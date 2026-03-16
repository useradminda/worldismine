using UnityEngine;
using System.Collections;
using System.Collections.Generic;
public class orderMgr:gameModulebase
{
	static orderMgr _ins = null;
	public string order_num;						//< 订单号
	public float life_time = 60.0f;							//< 订单守护时间
	public float enter_time;						//< 进入状态时间
	public float space_ask_time = 10f;						//< 请求间隔时间
	public float last_ask_time;						//< 上次请求时间
	public bool is_work = false;
	public List<string> list_succ_order = new List<string>();
	public float app_life = 60.0f;					//< app购买请求最长时间 
	public float ask_app_goods_time = 0;
	public bool ask_app_goods_state = false;
	public bool is_app = false;
	public static orderMgr Ins
	{
		get
		{
			if(_ins == null)
			{
				_ins = new orderMgr();
			}
			return _ins;
		}
	}
	public override void re_login_game()
	{
		ask_app_goods_state = false;
	}
	public GameObject Fun_Obj = null;
	public string Fun_String = "";
	public void report_order(string no)
	{
		add_succ_order(no);
		if(no == order_num)
		{
			leaveOrder(true);
		}
		else
		{
			leaveOrder(false);
		}
		Debug.LogError("退出订单守护状态: " + no);
		if(Fun_Obj!=null&&Fun_String!="")
		{
			Fun_Obj.SendMessage(Fun_String);
		}
		
	}
	public void enterOrder(string no)
	{
		/*if(is_succ(no))
		{
			Debug.LogError("已经发货成功:  " + no );
		}
		else*/
		{
			is_work = true;
			enter_time = Time.realtimeSinceStartup;
            //lgNoDelCsFun.Ins.OpenLoadingPanel("");
			ask_order_info();
			//Loading.Ins.StartLoading();
			Debug.LogError("进入订单守护状态:  " + no );
		}
		
		
	}
	private void ask_order_info()
	{
		last_ask_time = Time.realtimeSinceStartup;
        //lgNoDelCsFun.Ins.SendCheckOrder("");
		//netSyncMgr.Ins.ask_send_sync_info();
	}
	public void leaveOrder(bool succ)
	{
		is_work = false;
        //lgNoDelCsFun.Ins.CloseLoadingPanel("");
		//Loading.Ins.StopLoading();
	}
	public void Update()
	{
		float thistime = Time.realtimeSinceStartup;
		if(ask_app_goods_state == true)
		{
			if(thistime - ask_app_goods_time >= app_life)
			{
				ask_app_goods_report("3"); ///< 超时
				return;
		    }
		}
		if(is_work == false)
			return;
		
		if(thistime - enter_time >= life_time)
		{
			leaveOrder(false);
			return;
		}
		if(thistime - last_ask_time >= space_ask_time)
		{
			ask_order_info();
		}
		
	}
	public void add_succ_order(string order)
	{
		list_succ_order.Add(order);
	}
	public bool is_succ(string order)
	{
		int len = list_succ_order.Count;
		for(int i=0;i<len;i++)
		{
			string ord = list_succ_order[i];
			if(ord.CompareTo(order) == 0)
			{
				return true;
			}
		}
		return false;
	}
	//< app 购买请求 进入
	public void enter_ask_app_goods(string msg)
	{
		//Loading.Ins.StartLoading();
		ask_app_goods_state = true;
		ask_app_goods_time = Time.realtimeSinceStartup;
		
		
	}
	public void ask_app_goods_report(string msg)
	{
		//Loading.Ins.StopLoading();
		ask_app_goods_state = false;
	}
}

