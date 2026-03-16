--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
PlayerInfoSys = {}
PlayerInfoSys.DataList = {}
PlayerInfoSys.CallBackEvent = nil
PlayerInfoSys.PlayerSearchId = ""

PlayerInfoSys.PlayerSearchTempList = {}

function PlayerInfoSys.SetInfo(data)

	if data~=nil then
		for key,value in pairs(data) do
			local Id = tonumber(key)
			if Id~=nil then
				local item = PlayerInfoSys.CreatePlayerInfo(value)
				local player = value["Player"]
				local id = tonumber(player["_id"])
				PlayerInfoSys.DataList[id] = item
			end

		end
	end
end
--创建玩家数据
function PlayerInfoSys.CreatePlayerInfo(data)

	local player = data["Player"]
	local army = data["Army"]
	local hero = data["Hero"]
	local formation = data["Formation"]
	local lua = GameMain.requireLuaFile("PlayerInfo")
	local rolebaby = lua:new()
	rolebaby:Init(player , army , hero , formation)
	return rolebaby
end

function PlayerInfoSys.SetName(_Info)
	local info = _Info
	WebEvent.SetNamePlayer(info  ,"PlayerInfoSys.SetNameCallBack" , PlayerInfoSys.SetNameCallBack)
end

function PlayerInfoSys.SetNameCallBack(data , returnId)
	local isSuccess = returnId
	
	local UIPlayerInfoTar = MainGameUI.FindPanelTarget(UIPlayerInfo)
	if UIPlayerInfo ~= nil then
		UIPlayerInfo:ShowSetNameAfter(isSuccess)
	end
end

--查询玩家的信息 ischange=1,需要请求 ischange =0 不需要一直请求网络  ; IdList 玩家的ID多个用下划线链接;IsFull 1所有 2 player
function PlayerInfoSys.SearchInfo(IsChange, IdList,IsFull,CallBack)
	if IdList == nil then
		CallBack(nil)
		return
	end
	PlayerInfoSys.PlayerSearchId = ""
	PlayerInfoSys.PlayerSearchId = IdList
	if IsChange == 1 then
		PlayerInfoSys.SendWebGetPlayerInfo( IdList , IsFull,CallBack )
	else
		local list = ""
		PlayerInfoSys.PlayerSearchTempList = {}
		local idList = GameMain.StringSplit(IdList , "_")
		for key,value in pairs(idList) do
			local id = tonumber(value)
			if PlayerInfoSys.DataList[id]~=nil then
				PlayerInfoSys.PlayerSearchTempList[id] = PlayerInfoSys.DataList[id]
			else
				if list == "" then
					list = list .. tostring(id)
				else
					list = list .. "_" .. tostring(id)
				end
			end
		end
		if list == "" then
			CallBack(PlayerInfoSys.PlayerSearchTempList)
		else
			PlayerInfoSys.SendWebGetPlayerInfo( list , IsFull, CallBack )
		end
	end
end
--本地没有数据，向服务器请求
function PlayerInfoSys.SendWebGetPlayerInfo( IdList , IsFull, CallBack)
	PlayerInfoSys.CallBackEvent = nil
	PlayerInfoSys.CallBackEvent = CallBack
	local info = IdList .. "," .. IsFull
	WebEvent.GetPlayerInfo(info , "PlayerInfoSys.SendWebGetPlayerInfoCallBack" ,PlayerInfoSys.SendWebGetPlayerInfoCallBack)
end

function PlayerInfoSys.SendWebGetPlayerInfoCallBack(data , returnId)
	local list = {}
	local idList = GameMain.StringSplit(PlayerInfoSys.PlayerSearchId , "_")
	for key,value in pairs(idList) do
		local id = tonumber(value)
		list[id] = PlayerInfoSys.DataList[id]
	end
	PlayerInfoSys.CallBackEvent(list)
end

function PlayerInfoSys.ReleasData()
	PlayerInfoSys.DataList = {}
	PlayerInfoSys.CallBackEvent = nil
	PlayerInfoSys.PlayerSearchId = ""

	PlayerInfoSys.PlayerSearchTempList = {}
end

return PlayerInfoSys
--endregion
