using UnityEngine;
using System.Collections;
using gotye;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Security.Cryptography;

/// <summary>
/// Filename: ChatManager.cs
/// Description: Manager of chat
/// Author: Jayce
/// Date: [15/11/10] 创建 待完善功能[CD的获取|每日发送次数的实现]
/// </summary>

//消息来源类型（世界聊天室/公会群/私聊）,消息对象
using SLua;


public delegate void ReceiveMessage(GotyeChatTargetType msgFromType, GotyeMessage message); 

[CustomLuaClass]
public class ChatManager : GotyeMonoBehaviour, ChatListener {	
	public long worldRoomId = 0;    //世界聊天室ID
	public long guildGroupId = 0;   //公会聊天群ID
	public GotyeRoom worldRoom = null;
	public string extraData = "";
	public string loginName = "";
	/// <summary>
	/// 消息来源,消息对象
	/// </summary>
	public ReceiveMessage _onReceiveMessage = null;
	private string TOGGLE_WORLDCHAT_KEY = "ToggleWorldChat";	//世界聊天是否屏蔽的KEY
	private string TOGGLE_GUILDCHAT_KEY = "ToggleGuildChat";	//公会聊天是否屏蔽的KEY
	private bool isWorldChatOpen = true;
	private bool isGuildChatOpen = true;
	private float curTime = 0;
	private float cdTime = 5;	//发送消息间隔时间
	private int daySendMaxCount = 40;	//每日发送次数上限
	private int curSendCount = 0;	//待完善

	public GotyeAPI api;	
	
	private static ChatManager _ins;
	public static ChatManager Ins
	{
		get
		{
			return _ins;
		}
	}

	void Awake()
	{
		_ins = this;

#if chatdisabled
		gameObject.SetActive (false);
#endif
	}

	void Start()
	{
		api = GotyeAPI.GetInstance ();
		api.AddListener (this);
	}

	void Update()
	{
		if (curTime > 0) {
			curTime -= Time.deltaTime;
		}
	}

