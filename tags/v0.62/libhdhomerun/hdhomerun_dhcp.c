/*
 * hdhomerun_dhcp.c
 *
 * Copyright © 2006-2007 Silicondust Engineering Ltd. <www.silicondust.com>.
 *
 * This library is free software; you can redistribute it and/or 
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "hdhomerun_os.h"
#include "hdhomerun_pkt.h"
#include "hdhomerun_dhcp.h"

struct dhcp_pkt_t {
	uint8_t bootp_message_type;
	uint8_t hardware_type;
	uint8_t hardware_address_length;
	uint8_t hops;
	uint32_t transaction_id;
	uint16_t seconds_elapsed;
	uint16_t bootp_flags;
	uint32_t client_ip;
	uint32_t your_ip;
	uint32_t next_server_ip;
	uint32_t relay_agent_ip;
	uint8_t client_mac[16];
	uint8_t server_host_name[64];
	uint8_t boot_file_name[128];
	uint32_t magic_cookie;
};

/*struct hdhomerun_dhcp_t {
	struct hdhomerun_dhcp_interface_t *intf_list;
	int sock;
	pthread_t thread;
	volatile bool_t terminate;
};*/

static THREAD_FUNC_PREFIX hdhomerun_dhcp_thread_execute(void *arg);

struct hdhomerun_dhcp_t *hdhomerun_dhcp_create(void)
{
	struct hdhomerun_dhcp_t *dhcp = (struct hdhomerun_dhcp_t *)calloc(1, sizeof(struct hdhomerun_dhcp_t));
	if (!dhcp) {
		return NULL;
	}

	if (pthread_create(&dhcp->thread, NULL, &hdhomerun_dhcp_thread_execute, dhcp) != 0) {
		free(dhcp);
		return NULL;
	}

	return dhcp;
}

void hdhomerun_dhcp_destroy(struct hdhomerun_dhcp_t *dhcp)
{
	dhcp->terminate = TRUE;
	pthread_join(dhcp->thread, NULL);

	if (dhcp->sock != -1) {
		close(dhcp->sock);
	}

	free(dhcp);
}

static bool_t hdhomerun_dhcp_create_sock(struct hdhomerun_dhcp_t *dhcp)
{
	/* Create socket. */
	int sock = (int)socket(AF_INET, SOCK_DGRAM, 0);
	if (sock == -1) {
		return FALSE;
	}

	/* Set timeout. */
	setsocktimeout(sock, SOL_SOCKET, SO_RCVTIMEO, 1000);

	/* Allow broadcast. */
	int sock_opt = 1;
	setsockopt(sock, SOL_SOCKET, SO_BROADCAST, (char *)&sock_opt, sizeof(sock_opt));

	/* Bind socket. */
	struct sockaddr_in sock_addr;
	memset(&sock_addr, 0, sizeof(sock_addr));
	sock_addr.sin_family = AF_INET;
	sock_addr.sin_addr.s_addr = htonl(INADDR_ANY);
	sock_addr.sin_port = htons(67);
	if (bind(sock, (struct sockaddr *)&sock_addr, sizeof(sock_addr)) != 0) {
		close(sock);
		return FALSE;
	}

	dhcp->sock = sock;
	return TRUE;
}

static void hdhomerun_dhcp_send(struct hdhomerun_dhcp_t *dhcp, uint8_t message_type, uint8_t *buffer)
{
	struct dhcp_pkt_t *pkt = (struct dhcp_pkt_t *)buffer;

	uint32_t remote_addr = 0xA9FE0000;
	remote_addr |= (uint32_t)pkt->client_mac[4] << 8;
	remote_addr |= (uint32_t)pkt->client_mac[5] << 0;

	pkt->bootp_message_type = 0x02;
	pkt->your_ip = htonl(remote_addr);
	pkt->next_server_ip = htonl(0xA9FEFFFF);

	uint8_t *ptr = buffer + sizeof(struct dhcp_pkt_t);

	hdhomerun_write_u8(&ptr, 53);
	hdhomerun_write_u8(&ptr, 1);
	hdhomerun_write_u8(&ptr, message_type);

	hdhomerun_write_u8(&ptr, 54);
	hdhomerun_write_u8(&ptr, 4);
	hdhomerun_write_u32(&ptr, 0xA9FEFFFF);

	hdhomerun_write_u8(&ptr, 51);
	hdhomerun_write_u8(&ptr, 4);
	hdhomerun_write_u32(&ptr, 7*24*60*60);

	hdhomerun_write_u8(&ptr, 1);
	hdhomerun_write_u8(&ptr, 4);
	hdhomerun_write_u32(&ptr, 0xFFFF0000);

	hdhomerun_write_u8(&ptr, 0xFF);

	while (ptr < buffer + 300) {
		hdhomerun_write_u8(&ptr, 0x00);
	}

	struct sockaddr_in sock_addr;
	memset(&sock_addr, 0, sizeof(sock_addr));
	sock_addr.sin_family = AF_INET;
	sock_addr.sin_addr.s_addr = htonl(0xFFFFFFFF);
	sock_addr.sin_port = htons(68);

	sendto(dhcp->sock, (char *)buffer, (int)(ptr - buffer), 0, (struct sockaddr *)&sock_addr, sizeof(sock_addr));
}

static void hdhomerun_dhcp_recv(struct hdhomerun_dhcp_t *dhcp, uint8_t *buffer, uint8_t *end)
{
	uint8_t *ptr = buffer + sizeof(struct dhcp_pkt_t);
	if (ptr > end) {
		return;
	}

	struct dhcp_pkt_t *pkt = (struct dhcp_pkt_t *)buffer;
	if (ntohl(pkt->magic_cookie) != 0x63825363) {
		return;
	}

	static uint8_t vendor[3] = {0x00, 0x18, 0xDD};
	if (memcmp(pkt->client_mac, vendor, 3) != 0) {
		return;
	}

	if (ptr + 3 > end) {
		return;
	}
	if (hdhomerun_read_u8(&ptr) != 53) {
		return;
	}
	if (hdhomerun_read_u8(&ptr) != 1) {
		return;
	}
	uint8_t message_type_val = hdhomerun_read_u8(&ptr);

	switch (message_type_val) {
	case 0x01:
		hdhomerun_dhcp_send(dhcp, 0x02, buffer);
		break;
	case 0x03:
		hdhomerun_dhcp_send(dhcp, 0x05, buffer);
		break;
	default:
		return;
	}
}

static THREAD_FUNC_PREFIX hdhomerun_dhcp_thread_execute(void *arg)
{
	struct hdhomerun_dhcp_t *dhcp = (struct hdhomerun_dhcp_t *)arg;

	while (1) {
		if (dhcp->terminate) {
			return NULL;
		}

		if (dhcp->sock == -1) {
			if (!hdhomerun_dhcp_create_sock(dhcp)) {
				sleep(1);
				continue;
			}
		}

		uint8_t buffer[1460];
		int length = recv(dhcp->sock, (char *)buffer, sizeof(buffer), 0);
		if (length <= 0) {
			if (sock_getlasterror_socktimeout) {
				continue;
			}
			close(dhcp->sock);
			dhcp->sock = -1;
			continue;
		}

		hdhomerun_dhcp_recv(dhcp, buffer, buffer + length);
	}
}
