using UnityEngine;
using System.Collections;
using gotye;

public class Login : GotyeMonoBehaviour, LoginListener {
	public GotyeAPI api;
	void Start()
	{
		api = GotyeAPI.GetInstance ();
		api.AddListener (this);
	}

	public void onLogin(GotyeStatusCode code,GotyeUser user)
	{
		Debug.Log ("Chat Login code = " + code);
		if (code == GotyeStatusCode.CodeOK || code == GotyeStatusCode.CodeReloginOK) 
		{
			lgChatMag.Ins.LoginOk(user);
		}
	}

	public void onLogout(GotyeStatusCode code)
	{		
		Debug.Log ("Chat onLogout code = " + code);
	}

	public void onReconnecting(GotyeStatusCode code, GotyeUser currentUser)
	{		
	}
}
