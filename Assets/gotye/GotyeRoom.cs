using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using gotyejson; 

namespace gotye
{
    /// <summary>
    /// 聊天室对象
    /// </summary>
   public class GotyeRoom:GotyeChatTarget
    {
       public GotyeRoom(long roomId)
       {
           ID = roomId;
           Type = GotyeChatTargetType.GotyeChatTargetTypeRoom;
       }
       

		public bool IsTop{ get; set;}

		public int Capacity{ get; set;}

		public int OnlineNumber{ get; set;}

       public static GotyeRoom createRoomJson(GotyeJsonData obj) {
           long mRoomId = (Int64)obj["id"];
           GotyeRoom room = new GotyeRoom(mRoomId);
			room.Capacity= (int)obj["capacity"];
           GotyeMedia icon = GotyeMedia.jsonToIcon(obj["icon"]);
           room.Icon = icon;
		 

            room.IsTop=(bool)obj["isTop"];
            room.Name=(string)obj["name"];
 
			room.OnlineNumber=(int)obj["onlineNumber"];

            return room;
	}
       public override bool Equals(object obj)
       {
           if (obj == null || !(obj is GotyeRoom))
           {
               return false;
           }
           GotyeRoom r = (GotyeRoom)obj;
           return r.ID == ID;

       }

    }
}
