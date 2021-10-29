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
    public class NetworkWidget : Gtk.Grid {
        private Gtk.Revealer widget_revealer;
        private Gtk.Label upload_label;
        private Gtk.Label download_label;

        public bool display {
            set { widget_revealer.reveal_child = value; }
            get { return widget_revealer.get_reveal_child () ; }
        }

        construct {
            orientation = Gtk.Orientation.HORIZONTAL;

            // Define widget icons and sizes
            // Network icon
            var icon = new Gtk.Image.from_icon_name ("net-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            // Upload icon
            var icon_up = new Gtk.Image.from_icon_name ("upload-read-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            icon_up.set_pixel_size (10);
            // Download icon
            var icon_down = new Gtk.Image.from_icon_name ("download-write-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            icon_down.set_pixel_size (10);

            // Define upload value label
            upload_label = new Gtk.Label (_("N/A"));
            upload_label.set_width_chars (8);
            upload_label.set_xalign (1);
            upload_label.set_yalign (1);
            var upload_label_context = upload_label.get_style_context ();
            upload_label_context.add_class ("small-label");
            upload_label_context.add_class ("upload-read-download-write");

            // Define download value label
            download_label = new Gtk.Label (_("N/A"));
            download_label.set_width_chars (8);
            download_label.set_xalign (1);
            download_label.set_yalign (0);
            var down_label_context = download_label.get_style_context ();
            down_label_context.add_class ("small-label");
            down_label_context.add_class ("upload-read-download-write");

            // Define widget packaging grid
            var group = new Gtk.Grid ();
            group.set_column_spacing (0);
            group.set_row_spacing (0);
            group.set_row_homogeneous (true);
            // Add network icon
            group.attach (icon, 0, 0, 1, 2);
            // Add upload icon
            group.attach (icon_up, 1, 0, 1, 1);
            // Add download icon
            group.attach_next_to (icon_down, icon_up, Gtk.PositionType.BOTTOM, 1, 1);
            // Add upload value label
            group.attach (upload_label, 2, 0, 1, 1);
            // Add download value label
            group.attach_next_to (download_label, upload_label, Gtk.PositionType.BOTTOM, 1, 1);

            widget_revealer = new Gtk.Revealer ();
            widget_revealer.transition_type = Gtk.RevealerTransitionType.SLIDE_RIGHT;
            widget_revealer.reveal_child = true;

            widget_revealer.add (group);

            add (widget_revealer);
        }

        public void update_label_data (string up_speed, string down_speed) {
            upload_label.label = up_speed;
            download_label.label = down_speed;
        }
    }
}
