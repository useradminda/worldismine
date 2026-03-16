using UnityEngine;
using System;
using System.Collections.Generic;
/**
 * Billing script class for encapsulating java api in libs\CMBilling.jar.
 */ 
public class DlBillingAndroid
{
    //#if UNITY_ANDROID
    // The reflected class of java api of lib.jar
    //private AndroidJavaClass klass = new AndroidJavaClass("com.downjoy.Downjoy");
    
    // The instance of billing script.
    private static DlBillingAndroid _instance;
    public static DlBillingAndroid Instance
    {
        get
        {
            if(_instance==null){
                _instance = new DlBillingAndroid();
            }
            return _instance;
        }
    }

	// 浮标显示位置标记
    public static int LOCATION_LEFT_TOP = 0;

    public static int LOCATION_LEFT_CENTER_VERTICAL = 1;

    public static int LOCATION_LEFT_BOTTOM = 2;

    public static int LOCATION_RIGHT_TOP = 3;

    public static int LOCATION_RIGHT_CENTER_VERTICAL = 4;

    public static int LOCATION_RIGHT_BOTTOM = 5;

    public static int LOCATION_CENTER_HORIZONTAL_TOP = 6;

    public static int LOCATION_CENTER_HORIZONTAL_BOTTOM = 7;
    /**
     * Initialize billing SDK's instance.It should be invoked at the beginning of the app.
     * @param main The activity environment for SDK's UI displaying.
     
    public void InitializeApp()
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass ("com.unity3d.player.UnityPlayer")) {
            using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
                klass.CallStatic("initializeApp", curActivity);
            }
        }
    }*/
    
    /** 
     * Return active flag of the specified index billinginfo 
     * @param billingIndex The index of billing point saved in assets\ConsumeCodeInfo.xml.
     * @return The active flag of first billing index.
     
    public bool GetActivateFlag(String index)
    {
        return klass.CallStatic<bool>("getActivateFlag", index);
    }*/
    
    /** 
     * Set active status of the specified index billinginfo 
     * @param billingIndex The billing index need to save its actived flag.
     * @param flag The value of actived flag.
     
    public void SetActivateFlag(String index, bool flag)
    {
        klass.CallStatic("setActivateFlag", index, flag);
    }*/
    
    /**
     * Whehter user open the switch of music, if true game developer need implement the music logic.
     * @return true for open background music, false otherwise.
     
    public bool IsMusicEnabled()
    {
        return klass.CallStatic<bool>("isMusicEnabled");
    }*/
    
