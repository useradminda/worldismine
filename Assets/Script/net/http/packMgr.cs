using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LitJson;
using System;
using SLua;
//public delegate void packItemCallback(int returnCode,JsonData netMsg);
public delegate void packItemCallback(int returnCode,IDictionary netMsg,packItem pack);
public delegate void packItemCallbackLua(string data, string lucab , int returnID, string error , packItem pack);

public class packItem
{
	public int sendTimes =packMgr.Ins.max_send_times;									//< 发送的次数
	public  int id;
	public string luaCb;
	public string A;
	public string M;
	public string P;
	public string E;
	//private packItemCallback execute;
	/*public void setCallBack(packItemCallback p)
	{
		execute = p;
	}
	public void Execute(int code,IDictionary msg,packItem pack)
	{
		execute(code,msg,pack);
	}*/
	private packItemCallbackLua execute;
	
	public packItem()
	{
		execute = net_callback.handle_lua_http;
	}
	
	public void Execute(string data , string luacb , int returnID, string error , packItem _pack)
	{
		execute(data, luacb , returnID , error , _pack);
	}
	
	
}
[CustomLuaClass]
public class packMgr
{
	public string GameUrl = "";
	public LuaTable Tabel ;
	public string Token = "";
	public int PlayerId = 0;
	
	public int max_send_times = 2;
	private static packMgr _ins = null;
	
	public List<packItem> NowSendPack = new List<packItem>(0);											//当前发送的包
	public packItem LastSendPack = null;										//上次发送的包
	
	public List<packItem> list_pack;											//发送过的 待处理的包
	public List<packItem> list_pack_last_game = new List<packItem>();			//上次游戏使用的包
		
	private List<packItem> list_delete;											//待删除的包

	private int gPackID =0;

	private float pack_send_delay_time = 10f;
	private float lastSendTime;
	public Queue<int> list_exec_id = new Queue<int>();
	public packMgr()
	{
		list_pack = new List<packItem>();
		list_delete = new List<packItem>();
	}
	public static packMgr Ins
	{
		get
		{
			if(_ins == null)
			{
				_ins = new packMgr();
			}
			return _ins;
		}
	}
	public static packMgr GetInstance()
	{
		if(_ins == null)
			{
				_ins = new packMgr();
			}
			return _ins;
		
	}
	
	public int applyPackID()
	{
		return ++gPackID;
	}
	public int PlusPackID()
	{
		return --gPackID;
	}
	//< 初始化打包系统-
	public bool setup()
	{
		gPackID = 0;
		list_pack.Clear();
		list_delete.Clear();
		return true;
	}
	public packItem getPackItem(int ID)
	{
		foreach(packItem pack in list_pack)
		{
			if(pack.id == ID)
			{
				return pack;
			}
		}
		return null;
	}
	public void update()
	{
		float thistime = Time.time;
		if(thistime - lastSendTime >= pack_send_delay_time)
		{
			sendPack();
			lastSendTime = thistime;
		}
	}
	public void removeAllPack()
	{
		NowSendPack.Clear();
		list_pack.Clear();
	}
	public void sendPack()
	{		
		
		if(list_pack.Count <=0)
		{
			return;
		}

		int player_id = PlayerId;
		string token = Token;
		string syncStr = "";
		string xlb_id = "sadfsdf";//xiaoLaBaSys.Ins.cur_mess_id;
		WWWForm form = new WWWForm();
		string str = JsonMapper.ToJson(NowSendPack);	
		string str_tmp = stringEncodeMgr.Ins.Encrypt(str);
		//string strMini = MiniJSON.Json.Serialize(NowSendPack);	
		//Debug.Log(player_id);
		//Debug.Log("list_pack:"+str);
		//Debug.Log(GameUrl);
		form.AddField("player_id",player_id);
		form.AddField("token",token);
		form.AddField("pack",str_tmp);
		//form.AddField("brid",xlb_id);		
		form.AddField("syncStr",syncStr);
        form.AddField("sbll", stringEncodeMgr.Ins.is_down_jm.ToString());
      
		{
#if UNITY_EDITOR
            Debug.LogError("发送数据包： " + str);
           //Debug.Log("发送数据包 xlb_id： " + xlb_id);
#endif
        }
		
		WebRequestManager.GetInstance().SendRequestLua(GameUrl , form , pack_send_callback , NowSendPack[0].luaCb);
		//WebRequestManager.GetInstance().SendRequest(gameModule.gameUrl,form,pack_send_callback);

	}
	public void deleteOldPack()													//删除处理包
	{
		for(int i=0; i<list_delete.Count; i++)
		{
			packItem deleteItem = list_delete[i];
			list_pack.Remove(deleteItem);
		}
		list_delete.Clear();
	}
	public void limitSendPack(packItem p)
	{
		addPack(p);
		//EatExpProxy.Ins.pick_baby_fight_state();
		sendPack();
		lastSendTime = Time.time;
	}
	
