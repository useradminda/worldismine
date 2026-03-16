using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using gotye;
using System.IO;


public struct MyRoleInfoData_ 
{
public string name	;	//名字
public string  uuid ;		//账号ID  防止查找用
public int Country	;//所属国家 -1 还没有加入国家

public int lvl	;		//等级
public int qulity	;	//品质
public int vip;			//vip等级
public int headspid;
    public string head_atlas;
    public string head_sp;
    public string country_atlas;
public string country_sp;
}

//负责接收返回消息
public class RoleChatMag : GotyeMonoBehaviour, ChatListener {
	// Use this for initialization
	void Start () {
		//Debug.Log ("testchat  ");
		api = GotyeAPI.GetInstance ();
		api.AddListener (this);
	}

	void OnDestroy() {

		if(api!=null)
		{

		GotyeStatusCode code = api.Logout (); 
		}
	}
	
	// Update is called once per frame
	//void Update () {
	//	if(Input.GetKeyDown(KeyCode.A)==true)
	//	{
	//		Login();
	//	}
	//}

	public MyRoleInfoData_ MyRoleInfodata;
	public string MyRoleInfo;


	string loginname="";
	public void Login(string name)
	{
        //Debug.Log(name);
        if (api == null)
			Debug.Log("Login api == null");
        api.Login(name, null);
		loginname = name;
    }
	public void LoginOut()
	{
		if(api!=null&&loginname!="")
		{
			Debug.LogError("LoginOut loginname="+loginname);
			GotyeStatusCode code = api.Logout (); 
			loginname = "";
		}
	}
	public int TalkMaxTime = 30;		//语音最大时长


	//public void LoginGroup(int Groupid)
	//{
		//GotyeStatusCode cod = api.EnterRoom (new GotyeGroup (Groupid));
	//}


	//发送文本消息
	public void SendTextToRole (string content, string userId = "")
	{
	
		GotyeChatTarget receiver = new GotyeUser(userId);
		if (receiver != null) {
			GotyeMessage msg = GotyeMessage.CreateTextMessage(receiver, content);
			msg.PutExtraData(System.Text.Encoding.UTF8.GetBytes(MyRoleInfo));			//将个人信息放在额外参数里发送
			api.SendMessage(msg);
			
			//Debug.Log("_SendText" + msg.Text);
			//curTime = cdTime;
		}
	}
	public void SendTextToGroup (string content,GotyeGroup receiver)
	{
        //检查是否被禁言

        //Debug.Log ("receiver:" + receiver.Name);;
        if (receiver != null)
        {
            //Debug.Log("receiver:" + receiver.Name);
            GotyeMessage msg = GotyeMessage.CreateTextMessage(receiver, content);
            msg.PutExtraData(System.Text.Encoding.UTF8.GetBytes(MyRoleInfo));
            api.SendMessage(msg);
            //Debug.Log("_SendText" + msg.Text);
            //curTime = cdTime;
        }
        else
        {
            Debug.Log("receiver is null");
        }
	}

	//发送语音消息

	/// <summary>
	/// 开始录制语音
	/// </summary>
	/// <param name="userId">非私聊可不传</param>
	public void _StartTalkToRole(string userId )
	{
		GotyeChatTarget receiver = new GotyeUser(userId);
		if (receiver != null) {
			api.StartTalk (receiver, GotyeWhineMode.GotyeWhineModeDefault, false, TalkMaxTime * 1000);
		}

	}
	public void _StartTalkToGruop(GotyeGroup receiver)
	{
		api.StartTalk (receiver, GotyeWhineMode.GotyeWhineModeDefault, false, TalkMaxTime * 1000);
        //开始计算说话时间  超时自己结束
    }
	
	/// <summary>
	/// 停止录音并发送
	/// </summary>
	public void _StopTalk()
	{
		api.StopTalk ();
	}
	public void onStopTalk(GotyeStatusCode code, bool realtime, GotyeMessage message){
		// code为回馈状态码，message为产生的语音消息对象，当为实时语音时message是为null的
		if (code == GotyeStatusCode.CodeOK && message != null) {
			message.PutExtraData (System.Text.Encoding.UTF8.GetBytes (MyRoleInfo));			//将个人信息放在额外参数里发送
			api.SendMessage (message);
		} else {

			Debug.LogError("Error onStopTalk code = "+code.ToString());
		}
	}
	//发送消息回调给自己  用于判定发送是否成功 等
	public override void onSendMessage(GotyeStatusCode code, GotyeMessage message)
	{
		//Debug.Log("onSendMessage:" + code);
		if (code == GotyeStatusCode.CodeOK) {
			lgChatMag.Ins.onSendMessage (message);
		} else {
			Debug.LogError("onSendMessage error code = "+code.ToString());
		}
	}
	

	Dictionary<int, GotyeMessage> audioDic = new Dictionary<int, GotyeMessage>();
	//接收到别人发送过来的消息
	public override void onReceiveMessage(GotyeMessage message)
	{
		lgChatMag.Ins.onReceiveMessage (message);
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

	public void JoinGroup(GotyeGroup group)
	{
		api.JoinGroup (group);
	}

    public void LeaveGroup(GotyeGroup group)
    {
        api.LeaveGroup(group);
    }

	public void RequestModifyUserInfo(GotyeUser user,string headIconPath)
	{
		GotyeStatusCode code = api.ReqModifyUserInfo(user,headIconPath);

	}

	public void onModifyUserInfo(GotyeStatusCode code,GotyeUser user)
	{
		lgChatMag.Ins.onModifyUserInfo(code,user);
	}
	/*
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
	*/
}
