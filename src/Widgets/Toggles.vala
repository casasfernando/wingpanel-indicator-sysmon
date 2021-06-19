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
    public class TogglesWidget : Gtk.Grid {
        private Gtk.Separator settings_separator;
        private Wingpanel.Widgets.Switch cpu_switch;
        private Wingpanel.Widgets.Switch cpu_temp_switch;
        private Wingpanel.Widgets.Switch ram_switch;
        private Wingpanel.Widgets.Switch network_switch;
        private Wingpanel.Widgets.Switch disk_switch;
        private Wingpanel.Widgets.Switch workspace_switch;
        private Wingpanel.Widgets.Switch icon_only_switch;
        private Wingpanel.Widgets.Switch indicator;
        public unowned Settings settings { get; construct set; }

        public TogglesWidget (Settings settings) {
            Object (settings: settings, hexpand: true);
        }

        construct {
            orientation = Gtk.Orientation.VERTICAL;

            icon_only_switch = new Wingpanel.Widgets.Switch ("Show indicator icon only", settings.get_boolean ("icon-only"));
            settings_separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            cpu_switch = new Wingpanel.Widgets.Switch ("CPU usage", settings.get_boolean ("show-cpu"));
            cpu_temp_switch = new Wingpanel.Widgets.Switch ("CPU temperature", settings.get_boolean ("show-cpu-temp"));
            ram_switch = new Wingpanel.Widgets.Switch ("RAM usage", settings.get_boolean ("show-ram"));
            network_switch = new Wingpanel.Widgets.Switch ("Network throughput", settings.get_boolean ("show-network"));
            disk_switch = new Wingpanel.Widgets.Switch ("Disk throughput", settings.get_boolean ("show-disk"));
            workspace_switch = new Wingpanel.Widgets.Switch ("Workspace number", settings.get_boolean ("show-workspace"));
            indicator = new Wingpanel.Widgets.Switch ("Show indicator", settings.get_boolean ("display-indicator"));

            settings.bind ("display-indicator", indicator.get_switch (), "active", SettingsBindFlags.DEFAULT);

            settings.bind ("icon-only", icon_only_switch.get_switch (), "active", SettingsBindFlags.DEFAULT);
            settings.bind ("show-cpu", cpu_switch.get_switch (), "active", SettingsBindFlags.DEFAULT);
            settings.bind ("show-cpu-temp", cpu_temp_switch.get_switch (), "active", SettingsBindFlags.DEFAULT);
            settings.bind ("show-ram", ram_switch.get_switch (), "active", SettingsBindFlags.DEFAULT);
            settings.bind ("show-network", network_switch.get_switch (), "active", SettingsBindFlags.DEFAULT);
            settings.bind ("show-disk", disk_switch.get_switch (), "active", SettingsBindFlags.DEFAULT);
            settings.bind ("show-workspace", workspace_switch.get_switch (), "active", SettingsBindFlags.DEFAULT);

            settings.bind ("icon-only", settings_separator, "visible", SettingsBindFlags.INVERT_BOOLEAN);
            settings.bind ("icon-only", cpu_switch, "visible", SettingsBindFlags.INVERT_BOOLEAN);
            settings.bind ("icon-only", cpu_temp_switch, "visible", SettingsBindFlags.INVERT_BOOLEAN);
            settings.bind ("icon-only", ram_switch, "visible", SettingsBindFlags.INVERT_BOOLEAN);
            settings.bind ("icon-only", network_switch, "visible", SettingsBindFlags.INVERT_BOOLEAN);
            settings.bind ("icon-only", disk_switch, "visible", SettingsBindFlags.INVERT_BOOLEAN);
            settings.bind ("icon-only", workspace_switch, "visible", SettingsBindFlags.INVERT_BOOLEAN);

            add (indicator);
            add (icon_only_switch);
            add (settings_separator);
            add (cpu_switch);
            add (cpu_temp_switch);
            add (ram_switch);
            add (network_switch);
            add (disk_switch);
            add (workspace_switch);

        }
    }
}
