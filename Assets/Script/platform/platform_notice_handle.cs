using UnityEngine;
using System.Collections;

public class platform_notice_handle : MonoBehaviour
{

	// Use this for initialization
	void Start ()
	{
		DontDestroyOnLoad(this);
	}
	
	// Update is called once per frame
	void Update ()
	{
		
	}
	public void XCODE_sendMessage(string msg)
	{
		platformSys.Ins.handle_xcode_msg(msg);
	}
}

 