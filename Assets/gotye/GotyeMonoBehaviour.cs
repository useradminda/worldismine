using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using gotye;
using System.Threading;
using System;
public class GotyeMonoBehaviour : MonoBehaviour,UserListener,RoomListener,GroupListener,ChatListener,DownloadListener,PlayListener, LoginListener{
 
	//public static int monoBehaviourCounter = 0;
	public static List<string> monoBehaviourCounter=new List<string>();
	public static string logStr;
 
	public void Start () {
		#if UNITY_ANDROID || UNITY_EDITOR_WIN
		string name=this.GetType().ToString();
		if(!monoBehaviourCounter.Contains(name)){
			monoBehaviourCounter.Add(name);
		}

		if(monoBehaviourCounter.Count==1){
			InvokeRepeating ("mainLoop",0.0f, 0.050f);
		}

		GotyeMonoBehaviour.logStr += "\n"+name+" count+=" + GotyeMonoBehaviour.monoBehaviourCounter;
#endif
	}
	 
	public void OnDestroy() {
		#if UNITY_ANDROID || UNITY_EDITOR_WIN
		string name=this.GetType().ToString();
		if(monoBehaviourCounter.Contains(name)){
			monoBehaviourCounter.Remove(name);
		}
		GotyeMonoBehaviour.logStr += "\n"+name+" count-=" + GotyeMonoBehaviour.monoBehaviourCounter;
		#endif
	}
 
 

#if false
	public Base(){
		allMonos.Add (this);
		Debug.Log ("constructor " + allMonos.Count + " tid " + Thread.CurrentThread.ManagedThreadId);
	}
		
	~Base()
	{
		allMonos.Remove (this);
		Debug.Log ("destructor " + allMonos.Count + " tid " + Thread.CurrentThread.ManagedThreadId);
	}
#endif 
	 
	void mainLoop(){
		//GotyeAPI.GetInstance ().Log ("mainloop...");
		api.MainLoop ();
	}

	// Update is called once per frame
	void Update () {
	
	}
	public GotyeAPI api = GotyeAPI.GetInstance();
	public virtual void onGetUserDetail(GotyeStatusCode code, GotyeUser user)
	{
		
	}
	
	public virtual void onModifyUserInfo(GotyeStatusCode code, GotyeUser user)
	{
		
	}
	
	public virtual void onSearchUserList(GotyeStatusCode code, int pagerIndex, List<GotyeUser> mList,List<GotyeUser> curPageList)
	{
		
	}
	
	public virtual void onAddFriend(GotyeStatusCode code, GotyeUser user)
	{
		
	}
	
	public virtual void onGetFriendList(GotyeStatusCode code, List<GotyeUser> mList)
	{
		
	}
	
	public virtual void onAddBlocked(GotyeStatusCode code, GotyeUser user)
	{
		
	}

	public virtual void onLogin(GotyeStatusCode code,GotyeUser user){
	}

	public virtual void  onLogout(GotyeStatusCode code){
	}
	public virtual void onReconnecting(GotyeStatusCode code, GotyeUser currentUser){
	}
	
	public virtual void onRemoveFriend(GotyeStatusCode code, GotyeUser user)
	{
		
	}
	
	public virtual void onRemoveBlocked(GotyeStatusCode code, GotyeUser user)
	{
		
	}
	
	public virtual void onGetBlockedList(GotyeStatusCode code, List<GotyeUser> mList)
	{
		
	}
	
	public virtual  void onGetProfile(GotyeStatusCode code, GotyeUser user)
	{
		
	}
	 
	public virtual void onDownloadMedia(GotyeStatusCode code, GotyeMedia media)
	{
		
	}
	
	public virtual void onEnterRoom(GotyeStatusCode code, GotyeRoom room)
	{
		
	}
	
	public virtual void onLeaveRoom(GotyeStatusCode code, GotyeRoom room)
	{
		
	}

    public virtual void onGetRoomList(GotyeStatusCode code, int pageIndex, List<GotyeRoom> curPageRoomList, List<GotyeRoom> allRoomList)
	{
	    
	}
	
	public virtual void onGetRoomMemberList(GotyeStatusCode code, GotyeRoom room,int pageIndex,  List<GotyeUser> currentPageMembers,List<GotyeUser> totalMembers )
	{
		
	}

    public virtual void onGetMessageList(GotyeStatusCode code, List<GotyeMessage> list/*, bool downloadMediaIfNeed*/)
	{
		
	}
	
	public virtual void onRequestRoomInfo(GotyeStatusCode code, GotyeRoom room)
	{
		
	}
	
	public virtual void onCreateGroup(GotyeStatusCode code, GotyeGroup group)
	{
		
	}
	
	public virtual void onJoinGroup(GotyeStatusCode code, GotyeGroup group)
	{
		
	}
	
	public virtual void onLeaveGroup(GotyeStatusCode code, GotyeGroup group)
	{
		
	}
	
	public virtual void onDismissGroup(GotyeStatusCode code, GotyeGroup group)
	{
		
	}
	
	public virtual void onKickoutGroupMember(GotyeStatusCode code, GotyeGroup group,GotyeUser kickedMember)
	{
		
	}
	
	public virtual void onGetGroupList(GotyeStatusCode code, List<GotyeGroup> grouplist)
	{
		
	}
	
