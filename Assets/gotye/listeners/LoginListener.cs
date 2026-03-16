using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
 

namespace gotye
{
   public interface LoginListener:GotyeListener
    {
        void onLogin(GotyeStatusCode code,GotyeUser user);
        void  onLogout(GotyeStatusCode code);
		void onReconnecting(GotyeStatusCode code, GotyeUser currentUser);
    }
}
