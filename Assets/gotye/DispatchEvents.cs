using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;

namespace gotye
{
    public enum GotyeEventCode
    {   
        Login,
        Logout,
        GetProfile,
        GetUserInfo,
        ModifyUserInfo,
        GetFriendList,
        GetBlockedList,
        SearchUserList,
        AddFriend,
        AddBlocked,
        RemoveFriend,
        RemoveBlocked,
        GetRoomList,
        EnterRoom,
        LeaveRoom,
        GetUserList,
        GetHistoryMessageList,
        SearchGroup,
        CreateGroup,
        JoinGroup,
        LeaveGroup,
        DismissGroup,
        KickoutUser,
        ChangeGroupOwner,
        UserJoinGroup,
        UserLeaveGroup,
        UserDismissGroup,
        UserKickedFromGroup,
        GetGroupList,
        GetGroupInfo,
        ModifyGroupInfo,
        GetGroupUserList,
        ReceiveNotify,
        GetOfflineMessageList,
        SendMessage,
        ReceiveMessage,
        DownloadMessage,
        StartTalk,
        StopTalk,
        DownloadMedia,
        PlayStart,
        RealPlayStart,
        Playing,
        PlayStop,
        Report,
        DecodeFinished,
        SendNotify,
        Reconnecting,
        RequestCS,
        SetGroupMsgConfig,
        GetGroupMsgConfig,
        GetOfflineMessages,
        GetHistoryMessages,
        StartAPNS,
        StopAPNS,
        UpdateUnreadMessageCount,
        GetLocalRoomList,
        GetRoomDetail,
        GetRoomStatus,
        GetRoomRealtimeSupport,
        GetUnreadNotifyCount,
        GetNotifyList,
        GetLastMessage,
        GetSessionList,
        GetUnreadMessageCount,
        GetTotalUnreadMessageCount,
        GetTotalUnreadMessageCountOfTypes,
		//new code
		//CustomerService,
		//OutputAudioData,
		//SendPraise,	
		//GetPraise,
		//Praise,
		//EnterLiveRoom,
		//GetChannelInfo,
		//SetChannel,
		//CloseChannel,
		//UpdateChannelInfo,
		//GetRoomOnlineNum,
    }
    public class DispatchEvents
    {
        public static void onDispatchEvents(GotyeEventCode eventCode, WorkerUserState userState)
        {
            GotyeStatusCode statusCode = (GotyeStatusCode)userState.Args[0];

            GotyeDelegateImp delegateImpl = GotyeAPI.GetInstance().delegateImpl;
                if (delegateImpl == null)
                {
                    delegateImpl = new GotyeDelegateImp();
                }

                switch (eventCode)
                {
                    case GotyeEventCode.Login:
                        delegateImpl.onLogin(statusCode, (GotyeUser)userState.Args[1]);
                        break; 

                    case GotyeEventCode.Logout:
                            delegateImpl.onLogout(statusCode);
                        break;

                    case GotyeEventCode.GetProfile:
                            delegateImpl.onGetProfile(statusCode, (GotyeUser)userState.Args[1]);
                        break;

                    case GotyeEventCode.GetUserInfo:
                        delegateImpl.onGetUserDetail(statusCode, (GotyeUser)userState.Args[1]);
                        break;

                    case GotyeEventCode.ModifyUserInfo:
                       
                            delegateImpl.onModifyUserInfo(statusCode, (GotyeUser)userState.Args[1]);
                        
                        break;

                    case GotyeEventCode.GetFriendList:
                       
                            delegateImpl.onGetFriendList(statusCode,
                                    (List<GotyeUser>)userState.Args[1]);
                      
                        break;

                    case GotyeEventCode.GetBlockedList:
                         
                            delegateImpl.onGetBlockedList(statusCode,
                                    (List<GotyeUser>)userState.Args[1]);
                        
                        break;

                    case GotyeEventCode.SearchUserList:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onSearchUserList(statusCode,
					                              (int)userState.Args[1],(List<GotyeUser>)userState.Args[2],(List<GotyeUser>)userState.Args[3]);
                        }
                        break;

                    case GotyeEventCode.AddFriend:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onAddFriend(statusCode, (GotyeUser)userState.Args[1]);
                        }
                        break;

