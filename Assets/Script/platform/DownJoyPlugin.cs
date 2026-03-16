using UnityEngine;
using System.Collections;

public class DownJoyPlugin : MonoBehaviour
{
    bool m_IsReady = true;

    public bool EnableDebugInfo = true;

    public bool EnableTestUI = true;

    float m_Timer = 0.0f;

    public bool LoginSuccess = false;

    public string LoginMessage = "";

    public string MemberID = "";

    public string UserName = "";

    public string Nickname = "";

    public string Token = "";

    public bool LogoutSuccess = false;

    public string LogoutMessage = "";

    public bool PaySuccess = false;

    public string PayMessage = "";

    static bool Init = false;

    // Use this for initialization
    void Start()
    {
		DontDestroyOnLoad(this.gameObject);
		//return;
        if (!Init)
        {
            Init = true;/*
            DontDestroyOnLoad(gameObject);
			DlBillingAndroid.Instance.InitDownjoy("PlatformMsg", "101", "195", "1", "j5VEvxhc");
            DlBillingAndroid.Instance.showDownjoyIconAfterLoginedForU3d(true);
			DlBillingAndroid.Instance.setInitLocationForU3d(DlBillingAndroid.LOCATION_LEFT_CENTER_VERTICAL);
			*/
        }
    }

    void OnGUI()
    {
		return;
        if (EnableDebugInfo)
        {
            GUI.skin.label.fontSize = Screen.width / 60;

            GUILayout.BeginVertical("BOX", GUILayout.Width(Screen.width));

            GUILayout.Label("Init =- " + Init + " FrameCount = "+ Time.frameCount.ToString());

            GUILayout.Label("Login = " + LoginSuccess );
			GUILayout.Label("debuginfo = " + platformSys.Ins.debug_str );

            if (LoginSuccess)
            {
                GUILayout.Label("MemberID = " + MemberID + " Username = " + UserName + " NickName = " + Nickname);

                GUILayout.Label("Token = " + Token);
            }

            GUILayout.Label("Logout = " + LogoutSuccess + " Message = " + LogoutMessage);

            GUILayout.Label("Pay = " + PaySuccess + " Message = " + PayMessage);

            GUILayout.EndVertical();
        }

        if (EnableTestUI && m_IsReady)
        {
            GUI.skin.button.fontSize = Screen.width / 60;
            GUILayout.BeginHorizontal("BOX");
            if (GUILayout.Button("Login", GUILayout.Height(Screen.height*0.2f)))
            {
                m_IsReady = false;
                DoLogin();
            }

            if (GUILayout.Button("Logout", GUILayout.Height(Screen.height * 0.2f)))
            {
                m_IsReady = false;
                DoLogout();
            }

            if (GUILayout.Button("Pay", GUILayout.Height(Screen.height * 0.2f)))
            {
                OpenDownJoyPay(0.01f, "測試商品", "Test");
                m_IsReady = false;
            }

            GUILayout.EndHorizontal();
        }
    }

    public void DoLogin()
    {
        ResetLogin();
		DlBillingAndroid.Instance.Log("DlBillingAndroid.Instance.doLogin");
		DlBillingAndroid.Instance.doLogin("OnLoginSuccess", "OnLoginFail", "OnLoginSystemFail");
    }

    public void DoLogout()
    {
        ResetLogin();
        DlBillingAndroid.Instance.doLogout("OnLogoutSuccess", "OnLoginFail", "OnLogoutSystemFail");
    }

    public void OpenDownJoyPay(float Money, string ProductInfo, string CPInfo)
    {
        PaySuccess = false;
        DlBillingAndroid.Instance.doPaymentDialogMin("OnPaySuccess", "OnPayFail", "OnPaySystemFail", Money.ToString(), ProductInfo, CPInfo);
    }

    // Update is called once per frame
    void Update()
    {
        if (!m_IsReady)
        {
            m_Timer += Time.deltaTime;
            if (m_Timer > 3.0f)
            {
                m_IsReady = true;
                m_Timer = 0.0f;
            }
        }
    }


