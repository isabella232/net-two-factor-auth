using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(LoginSample.Startup))]
namespace LoginSample
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
