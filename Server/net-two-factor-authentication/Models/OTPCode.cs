using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace net_two_factor_authentication.Models
{
    public class OTPCode
    {

        public string PhoneNumber { get; set; }
        public string Code { get; set; }
    }

}