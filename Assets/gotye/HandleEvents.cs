using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using gotyejson;
namespace gotye
{
    public class HandleEvents
    {
        static int getCStringLength(IntPtr ptr)
        {
            int len = 0;
            while (true)
            {
                byte b = Marshal.ReadByte(ptr, len);
                len++;
                if (b == 0)
                {
                    return len-1;
                }
            }
        }

        public static void onHandleEvents(int event_code, IntPtr args)
        {
            //int tid = Thread.CurrentThread.ManagedThreadId;
            int arglen = getCStringLength(args);
            byte[] utf8bytes = new byte[arglen];
            Marshal.Copy(args, utf8bytes, 0, arglen);

            string jsonstring = System.Text.Encoding.UTF8.GetString(utf8bytes, 0, arglen);
			Console.WriteLine (jsonstring);
            onHandleEvents(event_code, jsonstring);

        }
        public static void onHandleEvents(int event_code, string jsonstring)
        {
            //int tid = Thread.CurrentThread.ManagedThreadId;

			GotyeAPI.GetInstance ().Log ("handle event: " + event_code + "," + jsonstring);
			//NGUIDebug.Log (jsonstring);
			Console.WriteLine (jsonstring);
            GotyeAPI api = GotyeAPI.GetInstance();
           

            WorkerUserState userState = new WorkerUserState();

            GotyeJsonData json = GotyeJsonMapper.ToObject(jsonstring);
            GotyeEventCode code = (GotyeEventCode)event_code;



            switch (code)
            {
                case GotyeEventCode.Login:
                    {
                        int mCode = (int)json["code"];
                        GotyeUser User = GotyeUser.jsonToUser(json["user"]);
                        api.onEventRised(code, userState.SetArgs(mCode, User));
                    }
                    break;
                case GotyeEventCode.Logout:
                    {
                        int mCode = (int)json["code"];
                        api.onEventRised(code, userState.SetArgs(mCode));
                    }
                    break;

                case GotyeEventCode.GetProfile:
                    {
                        GotyeUser user = GotyeUser.jsonToUser(json["user"]);
                        int mCode = (int)json["code"];
                        api.onEventRised(code, userState.SetArgs(mCode, user));
                    }

                    break;

                case GotyeEventCode.GetUserInfo:
                    {
                        int mCode = (int)json["code"];
                        GotyeUser mUser = GotyeUser.jsonToUser(json["user"]);
                        api.onEventRised(code, userState.SetArgs(mCode, mUser));
                    }
                    break;

                case GotyeEventCode.ModifyUserInfo:
                    {

                        int mCode = (int)json["code"];
                        GotyeUser mUser = GotyeUser.jsonToUser(json["user"]);
                        api.onEventRised(code, userState.SetArgs(mCode, mUser));

                    }
                    break;

                case GotyeEventCode.GetFriendList:
                    {
                        List<GotyeUser> mList = new List<GotyeUser>();
                        int mCode = (int)json["code"];
                        GotyeJsonData Array = json["friendlist"];
                        if (Array != null)
                        {
                            int len = Array.Count;
                            if (len > 0)
                            {
                                for (int i = 0; i < len; i++)
                                {
                                    mList.Add(GotyeUser.jsonToUser(Array[i]));
                                }
                            }
                        }
                        api.onEventRised(code, userState.SetArgs(mCode, mList));
                    }
                    break;

                case GotyeEventCode.GetBlockedList:
                    {
                        List<GotyeUser> mList = new List<GotyeUser>();
                        int mCode = (int)json["code"];
                        GotyeJsonData Array = json["blockedlist"];
                        if (Array != null)
                        {
                            int len = Array.Count;
                            if (len > 0)
                            {
                                for (int i = 0; i < len; i++)
                                {
                                    mList.Add(GotyeUser.jsonToUser(Array[i]));
                                }

                            }
                        }
                        api.onEventRised(code, userState.SetArgs(mCode, mList));
                    }
                    break;

                case GotyeEventCode.SearchUserList:
                    {
                        int mCode = (int)json["code"];
                        List<GotyeUser> mList = new List<GotyeUser>();
                        List<GotyeUser> curPageList = new List<GotyeUser>();
                        int mPagerIndex = (int)json["pageIndex"];
                        GotyeJsonData Array = json["allList"];
                        if (Array != null)
                        {
                            int len = Array.Count;
                            if (len > 0)
                            {
                                for (int i = 0; i < len; i++)
                                {
                                    GotyeUser user = GotyeUser.jsonToUser(Array[i]);
                                    mList.Add(user);
                                }
                            }
                        }

                        GotyeJsonData cur = json["curPageList"];
                        if (cur != null)
                        {
                            int len = cur.Count;
                            if (len > 0)
                            {
                                for (int i = 0; i < len; i++)
                                {
                                    GotyeUser user = GotyeUser.jsonToUser(cur[i]);
                                    curPageList.Add(user);
                                }
                            }
                        }

                        api.onEventRised(code, userState.SetArgs(mCode, mPagerIndex, mList, curPageList));
                    }
                    break;

                case GotyeEventCode.AddFriend:
                    {
                        int mCode = (int)json["code"];
                        GotyeUser user = GotyeUser.jsonToUser(json["user"]);
                        api.onEventRised(code, userState.SetArgs(mCode, user));
                    }
                    break;

                case GotyeEventCode.AddBlocked:
                    {
                        int mCode = (int)json["code"];
                        GotyeUser user = GotyeUser.jsonToUser(json["user"]);
                        api.onEventRised(code, userState.SetArgs(mCode, user));
                    }
                    break;

                case GotyeEventCode.RemoveFriend:
                    {
                        int mCode = (int)json["code"];
                        GotyeUser user = GotyeUser.jsonToUser(json["user"]);
                        api.onEventRised(code, userState.SetArgs(mCode, user));
                    }

                    break;

                case GotyeEventCode.RemoveBlocked:
                    {
                        int mCode = (int)json["code"];
                        GotyeUser user = GotyeUser.jsonToUser(json["user"]);
                        api.onEventRised(code, userState.SetArgs(mCode, user));
                    }
                    break;

                case GotyeEventCode.GetRoomList:
                    {
                        List<GotyeRoom> curPageRoomList = new List<GotyeRoom>();
                        List<GotyeRoom> allRoomList = new List<GotyeRoom>();
                        int mCode = (int)json["code"];
                        int mPageIndex = (int)json["pageIndex"];
                        GotyeJsonData curArray = json["curPageRoomList"];
                        if (curArray != null)
                        {
                            int len = curArray.Count;
                            if (len > 0)
                            {
                                for (int i = 0; i < len; i++)
                                {
                                    GotyeRoom gotyeRoom = GotyeRoom.createRoomJson(curArray[i]);
                                    curPageRoomList.Add(gotyeRoom);
                                }
                            }
                        }


                        GotyeJsonData Array = json["allRoomList"];
                        if (Array != null)
                        {
                            int len = Array.Count;
                            if (len > 0)
                            {
                                for (int i = 0; i < len; i++)
                                {
                                    GotyeRoom gotyeRoom = GotyeRoom
                                            .createRoomJson(Array[i]);
                                    allRoomList.Add(gotyeRoom);
                                }
                            }

                        }


                        api.onEventRised(code, userState.SetArgs(mCode, mPageIndex, curPageRoomList, allRoomList));
                    }
                    break;

                case GotyeEventCode.EnterRoom:
                    {
                        int mCode = (int)json["code"];
                        GotyeRoom room = GotyeRoom.createRoomJson(json["room"]);
                        api.onEventRised(code, userState.SetArgs(mCode, room));
                    }
                    break;

                case GotyeEventCode.LeaveRoom:
                    {
                        int mCode = (int)json["code"];
                        GotyeRoom room = GotyeRoom.createRoomJson(json["room"]);
                        api.onEventRised(code, userState.SetArgs(mCode, room));

                    }


                    break;

                case GotyeEventCode.GetUserList:
                    {
                        int mCode = (int)json["code"];
                        int pageIndex = (int)json["pageIndex"];
                        List<GotyeUser> totlaMembers = new List<GotyeUser>();
                        GotyeJsonData allMemberList = json["allMemberList"];
                        int len = allMemberList.Count;
                        if (len > 0)
                        {
                            for (int i = 0; i < len; i++)
                            {
                                totlaMembers.Add(GotyeUser.jsonToUser(allMemberList[i]));
                            }
                        }

                        List<GotyeUser> curPageMembers = new List<GotyeUser>();


                        GotyeJsonData curPageMemberList = json["curPageMemberList"];
                        int llen = curPageMemberList.Count;
                        if (llen > 0)
                        {
                            for (int i = 0; i < llen; i++)
                            {
                                curPageMembers
                                        .Add(GotyeUser.jsonToUser(curPageMemberList[i]));
                            }
                        }
                        GotyeRoom room = GotyeRoom.createRoomJson(json["room"]);
                        //DispatchListener.onListener(code, mCod, room, totlaMembers, curPageMembers,
                        //	pageIndex);
                        api.onEventRised(code, userState.SetArgs(mCode, room, pageIndex, curPageMembers, totlaMembers));
                    }

                    break;

                case GotyeEventCode.GetHistoryMessageList:
                    {
                        List<GotyeMessage> mList = new List<GotyeMessage>();
                        int mCode = (int)json["code"];
                        GotyeJsonData Array = json["msglist"];
                        if (Array != null)
                        {
                            int len = Array.Count;
                            if (len > 0)
                            {
                                for (int i = 0; i < len; i++)
                                {
                                    GotyeMessage gMsg = GotyeMessage
                                            .jsonToMessage(Array[i]);
                                    mList.Add(gMsg);
                                }
                            }
                        }
                        api.onEventRised(code, userState.SetArgs(mCode, mList));
                    }

                    break;

                case GotyeEventCode.SearchGroup:
                    {
                        List<GotyeGroup> allList = new List<GotyeGroup>();
                        List<GotyeGroup> curList = new List<GotyeGroup>();
                        int mCode = (int)json["code"];



                        int mPagerIndex = (int)json["pageIndex"];

                        GotyeJsonData array = json["allList"];
                        int len = array.Count;
                        if (len > 0)
                        {
                            for (int i = 0; i < len; i++)
                            {
                                allList.Add(GotyeGroup.createGroupJson(array[i]));
                            }
                        }
                        GotyeJsonData array2 = json["curPageList"];
                        int lenn = array2.Count;
                        if (lenn > 0)
                        {
                            for (int i = 0; i < lenn; i++)
                            {
                                curList.Add(GotyeGroup.createGroupJson(array2[i]));
                            }
                        }

                        api.onEventRised(code, userState.SetArgs(mCode, allList, curList, mPagerIndex));
                    }

                    break;

                case GotyeEventCode.CreateGroup:
                    {
                        int mCode = (int)json["code"];
                        GotyeGroup group = GotyeGroup.createGroupJson(json["group"]);
                        api.onEventRised(code, userState.SetArgs(mCode, group));
                    }
                    break;
                case GotyeEventCode.JoinGroup:
                    {
                        int mCode = (int)json["code"];
                        GotyeGroup group = GotyeGroup.createGroupJson(json["group"]);
                        api.onEventRised(code, userState.SetArgs(mCode, group));
                    }
                    break;

                case GotyeEventCode.LeaveGroup:
                    {
                        int mCode = (int)json["code"];
                        GotyeGroup group = GotyeGroup.createGroupJson(json["group"]);
                        api.onEventRised(code, userState.SetArgs(mCode, group));
                    }
                    break;

                case GotyeEventCode.DismissGroup:
                    {
                        int mCode = (int)json["code"];
                        GotyeGroup group = GotyeGroup.createGroupJson(json["group"]);
                        api.onEventRised(code, userState.SetArgs(mCode, group));
                    }
                    break;

                case GotyeEventCode.KickoutUser:
                    {
                        int mCode = (int)json["code"];
                        GotyeGroup group = GotyeGroup.createGroupJson(json["group"]);
                        GotyeUser user = GotyeUser.jsonToUser(json["user"]);
                        api.onEventRised(code, userState.SetArgs(mCode, group, user));
                    }

                    break;

                case GotyeEventCode.ChangeGroupOwner:
                    {
                        int mCode = (int)json["code"];
                        GotyeGroup group = GotyeGroup.createGroupJson(json["group"]);
                        GotyeUser user = GotyeUser.jsonToUser(json["user"]);
                        api.onEventRised(code, userState.SetArgs(mCode, group, user));
                    }
                    break;

                case GotyeEventCode.UserJoinGroup:
                    {
                        int mCode = (int)GotyeStatusCode.CodeOK;
                        GotyeGroup group = GotyeGroup.createGroupJson(json["group"]);
                        GotyeUser user = GotyeUser.jsonToUser(json["user"]);
                        api.onEventRised(code, userState.SetArgs(mCode, group, user));
                    }
                    break;
                case GotyeEventCode.UserLeaveGroup:
                    {
                        int mCode = (int)GotyeStatusCode.CodeOK;
                        GotyeGroup group = GotyeGroup.createGroupJson(json["group"]);
                        GotyeUser user = GotyeUser.jsonToUser(json["user"]);
                        api.onEventRised(code, userState.SetArgs(mCode, group, user));
                    }
                    break;

                case GotyeEventCode.UserDismissGroup:
                    {
                        int mCode = (int)GotyeStatusCode.CodeOK;
                        GotyeGroup group = GotyeGroup.createGroupJson(json["group"]);
                        GotyeUser user = GotyeUser.jsonToUser(json["user"]);
                        api.onEventRised(code, userState.SetArgs(mCode, group, user));
                    }
                    break;

                case GotyeEventCode.UserKickedFromGroup:
                    {
                        int mCode = (int)GotyeStatusCode.CodeOK;
                        GotyeGroup group = GotyeGroup.createGroupJson(json["group"]);
                        GotyeUser kicked = GotyeUser.jsonToUser(json["kicked"]);
                        GotyeUser actor = GotyeUser.jsonToUser(json["actor"]);
                        api.onEventRised(code, userState.SetArgs(mCode, group, kicked, actor));
                    }
                    break;

                case GotyeEventCode.GetGroupList:
                    {
                        List<GotyeGroup> groupList = new List<GotyeGroup>();
                        int mCode = (int)json["code"];
                        GotyeJsonData Array = json["grouplist"];
                        if (Array != null)
                        {
                            int len = Array.Count;
                            if (len > 0)
                            {
                                for (int i = 0; i < len; i++)
                                {
                                    GotyeGroup group = GotyeGroup.createGroupJson(Array[i]);
                                    groupList.Add(group);
                                }
                            }
                        }
                        api.onEventRised(code, userState.SetArgs(mCode, groupList, 0));
                    }
                    break;

                case GotyeEventCode.GetGroupInfo:
                    {
                        int mCode = (int)json["code"];
                        GotyeGroup group = GotyeGroup.createGroupJson(json["group"]);
                        api.onEventRised(code, userState.SetArgs(mCode, group));
                    }
                    break;
                case GotyeEventCode.ModifyGroupInfo:
                    {
                        int mCode = (int)json["code"];
                        GotyeGroup group = GotyeGroup.createGroupJson(json["group"]);
                        api.onEventRised(code, userState.SetArgs(mCode, group));
                    }
                    break;

                case GotyeEventCode.GetGroupUserList:
                    {
                        List<GotyeUser> allList = new List<GotyeUser>();
                        List<GotyeUser> curList = new List<GotyeUser>();
                        GotyeGroup group = null;
                        int mCode = (int)json["code"];
                        int mPagerIndex = (int)json["pageIndex"];
                        GotyeJsonData array = json["allMemberList"];
                        int len = array.Count;
                        if (len > 0)
                        {
                            for (int i = 0; i < len; i++)
                            {
                                GotyeUser user = GotyeUser.jsonToUser(array[i]);
                                allList.Add(user);
                            }
                        }

                        GotyeJsonData cur = json["curPageMemberList"];
                        int lenn = cur.Count;
                        if (lenn > 0)
                        {
                            for (int j = 0; j < lenn; j++)
                            {
                                GotyeUser user = GotyeUser.jsonToUser(cur[j]);
                                curList.Add(user);
                            }
                        }
                        group = GotyeGroup.createGroupJson(json["group"]);

                        api.onEventRised(code, userState.SetArgs(mCode, group, mPagerIndex, curList, allList));
                    }
                    break;

                case GotyeEventCode.ReceiveNotify:
                    {
                        int mCode = (int)json["code"];
                        GotyeNotify notify = GotyeNotify.jsonToNotify(json["notify"]);
                        api.onEventRised(code, userState.SetArgs(mCode, notify));
                    }
                    break;

                case GotyeEventCode.GetOfflineMessageList:
                    {
                    }
                    break;

                case GotyeEventCode.SendMessage:
                    {
                        int mCode = (int)json["code"];
                        GotyeMessage message = GotyeMessage.jsonToMessage(json["message"]);
                        api.onEventRised(code, userState.SetArgs(mCode, message));
                    }
                    break;

                case GotyeEventCode.ReceiveMessage:
                    {
                        int mCode = (int)json["code"];
                        GotyeMessage message = GotyeMessage.jsonToMessage(json["message"]);
                        api.onEventRised(code, userState.SetArgs(mCode, message));
                    }
                    break;

                case GotyeEventCode.DownloadMessage:
                    {
                        int mCode = (int)json["code"];
                        GotyeMessage message = GotyeMessage.jsonToMessage(json["message"]);
                        api.onEventRised(code, userState.SetArgs(mCode, message));
                    }
                    break;

                case GotyeEventCode.StartTalk:
                    {
                        int mCode = (int)json["code"];
                        bool mIsReal = (bool)json["is_realtime"];
                        int mTarType = (int)json["target_type"];
                        GotyeChatTarget mTarget = new GotyeChatTarget();
                        if (mTarType == 0)
                        {
                            string name = (string)json["target"];
                            mTarget = new GotyeUser(name);
                        }
                        else if (mTarType == 1)
                        {
                            uint roomid = (uint)json["target"];
                            mTarget = new GotyeRoom(roomid);
                        }
                        else if (mTarType == 2)
                        {
                            uint groupId = (uint)json["target"];
                            mTarget = new GotyeGroup(groupId);
                        }
                        api.onEventRised(code, userState.SetArgs(mCode, mTarget, mIsReal));
                    }
                    break;
                case GotyeEventCode.StopTalk:
                    {
                        int mCode = (int)json["code"];
                        bool isVoiceRealTime = (bool)json["realtime"];
                        GotyeMessage message = null;
                        if (mCode == 0)
                        {
                            if (isVoiceRealTime == false)
                            {
                                message = GotyeMessage.jsonToMessage(json["message"]);
                            }
                        }
                        api.onEventRised(code, userState.SetArgs(mCode, isVoiceRealTime, message));
                    }
                    break;

                case GotyeEventCode.DownloadMedia:
                    {
                        int mCode = (int)json["code"];
                        String mPath = (string)json["path"];
                        String mUrl = (string)json["url"];
                        GotyeMedia media = new GotyeMedia(GotyeMediaType.Image);
                        media.Path = mPath;
                        media.PathEx = mPath;
                        media.Url = mUrl;

                        api.onEventRised(code, userState.SetArgs(mCode, media));
                    }
                    break;
                case GotyeEventCode.PlayStart:
                    {
                        int mCode = (int)json["code"];
                        GotyeMessage message = GotyeMessage.jsonToMessage(json["message"]);
                        api.onEventRised(code, userState.SetArgs(mCode, message));
                    }

                    break;

                case GotyeEventCode.RealPlayStart:
                    {
                        int mCode = (int)json["code"];
                        GotyeRoom romom = GotyeRoom.createRoomJson(json["room"]);
                        GotyeUser speaker = GotyeUser.jsonToUser(json["speaker"]);
                        api.onEventRised(code, userState.SetArgs(mCode, romom, speaker));
                    }
                    break;

                case GotyeEventCode.Playing:
                    {
                        int mCode = (int)json["code"];
                        int mPosition = (int)json["position"];
                        api.onEventRised(code, userState.SetArgs(mCode, mPosition));
                    }
                    break;

                case GotyeEventCode.PlayStop:
                    {
                        int mCode = (int)json["code"];
                        api.onEventRised(code, userState.SetArgs(mCode));
                    }
                    break;

                case GotyeEventCode.Report:
                    {
                        int mCode = (int)json["code"];
                        GotyeMessage message = GotyeMessage.jsonToMessage(json["message"]);
                        api.onEventRised(code, userState.SetArgs(mCode, message));
                    }
                    break;

                case GotyeEventCode.DecodeFinished:
                    {
                        int mCode = (int)json["code"];
                        GotyeMessage message = GotyeMessage.jsonToMessage(json["message"]);
                        api.onEventRised(code, userState.SetArgs(mCode, message));

                    }
                    break;

                case GotyeEventCode.SendNotify:
                    {
                        int mCode = (int)json["code"];
                        GotyeNotify notify = GotyeNotify.jsonToNotify(json["notify"]);
                        api.onEventRised(code, userState.SetArgs(mCode, notify));
                    }
                    break;

                case GotyeEventCode.Reconnecting:
                    {
                        int mCode = (int)json["code"];
                        GotyeUser User = GotyeUser.jsonToUser(json["user"]);
                        api.onEventRised(code, userState.SetArgs(mCode, User));
                    }
                    break;


                case GotyeEventCode.GetLocalRoomList:
                    {
                        int mCode = (int)json["code"];
                        GotyeJsonData localRoomList = json["roomlist"];
                        int lenn = localRoomList.Count;
                        if (lenn > 0)
                        {
                            for (int j = 0; j < lenn; j++)
                            {
                                GotyeRoom room = GotyeRoom.createRoomJson(localRoomList[j]);
                                localRoomList.Add(room);
                            }
                        }
                        api.onEventRised(code, userState.SetArgs(mCode));
                    }
                    break;

                case GotyeEventCode.GetRoomDetail:
                    {
                        int mCode = (int)json["code"];
                        GotyeRoom room = GotyeRoom.createRoomJson(json["room"]);
                        bool inRoom = (bool)json["inRoom"];
                        api.onEventRised(code, userState.SetArgs(mCode, room, inRoom ));
                    }
                    break;

                case GotyeEventCode.GetRoomStatus:
                    {
                        int mCode = (int)json["code"];
                        GotyeRoom room = GotyeRoom.createRoomJson(json["room"]);
                        bool bo = (bool)json["inRoom"];
                        api.onEventRised(code, userState.SetArgs(mCode, room, bo));
                    }
                    break;

                case GotyeEventCode.GetRoomRealtimeSupport:
                    {
                        int mCode = (int)json["code"];
                        GotyeRoom room = GotyeRoom.createRoomJson(json["room"]);
                        bool bo = (bool)json["support_realtime"];
                        api.onEventRised(code, userState.SetArgs(mCode, room, bo));
                    }

                    break;


                case GotyeEventCode.GetUnreadNotifyCount:
                    {
                        int mCode = (int)json["code"];
                        int count = (int)json["count"];
                        api.onEventRised(code, userState.SetArgs(mCode, count));
                    }
                    break;

                case GotyeEventCode.GetNotifyList:
                    {
                        int mCode = (int)json["code"];
                        List<GotyeNotify> mList = new List<GotyeNotify>();
                        GotyeJsonData Array = json["notifylist"];
                        if (Array != null)
                        {
                            int len = Array.Count;
                            if (len > 0)
                            {
                                for (int i = 0; i < len; i++)
                                {
                                    mList.Add(GotyeNotify.jsonToNotify(Array[i]));
                                }
                            }
                        }
                        api.onEventRised(code, userState.SetArgs(mCode, mList));
                    }
                    break;

                case GotyeEventCode.GetLastMessage:
                    {
                        int mCode = (int)json["code"];
                        //(GotyeChatTarget target, GotyeMessage message)
                        GotyeChatTarget target = GotyeChatTarget.jsonToSession(json["target"]);
                        GotyeMessage message = GotyeMessage.jsonToMessage(json["last_message"]);
                        api.onEventRised(code, userState.SetArgs(mCode, target, message));
                    }
                    break;

                case GotyeEventCode.GetSessionList:
                    {
                        int mCode = (int)json["code"];
                       // List<GotyeChatTarget>
                        List<GotyeChatTarget> mList = new List<GotyeChatTarget>();
                        GotyeJsonData Array = json["session_list"];
                        if (Array != null)
                        {
                            int len = Array.Count;
                            if (len > 0)
                            {
                                for (int i = 0; i < len; i++)
                                {
                                    mList.Add(GotyeChatTarget.jsonToSession(Array[i]));
                                }
                            }
                        }
                        api.onEventRised(code, userState.SetArgs(mCode, mList));
                    }
                    break;

                case GotyeEventCode.GetUnreadMessageCount:
                    {
                        int mCode = (int)json["code"];
                        GotyeChatTarget target = GotyeChatTarget.jsonToSession(json["target"]);
                        int count = (int)json["unread_count"];

                        api.onEventRised(code, userState.SetArgs(mCode, target, count));
                    }
                    break;

                case GotyeEventCode.GetTotalUnreadMessageCount:
                    {
                        int mCode = (int)json["code"];
                        int count = (int)json["total_unread_count"];
                        api.onEventRised(code, userState.SetArgs(mCode, count));
                    }
                    break;

                case GotyeEventCode.GetTotalUnreadMessageCountOfTypes:
                    {
                        int mCode = (int)json["code"];
                        int count = (int)json["unread_count"];

                        api.onEventRised(code, userState.SetArgs(mCode, count));
                    }
                    break;
            }

            /***
            switch (code)
            {
                case GotyeEventCode.Login:
                    api.onEventRised(code, userState.SetArgs(status));
                    break;
                case GotyeEventCode.Logout:
                    api.onEventRised(code, userState.SetArgs(status));
                    break;
                case GotyeEventCode.GetUserInfo:

                    api.Log("GotyeEventCode.GetUserInfo++++++++++++++++++++++++++++++++++++start");
                    string name = (string)json["user"]["name"];
                    GotyeUser user = new GotyeUser(name);
                    user.Gender = (GotyeGender)(int)json["user"]["gender"];
                    user.NickName = (string)json["user"]["nickname"];
                    user.Icon = new GotyeMedia(GotyeMediaType.Image);
                    user.Icon.Url = (string)json["user"]["icon"]["url"];
                    user.Icon.Path = (string)json["user"]["icon"]["path"];
                    user.Icon.PathEx = (string)json["user"]["icon"]["path_ex"];
                    api.onEventRised(code, userState.SetArgs(status, user));
                    api.Log("GotyeEventCode.GetUserInfo+++++++++++++++++++++++end");

                    break;
                case GotyeEventCode.ModifyUserInfo:
                    api.onEventRised(code, userState.SetArgs(status));
                    break;
                case GotyeEventCode.GetRoomList:
                    int pageIndex = (int)json["pageIndex"];
                    JsonData list = json["roomlist"];
                    List<GotyeRoom> roomlist = new List<GotyeRoom>();

                    for (int i = 0; i < list.Count; i++)
                    {
                        JsonData item = list[i];
                        int roomId = (int)item["id"];
                        GotyeRoom room = new GotyeRoom(roomId);
                        room.Name = (string)item["name"];
                        room.Icon = new GotyeMedia(GotyeMediaType.Image);
                        room.Icon.Url = (string)item["icon"]["url"];
                        room.Icon.Path = (string)item["icon"]["path"];
                        room.Icon.PathEx = (string)item["icon"]["path_ex"];
                        roomlist.Add(room);
                    }
                    api.onEventRised(code, userState.SetArgs(status, pageIndex, roomlist));
                    break;
                case GotyeEventCode.EnterRoom:
                    {
                        int roomId = (int)json["roomID"];
                        Int64 lastMsgId = (Int64)json["lastMsgID"];
                        api.onEventRised(code, userState.SetArgs(status, roomId, lastMsgId));
                    }
                    break;
                case GotyeEventCode.LeaveRoom:
                    {
                        int roomId = (int)json["roomID"];
                        //int roomId = (int)userState.Args[1];
                        api.onEventRised(code, userState.SetArgs(status, roomId));
                    }
                    break;

                case GotyeEventCode.GetUserList:
                    {
                        int roomId = (int)json["roomID"];
                        List<string> userlist = new List<string>();
                        JsonData jsonlist = json["userlist"];
                        for (int i = 0; i < jsonlist.Count; i++)
                        {
                            userlist.Add((string)jsonlist[i]);
                        }

                        //int roomId = (int)userState.Args[1];
                        //List<string> userlist = userState.Args[2] as List<string>;
                        api.onEventRised(code, userState.SetArgs(status, roomId, userlist));
                    }
                    break;
                case GotyeEventCode.SendMessage:
                    {
                        //api().Log("case GotyeEventCode.SendMessage");
                        GotyeMessage message = GotyeMessage.jsonToMessage(json);

                        //GotyeMessage message = (GotyeMessage)userState.Args[1];
                        api.onEventRised(code, userState.SetArgs(status, message));
                    }
                    break;
                case GotyeEventCode.ReceiveMessage:
                    {
                        GotyeMessage message = GotyeMessage.jsonToMessage(json);
                        api.onEventRised(code, userState.SetArgs(status, message));
                    }
                    break;
                case GotyeEventCode.DownloadMessage:
                    {
                        GotyeMessage message = GotyeMessage.jsonToMessage(json);
                        //GotyeMessage message = (GotyeMessage)userState.Args[1];
                        api.onEventRised(code, userState.SetArgs(status, message));
                    }
                    break;
                case GotyeEventCode.GetHistoryMessageList:
                    {
                        List<GotyeMessage> msglist = new List<GotyeMessage>();
                        JsonData jsonlist = json["msglist"];
                        for (int i = 0; i < jsonlist.Count; i++)
                        {
                            GotyeMessage msg = GotyeMessage.jsonToMessage(jsonlist[i]);
                            msglist.Add(msg);
                        }
                        //List<GotyeMessage> msglist = (List<GotyeMessage>)userState.Args[1];
                        api.onEventRised(code, userState.SetArgs(status, msglist));
                    }
                    break;
                case GotyeEventCode.ReleaseMessage:
                    {
                        GotyeMessage msg = createMessageFromJson(json);
                        //GotyeMessage msg = (GotyeMessage)userState.Args[1];

                        api.onEventRised(code, userState.SetArgs(status, msg));
                    }
                    break;
                case GotyeEventCode.StartTalk:
                    {
                        IGotyeChatTarget target;
                        bool isRoom = (bool)json["is_room"];
                        GotyeChatTargetType t;
                        if (isRoom)
                        {
                            t = (GotyeChatTargetType)1;
                        }
                        else
                        {
                            t = (GotyeChatTargetType)0;
                        }
                        if (t == GotyeChatTargetType.Room)
                        {
                            target = new GotyeRoom((int)json["target"]);
                        }
                        else
                        {
                            target = new GotyeUser((string)json["target"]);
                        }
                        bool realtime = (bool)json["is_realtime"];
                        api.onEventRised(code, userState.SetArgs(status, target, realtime));
                    }
                    break;

                case GotyeEventCode.StopTalk:
                    {
                        GotyeMessage message = null;
                        if (status == 0)
                        {
                            message = createMessageFromJson(json);
                        }
                        api.onEventRised(code, userState.SetArgs(status, message));
                    }
                    break;

                case GotyeEventCode.DownloadMedia:
                    {
                        api().Log("GotyeAPI on DownloadMedia in++++++++++++++++++++++++++++");
                        string url = (string)json["url"];
                        string Path = (string)json["path"];
                        string PathEx = (string)json["path_ex"];
                        GotyeMedia media = new GotyeMedia(GotyeMediaType.Image, Path, PathEx);
                        media.Url = url;
                        api.onEventRised(code, userState.SetArgs(status, media));
                        api().Log("GotyeAPI on DownloadMedia exit----------------------");
                    }
                    break;
                case GotyeEventCode.PlayStart:
                    {
                        bool realtime = (bool)json["is_realtime"];
                        if (realtime)
                        {
                            string who = (string)json["who"];
                            int roomId = (int)json["roomID"];
                            GotyeRoom room = new GotyeRoom(roomId);
                            room.Name = who;
                            api.onEventRised(code, userState.SetArgs(0, true, null, room));
                        }
                        else
                        {
                            GotyeMessage msg = createMessageFromJson(json);
                            api.onEventRised(code, userState.SetArgs(0, false, msg, null));
                        }
                    }
                    break;

                case GotyeEventCode.Playing:
                    {
                        int pos = (int)json["position"];
                        api.onEventRised(code, userState.SetArgs(0, pos));
                    }
                    break;

                case GotyeEventCode.PlayStop:
                    {
                        api.onEventRised(code, userState.SetArgs(0));
                    }
                    break;


                case GotyeEventCode.Report:
                    {
                        GotyeMessage message = createMessageFromJson(json);
                        //GotyeMessage message = (GotyeMessage)userState.Args[1];
                        api.onEventRised(code, userState.SetArgs(status, message));
                    }
                    break;
            }
            */

           


        }
    }
}
