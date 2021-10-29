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
    public class DiskWidget : Gtk.Grid {
        private Gtk.Revealer widget_revealer;
        private Gtk.Label read_label;
        private Gtk.Label write_label;

        public bool display {
            set { widget_revealer.reveal_child = value; }
            get { return widget_revealer.get_reveal_child () ; }
        }

        construct {
            orientation = Gtk.Orientation.HORIZONTAL;

            // Define widget icons and sizes
            // Disk icon
            var icon = new Gtk.Image.from_icon_name ("disk-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            // Read icon
            var icon_read = new Gtk.Image.from_icon_name ("upload-read-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            icon_read.set_pixel_size (10);
            // Write icon
            var icon_write = new Gtk.Image.from_icon_name ("download-write-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            icon_write.set_pixel_size (10);

            // Define read value label
            read_label = new Gtk.Label (_("N/A"));
            read_label.set_width_chars (8);
            read_label.set_xalign (1);
            read_label.set_yalign (1);
            var read_label_context = read_label.get_style_context ();
            read_label_context.add_class ("small-label");
            read_label_context.add_class ("upload-read-download-write");

            // Define download value label
            write_label = new Gtk.Label (_("N/A"));
            write_label.set_width_chars (8);
            write_label.set_xalign (1);
            write_label.set_yalign (0);
            var write_label_context = write_label.get_style_context ();
            write_label_context.add_class ("small-label");
            write_label_context.add_class ("upload-read-download-write");

            // Define widget packaging grid
            var group = new Gtk.Grid ();
            group.set_column_spacing (0);
            group.set_row_spacing (0);
            group.set_row_homogeneous (true);
            // Add disk icon
            group.attach (icon, 0, 0, 1, 2);
            // Add read icon
            group.attach (icon_read, 1, 0, 1, 1);
            // Add write icon
            group.attach_next_to (icon_write, icon_read, Gtk.PositionType.BOTTOM, 1, 1);
            // Add read value label
            group.attach (read_label, 2, 0, 1, 1);
            // Add write value label
            group.attach_next_to (write_label, read_label, Gtk.PositionType.BOTTOM, 1, 1);

            widget_revealer = new Gtk.Revealer ();
            widget_revealer.transition_type = Gtk.RevealerTransitionType.SLIDE_RIGHT;
            widget_revealer.reveal_child = true;

            widget_revealer.add (group);

            add (widget_revealer);
        }

        public void update_label_data (string read_speed, string write_speed) {
            read_label.label = read_speed;
            write_label.label = write_speed;
        }
    }
}

