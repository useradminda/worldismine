using UnityEngine;
using System.Collections;



public class lgsdkbase 
{
	// Use this for initialization
	//void Start () {
		
	//}
	
	// Update is called once per frame
	//void Update () {
		
	//}
	public sdktype mysdktype;
	public sdkp mysdkp;
	public string SdkCBobjname;
	public string SdkCBFunname;
	public lgSdkMag Mymag;
	//public platformDes describ;
	//public int target_id = 1;   									//< publish_target
	//public plState curPLState = new plState();						//< 描述当前状态
	//public static platformUserInfo pl_userInfo = new platformUserInfo();		//< 平台账号相关
	

	

	//初始化SDK
	public void InitSdk(lgSdkMag thismag,sdktype thissdktype,sdkp thissdkp,string thisSdkCBobjname,string thisSdkCBFunname)
	{

		mysdktype=thissdktype;
		mysdkp=thissdkp;
		Mymag = thismag;
		SdkCBobjname=thisSdkCBobjname;
		SdkCBFunname=thisSdkCBFunname;
		SonInitSdk ();
	}
	public virtual void SonInitSdk()
	{
	}


	//退出登录  游戏退出时
	public void Logout()
	{
		SonLogout();
	}
	public virtual void SonLogout()
	{

	}

	//SDK 退出登录
	public void Logout_cb_fromsdk(string msg)
	{
		SonLogout_cb_fromsdk(msg);
	}
	public virtual void SonLogout_cb_fromsdk(string msg)
	{
		
	}

	public void AskBuy(string objtypeid,string orderid)
	{
		//向服务器请求一个商品id
		/*
		int packID = packMgr.Ins.applyPackID();
		packItem pack = new packItem();
		pack.id = packID;
		pack.M = "shop";
		pack.A = "generateOrder";
		pack.P = objtypeid.ToString();
		pack.setCallBack(svCB_buyobjuuid);
		packMgr.Ins.limitSendPack(pack);
		*/
		SonAskBuy (objtypeid, orderid);

	}
	public virtual void SonAskBuy(string objtypeid,string orderid)
	{

	}
	/*
	public void svCB_buyobjuuid(string data, string lucab , int returnID, string error , packItem pack)
	{

		SonsvCB_buyobjuuid  (data,  lucab ,  returnID,  error ,  pack);

	}
	public virtual void SonsvCB_buyobjuuid(string data, string lucab , int returnID, string error , packItem pack)
	{

	}
*/

	public void Get_Sdk_Msg(string msg)
	{
		//Debug.LogError ("Get_Sdk_Msg  msg="+msg);
		string[] msgtemp = msg.Split (':');
	
		if(msgtemp.Length<=0)
		{
			Debug.LogError("xcdoe 传回的消息错误： " + msg);
			return ;
		}
		string op = msgtemp[0];
		switch(op)
		{
		case "IniOk":
			Do_IniOk();
			break;
			
		case "IniOk_NoBuy":
			Do_IniOk_NoBuy();
			break;

		case "CB_Login_Result":				
			Do_Login_Result();
			break;
		case "CB_Loginout_user":				
			Do_Login_Result();
			break;

		case "CB_NoBuyObj":
			Do_NoBuyObj(msgtemp[1]);
			break;
			
		case "CB_Buy_Finish":
			Do_Buy_Finish(msgtemp[1],msgtemp[2],msgtemp[3]);
			break;
			
			
		case "CB_Buy_Restored":
			Do_Buy_Restored(msgtemp[1]);
			break;
			
		case "CB_Buy_Failed":
			Do_Buy_Failed(msgtemp[1]);
			break;
			
		case "CB_Buy_Failed_cancel":
			Do_Buy_Failed_cancel(msgtemp[1]);
			break;

		case "MaikefengNo":
			lgNoDelCsFun.Ins.Maikefeng = false;
			break;

		case "MaikefengYes":
			lgNoDelCsFun.Ins.Maikefeng = true;
			break;
			
		}

		SonGet_Sdk_Msg( msg);
	}
	public virtual void SonGet_Sdk_Msg(string msg)
	{

	}