	/// <summary>
	/// 判断是否冷却完毕，可以发送
	/// </summary>
	public bool _JudgeCD()
	{
		if(curTime <= 0)
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	/// 聊天初始化，并登陆
	/// </summary>
	/// <param name="userId">用户唯一标识.</param>
	/// <param name="worldChatId">世界聊天室ID.</param>
	/// <param name="guildChatId">公会聊天室ID.</param>
	public void _Init(string userId, long worldChatId, long guildChatId, string ed)
    {
		// 聊天配置
		/*
		string jsonStr = configDB.Ins.GetMixedConfig(MixedConfigIdDefine.SYSTEM);
		if (jsonStr != "")
		{
			IDictionary jsonObjects = (IDictionary)MiniJSON.Json.Deserialize(jsonStr);
			IDictionary chatobj = (IDictionary)jsonObjects["chat"];
			cdTime = System.Convert.ToInt32(chatobj["cdTime"]);
			daySendMaxCount = System.Convert.ToInt32(chatobj["dailyLimit"]);
		}
		*/
		cdTime = 5;
		daySendMaxCount = 41;

#if chatdisabled 
#else

		extraData = ed;
		worldRoomId = worldChatId;
		guildGroupId = guildChatId;
		api.Logout();
		loginName = userId;//MD5Encrypt (userId);
		api.Login(loginName, null);
		
		if (PlayerPrefs.HasKey (TOGGLE_WORLDCHAT_KEY) && PlayerPrefs.GetInt(TOGGLE_WORLDCHAT_KEY) == 0) {
			isWorldChatOpen = false;
		}
		if (PlayerPrefs.HasKey (TOGGLE_GUILDCHAT_KEY) && PlayerPrefs.GetInt(TOGGLE_GUILDCHAT_KEY) == 0) {
			isGuildChatOpen = false;
		}
#endif
    }

	/*
	/// <summary>
	/// 切换聊天室，记录当前所在聊天室类型
	/// </summary>
	/// <param name="roomType">Room type.</param>
    public void _SwitchChatRoom(GotyeChatTargetType roomType)
    {
        AppContent.chatPageNowType = roomType;
    }
    */

	public void _SwitchChatRoom(int index)
	{
		switch (index) {
		case 1:
                AppContent.chatPageNowType = GotyeChatTargetType.GotyeChatTargetTypeUser;
			break;
		case 2:
            AppContent.chatPageNowType = GotyeChatTargetType.GotyeChatTargetTypeRoom;
			break;
		case 3:
            AppContent.chatPageNowType = GotyeChatTargetType.GotyeChatTargetTypeGroup;
			break;
            case 4:
            AppContent.chatPageNowType = GotyeChatTargetType.GotyeChatTargetTypeRoom;
            break;
		}
	}
	
	/// <summary>
	/// 发送文本
	/// </summary>
	/// <param name="content">Content.</param>
	/// <param name="targetName">目标userId（私聊用，非私聊可不传）</param>
	public void _SendText (string content, string userId = "")
	{
		GotyeChatTarget receiver = null;
        //Debug.Log("_sndtext" + AppContent.chatPageNowType);
		if (AppContent.chatPageNowType == GotyeChatTargetType.GotyeChatTargetTypeUser) {
            receiver = new GotyeUser(userId);//MD5Encrypt (userId)
		} else if (AppContent.chatPageNowType == GotyeChatTargetType.GotyeChatTargetTypeRoom) {
			receiver = worldRoom;
		} else if (AppContent.chatPageNowType == GotyeChatTargetType.GotyeChatTargetTypeGroup) {
			receiver = null;	//公会先不做
		}

		//Debug.Log ("receiver:" + receiver.Name);;
		if (receiver != null) {
			GotyeMessage msg = GotyeMessage.CreateTextMessage(receiver, content);
			msg.PutExtraData(System.Text.Encoding.UTF8.GetBytes(extraData));
			api.SendMessage(msg);

            //Debug.Log("_SendText" + msg.Text);
			curTime = cdTime;
		}
	}

	/// <summary>
	/// 开始录制语音
	/// </summary>
	/// <param name="userId">非私聊可不传</param>
	public void _StartTalk(string userId = "")
	{
		GotyeChatTarget receiver = null;
		if (AppContent.chatPageNowType == GotyeChatTargetType.GotyeChatTargetTypeUser) {
            receiver = new GotyeUser(userId);//MD5Encrypt (userId)
		} else if (AppContent.chatPageNowType == GotyeChatTargetType.GotyeChatTargetTypeRoom) {
			receiver = worldRoom;
		} else if (AppContent.chatPageNowType == GotyeChatTargetType.GotyeChatTargetTypeGroup) {
			receiver = null;	//公会先不做
		}

		api.StartTalk (receiver, GotyeWhineMode.GotyeWhineModeDefault, false, 30 * 1000);
	}

	/// <summary>
	/// 停止录音并发送
	/// </summary>
	public void _StopTalk()
	{
		api.StopTalk ();
	}

	/// <summary>
	/// 播放语音
	/// </summary>
	/// <param name="message">Message.</param>
	public void _PlayAudio(GotyeMessage message)
	{        
		if(File.Exists(message.Media.Path))//如果本地有这个语音
		{
            PlayAudioAPI(message);
		}
		else
		{
			api.DownloadMediaInMessage(message);
		}
	}

    /// <summary>
    /// 调用播放音频的API
    /// </summary>
    /// <param name="message"></param>
    private void PlayAudioAPI(GotyeMessage message)
    {
        PauseBGMusicWhenPlayAudio(message.Media.Duration);
        api.PlayMessage(message);
    }

    /// <summary>
    /// 播放聊天语音的时候 暂停背景音乐
    /// </summary>
    /// <param name="time">语音时长,单位：毫秒</param>
    private void PauseBGMusicWhenPlayAudio(float time)
    {
        if (AudioManager.Instance.IsBGMusicOpen())
        {
            AudioManager.Instance.StopBG();
            StartCoroutine(DelayToInvoke.DelayToInvokeDo(() =>
            {
                if (AudioManager.Instance.IsBGMusicOpen())
                {
                    AudioManager.Instance.PlayBG(AudioManager.Instance.GetCurMusicName());
                }                
            }, Mathf.Ceil(time / 1000)));            
        }
    }

	/// <summary>
	/// 屏蔽世界/公会 聊天
	/// </summary>
	/// <param name="chatTargetType">Chat target type.</param>
	/// <param name="isOpen">If set to <c>true</c> is open.</param>
	public void _ToggleChat(int chatTargetType, bool isOpen)
	{
        switch ((GotyeChatTargetType)(chatTargetType - 1))
        {
		case GotyeChatTargetType.GotyeChatTargetTypeRoom:
			PlayerPrefs.SetInt (TOGGLE_WORLDCHAT_KEY, isOpen ? 1 : 0);
			isWorldChatOpen = isOpen;
			break;
		case GotyeChatTargetType.GotyeChatTargetTypeGroup:
			PlayerPrefs.SetInt (TOGGLE_GUILDCHAT_KEY, isOpen ? 1 : 0);
			isGuildChatOpen = isOpen;
			break;
		}
	}

	/*
    /// <summary>
    /// 创建公会回调
    /// </summary>
    public void onCreateGuild(string guildName)
    {             
    }
    /// <summary>
    /// 加入公会回调
    /// </summary>
    public void onAddGuild()
    {        
    }
    /// <summary>
    /// 退出公会回调
    /// </summary>
    public void onQuitGuild()
    {        
    }
	*/

	public override void onSendMessage(GotyeStatusCode code, GotyeMessage message)
	{
        //Debug.Log("onSendMessage:" + code);
        if (code == GotyeStatusCode.CodeOK)
        {
            //发送成功的文本
            System.Object[] args = new System.Object[3];
            args[0] = (int)message.Receiver.Type + 1;
            args[1] = (int)message.Type + 1;
            args[2] = message;
            lgNoDelCsFun.Ins.Call(lgNoDelCsFun.Ins.mainlua, "GameMain.ChatSysSendMessage", args);
        }
	}

    /// <summary>
    /// 本地消息
    /// </summary>
    /// <param name="txt"></param>
    /// <param name="senderPlayerName">userId</param>
    /// <param name="senderVipLevel">viplvl</param>
    /// <param name="senderWorld_id">world_id</param>
    /// <param name="senderRealId">角色realId</param>
    public void _onReceiveLocalTextMessage(string txt, string senderUserId, string senderVipLevel, string senderWorld_id, string senderRealId)
    {
        GotyeUser sender = new GotyeUser(senderWorld_id);
        GotyeRoom receiver = new GotyeRoom(worldRoomId);
        GotyeMessage gotyeMessage = GotyeMessage.CreateTextMessage(sender, receiver, txt);
        gotyeMessage.PutExtraData(System.Text.Encoding.UTF8.GetBytes(senderUserId + "&" + senderVipLevel + "&" + senderWorld_id + "&" + senderRealId));
        System.Object[] args = new System.Object[3];
        args[0] = (int)gotyeMessage.Receiver.Type + 1;
        args[1] = (int)gotyeMessage.Type + 1;
        args[2] = gotyeMessage;
        lgNoDelCsFun.Ins.Call(lgNoDelCsFun.Ins.mainlua, "GameMain.ChatSysGetMessage", args);
    }

    Dictionary<int, GotyeMessage> audioDic = new Dictionary<int, GotyeMessage>();
	public override void onReceiveMessage(GotyeMessage message)
	{
		if (message.Receiver.Type == GotyeChatTargetType.GotyeChatTargetTypeRoom && !isWorldChatOpen)
			return;
		if (message.Receiver.Type == GotyeChatTargetType.GotyeChatTargetTypeGroup && !isGuildChatOpen)
			return;

		if (_onReceiveMessage != null) {
			_onReceiveMessage (message.Receiver.Type, message);
		}
		else{
			System.Object[] args = new System.Object[3];
			args[0] = (int)message.Receiver.Type + 1;
            args[1] = (int)message.Type + 1;
            args[2] = message;
            /*
            if(message.Type == GotyeMessageType.Text)
            {
                args[2] = message.Text;
            }
            else
            {
                int curIndex = audioDic.Count + 1;
                audioDic.Add(curIndex, message);
                args[2] = curIndex;
            }

            Debug.Log("args[2]:" + args[2]);
             * */
    		lgNoDelCsFun.Ins.Call(lgNoDelCsFun.Ins.mainlua, "GameMain.ChatSysGetMessage", args);
		}

		/*
		if (message.Receiver.Type == GotyeChatTargetType.GotyeChatTargetTypeRoom) {

		} else if (message.Receiver.Type == GotyeChatTargetType.GotyeChatTargetTypeUser) {
		
		}

		if (message.Type == GotyeMessageType.Text) {
			
		}
		else if(message.Type == GotyeMessageType.Audio)
		{
			if(File.Exists(message.Media.Path))//如果本地有这个语音
			{
				//api.PlayMessage(message);
			}
			else
			{
				api.DownloadMediaInMessage(message);
			}
		}
		*/
	}



	public void onStartTalk(GotyeStatusCode code, GotyeChatTarget target,  bool isRealTime)
	{
		//Debug.Log ("onStartTalk" + code);
	}
	
	public void onStopTalk(GotyeStatusCode code, bool realtime, GotyeMessage message)
	{
		//Debug.Log ("onStopTalk" + code + "," + message.Receiver.Name);
		message.PutExtraData(System.Text.Encoding.UTF8.GetBytes(extraData));
		api.SendMessage(message);
		curTime = cdTime;
	}

	public void onDownloadMediaInMessage(GotyeStatusCode code, GotyeMessage message)
	{
		if (code == GotyeStatusCode.CodeOK) {
			if (message.Type == GotyeMessageType.Image) {
				//Debug.Log ("下载消息中的图片成功!");				
			} else if (message.Type == GotyeMessageType.Audio) {
                PlayAudioAPI(message);
				//Debug.Log ("下载消息中的音频成功!");                
				
			}			
		}
	}
	
	public void onDecodeMessage(GotyeStatusCode code, GotyeMessage message)
	{
		if(code == GotyeStatusCode.CodeOK)
		{
			//Debug.Log ("解码消息成功!" + message.Text);
		}
	}

    /// <summary>
    /// 世界聊天屏蔽开关
    /// </summary>
    public void ToogleReceiveWorldChat()
    { 
        
    }

    /// <summary>
    /// 公会聊天屏蔽开关
    /// </summary>
    public void ToogleReceiveGuildChat()
    {
 
    }
	/// <summary>
	/// 该消息是否是接收的消息
	/// </summary>
	/// <returns><c>true</c> if this instance is receieved message the specified message; otherwise, <c>false</c>.</returns>
	/// <param name="message">Message.</param>
	public bool _IsReceievedMessage(GotyeMessage message)
	{
		if (message.Sender.Name == loginName) {
			return false;
		} else {
			return true;
		}
	}

	/// <summary>
	/// 是否是语音消息
	/// </summary>
	/// <returns><c>true</c>, if is audio message was _ed, <c>false</c> otherwise.</returns>
	/// <param name="message">Message.</param>
	public bool _IsAudioMessage(GotyeMessage message)
	{
		if (message.Type == GotyeMessageType.Audio) {
			return true;
		} else {
			return false;
		}
	}

	/// <summary>
	/// _s the duration of the get media.
	/// </summary>
	/// <returns>The get media duration.</returns>
	/// <param name="message">Message.</param>
	public int _GetMediaDuration(GotyeMessage message)
	{
		return message.Media.Duration;
	}
    /*
	private string MD5Encrypt(string input)
	{
		input = "dhz" + input;
		return MD5Encrypt(input, new UTF8Encoding());
	}
	
	private string MD5Encrypt(string input, Encoding encode)
	{
		MD5 md5 = new MD5CryptoServiceProvider();
		byte[] t = md5.ComputeHash(encode.GetBytes(input));
		StringBuilder sb = new StringBuilder(32);
		for (int i = 0; i < t.Length; i++)
			sb.Append(t[i].ToString("x").PadLeft(2, '0'));
		return sb.ToString();
	}
    */
}
