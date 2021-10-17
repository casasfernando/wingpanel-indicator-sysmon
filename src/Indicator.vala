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
    public class Indicator : Wingpanel.Indicator {
        const string APPNAME = "wingpanel-indicator-sysmon";

        private DisplayWidget display_widget;
        private PopoverWidget popover_widget;

        private CPU cpu_data;
        private CPUTemperature cpu_temp_data;
        private Memory memory_data;
        private Network network_data;
        private Disk disk_data;
        private System system_data;
        private Gdk.X11.Screen screen;

        private static GLib.Settings settings;

        public int cpu_usage;
        public int cpu_temp;
        public int[] net_usage;
        public int[] disk_usage;

        public Indicator (Wingpanel.IndicatorManager.ServerType server_type) {
            Object (
                code_name: APPNAME,
                display_name: "Wingpanel System Monitor",
                description: "System monitor indicator for Wingpanel"
                );
        }

        construct {
            var provider = new Gtk.CssProvider ();
            provider.load_from_resource ("/com/github/casasfernando/wingpanel-indicator-sysmon/icons/Application.css");
            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (),
                provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );

            Gtk.IconTheme.get_default ().add_resource_path ("/com/github/casasfernando/wingpanel-indicator-sysmon/icons");
            cpu_data = new CPU ();
            cpu_temp_data = new CPUTemperature ();
            memory_data = new Memory ();
            network_data = new Network ();
            disk_data = new Disk ();
            system_data = new System ();
            screen = Gdk.Screen.get_default () as Gdk.X11.Screen;

            settings = new GLib.Settings ("com.github.casasfernando.wingpanel-indicator-sysmon");

            visible = settings.get_boolean ("display-indicator");

            settings.bind ("display-indicator", this, "visible", SettingsBindFlags.DEFAULT);
        }

        public override Gtk.Widget get_display_widget () {
            if (display_widget == null) {
                display_widget = new DisplayWidget (settings);
                update_display_widget_data ();
            }
            return display_widget;
        }

        public override Gtk.Widget ? get_widget () {
            if (popover_widget == null) {
                popover_widget = new PopoverWidget (settings);
            }

            return popover_widget;
        }

        public override void opened () {
        }

        public override void closed () {
        }

        private void update_display_widget_data () {
            if (display_widget != null) {
                Timeout.add_seconds (1, () => {
                    display_widget.update_icon ();
                    cpu_usage = cpu_data.percentage_used;
                    display_widget.update_cpu (cpu_usage);
                    cpu_temp = cpu_temp_data.cpu_temperature;
                    display_widget.update_cpu_temp (cpu_temp);
                    display_widget.update_memory (memory_data.percentage_used);
                    net_usage = network_data.get_bytes ();
                    display_widget.update_network (net_usage[0], net_usage[1]);
                    disk_usage = disk_data.get_bytes ();
                    display_widget.update_disk (disk_usage[0], disk_usage[1]);
                    display_widget.update_workspace ((int)screen.get_current_desktop () + 1);
                    update_popover_widget_data ();
                    return GLib.Source.CONTINUE;
                });
            }
        }

        private void update_popover_widget_data () {
            if (popover_widget == null) return;
            popover_widget.update_cpu (cpu_usage, cpu_data.frequency);
            popover_widget.update_cpu_temp (cpu_temp);
            popover_widget.update_ram (memory_data.used, memory_data.total);
            popover_widget.update_swap (memory_data.used_swap, memory_data.total_swap);
            popover_widget.update_uptime (system_data.uptime);
            popover_widget.update_load_average (system_data.loadavg);
            popover_widget.update_network (net_usage[0], net_usage[1]);
            popover_widget.update_disk (disk_usage[0], disk_usage[1]);
        }

    }
}
public Wingpanel.Indicator ? get_indicator (Module module, Wingpanel.IndicatorManager.ServerType server_type) {
    debug ("wingpanel-indicator-sysmon: loading system monitor indicator");

    if (server_type != Wingpanel.IndicatorManager.ServerType.SESSION) {
        debug ("wingpanel-indicator-sysmon: Wingpanel is not in session, not loading wingpanel-indicator-sysmon indicator");
        return null;
    }

    var indicator = new WingpanelSystemMonitor.Indicator (server_type);

    return indicator;
}
