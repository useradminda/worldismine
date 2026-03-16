using UnityEngine;
using System.Collections;
using gotye;
using System.Collections.Generic;

public class Room : GotyeMonoBehaviour,RoomListener {
	public GotyeAPI api;
	void Start()
	{
		api = GotyeAPI.GetInstance ();
		api.AddListener (this);
	}

	public void onEnterRoom(GotyeStatusCode code, GotyeRoom room)
	{
		ChatManager.Ins.worldRoom = room;
		Debug.Log ("onEnterRoom " + code);
	}
}
