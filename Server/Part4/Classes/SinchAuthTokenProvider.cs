using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using Base32;
using Microsoft.AspNet.Identity;
using OtpSharp;
using Part4.Models;

namespace Part4.Classes {
    public class SinchAuthTokenProvider : IUserTokenProvider<ApplicationUser, string> {
        public Task<string> GenerateAsync(string purpose, UserManager<ApplicationUser, string> manager, ApplicationUser user) {
            
            return Task.FromResult((string)null);
        }

        public Task<bool> ValidateAsync(string purpose, string token, UserManager<ApplicationUser, string> manager, ApplicationUser user) {
            long timeStepMatched = 0;
            var otp = new Totp(Base32Encoder.Decode(user.SinchAuthSecretKey));
            bool valid = otp.VerifyTotp(token, out timeStepMatched, new VerificationWindow(2, 2));
            return Task.FromResult(valid);
        }

        public Task NotifyAsync(string token, UserManager<ApplicationUser, string> manager, ApplicationUser user) {
            return Task.FromResult(true);
        }

        public Task<bool> IsValidProviderForUserAsync(UserManager<ApplicationUser, string> manager, ApplicationUser user) {
            return Task.FromResult(user.IsSinchAuthEnabled);
        }
    }
}