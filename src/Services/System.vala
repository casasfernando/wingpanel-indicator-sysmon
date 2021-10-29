/*-
 * Copyright (c) 2020 Tudor Plugaru (https://github.com/PlugaruT/wingpanel-monitor)
 * Copyright (c) 2021 Fernando Casas Schössow (https://github.com/casasfernando/wingpanel-indicator-sysmon)
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
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA.
 *
 * Authored by: Tudor Plugaru <plugaru.tudor@gmail.com>
 *              Fernando Casas Schössow <casasfernando@outlook.com>
 */

namespace WingpanelSystemMonitor {
    public class System : GLib.Object {
        private string _uptime;
        private string _loadavg;

        public string loadavg {
            get { update_loadavg (); return _loadavg; }
        }

        public string uptime {
            get { update_uptime (); return _uptime; }
        }

        public System () {
        }

        construct { }

        private void update_loadavg () {
            GTop.LoadAvg loadavg;
            GTop.get_loadavg (out loadavg);

            _loadavg = "%.2f, %.2f, %.2f".printf (loadavg.loadavg[0], loadavg.loadavg[1], loadavg.loadavg[2]);
        }

        private void update_uptime () {
            GTop.Uptime uptime;
            GTop.get_uptime (out uptime);

            int upsec = (int)uptime.uptime;
            int days = upsec / (24 * 3600);

            if (days > 0) {
                upsec = upsec % (24 * 3600);
                _uptime = days.to_string ().concat (_(" days, "), Granite.DateTime.seconds_to_time (upsec));
            } else {
                _uptime = Granite.DateTime.seconds_to_time ((int)uptime.uptime);
            }
        }

    }
}
