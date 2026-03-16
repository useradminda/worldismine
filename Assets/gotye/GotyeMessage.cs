 
using System.Collections;
using System;
using System.Collections.Generic;
using gotyejson;
namespace gotye
{   /// <summary>
    /// 消息类型
    /// </summary>
    public enum GotyeMessageType
    { /// <summary>
        /// 文本消息
        /// </summary>
        Text,
        /// <summary>
        /// 图片消息
        /// </summary>
        Image,
        /// <summary>
        /// 语音消息
        /// </summary>
        Audio,
        /// <summary>
        /// 用户自定义数据
        /// </summary>
        UserData
    };
    /// <summary>
    /// 语音消息变声类型
    /// </summary>
    public enum GotyeWhineMode
    {
        /// <summary>
        /// 默认变声（未变声）
        /// </summary>
        GotyeWhineModeDefault,
        /// <summary>
        /// 圣诞老人
        /// </summary>
        GotyeWhineModeFatherChristmas,
        /// <summary>
        /// 变形金刚擎天柱
        /// </summary>
        GotyeWhineModeOptimus,
        /// <summary>
        /// 海豚
        /// </summary>
        GotyeWhineModeDolphine,
        /// <summary>
        /// 婴儿
        /// </summary>
        GotyeWhineModeBaby,
        /// <summary>
        /// 低音
        /// </summary>
        GotyeWhineModeSubwoofer
    }

   /// <summary>
   /// 消息状态.
   /// </summary>
	public enum GotyeMessageStatus
	{
		/// <summary>
		/// 默认状态.
		/// </summary>
		GotyeMessageStatusCreated,
		/// <summary>
		/// 未读.
		/// </summary>
		GotyeMessageStatusUnread,
		/// <summary>
		/// 已读.
		/// </summary>
		GotyeMessageStatusRead,
		/// <summary>
		/// 发送中.
		/// </summary>
		GotyeMessageStatusSending,
		/// <summary>
		/// 发送成功.
		/// </summary>
		GotyeMessageStatusSent,
		/// <summary>
		/// 发送失败.
		/// </summary>
		GotyeMessageStatusSendingFailed
	}

    /// <summary>
    /// GotyeAPI消息对象
    /// </summary>
    public class GotyeMessage
    {
        
		public long Date{ get; set;}

		public long DbId{ get; set;}

		public long Id{ get; set;}

        public GotyeMedia Media { get; set; }
        public GotyeMedia Extra { get; set; }

		public byte[] UserData{ get; set;}
		public byte[] ExtraData{ get; set;}
        public GotyeChatTarget Receiver { set; get; }

        public GotyeChatTargetType ReceiverType { set; get; }

        public GotyeChatTarget Sender { get; set; }

        public GotyeChatTargetType SenderType { set; get; }

        public String Text { set; get; }

        public GotyeMessageType Type { set; get; }
		public GotyeMessageStatus Status { set; get; }


        private GotyeMessage()
        {

        }


        public void PutExtraData(byte[] extraData)
        {
            this.ExtraData = extraData;
        }

        public byte[] GetExtraData()
        {
            return ExtraData;
        }


        public byte[] GetUserData()
        {
            return UserData;
        }
 
        public static GotyeMessage CreateTextMessage(GotyeChatTarget receiver,
                String text)
        {
			return CreateTextMessage(GotyeAPI.GetInstance().GetLoginUser(), receiver, text);
        }

        public static GotyeMessage CreateTextMessage(GotyeChatTarget sender,
                GotyeChatTarget receiver, String text)
        {
            GotyeMessage message = new GotyeMessage();
            message.Sender = sender;
            message.Receiver = receiver;
            message.Text = text;
             
            message.Type = GotyeMessageType.Text;
            return message;
        }

        public static GotyeMessage CreateImageMessage(GotyeChatTarget receiver,
                String imagePath)
        {
            return CreateImageMessage(GotyeAPI.GetInstance().GetLoginUser(), receiver, imagePath);
        }

        //
        public static GotyeMessage CreateImageMessage(GotyeChatTarget sender,
                GotyeChatTarget receiver, String imagePath)
        {
            GotyeMessage message = new GotyeMessage();
            message.Sender = sender;
            message.Receiver = receiver;
            //message.setDate(System.currentTimeMillis() / 1000);
            GotyeMedia media = new GotyeMedia(GotyeMediaType.Image);
            media.PathEx = imagePath;
            media.Type = GotyeMediaType.Image;
            message.Media = media;
            message.Type = GotyeMessageType.Image;
            return message;
        }

        public static GotyeMessage CreateUserDataMessage(GotyeChatTarget receiver,
                String dataPath)
        {
            return CreateUserDataMessage(GotyeAPI.GetInstance().GetLoginUser(), receiver, dataPath);
        }

