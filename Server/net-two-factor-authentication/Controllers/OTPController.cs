using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using net_two_factor_authentication.Models;
using Sinch.SMS;

namespace net_two_factor_authentication.Controllers {



    public class OTPController : ApiController {
        private static List<OTPCode> OTPCodes = new List<OTPCode>();
        private static Random rng = new Random();
        [HttpGet]
        public async Task<HttpResponseMessage> RequestOTP(string phoneNumber) {
            int value = rng.Next(100, 9999); //I want to avoid all zeros 
            string code = value.ToString("0000");
            var number = phoneNumber.Trim();
            OTPCodes.Add(new OTPCode { PhoneNumber = number, Code = code });

            try {
                // sms client will throw an error if something goes wrong 
                var message = string.Format("Your code:{0} for verifying your number with us", code);

                Client smsClient = new Client("key", "secret");
                await smsClient.SendSMS(number, message);
                return new HttpResponseMessage(HttpStatusCode.OK);

            } catch (Exception ex) {
                // handle error here, see https://www.sinch.com/docs/rest-apis/api-documentation/#messagingapi for possible errros
                return new HttpResponseMessage(HttpStatusCode.InternalServerError);
            }
        }
        [HttpGet]
        public HttpResponseMessage VerifyOTP(string phoneNumber, string code) {
            if (OTPCodes.Any(otp => otp.PhoneNumber == phoneNumber.Trim() && otp.Code == code)) {
                return new HttpResponseMessage(HttpStatusCode.OK);
            } else {
                return new HttpResponseMessage(HttpStatusCode.NotFound);
            }
        }
    }
}
