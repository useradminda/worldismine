using UnityEngine;
using System.Collections;

using gotye;
public class GroupChatMag : GotyeMonoBehaviour, GroupListener {

	// Use this for initialization
	void Start () {
		//Debug.Log ("testchat  ");
		api = GotyeAPI.GetInstance ();
		api.AddListener (this);
	}

	public GotyeGroup GetGroupInfo(long Groupid)
	{
		GotyeGroup group = api.getGroupDetail (Groupid, true);
		return group;
	}
	public void onGetGroupDetail(GotyeStatusCode code, GotyeGroup group)
	{
		if (code == GotyeStatusCode.CodeOK) {
			lgChatMag.Ins.GetGroupInfo (group);
		} else {
			Debug.LogError("onGetGroupDetail error code="+code.ToString());

		}
	}
	public void  onJoinGroup(GotyeStatusCode code,GotyeGroup group)
	{
		//if (code == GotyeStatusCode.CodeOK) {

		
		Debug.LogError("onJoinGroup  code="+code.ToString()+" group ID="+group.ID);
			
		//}
	}
}
