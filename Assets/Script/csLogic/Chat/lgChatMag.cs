using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using gotye;
using SLua;
public struct IniChatData_
{
	//public long chatid;	//GotyeChatTarget.ID
	public string name	;	//名字
	public string  uuid ;		//账号ID  防止查找用
	public int Country	;//所属国家 -1 还没有加入国家
	public long countrychatid	;//国家聊天房间id
	public long worldchatid;	//世界聊天室id
	public int lvl	;		//等级
	public int qulity	;	//品质
	public int vip;			//vip等级
	public bool countrychatfb;	//国家频道禁言
	public int chatfblvl;		//禁言权限等级  高的禁言低级的
	public int labanum;			//玩家有世界喇叭数量
	public int saylabneednum;	//每次说话 扣除喇叭数量

	public int headspid;//出战uuid
    public string head_atlas;
    public string head_sp;
    public string country_atlas;
	public string country_sp;
}

public struct ChatRoleInfo_
{
	public string  uuid ;		//账号ID  防止查找用
	public int Country	;//所属国家 -1 还没有加入国家
	public int lvl	;		//等级
	public int qulity	;	//品质
	
}
public struct MsgData_
{
	public GotyeMessage msg;
	public chatitem showitem;

}

public struct MsgData2_
{
	public string info;
	public siliaoitem showitem;
	public MyRoleInfoData_ showdata;
}

[CustomLuaClass]
public class lgChatMag :MonoBehaviour {


	private static lgChatMag _ins = null;
	public static lgChatMag Ins
	{
		get
		{
			//if (_ins == null)
			//{
			//	_ins = new lgChatMag();
			//}
			return _ins;
		}
	}

	private RoleChatMag MyRoleChat;
	private GroupChatMag MyGroupChat;

	private GotyeGroup Countrygroup;
	private GotyeGroup Worldgroup;


	public GotyeUser MyUser;

	public IniChatData_ MyIniChatData;

	public int smallmsgnum = 50;	//接收所有消息数量
	public int sysmsgnum = 50;		//接收系统消息数量
	public int Countrymsgnum = 50;	//接收国家消息数量
	public int Worldmsgnum = 50;	//接收世界消息数量
	public int Rolemsgnum = 50;		//接收私聊消息数量

	//数据
	public List<GotyeMessage> sysmsgList = new List<GotyeMessage>();		//接收系统消息
	//public Dictionary<int ,MsgData_> CountrymsgList = new Dictionary<int,MsgData_>();	//接收国家消息
	public List<MsgData_> CountrymsgList = new List<MsgData_>();	//接收国家消息
	public List<MsgData_> WorldmsgList = new List<MsgData_>();	//接收世界消息

	public List<MsgData2_> RolemsgList = new List<MsgData2_>();		//接收私聊消息

	public Dictionary<string,List<MsgData_>> PrivateChatMsg = new Dictionary<string, List<MsgData_>> ();

	//List<string> PrivateChatRoleList = new List<string> ();

	public List<MsgData_> smallshowmsgList = new List<MsgData_>();		//接收所有消息 用于显示外面小面板

    private void ClearAllData()
    {
        sysmsgList.Clear();
        CountrymsgList.Clear();
        WorldmsgList.Clear();
        RolemsgList.Clear();
        PrivateChatMsg.Clear();
        smallshowmsgList.Clear();
    }
	public int sysmsgfromid = 0;
	public int Countrymsgfromid = 0;
	public int Worldmsgfromid = 0;
	//public int Rolemsgfromid = 0;

	public int sysmsgtoid = 0;
	public int Countrymsgtoid = 0;
	public int Worldmsgtoid = 0;
	//public int Rolemsgtoid = 0;

	public int smallshowmsgfromid = 0;
	public int smallshowmsgtoid = 0;

	//界面相关
	public bool showChatNow = false;
	public GameObject chatprefab;	//聊天物件 挂在UI 摄像机下面
	public GameObject chatobj;
	public UIChatMag MyUIChatMag;

	void Awake()
	{
		_ins = this;
	}

