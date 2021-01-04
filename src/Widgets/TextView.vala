namespace Licenses {

    public class TextView : Gtk.TextView {

        public TextView (string content) {
            this.set_text (content);
        }

        public void set_text (string content) {
            get_buffer ().set_text (content);
        }

        construct {

            /**
             * Some text formatting
             */

            set_editable (false);

            set_pixels_above_lines (5);

            set_top_margin (10);
            set_right_margin (25);
            set_bottom_margin (10);
            set_left_margin (25);

            set_wrap_mode (WORD);
        }
    }
}
