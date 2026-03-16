using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using gotye;


//extraData = lgNoDelCsFun.Ins:GetStringFromBytes(message:GetExtraData()) 
public class UIChatMag : MonoBehaviour {


	public lgChatMag MylgChatMag;
	public BtUIEventListener sysbt;			//系统
	public BtUIEventListener guojiabt;		//国家
	public BtUIEventListener shijiebt;		//世界
	public BtUIEventListener siliaobt;		//私聊
	public BtUIEventListener fanhuibt;		//返回


	public GameObject sysbg;			//系统
	public GameObject guojiabg;		//国家
	public GameObject shijiebg;		//世界
	public GameObject siliaobg;		//私聊

	public GameObject sysbg_choose;			//系统
	public GameObject guojiabg_choose;		//国家
	public GameObject shijiebg_choose;		//世界
	public GameObject siliaobg_choose;		//私聊


	public int NowShowType = -1;	//0 小面板  1 系统 2国家 3世界  4私聊 5 跟某人聊天

	public GameObject bigshow;
	public GameObject smallshow;


	public GameObject syschatroot;
	public GameObject guojiachatroot;
	public GameObject shijiechatroot;
	public GameObject siliaochatroot;
	public GameObject Rolechatroot;		//和某人聊天

	public UIGrid syschatgrid;
	public UIGrid guojiachatgrid;
	public UIGrid shijiechatgrid;
	public UIGrid siliaochatgrid;
	public UIGrid Rolechatgrid;		//和某人聊天

	//public int guojiamsgidf=0;
	public int guojiamsgidt=0;
	public int shijieamsgidt=0;
	public int siliaomsgidt=0;

	public GameObject msg1objp ; //左边显示	prefab  显示内容 别人消息  和自己消息
	public GameObject msg2objp ; //右边显示
	public GameObject siliaoobjp ; //私聊显示
	private List<chatitem> countrymsgshowlist = new List<chatitem> ();

	private List<chatitem> diemsg1list = new List<chatitem> ();  	//左边显示
	private List<chatitem> diemsg2list = new List<chatitem> ();		//右边显示
	private List<siliaoitem> rolemsglist = new List<siliaoitem> ();		// 私聊显示


	//大面板的上部
	public GameObject top_guojia; //国家自动播放
	public GameObject top_shijie;	//世界自动播放
	public GameObject top_siliao;	//私聊
	public GameObject top_role;		//个人


	public BtUIEventListener roleshanchujilubt;		//删除记录 个人聊天里面
	public BtUIEventListener rolefanhuibt;		//返回 个人聊天里面
	public UILabel TalkToName;		//个人聊天里面 人物名字
	//大面板的底部
	public GameObject dibuobj;
	public GameObject haojiaoobj;
	public UILabel haojiaolab;
	public UILabel saylab;
	public BtUIEventListener shuohuabt;		//说话
	public BtUIEventListener fasongbt;		//发送


	//私聊界面
	public BtUIEventListener shanchujilubt;		//删除记录	私聊界面
	public string showroleinfo;		//当前聊天对象 uuid

	public GameObject bigplanzhedang;

    [Header("进入聊天系统")]
    public BtUIEventListener enterChatSys;
    private string normalInfo = "点击输入文字            ";