	public void IniChat(IniChatData_ inidata)
	{
		//Debug.LogError ("IniChat  IniChat name="+inidata.name+" uuid="+inidata.uuid);
        ClearAllData();

#if UNITY_EDITOR1
#else
        IniOk = false;
		MyIniChatData = inidata;
		if(MyRoleChat==null)
		{
			MyRoleChat = gameObject.GetComponent<RoleChatMag>() as RoleChatMag;
		}
        
		if(MyGroupChat==null)
		{
			MyGroupChat = gameObject.GetComponent<GroupChatMag>() as GroupChatMag;
		}

		MyRoleChat.LoginOut ();

		sysmsgfromid = 0;
		Countrymsgfromid = 0;
		Worldmsgfromid = 0;
		//Rolemsgfromid = 0;
		
		sysmsgtoid = 0;
		Countrymsgtoid = 0;
		Worldmsgtoid = 0;
		//Rolemsgtoid = 0;
		smallshowmsgfromid = 0;
		smallshowmsgtoid = 0;

		MyRoleChat.Login (MyIniChatData.name);

#endif
    }
    public bool IniOk = false;
	public int addgroupnum = 0;
	public void LoginOk(GotyeUser user)
	{
		//Debug.Log ("LoginOkLoginOkLoginOkLoginOkLoginOkLoginOk");
		MyUser = user;
		//世界频道在第一次可以打开世界频道的时候 加入到群

		//国家频道在 第一次加入国家的时候  加入到群  跟加入聊天室不一样  不用每次加入
		if ( MyUser.Info == "") {

			MyUser.Info = MyIniChatData.uuid;
			//GotyeStatusCode code = api.RequestModifyUserInfo(user,headIconPath);
			MyRoleChat.RequestModifyUserInfo (MyUser, "");
		} else {

			if (MyIniChatData.Country != -1 && MyIniChatData.countrychatid > 0) {  	//已经加入国家
				addgroupnum ++;
				MyGroupChat.GetGroupInfo (MyIniChatData.countrychatid);		//获取群信息
			}
			if (MyIniChatData.worldchatid > 0) {
				addgroupnum ++;
				MyGroupChat.GetGroupInfo (MyIniChatData.worldchatid);		//获取群信息
			}
		}
        //设置玩家额外信息
        string Myinfo = MyIniChatDataTostring (MyIniChatData);
		MyRoleChat.MyRoleInfo = Myinfo;
		MyRoleChat.MyRoleInfodata = stringToMyRoleInfoData (Myinfo);
        JointGroup();//等服务器完善后处理
    }
	public string MyIniChatDataTostring(IniChatData_ MyIniChatData)
	{
		string Myinfo = MyIniChatData.name+","+MyIniChatData.uuid+","+MyIniChatData.Country.ToString()+","+MyIniChatData.lvl.ToString()+","+MyIniChatData.qulity.ToString()+","+MyIniChatData.headspid+","+MyIniChatData.country_atlas+","+MyIniChatData.country_sp+","+MyIniChatData.vip.ToString();
		return Myinfo;
	}

	public string MyRoleInfoDataTostring(MyRoleInfoData_ MyIniChatData)
	{
		string Myinfo = MyIniChatData.name+","+MyIniChatData.uuid+","+MyIniChatData.Country.ToString()+","+MyIniChatData.lvl.ToString()+","+MyIniChatData.qulity.ToString()+","+MyIniChatData.headspid+","+MyIniChatData.country_atlas+","+MyIniChatData.country_sp+","+MyIniChatData.vip.ToString();
		return Myinfo;
	}
	public MyRoleInfoData_ stringToMyRoleInfoData(string Myinfo)
	{
		MyRoleInfoData_ result = new MyRoleInfoData_();
		string[] temp = Myinfo.Split (',');
        result.name =temp[0];	//名字
		result.uuid =temp[1];		//账号ID  防止查找用
		result.Country=int.Parse(temp[2]);//所属国家 -1 还没有加入国家
		
		result.lvl=int.Parse(temp[3]);		//等级
		result.qulity=int.Parse(temp[4]);	//品质
		
		result.headspid=int.Parse(temp[5]); //品质

        result.head_atlas = temp[5];
        result.head_sp = temp[6];
        result.country_atlas=temp[6];
		result.country_sp=temp[7];
		result.vip=int.Parse(temp[8]);//vip
		return result;
	}

	public void onModifyUserInfo(GotyeStatusCode code,GotyeUser user)
	{
		MyUser = user;
		if (MyIniChatData.Country != -1 && MyIniChatData.countrychatid > 0) {  	//已经加入国家
			addgroupnum ++;
		}
		if (MyIniChatData.worldchatid > 0) {
			addgroupnum ++;
		}
		if (MyIniChatData.Country != -1 && MyIniChatData.countrychatid > 0) {  	//已经加入国家

			MyGroupChat.GetGroupInfo (MyIniChatData.countrychatid);		//获取群信息
		}
		if (MyIniChatData.worldchatid > 0) {

			MyGroupChat.GetGroupInfo (MyIniChatData.worldchatid);		//获取群信息
		}
	}


