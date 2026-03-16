using UnityEngine;
using System;
using System.Collections.Generic;
using LitJson;
using System.Security.Cryptography;
using System.IO;
using System.Text;
using System.Collections;
using SLua;


public delegate void RequestCallback(String netReturnBuff  , int errorID, string errInfo);
public delegate void RequestCallbackLua(String netReturnBuff , string func , int errorID, string errInfo);

public class WebRequest
{
	
	public float stratTime;
	
	public WWW www;
	
	public RequestCallback requestCallback;
	public RequestCallbackLua requestCallbacklua;
	
	public string headtext = "";

	public WebRequest(float stratTime, WWW www, RequestCallback requestCallback) 
	{
		this.stratTime = stratTime;
		this.www = www;
		this.requestCallback = requestCallback;

	}

	public WebRequest(float stratTime, WWW www, RequestCallbackLua requestCallback, string headtext) 
	{
		this.stratTime = stratTime;
		this.www = www;
		this.requestCallbacklua = requestCallback;
		this.headtext = headtext;
	}
}

[CustomLuaClass]
public class WebRequestManager{
	
	private static readonly String strKey = "djfh47cd";

	public float timeOut = 20.0f;
	
	private static WebRequestManager instance;
	
	private List<WebRequest> requestList = new List<WebRequest>();
	private List<WebRequest> addList = new List<WebRequest>();
	
	public static WebRequestManager GetInstance() 
	{
		if(instance == null) 
		{
			instance = new WebRequestManager();
		}
		
		return instance;
	}
	
	public void clear()
	{
		requestList.Clear();
		addList.Clear();
	}
	
	private float now ;
	private List<WebRequest> deleteList = new List<WebRequest>();
	public void Update ()																					//处理数据包z
	{
		now = Time.time;
		deleteList.Clear();
		requestList.AddRange(addList);
		addList.Clear();
		
		for(int i = 0;i< requestList.Count;i++)
		{			
			WebRequest request = requestList[i];
			
			if(request.www.isDone)
			{
				if(request.requestCallback != null||request.requestCallbacklua!=null)
				{
					if(request.www.error != null)
					{
						Debug.Log(request.www.error);
						
						if(request.headtext!="")
						{
							request.requestCallbacklua("" , request.headtext ,  net_msg_id_define.NM_HTTP_ERROR, "");
						}
						else
						{
							request.requestCallback("" , net_msg_id_define.NM_HTTP_ERROR, request.www.error);
						}
						
						
					}
					else{
						
						if(request.www.bytes.Length <= 0)
						{
							if(request.headtext!="")
							{
								request.requestCallbacklua(request.www.text , request.headtext ,  net_msg_id_define.NM_HTTP_ERROR, "no enough texts");
							}
							else
							{
								request.requestCallback(request.www.text , net_msg_id_define.NM_HTTP_ERROR , "no enough texts");
							}
						}
						else
						{
							
							//string text = Encoding.UTF8.GetString(request.www.text, 3, request.www.bytes.Length);
							
							string text = request.www.text;

                            if (text.Substring(0,6) == "<br />")
                            {
                                Debug.LogError("网络错误：" + text);
                            }
                            else
                            {
                                if(request.headtext!="")
                                {
                                    request.requestCallbacklua(text , request.headtext , net_msg_id_define.NM_OK, "");
                                }
                                else
                                {
                                    request.requestCallback(text , net_msg_id_define.NM_OK, "");
                                }	
                            }
						}
					}
				}	
				deleteList.Add(request);
			}
			else
			{
				if(now > (request.stratTime + timeOut))
				{
					Debug.LogError("www time out:" + request.www.url);
					lgNoDelCsFun.Ins.WebEvent(1002);
					deleteList.Add(request);
				}
			}
		}
		
		for(int i = 0;i< deleteList.Count;i++)
		{
			WebRequest request = deleteList[i];	
			requestList.Remove(request);
		}
		
		deleteList.Clear();
	}
	