	public void IniSome(lgChatMag ChatMag)
	{
		MylgChatMag = ChatMag;
		sysbt.onClick = OnC_Sys;			//系统
		guojiabt.onClick =OnC_guojia;		//国家
		shijiebt.onClick = OnC_shijie;		//世界
		siliaobt.onClick = OnC_siliao;		//私聊
		fanhuibt.onClick = OnC_fanhui;		//返回
        enterChatSys.onClick = OpenChatSys;//打开大的面板

        if (shanchujilubt!=null)
		{
			shanchujilubt.onClick = OnC_Shanchu;		//删除记录
		}
		NowShowType = -1;

		guojiamsgidt=0;
		shijieamsgidt=0;
		siliaomsgidt=0;

		shuohuabt.onPress =OnC_shuohua;
		fasongbt.onClick =OnC_fasong;

		sm_shuohuabt.onClick =Onsm_shuohua;		//打开私聊界面
		sm_guojiabt.onPress =Onsm_guojia;		//发送国家说话
		sm_shijiebt.onPress =Onsm_shijie;		//发送世界说话

		roleshanchujilubt.onClick =OnC_TopShanchujilu;		//删除记录 个人聊天里面
		rolefanhuibt.onClick =OnC_Topfanhui;		//返回 个人聊天里面

		Tp_liaotbt.onClick =cb_tp_liaotian;		//聊天
		Tp_jiahaoyoubt.onClick =cb_tp_jiahaoyou;	//加为好友
		Tp_chakanbt.onClick =cb_tp_chakan;		//查看
		Tp_pingbibt.onClick =cb_tp_pingbi;		//屏蔽
		Tp_jinyanbt.onClick =cb_tp_jinyan;		//禁言
		Tp_Closebt.onClick =cb_tp_CloseRoleTipPlan;	//关闭角色显示面板
	}

	
	// Update is called once per frame
	void Update () {
		//每帧更新一条消息
		switch(NowShowType)
		{
		case -1:

			break;
		case 0:

			break;
		case 1:

			//显示系统

			break;
		case 2:

			//显示国家
			updatecountry();
			break;
		case 3:

			//显示世界
			updateWorld();
			break;
		case 4:

			//显示私聊
			updateRole();
			break;
		case 5:	
			
			//显示个人聊天
			updateOneRole();
			break;
		}
	}

	//public int huancunnum = 10; //缓存删除消息数量
	void updatecountry()
	{

		//if(guojiamsgidf<MylgChatMag.Countrymsgfromid-huancunnum)	//比缓存的还小  则把以前的消息删除
		//{

		//}
		if(guojiamsgidt<MylgChatMag.Countrymsgfromid)
		{
            //
			guojiamsgidt = MylgChatMag.Countrymsgfromid;
		}
		if(guojiamsgidt<MylgChatMag.Countrymsgtoid)
		{
			//增加一条
			int id = guojiamsgidt-MylgChatMag.Countrymsgfromid;
			MsgData_  usedata = MylgChatMag.CountrymsgList[id];
			chatitem item =GetOneChatitem(usedata.msg);
			usedata.showitem= item;
			MylgChatMag.CountrymsgList[id] = usedata;
			//countrymsgshowlist.Add(item);
			item.gameObject.name = guojiamsgidt.ToString();
			item.gameObject.SetActive (true);
			item.gameObject.transform.parent = guojiachatgrid.gameObject.transform;
			item.gameObject.transform.localScale = Vector3.one;
			guojiamsgidt++;
			guojiachatgrid.Reposition();
		}

	}
	void updateWorld()
	{
		if(shijieamsgidt<MylgChatMag.Worldmsgfromid)
		{
			
			shijieamsgidt = MylgChatMag.Worldmsgfromid;
		}
		if(shijieamsgidt<MylgChatMag.Worldmsgtoid)
		{
			//增加一条
			int id = shijieamsgidt-MylgChatMag.Worldmsgfromid;

			MsgData_  usedata = MylgChatMag.WorldmsgList[id];
			chatitem item =GetOneChatitem(usedata.msg);
			usedata.showitem= item;
			MylgChatMag.WorldmsgList[id] = usedata;

			//countrymsgshowlist.Add(item);
			item.gameObject.name = shijieamsgidt.ToString();
			item.gameObject.SetActive (true);
			item.gameObject.transform.parent = shijiechatgrid.gameObject.transform;
			item.gameObject.transform.localScale = Vector3.one;
			shijieamsgidt++;
			shijiechatgrid.Reposition();
		}
		
	}
    
