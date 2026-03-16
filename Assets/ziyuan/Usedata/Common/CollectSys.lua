--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

CollectSys = {}
CollectSys.BasicMoney = 1000	--征收的基础值
CollectSys.CostCollectTimes = 0 --强行征收的次数
CollectSys.FreeCollectTimes = 0 --免费征收的次数

CollectSys.FreeCollectCD = 0	--免费征收的时间戳


function CollectSys.Init()
--	WebEvent.InitSummonStore(nil , "CollectSys.InitCallBack" , CollectSys.InitCallBack)
end

function CollectSys.InitCallBack(data , returnId)
	local UICollectTar = MainGameUI.FindPanelTarget("UICollect")
		if UICollectTar ~=nil then
			UICollectTar:SetInitData()
		end
end


function CollectSys.FreeCollectMoney()				--免费征收一次获得的金钱
	local moneyCount = CollectSys.BasicMoney + (ClinetInfomation.Lvl -1)*50
	return moneyCount
end

function CollectSys.CostCollectMoney()				--强行征收一次获得的金钱
	local moneyCount = CollectSys.BasicMoney + (ClinetInfomation.Lvl -1)*50
	local value = math.random(0 , 100)
	if value <=10 then
		return moneyCount*2
	else
		return moneyCount
	end
end

function CollectSys.CostCollectDelItem(_Times)	--强行征收消耗的道具数量
	if _Times >=1 and _Times <= 5 then
		return 1
	end
	
	if _Times >=6 and _Times <= 10 then
		return 2
	end

	if _Times >=11 and _Times <= 15 then
		return 3
	end

	if _Times >=16 and _Times <= 20 then
		return 4
	end

	if _Times >=21 and _Times <= 25 then
		return 5
	end
	
	if _Times >=26 and _Times <= 30 then
		return 6
	end

	if _Times >=31 and _Times <= 35 then
		return 7
	end

	if _Times >=36 and _Times <= 40 then
		return 8
	end

	if _Times >=41 and _Times <= 45 then
		return 9
	end
	
	if _Times >=46 and _Times <= 50 then
		return 10
	end
	if _Times>=50 then
		return 10
	end
end

function CollectSys.IsCanFreeCollect()				--是否可以免费征收（处于CD中不可以征收）
--	local today = os.date("*t")
--	local CurTime = os.time({day=today.day, month=today.month,year=today.year, hour=today.hour, minute=today.minute, second=today.second})
	local CurTime = ClinetInfomation.WorldTime
	local endTime = CollectSys.FreeCollectCD
	local m_time = endTime - CurTime
	
	if m_time >= 600 then
		return false
	else
		return true
	end
end

function CollectSys.Collect(_Type)					--征收
	local info = _Type		--1普通，2强制
	WebEvent.Collect(info , "CollectSys.CollectCallBack" , CollectSys.CollectCallBack)
end

function CollectSys.CollectCallBack(data , returnId)
	MusicManagerSys.Collect()
	CollectSys.SetCollectTime()
	local uiHireHeroTar = MainGameUI.FindPanelTarget("UICollect")
		if uiHireHeroTar ~=nil then
			uiHireHeroTar:ShowFreeCDTime()
		end
end

function CollectSys.SetCollectTime()			--设置免费征收的时间
--	local today = os.date("*t")
--	local CurTime = os.time({day=today.day, month=today.month,year=today.year, hour=today.hour, minute=today.minute, second=today.second})
	local CurTime = ClinetInfomation.WorldTime
	local endTime = CollectSys.FreeCollectCD
	
	if  CurTime <= endTime then
		TimeControl.LoginTime(endTime-CurTime, "FreeCollectTime")
	end
	
end

--征收加速
function CollectSys.Speed()
	local info = nil
	WebEvent.CollectSpeed(info , "CollectSys.SpeedCallBack" , CollectSys.SpeedCallBack)
end

function CollectSys.SpeedCallBack(data , returnId)

end

function CollectSys.ComminfoCallBack(data)
	local harvestData = data["harvest"]
	if harvestData ~= nil then
		CollectSys.FreeCollectTimes = harvestData["num_1"]
		
		CollectSys.CostCollectTimes = harvestData["num_2"]
		CollectSys.FreeCollectCD = harvestData["cd_1"]
		CollectSys.SetCollectTime()
	end
end

function CollectSys.ClearData()
	CollectSys.BasicMoney = 1000	--征收的基础值
	CollectSys.CostCollectTimes = 0 --强行征收的次数
	CollectSys.FreeCollectTimes = 0 --免费征收的次数

	CollectSys.FreeCollectCD = 0	--免费征收的时间戳
end


return CollectSys
--endregion
