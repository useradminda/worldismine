using UnityEngine;
using System.Collections;
using System;
using System.Text;
public class appPlatform : basePlatform
{
	public appPlatform()
	{
		describ.id = "22";
		describ.name = "app  platform";
	}

	public int bak_goods_id = 0;

	public override void onInit()
	{
		//SDK.App_Init();
	}
	public override void ask_Init()
	{
		//SDK.App_Init();
		//dotaClient.Ins.mainState.changeState("login");
	}
	public override void ask_Login()
	{
		
	}
	public override void ask_Logout()
	{
		
	}
	public  int handle_app_buyGoods(string msg)
	{
		//string[] tmp = msg.Split(':');
		//string info = tmp[1];
		//bool Sandbox = info.Contains("Sandbox");
		//string info_base64 = Convert.ToBase64String(Encoding.UTF8.GetBytes(info)); 
		
		
		////< send to server
		//int packID = packMgr.Ins.applyPackID();
		//packItem pack = new packItem();
		//pack.id = packID;
		//pack.M = "shop";
		//pack.A = "generateOrderAppStore";
		//pack.P = info_base64.ToString();
		//pack.P += ",";
		//if(Sandbox == true)
		//{
		//	pack.P+="1";
		//}
		//else{
		//	pack.P+="0";
		//}
		//pack.P += ",";
		//pack.P += bak_goods_id.ToString() ;
  //      pack.P += ",";
  //      serverInfo info1 =  serverListMgr.Ins.getCurServer();
  //      if (info1 != null)
  //      {
  //          pack.P += info1.id.ToString();
  //      }
        
		////Debug.LogError("向服务器提交app购买信息:  " + pack.P);
		//pack.setCallBack(appPlatform.handle_buy_goods);
		//packMgr.Ins.limitSendPack(pack);
		//Loading.Ins.StartLoading();
		//PlayerPrefs.SetString("app",pack.P);
		//Debug.LogError("cs==============================:: " + PlayerPrefs.GetString("app"));
		return 0;
	}
	
	public  int handle_App_buyGoods_ask(string msg)
	{
		orderMgr.Ins.enter_ask_app_goods("0");
		return 0;
	}
	public  int handle_App_buyGoods_ask_report(string msg)
	{
		orderMgr.Ins.ask_app_goods_report("1");
		return 0;
	}
	
	
	
	public override int do_receive_xcode_msg(string msg)
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
			case "App_buyGoods_Done":
			handle_app_buyGoods(msg);
			break;
			case "App_buyGoods_ask":
			handle_App_buyGoods_ask(msg);
			break;
			case "App_buyGoods_ask_report":
			handle_App_buyGoods_ask_report(msg);
			break;
			
			default:
			{
				//Debug.LogError("app 返回消息未找到处理函数" + msg);
				base.do_receive_xcode_msg(msg);
				
			}
			break;
		}
		return 0;
	}
	public override float do_buy_goods(int succ,IDictionary netMsg,packItem pack)
	{
		//Loading.Ins.StopLoading();
		Debug.LogError("游戏服务器对app的购买发货处理返回");
		if(succ == 0)
		{
			//NoticeMsg.Ins.CallNoticeMsg1Prefab("DT83",0);
			PlayerPrefs.SetString("app","");
			
		}
		else
		{
			Debug.LogError("服务器发货APP商品错误: " + succ);
		}
		return 0;
	}

	public void repet_app_order()
	{
	//	int packID = packMgr.Ins.applyPackID();
	//	packItem pack = new packItem();
	//	pack.id = packID;
	//	pack.M = "shop";
	//	pack.A = "generateOrderAppStore";

	//	pack.P += PlayerPrefs.GetString("app");
	//	//NoticeMsg.Ins.CallNoticeMsg1Prefab(UIStringMag.inst.server_err_10,0);
	//	//pack.setCallBack(appPlatform.handle_buy_goods);
	//	packMgr.Ins.limitSendPack(pack);
	//	Loading.Ins.StartLoading();
	}
	public override void ask_buy_goods_imp(int goods_id)
	{
		
		//shopItemDb goods = goodsDB.Ins.getRMBGoods(goods_id);
		//if(goods == null)
		//{
		//	Debug.LogError("没有该商品,购买失败： " + goods_id);
		//	return;
		//}
		//Debug.LogError("请求向app 购买道具:  " + goods.index_in_app);
		//string app_info = PlayerPrefs.GetString("app");
		//if(app_info.Length >10)
		//{
		//	repet_app_order();
		//	Debug.LogError("请求向app qingqiu  shangci de dingdan :  " + goods.index_in_app);
		//	return;
		//}
		//SDK.App_buyGoods(goods.index_in_app);
		//bak_goods_id = goods.index_in_app;
		//orderMgr.Ins.enter_ask_app_goods("0");
		//base.ask_buy_goods(goods_id,appPlatform.handle_buy_goods);
	}
	
	public static new void handle_buy_goods(int returnCode,IDictionary d,packItem pack)
	{
		//platformSys.Ins.curPlatform.do_buy_goods(returnCode,d,pack);
	}
	public override void on_receive_xcode_msg(string msg)
	{
		//Loading.Ins.StopLoading();
		Debug.LogError("这是app台返回的消息: " + msg);
		//do_receive_xcode_msg(msg);		
	}
}

