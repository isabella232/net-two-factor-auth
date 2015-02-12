using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using Microsoft.AspNet.Identity;
using Sinch.SMS;

namespace net_two_factor_authentication {
    public class SMSIdentityService : IIdentityMessageService {
       
            public async Task SendAsync(IdentityMessage message) {
                var Sinch = new Client("1aaad909-3858-413f-a947-31166c643c11", "G7IL68UdUUyN0rSE1yWi1w==");
                var result = await Sinch.SendSMS(message.Destination, message.Body);
                return ;
            }
       
    }
}