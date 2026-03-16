using UnityEngine;
using System.Collections;

public class developPlatform: basePlatform
{
	public developPlatform()
	{
		describ.id = "0";
		describ.name = "develop test platform";
	}
	public override void ask_Init()
	{
		//SDK.App_Init();
		//dotaClient.Ins.mainState.changeState("login");
	}
	public override void ask_buy_goods_imp(int goods_id)
	{
		//Debug.LogError("开发平台不能购买人民币道具");
		ask_buy_goods(goods_id,developPlatform.handle_buy_goods);
		
	}
	public override void ask_login_gameServer()
	{
		//Loading.Ins.StartLoading();
		//if(dotaClient.Ins.AccInfo.userAccType == userInfo.accType.ct_email)
		//{			
		//	loginModule.ask_email_signin();		
		//}
		//else if(dotaClient.Ins.AccInfo.userAccType == userInfo.accType.ct_guest)
		//{
		//	loginModule.ask_guest_signin();
		//}
		//else if(dotaClient.Ins.AccInfo.userAccType == userInfo.accType.ct_first)
		//{
		//	loginModule.ask_guest_signup();
		//}
	}
    public override float do_buy_goods(int succ, IDictionary netMsg, packItem pack)
	{
		//Debug.Log(serverListMgr.Ins.curServerID);
  //      float price = base.do_buy_goods(succ, netMsg, pack);
		//Loading.Ins.StopLoading();
		return 0;
	}
	
	public static void handle_buy_goods(int returnCode,IDictionary d,packItem pack)
	{
		//platformSys.Ins.curPlatform.do_buy_goods(returnCode,d,pack);
	}
	
}