	public void limitSendPackLua(LuaTable _Table)
	{
		deleteOldPack();
		int packID = packMgr.Ins.applyPackID();
		packItem pack = new packItem();
		pack.id = packID;
		 
	    IEnumerator<LuaTable.TablePair> e = _Table.GetEnumerator();
      
        while (e.MoveNext())
        {
			if(e.Current.key.ToString()=="A")
			{
				pack.A = e.Current.value.ToString();
			}
			if(e.Current.key.ToString()=="M")
			{
				pack.M = e.Current.value.ToString();
			}
			if(e.Current.key.ToString()=="P")
			{
				pack.P = e.Current.value.ToString();
			}
			if(e.Current.key.ToString()=="E")
			{
				pack.E = e.Current.value.ToString();
			}
			if(e.Current.key.ToString()=="token")
			{
				Token = e.Current.value.ToString();
			}
			if(e.Current.key.ToString()=="playerId")
			{
				PlayerId = System.Convert.ToInt32(e.Current.value);
			}
			if(e.Current.key.ToString()=="GameUrl")
			{
				GameUrl = e.Current.value.ToString();
			}
			if(e.Current.key.ToString()=="luac")
			{
				pack.luaCb = e.Current.value.ToString();
			}
        }
		if(pack.A=="synchronous")
		{
			if(list_pack.Count>0)
			{
				packMgr.Ins.PlusPackID();
				return;
			}
		}
		addPack(pack);
		if(NowSendPack.Count == 0)
		{
			NowSendPack.Add(null);
		}
		NowSendPack[0] = pack;
		sendPack();
		lastSendTime = Time.time;
	}
	
	
	
	private packItem getLastPack()
	{
		packItem item = null;
		if(list_pack.Count>0)
		{
			int count = list_pack.Count-1;
			return list_pack[count];
		}
		return item;
	}
	
	public void addPack(packItem item)
	{
		if(list_pack.Count<=0)
		{
			list_pack.Add(item);
		}
		else
		{
			/*packItem last = getLastPack();
			if(item.id - last.id != 1)
			{
				Debug.Log("pack error");
				//logger.Ins.logPHP("addpack error");
				throw new Exception(" addpack error");
				//return;
			}
			else{*/
				list_pack.Add(item);
			//}
		}
	}
	
	
	public void do_timeout_pack()
	{
		int len = list_pack.Count;
		bool reSend = false;
		for(int i=0;i<len;i++)
		{
			packItem pack = list_pack[i];			
			if(pack.sendTimes < max_send_times)
			{
				pack.sendTimes++;
				reSend = true;				
				break;
			}
			else
			{
				continue;
			}
		}
		if(reSend == true)
		{
			Debug.LogError("超时重新发送");
		}
	}
	