	public  void Do_IniOk()
	{
		if (mysdktype == 0) {	//mei you sdk
			//kaishiyouxi
			Mymag.NoSdk_IniOk_ (true);
		} else {
			Mymag.Sdk_IniOk_ (true);

		}


		SonDo_IniOk ();
	}
	public virtual void SonDo_IniOk()
	{

	}

	public  void Do_IniOk_NoBuy()
	{
		if(mysdktype==0)	//mei you sdk
		{
			//kaishiyouxi
			Mymag.NoSdk_IniOk_(false);
		}
		else {
			Mymag.Sdk_IniOk_ (false);
			
		}
		SonDo_IniOk_NoBuy ();
	}
	public virtual void SonDo_IniOk_NoBuy()
	{
		
	}

	public  void Do_Login_Result()
	{
		SonDo_Login_Result();
	}
	public virtual void SonDo_Login_Result()
	{
		
	}

	public  void Do_Loginout_user()
	{
		SonDo_Loginout_user();
	}
	public virtual void SonDo_Loginout_user()
	{
		
	}

	public  void Do_NoBuyObj(string objtypeid)
	{
		SonDo_NoBuyObj(objtypeid);
	}
	public virtual void SonDo_NoBuyObj(string objtypeid)
	{
		
	}

	public  void Do_Buy_Finish(string objtypeid,string receipt,string issandbox)
	{
		SonDo_Buy_Finish( objtypeid, receipt,issandbox);
	}
	public virtual void SonDo_Buy_Finish(string objtypeid,string receipt,string issandbox)
	{
		
	}

	public  void Do_Buy_Restored(string objtypeid)
	{
		SonDo_Buy_Restored(objtypeid);
	}
	public virtual void SonDo_Buy_Restored(string objtypeid)
	{
		
	}

	public  void Do_Buy_Failed(string objtypeid)
	{
		SonDo_Buy_Restored( objtypeid);
	}
	public virtual void SonDo_Buy_Failed( string objtypeid)
	{
		
	}

	public virtual void Do_Buy_Failed_cancel(string objtypeid)
	{
		SonDo_Buy_Failed_cancel( objtypeid);
	}
	public virtual void SonDo_Buy_Failed_cancel(string objtypeid)
	{
		
	}
	


	//public virtual void ask_buy_goods_imp(int goods_id)
	//{
		
	//}
	//public void ask_buy_goods(int goods_id,packItemCallback ptCall)
	//{
	//	int packID = packMgr.Ins.applyPackID();
	//	packItem pack = new packItem();
	//	pack.id = packID;
	//	pack.M = "shop";
	//	pack.A = "generateOrder";
	//	pack.P = goods_id.ToString();
		//pack.setCallBack(ptCall);
		//packMgr.Ins.limitSendPack(pack);
		//Loading.Ins.StartLoading();
	//}
	//public virtual float do_buy_goods(int succ,IDictionary netMsg,packItem pack)
	//{
		//Loading.Ins.StopLoading();
		//if(succ == 0)
		//{
		//	string order = System.Convert.ToString(netMsg["order_num"]);
		//	if(order == "0")
		//	{
		//		Debug.LogError("生成订单号失败.....");
		//		return -1;
		//	}
		//	Debug.LogError("本次生成的订单号： " + order);
		//	int goods_id = int.Parse(pack.P);
		//	shopItemDb goods = goodsDB.Ins.getRMBGoods(goods_id);
		//	if(goods == null)
		//	{
		//		Debug.LogError("没有该商品,购买失败： " + goods_id);
		//		return -2;
		//	}
		//          float rmb = goods.renmingbi;
		//	return rmb;
		//}
		//else
		//{
		//	Debug.LogError("订单号生成失败...");
		//	return -5;
		//}
		//return 0;
		
