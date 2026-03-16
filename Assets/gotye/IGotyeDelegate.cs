 
using System.Collections;
using System.Collections.Generic;
using System;
namespace gotye
{   /// <summary>
	/// 异步监听接口
	/// </summary>
    public interface IGotyeDelegate
    {
         void onLogin(GotyeStatusCode code, GotyeUser user);

         void onGetProfile(GotyeStatusCode code, GotyeUser user);

         void onLogout(GotyeStatusCode code);

         void onGetUserDetail(GotyeStatusCode code, GotyeUser user);

         void onModifyUserInfo(GotyeStatusCode code, GotyeUser user);

		void onSearchUserList(GotyeStatusCode code,int pageIndex, List<GotyeUser> curPageList,List<GotyeUser> allList);
         void onGetFriendList(GotyeStatusCode code, List<GotyeUser> mList);

         void onGetBlockedList(GotyeStatusCode code, List<GotyeUser> mList);

         void onAddFriend(GotyeStatusCode code, GotyeUser user);

         void onAddBlocked(GotyeStatusCode code, GotyeUser user);

         void onRemoveFriend(GotyeStatusCode code, GotyeUser user);

         void onRemoveBlocked(GotyeStatusCode code, GotyeUser user);

         void onGetRoomList(GotyeStatusCode code, int pageIndex, List<GotyeRoom> curPageRoomList, List<GotyeRoom> allRoomList);

         void onEnterRoom(GotyeStatusCode code, GotyeRoom room);

         void onLeaveRoom(GotyeStatusCode code, GotyeRoom room);

         void onGetRoomMemberList(GotyeStatusCode code, GotyeRoom room, int pageIndex, List<GotyeUser> currentPageMembers, List<GotyeUser> allMemberList);
         void onSearchGroupList(GotyeStatusCode code,int pageIndex, List<GotyeGroup> curPageList, List<GotyeGroup> allList);
         void onCreateGroup(GotyeStatusCode code, GotyeGroup group);

         void onJoinGroup(GotyeStatusCode code, GotyeGroup group);

         void onLeaveGroup(GotyeStatusCode code, GotyeGroup group);

         void onDismissGroup(GotyeStatusCode code, GotyeGroup group);

         void onKickoutGroupMember(GotyeStatusCode code, GotyeGroup group, GotyeUser user);/////

         void onGetGroupList(GotyeStatusCode code, List<GotyeGroup> grouplist);

         void onChangeGroupOwner(GotyeStatusCode code, GotyeGroup group, GotyeUser user);

         void onUserJoinGroup(GotyeGroup group, GotyeUser user);

         void onUserLeaveGroup(GotyeGroup group, GotyeUser user);

         void onUserDismissGroup(GotyeGroup group, GotyeUser user);

         void onUserKickedFromGroup(GotyeGroup group, GotyeUser kicked, GotyeUser actor);     ////////

         void onGetGroupDetail(GotyeStatusCode code ,GotyeGroup group);

         void onGetGroupMemberList(GotyeStatusCode code, GotyeGroup group, int pageIndex, List<GotyeUser> curPageMemberList, List<GotyeUser> allMemberList);
         
         //void onReceiveGroupInvite(GotyeStatusCode code, GotyeGroup mGroup, String message, GotyeUser sender);

         void onSendMessage(GotyeStatusCode code, GotyeMessage message);

         void onReceiveMessage(GotyeMessage message);

         void onDownloadMediaInMessage(GotyeStatusCode code, GotyeMessage message);

         void onReport(GotyeStatusCode code, GotyeMessage message);

         void onGetMessageList(GotyeStatusCode code, List<GotyeMessage> list/*, bool downloadMediaIfNeed*/);

         void onStartTalk(GotyeStatusCode code, GotyeChatTarget target, bool isRealTime );

         void onStopTalk(GotyeStatusCode code, bool isRealTimeVoice, GotyeMessage message/*, bool isVoiceReal*/);

         void onDownloadMedia(GotyeStatusCode code, GotyeMedia media);

         void onPlayStart(GotyeStatusCode code, GotyeMessage message);

         void onPlayStartReal(GotyeStatusCode code, GotyeRoom room, GotyeUser who);

         void onPlaying(GotyeStatusCode code, int position);

	  	 void onPlayStop();               //////////////

         void onModifyGroupInfo(GotyeStatusCode code, GotyeGroup gotyeGroup);

         void onDecodeMessage(GotyeStatusCode code, GotyeMessage message);

         void onSendNotify(GotyeStatusCode code, GotyeNotify notify);

         void onReceiveNotify(GotyeStatusCode code, GotyeNotify notify);


         void onReconnecting(GotyeStatusCode code, GotyeUser currentLoginUser);

         // public virtual void onRequestCS(GotyeStatusCode code, GotyeUser user) { }

         // void onRequestCS(GotyeStatusCode code, GotyeUser user);
         void onSetGroupMsgConfig(GotyeStatusCode code, GotyeGroup group, GotyeGroupMsgConfig msgConfig);
         void onGetGroupMsgConfig(GotyeStatusCode code, GotyeGroup group, GotyeGroupMsgConfig msgConfig);

         void onGetOfflineMessageList(GotyeStatusCode code, List<GotyeMessage> msgList/*, bool downloadMediaIfNeed*/);

         void onGetHistoryMessageList(GotyeStatusCode code, List<GotyeMessage> msgList/*, bool downloadMediaIfNeed*/);

         void onStartAPNS(GotyeStatusCode code);

         void onStopAPNS(GotyeStatusCode code);

         void onUpdateUnreadMessageCount(GotyeStatusCode code);

        //=======================新增加的========================================

        void onGetLocalRoomList(List<GotyeRoom> curPageRoomList);

        void onGetRoomDetail(GotyeStatusCode code, GotyeRoom room);
    
        void onGetRoomStatus(GotyeRoom room, bool In);
    
        void onGetRoomRealtimeStatus( GotyeRoom room, bool support) ;
    
        void onGetUnreadNotifyCount(int count) ;
    
        void onGetNotifyList(List<GotyeNotify> notifylist) ;

        void onGetLastMessage(GotyeChatTarget target, GotyeMessage message) ;
    
         void onGetSessionList(List<GotyeChatTarget> list) ;
    
        void onGetUnreadMessageCount(GotyeChatTarget target, int count) ;
    
        void onGetTotalUnreadMessageCount(int count) ;
    
        void onGetTotalUnreadMessageCountOfTypes(List<GotyeChatTargetType> types, int count) ;

    }
}