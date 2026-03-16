using UnityEngine;
using System.Collections;

public struct BuyRecordData_
{
	public string BuyObjTypeid;
	public string BuySvObjOrderId;
	public string BuyCertificate;

	public int issandbox;
	public int payresult;
}
//public enum BuyStateInof_
//{
//	bsNull =0,

//	bshassvobjuuid =1,			//已有服务器uuid 

//}


//客户端购买记录 只存一条
public class lgBuyRecord  {
	public lgSdkMag MysdkMag;
	public bool HasBuyObj=false;
	public BuyRecordData_ MyRecordData;
	public bool IniSome(lgSdkMag thissdkMag)
	{
		MysdkMag = thissdkMag;
		MyRecordData.BuyObjTypeid = PlayerPrefs.GetString("BuyObjTypeid", "");
		MyRecordData.BuySvObjOrderId = PlayerPrefs.GetString("BuySvObjUUID", "");
		MyRecordData.BuyCertificate=PlayerPrefs.GetString("BuyCertificate", "");
		MyRecordData.issandbox = PlayerPrefs.GetInt("issandbox",0 );
		MyRecordData.payresult = PlayerPrefs.GetInt("payresult",-1 );
		HasBuyObj=false;
		if(MyRecordData.BuyObjTypeid!="")
		{
			HasBuyObj=true;
		}

		//if(MyRecordData.payresult!=-1)
		//{
			//fa song  server
		//	CheckBuyCertificate();
		//}

		//snbug
		//ClearBuyRecord ();


		Debug.LogError ("lgBuyRecord IniSome BuyObjTypeid="+MyRecordData.BuyObjTypeid+" BuySvObjOrderId="+MyRecordData.BuySvObjOrderId+" BuyCertificate="+MyRecordData.BuyCertificate+" HasBuyObj="+HasBuyObj.ToString()+" payresult="+MyRecordData.payresult.ToString());
		return HasBuyObj;
	}

	public int Set_BuyObj(string thisBuyObjTypeid,string thisBuySvObjOrderId)
	{
		if (HasBuyObj == true) {
			Debug.LogError ("Error  has buy obj BuyObjTypeid=" + MyRecordData.BuyObjTypeid.ToString () + " BuySvObjOrderId =" + MyRecordData.BuySvObjOrderId);
			return -1;
		} else {
			MyRecordData.BuyObjTypeid=thisBuyObjTypeid;
			MyRecordData.BuySvObjOrderId=thisBuySvObjOrderId;
			MyRecordData.BuyCertificate="";
			MyRecordData.payresult=-1;
			PlayerPrefs.SetString("BuyObjTypeid", MyRecordData.BuyObjTypeid);
			PlayerPrefs.SetString("BuySvObjUUID", MyRecordData.BuySvObjOrderId);
			PlayerPrefs.SetString("BuyCertificate", MyRecordData.BuyCertificate);
			PlayerPrefs.SetInt("payresult", MyRecordData.payresult);
			HasBuyObj =true;
		}
		return 0;

	}
	public void GetBuyResult(int re,string objtypeid,string rep,int issandbox)
	{
		if (objtypeid == MyRecordData.BuyObjTypeid) {
			MyRecordData.BuyCertificate = rep;
			MyRecordData.issandbox = issandbox;
			MyRecordData.payresult=re;
			PlayerPrefs.SetString ("BuyCertificate", MyRecordData.BuyCertificate);
			PlayerPrefs.SetInt ("issandbox", MyRecordData.issandbox);
			PlayerPrefs.SetInt("payresult", MyRecordData.payresult);


		} else {
			Debug.LogError("error Set_BuyResult typeid != MyRecordData.BuyObjTypeid  typeid="+objtypeid+" MyRecordData.BuyObjTypeid="+MyRecordData.BuyObjTypeid);
		}
	}
	/*
	public void Set_BuyResult(string typeid,string thisBuyCertificate,int thisissandbox)
	{
		if (typeid == MyRecordData.BuyObjTypeid) {
			MyRecordData.BuyCertificate = thisBuyCertificate;
			MyRecordData.issandbox = thisissandbox;
			MyRecordData.payresult=0;
			PlayerPrefs.SetString ("BuyCertificate", MyRecordData.BuyCertificate);
			PlayerPrefs.SetInt ("issandbox", MyRecordData.issandbox);
			PlayerPrefs.SetInt("payresult", MyRecordData.payresult);
			//fa song  server
			CheckBuyCertificate();
		} else {
			Debug.LogError("error Set_BuyResult typeid != MyRecordData.BuyObjTypeid  typeid="+typeid+" MyRecordData.BuyObjTypeid="+MyRecordData.BuyObjTypeid);
		}
	}
	public void Quit_Buy(int re,string typeid,int thisissandbox)
	{
		if (typeid == MyRecordData.BuyObjTypeid)
		{
			MyRecordData.issandbox = thisissandbox;
			MyRecordData.payresult=re;
			PlayerPrefs.SetInt ("issandbox", MyRecordData.issandbox);
			PlayerPrefs.SetInt("payresult", MyRecordData.payresult);
			MysdkMag.CanCalBuyOrder(MyRecordData);

		} else {
			Debug.LogError("error Set_BuyResult typeid != MyRecordData.BuyObjTypeid");
		}
	}
	*/
	//public void CheckCertificate_CB(string thisBuySvObjOrderId,bool result)
	//{
	//	if (result == true) {


	//	} else {
			//检查凭证 错误

	//	}
	//}
	/*
	public void CheckBuyCertificate()
	{
		MysdkMag.CheckBuyCertificate(MyRecordData);
	}*/
	public void ClearBuyRecord()
	{
		MyRecordData.BuyObjTypeid="";
		MyRecordData.BuySvObjOrderId="";
		MyRecordData.BuyCertificate="";
		MyRecordData.issandbox = -1;
		MyRecordData.payresult = -1;
		PlayerPrefs.SetInt ("issandbox", MyRecordData.issandbox);
		PlayerPrefs.SetString ("BuyObjTypeid", MyRecordData.BuyObjTypeid);
		PlayerPrefs.SetString ("BuySvObjUUID", MyRecordData.BuySvObjOrderId);
		PlayerPrefs.SetString ("BuyCertificate", MyRecordData.BuyCertificate);
		PlayerPrefs.SetInt ("payresult", MyRecordData.payresult);
		HasBuyObj=false;

	}
	public float checktime = 120f;
	float tempchecktime =0f;
	public void updatacheck(float dt)
	{
		if(MyRecordData.payresult!=-1)
		{
			tempchecktime+=dt;

			if(tempchecktime>=checktime)
			{
				tempchecktime = 0f;
				MysdkMag.SendSVOrderResult();
			}
		}

	}
	public void UpdataBuInfo()
	{
		PlayerPrefs.SetInt ("issandbox", MyRecordData.issandbox);
		PlayerPrefs.SetString("BuyObjTypeid", MyRecordData.BuyObjTypeid);
		PlayerPrefs.SetString("BuySvObjUUID", MyRecordData.BuySvObjOrderId);
		PlayerPrefs.SetString("BuyCertificate", MyRecordData.BuyCertificate);
		//PlayerPrefs.SetInt("BuyState", MyRecordData.BuyState);
	}
}