                    case GotyeEventCode.AddBlocked:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onAddBlocked(statusCode, (GotyeUser)userState.Args[1]);
                        }
                        break;

                    case GotyeEventCode.RemoveFriend:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onRemoveFriend(statusCode, (GotyeUser)userState.Args[1]);
                        }
                        break;

                    case GotyeEventCode.RemoveBlocked:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onRemoveBlocked(statusCode, (GotyeUser)userState.Args[1]);
                        }
                        break;

                    case GotyeEventCode.GetRoomList:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onGetRoomList(statusCode,(int)userState.Args[1], (List<GotyeRoom>)userState.Args[2], (List<GotyeRoom>)userState.Args[3]);
                        }
                        break;

                    case GotyeEventCode.EnterRoom:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onEnterRoom(statusCode, (GotyeRoom)userState.Args[1]);
                        }
                        break;

                    case GotyeEventCode.LeaveRoom:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onLeaveRoom(statusCode, (GotyeRoom)userState.Args[1]);
                        }
                        break;

                    case GotyeEventCode.GetUserList:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onGetRoomMemberList(statusCode, (GotyeRoom)userState.Args[1], (int)userState.Args[2], (List<GotyeUser>)userState.Args[3], (List<GotyeUser>)userState.Args[4]);
                        }
                        break;

                    case GotyeEventCode.GetHistoryMessageList:
                         if (delegateImpl != null)
                         {
                             delegateImpl.onGetHistoryMessageList(statusCode, (List<GotyeMessage>)userState.Args[1]);
                             
                         }
                        if (delegateImpl != null)
                        {
                            delegateImpl.onGetMessageList(statusCode,
                                    (List<GotyeMessage>)userState.Args[1]);
                        }
                        break;

                    case GotyeEventCode.SearchGroup:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onSearchGroupList(statusCode,
                                    (int)userState.Args[3],
                                    (List<GotyeGroup>)userState.Args[1],
                                    (List<GotyeGroup>)userState.Args[2]);
                        }
                        break;

                    case GotyeEventCode.CreateGroup:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onCreateGroup(statusCode, (GotyeGroup)userState.Args[1]);
                        }
                        break;

                    case GotyeEventCode.JoinGroup:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onJoinGroup(statusCode, (GotyeGroup)userState.Args[1]);
                        }
                        break;

                    case GotyeEventCode.LeaveGroup:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onLeaveGroup(statusCode, (GotyeGroup)userState.Args[1]);
                        }
                        break;

                    case GotyeEventCode.DismissGroup:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onDismissGroup(statusCode, (GotyeGroup)userState.Args[1]);
                        }
                        break;

                    case GotyeEventCode.KickoutUser:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onKickoutGroupMember(statusCode, (GotyeGroup)userState.Args[1], (GotyeUser)userState.Args[2]);
                        }
                        break;

                    case GotyeEventCode.ChangeGroupOwner:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onChangeGroupOwner(statusCode, (GotyeGroup)userState.Args[1], (GotyeUser)userState.Args[2]);
                        }
                        break;

                    case GotyeEventCode.UserJoinGroup:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onUserJoinGroup((GotyeGroup)userState.Args[1],
                                    (GotyeUser)userState.Args[2]);
                        }
                        break;

                    case GotyeEventCode.UserLeaveGroup:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onUserLeaveGroup((GotyeGroup)userState.Args[1],
                                    (GotyeUser)userState.Args[2]);
                        }
                        break;

                    case GotyeEventCode.UserDismissGroup:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onUserDismissGroup((GotyeGroup)userState.Args[1],
                                    (GotyeUser)userState.Args[2]);
                        }
                        break;

                    case GotyeEventCode.UserKickedFromGroup:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onUserKickedFromGroup((GotyeGroup)userState.Args[1],
                                    (GotyeUser)userState.Args[2], (GotyeUser)userState.Args[3]);
                        }
                        break;

                    case GotyeEventCode.GetGroupList:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onGetGroupList(statusCode,
                                    (List<GotyeGroup>)userState.Args[1]);
                        }
                        break;
                    case GotyeEventCode.ModifyGroupInfo:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onModifyGroupInfo(statusCode, (GotyeGroup)userState.Args[1]);
                        }
                        break;

                    case GotyeEventCode.GetGroupInfo:
                        if (delegateImpl != null)
                        {
                           delegateImpl.onGetGroupDetail(statusCode, (GotyeGroup)userState.Args[1]);
                            //delegateImpl.onModifyGroupInfo(statusCode, (GotyeGroup)userState.Args[1]);
                        }
                        break;

                    

                    case GotyeEventCode.GetGroupUserList:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onGetGroupMemberList(statusCode,(GotyeGroup)userState.Args[1],(int)userState.Args[2],
                                    (List<GotyeUser>)userState.Args[3], (List<GotyeUser>)userState.Args[4]);

                        }
                        break;

                    case GotyeEventCode.ReceiveNotify:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onReceiveNotify(statusCode, (GotyeNotify)userState.Args[1]);
                        }
                        break;

                    case GotyeEventCode.GetOfflineMessageList:
                         if (delegateImpl != null) {
                         delegateImpl.onGetOfflineMessageList(statusCode,
                         (List<GotyeMessage>) userState.Args[1]);
                         }
                        break;

                    case GotyeEventCode.SendMessage:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onSendMessage(statusCode, (GotyeMessage)userState.Args[1]);
                        }
                        break;

                    case GotyeEventCode.ReceiveMessage:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onReceiveMessage((GotyeMessage)userState.Args[1]);
                        }
                        break;

                    case GotyeEventCode.DownloadMessage:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onDownloadMediaInMessage(statusCode,
                                    (GotyeMessage)userState.Args[1]);
                        }
                        break;

                    case GotyeEventCode.StartTalk:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onStartTalk(statusCode, (GotyeChatTarget)userState.Args[1],(bool)userState.Args[2]);
                        }
                        break;

                    case GotyeEventCode.StopTalk:
                        if (delegateImpl != null)
                        {
                            Object param0 = userState.Args[1];
                            Object param1 = userState.Args[2];
                            GotyeMessage msg = null;
                            bool isRealTime = false;
                            if (param1 != null)
                            {
                                msg = (GotyeMessage)param1;
                            }
                            if (param0 != null)
                            {
                                isRealTime = (bool)param0;
                            }
                            delegateImpl.onStopTalk(statusCode, isRealTime, msg);
                        }  
                        break;

                    case GotyeEventCode.DownloadMedia:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onDownloadMedia(statusCode, (GotyeMedia)userState.Args[1]);
                        }
                        break;

                    case GotyeEventCode.PlayStart:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onPlayStart(statusCode, (GotyeMessage)userState.Args[1]);

                        }
                        break;
                    case GotyeEventCode.RealPlayStart:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onPlayStartReal(statusCode, (GotyeRoom)userState.Args[1],
                                    (GotyeUser)userState.Args[2]);
                        }
                        break;
                    case GotyeEventCode.Playing:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onPlaying(statusCode, (int)userState.Args[1]);
                        }
                        break;

                    case GotyeEventCode.PlayStop:
                        if (delegateImpl != null)
                        {
					        delegateImpl.onPlayStop();
                        }
                        break;

                    case GotyeEventCode.Report:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onReport(statusCode, (GotyeMessage)userState.Args[1]);
                        }
                        break;

                    case GotyeEventCode.DecodeFinished:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onDecodeMessage(statusCode, (GotyeMessage)userState.Args[1]);
                        }
                        break;

                    case GotyeEventCode.SendNotify:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onSendNotify(statusCode, (GotyeNotify)userState.Args[1]);
                        }
                        break;
                    case GotyeEventCode.Reconnecting:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onReconnecting(statusCode, (GotyeUser)userState.Args[1]);
                        }
                        break;
