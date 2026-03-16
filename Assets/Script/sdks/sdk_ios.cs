using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;
public class sdk_ios : lgsdkbase {



	override public void SonInitSdk()
	{

		Ios_IniSdk((int) mysdktype,(int)(mysdkp),SdkCBobjname,SdkCBFunname); 
	}

	//
	override public void SonAskBuy(string objtypeid,string orderid)
	{
		Ios_SdkBuy (objtypeid);  
	}

	override public void SonGet_Sdk_Msg(string msg)
	{
		
	}

	override public void SonDo_IniOk()
	{
		
	}
	

	override public void SonDo_IniOk_NoBuy()
	{
		
	}
	

	override public void SonDo_Login_Result()
	{
		
	}
	

	override public void SonDo_Loginout_user()
	{
		
	}
	

	override public void SonDo_NoBuyObj(string objtypeid)
	{


		Mymag.GetBuyResult(1, objtypeid, "",0);
	}
	

	override public void SonDo_Buy_Finish(string objtypeid,string receipt,string issandbox)
	{

		Mymag.GetBuyResult(0,objtypeid, receipt,int.Parse( issandbox));
	}
	

	override public void SonDo_Buy_Restored(string objtypeid)
	{

		Mymag.GetBuyResult(2,objtypeid, "",0);
	}
	

	override public void SonDo_Buy_Failed(string objtypeid)
	{

		Mymag.GetBuyResult(3,objtypeid, "",0);
	}
	

	override public void SonDo_Buy_Failed_cancel(string objtypeid)
	{

		Mymag.GetBuyResult(4,objtypeid, "",0);
	}
	[DllImport("__Internal")]  
	private static extern void Ios_IniSdk(int mysdktype,int sdkp,string SdkCBobjname,string SdkCBFunname);  


	[DllImport("__Internal")]  
	private static extern void Ios_LogoutSdk(); 

	[DllImport("__Internal")]  
	private static extern void Ios_SdkBuy(string buyobjtypeid);  


	/*
	[DllImport("__Internal")]  
	private static extern void XCLogin(int tag);

 

	[DllImport("__Internal")]  
	private static extern void XCSwitchAccount();

	[DllImport("__Internal")]  
	private static extern void XCIsLogined();
	[DllImport("__Internal")]  
	private static extern void XCSetDebug(); 

	[DllImport("__Internal")] 
	private static extern void XCSessionID();
	[DllImport("__Internal")]  
	private static extern void XCUserID(); 
	[DllImport("__Internal")]  
	private static extern void XCNickName(); 

	[DllImport("__Internal")]  
	private static extern void XCCheckUpdate();
	[DllImport("__Internal")]  
	private static extern void XCPayRMB(int amount);
	[DllImport("__Internal")]  
	private static extern void XSDKSetRechargeUserInfo(string roleId,string  roleName, string serverId);
	*/
}
