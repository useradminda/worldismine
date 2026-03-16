using UnityEngine;
using System.Collections;

public class net_msg_id_define
{
	public static int NM_OK = 0;						//< 本次webquest正常，解压正常、消息分派到下层解析-
	public static int NM_TIMEOUT = -9999;				//< 本次请求超时-
	public static int NM_HTTP_ERROR = -9998;			//< 本次请求http错误-
	public static int NM_DESEncrypt_ERROR = -9997;		//< 数据包解密错误-	
	
	
	public static int NM_LOGOUT = 102;						//< 账号被登出
	public static int NM_PARAM_ERROR = 403;					//< 客户端传入的参数错误
	public static int NM_PID_ERROR = 100;					//< 玩家ID为空
	public static int NM_NO_PLAYTER = 101;					//< 没这个玩家
	public static int NM_WRONG_TOKEN = 102;					//< 错误的签证
	public static int NM_WRONG_REQUEST = 200;				//< 错误的请求
	
	public static int NM_ERROR_SERVER_ASSERT = 9001;				//< 服务器维护
	public static int NM_CLIENT_NEED_UPDATE = 9002;				//< 更新客户端
	public static int NM_ACC_SEAL = 9003;				//< 玩家被封号
	public static int NM_DATA_FAIL = 9004;				//< 数据更新，需要重新启动游戏
	public static int NM_TOKEN_FAIL = 9005;				//< token超时，需要重新启动游戏
	//public static int NM_DATA_FAIL = 9005;				//< 数据更新，需要重新启动游戏
	
	
	public static int NM_Param_Error = 1001;				//< 参数错误
	public static int NM_Another_PlayerOn = 1002;				//< 其他设备登陆
	public static int NM_Package_Error = 1003;				//< 数据包无法解析
	public static int NM_Planet_On_Error = 1004;				//< 登录平台失败
	public static int NM_Planet_Test_Error = 1005;				//< 平台验证失败
	public static int NM_Login_Error = 1006;				//< 登录失败
	//public static int NM_WRONG_TOKEN = 201;
	
	public static int CPPServerError = 1007;				//C++服务器超时
	
	public static int NetError = 2;
	
}

