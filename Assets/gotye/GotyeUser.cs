using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using gotyejson;
namespace gotye
{        
        /// <summary>
        /// 用户对象
        /// </summary>
        public class GotyeUser : GotyeChatTarget
        {
		    public bool IsBlocked{ get; set;}
		    public bool IsFriend{ get; set;}
            
            public string NickName { get; set; }
            public GotyeUserGender Gender{get;set;}
            /// <summary>
            /// 创建用户对象
            /// </summary>
            /// <param name="username">用户名字</param>
            /// 
            public GotyeUser(string username)
            {
                this.Name = username;
                Type = GotyeChatTargetType.GotyeChatTargetTypeUser;
            }
             /// <summary>
             /// 类型
             /// </summary>

            public override bool Equals(object obj)
            {
                if (obj==null || !(obj is GotyeUser))
                {
                    return false;
                }
                GotyeUser u = (GotyeUser)obj;
                return u.Name.Equals(this.Name);
               
            }
            public static GotyeUser jsonToUser(GotyeJsonData json) {

                string name = (string)json["name"];
                GotyeUser user = new GotyeUser(name);
                user.IsBlocked = (bool)json["isBlocked"];
                user.IsFriend = (bool)json["isFriend"];

                user.Info = (string)json["info"];
                user.NickName = (string)json["nickname"];
                int gender=(int)json["gender"];

                user.Gender = (GotyeUserGender)gender;

                user.HasGotDetail = (bool)json["hasGotDetail"];
                user.Icon = GotyeMedia.jsonToIcon(json["icon"]);
                return user;		
            }
        }
 
}
