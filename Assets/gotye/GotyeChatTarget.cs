using gotyejson;
using System.Collections;
using gotye;
namespace gotye{
 
      
	/// <summary>
	/// I gotye chat target.
	/// </summary>
    public class GotyeChatTarget
    {  /// <summary>
    /// ID
    /// </summary>
    /// <value>The I.</value>
       public long ID { get; set; }
		/// <summary>
		/// 用户名字
		/// </summary>

       public string Name { get; set; }

		/// <summary>
		/// 聊天类型
		/// </summary>

       public GotyeChatTargetType Type { get; set; }
		/// <summary>
		/// 头像
		/// </summary>
       public GotyeMedia Icon { get; set; }

       public string Info { get; set; }


	   public bool HasGotDetail{ get; set;}

       public static GotyeChatTarget jsonToSession(GotyeJsonData jsonObject)
       {
           GotyeChatTarget target = null;
           int Id = (int)jsonObject["id"];
           string name = (string)jsonObject["name"];
          
               int type = (int)jsonObject["type"];
               if (type == 0)
               {
                   target = new GotyeUser(name);
               }
               else if (type == 1)
               {
                   target = new GotyeRoom(Id);
               }
               else
               {
                   target = new GotyeGroup(Id);
               }

           return target;
       }
    }
 
   
   

}