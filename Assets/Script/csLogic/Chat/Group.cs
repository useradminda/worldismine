using UnityEngine;
using System.Collections;
using gotye;
using System.Collections.Generic;

public class Group : GotyeMonoBehaviour, GroupListener
{
    public GotyeAPI api;
    void Start()
    {
        api = GotyeAPI.GetInstance();
        api.AddListener(this);
    }

    void GroupListener.onCreateGroup(GotyeStatusCode code, GotyeGroup group)
    {
        throw new System.NotImplementedException();
    }

    void GroupListener.onJoinGroup(GotyeStatusCode code, GotyeGroup group)
    {
        throw new System.NotImplementedException();
    }

    void GroupListener.onLeaveGroup(GotyeStatusCode code, GotyeGroup group)
    {
        throw new System.NotImplementedException();
    }

    void GroupListener.onDismissGroup(GotyeStatusCode code, GotyeGroup group)
    {
        throw new System.NotImplementedException();
    }

    void GroupListener.onKickoutGroupMember(GotyeStatusCode code, GotyeGroup group, GotyeUser user)
    {
        throw new System.NotImplementedException();
    }

    void GroupListener.onGetGroupList(GotyeStatusCode code, List<GotyeGroup> grouplist)
    {

    }

    void GroupListener.onGetGroupDetail(GotyeStatusCode code, GotyeGroup group)
    {
        throw new System.NotImplementedException();
    }

    void GroupListener.onGetGroupMemberList(GotyeStatusCode code, GotyeGroup group, int pagerIndex, List<GotyeUser> curList, List<GotyeUser> allList)
    {
        throw new System.NotImplementedException();
    }

    void GroupListener.onSearchGroupList(GotyeStatusCode code, int pageIndex, List<GotyeGroup> curList, List<GotyeGroup> mList)
    {
        throw new System.NotImplementedException();
    }

    void GroupListener.onModifyGroupInfo(GotyeStatusCode code, GotyeGroup gotyeGroup)
    {
        throw new System.NotImplementedException();
    }

    void GroupListener.onChangeGroupOwner(GotyeStatusCode code, GotyeGroup group, GotyeUser user)
    {
        throw new System.NotImplementedException();
    }

    void GroupListener.onUserJoinGroup(GotyeGroup group, GotyeUser user)
    {
        throw new System.NotImplementedException();
    }

    void GroupListener.onUserLeaveGroup(GotyeGroup group, GotyeUser user)
    {
        throw new System.NotImplementedException();
    }

    void GroupListener.onUserDismissGroup(GotyeGroup group, GotyeUser user)
    {
        throw new System.NotImplementedException();
    }

    void GroupListener.onUserKickedFromGroup(GotyeGroup group, GotyeUser kicked, GotyeUser actor)
    {
        throw new System.NotImplementedException();
    }

    void GroupListener.onSendNotify(GotyeStatusCode code, GotyeNotify notify)
    {
        throw new System.NotImplementedException();
    }

    void GroupListener.onReceiveNotify(GotyeStatusCode code, GotyeNotify notify)
    {
        throw new System.NotImplementedException();
    }
}
