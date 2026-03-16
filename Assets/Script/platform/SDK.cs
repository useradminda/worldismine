using UnityEngine;
using System.Collections;

public class SDK  {
    public static int is_init = 0;
    public static int is_entergame = 0;
    public static void c_sdk_init()
    {
        Debug.LogError("c_sdk_init============================================");
        DlBillingAndroid.Instance.SDKInit("PlatformMsg", "u9_init_succ", "u9_init_fail");
    }



    //< 登录
    public static void c_sdk_login()
    {
        if(is_init<=0)
        {
            c_sdk_init();
            is_init++;
        }
        
        Debug.LogError("c_sdk_login============================================");
        Debug.LogError("调通平台登陆接口");

        DlBillingAndroid.Instance.SDKLogin("u9_login_succ", "u9_login_fail", "u9_login_sysfail");
    }
    //< 登出注销
    public static void c_sdk_logout()
    {
                Debug.LogError("c_sdk_logout============================================");
        

        DlBillingAndroid.Instance.SDKLogout("u9_logout_succ", "u9_logout_fail", "u9_logout_sysfail");
    }
    //< 用户中心
    public static void c_sdk_GCUserCenter()
    {
        Debug.LogError("c_sdk_GCUserCenter============================================");
        DlBillingAndroid.Instance.SDKGCUserCenter();
    }
    
	

    //< 创建角色
   /* public static void c_sdk_u9GCCreateRole()
    {
        Debug.LogError("c_sdk_u9GCCreateRole============================================");
		
    }
    //< 角色进入大厅
    public static void c_sdk_u9GCEnterGameHome()
    {
        Debug.LogError("c_sdk_u9GCEnterGameHome============================================");
    }*/
	
	
	
	
    //< U99999999角色创角统计	ID 名字 等级  服务器名字 创角时间 9/22
    public static void c_sdk_u9GCRCreateRole(string roleId,string roleName,string roleLevel, string serverId , string serverName , string roleCreateTime  , string roleLevelUpTime)
    {
        Debug.LogError("c_sdk_u9GCRCreateRole============================================");
		DlBillingAndroid.Instance.SDKCreateRole(roleId, roleName, roleLevel, serverId ,serverName , roleCreateTime , roleLevelUpTime);
    }
	
	//U99999角色升级统计 9/22
	public static void c_sdk_u9GCRoleLevelUp(string roleId,string roleName,string roleLevel, string serverId , string serverName , string roleCreateTime  , string roleLevelUpTime)
    {
        Debug.LogError("c_sdk_u9GCRoleLevelUp============================================");
		DlBillingAndroid.Instance.SDKRoleLvlUp(roleId, roleName, roleLevel, serverId ,serverName , roleCreateTime , roleLevelUpTime);
    } 
	//U99999角色进入主城 9/22
	public static void c_sdk_u9GCRoleEnterGameHome(string roleId,string roleName,string roleLevel, string serverId , string serverName , string roleCreateTime  , string roleLevelUpTime)
    {
        if (is_entergame<1)
        {
            is_entergame++;
            Debug.LogError("c_sdk_u9GCRoleEnterGameHome============================================");
            DlBillingAndroid.Instance.SDKRoleEnterGameHome(roleId, roleName, roleLevel, serverId, serverName, roleCreateTime, roleLevelUpTime);
        }
       
    } 
	
	//< U9游戏版本更新 9/22
    public static void c_sdk_u9_sdk_GCGameUpdate()
    {
        Debug.LogError("c_sdk_u9_sdk_GCGameUpdate============================================");
        DlBillingAndroid.Instance.SDKGCGameUpdate();//"u9_func_succ", "u9_func_fail", "u9_func_sys");
    }
	
	//<u9用户中心 9/23
	public static void c_sdk_u9_sdk_SDKGCUserCenter()
    {
        Debug.LogError("c_sdk_u9_sdk_SDKGCUserCenter============================================");
        DlBillingAndroid.Instance.SDKGCUserCenter();//"u9_func_succ", "u9_func_fail", "u9_func_sys");
    }
	
	
	
	//U99999角色登出 9/22
	public static void c_sdk_u9GCLogout()
    {
        Debug.LogError("c_sdk_u9GCLogout============================================");       
        DlBillingAndroid.Instance.SDKLogout();
    }
	
	//u9退出游戏
	public static void c_sdk_U9ExitGame()
	{
		Debug.LogError("c_sdk_U9ExitGame============================================");       
        DlBillingAndroid.Instance.SDKGCExitGame();
	}
	
	
	
	
	
    //< 退出游戏
    public static void c_sdk_u9GCExitGame()
    {
        Debug.LogError("c_sdk_u9GCExitGame============================================");
    }
    public static void c_sdk_openBBS()
    {
        Debug.LogError("c_sdk_openBBS============================================");
        Debug.LogError("调通平台OpenBSS接口");
        DlBillingAndroid.Instance.SDKOpenBBS("", "", "");
    }

    public static void c_sdk_antiAddictionQuery()
    {
        Debug.LogError("c_sdk_antiAddictionQuery============================================调通平台c_sdk_antiAddictionQuery接口,token=" + basePlatform.pl_userInfo.token + ",uuid=" + basePlatform.pl_userInfo.uuid);
        //lgNoDelCsFun.Ins.AntiAddicitionQuery();
    }

    //SDKPayment
    public static void c_sdk_payment(string _Money, string QUANTITY, string PRODUCT_ID,
        string VIRTUAL_QUANTITY, string PRODUCT_NAME, string SERVER_ID, string EXTRA,
        string CURRENCY, string PRODUCT_DESC)
    {
        if (PRODUCT_DESC == "UI_Icon_Shop_Gem1")
        {
            PRODUCT_NAME = "60钻石";
        }
        if (PRODUCT_DESC == "UI_Icon_Shop_Gem2")
        {
            PRODUCT_NAME = "300钻石";
        }
        if (PRODUCT_DESC == "UI_Icon_Shop_Gem3")
        {
            PRODUCT_NAME = "980钻石";
        }
        if (PRODUCT_DESC == "UI_Icon_Shop_Gem4")
        {
            PRODUCT_NAME = "3280钻石";
        }
        if (PRODUCT_DESC == "UI_Icon_Shop_Gem5")
        {
            PRODUCT_NAME = "6480钻石";
        }
        if (PRODUCT_DESC == "UI_Icon_Shop_Gem6")
        {
            PRODUCT_NAME = "19980钻石";
        }
        if (PRODUCT_DESC == "UI_Icon_Shop_Gem7")
        {
            PRODUCT_NAME = "月卡";
        }
        
        Debug.LogError("c_sdk_payment============================================调通平台c_sdk_payment接口");
        Debug.LogError("---------------------------------------------" + PRODUCT_NAME);
        //金额、商品id，商品名称、订单id 必须的 额外信息：服务器id
        //商品信息，开发商信息 是可选的
        //final String sucmethod, final String failmethod, String systemfail, String Money, String ProductInfo,String CPInfo, String serverId, String productId
        DlBillingAndroid.Instance.SDKPayment("u9_SDKPayment_succ", "u9_SDKPayment_fail", "u9_SDKPayment_sysfail", _Money, QUANTITY, PRODUCT_ID,
           VIRTUAL_QUANTITY, PRODUCT_NAME, SERVER_ID, EXTRA, CURRENCY, PRODUCT_DESC);//
    }
}
