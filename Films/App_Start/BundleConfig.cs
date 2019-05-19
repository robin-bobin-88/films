using System.Web;
using System.Web.Optimization;

namespace Films
{
    public class BundleConfig
    {
        // Дополнительные сведения об объединении см. на странице https://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"
                        ));

            bundles.Add(new ScriptBundle("~/bundles/js").Include(                      
                      "~/Scripts/axios.min.js"
                      ));
                 
            bundles.Add(new StyleBundle("~/Content/css").Include(                      
                      "~/Content/site.css"
                      ));
        }
    }
}
