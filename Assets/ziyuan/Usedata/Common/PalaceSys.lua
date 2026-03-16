--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
PalaceSys = {}
PalaceSys.InitElectId = 0	--初始化的ID
PalaceSys.IsJoined = 0		--是否参选
PalaceSys.VoteCount = 0		--投票的次数
PalaceSys.ElectList = {}	--官员选举的官职列表

PalaceSys.OfficerList = {}	--王宫的排名

PalaceSys.IsRwdRecvd = 0	--是否领取俸禄

function PalaceSys.Init()		--王宫初始化
	local info  = nil
	WebEvent.PalaceInit(info , "PalaceSys.InitCallBack" , PalaceSys.InitCallBack)
end

function PalaceSys.InitCallBack(data , returnId)
	local UIPalaceTar = MainGameUI.FindPanelTarget("UIPalace")
	if UIPalaceTar ~=nil then
		UIPalaceTar:ShowPalaceInfo()
	end
end


function PalaceSys.RecvReward()		--领取俸禄
	local info = nil
	WebEvent.PalaceRwd(info , "PalaceSys.RecvRewardCallBack" , PalaceSys.RecvRewardCallBack)
end

function PalaceSys.RecvRewardCallBack(data , returnId)

end

--选举界面初始化
function PalaceSys.InitElect()
	local info = PalaceSys.InitElectId
	WebEvent.PalaceInitElection(info , "PalaceSys.InitElectCallBack", PalaceSys.InitElectCallBack)
end

function PalaceSys.InitElectCallBack(data , returnId)
	local UIPalaceTar = MainGameUI.FindPanelTarget("UIPalace")
	if UIPalaceTar ~=nil then
		UIPalaceTar:ShowElectPanelInfo()
	end
end

--投票
function PalaceSys.Vote(Id)
	local info = Id
	WebEvent.PalaceVote(info , "PalaceSys.VoteCallBack" , PalaceSys.VoteCallBack)
end

function PalaceSys.VoteCallBack(data , returnId)
    if returnId == 0 then
	    local UIPalaceTar = MainGameUI.FindPanelTarget("UIPalace")
	    if UIPalaceTar ~=nil then
	    	UIPalaceTar:ShowElectPanelInfo()
	    end
        DataUIInstance.PopTip("Z1")
    elseif returnId == 2 then
        DataUIInstance.PopTip("Z2")
    end
end

--参选
function PalaceSys.JoinElection()
	local info = nil
	WebEvent.PalaceJoinElection(info , "PalaceSys.JoinElectionCallBack" , PalaceSys.JoinElectionCallBack)
end

function PalaceSys.JoinElectionCallBack(data , returnId)
	local UIPalaceTar = MainGameUI.FindPanelTarget("UIPalace")
	if UIPalaceTar ~=nil then
		UIPalaceTar:ShowJointElectAfter()
	end
end

function PalaceSys.GetElectDataList()				--得到官员选举初始化的数据
	table.sort(PalaceSys.ElectList , PalaceSys.CompElect)
	return PalaceSys.ElectList

end

function PalaceSys.CompElect(A , B)
	if A == nil then
		return false
	end
	if B == nil then
		return false
	end
	if A.OwnCount > B.OwnCount then
		return true
	end
	if A.OwnCount == B.OwnCount then
		if A.VipLvl > B.VipLvl then
			return true
		end
		if A.VipLvl == B.VipLvl then
			if A.CreateTime > B.CreateTime then
				return true
			end
			if A.CreateTime == B.CreateTime then
				return true
			end
			if A.CreateTime < B.CreateTime then
				return false
			end
		end
		if A.VipLvl < B.VipLvl then
			return false
		end
	end
	if A.OwnCount < B.OwnCount then
		return false
	end
end

