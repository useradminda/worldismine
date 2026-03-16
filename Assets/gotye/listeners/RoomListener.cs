using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
 

namespace gotye{

public interface RoomListener  : GotyeListener{
	/**
	 * 进入聊天室回调
	 * @param code 状态码 参见 {@link GotyeStatusCode}
	 * @param room 当前聊天室对象
	 */
	void onEnterRoom(GotyeStatusCode code, GotyeRoom room);

	/**
	 * 离开聊天室
	 * @param code 状态码 参见 {@link GotyeStatusCode}
	 * @param room 当前聊天室对象
	 */
	void onLeaveRoom(GotyeStatusCode code, GotyeRoom room);

	/**
	 * 回去聊天室列表
	 * @param code 状态码 参见 {@link GotyeStatusCode}
	 * @param gotyeroom 聊天室列表
	 */
    void onGetRoomList(GotyeStatusCode code, int pageIndex, List<GotyeRoom> curPageRoomList, List<GotyeRoom> allRoomList);

	/**
	 * 获取聊天室成员列表
	 * @param code 状态码 参见 {@link GotyeStatusCode}
	 * @param room 当前聊天室 
	 * @param totalMembers 每页结果集合
	 * @param currentPageMembers 当前页集合
	 * @param pageIndex 当前页码
	 */
	void onGetRoomMemberList(GotyeStatusCode code, GotyeRoom room , int pageIndex, List<GotyeUser> currentPageMembers,List<GotyeUser> totalMembers);


    void onGetLocalRoomList(List<GotyeRoom> curPageRoomList);
    void onGetRoomDetail(GotyeStatusCode code, GotyeRoom room);

    void onGetRoomStatus(GotyeRoom room, bool In);

    void onGetRoomRealtimeStatus(GotyeRoom room, bool support);

    

    
}
}