	public void GetGroupInfo(GotyeGroup group)
	{
		if (group.ID == MyIniChatData.countrychatid)
		{
			addgroupnum --;
			Countrygroup = group;
			//加入群
			MyRoleChat.JoinGroup(Countrygroup);
		}
		else if (group.ID == MyIniChatData.worldchatid)
		{
			addgroupnum --;
			Worldgroup = group;
			MyRoleChat.JoinGroup(Worldgroup);
			//加入群
		}
		if(addgroupnum==0)
		{
			IniOk = true;
		}
	}

    public void LeaveGroup()
    {
        var group =  MyGroupChat.GetGroupInfo(MyIniChatData.countrychatid);
        MyRoleChat.LeaveGroup(group);
    }

    private void JointGroup()
    {
        var group = MyGroupChat.GetGroupInfo(MyIniChatData.countrychatid);
        Countrygroup = group;
        MyRoleChat.JoinGroup(group);
        var worldGroup = MyGroupChat.GetGroupInfo(MyIniChatData.worldchatid);
        Worldgroup = worldGroup;
        MyRoleChat.JoinGroup(Worldgroup);
    }
	//type = 0 缩略聊天面板  1 系统  2 国家 3 世界 4 私聊 5 个人聊天
	public void OpenChat(GameObject chatroot,int type)
	{
		//Debug.LogError ("OpenChat  OpenChat");
		showChatNow = true;
		if (chatobj == null) {
			chatobj = GameObject.Instantiate (chatprefab);
			chatobj.transform.parent = chatroot.transform;
			chatobj.transform.localPosition = Vector3.zero;
			chatobj.transform.localScale = Vector3.one;
			MyUIChatMag = chatobj.GetComponent<UIChatMag>() as UIChatMag;
			MyUIChatMag.IniSome(this);
		}
		
		chatroot.SetActive(true);
		MyUIChatMag.ShowUI (type);
		
	}
	
	//clear ==true 删除物件 比如进战斗清场景了  clear==false 只是隐藏
	public void CloseChat(bool clear)
	{
		//Debug.LogError ("CloseChat  CloseChat  clear="+clear.ToString());
		showChatNow = false;
		if (clear == true) {
			//清楚各种记录列表
			if(MyUIChatMag!=null)
			{
				MsgData_ thisdata;
				for(int i =0;i<CountrymsgList.Count;i++)
				{
					thisdata = CountrymsgList[i];
					if(thisdata.showitem!=null)	//加载的物件要释放
					{
						MyUIChatMag.DieChatitem(thisdata.showitem,2);
					}
					thisdata.showitem =null;
					CountrymsgList[i] = thisdata;
				}
				for(int i =0;i<WorldmsgList.Count;i++)
				{
					thisdata = WorldmsgList[i];
					if(thisdata.showitem!=null)	//加载的物件要释放
					{
						MyUIChatMag.DieChatitem(thisdata.showitem,3);
					}
					thisdata.showitem=null;
					WorldmsgList[i] = thisdata;
				}
				/*
				for(int i =0;i<RolemsgList.Count;i++)
				{
					thisdata = RolemsgList[i];
					if(thisdata.showitem!=null)	//加载的物件要释放
					{
						MyUIChatMag.DieChatitem(thisdata.showitem,4);
					}
					thisdata.showitem=null;
					RolemsgList[i]=thisdata;
				}
				*/
			}
          
            MyUIChatMag = null;
			if(chatobj!=null)
			{
            	Destroy(chatobj.gameObject);
			}
            chatobj = null;
        } else {
			chatobj.SetActive(false);
		}
	}