	bool temp_hasupdaterole =false;
	void updateRole()
	{
		temp_hasupdaterole =false;
		for(int i =0;i< MylgChatMag.RolemsgList.Count;i++)
		{
			MsgData2_ temp = MylgChatMag.RolemsgList[i];
			if(temp.showitem==null)
			{
				temp.showitem =GetOneChatitem2(MylgChatMag.RolemsgList[i].showdata);
				temp.showitem.gameObject.name = i.ToString();
				temp.showitem.gameObject.SetActive (true);
				temp.showitem.gameObject.transform.parent = siliaochatgrid.gameObject.transform;
				temp.showitem.gameObject.transform.localScale = Vector3.one;
				MylgChatMag.RolemsgList[i] = temp;
				temp_hasupdaterole =true;
			}
		}
		if(temp_hasupdaterole ==true)
		{
			siliaochatgrid.Reposition();
		}
		/*
		if(siliaomsgidt<MylgChatMag.Rolemsgtoid)
		{
			//增加一条
			int id = siliaomsgidt-MylgChatMag.Rolemsgfromid;
			chatitemdata_
			MsgData2_  usedata = MylgChatMag.RolemsgList[id];
			siliaoitem item =GetOneChatitem2(usedata.info);
			usedata.showitem= item;
			MylgChatMag.RolemsgList[id] = usedata;

			//countrymsgshowlist.Add(item);
			item.gameObject.name = siliaomsgidt.ToString();
			item.gameObject.SetActive (true);
			item.gameObject.transform.parent = siliaochatroot.transform;
			item.gameObject.transform.localScale = Vector3.one;
			siliaomsgidt++;
		}
		*/
	}
	private List<MsgData_> tempshowOneRole = new List<MsgData_>();
	void updateOneRole()
	{
		//showroleinfo
		if(showroleinfo=="")
		{
			return;
		}
		tempshowOneRole = null;

		MylgChatMag.PrivateChatMsg.TryGetValue (showroleinfo,out tempshowOneRole);
		if(tempshowOneRole==null)
		{
			return;
		}
		temp_hasupdaterole = false;
		for(int i =0;i< tempshowOneRole.Count;i++)
		{
			MsgData_ usedata = tempshowOneRole[i];
			if(usedata.showitem==null)
			{
				chatitem item =GetOneChatitem(usedata.msg);
				usedata.showitem= item;
				tempshowOneRole[i] = usedata;
				
				//countrymsgshowlist.Add(item);
				item.gameObject.name = shijieamsgidt.ToString();
				item.gameObject.SetActive (true);
				item.gameObject.transform.parent = Rolechatgrid.gameObject.transform;
				item.gameObject.transform.localScale = Vector3.one;
				temp_hasupdaterole = true;
			}
		}
		if (temp_hasupdaterole == true) {
			Rolechatgrid.Reposition ();
		}
		//if(guojiamsgidf<MylgChatMag.Countrymsgfromid-huancunnum)	//比缓存的还小  则把以前的消息删除
		//{
		
		//}
		/*
		if(siliaomsgidt<MylgChatMag.Rolemsgfromid)
		{
			siliaomsgidt = MylgChatMag.Rolemsgfromid;
		}
		if(siliaomsgidt<MylgChatMag.Rolemsgtoid)
		{
			//增加一条
			int id = siliaomsgidt-MylgChatMag.Rolemsgfromid;
			
			MsgData_  usedata = MylgChatMag.RolemsgList[id];
			chatitem item =GetOneChatitem(usedata.msg);
			usedata.showitem= item;
			MylgChatMag.RolemsgList[id] = usedata;
			
			//countrymsgshowlist.Add(item);
			item.gameObject.name = siliaomsgidt.ToString();
			item.gameObject.SetActive (true);
			item.gameObject.transform.parent = siliaochatroot.transform;
			item.gameObject.transform.localScale = Vector3.one;
			siliaomsgidt++;
		}
		*/
	}
	//聊天里显示物件  分左右边
	public chatitem GetOneChatitem(GotyeMessage message)
	{
		if (message.Sender.Info == MylgChatMag.MyUser.Info) //自己发的
		{	
			return GetOneChatitemByType(message,2);
		} 
		else 
		{
			return GetOneChatitemByType(message,1);
		}
		/*
		chatitemdata_ data;
		if (message.Receiver.Type == GotyeChatTargetType.GotyeChatTargetTypeUser) //私人消息
		{

		}

		if (message.Receiver.Type == GotyeChatTargetType.GotyeChatTargetTypeGroup) 
		{
			if(message.Receiver.ID == MylgChatMag.MyIniChatData.countrychatid)
			{

			}
			if(message.Receiver.ID == MylgChatMag.MyIniChatData.worldchatid)
			{

			}
		}
		result.IniShow (data);
		*/

		return null;
	}