function PalaceSys.AddElectList(_Id , _Num , _Lvl , _CreateTime , _Name)
	local data = PalaceSys.CreateElect(_Id , _Num , _Lvl , _CreateTime , _Name)
	local index = PalaceSys.GetElectIndex(data)
	if index == nil then
		table.insert(PalaceSys.ElectList , #PalaceSys.ElectList +1 , data)
	else
		PalaceSys.ElectList[index] = data
	end
end

function PalaceSys.GetElectIndex(_Data)
	if #PalaceSys.ElectList == 0 then
		return nil
	end
	for key,value in pairs(PalaceSys.ElectList) do
		if _Data.Dbid == value.Dbid then
			return key
		end
	end
	return nil
end

function PalaceSys.CreateElect(_Id , _Num , _Lvl , _CreateTime , _Name)
	local lua = GameMain.requireLuaFile("PalaceElect")
	local elect = lua:new()
	elect:Init(_Id , _Num , _Lvl , _CreateTime , _Name)
	return elect
end


--王宫初始化信息
function PalaceSys.ComminfoInitCallBack(data)
	
	if data~=nil then
		PalaceSys.OfficerList = {}
		for key,value in pairs(data) do
			local rankNum = tonumber(key)
			if rankNum~=nil then
				local playerData = 
				{
					RankNum = rankNum,
					Id = tonumber(value["_id"]),
					Name = tostring(value["name"]),
					Lvl = tonumber(value["vip"]),
					Num = tonumber(value["num"]),
					CreateTime = tonumber(value["create_time"]),
					ModelId = tonumber(value["commanderId"]),
--					ModelId = 20614,--测试用
				}
				if playerData~=nil then
					PalaceSys.OfficerList[rankNum +1] = playerData
				end
			end
		end
		GameMain.Print(PalaceSys.OfficerList , "initpalacedatas")
	end
end

--官员选举初始化信息
function PalaceSys.VoteResultCallBack(data)
	if data ~= nil then
		PalaceSys.InitElectId = tonumber(data["ver"])
		local list = data["list"]
		if list~=nil then
			for key,value in pairs(list) do
				local id = tostring(value["_id"])
				local num = tonumber(value["num"])
				local lv = tonumber(value["lv"])
				local name = tostring(value["name"])
				local createTime = tonumber(value["create_time"])
--				local commandId = tonumber(value["commanderId"])
				PalaceSys.AddElectList(id , num , lv , createTime , name)
			end
		end
	end
end

--个人信息
function PalaceSys.ComminfoCallBack(data)
	if data~=nil then
		PalaceSys.IsJoined = tonumber(data["isCandidate"])		--是否参选
		PalaceSys.VoteCount = tonumber(data["voteChance"])		--投票的次数
		PalaceSys.IsRwdRecvd = tonumber(data["rewardRecvd"])	--是否领取俸禄
	end
end

function PalaceSys.GetMyPosition()
	if #PalaceSys.OfficerList>0 then
		for i=1,#PalaceSys.OfficerList,1 do
			local playerData = PalaceSys.OfficerList[i]
			
			if tonumber(playerData.Id) == tonumber( ClinetInfomation.Player_id) then
				return i
			end
		end
	end
	return nil
end

function PalaceSys.GetMyOffical()	--得到我的官职
	local index =  PalaceSys.GetMyPosition()
	if index == nil then
		return UIstring.OfficerName[12]
	end
	if index<=9  then
		return UIstring.OfficerName[index]
	end
	if index>9 and index<=17 then
		return UIstring.OfficerName[10]
	end
	if index>17 and index<=33 then
		return UIstring.OfficerName[11]
	end
	return UIstring.OfficerName[12]
end

function PalaceSys.GetPosRewardData()
	local index =  PalaceSys.GetMyPosition()
	if index == nil then
		return OfficialRwdDataConfig.GetDataById(106)
	end
	if index<=1 then
		return OfficialRwdDataConfig.GetDataById(101)
	end
	if index>1 and index<=4 then
		return OfficialRwdDataConfig.GetDataById(102)
	end
	if index>5 and index<=9 then
		return OfficialRwdDataConfig.GetDataById(103)
	end
	if index>9 and index<=10 then
		return OfficialRwdDataConfig.GetDataById(104)
	end
	if index>10 and index<=11 then
		return OfficialRwdDataConfig.GetDataById(105)
	end
	return OfficialRwdDataConfig.GetDataById(106)
end
return PalaceSys
--endregion
