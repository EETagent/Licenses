namespace Licences {

	public class Application : Gtk.Application {

		public const GLib.ActionEntry[] action_entries = {
			{ "copy", copy_activated },
			{ "quit", quit_activated }
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
			add_action_entries (action_entries, this);
			set_accels_for_action ("app.quit", { "<Ctrl>Q", "<Super>Q" } );
			set_accels_for_action ("app.copy", { "<Ctrl>C", "<Super>C" } );

			base.startup ();
		}

		void quit_activated (SimpleAction action, Variant ? variant) {
			this.quit ();
		}

		void copy_activated (SimpleAction action, Variant ? variant) {
			var window = this.active_window;
			if (window != null) {
				((Licenses.Window)window).copy_action ();
			}
		}

		public static int main (string[] args) {
			var app = new Licences.Application ();
			return app.run (args);
		}
	}
}
