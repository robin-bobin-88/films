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
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/js").Include(
                      "~/Scripts/vue.min.js",
                      "~/Scripts/axios.min.js",
                      "~/Scripts/ElementUI/element-ui.js"));
                 
            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Content/bootstrap.css",
                      "~/Content/site.css",
                      "~/Content/ElementUI/element-ui.css"));
        }
    }
}
