namespace Licenses {

    public class License : GLib.Object {

        public string license_faq;
        public string license_text;
        private GLib.Regex regex;

        construct {
            try {

                /**
                 * Initialize regular expression -> Match every line between ---
                 */

                this.regex = new GLib.Regex ("---(.*?)---\n", DOTALL); 
                
            } catch (GLib.RegexError e) {
                print(e.message);
            }
        }

        public void reset () {
           
            /**
             * Reset license_faq and license_text back to the first license in array
             */
            
            get_license (Licenses.LICENSES[0]);
        }

        public void get_license (string license_name) {

            try {      
                
                /**
                 * Path to embedded GResource
                 */

                string uri = "resource:///com/github/eetagent/Licenses/" + license_name + ".txt";

                
                /**
                 * Get GResource content
                 */

                DataInputStream license_stream = new DataInputStream (File.new_for_uri (uri).read ());
                string license_data = license_stream.read_upto ("", -1, null, null);

                /**
                 * Rather dirty Regex code
                 */

                MatchInfo match_info;
                this.regex.match(license_data, 0, out match_info);

                license_text = this.regex.replace (license_data, license_data.length, 0, "");
                license_faq = match_info.fetch (1);

            } catch (GLib.Error e) {
                license_faq = e.message;
                license_text = e.message;
            }


        }

    }

    /**
     * Array with names of all imported licenses
     */
    
    const string[] LICENSES = { 
    "0BSD", 
    "AFL-3.0", 
    "AGPL-3.0", 
    "Apache-2.0", 
    "Astistic-2.0", 
    "BSD-2-CLAUSE", 
    "BSD-3-CLAUSE", 
    "BSD-4-CLAUSE", 
    "BSL-1.0", 
    "CC-BY-4.0", 
    "CC-BY-SA-4.0", 
    "CC0-1.0", 
    "CeCILL-2.1", 
    "ECL-2.0", 
    "EPL-1.0", 
    "EPL-2.0", 
    "EUPL-1.1", 
    "EUPL-1.2", 
    "GPL-2.0", 
    "GPL-3.0", 
    "ISC", 
    "LGPL-2.1", 
    "LGPL-3.0", 
    "LPPL-1.3C", 
    "MIT", 
    "MPL-2.0", 
    "MS-PL", 
    "MS-RL", 
    "NCSA",
    "ODBL-1.0", 
    "OFL-1.1", 
    "OSL-3.0", 
    "PostgreSQL", 
    "Unlicense", 
    "UPL-1.0", 
    "VIM", 
    "WTFPL", 
    "ZLIB" };

}