	public void pack_send_callback(String str, string luacb , int returnID, string error)
	{
			
		//Debug.Log(str);
		
        if (stringEncodeMgr.Ins.is_down_jm > 0)
        {
            str = stringEncodeMgr.Ins.Decrypt(str);
        }
				
		if (Application.platform == RuntimePlatform.WindowsEditor)
		{
#if UNITY_EDITOR
            Debug.Log(str + "  pack_send_callback");
#endif
		}
       
		//Debug.Log("returnID: " + returnID);
		
		if(returnID == net_msg_id_define.NM_OK)
		{
			IDictionary  objStr = (IDictionary )MiniJSON.Json.Deserialize(str);
			string sr = objStr["r"].ToString();
			if(sr == "0")
			{
				//< 奖励
				//IDictionary rwd = (IDictionary)objStr["rwd"];
				//rewardMgr.Ins.initNetData(rwd);	
				//< 数据同步
				object commInfo = (object) objStr["commonInfo"];
				string Cominfostr =  MiniJSON.Json.Serialize(commInfo);
				if(Cominfostr!=null)
				{	
					net_callback.sysc_data_from_net(Cominfostr);
				}
				
				//helpFunction.sysc_data_from_net(commInfo);
				
				//< 其他
				object objList = objStr["res"];
				IList<object> list = objList as IList<object>;
				int resLen = list.Count;
				if(resLen == 0)
				{
					Debug.LogError("解析pack_send_callback错误 res.count == 0");
					return;
				}
				for(int i=0;i<resLen;i++)
				{
					IDictionary net_pack = (IDictionary)list[i];
					int item_r = System.Convert.ToInt32(net_pack["r"]);
					int item_id = System.Convert.ToInt32(net_pack["id"]);
									
					if(item_r == 0)
					{
						object data = (object)net_pack["d"];
						string datainfo =  MiniJSON.Json.Serialize(data);
						packItem item = getPackItem(item_id);	
						list_delete.Add(item);
						if(item != null)
						{
							if(list_exec_id.Contains(item_id))
							{
								Debug.LogError("重复数据包处理，抛弃");
							}
							else
							{
								
								item.Execute(datainfo,luacb,0,error,item);
								list_exec_id.Enqueue(item_id);
								while(list_exec_id.Count>= 10)
								{
									list_exec_id.Dequeue();
								}
							}
							
						}
						else 
						{
							//item.Execute(0,null,item);
							
							Debug.LogError("强烈警告。。。 数据包未发现处理");
						}

						
					}
					else
					{
						//object obj = net_pack["d"];
						//IDictionary data = (IDictionary)net_pack["d"];
						packItem item = getPackItem(item_id);
						if(item != null)
						{
							list_delete.Add(item);
							if(item.A == "coupon")
							{
								object data = (object)net_pack["d"];
						        string datainfo =  MiniJSON.Json.Serialize(data);
								item.Execute(datainfo , luacb , item_r, error ,item);
							}
							else
							{
								item.Execute(null , luacb , item_r , error ,item);
							}
							
							
						}
						
					}
				}
			
										
			}
			else
			{
				int ret = System.Convert.ToInt32(sr);
				
				if(ret == net_msg_id_define.NM_ERROR_SERVER_ASSERT)
				{lgNoDelCsFun.Ins.WebEvent(ret);
					//NoticeMsg.Ins.CallNoticeMsg1Prefab("DT120",0);
				}
				else if(ret == net_msg_id_define.NM_CLIENT_NEED_UPDATE)
				{lgNoDelCsFun.Ins.WebEvent(ret);
					//NoticeMsg.Ins.CallNoticeMsg1Prefab("DT121",0);
				}
				else if(ret == net_msg_id_define.NM_ACC_SEAL)
				{lgNoDelCsFun.Ins.WebEvent(ret);
					//NoticeMsg.Ins.CallNoticeMsg1Prefab("DT93",0);
				}
				else if(ret == net_msg_id_define.NM_DATA_FAIL)
				{
					//NoticeMsg.Ins.CallNoticeMsg1Prefab("DT93",0);
					
					//if(Loading.Ins != null)
					//	Loading.Ins.StopLoading();
					//Time.timeScale=0f;
					//if(NoticeMsg.Ins != null)
					//	NoticeMsg.Ins.CallNoticeMsg("DT127",helpFunction.app_quit);
					lgNoDelCsFun.Ins.WebEvent(ret);
				}
				else if(ret == net_msg_id_define.NM_TOKEN_FAIL)
				{
					//NoticeMsg.Ins.CallNoticeMsg1Prefab("DT93",0);
					
					//if(Loading.Ins != null)
					//	Loading.Ins.StopLoading();
					//Time.timeScale=0f;
					
					//if(NoticeMsg.Ins != null)
					//	NoticeMsg.Ins.CallNoticeMsg("DT174",helpFunction.app_quit);
					lgNoDelCsFun.Ins.WebEvent(ret);
				}
				else if(ret == 9006)
				{
					lgNoDelCsFun.Ins.WebEvent(ret);
					string D = objStr["d"].ToString();
					//if(NoticeMsg.Ins != null)
					//	NoticeMsg.Ins.CallNoticeMsg(D,dotaClient.Ins.re_login_game);
					//if(Loading.Ins != null)
					//	Loading.Ins.StopLoading();
				}
				else if (ret==net_msg_id_define.NM_Another_PlayerOn)				//< 网络错误
				{
				    lgNoDelCsFun.Ins.WebEvent(ret);
				}
				else if (ret == net_msg_id_define.NetError)
				{
					lgNoDelCsFun.Ins.WebEvent(ret);
				}
				else
				{

					Debug.LogError("pack_send_callback r: "+ sr);
					//Time.timeScale=0f;
					lgNoDelCsFun.Ins.WebEvent(net_msg_id_define.NM_Another_PlayerOn);
					
				}
				
				
			}
		}
		else if(returnID == net_msg_id_define.NM_TIMEOUT)			//发包超时
		{
			lgNoDelCsFun.Ins.WebEvent(returnID);
			//do_timeout_pack();
		}
		else if(returnID == net_msg_id_define.NM_HTTP_ERROR)
		{
			//if(Loading.Ins != null)
			//	Loading.Ins.StopLoading();
			//Time.timeScale=0f;
			//NoticeMsg.Ins.EndNowTrain();
			//if(NoticeMsg.Ins != null)
			//	NoticeMsg.Ins.CallNoticeMsg("DT174",dotaClient.Ins.re_login_game);
			lgNoDelCsFun.Ins.WebEvent(returnID);	
			Debug.LogError("当前数据包数量为：　"+list_pack.Count);
		}
		else if(returnID == net_msg_id_define.NM_ERROR_SERVER_ASSERT)
		{lgNoDelCsFun.Ins.WebEvent(returnID);
			//NoticeMsg.Ins.CallNoticeMsg1Prefab("DT120",0);
		}
		else if(returnID == net_msg_id_define.NM_CLIENT_NEED_UPDATE)
		{lgNoDelCsFun.Ins.WebEvent(returnID);
			//NoticeMsg.Ins.CallNoticeMsg1Prefab("DT121",0);
		}
		else if(returnID == net_msg_id_define.NM_ACC_SEAL)
		{
			lgNoDelCsFun.Ins.WebEvent(returnID);
			//NoticeMsg.Ins.CallNoticeMsg1Prefab("DT93",0);
		}
		else if(returnID == net_msg_id_define.NM_DATA_FAIL)
		{
			//NoticeMsg.Ins.CallNoticeMsg1Prefab("DT93",0);
			lgNoDelCsFun.Ins.WebEvent(returnID);
			//Time.timeScale=0f;
			
		}
		else if (returnID== net_msg_id_define.NM_Another_PlayerOn)				//< 网络错误
		{
			lgNoDelCsFun.Ins.WebEvent(returnID);
		}
		else
		{
			
			//Time.timeScale=0f;
			lgNoDelCsFun.Ins.WebEvent(net_msg_id_define.NM_Another_PlayerOn);
			Debug.LogError("当前数据包数量为：　"+list_pack.Count);

		}
		
		
	}
	
}
	 



public struct packItemMsg
{
	public int id;
	public int r;
	public packItemMsg_res res;
}

public struct packItemMsg_res
{
	public string name;
	public string num;
	public string role;
	public string level;
	public string exp;
	public string coin;
	public string sta;
	public string diamond;
}


