namespace Licenses {

    public class Window : Gtk.ApplicationWindow {

        private GLib.Settings saved_settings = new GLib.Settings ("com.github.eetagent.Licenses");

        private Licenses.License license;

        private Gdk.Clipboard clipboard;

        private Granite.ModeSwitch mode_switch;

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

            this.set_default_size (this.saved_settings.get_int ("window-width"), this.saved_settings.get_int ("window-height"));

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

            var copy_button = new Gtk.Button.from_icon_name ("edit-copy-symbolic");
            var faq_button = new Gtk.Button.from_icon_name ("help-faq-symbolic");

            var mode_switch = new Granite.ModeSwitch.from_icon_name ("display-brightness-symbolic", "weather-clear-night-symbolic");
            mode_switch.primary_icon_tooltip_text = "Light background";
            mode_switch.secondary_icon_tooltip_text = "Dark background";
            mode_switch.bind_property ("active", gtk_settings, "gtk_application_prefer_dark_theme");
            mode_switch.active = this.saved_settings.get_boolean("dark-theme");
            this.mode_switch = mode_switch;

            titlebar.pack_start (copy_button);
            titlebar.pack_start (faq_button);

            titlebar.pack_end (mode_switch);
            
            this.set_titlebar (titlebar);
            this.set_title ("Licenses");

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
             *  Signals START
             */
            main_stack.notify["visible-child-name"].connect (stack_item_clicked);
            copy_button.clicked.connect (copy_button_clicked);
            faq_button.clicked.connect (faq_button_clicked);
            close_request.connect(before_window_close);

            /**
             *  Signals END
             */
        }

        /**
         *  Launches when the window is closed
         */

        public bool before_window_close() {
            int width, height;
            bool dark_mode = mode_switch.active;
            get_default_size(out width, out height);
            saved_settings.set_int("window-width", width);
            saved_settings.set_int("window-height", height);
            saved_settings.set_boolean("dark-theme", dark_mode);
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
             * Get text of currently opened TextView
             */

            var scrolled_window = main_stack.get_visible_child ();
            var text_view = ( (Gtk.ScrolledWindow)scrolled_window).get_child ();
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