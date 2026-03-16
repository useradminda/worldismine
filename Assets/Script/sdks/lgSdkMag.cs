using UnityEngine;
using System.Collections;

public enum sdktype
{
	nosdk = 0,
	sdk_u9 = 1,	//U9sdk  不分ios 还是安卓


}

public enum sdkp
{
	ceshi =0,		//测试
	zhengban = 1,	//正版
	yueyu = 2,		//越狱
	
}
public enum gametype
{
	pc =0,		//pc
	ios = 1,	//ios
	andriod = 2,		//安卓
	
}

public class lgSdkMag : MonoBehaviour {
	
	public sdktype mysdktype;
	public sdkp mysdkp;
	public gametype mygametype;
	 lgsdkbase nowsdk;

	public bool hasinisdk;
	public bool hasloginsdk;

	public string CBobjname;
	public string CBFunname;

	//bool hasbuysome=false;
	bool canbuy =false;
	bool hasbuyRecord=false;
	lgBuyRecord MyBuyRecord;
	int idte=1;
	public void IniSdk(int sdk_type,int sdk_p)
	{
		if(hasinisdk==true)
		{
			return;
		}
		hasloginsdk = false;
		mysdktype = (sdktype) (sdk_type);
		mysdkp = (sdkp) (sdk_p);

		#if UNITY_IPHONE
		mygametype = gametype.ios;
		#elif UNITY_ANDROID
		mygametype = gametype.andriod;
		#else
		mygametype = gametype.pc;
		#endif
		CBobjname = gameObject.name;
		CBFunname = "Get_Sdk_Msg";
		canbuy =false;

		if(MyBuyRecord==null)
		{
			MyBuyRecord = new lgBuyRecord();
		}
		//hasbuyRecord=MyBuyRecord.IniSome (this);
		MyBuyRecord.IniSome (this);
		choosesdk ();


	}

	//游戏退出时 要通知SDK 退出
	public void QuitGame()
	{
		if(nowsdk!=null)
		{
			nowsdk.Logout();
		}
	}

	//接收SDK 发过来的消息
	public void Get_Sdk_Msg(string msg)
	{
		//Debug.LogError ("Get_Sdk_Msg  msg="+msg);
		if(mygametype == gametype.ios)
		{
			nowsdk.Get_Sdk_Msg( msg);
		}
		else if(mygametype == gametype.andriod)
		{
			
		}
		else if(mygametype == gametype.pc)
		{
			
		}
	}
	public void NoSdk_IniOk_(bool thiscanbuy)
	{
		canbuy =thiscanbuy;
		//
	}
	public void Sdk_IniOk_(bool thiscanbuy)
	{
		canbuy =thiscanbuy;
		//
	}



	//SDK登录结果返回
	public void Sdk_CB_Login(bool isok,string msg)
	{
		//
	}
	//SDK登出
	public void Sdk_CB_LoginOut()
	{
		
	}


	public bool AskBuy(string objid,string orderid)
	{

		if(canbuy==false)
		{
			//tip
			Debug.LogError("error lgSdkMag AskBuy canbuy==false");
			return false;
		}
		if(MyBuyRecord.HasBuyObj==true)//if(hasbuyRecord==true)
		{
			//tip
			Debug.LogError("error lgSdkMag AskBuy hasbuyRecord==true");
			return false;
		}

		MyBuyRecord.Set_BuyObj (objid, orderid);

		if(mygametype == gametype.ios)
		{

			nowsdk.AskBuy( objid,orderid);
		}
		else if(mygametype == gametype.andriod)
		{
			
		}
		else if(mygametype == gametype.pc)
		{
			
		}
		return true;
	}
	public void GetBuyResult(int re,string objtypeid,string rep,int issandbox)
	{
		/*
		if (re == 0) {
			MyBuyRecord.Set_BuyResult(objtypeid,rep, issandbox);
		} else {
			MyBuyRecord.Quit_Buy( re,objtypeid, issandbox);
			//hasbuyRecord=false;
		}*/
		MyBuyRecord.GetBuyResult( re, objtypeid, rep, issandbox);

		SendSVOrderResult ();
		lgNoDelCsFun.Ins.GetBuyResult ( re);
		//end loading
	}

	public void SendSVOrderResult()
	{
		string p = MyBuyRecord.MyRecordData.BuySvObjOrderId + ","+MyBuyRecord.MyRecordData.payresult.ToString()+"," + MyBuyRecord.MyRecordData.BuyCertificate+","+MyBuyRecord.MyRecordData.issandbox.ToString();
		lgNoDelCsFun.Ins.SendWeb ("Recharge","finishOrderIOS",p);
		//Debug.LogError ("SendSVOrderResult  SendSVOrderResult!!!!!! P="+p);
	}

	public void ClearBuyRecord()
	{
		Debug.LogError ("ClearBuyRecord  ClearBuyRecord!!!!!!");
		MyBuyRecord.ClearBuyRecord ();
		//hasbuyRecord = false;
	}
	public void choosesdk()
	{

		if(mygametype == gametype.ios)
		{
			nowsdk = new sdk_ios();
			nowsdk.InitSdk(this,mysdktype,mysdkp,CBobjname,CBFunname);
		}
		if(mygametype == gametype.andriod)
		{
			
		}
		if(mygametype == gametype.pc)
		{
			
		}
	}
	public void updatacheck(float dt)
	{
		MyBuyRecord.updatacheck (dt);

	}
}