	public chatitem GetOneChatitemByType(GotyeMessage message,int type)
	{
		chatitem result;
		if (type == 2) //左边
		{
            if (diemsg1list.Count>0)
			{
				result = diemsg1list[0];
				diemsg1list.RemoveAt(0);
			}
			else
			{
				GameObject newone = GameObject.Instantiate(msg1objp);
				result = newone.GetComponent<chatitem>() as chatitem;
				result.MyUIChatMag =this;
				result.type = 1;
			}
		} 
		else 	//右边
		{
			if(diemsg2list.Count>0)
			{
				result = diemsg2list[0];
				diemsg2list.RemoveAt(0);
			}
			else
			{
				GameObject newone = GameObject.Instantiate(msg2objp);
				result = newone.GetComponent<chatitem>() as chatitem;
				result.MyUIChatMag =this;
				result.type = 2;
				
			}
		}

		result.IniShowByMsg (message);
		return result;
	}

	//私聊界面用创建物件
	public siliaoitem GetOneChatitem2(MyRoleInfoData_ data)
	{
		
		siliaoitem result;


		if(rolemsglist.Count>0)
		{
			result = rolemsglist[0];
			rolemsglist.RemoveAt(0);
		}
		else
		{
			GameObject newone = GameObject.Instantiate(siliaoobjp);
			result = newone.GetComponent<siliaoitem>() as siliaoitem;
			result.MyUIChatMag =this;
		}

		result.IniShow(data);
		return result;
	}
    
	public void DieChatitem2(siliaoitem thisitem)
	{
		thisitem.gameObject.SetActive (false);
		thisitem.gameObject.transform.parent = null;
		rolemsglist.Add (thisitem);
	}

	//type 0 小面板  1 系统 2国家 3世界  5私聊
	public void DieChatitem(chatitem thisitem,int type)
	{
		thisitem.gameObject.SetActive (false);
		thisitem.gameObject.transform.parent = null;
		if (thisitem.type == 2) {
			diemsg2list.Add (thisitem);
		} else {
			diemsg1list.Add (thisitem);
		}
	}

	public void ShowUI(int type)
	{
		switch(type)
		{
			case -1:
				NowShowType =-1;
				//退出显示
			bigshow.SetActive(false);
			smallshow.SetActive(false);
			break;
			case 0:
			NowShowType =0;
                //显示小面板
            bigshow.SetActive(false);
			smallshow.SetActive(true);
			ShowSmPlan();
			break;
		case 1:
			NowShowType =1;
			//显示系统
			bigshow.SetActive(true);
			smallshow.SetActive(false);

			syschatroot.SetActive(true);
			guojiachatroot.SetActive(false);
			shijiechatroot.SetActive(false);
			siliaochatroot.SetActive(false);
			dibuobj.SetActive(false);

			break;
		case 2:
			NowShowType =2;
			//显示国家
			bigshow.SetActive(true);
			smallshow.SetActive(false);
			syschatroot.SetActive (false);
			guojiachatroot.SetActive (true);
			shijiechatroot.SetActive (false);
			siliaochatroot.SetActive (false);
			dibuobj.SetActive(true);
			haojiaoobj.SetActive(false);
			break;
		case 3:
			NowShowType =3;
			//显示世界
			bigshow.SetActive(true);
			smallshow.SetActive(false);
			syschatroot.SetActive (false);
			guojiachatroot.SetActive (false);
			shijiechatroot.SetActive (true);
			siliaochatroot.SetActive (false);
			dibuobj.SetActive(true);
			haojiaoobj.SetActive(true);
			break;
		case 4:
			NowShowType =4;
			//显示私聊
			bigshow.SetActive(true);
			smallshow.SetActive(false);
			syschatroot.SetActive (false);
			guojiachatroot.SetActive (false);
			shijiechatroot.SetActive (false);
			siliaochatroot.SetActive (true);
			dibuobj.SetActive(false);
			haojiaoobj.SetActive(false);
			break;
		case 5:
			NowShowType =5;
			//显示私聊 某个人
			bigshow.SetActive(true);
			smallshow.SetActive(false);

			syschatroot.SetActive (false);
			guojiachatroot.SetActive (false);
			shijiechatroot.SetActive (false);
			siliaochatroot.SetActive (true);
			dibuobj.SetActive(true);
			haojiaoobj.SetActive(false);

			break;
		}
		showbtchoose(NowShowType);
	}

	//显示系统聊天
	public void OnC_Sys(GameObject thisobj, int Order,string key)
	{
		if(NowShowType!=1)
		{
			ShowUI(1);
		}


	}

