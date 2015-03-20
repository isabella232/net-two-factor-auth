using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Part4.Startup))]
namespace Part4
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
