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
    public class DisplayWidget : Gtk.Grid {
        private IndicatorWidget cpu_info;
        private IndicatorWidget cpu_temp_info;
        private IndicatorWidget ram_info;
        private IndicatorWidget workspace_info;
        private IndicatorWidget icon_only;
        private NetworkWidget network_info;
        private DiskWidget disk_info;

        public unowned Settings settings { get; construct set; }

        public DisplayWidget (Settings settings) {
            Object (settings: settings);
        }

        construct {
            valign = Gtk.Align.CENTER;


            cpu_info = new IndicatorWidget ("cpu-symbolic", 4);
            cpu_temp_info = new IndicatorWidget ("cpu-temperature-symbolic", 4);
            ram_info = new IndicatorWidget ("ram-symbolic", 4);
            network_info = new NetworkWidget ();
            disk_info = new DiskWidget ();
            workspace_info = new IndicatorWidget ("computer-symbolic", 2);
            icon_only = new IndicatorWidget ("indicator-symbolic", 0);
            icon_only.label_value = "";

            add (icon_only);
            add (cpu_info);
            add (cpu_temp_info);
            add (ram_info);
            add (network_info);
            add (disk_info);
            add (workspace_info);
        }

        public void set_widget_visible (Gtk.Widget widget, bool visible) {
            widget.no_show_all = !visible;
            widget.visible = visible;
        }

        public void update_icon () {
            if (settings.get_boolean ("icon-only")) {
                set_widget_visible (icon_only, true);
            } else {
                set_widget_visible (icon_only, false);
            }
        }

        public void update_cpu (int val) {
            if (settings.get_boolean ("icon-only") || !settings.get_boolean ("show-cpu")) {
                set_widget_visible (cpu_info, false);
            } else {
                set_widget_visible (cpu_info, true);
            }
            cpu_info.label_value = val.to_string () + "%";
        }

        public void update_cpu_temp (int val) {
            if (settings.get_boolean ("icon-only") || !settings.get_boolean ("show-cpu-temp")) {
                set_widget_visible (cpu_temp_info, false);
            } else {
                set_widget_visible (cpu_temp_info, true);
            }
            if (val == 777) {
                cpu_temp_info.label_value = "N/A";
            } else {
                cpu_temp_info.label_value = val.to_string () + "ºC";
            }
        }

        public void update_memory (int val) {
            if (settings.get_boolean ("icon-only") || !settings.get_boolean ("show-ram")) {
                set_widget_visible (ram_info, false);
            } else {
                set_widget_visible (ram_info, true);
            }
            ram_info.label_value = val.to_string () + "%";
        }

        public void update_network (int upload, int download) {
            if (settings.get_boolean ("icon-only") || !settings.get_boolean ("show-network")) {
                set_widget_visible (network_info, false);
            } else {
                set_widget_visible (network_info, true);
            }
            string up = WingpanelSystemMonitor.Utils.format_net_speed (upload, true, false);
            string down = WingpanelSystemMonitor.Utils.format_net_speed (download, true, false);
            network_info.update_label_data (up, down);
        }

        public void update_disk (int read, int write) {
            if (settings.get_boolean ("icon-only") || !settings.get_boolean ("show-disk")) {
                set_widget_visible (disk_info, false);
            } else {
                set_widget_visible (disk_info, true);
            }
            string read_s = WingpanelSystemMonitor.Utils.format_net_speed (read, true, false);
            string write_s = WingpanelSystemMonitor.Utils.format_net_speed (write, true, false);
            disk_info.update_label_data (read_s, write_s);
        }

        public void update_workspace (int val) {
            if (settings.get_boolean ("icon-only") || !settings.get_boolean ("show-workspace")) {
                set_widget_visible (workspace_info, false);
            } else {
                set_widget_visible (workspace_info, true);
            }
            workspace_info.label_value = val.to_string ();
        }

    }
}