	//显示国家聊天
	public void OnC_guojia(GameObject thisobj, int Order,string key)
	{
		if (NowShowType != 2) 
		{
			ShowUI(2);
		}
	}
	//显示世界聊天
	public void OnC_shijie(GameObject thisobj, int Order,string key)
	{
		if (NowShowType != 3) {
			ShowUI(3);
		}
	}
	//显示私聊
	public void OnC_siliao(GameObject thisobj, int Order,string key)
	{
		if (NowShowType != 4) {
			ShowUI(4);
		}
	}

	public void showbtchoose(int type)
	{
		sysbg.SetActive(true);			//系统
		guojiabg.SetActive(true);		//国家
		shijiebg.SetActive(true);		//世界
		siliaobg.SetActive(true);		//私聊
		
		sysbg_choose.SetActive(false);			//系统
		guojiabg_choose.SetActive(false);		//国家
		shijiebg_choose.SetActive(false);		//世界
		siliaobg_choose.SetActive(false);		//私聊
		switch(type)
		{
		case 1:
			//显示系统
			sysbg.SetActive(false);	
			sysbg_choose.SetActive(true);
			break;
		case 2:
			//显示国家
			guojiabg.SetActive(false);	
			guojiabg_choose.SetActive(true);
			break;
		case 3:
			//显示世界
			shijiebg.SetActive(false);
			shijiebg_choose.SetActive(true);
			break;
		case 4:
			//显示私聊
			siliaobg.SetActive(false);
			siliaobg_choose.SetActive(true);
			break;
		case 5:
			//显示私聊 某个人
			siliaobg.SetActive(false);
			siliaobg_choose.SetActive(true);
			break;
		}

	}

    public void OpenChatSys(GameObject thiobj, int order, string key)
    {
        if (!lgChatMag.Ins.GetMyCountroy())
        {
            lgNoDelCsFun.Ins.PopTip("请先加入国家");
            return;
        }
        ShowUI(2);
    }


    public void OnC_fanhui(GameObject thisobj, int Order,string key)
	{
		//切换到小窗口显示聊天
		//bigshow.SetActive (false);
		//smallshow.SetActive (true);
		ShowUI (0);
	}
	public void OnC_Shanchu(GameObject thisobj, int Order,string key)
	{
		//删除记录
		MylgChatMag.DelAllPrivate ();
	}





	public void OnC_shuohua(GameObject thisobj,bool state, int Order,string key)
	{
		//开始说话
		switch(NowShowType)
		{
		case -1: //没有显示
			
			break;
		case 0: //小面板
			
			break;
		case 1:
			
			//显示系统
			
			break;
		case 2:
			if(state==true)
			{
				if(lgNoDelCsFun.Ins.Maikefeng == true)
				{
				//开始说话  显示提示
					MylgChatMag.StartTalkToGruop_Guojia();
					ShowTalkTip(true);
				}
				else
				{
					lgNoDelCsFun.Ins.PopTip("麦克风被禁用");
				}
			}
			else
			{
				if(lgNoDelCsFun.Ins.Maikefeng == true)
				{
					//停止说话
					MylgChatMag.StopTalk();
					ShowTalkTip(false);
				}
			}
			//显示国家
			//updatecountry();
			break;
		case 3:
			
			//显示世界
			if(state==true)
			{
				if(lgNoDelCsFun.Ins.Maikefeng == true)
				{
					//开始说话  显示提示
					MylgChatMag.StartTalkToGruop_Shijie();
					ShowTalkTip(true);
				}
				else
				{
					lgNoDelCsFun.Ins.PopTip("麦克风被禁用");
				}
			}
			else
			{
				if(lgNoDelCsFun.Ins.Maikefeng == true)
				{
					//停止说话
					MylgChatMag.StopTalk();
					ShowTalkTip(false);
				}
			}
			//updateWorld();
			break;
		case 4:
			
			//显示私聊
			if(state==true)
			{
				if(lgNoDelCsFun.Ins.Maikefeng == true)
				{
					//开始说话  显示提示
					//StartTalkToRole(string userId)
					ShowTalkTip(true);
				}
				else
				{
					lgNoDelCsFun.Ins.PopTip("麦克风被禁用");
				}
			}
			else
			{
				if(lgNoDelCsFun.Ins.Maikefeng == true)
				{
					//停止说话
					MylgChatMag.StopTalk();
					ShowTalkTip(false);
				}
			}
			//updateRole();
			break;
		}
	}
	public void OnC_fasong(GameObject thisobj, int Order,string key)
	{
		string str = saylab.text;
       
        //检查屏蔽字 
        if (str==""|| str == normalInfo)
		{
            lgNoDelCsFun.Ins.PopTip("请输入正确文字");
			return;
		}
        var count = lgNoDelCsFun.Ins.GetStrByteCount(str);
       
        if (count > 60)
        {
            lgNoDelCsFun.Ins.PopTip("文字过长，超过30个字");
            return;
        }
		//点击发送
		switch(NowShowType)
		{
		case -1:	//没有显示
			
			break;
		case 0:	//小面板
			
			break;
		case 1:
			
			//显示系统
			
			break;
		case 2:
			//显示国家
			MylgChatMag.SendGroupMsg_Guojia(str);
			break;
		case 3:
			
			//显示世界
			MylgChatMag.SendGroupMsg_Shijie(str);
			break;
		case 4:
			
			//显示私聊
			//updateRole();
			break;
		}
		saylab.text = "点击输入文字            ";
	}


