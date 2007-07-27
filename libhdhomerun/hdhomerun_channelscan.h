/*
 * hdhomerun_channelscan.h
 *
 * Copyright © 2006 Silicondust Engineering Ltd. <www.silicondust.com>.
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

struct channelscan_entry_t;

#define HDHOMERUN_CHANNELSCAN_MODE_SCAN 0
#define HDHOMERUN_CHANNELSCAN_MODE_CHANNELLIST 1

typedef int (*channelscan_callback_t)(va_list ap, const char *type, const char *str);

extern int channelscan_execute_single(struct hdhomerun_device_t *hd, int mode, struct channelscan_entry_t **pentry, channelscan_callback_t callback, ...);
extern int channelscan_execute_all(struct hdhomerun_device_t *hd, int mode, channelscan_callback_t callback, ...);
