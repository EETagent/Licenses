namespace Licenses {

    public class Window : Gtk.ApplicationWindow {

        private GLib.Settings settings = new GLib.Settings ("com.github.eetagent.Licenses");

        private Licenses.License license;

        private Gdk.Clipboard clipboard;

        private Gtk.Stack main_stack;

        private Licenses.TextView last_text_view;

        private bool faq_bool = false;

        public Window (Gtk.Application app) {
            Object (application: app);
        }

        construct {

            /**
             * Load window size from Gschema
             */

            this.set_default_size (this.settings.get_int ("window-width"), this.settings.get_int ("window-height"));

            /**
             * Import Gtk.Settings for dark mode functionality
             */

            var gtk_settings = Gtk.Settings.get_default ();


            /**
             * Clipboard initialization
             */

            this.clipboard = this.get_display ().get_clipboard ();

            /**
             * Create new instance of license object
             */

            this.license = new Licenses.License ();

            /**
             * HeaderBar START
             */

            var titlebar = new Gtk.HeaderBar ();

            /**
             * Create title and subtitle
             */

            var titlebar_title_widget = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            titlebar_title_widget.set_valign (Gtk.Align.CENTER);
            var title_label = new Gtk.Label ("Licenses");
            title_label.add_css_class ("title");
            var subtitle_label = new Gtk.Label ("Choose and copy your favourite FOSS license");
            subtitle_label.add_css_class ("subtitle");

            titlebar_title_widget.append (title_label);
            titlebar_title_widget.append (subtitle_label);

            titlebar.set_title_widget (titlebar_title_widget);

            /**
             * Create copy and FAQ buttons
             */

            var copy_button = new Gtk.Button.from_icon_name ("edit-copy-symbolic");
            var faq_button = new Gtk.Button.from_icon_name ("help-faq-symbolic");
            var menu_button = new Gtk.MenuButton ();
            menu_button.set_icon_name ("open-menu-symbolic");
            var menu_model = new GLib.Menu ();
            menu_model.append ("Preferences", "app.preferences");
            menu_model.append ("About Licenses", "app.about");
            menu_model.append ("Quit", "app.quit");
            menu_button.set_menu_model (menu_model);


            /**
             * Create dark mode switch
             */

            var mode_switch = new Granite.ModeSwitch.from_icon_name ("display-brightness-symbolic", "weather-clear-night-symbolic");
            mode_switch.primary_icon_tooltip_text = "Light background";
            mode_switch.secondary_icon_tooltip_text = "Dark background";
            mode_switch.bind_property ("active", gtk_settings, "gtk_application_prefer_dark_theme");
            settings.bind ("dark-theme", mode_switch, "active", GLib.SettingsBindFlags.GET_NO_CHANGES);

            titlebar.pack_start (copy_button);
            titlebar.pack_start (faq_button);
            titlebar.pack_end (menu_button);

            titlebar.pack_end (mode_switch);

            this.set_titlebar (titlebar);

            /**
             * HeaderBar END
             */

            /**
             * SideBar and TextView START
             */

            var main_stack = new Gtk.Stack ();

            foreach (string license in Licenses.LICENSES) {


                this.license.get_license (license);

                var license_text_view = new Licenses.TextView (this.license.license_text);

                var license_scrolled_window = new Gtk.ScrolledWindow ();
                license_scrolled_window.set_child (license_text_view);
                license_scrolled_window.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);

                main_stack.add_titled (license_scrolled_window, license, license);
            }

            /**
             * Reset object back to the first license in array
             */
            license.reset ();

            var stack_sidebar = new Gtk.StackSidebar ();
            stack_sidebar.stack = main_stack;

            var paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
            paned.set_start_child (stack_sidebar);
            paned.set_end_child (main_stack);
            paned.set_position (135);

            this.main_stack = main_stack;

            set_child (paned);

            /**
             * SideBar and TextView END
             */

            /**
             *  Connect START
             */
            main_stack.notify["visible-child-name"].connect (stack_item_clicked);
            copy_button.clicked.connect (copy_button_clicked);
            faq_button.clicked.connect (faq_button_clicked);
            close_request.connect (before_window_close);

            /**
             *  Connect END
             */
        }

        /**
         *  Launches when the window is closed
         */

        public bool before_window_close () {
            int width, height;
            get_default_size (out width, out height);
            settings.set_int ("window-width", width);
            settings.set_int ("window-height", height);
            return false;
        }

        /**
         *  Launches when the ListBoxRow is clicked
         */

        private void stack_item_clicked (GLib.Object sender, GLib.ParamSpec property) {

            if (this.faq_bool == true) {
                this.last_text_view.set_text (license.license_text);
                this.faq_bool = false;
            }

            string visible_child_name = main_stack.get_visible_child_name ();

            this.license.get_license (visible_child_name);
        }

        /**
         * Launches when the copy button is clicked
         */

        private void copy_button_clicked () {
            this.clipboard.set_text (this.license.license_text);
        }

        /**
         * Launches when the FAQ button is clicked
         */

        private void faq_button_clicked () {

            /**
             * Get text of the currently opened TextView
             */

            var scrolled_window = main_stack.get_visible_child ();
            var text_view = ((Gtk.ScrolledWindow)scrolled_window).get_child ();
            this.last_text_view = ((Licenses.TextView)text_view);
            if (this.faq_bool == false) {
                this.last_text_view.set_text (license.license_faq);
                this.faq_bool = true;
            } else {
                this.last_text_view.set_text (license.license_text);
                this.faq_bool = false;
            }
        }

        /**
         * Launches when the app.copy is activated
         */

        public void copy_action () {
            this.copy_button_clicked ();
        }
    }
}
