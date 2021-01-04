namespace Licences {

    public class Application : Gtk.Application {

        public const GLib.ActionEntry[] ACTION_ENTRIES = {
            { "copy", copy_activated },
            { "quit", quit_activated },
            { "preferences", preferences_activated },
            { "about", about_activated }
        };

        public Application () {
            Object (application_id: "com.github.eetagent.Licenses",
                    flags : ApplicationFlags.FLAGS_NONE);
        }

        protected override void activate () {
            var window = this.active_window;
            if (window == null) {
                window = new Licenses.Window (this);
            }
            window.present ();
        }

        protected override void startup () {
            add_action_entries (ACTION_ENTRIES, this);
            set_accels_for_action ("app.quit", { "<Ctrl>Q", "<Super>Q" });
            set_accels_for_action ("app.copy", { "<Ctrl>C", "<Super>C" });
            set_accels_for_action ("app.preferences", { "<Ctrl>comma", "<Super>comma" });
            set_accels_for_action ("app.about", { "<Ctrl>I", "<Super>I" });

            base.startup ();
        }

        void quit_activated (SimpleAction action, Variant ? variant) {
            this.quit ();
        }

        void copy_activated (SimpleAction action, Variant ? variant) {
            ((Licenses.Window)this.active_window).copy_action ();
        }

        void preferences_activated (SimpleAction action, Variant ? variant) {
            var dialog = new Licenses.PreferencesDialog ((Licenses.Window) this.active_window);
            dialog.show ();
        }

        void about_activated (SimpleAction action, Variant ? variant) {
            Gtk.show_about_dialog (this.active_window,
                                   "program-name", ("Licenses"),
                                   "version", "0.9.0",
                                   "comments", "Simple Vala learning project. An application that displays a list of FOSS licenses",
                                   "logo-icon-name", "com.github.eetagent.Licenses",
                                   "license_type", Gtk.License.GPL_3_0,
                                   "website", "https://github.com/EETagent/Licenses",
                                   "website-label", ("GitHub Page"),
                                   null);
        }

        public static int main (string[] args) {
            var app = new Licences.Application ();
            return app.run (args);
        }
    }
}