    void ResetLogin()
    {
        LoginSuccess = false;
        LoginMessage = "";
        MemberID = "";
        UserName = "";
        Nickname = "";
        Token = "";
    }

    void OnLoginSuccess(string arg)
    {
		platformSys.Ins.debug_str = "OnLoginSuccess";
        //登录成功后在回调函数sucmethod中可以获得用户信息如memberId + "|" + username + "|" + nickname + "|" + token
        LoginSuccess = true;
        LoginMessage = arg;
        Debug.Log("LoginSuccess, msg = " + arg);
		DlBillingAndroid.Instance.Log(arg);
        string[] _Args = arg.Split('|');
        if (_Args.Length == 4)
        {
            MemberID = _Args[0];
            UserName = _Args[1];
            Nickname = _Args[2];
            Token = _Args[3];
			string str = string.Format("LoginResult:1_{0}_{1}_{2}",MemberID,Nickname,Token);
			platformSys.Ins.handle_xcode_msg(str);
        }
        else
        {
            LoginSuccess = false;
            Debug.LogError("OnLoginSuccess parse login message error, msg = " + LoginMessage);
        }

        //DlBillingAndroid.Instance.showDownjoyIconAfterLoginedForU3d (true);
        //DlBillingAndroid.Instance.setInitLocationForU3d (DlBillingAndroid.FloatLocal.LOCATION_LEFT_TOP);
    }

    void OnLoginFail(string arg)
    {
        LoginSuccess = false;
        LoginMessage = arg;
        Debug.Log("LoginFail, msg = " + arg);
		platformSys.Ins.debug_str = "OnLoginFail";
    }

	void OnLoginSystemFail(string arg)
	{
		LoginSuccess = false;
		LoginMessage = arg;
		Debug.Log("OnLoginSystemFail, msg = " + arg);
		platformSys.Ins.debug_str = "OnLoginSystemFail";
	}

    void OnLogoutSuccess(string arg)
    {
        Debug.Log("OnLogoutSuccess, msg = " + arg);
        LogoutSuccess = true;
        LogoutMessage = arg;
    }

    void OnLogoutFail(string arg)
    {
        Debug.Log("OnLogoutFail, msg = " + arg);
        LogoutSuccess = false;
        LogoutMessage = arg;
    }

    void OnLogoutSystemFail(string arg)
    {
        Debug.Log("OnLogoutSystemFail, msg = " + arg);
        LogoutSuccess = false;
        LogoutMessage = arg;
    }

    void OnPaySuccess(string arg)
    {
        Debug.Log("OnPaySuccess, msg = " + arg);
        PaySuccess = true;
        PayMessage = arg;
    }

    void OnPayFail(string arg)
    {
        Debug.Log("OnPayFail, msg = " + arg);
        PaySuccess = false;
        PayMessage = arg;
    }

    void OnPaySystemFail(string arg)
    {
        Debug.Log("OnPaySystemFail, msg = " + arg);
        PaySuccess = false;
        PayMessage = arg;
    }
	
	void OnMemberCenterSuccess(string arg)
    {
        Debug.Log("OnMemberCenterSuccess, msg = " + arg);       
    }

    void OnMemberCenterstemFail(string arg)
    {
        Debug.Log("OnMemberCenterstemFail, msg = " + arg);
      
    }
	
	//========================u9time callback=====================================
	void u9_init_succ(string srg)
	{
        Debug.LogError("sdk 回调=========u9_init_succ===================================");
        //platformSys.Ins.handle_xcode_msg("InitDone:1_10006");
        string str = string.Format("InitDone:1_{0}",srg);
		platformSys.Ins.handle_xcode_msg(str);
		
	}
	void u9_init_fail(string srg)
	{
        Debug.LogError("sdk 回调=========u9_init_fail===================================");
    }
	//< login
	void u9_login_succ(string srg)
	{
        Debug.LogError("sdk 回调=========u9_login_succ===================================");
		string[] _Args = srg.Split('_');
        if (_Args.Length == 4)
        {
            MemberID = _Args[0];
            UserName = _Args[1];
            Nickname = _Args[2];
            Token = _Args[3];
			string str = string.Format("LoginResult:1_{0}_{1}_{2}",MemberID,Nickname,Token);
			platformSys.Ins.handle_xcode_msg(str);
        }
        else
        {           
            Debug.LogError("OnLoginSuccess parse login message error, msg = " + LoginMessage);
        }
	}
	void u9_login_fail(string srg)
	{
		string str = string.Format("LoginResult:0_{0}_{1}_{2}",0,0,0);
		platformSys.Ins.handle_xcode_msg(str);
	}
	void u9_login_sysfail(string srg)
	{
		string str = string.Format("LoginResult:0_{0}_{1}_{2}",0,0,0);
		platformSys.Ins.handle_xcode_msg(str);
	}
	