	public void SendRequest (string url, LuaTable table, string luacb) {
		if(url == null)
			return;

		WWWForm f = new WWWForm();
		 IEnumerator<LuaTable.TablePair> e = table.GetEnumerator();
		while (e.MoveNext()) {
            f.AddField(e.Current.key.ToString(), e.Current.value.ToString());
		}


		WWW w = new WWW(url, f);
		WebRequest request = new WebRequest(Time.time, w, net_callback.handle_lua_http, luacb);
		addList.Add(request);
	}

    public void SendRequest3(string url, LuaTable table, string luacb)
    {
        if (url == null)
            return;
		Debug.Log(url);
        WWWForm f = new WWWForm();
         IEnumerator<LuaTable.TablePair> e = table.GetEnumerator();
        while (e.MoveNext())
        {
            f.AddField(e.Current.key.ToString(), e.Current.value.ToString());
        }
        WWW w = new WWW(url, f);
        WebRequest request = new WebRequest(Time.time, w, net_callback.handle_lua_http, luacb);
        addList.Add(request);
    }
	
	public void SendRequestLua(string url , WWWForm data,RequestCallbackLua requestCallback ,string luacb)			//LUA使用的发包机制z
	{
		if(url == null)
			return;
		WWW w = new WWW(url,data);
		 WebRequest request = new WebRequest(Time.time, w, requestCallback , luacb);
		addList.Add(request);
	}
	
	public void SendRequest(string url, string action, string data, RequestCallback requestCallback){
		
		if(url == null || data == null)
			return;
		
		//encrypt data
		string encryptData = Encrypt3DES(data);		
		if(encryptData != ""){
			WWWForm form = new WWWForm();
			form.AddField("action", action);
			form.AddField("data", encryptData);
			
			WWW www = new WWW(url, form);	
			WebRequest request = new WebRequest(Time.time, www, requestCallback);
			requestList.Add(request);
		}
	}
	
	
	public void SendRequest(string url,WWWForm data,RequestCallback requestCallback)
	{
		if(url == null)
			return;
		WWW w = new WWW(url,data);
		WebRequest request = new WebRequest(Time.time,w,requestCallback);
		addList.Add(request);
	}
	
	public void SendRequest(string url,RequestCallback requestCallback)
	{
		if(url == null)
			return;
		WWW w = new WWW(url);
		WebRequest request = new WebRequest(Time.time,w,requestCallback);
		addList.Add(request);
	}

	public void SendRequest(string url , string luacb)
	{
		if(url == null)
			return;
		WWW w = new WWW(url);
		WebRequest request = new WebRequest(Time.time, w, net_callback.handle_lua_http, luacb);
		addList.Add(request);
	}
	
	
	
	
	public void Dispose(){
		requestList.Clear();	
	}
	
	private string Encrypt3DES(string strString)
	{
		try{
		    DESCryptoServiceProvider DES = new DESCryptoServiceProvider();
		    DES.Key = Encoding.UTF8.GetBytes(strKey);
		    DES.Mode = CipherMode.ECB;
		    DES.Padding = PaddingMode.Zeros;
		    ICryptoTransform DESEncrypt = DES.CreateEncryptor();
		    byte[] Buffer = Encoding.UTF8.GetBytes(strString);
			Buffer = DESEncrypt.TransformFinalBlock(Buffer, 0, Buffer.Length);
		    return Convert.ToBase64String(Buffer);
		}
		catch{
			return "";
		}
	}
	
	private string Decrypt3DES(string strString)
    {
		try{
	        DESCryptoServiceProvider DES = new DESCryptoServiceProvider ();
	        DES.Key = Encoding.UTF8.GetBytes(strKey);
	        DES.Mode = CipherMode.ECB;
	        DES.Padding = PaddingMode.Zeros;
	        ICryptoTransform DESDecrypt = DES.CreateDecryptor();
	        byte[] Buffer = Convert.FromBase64String(strString);
			Buffer = DESDecrypt.TransformFinalBlock(Buffer, 0, Buffer.Length);
	        return Encoding.UTF8.GetString(Buffer).Replace("\0","");
		}
		catch{
			return "";
		}
    }
	
}





