	//}
	/*
	public string is_ylt_299()
	{
		string is_ylt_299 = "0";
		if (Application.platform == RuntimePlatform.Android) 
		{
			Object oReader = Resources.Load("Settings/updateSrvIP");
			string sReadLine = oReader.ToString();
			string [] Temp = sReadLine.Split(new char[2]{'\r','\n'});
			for(int i=0;i<Temp.Length;i++)
			{
				string[] content = Temp[i].Split('=');
				if(content.Length == 2)
				{
					if(content[0] == "is_ylt_299")
					{
						is_ylt_299 = content[1];
						break;
					}
				}
			}
		}
		else
		{
			string path = Application.streamingAssetsPath + "//updateSrvIP.txt";		
			string[] Temp =  System.IO.File.ReadAllLines(path);
			for(int i=0;i<Temp.Length;i++)
			{
				string[] content = Temp[i].Split('=');
				if(content.Length == 2)
				{
					if(content[0] == "is_ylt_299")
					{
						is_ylt_299 = content[1];
						break;
					}
				}
			}
		}
		
		return is_ylt_299;
	}
	*/
	//< 登陆游戏服务器
	//public virtual void ask_login_gameServer()
	//{		
		//if(curPLState.state == (int)pl_state.pl_login_Over)
		//{
		//	if(curPLState.param == "1")
		//	{				
		//		if(is_ylt_299() == "1")
		//		{
		//			int hefa = configVerifyMgr.Ins.is_hefaxing_juge();
		//			if(hefa == 0)
		//			{
		//				return;
		//			}
		//                  else if (hefa == 1)
		//                  {
		//                      imp_login_gameServer();
		//                      return;
		//                  }
		//                  else if (hefa == 2)
		//                  {
		//                      //NoticeMsg.Ins.CallNoticeMsg("客户端需要更新", this.do_update_clinet_by_user);
		//                     // NoticeMsg.Ins.GrayPanel.SetActive(true);
		//                  }
		//		}
		//              if (platformSys.Ins.cur_users == users_type.ut_app)
		//              {
		//                  int hefa = configVerifyMgr.Ins.is_hefaxing_juge();
		//                  if (hefa == 0)
		//                  {
		//                      NoticeMsg.Ins.CallNoticeMsg(UIStringMag.inst.server_err_2, this.do_update_clinet_by_user);
		//                      NoticeMsg.Ins.GrayPanel.SetActive(true);
		//                     // Application.OpenURL(configVerifyMgr.Ins.store_kuku);
		//                      return;
		//                  }
		//                  else if (hefa == 1)
		//                  {
		//                      imp_login_gameServer();
		//                      return;
		//                  }
		//                  else if (hefa == 2)
		//                  {
		
		//                  }
		//              }
		//              imp_login_gameServer();
		
		//	}
		//	else
		//	{
		//		Debug.LogError("平台登陆失败");
		//		Debug.LogError("curPLState.state: " + curPLState.state + "curPLState.param" + curPLState.param);
		//		SDK.TBLogin(0);
		//	}
		
		//}
		//else
		//{
		//	//Debug.LogError("curPLState.state: " + curPLState.state + "curPLState.param" + curPLState.param);
		//	Debug.LogError("请等待平台登陆返回");
		//	SDK.TBLogin(0);
		//}
	//}
	//private void imp_login_gameServer()
	//{
		//string svr_id = describ.id + "_";
		//WWWForm f = new WWWForm();
		//f.AddField("token", pl_userInfo.token);
		//f.AddField("user_id", svr_id + pl_userInfo.uuid);
		//f.AddField("sig", ((int)platformSys.Ins.cur_users).ToString());
		//f.AddField("udid", pl_userInfo.nickName);
		//f.AddField("version", configVerifyMgr.Ins.clienVersion);
		//f.AddField("plat", dotaClient.getOS());
		//serverInfo info = serverListMgr.Ins.getCurServer();
		//if ((info.status == "4") || (info.status == "0"))
		//{
		//    if (NoticeMsg.Ins != null)
		//        NoticeMsg.Ins.CallNoticeMsg(UIStringMag.inst.server_err_1, helpFunction.app_quit);
		//    return;
		//}
		//if ((info.status == "6"))
		//{
		//    NoticeMsg.Ins.CallNoticeMsg1Prefab(UIStringMag.inst.server_err_11, 0);
		//    return;
		//}
		
		//string url = info.gameIP + "game/index.php/user/login/";
		//Debug.Log("本次登陆的IP： " + url);
		//Debug.Log("本次登陆的账号为： " + svr_id + pl_userInfo.uuid);
		//string urlbak = url + "token/" + pl_userInfo.token + "/user_id/" + svr_id + pl_userInfo.uuid;
		//Debug.Log("本次登陆的完整 ： " + urlbak);
		//dotaClient.Ins.AccInfo.token = pl_userInfo.token;
		//WebRequestManager.GetInstance().SendRequest(url, f, handleNatMsg_game.handle_me_enter_gameserver);
		//Loading.Ins.StartLoading();
	//}
	//public void do_update_clinet_by_user(bool isUpdate)
	//{
		//if (isUpdate == false)
		//{
		//    imp_login_gameServer();
		//}
		//else
		//{
		//    Application.OpenURL(configVerifyMgr.Ins.store_kuku);
		//    Application.Quit();
		//}
		
