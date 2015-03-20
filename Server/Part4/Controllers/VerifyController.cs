using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using Base32;
using Microsoft.AspNet.Identity;
using Part4;
using Sinch.SMS;
using Microsoft.AspNet.Identity.Owin;
using Newtonsoft.Json;
using OtpSharp;
using Part4.Models;

namespace net_two_factor_authentication.Controllers {
    public class VerifyController : ApiController {
        

        private ApplicationSignInManager _signInManager;
        private ApplicationUserManager _userManager;

        public VerifyController() {
            
        }
        public VerifyController(ApplicationUserManager userManager, ApplicationSignInManager signInManager) {
            UserManager = userManager;
            SignInManager = signInManager;
        }
        public ApplicationSignInManager SignInManager {
            get
            {
                return _signInManager ?? Request.GetOwinContext().Get<ApplicationSignInManager>();

                
            }
            private set {
                _signInManager = value;
            }
        }
        public ApplicationUserManager UserManager {
            get
            {
                return _userManager ?? Request.GetOwinContext().GetUserManager<ApplicationUserManager>();
            }
            private set {
                _userManager = value;
            }
        }

            /// <summary>
        /// Method to start a phonenumber verification process. 
        /// </summary>
        /// <param name="phoneNumber">Phonenumber in international format 15555551231</param>
        /// <returns>200 ok and delivers an sms to the handset</returns>
        [HttpGet]
        [Route("api/requestcode/{phonenumber}")]
        public async Task<HttpResponseMessage> RequestCode(string phoneNumber) {
            var number = phoneNumber.Trim();
            var user = UserManager.Users.First(u => u.PhoneNumber == phoneNumber);
            var code = await UserManager.GenerateChangePhoneNumberTokenAsync(user.Id, number);
            if (UserManager.SmsService != null)
            {
                var message = new IdentityMessage
                {
                    Destination = number,
                    Body = "Your security code is: " + code
                };
                await UserManager.SmsService.SendAsync(message);
            }
            
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        /// <summary>
        /// Endpoint for verifying code recieved by sms
        /// </summary>
        /// <param name="phoneNumber">Phonenumber in international format 15555551231</param>
        /// <param name="code">code</param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/verifycode/{phonenumber}/{code}")]
        public async Task<VerifyCodeResponse> VerifyCode(string phoneNumber, string code) {
            var user = UserManager.Users.FirstOrDefault(u => u.PhoneNumber == phoneNumber);
            if (user == null)
                throw new HttpException(404, "User not found");
            VerifyCodeResponse vcr = new VerifyCodeResponse();
            var result = await UserManager.VerifyChangePhoneNumberTokenAsync(user.Id, code, phoneNumber);
            if (result )
            {
                vcr.Secret = user.SinchAuthSecretKey;
                return vcr;
            }
            else
            {
                throw new HttpException(404, "User not found");
            }
            
        }

        

        /// <summary>
        /// Use this to send in the RFC token from the authenticator funtion in the app
        /// </summary>
        /// <param name="token"></param>
        /// <param name="phoneNumber"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/verifytoken/")]
        public async Task<HttpResponseMessage> VerifyToken(string token, string phoneNumber)
        {
            long timeStepMatched = 0;
            var user = UserManager.Users.First(u => u.PhoneNumber == phoneNumber);
            var otp = new Totp(Base32Encoder.Decode(user.SinchAuthSecretKey));
            bool valid = otp.VerifyTotp(token, out timeStepMatched, new VerificationWindow(2, 2));
            if (!valid)
                return new HttpResponseMessage(HttpStatusCode.Forbidden);
            OneTimeLinks.AddLink(user.Id);
            return new HttpResponseMessage(HttpStatusCode.OK);
        }



        [HttpGet]
        [Route("Verify/StatusCheck")]
        public async Task<object> StatusCheck()
        {
            var userId = await SignInManager.GetVerifiedUserIdAsync();
            
            if (string.IsNullOrEmpty(userId))
            {
                return Json(new {status="Error"});
            }
            var link = OneTimeLinks.GetByUserId(userId);
            if ( link == null) {
                return Json(new {status="Waiting"});
                }
            else
            {
                return Json(new { status = "Ok", guid = link.Guid });    
            }
        }

      
    }
    public class VerifyCodeResponse
    {
        [JsonProperty(PropertyName = "secret")]
        public string Secret { get; set; }
    }

    
}
