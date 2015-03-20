using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Part4.Models {
    public class OneTimeLink {
        public string UserId { get; set; }
        public Guid Guid { get; set; }
    }

    public class OneTimeLinks {
        private static List<OneTimeLink> _oneTimelinks { get; set; }

        public static OneTimeLink GetByUserId(string userId)
        {
            if (_oneTimelinks == null)
                return null;
            return _oneTimelinks.FirstOrDefault(m => m.UserId == userId);
        }
        public static bool VerifyLink(string userId, Guid guid) {
            if (_oneTimelinks == null)
                return false;
            if (_oneTimelinks.Any(m => m.Guid == guid && m.UserId == userId)) {
                _oneTimelinks.Remove(_oneTimelinks.First(m => m.Guid == guid && m.UserId == userId));
                return true;
            } else {
                return false;
            }
        }
        public static void AddLink(string userId) {
            if (_oneTimelinks == null)
                _oneTimelinks = new List<OneTimeLink>();
            _oneTimelinks.Add(new OneTimeLink {
                UserId = userId,
                Guid = Guid.NewGuid()
            });
        }
    }


}