	//}
	//public virtual void on_receive_xcode_msg(string msg)
	//{
		
	//}
	
	//< handle====================================================
	//public virtual int handle_pl_initDone(string msg)
	//{
		//curPLState.state = (int)pl_state.pl_app_init;
		//SDK.TBLogin(0);
		//curPLState.state = (int)pl_state.pl_login_ing;
	//	return 0;
	//}
	//public virtual int handle_pl_Login(string msg)
	//{
	//	return 0;
	//}
	/*
	public virtual int handle_pl_LoginResult(string msg)
	{
		string[] tmp = msg.Split(':');
		string info = tmp[1];
		string[] info_list = info.Split('_');
		string loginResult = info_list[0];
		curPLState.param = loginResult;
		curPLState.state = (int)pl_state.pl_login_Over;
		if(loginResult == "0")
		{			
			Debug.LogError("平台登陆失败");
			//lgNoDelCsFun.Ins.plat360("0", "0" , "0");
			return 0;
		}
		else if(loginResult == "1")
		{
			pl_userInfo.uuid = info_list[1];
			pl_userInfo.nickName = info_list[2];
			pl_userInfo.token = info_list[3];
			
			//dotaClient.Ins.mainState.changeState("login");
			Debug.LogError(describ.id +"平台登陆成功" + msg + ":uuid=" + pl_userInfo.uuid + ",token=" + pl_userInfo.token);
			string qdl = platformSys.Ins.channel_id;
			
			//lgNoDelCsFun.Ins.plat360(pl_userInfo.token , qdl);
			//lgNoDelCsFun.Ins.plat360(pl_userInfo.token, qdl, pl_userInfo.uuid);
			//dotaClient.Ins.mainState.changeState("platformLoginState");
			//防沉迷检测
			//SDK.c_sdk_antiAddictionQuery();
		}
		return 0;
	}
	public virtual int handle_pl_DidLogout(string msg)
	{
		curPLState.state = (int)pl_state.pl_init_Over;
		curPLState.param = "0";
		//dotaClient.Ins.re_login_game(true);
		Application.Quit();
		return 0;
	}
	
	//< 购买成功
	public virtual int handle_pl_BuyGoodsSuccess(string msg)
	{
		//NoticeMsg.Ins.CallNoticeMsg1Prefab("DT83",0);
		//lgNoDelCsFun.Ins.PayRechargePhp("");
		orderMgr.Ins.enterOrder(msg);		
		return 0;
	}
	
	//< 购买失败
	public virtual int handle_pl_BuyGoodsFailedWithCode(string msg)
	{
		//NoticeMsg.Ins.CallNoticeMsg1Prefab("DT84",0);
		return 0;
	}
	
	//< 购买取消
	public virtual int handle_pl_BuyGoodsDidCancelByUser(string msg)
	{
		return 0;
	}
	
	public virtual int do_receive_xcode_msg(string msg)
	{
		string[] tmp = msg.Split(':');
		if(tmp.Length<=0)
		{
			Debug.LogError("xcdoe 传回的消息错误： " + msg);
			return 0;
		}
		string op = tmp[0];
		switch(op)
		{
		case "InitDone":
			handle_pl_initDone(msg);
			break;
			
		case "Login":
			handle_pl_Login(msg);
			break;
			
		case "LoginResult":
			handle_pl_LoginResult(msg);
			break;
			
		case "DidLogout":
			handle_pl_DidLogout(msg);
			break;
			
			
		case "BuyGoodsSuccess":
			handle_pl_BuyGoodsSuccess(msg);
			break;
			
		case "BuyGoodsFailedWithCode":
			handle_pl_BuyGoodsFailedWithCode(msg);
			break;
			
		case "BuyGoodsDidCancelByUser":
			handle_pl_BuyGoodsDidCancelByUser(msg);
			break;
			
		}
		return 0;
	}
	*/
}