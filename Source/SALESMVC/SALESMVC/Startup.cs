using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(SALESMVC.Startup))]
namespace SALESMVC
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