	//9/23 u999
	void u9_quit_Game()
	{
        Debug.LogError("游戏执行注销。。。。。");
		Application.Quit();
	}
	
	//9/23 u999
	void u9_Pop_ExipPanel()
	{
		//lgNoDelCsFun.Ins.PopExitGamePanel("");
	}
	
	//< enter memcenter
	void u9_entermembercent_succ(string srg)
	{
		Debug.LogError("u9_entermembercent_succ");
	}
	void u9_entermembercent_fail(string srg)
	{
		Debug.LogError("u9_entermembercent_fail");
	}
	void u9_enter_game_succ(string srg)
	{
		if(srg.Contains("DidLogout"))
		{
			platformSys.Ins.handle_xcode_msg("DidLogout");
		}
		Debug.LogError("u9_enter_game_succ:  " + srg);
	}
	void u9_enter_game_fail()
	{
		
	}
	//< logout
	void u9_logout_succ(string srg)
	{
		platformSys.Ins.handle_xcode_msg("DidLogout");
	}

    //< 渠道浮标请求注销
    void qd_ask_logout(string srg)
    {
        //lgNoDelCsFun.Ins.QDLoginGame(1);
        //lgNoDelCsFun.Ins.U9Logout();
    }
	void u9_logout_fail(string srg)
	{
		
	}
	void u9_logout_sysfail(string srg)
	{
		
	}
    //< antiAddictionQuery
    void u9_anti_addiction_query_succ(string srg)
    {
        Debug.LogWarning("cs_u9_anti_addiction_query_succ:" + srg);
    }
    //< 防沉迷注册后，继续查询
    void u9_anti_addiction_query_fail(string srg)
    {
        Debug.LogWarning("u9_anti_addiction_query_fail:" + srg);
        SDK.c_sdk_antiAddictionQuery();
    }
    //< SDKPayment
    void u9_SDKPayment_succ(string srg)
	{
		platformSys.Ins.handle_xcode_msg("BuyGoodsSuccess");
	}
	void u9_SDKPayment_fail(string srg)
	{
		platformSys.Ins.handle_xcode_msg("BuyGoodsFailedWithCode");
	}
	void u9_SDKPayment_sysfail(string srg)
	{
		platformSys.Ins.handle_xcode_msg("BuyGoodsFailedWithCode");
	}

    //?< 用户中心
    void u9_sdk_GCUserCenter_succ(string msg)
    {
        platformSys.Ins.handle_xcode_msg("u9_sdk_GCUserCenter_succ");
    }
    void u9_sdk_GCUserCenter_fail(string msg)
    {
        platformSys.Ins.handle_xcode_msg("u9_sdk_GCUserCenter_fail");
    }
   
    //< momo
    //< 分享
    void u9_momo_share_succ()
    {

    }
    void u9_momo_share_fail()
    {

    }

    //< momo注销
    void u9_momo_logout_succ()
    {

    }
    void u9_momo_logout_fail()
    {

    }

    //< momo 吧
    void u9_momo_tieba_succ()
    {
    }
    void u9_momo_tieba_fail()
    {
    }
    //< momo 客服
    void u9_momo_kefu_succ()
    {
    }
    void u9_momo_kefu_fail()
    {
    }

    //< efun 
    void efun_payment_succ(string srg)
    {
    }
    void efun_payment_fail(string srg)
    {
    }

	//< common
	void u9_func_succ()
	{
	}
	void u9_func_fail()
	{

	}
    void u9_func_sys()
    {

    }
}
