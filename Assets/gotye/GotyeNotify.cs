using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using gotyejson;

namespace gotye
{
   public enum GotyeNotifyType
    {
        /**
         * 邀请类型
         */
        GroupInvite,
        /**
         * 请求类型
         */
        JoinGroupRequest,
        /**
         * 请求回复类型
         */
        JoinGroupReply
    }
   public class GotyeNotify
    {
		public long DbId{ get; set;}
		public long Date{ get; set;} // seconds since 1970.1.1 00:00
       public bool IsRead { get; set; }
       public GotyeChatTarget Sender { get; set; }
       public GotyeChatTarget Receiver { get; set; }
       public GotyeChatTarget From { get; set; } // source of notify.
        // GotyeNotifyTypeGroupInvite is from some
        // group, etc.

       public bool Agree { get; set; }
       public bool IsSystemNotify { get; set; }
       public GotyeNotifyType Type { get; set; }
       public String Text { get; set; }// notify content.
  

        

        public static GotyeNotify jsonToNotify(GotyeJsonData obj)
        {
             
                GotyeNotify notify = new GotyeNotify();
                notify.DbId = (int)obj["db_id"];
                notify.Date = (int)obj["date"];
                notify.IsRead = (bool)obj["is_read"];
                int sender_type = (int)obj["sender_type"];
                long sender_id = (int)obj["sender_id"];
                String sender_name = (string)obj["sender_name"];

                if (sender_type == 0)
                {
                    GotyeChatTarget sender = new GotyeUser(sender_name);
                    sender.Type = (GotyeChatTargetType)sender_type;
                    notify.Sender = sender;
                }
                int receiver_type = (int)obj["receiver_type"];
                long receiver_id = (int)obj["sender_id"];
                String receiver_name = (string)obj["receiver_name"];
                if (receiver_type == 0)
                {
                    GotyeChatTarget receiver = new GotyeUser(receiver_name);
                    receiver.Type = (GotyeChatTargetType)receiver_type;
                    notify.Receiver = receiver;
                }

                int from_type = (int)obj["from_type"];
                long from_id = (uint)obj["from_id"];
                String from_name = (string)obj["from_name"];

                if (from_type == 2)
                {
                    GotyeChatTarget from = new GotyeGroup(from_id);
                    from.Name = from_name;
                    from.Type = (GotyeChatTargetType)from_type;
                    notify.From = from;
                }

                notify.IsSystemNotify = (bool)obj["is_system"];
                notify.Agree = (bool)obj["agree"];
                int type = (int)obj["type"];
                notify.Type = (GotyeNotifyType)type;
                notify.Text = (string)obj["text"];
                return notify;
            
           
        }
    }
}
