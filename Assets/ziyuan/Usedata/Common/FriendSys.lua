--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
FriendSys = {}

FriendSys.RecommendDataList = {}	--推荐好友的数据
FriendSys.FriendDataDic = {}		--我拥有的好友
FriendSys.BlackFriendDic = {}		--黑名单
FriendSys.RequireDataDic = {}		--向我申请的好友
FriendSys.HasSendStrsList = {}		--已经申请的好友list

--请求推荐好友 1刷新 0 不刷新
function FriendSys.RecommendFriend(_IsRefrash)
	local info = _IsRefrash
	WebEvent.RecommendFriend(info , "FriendSys.RecommendFriendCallBack", FriendSys.RecommendFriendCallBack)
end

function FriendSys.RecommendFriendCallBack(data , returnId)
	local uiFriendTar = MainGameUI.FindPanelTarget("UIFriend")
	if uiFriendTar ~=nil then
		
		uiFriendTar:ShowAddFriendCallBack()
	end

end

--请求添加好友
function FriendSys.RequestFriend(ID)	
	if FriendSys.FriendDataDic[ID] ~= nil then
		DataUIInstance.PopTip(UIstring.HasOwnFriend)
		return
	end		
	local info = ID
	WebEvent.RequestFriend(info , "FriendSys.RequestFriendCallBack" ,FriendSys.RequestFriendCallBack)
end

function FriendSys.RequestFriendCallBack(data , returnId)
	
end

--处理好友请求 1接受 0 不接受
function FriendSys.ResponseFriend(ID , IsResponse)
	local info = ID .. "," .. IsResponse
	WebEvent.ResponseFriend(info , "FriendSys.ResponseFriendCallBack" , FriendSys.ResponseFriendCallBack)
end

function FriendSys.ResponseFriendCallBack(data , returnId)
	
end

--删除好友
function FriendSys.RemoveFriend(_ID)
	local  info = _ID
	WebEvent.RemoveFriend(info , "FriendSys.RemoveFriendCallBack" ,FriendSys.RemoveFriendCallBack )
end

function FriendSys.RemoveFriendCallBack(data , returnId)

end
--加入黑名单
function FriendSys.AddBlackFriend(_ID)
	local info = _ID
	WebEvent.AddBlackFriend(info , "FriendSys.AddBlackFriendCallBack" , FriendSys.AddBlackFriendCallBack)
end

function FriendSys.AddBlackFriendCallBack(data , returnId)

end

--删除黑名单
function FriendSys.RemoveBlackFriend(_ID)
	local info = _ID
	WebEvent.RemoveBlackFriend(info , "FriendSys.RemoveBlackFriendCallBack" , FriendSys.RemoveBlackFriendCallBack)
end

function FriendSys.RemoveBlackFriendCallBack(data , returnId)

end


function FriendSys.ComminfoInitCallBack(data)	--好友相关的所有信息
	local friendData = data["friend"]
	local friendRequire = data["request"]
	local friendBlack = data["blackname"]
	local friendSend = data["send"]

	FriendSys.SetSendFriend(friendSend)
	FriendSys.SetMyFriend(friendData)
	FriendSys.SetHasRequestInfo(friendRequire)
	FriendSys.SetBlackInfo(friendBlack)
	
end

function FriendSys.SetSendFriend(data)
	if data~=nil then
		FriendSys.HasSendStrsList = {}
		for key,value in pairs(data) do
			local id = tonumber(value)
			if id ~=nil then
				FriendSys.HasSendStrsList[tostring(value)] = value
			end
		end
	else
		FriendSys.HasSendStrsList = {}
	end
	
end

--设置已经向我申请的好友
function FriendSys.SetHasRequestInfo(data)
	if data ~=nil then
		FriendSys.RequireDataDic = {}
		for key,value in pairs(data) do
			local id = tonumber(value)
			if id~=nil then
				FriendSys.RequireDataDic[tostring(value)] = value
			end
		end
	else
		FriendSys.RequireDataDic = {}
	end
end