	public virtual void onGetGroupDetail(GotyeStatusCode code, GotyeGroup group)
	{
		
	}
	
	public virtual void onGetGroupMemberList(GotyeStatusCode code, GotyeGroup group, int pagerIndex,List<GotyeUser> curList, List<GotyeUser> allList)
	{
		
	}
	
	//public virtual void onReceiveGroupInvite(GotyeStatusCode code, GotyeGroup group, GotyeUser sender, string message)
	//{
		
	//}
	
	public virtual void onReceiveRequestJoinGroup(GotyeStatusCode code, GotyeGroup group, GotyeUser sender, string message)
	{
		
	}
	
	public virtual void onReceiveReplayJoinGroup(GotyeStatusCode code, GotyeGroup group, GotyeUser sender, string message, bool isAgree)
	{
		
	}
	
	public virtual void onGetOfflineMessageList(GotyeStatusCode code, List<GotyeMessage> messagelist)
	{
		
	}
	
	public virtual void onSearchGroupList(GotyeStatusCode code,int pageIndex,List<GotyeGroup> curList,List<GotyeGroup> mList)
	{
		
	}
	
	public virtual void onModifyGroupInfo(GotyeStatusCode code, GotyeGroup gotyeGroup)
	{
		
	}
	
	public virtual void onChangeGroupOwner(GotyeStatusCode code, GotyeGroup group,GotyeUser newOwner)
	{
		
	}
	
	public virtual void onUserJoinGroup(GotyeGroup group, GotyeUser user)
	{
		
	}
	
	public virtual void onUserLeaveGroup(GotyeGroup group, GotyeUser user)
	{
		
	}
	
	public virtual void onUserDismissGroup(GotyeGroup group, GotyeUser user)
	{
		
	}
	
	public virtual void onUserKickedFromGroup(GotyeGroup group, GotyeUser kicked, GotyeUser actor)
	{
		
	}
	
	public virtual void onSendNotify(GotyeStatusCode code, GotyeNotify notify)
	{
		
	}
	
	public virtual void onSendMessage(GotyeStatusCode code, GotyeMessage message)
	{
	}
	
	
	public virtual void onReceiveMessage(GotyeMessage message)
	{
		
	}
	
	
	public virtual void onDownloadMediaInMessage(GotyeStatusCode code, GotyeMessage message)
	{
		
	}
	
	
	public virtual void onReleaseMessage(GotyeStatusCode code)
	{
		
	}
	
	public virtual void onReport(GotyeStatusCode code, GotyeMessage message)
	{
		
	}
	
	public virtual void onStartTalk(GotyeStatusCode code, GotyeChatTarget target,  bool isRealTime)
	{
		
	}
	
	
	public virtual void onStopTalk(GotyeStatusCode code, bool isVoiceReal, GotyeMessage message)
	{
		
	}
	
	public virtual void onDecodeMessage(GotyeStatusCode code, GotyeMessage message)
	{
		
	}

	public virtual void onPlayStart(GotyeStatusCode code, GotyeMessage message){

	}
	
	 
	public virtual  void onPlaying(GotyeStatusCode code, int position){

	}
	 
	public virtual  void onPlayStop(){

	}
	 
	public virtual  void onPlayStartReal(GotyeStatusCode code, GotyeRoom room,
	                                     GotyeUser who){}

   // public virtual void onRequestCS(GotyeStatusCode code, GotyeUser user) { }

    // void onRequestCS(GotyeStatusCode code, GotyeUser user);
    public virtual void onSetGroupMsgConfig(GotyeStatusCode code, GotyeGroup group, GotyeGroupMsgConfig msgConfig) { }
    public virtual void onGetGroupMsgConfig(GotyeStatusCode code, GotyeGroup group, GotyeGroupMsgConfig msgConfig) { }
    public virtual void onGetOfflineMessages(GotyeStatusCode code, List<GotyeMessage> msgList, bool downloadMediaIfNeed) { }

    public virtual void onGetHistoryMessageList(GotyeStatusCode code, List<GotyeMessage> msgList) { }

    public virtual void onStartAPNS(GotyeStatusCode code) { }

    public virtual void onStopAPNS(GotyeStatusCode code) { }

    public virtual void onUpdateUnreadMessageCount(GotyeStatusCode code) { }

    public virtual void onReceiveNotify(GotyeStatusCode code, GotyeNotify notify) { }

    public virtual void onGetLocalRoomList(List<GotyeRoom> curPageRoomList) { }
    
    public virtual void onGetRoomDetail(GotyeStatusCode code, GotyeRoom room){ } 
    
    public virtual void onGetRoomStatus(GotyeRoom room, bool In) { }

    public virtual void onGetRoomRealtimeStatus(GotyeRoom room, bool support) { }

    public virtual void onGetUnreadNotifyCount(int count) { }

    public virtual void onGetNotifyList(List<GotyeNotify> notifylist) { }

    public virtual void onGetLastMessage(GotyeChatTarget target, GotyeMessage message) { }

    public virtual void onGetSessionList(List<GotyeChatTarget> list) { }

    public virtual void onGetUnreadMessageCount(GotyeChatTarget target, int count) { }

    public virtual void onGetTotalUnreadMessageCount(int count) { }

    public virtual void onGetTotalUnreadMessageCountOfTypes(List<GotyeChatTargetType> types, int count) { }

}