	public void OnC_TopShanchujilu(GameObject thisobj, int Order,string key)
	{
		if(showroleinfo!="")
		{
			MylgChatMag.DelOnePrivateRole(showroleinfo);
		}
	}
	public void OnC_Topfanhui(GameObject thisobj, int Order,string key)
	{
		ShowUI (4);
	}

	//显示某人的聊天记录
	public void ShowTalkToThisRole(string roleuuid,string name)
	{
		if (roleuuid != "") {
			showroleinfo = roleuuid;
			TalkToName.text = name;
			ShowUI (5);
		} else {
			Debug.LogError("error ShowTalkToThisRole roleuuid="+roleuuid);
		}
	}


	public void _PlayAudio(GotyeMessage message)
	{
		MylgChatMag._PlayAudio (message);
	}



	//小面板相关
	public BtUIEventListener sm_shuohuabt;		//打开私聊界面
	public BtUIEventListener sm_guojiabt;		//发送国家说话
	public BtUIEventListener sm_shijiebt;		//发送世界说话
	
	public GameObject sm_Root;
	public UIGrid sm_uigrid;

   //[Header("录音中")] public GameObject SpeakingUI;

	public void ShowSmPlan()
	{
		smallshow.SetActive (true);
		//更新已有聊天消息
		updatasm ();
	}

	//public List<MsgData_> smallshowmsgList = new List<MsgData_>();		//接收所有消息 用于显示外面小面板
	public void updatasm()
	{
		for(int i =0;i< MylgChatMag.smallshowmsgList.Count;i++)
		{
			MsgData_ temp = MylgChatMag.smallshowmsgList[i];
			if(temp.showitem==null)
			{
                 Debug.Log( MylgChatMag.smallshowmsgList[i].msg);
				temp.showitem =GetOneChatitemByType(MylgChatMag.smallshowmsgList[i].msg,1);
				temp.showitem.gameObject.name = i.ToString();
				temp.showitem.gameObject.SetActive (true);
				temp.showitem.gameObject.transform.parent = sm_Root.transform;
				temp.showitem.gameObject.transform.localScale = Vector3.one;
				MylgChatMag.smallshowmsgList[i] = temp;
			}
		}
		sm_uigrid.Reposition ();
	}

    //得到返回的数据信息
    private void GetRwardMsg()
    {

    }
	//通知增加了一个小面板消息
	public void AddsmMsg(MsgData_ temp,int id)
	{
		//if(temp.showitem==null)
		//{

			temp.showitem =GetOneChatitemByType(MylgChatMag.smallshowmsgList[id].msg,1);
			temp.showitem.gameObject.name = id.ToString();
			temp.showitem.gameObject.SetActive (true);
			temp.showitem.gameObject.transform.parent = sm_Root.transform;
			temp.showitem.gameObject.transform.localScale = Vector3.one;
			MylgChatMag.smallshowmsgList[id] = temp;
		//}
		sm_uigrid.Reposition ();

	}
	//通知删除了一个小面板消息
	public void DelSmMsg()
	{

	}

