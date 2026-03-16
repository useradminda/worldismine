using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class net_callback
{

	static public void  handle_test_net(string str,int returnID, string error)
	{
		Debug.LogError ("net back msg:  " + str);
	}

	static public void handle_lua_http(string data , string luacname, int returnID, string error , packItem _pack ) 
	{
		/*if(data==null||returnID != net_msg_id_define.NM_OK)
		{
			return;
		}
		 */
		System.Object[] args = new System.Object[5];
		args[0] = "handleHttpRequest";
		args[1] = (System.Object)data;
		args[2] = (System.Object)returnID;
		args[3] = (System.Object)error;
		args[4] = (System.Object)luacname;
		
		lgNoDelCsFun.Ins.Call(lgNoDelCsFun.Ins.mainlua, "GameMain.CallBack", args);
	}
	
	static public void handle_lua_http(string str , string luacname , int returnID, string error ) 
	{
		//Debug.Log(str);
		if(str==""||returnID != net_msg_id_define.NM_OK)
		{
			return;
		}
		
		System.Object[] args = new System.Object[5];
		args[0] = "handleHttpRequest";
		args[1] = (System.Object)str;
		args[2] = (System.Object)returnID;
		args[3] = (System.Object)error;
		args[4] = (System.Object)luacname;
		
		lgNoDelCsFun.Ins.Call(lgNoDelCsFun.Ins.mainlua, "GameMain.CallBack", args);
	}
	
	public static void sysc_data_from_net(string comData)
	{
		//Debug.LogError("Comminfo:" + comData);
		if(comData==null)
		{
			return;
		}
		//List<object> listData = comData as List<object>;
		//int len = listData.Count;
		//for(int i=0;i<len;i++)
		{
			//IDictionary dataItem = (IDictionary)listData[i];
			//string luacb = dataItem["t"].ToString();
			
			//object dataInfo = (object)dataItem["i"];
			
			System.Object[] args = new System.Object[5];
			args[0] = "Commoninfo";
			args[1] = (System.Object)comData;
			args[2] = "";
			args[3] = "";
			args[4] = "";
			
			lgNoDelCsFun.Ins.Call(lgNoDelCsFun.Ins.mainlua, "GameMain.CallBack", args);
		}
	}
	

}

