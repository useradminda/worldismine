using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace gotye
{

public interface GroupListener  : GotyeListener{
	/**
	 * 创建群回调
	 * @param code 状态码 参见 {@link GotyeStatusCode}
	 * @param group 被创建的群
	 */
	void onCreateGroup(GotyeStatusCode code, GotyeGroup group);

	/**
	 * 加群回调
	 * @param code 状态码 参见 {@link GotyeStatusCode}
	 * @param group 要加群的群
	 */
    void onJoinGroup(GotyeStatusCode code, GotyeGroup group);

	/**
	 * 退出群回调
	 * @param code 状态码 参见 {@link GotyeStatusCode}
	 * @param group 所退出的群
	 */
    void onLeaveGroup(GotyeStatusCode code, GotyeGroup group);

	/**
	 * 解散群回调
	 * @param code 状态码 参见 {@link GotyeStatusCode}
	 * @param group 被解散的群
	 */
    void onDismissGroup(GotyeStatusCode code, GotyeGroup group);

	/**
	 * 踢群成员回调
	 * @param code 状态码 参见 {@link GotyeStatusCode}
	 * @param group 所在群
	 */
	void onKickoutGroupMember(GotyeStatusCode code, GotyeGroup group, GotyeUser user);

	/**
	 * 回去群列表回调
	 * @param code 状态码 参见 {@link GotyeStatusCode}
	 * @param grouplist 群列表
	 */
    void onGetGroupList(GotyeStatusCode code, List<GotyeGroup> grouplist);

	/**
	 * 获取群详情回调
	 * @param code 状态码 参见 {@link GotyeStatusCode}
	 * @param group  群对象
	 */
    void onGetGroupDetail(GotyeStatusCode code, GotyeGroup group);

	/**
	 * 获取群成员回调
	 * @param code 状态码 参见 {@link GotyeStatusCode}
	 * @param allList 请求的每页数据集合
	 * @param curList 当前页成员集合
	 * @param group 所在群
	 * @param pagerIndex 页码
	 */
		void onGetGroupMemberList(GotyeStatusCode code,GotyeGroup group,int pagerIndex,List<GotyeUser> curList, List<GotyeUser> allList);

 
    
	/**
	 * 搜索群结果回调
	 * @param code 状态码 参见 {@link GotyeStatusCode}
	 * @param mList 每页数据结果集合
	 * @param curList 当前数据集合
	 * @param pageIndex 当前页码
	 */
		void onSearchGroupList(GotyeStatusCode code,int pageIndex, List<GotyeGroup> curList,
		                       List<GotyeGroup>  mList);

	/**
	 * 请求修改群回调
	 * @param code 状态码 参见 {@link GotyeStatusCode}
	 * @param gotyeGroup 被修改后的群对象
	 */
    void onModifyGroupInfo(GotyeStatusCode code, GotyeGroup gotyeGroup);
	
	
   /**
    * 请求变更群主
    * @param code 状态码 参见 {@link GotyeStatusCode}
    * @param group 所在群
    */
    void onChangeGroupOwner(GotyeStatusCode code, GotyeGroup group, GotyeUser user);
	
	/**
	 * 有人加群群通知
	 * @param group 所在群
	 * @param user 新加入的成员
	 */
	void onUserJoinGroup(GotyeGroup group, GotyeUser user);
	
	/**
	 * 有人离开群通知
	 * @param group 所在群
	 * @param user 离开的群成员对象
	 */
	void onUserLeaveGroup(GotyeGroup group, GotyeUser user);
	
	/**
	 * 群被接收通知
	 * @param group 所在群
	 * @param user 解散人
	 */
	void onUserDismissGroup(GotyeGroup group, GotyeUser user);
	
	/**
	 * 群成员被踢出通知
	 * @param group 所在群
	 * @param kicked 被踢出的群成员
	 * @param actor 操作人
	 */
	void onUserKickedFromGroup(GotyeGroup group, GotyeUser kicked, GotyeUser actor);

	/**
	 * 发送申请入群信息回调
	 * @param code 状态码 参见 {@link GotyeStatusCode}
	 * @param notify 通知对象
	 */
    void onSendNotify(GotyeStatusCode code, GotyeNotify notify);


    void onReceiveNotify(GotyeStatusCode code, GotyeNotify notify);

    }
}