using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
 

namespace gotye
{
   public class GotyeDelegateImp:IGotyeDelegate
    {
	public void onLogin(GotyeStatusCode code, GotyeUser user) {
		// TODO Auto-generated method stub
		//GotyeAPI.getInstance().on//LoginCallBack(code,user);

		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		GotyeAPI.GetInstance ().Log ("GotyeDelegateImp::onLogin, code = " + code + " ls count = " + listeners.Count);

		foreach (GotyeListener listener in listeners) {
				GotyeAPI.GetInstance ().Log ("1111111" + (listener is LoginListener));
			try{
			if (listener != null && listener is LoginListener) {
					GotyeAPI.GetInstance ().Log ("22222222");
				((LoginListener) listener).onLogin(code,user);
			}
				}catch(Exception e){
					GotyeAPI.GetInstance ().Log (e.Message);
				}
		}
	}

	 
	public void onLogout(GotyeStatusCode code) {
		List<GotyeListener> listeners =  GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is LoginListener) {
				((LoginListener) listener).onLogout(code);
			}
		}
		//GotyeAPI.getInstance().onLogoutCallBack(code);
	}


    public void onGetUserDetail(GotyeStatusCode code, GotyeUser user)
    {
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is UserListener) {
				((UserListener) listener).onGetUserDetail(code, user);
			}
		}
	}

	
	public void onModifyUserInfo(GotyeStatusCode code, GotyeUser user) {
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is UserListener) {
				((UserListener) listener).onModifyUserInfo(code, user);
			}
		}
	}

	
	public void onGetProfile(GotyeStatusCode code, GotyeUser user) {
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is UserListener) {
				((UserListener) listener).onGetProfile(code, user);
			}
		}
	}

	
	public void onGetFriendList(GotyeStatusCode code, List<GotyeUser> mFriendList) {
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is UserListener) {
                ((UserListener)listener).onGetFriendList(code, mFriendList);
			}
		}
	}

	
	public void onGetBlockedList(GotyeStatusCode code, List<GotyeUser> mList) {
		List<GotyeListener> listeners =GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is UserListener) {
				((UserListener) listener).onGetBlockedList(code, mList);
			}
		}
	}

	
	public void onAddFriend(GotyeStatusCode code, GotyeUser user) {
		 
		List<GotyeListener> listeners =GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is UserListener) {
				((UserListener) listener).onAddFriend(code, user);
			}
		}
	   //foreach (GotyeListener listener in listeners) {
	   //	if (listener != null && listener is GroupListener) {
       //((GroupListener)listener).onFriendChanged(true, user);
       //         ((GroupListener)listener).onReceiveNotify(user);
	   //	}
	   //}
	}

	
	public void onAddBlocked(GotyeStatusCode code, GotyeUser user) {
		//Log.d("ListenerBack", "code = " + code + "user = " + user);
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is UserListener) {
				((UserListener) listener).onAddBlocked(code, user);
			}
		}
	}

	
	public void onRemoveFriend(GotyeStatusCode code, GotyeUser user) {
		 
		List<GotyeListener> listeners =GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is UserListener) {
				((UserListener) listener).onRemoveFriend(code, user);
			}
		}
		//foreach (GotyeListener listener in listeners) {
		//	if (listener != null && listener is NotifyListener) {
		//			((NotifyListener) listener).onFriendChanged(false,user);
		//	}
		//}
	}

	
	public void onRemoveBlocked(GotyeStatusCode code, GotyeUser user) {
		//Log.d("ListenerBack", "code = " + code + "user = " + user);
		List<GotyeListener> listeners =GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is UserListener) {
				((UserListener) listener).onRemoveBlocked(code, user);
			}
		}
	}


    public void onGetRoomList(GotyeStatusCode code, int pageIndex, List<GotyeRoom> curPageRoomList, List<GotyeRoom> allRoomList)
    {
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is RoomListener) {
				((RoomListener) listener).onGetRoomList(code, pageIndex, curPageRoomList, allRoomList);
			}
		}
	}

	
	public void onEnterRoom(GotyeStatusCode code, GotyeRoom room) {
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is RoomListener) {
				((RoomListener) listener).onEnterRoom(code,room);
			}
		}
	}


    public void onGetRoomMemberList(GotyeStatusCode code, GotyeRoom room, int pageIndex,
            List<GotyeUser> curPageMemberList , List<GotyeUser> allMemberList
			) {
		List<GotyeListener> listeners =GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is RoomListener) {
                ((RoomListener)listener).onGetRoomMemberList(code, room, pageIndex, curPageMemberList, allMemberList);
			}
		}
	}

	
	public void onLeaveRoom(GotyeStatusCode code, GotyeRoom room) {
		List<GotyeListener> listeners =GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is RoomListener) {
				((RoomListener) listener).onLeaveRoom(code, room);
			}
		}
	}


    public void onSearchGroupList(GotyeStatusCode code, int pageIndex, List<GotyeGroup> curPageList,
			List<GotyeGroup> allList) {
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is GroupListener) {
                ((GroupListener)listener).onSearchGroupList(code, pageIndex, curPageList, allList);
			}
		}
	}

	
	public void onCreateGroup(GotyeStatusCode code, GotyeGroup group) {
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is GroupListener) {
				((GroupListener) listener).onCreateGroup(code, group);
			}
		}
	}

	
	public void onJoinGroup(GotyeStatusCode code, GotyeGroup group) {
		//Log.d("ListenerBack", "code = " + code + "group = " + group);
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is GroupListener) {
				((GroupListener) listener).onJoinGroup(code, group);
			}
		}
	}

	
	public void onLeaveGroup(GotyeStatusCode code, GotyeGroup group) {
		List<GotyeListener> listeners =GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is GroupListener) {
				((GroupListener) listener).onLeaveGroup(code, group);
			}
		}
	}

	
	public void onDismissGroup(GotyeStatusCode code, GotyeGroup group) {
		//Log.d("ListenerBack", "code = " + code + "group = " + group);
		List<GotyeListener> listeners =GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is GroupListener) {
				((GroupListener) listener).onDismissGroup(code, group);
			}
		}
	}


    public void onKickoutGroupMember(GotyeStatusCode code, GotyeGroup group, GotyeUser user)
    {
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is GroupListener) {
				((GroupListener) listener).onKickoutGroupMember(code, group, user);
			}
		}
	}

	
	public void onGetGroupList(GotyeStatusCode code, List<GotyeGroup> grouplist) {
		List<GotyeListener> listeners =GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is GroupListener) {
				((GroupListener) listener).onGetGroupList(code, grouplist);
			}
		}
	}


    public void onChangeGroupOwner(GotyeStatusCode code, GotyeGroup group, GotyeUser user){
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is GroupListener) {
				((GroupListener) listener).onChangeGroupOwner(code, group, user);
			}
		}
	}



    public void onGetGroupDetail(GotyeStatusCode code, GotyeGroup group)
    {
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is GroupListener) {
				((GroupListener) listener).onGetGroupDetail(code, group);
			}
		}
        
	}


    public void onGetGroupMemberList(GotyeStatusCode code, GotyeGroup group, int pageIndex, List<GotyeUser> curPageMemberList, List<GotyeUser> allMemberList) {
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is GroupListener) {
					((GroupListener) listener).onGetGroupMemberList(code, group, pageIndex ,curPageMemberList, allMemberList);
			}
		}
	}
    public void onGetOfflineMessageList(GotyeStatusCode code, List<GotyeMessage> msgList)
    {
        List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
        foreach (GotyeListener listener in listeners)
        {
            if (listener != null && listener is ChatListener)
            {
                ((ChatListener)listener).onGetOfflineMessageList(code, msgList);
            }
        }
    }

	
	public void onReceiveNotify(GotyeStatusCode code,GotyeNotify notify) {
		
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is GroupListener) {
                ((GroupListener)listener).onReceiveNotify(code, notify); ;
			}
		}
	}

	
	public void onSendMessage(GotyeStatusCode code, GotyeMessage message) {
		//Log.d("ListenerBack", "message = " + message);
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is ChatListener) {
				((ChatListener) listener).onSendMessage(code, message);
			}
		}
		 
	}

	
	public void onReceiveMessage(GotyeMessage message) {
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is ChatListener) {
				((ChatListener) listener).onReceiveMessage(message);
			}
		}
		//foreach (GotyeListener listener in listeners) {
		//	if (listener != null && listener is NotifyListener) {
		//		((NotifyListener) listener).onReceivePushMessage(message);
		//	}
		
	}

	
	public void onDownloadMediaInMessage(GotyeStatusCode code, GotyeMessage message) {
		List<GotyeListener> listeners =GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is ChatListener) {
				((ChatListener) listener).onDownloadMediaInMessage(code, message);
			}
		}
	}

	
	public void onReport(GotyeStatusCode code, GotyeMessage message) {
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is ChatListener) {
				((ChatListener) listener).onReport(code, message);
			}
		}
	}


    public void onGetMessageList(GotyeStatusCode code, List<GotyeMessage> list/*, bool downloadMediaIfNeed*/)
    {
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is ChatListener) {
                ((ChatListener)listener).onGetMessageList(code, list);
			}
		}
	}
 
	
	public void onStartTalk(GotyeStatusCode code,
            GotyeChatTarget target, bool isRealTime)
    {
		 List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is ChatListener) {
				((ChatListener) listener).onStartTalk(code, target, isRealTime);
			}
		}
	}

	public void onStopTalk(GotyeStatusCode code, bool realtime,GotyeMessage message/*, bool isVoiceReal*/) {
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is ChatListener) {
				((ChatListener) listener).onStopTalk(code, realtime, message);
			}
		}
	}

	
	public void onDownloadMedia(GotyeStatusCode code,GotyeMedia media) {
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is DownloadListener) {
					((DownloadListener) listener).onDownloadMedia(code, media);
			}
		}
	}

	
	public void onPlayStart(GotyeStatusCode code, GotyeMessage message) {
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is PlayListener) {
				((PlayListener) listener).onPlayStart(code, message);
			}
		}
	}

	
	public void onPlayStartReal(GotyeStatusCode code, GotyeRoom room,
			GotyeUser who) {
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is PlayListener) {
                ((PlayListener)listener).onPlayStartReal(code, room, who);
			}
		}
	}

	
	public void onPlaying(GotyeStatusCode code, int position) {
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is PlayListener) {
				((PlayListener) listener).onPlaying(code, position);
			}
		}
	}

	
		public void onPlayStop() {
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is PlayListener) {
					((PlayListener) listener).onPlayStop();
			}
		}
	}

	public void onSearchUserList(GotyeStatusCode code, int pageIndex, List<GotyeUser> curPageList,List<GotyeUser> allList) {
		    List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		    foreach (GotyeListener listener in listeners) {
			    if (listener != null && listener is UserListener) {
                    ((UserListener)listener).onSearchUserList(code, pageIndex, curPageList, allList);
		    }
		}
	}

	 

	
	public void onModifyGroupInfo(GotyeStatusCode code, GotyeGroup gotyeGroup) {
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is GroupListener) {
				((GroupListener) listener).onModifyGroupInfo(code,gotyeGroup);
			}
		}
	}

	
	public void onUserJoinGroup(GotyeGroup group, GotyeUser user) {
		//Log.d("ListenerBack", "group = " + group + "user = " + user);
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is GroupListener) {
				((GroupListener) listener).onUserJoinGroup(group, user);
			}
		}
	}

	
	public void onUserLeaveGroup(GotyeGroup group, GotyeUser user) {
		//Log.d("ListenerBack", "group = " + group + "user = " + user);
		List<GotyeListener> listeners =GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is GroupListener) {
				((GroupListener) listener).onUserLeaveGroup(group, user);
			}
		}

	}

	
	public void onUserDismissGroup(GotyeGroup group, GotyeUser user) {
		//Log.d("ListenerBack", "group = " + group + "user = " + user);
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is GroupListener) {
				((GroupListener) listener).onUserDismissGroup(group, user);
			}
		}
	}

	
	public void onUserKickedFromGroup(GotyeGroup group, GotyeUser kicked,
			GotyeUser actor) {
		//Log.d("ListenerBack", "group = " + group + "kicked = " + kicked				 
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is GroupListener) {
				((GroupListener) listener).onUserKickedFromGroup(group, kicked, actor);
			}
		}
	}
	
	public void onDecodeMessage(GotyeStatusCode code, GotyeMessage message) {
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is ChatListener) {
				((ChatListener) listener).onDecodeMessage(code, message);
			}
		}
	}
 
	public void onSendNotify(GotyeStatusCode code, GotyeNotify notify) {
		// TODO Auto-generated method stub
		List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
		foreach (GotyeListener listener in listeners) {
			if (listener != null && listener is GroupListener) {
				((GroupListener)listener).onSendNotify(code,notify);
			}
		}
	}

       //端口不用了
   // public void onReceiveGroupInvite(GotyeStatusCode code, GotyeGroup mGroup,
	//		String message, GotyeUser sender) {
		// TODO Auto-generated method stub
		
	//}
		public void onReconnecting(GotyeStatusCode code, GotyeUser user)
		{
			// TODO Auto-generated method stub
			//GotyeAPI.getInstance().on//LoginCallBack(code,user);
			
			List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
			foreach (GotyeListener listener in listeners)
			{
				if (listener != null && listener is LoginListener)
				{
					((LoginListener)listener).onReconnecting(code, user);
				}
			}
		}


       //new 
       /*
       public void onRequestCS(GotyeStatusCode code, GotyeUser user)
       {
           List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
           foreach (GotyeListener listener in listeners)
           {
               if (listener != null && listener is LoginListener)
               {
                   ((ChatListener)listener).onRequestCS(code, user);
               }
           }
       }*/

       public void onSetGroupMsgConfig(GotyeStatusCode code, GotyeGroup group, GotyeGroupMsgConfig msgConfig)
       {
           List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
           foreach (GotyeListener listener in listeners)
           {
               if (listener != null && listener is LoginListener)
               {
                   ((ChatListener)listener).onSetGroupMsgConfig(code, group, msgConfig);
               }
           }
       }
        
       public void onGetGroupMsgConfig(GotyeStatusCode code, GotyeGroup group, GotyeGroupMsgConfig msgConfig)
       {
           List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
           foreach (GotyeListener listener in listeners)
           {
               if (listener != null && listener is LoginListener)
               {
                   ((ChatListener)listener).onGetGroupMsgConfig(code, group, msgConfig);
               }
           }
       }

      // public void onGetOfflineMessages(GotyeStatusCode code, List<GotyeMessage> msgList, bool downloadMediaIfNeed)
      // {
       //    List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
       //    foreach (GotyeListener listener in listeners)
       //    {
       //        if (listener != null && listener is LoginListener)
       //        {
       //            ((ChatListener)listener).onGetOfflineMessages(code, msgList, downloadMediaIfNeed);
       //        }
       //    }
       //}

       public void onGetHistoryMessageList(GotyeStatusCode code, List<GotyeMessage> msgList/*, bool downloadMediaIfNeed*/)
       {
           List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
           foreach (GotyeListener listener in listeners)
           {
               if (listener != null && listener is ChatListener)
               {
                   ((ChatListener)listener).onGetHistoryMessageList(code, msgList);
               }
           }
       }

       public void onStartAPNS(GotyeStatusCode code)
       {
           List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
           foreach (GotyeListener listener in listeners)
           {
               if (listener != null && listener is LoginListener)
               {
                   ((ChatListener)listener).onStartAPNS(code);
               }
           }
       }
        
       public void onStopAPNS(GotyeStatusCode code)
       {
           List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
           foreach (GotyeListener listener in listeners)
           {
               if (listener != null && listener is LoginListener)
               {
                   ((ChatListener)listener).onStopAPNS(code);
               }
           }
       }

       public void onUpdateUnreadMessageCount(GotyeStatusCode code)
       {
           List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
           foreach (GotyeListener listener in listeners)
           {
               if (listener != null && listener is LoginListener)
               {
                   ((ChatListener)listener).onUpdateUnreadMessageCount(code);
               }
           }
       }

       public void onGetLocalRoomList(List<GotyeRoom> curPageRoomList)
       {
           List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
           foreach (GotyeListener listener in listeners)
           {
               if (listener != null && listener is RoomListener)
               {
                   ((RoomListener)listener).onGetLocalRoomList(curPageRoomList);
               }
           }
       }
       public void onGetRoomDetail(GotyeStatusCode code, GotyeRoom room)
       {
           List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
           foreach (GotyeListener listener in listeners)
           {
               if (listener != null && listener is RoomListener)
               {
                   ((RoomListener)listener).onGetRoomDetail(code, room);
               }
           }
       }

       public void onGetRoomStatus(GotyeRoom room, bool In)
       {
           List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
           foreach (GotyeListener listener in listeners)
           {
               if (listener != null && listener is RoomListener)
               {
                   ((RoomListener)listener).onGetRoomStatus(room, In);
               }
           }
       }

       public void onGetRoomRealtimeStatus(GotyeRoom room, bool support)
       {
           List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
           foreach (GotyeListener listener in listeners)
           {
               if (listener != null && listener is RoomListener)
               {
                   ((RoomListener)listener).onGetRoomRealtimeStatus(room, support);
               }
           }
       }

       public void onGetUnreadNotifyCount(int count)
       {
           List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
           foreach (GotyeListener listener in listeners)
           {
               if (listener != null && listener is NotifyListener)
               {
                   ((NotifyListener)listener).onGetUnreadNotifyCount(count);
               }
           }
       }

       public void onGetNotifyList(List<GotyeNotify> notifylist)
       {
           List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
           foreach (GotyeListener listener in listeners)
           {
               if (listener != null && listener is NotifyListener)
               {
                   ((NotifyListener)listener).onGetNotifyList(notifylist);
               }
           }
       }

       public void onGetLastMessage(GotyeChatTarget target, GotyeMessage message)
       {
           List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
           foreach (GotyeListener listener in listeners)
           {
               if (listener != null && listener is ChatListener)
               {
                   ((ChatListener)listener).onGetLastMessage(target, message);
               }
           }
       }

       public void onGetSessionList(List<GotyeChatTarget> list)
       {
           List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
           foreach (GotyeListener listener in listeners)
           {
               if (listener != null && listener is ChatListener)
               {
                   ((ChatListener)listener).onGetSessionList(list);
               }
           }
       }

       public void onGetUnreadMessageCount(GotyeChatTarget target, int count)
       {
           List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
           foreach (GotyeListener listener in listeners)
           {
               if (listener != null && listener is ChatListener)
               {
                   ((ChatListener)listener).onGetUnreadMessageCount(target, count);
               }
           }
       }

       public void onGetTotalUnreadMessageCount(int count)
       {
           List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
           foreach (GotyeListener listener in listeners)
           {
               if (listener != null && listener is ChatListener)
               {
                   ((ChatListener)listener).onGetTotalUnreadMessageCount(count);
               }
           }
       }

       public void onGetTotalUnreadMessageCountOfTypes(List<GotyeChatTargetType> types, int count)
       {
           List<GotyeListener> listeners = GotyeAPI.GetInstance().Listeners;
           foreach (GotyeListener listener in listeners)
           {
               if (listener != null && listener is ChatListener)
               {
                   ((ChatListener)listener).onGetTotalUnreadMessageCountOfTypes(types, count);
               }
           }
       }
    }
}