function FriendSys.SetMyFriend(data)			--已经拥有的好友信息
	if data ~=nil then
		FriendSys.FriendDataDic = {}
		for key,value in pairs(data) do
			local id = tonumber(value)
			if id~=nil then
				FriendSys.FriendDataDic[tostring(value)] = value
			end
		end
	else
		FriendSys.FriendDataDic = {}
	end
end

function FriendSys.SetReconmendInfo(data)	--请求的好友信息		
	if data~=nil then
		FriendSys.RecommendDataList = {}
		for key,value in pairs(data) do
			local index = tonumber(key)
			if index ~= nil then
				local id = tostring(value["_id"])
				if id~=nil then
					local Item = FriendSys.CreateFriend(value)
					table.insert(FriendSys.RecommendDataList , #FriendSys.RecommendDataList +1 ,Item)
				end
			end
		end
	else
		FriendSys.RecommendDataList = {}
	end
end

function FriendSys.SetBlackInfo(data)		--黑名单
	if data~=nil then
		FriendSys.BlackFriendDic = {}
		for key,value in pairs(data) do
			local id = tostring(value)
			if id ~=nil then
				FriendSys.BlackFriendDic[tostring(value)] = value
			end
		end
	else
		FriendSys.BlackFriendDic = {}
	end
end

function FriendSys.GetRecommendIndex(id)			--根据ID得到所在的位置
	for i=1,#FriendSys.RecommendDataList,1  do
		if FriendSys.RecommendDataList[i].Dbid == id then
			return i
		end
	end
	return nil
end

function FriendSys.CreateFriend(_Data)				--创建好友信息
	local lua = GameMain.requireLuaFile("Friend")
	local rolebaby = lua:new()
	rolebaby:Init(_Data)
	return rolebaby
end


function FriendSys.GetMyFriends(CallBack)	--我的好友
	local idList = FriendSys.GetPlayerIdList(FriendSys.FriendDataDic)
	if idList ~= "" then
		PlayerInfoSys.SearchInfo(0, idList,2,CallBack)
	else
		PlayerInfoSys.SearchInfo(0, nil,2,CallBack)
	end
end

function FriendSys.GetBlackFriends(CallBack) --我的黑名单
	local idList = FriendSys.GetPlayerIdList(FriendSys.BlackFriendDic)
	if idList ~= "" then
		PlayerInfoSys.SearchInfo(0, idList,2,CallBack)
	else
		PlayerInfoSys.SearchInfo(0, nil,2,CallBack)
	end
end


function FriendSys.GetRequirseFriends(CallBack)
	local idList = FriendSys.GetPlayerIdList(FriendSys.RequireDataDic)
	if idList ~= "" then
		PlayerInfoSys.SearchInfo(0, idList,2,CallBack)
	else
		PlayerInfoSys.SearchInfo(0, nil,2,CallBack)
	end
end

function FriendSys.GetPlayerIdList(_Data)
	local idList = ""
	for key,value in pairs(_Data) do
		if tonumber(value)~=nil then
			if idList == "" then
				idList = value
			else
				idList = idList .. "_" .. value
			end
		end
	end
	return idList
end

function FriendSys.IsBlackFriend(_Id)				--是否是黑名单
	if FriendSys.BlackFriendDic[_Id] ~= nil then
		return true
	end
	return false
end

function FriendSys.SearchPlayerInfo(_Str)			--查询好友信息
	local info = _Str
	WebEvent.SearchFriendInfo(info , "FriendSys.SearchPlayerInfoCallBack" , FriendSys.SearchPlayerInfoCallBack)
end

function FriendSys.SearchPlayerInfoCallBack(data , returnId)
	local isHas = #data
	if isHas<1 then
		DataUIInstance.PopTip("未找到该玩家")
		return
	end
	local UIFriendTar = MainGameUI.FindPanelTarget("UIFriend")
	if UIFriendTar ~= nil then
		local playerData = PlayerInfoSys.DataList[tonumber(data[1])]
		UIFriendTar:SearchCallBack(playerData)
	end
end

return FriendSys
--endregion
