//#define _YUEYU
using UnityEngine;
using System.Collections;
using System.Collections.Generic;


//< 渠道来源
public enum channel_sur
{
    cs_normal,
    cs_efun,
}
public class platformSys 
{
	//public bool is_develop = false;																		//< 是否是开发平台
	//public users_type cur_users = users_type.ut_db;										//< 当前版本发布对象
    public bool is_develop = true;	
	private static platformSys _ins = null;
	//public Dictionary<int,basePlatform> dic_platform = new Dictionary<int, basePlatform>();
	public basePlatform curPlatform = null;
	public string debug_str = "00000000000000";
	public bool is_momo = false;													//是否是摸摸平台z
    public string channel_id = "0";                                                  //< 渠道ID
	public static platformSys Ins
	{
		get{
			if(_ins == null)
			{
				_ins = new platformSys();
			}
			return _ins;			
			
		}
	}

    //public string CHANNEL_ID
    //{
    //    get
    //    {
    //        return channel_id;
    //    }
    //    set
    //    {
    //        channel_id = value;
    //        if (channel_id == "11000")
    //        {
    //            cur_users = users_type.ut_app;
    //        }
    //    }
    //}
    //public channel_sur get_channel_sur()
    //{
    //    if((channel_id == "20099")||(channel_id == "10099"))
    //    {
    //        return channel_sur.cs_efun;
    //    }
    //    return channel_sur.cs_normal;
    //}
    public basePlatform factory_create_platform(string p_id)
    {
        basePlatform pl = null;
        channel_id = p_id;
        switch (p_id)
        {
            case "11":
                pl = new tmpPlatform();
                break;

            case "0":
                pl = new developPlatform();
                break;
            case "10000":
                pl = new appPlatform();
                orderMgr.Ins.is_app = true;
                break;


            default:
                pl = new tmpPlatform();
                //pl = new appPlatform();
                break;

        }
        pl.describ.id = p_id;
        return pl;
    }
    //< 初始化平台配置
    public void init_platform_cfg()
	{
		
	}
	//< 设置当前平台
	public void set_platform(string id)
	{
		Debug.LogError("set_platform:  " + id);
		basePlatform pl = factory_create_platform(id);
		curPlatform = pl;





		curPlatform.handle_pl_initDone(id);
		//curPlatform.ask_Login();
	}
	//< 初始化平台
	public void init_platform()
	{
		//if(is_develop == true)
		//{
		//	set_platform("0");
		//	curPlatform.ask_Init();
		//}
		//else{

		//	if(platformSys.Ins.cur_users == users_type.ut_db)
		//	{
		//		dotaClient.Ins.mainState.changeState("platformLoginState");
		//		SDK.TBInit();
		//	}
		//	else if(platformSys.Ins.cur_users == users_type.ut_app)
		//	{
		//		dotaClient.Ins.mainState.changeState("platformLoginState");
		//		SDK.TBInit();
		//	}
			
		//}
	}
	public void ask_buy_platform_goods(int goods_id,int count)
	{
		//if(curPlatform != null)
		//{
		//	curPlatform.ask_buy_goods_imp(goods_id);
		//}
	}
	public void do_init_platform(string msg)
	{
		string[] tmp = msg.Split(':');
		string param = tmp[1];
		string[] p_list = param.Split('_');
		string init_result = p_list[0];		
		if(init_result == "1")
		{
			string pl_id = p_list[1];
			int ip_id = System.Convert.ToInt32(pl_id);
			set_platform(pl_id);
			//curPlatform.onInit();
		}
		else if(init_result == "0")
		{
			Debug.LogError("平台初始化失败");	
		}
		
	}
	//< 
	public void ask_login_gameSvr()
	{
		//if(curPlatform != null)
		//{
		//	curPlatform.ask_login_gameServer();
		//}
		//else
		//{
		//	platformSys.Ins.debug_str = "curPlatform == null";
		//}
	}
	//< 处理xcode 消息
	public void handle_xcode_msg(string msg)
	{
		//NoticeMsg.Ins.CallNoticeMsg1Prefab(msg,0);
		Debug.LogError("平台返回消息为：　" + msg);
		
		string[] tmp = msg.Split(':');
		string cmd = tmp[0];
		if(cmd == "InitDone")
		{
			do_init_platform(msg);
			return;
		}
        if (curPlatform != null)
        {
            curPlatform.on_receive_xcode_msg(msg);
        }
    }
}

