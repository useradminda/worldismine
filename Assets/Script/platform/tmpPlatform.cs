using UnityEngine;
using System.Collections;

public class tmpPlatform : basePlatform
{
	public override void onInit()
	{
		
	}
	public override void ask_Init()
	{
		
	}
	public override void ask_Login()
	{
		//SDK.TBLogin(0);
	}
	public override void ask_Logout()
	{
		
	}

    public override float do_buy_goods(int succ, IDictionary netMsg, packItem pack)
	{
        float price = base.do_buy_goods(succ, netMsg, pack);
		if(price <= 0)
		{
			Debug.LogError("购买失败 tmp");
			return price;
		}
		string order = System.Convert.ToString(netMsg["order_num"]);
		//if(order.Length>=10&&UIStringMag.inst.CheckOrder(order))
		//{
		//	int goods_id = int.Parse(pack.P);
		//	shopItemDb goods = goodsDB.Ins.getRMBGoods(goods_id);
  //          if (platformSys.Ins.get_channel_sur() == channel_sur.cs_efun )
  //          {
  //              SDK.TBPayRMB_Order_Efun(goods.goods_no,dotaClient.Ins.theMe.world_id.ToString(),serverListMgr.Ins.curServerID.ToString(),dotaClient.Ins.theMe.lvl.ToString(),
  //                  dotaClient.Ins.theMe.NickName,order);
  //          }
  //          else
  //          {
  //              SDK.TBPayRMB_Order(price, order, serverListMgr.Ins.curServerID.ToString(), goods.name, goods.goods_no, goods.id.ToString());
  //          }
			
			
		//}
		//else
		//{
		//	packItem netpack = new packItem();
		//	netpack.id = packMgr.Ins.applyPackID();
		//	netpack.M = "debug";
		//	netpack.A = "log";
		//	netpack.P = "order_error" + "," + order;
		//	netpack.setCallBack(tmpPlatform.handle_order_error);
		//	packMgr.Ins.limitSendPack(netpack);
		//	NoticeMsg.Ins.CallNoticeMsg1Prefab("DT122",0);
		//}
		return 0;
	}
	
	public override void ask_buy_goods_imp(int goods_id)
	{
		base.ask_buy_goods(goods_id,tmpPlatform.handle_buy_goods);
	}
	
	public static void handle_buy_goods(int returnCode,IDictionary d,packItem pack)
	{
		//platformSys.Ins.curPlatform.do_buy_goods(returnCode,d,pack);
	}
	public override void on_receive_xcode_msg(string msg)
	{
		Debug.LogError("这是tmp台返回的消息: " + msg);
		do_receive_xcode_msg(msg);		
	}
	public static void handle_order_error(int returnCode,IDictionary d,packItem pack)
	{
		
	}
	
}