	//修改角色信息  包括加入国家  设置禁言权限
	public void SetChatfblvl(int lvl , int Country , int commandId , string name)
	{
		/*
        MyIniChatData.headspid = commandId;
		MyIniChatData.chatfblvl = lvl;
        MyIniChatData.Country = Country;
        MyIniChatData.name = name;
        LeaveGroup();

        var ceshiCountryId = 0;
        //测试用
        switch (MyIniChatData.Country)//1 ， 2 ，3 ，4 蜀 魏 吴 中立
        {
            case 1:
                ceshiCountryId = 524213;
                break;
            case 2:
                ceshiCountryId = 524209;
                break;
            case 3:
                ceshiCountryId = 524211;
                break;
        }

        MyIniChatData.countrychatid = ceshiCountryId;//国家聊天房间id
        MyIniChatData.worldchatid = 476672;//worldChatId;   //世界聊天室id
        JointGroup();
        */
    }

	//通知莫人禁言
	public void FbRole(string uuid,bool set)
	{
		//发送服务器 禁言某人
	}


	//通知被禁言
	public void BeFbTalk(string byuuid,bool set)
	{
		MyIniChatData.countrychatfb = set;
		//通知禁言被更改

		//通知UI
	}

	//发送消息回调给自己  成功  显示到界面
	public void onSendMessage(GotyeMessage message)
	{

		//发送成功的文本
		//System.Object[] args = new System.Object[3];
		//args[0] = (int)message.Receiver.Type + 1;
		//args[1] = (int)message.Type + 1;
		//args[2] = message;
		//通知界面显示
		//lgNoDelCsFun.Ins.Call(lgNoDelCsFun.Ins.mainlua, "GameMain.ChatSysSendMessage", args);
		onReceiveMessage (message);
	}

	//接收到别人发送过来的消息  开始分发消息
	public void onReceiveMessage(GotyeMessage message)
	{
		Debug.LogError ("onReceiveMessage  message.Receiver.ID =="+message.Receiver.ID.ToString()+" MyIniChatData.countrychatid="+MyIniChatData.countrychatid.ToString());
		if (message.Receiver.Type == GotyeChatTargetType.GotyeChatTargetTypeUser) //私人消息
		{
			GetPrivateMsg(message);
		}

		if (message.Receiver.Type == GotyeChatTargetType.GotyeChatTargetTypeGroup) 
		{
			if(message.Receiver.ID == MyIniChatData.countrychatid)
			{
				GetCountryMsg(message);
			}
			if(message.Receiver.ID == MyIniChatData.worldchatid)
			{
				GetWorldMsg(message);
			}
		}




		MsgData_ newdata = new MsgData_ ();
		newdata.msg = message;
		newdata.showitem = null;
		smallshowmsgList.Add (newdata);

		smallshowmsgtoid++;

		//当前打开聊天界面 通知
		if(showChatNow==true&&MyUIChatMag!=null)
		{
			MyUIChatMag.AddsmMsg(newdata,smallshowmsgList.Count-1);
		}

		if(smallshowmsgList.Count>smallmsgnum)
		{
			if(showChatNow==true&&smallshowmsgList[0].showitem!=null)	//加载的物件要释放
			{
				MyUIChatMag.DieChatitem(smallshowmsgList[0].showitem,0);
			}
			smallshowmsgList.RemoveAt(0);

			smallshowmsgfromid ++;

		}


	}
	//接收系统消息
	public void GetSysMsg()
	{

		
		//通知UI
	}


	
	//接收私聊
	public void GetPrivateMsg(GotyeMessage message)
	{
		//Rolemsgtoid = 0;
		MsgData_ newdata = new MsgData_ ();
		newdata.msg = message;
		newdata.showitem = null;


		string belongto = "";
		if (message.Sender.Info == MyUser.Info) {	//自己说的话

			belongto = message.Receiver.Info;
		} else {
			belongto = message.Sender.Info;
		}
		List<MsgData_> thisrole;
		if (PrivateChatMsg.TryGetValue (belongto, out thisrole) == true) {
			thisrole.Add (newdata);
		} else {
			thisrole = new List<MsgData_>();
			thisrole.Add (newdata);
			PrivateChatMsg.Add(belongto,  thisrole);

			string str= System.Text.Encoding.UTF8.GetString(message.ExtraData);

			MsgData2_ showdata = new MsgData2_();
			showdata.info = belongto;
			showdata.showitem = null;
			showdata.showdata = stringToMyRoleInfoData(str);

			RolemsgList.Add(showdata);
			//PrivateChatRoleList.Add();
			//Rolemsgtoid++;

		}

		//显示红点 提示



		//RolemsgList.Add (newdata);
		//Rolemsgtoid++;
		//if(RolemsgList.Count>Rolemsgnum)
		//{

		//	if(RolemsgList[0].showitem!=null)	//加载的物件要释放
		//	{
		//		MyUIChatMag.DieChatitem(RolemsgList[0].showitem,4);
		//	}
		//	RolemsgList.RemoveAt(0);
		//	Rolemsgfromid ++;
		//}
	}