        public static GotyeMessage CreateUserDataMessage(GotyeChatTarget sender,
                GotyeChatTarget receiver, String dataPath)
        {
            GotyeMessage message = new GotyeMessage();
            message.Sender = sender;
            message.Receiver = receiver;
            GotyeMedia media = new GotyeMedia(GotyeMediaType.UserData);
            media.Path = dataPath;
            message.Date = DateTime.Now.Millisecond / 1000;
            media.Type = GotyeMediaType.UserData;
            message.Media = media;
            message.Type = GotyeMessageType.UserData;
            return message;
        }

        public static GotyeMessage CreateUserDataMessage(GotyeChatTarget receiver,
                byte[] data, int len)
        {
            return CreateUserDataMessage(GotyeAPI.GetInstance().GetLoginUser(), receiver, data, len);

        }

        public static GotyeMessage CreateUserDataMessage(GotyeChatTarget sender,
                GotyeChatTarget receiver, byte[] data, int len)
        {
            if (data == null)
            {
                throw new NullReferenceException("data is null");
            }
            if (data.Length < len)
            {
                throw new NullReferenceException("len > data length");
            }
            GotyeMessage message = new GotyeMessage();
            message.Sender = sender;
            message.Receiver = receiver;
            message.UserData = data;
            message.Type = GotyeMessageType.UserData;
            return message;
        }

        public static GotyeMessage jsonToMessage(String jsonMessage)
        {
            if (jsonMessage == null || jsonMessage.Length == 0)
            {
                return null;
            }
            return jsonToMessage(new GotyeJsonData(jsonMessage));
        }

        public static GotyeMessage jsonToMessage(GotyeJsonData obj)
        {
            GotyeMessage msg = new GotyeMessage();


            msg.Date = (Int64)obj["date"];
            msg.DbId = (Int64)obj["dbID"];
            try
            {
                msg.Id = (Int64)obj["id"];
            }
            catch (Exception e) { 
            
            }
           
            int type = (int)obj["type"];

            msg.Type = (GotyeMessageType)type;
            int receiver_type = (int)obj["receiver_type"];
            msg.ReceiverType = (GotyeChatTargetType)receiver_type;
            if (msg.ReceiverType == GotyeChatTargetType.GotyeChatTargetTypeUser)
            {
                GotyeUser user = new GotyeUser((string)obj["receiver"]);
                msg.Receiver = user;
            }
            else if (msg.ReceiverType == GotyeChatTargetType.GotyeChatTargetTypeRoom)
            {
                long roomId = (Int64)obj["receiver"];
                GotyeRoom room = new GotyeRoom(roomId);

                msg.Receiver = room;
            }
            else if (msg.ReceiverType == GotyeChatTargetType.GotyeChatTargetTypeGroup)
            {
                long groupId = (Int64)obj["receiver"];
                GotyeGroup group = new GotyeGroup(groupId);
                msg.Receiver = group;
            }
            int sender_type = (int)obj["sender_type"];

            msg.SenderType = (GotyeChatTargetType)sender_type;


            if (msg.SenderType == GotyeChatTargetType.GotyeChatTargetTypeUser)
            {
                GotyeUser user = new GotyeUser((string)obj["sender"]);
                msg.Sender = user;
            }
            else if (msg.SenderType == GotyeChatTargetType.GotyeChatTargetTypeRoom)
            {
                long roomId = (Int64)obj["sender"];
                GotyeRoom room = new GotyeRoom(roomId);
                msg.Sender = room;
            }
            else if (msg.SenderType == GotyeChatTargetType.GotyeChatTargetTypeGroup)
            {
                long groupId = (Int64)obj["sender"];
                GotyeGroup group = new GotyeGroup(groupId);
                msg.Sender = group;
            }
            msg.Media = GotyeMedia.jsonToMedia(obj["media"]);
            if (msg.Type == GotyeMessageType.UserData && msg.Media.Type == GotyeMediaType.UserData)
            {
                msg.UserData = FileUtil.getBytes(msg.Media.Path);
            }
            msg.Extra = GotyeMedia.jsonToMedia(obj["extra"]);
            if (msg.Extra != null)
            {
                msg.ExtraData = FileUtil.getBytes(msg.Extra.Path);
            }
			int status=(int)obj["status"];
			msg.Status = (GotyeMessageStatus)status;
            msg.Text = (string)obj["text"];


            return msg;
        }

        public bool equals(Object obj)
        {
            if (obj == null)
            {
                return false;
            }
            GotyeMessage message = (GotyeMessage)obj;
            if (message.DbId == this.DbId)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}
