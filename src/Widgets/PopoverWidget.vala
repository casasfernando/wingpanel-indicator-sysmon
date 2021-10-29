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
    public class PopoverWidget : Gtk.Grid {
        private PopoverWidgetRow cpu;
        private PopoverWidgetRow cpu_temp;
        private PopoverWidgetRow ram;
        private PopoverWidgetRow swap;
        private PopoverWidgetRow uptime;
        private PopoverWidgetRow load_avg;
        private PopoverWidgetRow network_down;
        private PopoverWidgetRow network_up;
        private PopoverWidgetRow disk_read;
        private PopoverWidgetRow disk_write;


        public unowned Settings settings { get; construct set; }

        public PopoverWidget (Settings settings) {
            Object (settings: settings);
        }

        construct {
            orientation = Gtk.Orientation.VERTICAL;
            column_spacing = 4;

            cpu = new PopoverWidgetRow ("CPU", "0", 4);
            cpu_temp = new PopoverWidgetRow (_("CPU Temperature"), "0", 4);
            ram = new PopoverWidgetRow ("RAM", "0", 4);
            swap = new PopoverWidgetRow (_("Swap"), "0", 4);
            uptime = new PopoverWidgetRow (_("Uptime"), "0", 4);
            load_avg = new PopoverWidgetRow (_("Load Average"), "0", 4);
            network_up = new PopoverWidgetRow (_("Network Up"), "0", 4);
            network_down = new PopoverWidgetRow (_("Network Down"), "0", 4);
            disk_read = new PopoverWidgetRow (_("Disk Read"), "0", 4);
            disk_write = new PopoverWidgetRow (_("Disk Write"), "0", 4);

            var settings_button = new Gtk.ModelButton ();
            settings_button.text = _("Open Settings...");
            settings_button.clicked.connect (open_settings);


            add (cpu);
            add (cpu_temp);
            add (ram);
            add (swap);
            add (uptime);
            add (load_avg);
            add (network_up);
            add (network_down);
            add (disk_read);
            add (disk_write);
            add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
            add (settings_button);
        }

        private void open_settings () {
            try {
                var appinfo = AppInfo.create_from_commandline (
                    "com.github.casasfernando.wingpanel-indicator-sysmon", null, AppInfoCreateFlags.NONE
                    );
                appinfo.launch (null, null);
            } catch (Error e) {
                warning ("%s\n", e.message);
            }
        }

        public void update_cpu (int cpuper, double cpufreq) {
            string cpuf = "";
            if (cpufreq > 0) {
                cpuf = Utils.format_frequency (cpufreq);
            } else {
                cpuf = _("N/A");
            }
            cpu.label_value = "%s / %s".printf(cpuper.to_string () + "%", cpuf);
        }

        public void update_cpu_temp (int cputemp) {
            if (cputemp == 777) {
                cpu_temp.label_value = _("N/A");
            } else {
                cpu_temp.label_value = cputemp.to_string ().concat ("ºC");
            }
        }

        public void update_ram (double used_ram, double total_ram) {
            var used = Utils.format_size (used_ram);
            var total = Utils.format_size (total_ram);
            ram.label_value = "%s / %s".printf (used, total);
        }

        public void update_swap (double used_swap, double total_swap) {
            var used = Utils.format_size (used_swap);
            var total = Utils.format_size (total_swap);
            swap.label_value = "%s / %s".printf (used, total);
        }

        public void update_uptime (string val) {
            uptime.label_value = val;
        }

        public void update_load_average (string val) {
            load_avg.label_value = val;
        }

        public void update_network (int upload, int download) {
            network_down.label_value = Utils.format_net_speed (download, true, false);
            network_up.label_value = Utils.format_net_speed (upload, true, false);
        }

        public void update_disk (int read, int write) {
            disk_read.label_value = Utils.format_net_speed (read, true, false);
            disk_write.label_value = Utils.format_net_speed (write, true, false);
        }
    }
}
