/*-
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
 * Authored by: Fernando Casas Schössow <casasfernando@outlook.com>
 */

namespace WingpanelSystemMonitor {
    public class CPUTemperature : GLib.Object {

        private int _cpu_temp;

        public CPUTemperature () {
        }

        construct {
        }

        public int cpu_temperature {
            get { update_cpu_temp (); return _cpu_temp; }
        }

        private void update_cpu_temp () {
            _cpu_temp = 777;
            uint8 hwmon_idx = 0;
            uint8 core_idx = 1;
            bool hwmon_walk = true;
            bool cpu_walk = true;

            // Walkthrough each hwmon interface looking for a CPU temperature sensor
            while (hwmon_walk) {
                string hwmon_if_path = "/sys/class/hwmon/hwmon".concat (hwmon_idx.to_string (), "/name");
                if (!FileUtils.test (hwmon_if_path, FileUtils.EXISTS)) {
                    hwmon_walk = false;
                    continue;
                }

                string hwmon_if_name = "";
                try {
                    FileUtils.get_contents (hwmon_if_path, out hwmon_if_name);
                    hwmon_if_name = hwmon_if_name.replace ("\n","");
                    // Check if the interface is a CPU temperature sensor
                    // Intel: coretemp
                    // AMD: k10temp
                    if (hwmon_if_name != "coretemp" && hwmon_if_name != "k10temp") {
                        hwmon_idx++;
                        continue;
                    }

                    // Walkthrough each CPU temperature sensor looking for the CPU package temperature sensor
                    while (cpu_walk) {
                        string cpu_temp_sensor_label_path = "/sys/class/hwmon/hwmon".concat (hwmon_idx.to_string (), "/temp", core_idx.to_string (), "_label");
                        string cpu_temp_sensor_value_path = "/sys/class/hwmon/hwmon".concat (hwmon_idx.to_string (), "/temp", core_idx.to_string (), "_input");
                        if (!FileUtils.test (cpu_temp_sensor_label_path, FileUtils.EXISTS) || !FileUtils.test (cpu_temp_sensor_value_path, FileUtils.EXISTS)) {
                            cpu_walk = false;
                            continue;
                        }
                        // Get CPU temperature sensor label
                        string cpu_temp_sensor_label = "";
                        FileUtils.get_contents (cpu_temp_sensor_label_path, out cpu_temp_sensor_label);
                        cpu_temp_sensor_label = cpu_temp_sensor_label.replace ("\n","");
                        // Check if the CPU temperature sensor is for the CPU package or a CPU core
                        if (!cpu_temp_sensor_label.contains ("Package") && !cpu_temp_sensor_label.contains ("Tdie")) {
                            core_idx++;
                            continue;
                        }
                        // Get CPU package temperature sensor value
                        string cpu_temp_sensor_value = "";
                        FileUtils.get_contents (cpu_temp_sensor_value_path, out cpu_temp_sensor_value);
                        _cpu_temp = (int) double.parse (cpu_temp_sensor_value) / 1000;
                        cpu_walk = false;
                    }
                } catch (FileError e) {
                    warning ("wingpanel-indicator-sysmon: can't open temperature sensor file. CPU temperature value not available");
                }

                hwmon_idx++;
            }

        }

    }
}