	public void Onsm_shuohua(GameObject thisobj, int Order,string key)
	{
        if (!lgChatMag.Ins.GetMyCountroy())
        {
            lgNoDelCsFun.Ins.PopTip("请先加入国家");
            return;
        }
           
		ShowUI (4);
	}
	public void Onsm_guojia(GameObject thisobj,bool state, int Order,string key)
	{
        if (!lgChatMag.Ins.GetMyCountroy())
        {
            lgNoDelCsFun.Ins.PopTip("请先加入国家");
            return;
        }
        if (state==true)
		{
			//开始说话  显示提示
			MylgChatMag.StartTalkToGruop_Guojia();
			ShowTalkTip(true);
            //SpeakingUI.gameObject.SetActive(true);

        }
		else
		{
			//停止说话
			MylgChatMag.StopTalk();
			ShowTalkTip(false);
            //SpeakingUI.gameObject.SetActive(false);
        }
	}
	public void Onsm_shijie(GameObject thisobj,bool state, int Order,string key)
	{
        if (!lgChatMag.Ins.GetMyCountroy())
        {
            lgNoDelCsFun.Ins.PopTip("请先加入国家");
            return;
        }
        if (state==true)
		{
			//开始说话  显示提示
			MylgChatMag.StartTalkToGruop_Shijie();
			ShowTalkTip(true);
		}
		else
		{
			//停止说话
			MylgChatMag.StopTalk();
			ShowTalkTip(false);
		}
	}

	////玩家提示小面板
	/// 
	public GameObject TipPlanObj;
	public UISprite TP_Head;
	public UILabel Tp_Lvl;
	public UILabel Tp_name;
	public UILabel Tp_country;

	public BtUIEventListener Tp_liaotbt;		//聊天
	public BtUIEventListener Tp_jiahaoyoubt;	//加为好友
	public BtUIEventListener Tp_chakanbt;		//查看
	public BtUIEventListener Tp_pingbibt;		//屏蔽
	public BtUIEventListener Tp_jinyanbt;		//禁言

	public BtUIEventListener Tp_Closebt;		//fanhui

	private MyRoleInfoData_ Tp_RoleInfoData;
	public void ShowRoleTipPlan(MyRoleInfoData_ data)
	{
		if( MylgChatMag.IsPlayself(data.uuid)==true)
		{
			return;
		}
		Tp_RoleInfoData = data;
		TipPlanObj.SetActive (true);
		//lgNoDelCsFun.Ins.SetIcon (TP_Head,data.head_atlas,data.head_sp);
		Debug.LogError ("ShowRoleTipPlan TP_Head data.headspid="+data.headspid.ToString());
		lgNoDelCsFun.Ins.SetHeadIconById (TP_Head,data.headspid);
		Tp_Lvl.text = "Lv: "+data.lvl.ToString ();
		Tp_name.text = data.name;
		switch(data.Country)
		{
		case -1:Tp_country.text = "无";break;
		case 1:Tp_country.text = "魏";break;
		case 2:Tp_country.text = "蜀";break;
		case 3:Tp_country.text = "吴";break;
		}
		//检查是否为好友  禁用按钮

		//检查是否禁言等级  显示禁言按钮
		if(bigplanzhedang!=null)
		{
			bigplanzhedang.SetActive (true);
		}
	}

	public void cb_tp_CloseRoleTipPlan(GameObject thisobj, int Order,string key)
	{
		CloseRoleTipPlan ();

	}

	void CloseRoleTipPlan()
	{
		TipPlanObj.SetActive (false);
		if(bigplanzhedang!=null)
		{
			bigplanzhedang.SetActive (false);
		}
	}

	public void cb_tp_liaotian(GameObject thisobj, int Order,string key)
	{
		Debug.LogError ("cb_tp_liaotian uuid="+Tp_RoleInfoData.uuid+" name ="+Tp_RoleInfoData.name);
		ShowTalkToThisRole (Tp_RoleInfoData.uuid, Tp_RoleInfoData.name);
		CloseRoleTipPlan ();
	}
	public void cb_tp_jiahaoyou(GameObject thisobj, int Order,string key)
	{
        lgNoDelCsFun.Ins.AddFriend(Tp_RoleInfoData.uuid);
        CloseRoleTipPlan();

    }
	public void cb_tp_chakan(GameObject thisobj, int Order,string key)
	{
		
	}
	public void cb_tp_pingbi(GameObject thisobj, int Order,string key)
	{
		
	}
	public void cb_tp_jinyan(GameObject thisobj, int Order,string key)
	{
		
	}

	//说话提示
	public GameObject talktip;
	public void ShowTalkTip(bool isshow)
	{
		if(talktip!=null)
		{
			talktip.SetActive(isshow);
		}

	}

}
