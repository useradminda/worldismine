using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using gotyejson; 

namespace gotye
{
   public class GotyeGroup : GotyeChatTarget
    {
        public GotyeGroup(long groupId) {
            ID = groupId;
            Type = GotyeChatTargetType.GotyeChatTargetTypeGroup;
        }

		public GotyeGroup() {
			Type = GotyeChatTargetType.GotyeChatTargetTypeGroup;
		}

        
		public long Capacity{ get; set;}
	 
		public GotyeUser Owner{ get; set;}
	
		public GotyeGroupType OwnerType{ get; set;}
	
		public bool NeedAuthentication{ get; set;}
 

        public static GotyeGroup createGroupJson(GotyeJsonData obj) {

            long mGroupID = (Int64)obj["groupID"];
			GotyeGroup group = new GotyeGroup(mGroupID);
            group.Capacity=(int)obj["capacity"];
		     group.Info=(string)obj["groupInfo"];
            group.Name=(string)obj["groupName"];
            group.HasGotDetail=(bool)obj["hasGotDetail"];
            group.Icon=GotyeMedia.jsonToIcon(obj["icon"]);
 
            group.NeedAuthentication=(bool)obj["need_authentication"];
			group.Owner=new GotyeUser((string)obj["ownerAccount"]);
			group.OwnerType=(GotyeGroupType)(int)obj["ownerType"];
		 
			return group;
		 
	}

        public override bool Equals(object obj)
        {
            if (obj == null || !(obj is GotyeGroup))
            {
                return false;
            }
            GotyeGroup g = (GotyeGroup)obj;
            return g.ID == ID;

        }
    }
}