	//删除全部私聊记录
	public void DelAllPrivate()
	{
		//通知界面删除
		for(int i=0;i<RolemsgList.Count;i++)
		{
			MyUIChatMag.DieChatitem2(RolemsgList[i].showitem);
		}
		RolemsgList.Clear ();
		PrivateChatMsg.Clear ();
        
	}
	//删除某个人私聊记录
	public void DelOnePrivateRole(string info)
	{
		//PrivateChatRoleList.Remove (info);

		PrivateChatMsg.Remove (info);
		//通知界面删除
		
	}
	//接收国家聊天
	public void GetCountryMsg(GotyeMessage message)
	{
		//Countrymsgtoid = 0;
		MsgData_ newdata = new MsgData_ ();
		newdata.msg = message;
		newdata.showitem = null;
		CountrymsgList.Add (newdata);
		Countrymsgtoid++;
		if(CountrymsgList.Count>Countrymsgnum)
		{
			if(CountrymsgList[0].showitem!=null)	//加载的物件要释放
			{
				MyUIChatMag.DieChatitem(CountrymsgList[0].showitem,2);
			}
			CountrymsgList.RemoveAt(0);

			Countrymsgfromid ++;
		}

	}
	//接收世界聊天
	public void GetWorldMsg(GotyeMessage message)
	{
		//Worldmsgtoid = 0;
		MsgData_ newdata = new MsgData_ ();
		newdata.msg = message;
		newdata.showitem = null;
		WorldmsgList.Add (newdata);
		Worldmsgtoid++;
		if(WorldmsgList.Count>Worldmsgnum)
		{
			if(WorldmsgList[0].showitem!=null)	//加载的物件要释放
			{
				MyUIChatMag.DieChatitem(WorldmsgList[0].showitem,3);
			}
			WorldmsgList.RemoveAt(0);
			Worldmsgfromid ++;
		}
	}
	//发送私聊
	public void SendPrivateMsg(string content, string userId)
	{
		MyRoleChat.SendTextToRole (content, userId);
	}


	public void SendGroupMsg_Guojia(string content)
	{
		if (MyIniChatData.countrychatfb == false) {
			MyRoleChat.SendTextToGroup (content, Countrygroup);
		} else {

			//提示被禁言
		}
	}
	public void SendGroupMsg_Shijie(string content)
	{
		MyRoleChat.SendTextToGroup (content, Worldgroup);
	}

	//发送世界聊天 国家聊天
	public void SendGroupMsg(long id ,string content)
	{
		if(id == MyIniChatData.countrychatid&&MyIniChatData.countrychatfb==false)
		{
			MyRoleChat.SendTextToGroup (content, Countrygroup);
		}
		if(id == MyIniChatData.worldchatid)
		{
			MyRoleChat.SendTextToGroup (content, Worldgroup);
		}

	}

	//语音接口
	public void StartTalkToRole(string userId)
	{
		MyRoleChat._StartTalkToRole (userId);

	}

	public void StartTalkToGruop_Guojia()
	{
		if(MyIniChatData.countrychatfb==false)
		{
			MyRoleChat._StartTalkToGruop (Countrygroup);
		}

	}
	public void StartTalkToGruop_Shijie()
	{
		MyRoleChat._StartTalkToGruop (Worldgroup);
	}
	public void StartTalkToGruop(long id)
	{
		if(id == MyIniChatData.countrychatid&&MyIniChatData.countrychatfb==false)
		{
			MyRoleChat._StartTalkToGruop (Countrygroup);
		}
		if(id == MyIniChatData.worldchatid)
		{
			MyRoleChat._StartTalkToGruop (Worldgroup);
		}
	}
	public void StopTalk()
	{
		MyRoleChat._StopTalk ();
	}

	public void _PlayAudio(GotyeMessage message)
	{
		MyRoleChat._PlayAudio (message);
	}

    /// <summary>
    /// 是否加入了国家
    /// </summary>
    /// <returns></returns>
    public bool GetMyCountroy()
    {
        if (MyIniChatData.Country == -1)
            return false;
        return true;
    }
	public bool IsPlayself(string uuid)
	{

		return MyUser.Info == uuid;
	}
}
