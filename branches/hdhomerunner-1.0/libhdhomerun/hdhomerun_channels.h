/*
 * hdhomerun_channels.h
 *
 * Copyright � 2007 Silicondust Engineering Ltd. <www.silicondust.com>.
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

#define CHANNEL_MAP_US_BCAST (1 << 0)
#define CHANNEL_MAP_US_CABLE (1 << 1)
#define CHANNEL_MAP_US_HRC (1 << 2)
#define CHANNEL_MAP_US_IRC (1 << 3)

#define CHANNEL_MAP_US_ALL (CHANNEL_MAP_US_BCAST | CHANNEL_MAP_US_CABLE | CHANNEL_MAP_US_HRC | CHANNEL_MAP_US_IRC)

struct hdhomerun_channel_entry_t {
	struct hdhomerun_channel_entry_t *next;
	uint32_t channel_map;
	uint8_t channel_number;
	uint32_t frequency;
};

extern void hdhomerun_channel_name(char *buffer, char *limit, struct hdhomerun_channel_entry_t *entry);

extern struct hdhomerun_channel_entry_t *hdhomerun_channel_list_first(uint32_t channel_map);
extern struct hdhomerun_channel_entry_t *hdhomerun_channel_list_next(uint32_t channel_map, struct hdhomerun_channel_entry_t *entry);

extern uint32_t hdhomerun_channel_number_to_frequency(uint32_t channel_map, uint8_t channel_number);
extern uint8_t hdhomerun_channel_frequency_to_number(uint32_t channel_map, uint32_t frequency);