    /**
     * Start billing view with special billing index.
     * @param useSms Whether use sms billing mode or not.
     * @param isRepeated Whether this billing point is repeated billing point.
     * @param index The billing index to charge.
     * @param gameObject Game Object in Unity Games.
     * @param runtimeScriptMethod The runtime script method which implement the callback of getting billing result.
     
    public void DoBilling(bool useSms, bool isRepeated, String index, String gameObject, String runtimeScriptMethod)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass ("com.unity3d.player.UnityPlayer")) {
            using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
                klass.CallStatic("doBillingForUnity", curActivity, useSms, isRepeated, index, "", gameObject, runtimeScriptMethod);
            }
        }
    }*/
    public void InitDownjoy(string gameObject, string merchantId, string appId, string serverSeqNum, string appKey) {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass ("com.downjoy.U3DActivity")) {
            unityPlayer.CallStatic("InitDownjoy", gameObject, merchantId, appId, serverSeqNum, appKey);
        }
    }

    public void Log(string msg)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass ("com.downjoy.U3DActivity")) {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("Log", msg);
            //}
        }
    }
    //登录
    //登录成功后在回调函数sucmethod中可以获得用户信息如memberId + "|" + username + "|" + nickname + "|" + token
    //登录错误后在回调函数failmethod获得错误信息
	public void doLogin(string sucmethod, string failmethod, string systemfail)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass ("com.downjoy.U3DActivity")) {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
			unityPlayer.CallStatic("doLogin", sucmethod, failmethod, systemfail);
            //}
        }
    }
    //个人中心
	public void enterMemberCenter(string sucmethod, string systemfail)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass ("com.downjoy.U3DActivity")) {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
			unityPlayer.CallStatic("enterMemberCenter", sucmethod, systemfail);
            //}
        }
    }

    //登出
    //登出错误可以获得错误代码和错误信息errorCode + "|" + errorMsg
    public void doLogout(string sucmethod, string failmethod, string systemfail)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass ("com.downjoy.U3DActivity")) {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("doLogout", sucmethod, failmethod, systemfail);
            //}
        }
    }

    // 进入商品支付(0)
    //支付成功sucmethod获得订单号
    //支付失败failmethod获得错误代码 错误信息和订单号errorCode + "|" + errorMsg + "|" + orderNo
    // 系统错误systemfail
    public void doPaymentDialog(string sucmethod, string failmethod, string systemfail, string productinfo, string extinfo)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass ("com.downjoy.U3DActivity")) {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("doPaymentDialog", sucmethod, failmethod, systemfail, productinfo, extinfo);
            //}
        }
    }

    // 进入商品支付(0.1)
    //支付成功sucmethod获得订单号
    //支付失败failmethod获得错误代码 错误信息和订单号errorCode + "|" + errorMsg + "|" + orderNo
    public void doPaymentDialogMin(string sucmethod, string failmethod, string systemfail, string money, string productinfo, string extinfo)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass ("com.downjoy.U3DActivity")) {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("doPaymentDialogMin", sucmethod, failmethod, systemfail, money, productinfo, extinfo);
            //}
        }
    }

    // 获取用户信息
    //获取成功sucmethod可以获得如下信息memberId + "|" + username + "|" + nickname + "|" + gender + "|" + level + "|" + avatarUrl + "|" + createdDate
    //获取失败failmethod可以获得errorCode + "|" + errorMsg
    public void doGetInfo(string sucmethod, string failmethod, string systemfail)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass ("com.downjoy.U3DActivity")) {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("doGetInfo", sucmethod, failmethod, systemfail);
            //}
        }
    }
    // 录后是否显示浮标
    public void showDownjoyIconAfterLoginedForU3d(bool show)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass ("com.downjoy.U3DActivity")) {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("showDownjoyIconAfterLoginedForU3d", show);
            //}
        }
    }
    // 设置浮标位置
    public void setInitLocationForU3d(int loc)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass ("com.downjoy.U3DActivity")) {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("setInitLocationForU3d", loc);
            //}
        }
    }
    // 显示浮标
    public void showFloatingButtonForU3d()
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass ("com.downjoy.U3DActivity")) {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("showFloatingButtonForU3d");
            //}
        }
    }
    // 隐藏浮标
    public void hideFloatingButtonForU3d()
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass ("com.downjoy.U3DActivity")) {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("hideFloatingButtonForU3d");
            //}
        }
    }
	//<=========================u9time ===========================
	 public void SDKInit(string gameObject,string sucmethod, string failmethod ) {
         using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.u9time.dhz.DragonActivity"))
         {
            unityPlayer.CallStatic("SDKInit", "PlatformMsg", sucmethod, failmethod);
           // Debug.LogError(sucmethod + " " + failmethod + "========================================================");
        }
    }
	 //登录
    //登录成功后在回调函数sucmethod中可以获得用户信息如memberId + "|" + username + "|" + nickname + "|" + token
    //登录错误后在回调函数failmethod获得错误信息
	public void SDKLogin(string sucmethod, string failmethod, string systemfail)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.u9time.dhz.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
			unityPlayer.CallStatic("SDKLogin", sucmethod, failmethod, systemfail);
            //}
        }
    }
	
	//< 进入游戏
	public void SDKEnterGame(string sucmethod, string failmethod,string svr_id,string svr_name)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.u9time.dhz.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("SDKEnterGame", sucmethod, failmethod, svr_id, svr_name);
            //}
        }
    }
	
	//< U99999999999 角色创角统计
	public void SDKCreateRole(string roleId,string roleName,string roleLevel, string serverId , string serverName , string roleCreateTime  , string roleLevelUpTime)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.u9time.dhz.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("SDKCreateRole", roleId, roleName, roleLevel, serverId ,serverName , roleCreateTime , roleLevelUpTime);
            //}
        }
    }
	//U9角色升级统计
    public void SDKRoleLvlUp(string roleId,string roleName,string roleLevel, string serverId , string serverName , string roleCreateTime  , string roleLevelUpTime)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.u9time.dhz.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("SDKRoleLvlUp", roleId, roleName, roleLevel, serverId ,serverName , roleCreateTime , roleLevelUpTime);
            //}
        }
    }

	public void SDKRoleEnterGameHome(string roleId,string roleName,string roleLevel, string serverId , string serverName , string roleCreateTime  , string roleLevelUpTime)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.u9time.dhz.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("SDKRoleEnterGameHome", roleId, roleName, roleLevel, serverId ,serverName , roleCreateTime , roleLevelUpTime);
            //}
        }
    }
	
    //个人中心com.u9time.dhz
    public void SDKEnterMemberCenter(string sucmethod, string systemfail,string logoutfunc)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.u9time.dhz.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
			unityPlayer.CallStatic("SDKEnterMemberCenter", sucmethod, systemfail,logoutfunc);
            //}
        }
    }

    //登出
    //登出错误可以获得错误代码和错误信息errorCode + "_" + errorMsg
    public void SDKLogout(string sucmethod, string failmethod, string systemfail)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.u9time.dhz.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("SDKLogout", sucmethod, failmethod, systemfail);
            //}
        }
    }

    public void SDKOpenBBS(string sucmethod, string failmethod, string systemfail)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.u9time.dhz.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("SDKOpenBBS", sucmethod, failmethod, systemfail);
            //}
        }
    }
    //< U9用户中心 9/22
    public void SDKGCUserCenter()
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.u9time.dhz.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("SDKRoleEnterUserCenter");
            //}
        }
    }
    //< U9游戏更新 9/22
    public void SDKGCGameUpdate()//string sucmethod, string failmethod, string systemfail)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.u9time.dhz.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("SDKGameUpdate");//, sucmethod, failmethod, systemfail);
            //}
        }
    }

    //< U9创建角色 9/22
    public void SDKGCCreateRole(string sucmethod, string failmethod, string systemfail)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.u9time.dhz.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("SDKCreateRole", sucmethod, failmethod, systemfail);
            //}
        }
    }


    //< U9角色进入大厅 9/22
    public void SDKGCEnterGameHome(string sucmethod, string failmethod, string systemfail)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.u9time.dhz.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("u9GCGameUpdate", sucmethod, failmethod, systemfail);
            //}
        }
    }

    //< U9角色升级 9/22
    public void SDKGCRoleLevelUp(string sucmethod, string failmethod, string systemfail)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.u9time.dhz.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("u9GCGameUpdate", sucmethod, failmethod, systemfail);
            //}
        }
    }
	
	//U9游戏注销  9/22
	public void SDKLogout()
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.u9time.dhz.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("SDKU9Logout");
            //}
        }
    }
	
    //< 退出游戏 9/22
    public void SDKGCExitGame()
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.u9time.dhz.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("SDKExitGame");
            //}
        }
    }
	
	
	
    public void SDKAntiAddictionQuery(string qihooUserId, string sucmethod, string failmethod)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.u9time.dhz.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("SDKAntiAddictionQuery", qihooUserId, sucmethod, failmethod);
            //}
        }
    }

    // 进入商品支付(0.1)
    //支付成功sucmethod获得订单号
    //支付失败failmethod获得错误代码 错误信息和订单号errorCode + "|" + errorMsg + "|" + orderNo
    public void SDKPayment(string sucmethod, string failmethod, string systemfail, string _Money, string QUANTITY, string PRODUCT_ID,
        string VIRTUAL_QUANTITY, string PRODUCT_NAME, string SERVER_ID, string EXTRA,
        string CURRENCY, string PRODUCT_DESC)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.u9time.dhz.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("SDKPayment", sucmethod, failmethod, systemfail, _Money, QUANTITY, PRODUCT_ID,
           VIRTUAL_QUANTITY, PRODUCT_NAME, SERVER_ID, EXTRA, CURRENCY, PRODUCT_DESC);
            //}
        }
    }
	  // 录后是否显示浮标
    public void SDKshowDownjoyIconAfterLoginedForU3d(bool show)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.u9time.dhz.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("SDKshowDownjoyIconAfterLoginedForU3d", show);
            //}
        }
    }
    // 设置浮标位置
    public void SDKsetInitLocationForU3d(int loc)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.u9time.dhz.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObjectUnityPlayerActivitycurrentActivity")) {
            unityPlayer.CallStatic("SDKsetInitLocationForU3d", loc);
            //}
        }
    }
    public string get_rmbgoods_buy_info()
    {
        return "";
    }

    //< efun 购买
    public void SDKTBPayRMB_Order_Efun(string roleID, string svrID, string roleName, string roleLvl, string remark, string worldID, string surplusDay)
    {
        string ginfo = get_rmbgoods_buy_info();
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.u9time.dhz.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("SDKEFunGooglePay", "efun_payment_succ", "efun_payment_fail", roleID, svrID, roleName, roleLvl, remark, worldID, surplusDay, ginfo);
            //}
        }
    }

    //< 调用小图标
    public void SDKTBshowPlatFormWithBaseView_Efun(string svrID, string roleID, string roleLvl)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.u9time.dhz.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("SDKEFunIconShowAfterLogin", "1", "2", svrID, roleID, roleLvl);
            //}
        }
    }
    //?< momo相关
    //< 分享
    public void SDKMomoShare(string content,string imgpath)
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.u9time.dhz.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("SDKMomoShare", "u9_momo_share_succ","u9_momo_share_fail",content, imgpath);
            //}
        }
    }

    //< momo注销
    public void SDKMomoLogout()
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.youlongteng.kkams.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("SDKMomoLogout", "u9_momo_logout_succ", "u9_momo_logout_fail");
            //}
        }
    }

    //< momo吧
    public void SDKMomoTieBa()
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.youlongteng.kkams.DragonActivity"))
        {
            //using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
            unityPlayer.CallStatic("SDKMomoTieBa", "u9_momo_tieba_succ", "u9_momo_tieba_fail");
            //}
        }
    }
	
    //< momo 客服
    public void SDKMomoCustomerService()
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.youlongteng.kkams.DragonActivity"))
        {
            unityPlayer.CallStatic("SDKMomoCustomerService", "u9_momo_kefu_succ", "u9_momo_kefu_fail");            
        }
    }

	/**
 * 设置用户支付信息（在用户登录成功后调用）
 * @param sucmethod
 * @param failmethod
 * @param roleId 游戏角色id
 * @param roleName 游戏角色名字
 * @param serverId 游戏角色所在区服id
 */
	public  void SDKSetRechargeUserInfo(string roleId,string  roleName, string serverId)
	{
		using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.youlongteng.kkams.DragonActivity"))
		{
			unityPlayer.CallStatic("SDKSetRechargeUserInfo", "u9_func_succ", "u9_func_fail",roleId,roleName,serverId);            
		}
	}
    /** 
     * Return billing result of the specified index billinginfo 
     * @param billingIndex The index of billing point saved in assets\ConsumeCodeInfo.xml.
     * @return The billing result. See the constant definition of class <BillingResult>
     
    public String GetBillingResult(String index)
    {
        return klass.CallStatic<String>("getBillingResult", index);
    }*/
    
    /**
     * Start SDK's exit UI.
    
    public void ExitWithUI()
    {
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass ("com.unity3d.player.UnityPlayer")) {
            using (AndroidJavaObject curActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity")) {
                klass.CallStatic("exit", curActivity);
            }
        }
    } */

    /**
     * Release SDK's instance.
     
    public void Exit()
    {
        klass.CallStatic("exitApp");
    }*/

    //#endif


}