/*-
 * Copyright (c) 2020 Tudor Plugaru (https://github.com/PlugaruT/wingpanel-monitor)
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
 */
namespace WingpanelSystemMonitor {
    public class Disk : GLib.Object {
        private int _bytes_write;
        private ulong _bytes_write_old;
        private bool control;

        private int _bytes_read;
        private ulong _bytes_read_old;

        public Disk () {
            _bytes_write = 0;
            _bytes_write_old = 0;
            _bytes_read = 0;
            _bytes_read_old = 0;
            control = false;
        }

        public int[] get_bytes () {
            if (control == false) {
                control = true;
                update_bytes_total ();
            } else {
                control = false;
            }
            int[] ret;
            ret = {_bytes_read, _bytes_write};
            return ret;
        }

        private void update_bytes_total () {

            ulong n_bytes_read = 0;
            ulong n_bytes_write = 0;

            try {
                string content = null;
                FileUtils.get_contents (@"/proc/diskstats", out content);
                InputStream input_stream = new MemoryInputStream.from_data (content.data, GLib.g_free);
                DataInputStream dis = new DataInputStream (input_stream);
                string line;

                while ((line = dis.read_line ()) != null) {
                    string[] reg_split = Regex.split_simple("[ ]+", line);
                    if ((reg_split[1] == "8" && Regex.match_simple ("sd[a-z]{1}$", reg_split[3])) || (reg_split[1] == "259" && Regex.match_simple ("nvme[0-9]n[0-9]{1}$", reg_split[3]))) {
                        n_bytes_read += ulong.parse(reg_split[6]);
                        n_bytes_write += ulong.parse(reg_split[10]);
                    }

                }
            } catch (Error e) {
                warning("Could not retrieve disk data");
            }

            _bytes_read = (int)((n_bytes_read - _bytes_read_old) * 512);
            _bytes_write = (int)((n_bytes_write - _bytes_write_old) * 512);
            _bytes_read_old = n_bytes_read;
            _bytes_write_old = n_bytes_write;
        }

    }
}

