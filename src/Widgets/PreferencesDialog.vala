namespace Licenses {

    public class PreferencesDialog : Gtk.Dialog {

        private GLib.Settings settings = new GLib.Settings ("com.github.eetagent.Licenses");

        public PreferencesDialog (Licenses.Window window) {
            /**
             * Connect preferences dialog to the main window
             */

            set_title ("Preferences");
            set_transient_for (window);
            set_modal (true);
            set_resizable (false);
            set_deletable (false);

            var main_grid = new Gtk.Grid ();

            main_grid.set_row_spacing (15);
            main_grid.set_column_spacing (15);

            /**
             *  Create text input fields
             */

            var year_entry = new Gtk.Entry ();
            year_entry.set_text (settings.get_string ("year"));
            var fullname_entry = new Gtk.Entry ();
            fullname_entry.set_text (settings.get_string ("fullname"));
            var email_entry = new Gtk.Entry ();
            email_entry.set_text (settings.get_string ("email"));

            /**
             *  Create input description
             */

            var year_label = new Gtk.Label ("Set year: ");
            year_label.halign = Gtk.Align.START;
            var fullname_label = new Gtk.Label ("Set your fullname: ");
            fullname_label.halign = Gtk.Align.START;
            var email_label = new Gtk.Label ("Set your e-mail: ");
            email_label.halign = Gtk.Align.START;

            var close_button = new Gtk.Button.with_label ("Close");
            close_button.set_margin_end (5);
            close_button.clicked.connect ( () => {
                this.destroy ();
            });

            var save_button = new Gtk.Button.with_label ("Save");
            save_button.add_css_class ("suggested-action");
            save_button.clicked.connect ( () => {
                if (year_entry.get_text () == "") {
                    settings.set_string ("year", "[year]");
                } else {
                    settings.set_string ("year", year_entry.get_text ());
                }
                if (fullname_entry.get_text () == "") {
                    settings.set_string ("fullname", "[fullname]");
                } else {
                    settings.set_string ("fullname", fullname_entry.get_text ());
                }
                if (email_entry.get_text () == "") {
                    settings.set_string ("email", "[e-mail]");
                } else {
                    settings.set_string ("email", email_entry.get_text ());
                }
                this.destroy ();
            });

            close_button.set_margin_top (10);
            save_button.set_margin_top (10);

            main_grid.attach (year_label, 1, 0, 1, 1);
            main_grid.attach (year_entry, 2, 1, 3, 1);
            main_grid.attach (fullname_label, 1, 2, 1, 1);
            main_grid.attach (fullname_entry, 2, 3, 3, 1);
            main_grid.attach (email_label, 1, 4, 1, 1);
            main_grid.attach (email_entry, 2, 5, 3, 1);

            main_grid.attach (close_button, 3, 6, 1, 1);
            main_grid.attach (save_button, 4, 6, 1, 1);

            main_grid.set_margin_top (30);
            main_grid.set_margin_start (30);
            main_grid.set_margin_end (30);
            main_grid.set_margin_bottom (30);

            set_child (main_grid);
        }
    }
}
