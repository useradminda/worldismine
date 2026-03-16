SocketClient = {}

SocketClient.MsgID = {
    --*请求
    RequestLogin = 1,
    RequestMove = 2,
    Requestlook_fight = 3,
    RequestGetReward = 5 ,          --领取天降祥瑞道具
    RequestChangeTeam = 6,          --请求换阵容
    RequestGetCityInfo = 7,         --请求活动城池信息
    RequestHireArmy = 8,            --请求借兵
    RequestBuyArmy = 9,             --购买兵力
    RequestDanTiao = 10,            --单挑
    RequestBack = 11,               --请求撤退
    RequestGoAttack = 12,           --请求突进
    RequestCallFriend = 13,         --请求召集
    RequestRoomMember = 15,         --请求查看房间人数
    --*请求返回
    ReceiveLogin = 1001,            --返回登录
    ReceiveMove = 1002,             --返回移动
    Receivelook_fight = 1003,       --返回观战
    ReceiveFRS_Reward = 1005,       --领取天降祥瑞道具回调
    ReceiveTeam = 1006,             --请求修改阵容的回调
    ReceiveCityInfo = 1007,         --请求活动城池信息回调
    ReceiveHireArmy = 1008,         --请求借兵回调
    ReceiveBuyArmy = 1009,          --请求购买兵力回调
    ReceiveDanTiao = 1010,          --请求单挑回调
    ReceiveBack = 1011,             --请求撤退回调
    ReceiveGoAttack = 1012,         --请求突进回调
    ReceiveCallFriend = 1013,       --请求召集回调
    ReceiveRoomMember = 1015,       --请求查看房间人数回调
    --*推送的
    ReceiveStop = 2001,             --移动到某个点
    ReceiveCityState = 2002,        --推送城池状态
    ReceiveArmy = 2003,             --推送军队信息
    ReceiveActivity = 2004,         --推送活动
    ReceiveReward = 2006 ,          --推送刷新可领取道具 Type 1:天降祥瑞
    ReceiveSouthMan = 2007,         --推送南蛮入侵
    ReceiveArmyData = 2008,         --推送军队行军状态
    ReceiveWorldFight = 2009,       --推送世界战信息
    ReceiveEvent = 2010,            --推送事件
    ReceiveNowArmy = 2011,          --当前多少兵力
    ReceiveCommonInfo = 2013,       --接收信息

    ReceiveDebugMsg = 999,
    ReceiveAfterConnected = 998,
}

SocketClient["MsgHandleFun"] = {};

--[====[   注册网络收包回调函数   ]====]
function SocketClient.RegistMsgHandle(msgID, handle)
    SocketClient["MsgHandleFun"][msgID] = handle;
end

function SocketClient.GetPlayerId() -- 暂用数字模拟用户ID
    local uuid = PlayerPrefs.GetString("uuid");
    if (uuid == "") then
        uuid = os.date("1%M%H%S");
        PlayerPrefs.SetString("uuid", uuid);
    end

    return tonumber(uuid);
end

function SocketClient.CreateConnection(ip, port)
    Debug.LogError(ip)
    Debug.LogError(port)
    DotNetClient.hzClient.Create(ip, port);
end


--[====[   向服务器发送数据   ]====]
--[[ 
    data = {
        intList = {},       --可选
        floatList = {},     --可选
        stringList = {},    --可选
        vectorList = {},    --可选
    };
]]
function SocketClient.SendNetEvent(msgID, data)
    if (data~= nil) then

        local event = {
            id = msgID,
            check = "0",
            dosome = { data },
        };
        local server_id = 2;
        if (msgID == SocketClient.MsgID.RequestLogin) then
            server_id = 8;
        end

        local hzclient = DotNetClient.hzClient.GetPtr();
        if (hzclient ~= nil) then
            local world_id = tostring(LoginData.PlayerID);
            local server_id = server_id;
            GameMain.Print(event, "event to send");
            hzclient:SendNetEvent( world_id, server_id, event );
        else
            Debug.LogError("hzclient == nil");
        end
    end
end


--[====[  接收服务器发过来的数据   ]====]
function SocketClient.ReceiveNetEvent(e)
    local data = {
        intList = {},
        floatList = {},
        stringList = {},
        vectorList = {},
    };

    local EventId = tonumber(e.id);
    if WorldMapSocketSys.ReceiveBattle==true then
       
       if EventId==1003 or EventId==1015 then 
          
       else
          return
       end 

     
    end

    local temp =nil
    for i = 0, e.dosome.intList.Count - 1, 1 do 
        temp =  e.dosome.intList:getItem(i)
        data.intList[i + 1] = temp
    end
    for i = 0, e.dosome.floatList.Count - 1, 1 do 
        data.floatList[i + 1] = e.dosome.floatList[i]; 
    end
    for i = 0, e.dosome.stringList.Count - 1, 1 do
        data.stringList[i + 1] = e.dosome.stringList[i];
    end
    for i = 0, e.dosome.vectorList.Count - 1, 1 do 
        data.vectorList[i + 1] = e.dosome.vectorList[i] 
    end

    local type = tonumber(e.id);

    --GameMain.Print(data, "from server");

    

    if (SocketClient["MsgHandleFun"][type] ~= nil) then
       -- Debug.LogError("C++事件ID")
       -- Debug.LogError(type)
        SocketClient["MsgHandleFun"][type](data);
    else
        Debug.LogError("Unknown msgID " .. tostring(type));
    end
end

function SocketClient.ReceiveBattleEndHandle(data)
    Debug.LogError("战斗结束:" .. data.stringList[1]);
end

function SocketClient.RequestBattleStart(data)
    local data = {
        intList = {},
    }

    SocketClient.SendNetEvent(SocketClient.MsgID.RequestBattleStart, data);
end

function SocketClient.DisConnect()
   local hzclient = DotNetClient.hzClient.GetPtr();
   if hzclient~=nil then
      hzclient:disconnect()
   end
end

return SocketClient;
