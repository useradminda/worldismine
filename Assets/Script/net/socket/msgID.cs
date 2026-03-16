namespace DotNetClient {
    public enum NetMsg
    {
        //这两个消息不用注册
        NM_PING = 100,
        NM_PING_REP = 101,

        HANDSHAKE = 1001,
        HANDSHAKE_ACK = 1002,
        HEARTBEAT = 1003,


        CLIENT_LOGIN = 100001,
        CLIENT_LOGIN_REP = 200001,
        BATTLE_ENTER_BT = 300001,


        BATTLE_START = 100002,
        BATTLE_START_REP = 200002,
        BATTLE_START_BT = 300002,

        BATTLE_LEAVE = 100004,
        BATTLE_LEAVE_REP = 200004,
        BATTLE_LEAVE_NTF = 300004,

        BATTLE_ROLE_MOVE = 100011,
        BATTLE_ROLE_MOVE_REP = 200011,
        BATTLE_ROLE_MOVE_BT = 300011,

        BATTLE_SKILL_AT = 100014,		//请求攻击
        BATTLE_SKILL_AT_REP = 200014,	//请求攻击回应
        BATTLE_SKILL_AT_NTF = 300014,	//通知其他玩家攻击

        BATTLE_ATTR_CHANGE_NTF = 300015, //通知客户端某个角色属性改变

        BATTLE_CHANGE_RIDE = 100016,
        BATTLE_CHANGE_RIDE_REP = 200016,
        BATTLE_CHANGE_RIDE_NTF = 300016,

        BATTLE_COLLISION_ASK = 100017,	//碰撞检测请求

        BATTLE_DAMAGE_NTF = 300018,		//伤害广播

        BATTLE_REVIVE_ASK = 100019,		//请求重生


        BATTLE_OBJ_STATE_NTF = 300020,	//场景对象状态更新

        BATTLE_OBJ_EVENT_ASK = 100021,
        BATTLE_OBJ_EVENT_NTF = 300021,

        /**********************以下服务器之间的消息***************************/
        SM_REGISTER_AT_CENTER = 1000001,
        SM_REGISTER_AT_CENTER_RETURN,

        SM_SERVER_HEART_BEAT = 1000003,

		LoginBattleServer = 100022,
		LoginBattleServer_NTF = 200022,
		
		DisConnectBattleServer = 100023,
        /**********************服务器之间的消息结束***************************/
    };
}