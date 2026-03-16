using UnityEngine;
using System.Collections;
using gotye;
using System.Collections.Generic;

public class Friend : GotyeMonoBehaviour, UserListener {
	public GotyeAPI api;
	public List<GotyeUser> friendList = new List<GotyeUser>();
	void Start()
	{        
		api = GotyeAPI.GetInstance ();
		api.AddListener (this);
	}

	public void onAddFriend (GotyeStatusCode code,GotyeUser friend)
	{
		//添加好友成功后，刷新好友列表
		api.ReqFriendList ();
	}

	public void onGetFriendList(GotyeStatusCode code,List<GotyeUser> list)
	{
		friendList = list;
	}
}