/*
                    case GotyeEventCode.RequestCS:
                        if(delegateImpl != null)
                        {
                            delegateImpl.onRequestCS(statusCode, (GotyeUser)userState.Args[1]);
                        }
                        break;
                        */
                        case GotyeEventCode.SetGroupMsgConfig:
                        if(delegateImpl != null)
                        {
                            delegateImpl.onSetGroupMsgConfig(statusCode, (GotyeGroup)userState.Args[1], (GotyeGroupMsgConfig)userState.Args[2]);
                        }
                        break;

                        case GotyeEventCode.GetGroupMsgConfig:
                        if(delegateImpl != null)
                        {
                            delegateImpl.onGetGroupMsgConfig(statusCode, (GotyeGroup)userState.Args[1], (GotyeGroupMsgConfig)userState.Args[2]);
                        }
                        break;

                        case GotyeEventCode.GetOfflineMessages:
                        if(delegateImpl != null)
                        {
                            delegateImpl.onGetOfflineMessageList(statusCode, (List<GotyeMessage>)userState.Args[1]);
                        }
                        break;

                        case GotyeEventCode.StartAPNS:
                        if(delegateImpl != null)
                        {
                            delegateImpl.onStartAPNS(statusCode);
                        }
                        break;

                        case GotyeEventCode.StopAPNS:
                        if(delegateImpl != null)
                        {
                            delegateImpl.onStopAPNS(statusCode);
                        }
                        break;

                        case GotyeEventCode.UpdateUnreadMessageCount:
                        if(delegateImpl != null)
                        {
                            delegateImpl.onUpdateUnreadMessageCount(statusCode);
                        }
                        break;

                    case GotyeEventCode.GetLocalRoomList:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onGetLocalRoomList((List<GotyeRoom>)userState.Args[1]);
                        }
                        break;

                    case GotyeEventCode.GetRoomDetail:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onGetRoomDetail(statusCode, (GotyeRoom)userState.Args[1]);
                        }
                        break;
                    case GotyeEventCode.GetRoomStatus:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onGetRoomStatus((GotyeRoom)userState.Args[1], (bool)userState.Args[2]);
                        }
                        break;

                    case GotyeEventCode.GetRoomRealtimeSupport:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onGetRoomRealtimeStatus((GotyeRoom)userState.Args[1], (bool)userState.Args[2]);
                        }
                        break;
                    case GotyeEventCode.GetUnreadNotifyCount:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onGetUnreadNotifyCount((int)userState.Args[1]);
                        }
                        break;

                    case GotyeEventCode.GetNotifyList:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onGetNotifyList((List<GotyeNotify>)userState.Args[1]);
                        }
                        break;
                    case GotyeEventCode.GetLastMessage:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onGetLastMessage((GotyeChatTarget)userState.Args[1], (GotyeMessage)userState.Args[2]);
                        }
                        break;
                    case GotyeEventCode.GetSessionList:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onGetSessionList((List<GotyeChatTarget>)userState.Args[1]);
                        }
                        break;
                    case GotyeEventCode.GetUnreadMessageCount:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onGetUnreadMessageCount((GotyeChatTarget)userState.Args[1], (int)userState.Args[2]);
                        }
                        break;

                    case GotyeEventCode.GetTotalUnreadMessageCount:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onGetTotalUnreadMessageCount((int)userState.Args[1]);
                        }
                        break;
                    case GotyeEventCode.GetTotalUnreadMessageCountOfTypes:
                        if (delegateImpl != null)
                        {
                            delegateImpl.onGetTotalUnreadMessageCountOfTypes((List<GotyeChatTargetType>)userState.Args[1],(int)userState.Args[2]);
                        }
                        break;
    
                }
            }
        }

    }
 