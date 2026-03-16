--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
MonthCardSys = {}
MonthCardSys.GoldExpireTime = 0		--黄金月卡的过期时间戳
MonthCardSys.SilverExpireTime = 0	--白银月卡的过期时间戳

MonthCardSys.GoldLastRwdTime = 0	--黄金月卡上次领取的时间戳
MonthCardSys.SilverLastRwdTime = 0	--白银月卡上次领取的时间戳

function MonthCardSys.GetGoldItemList()				--得到黄金月卡的奖励数据
	local data = MonthCardDataConfig.GetDataById(102)
	local rewardData = RewardConfig.GetRewardConfig(tonumber(data.Reward))
			
	local jsonItems = RewardContentSys.GetRewardListString(rewardData.RewardString)
		
	return jsonItems.Items
end

function MonthCardSys.GetSilverItemList()			--得到白银月卡的奖励数据
	local data = MonthCardDataConfig.GetDataById(101)
	local rewardData = RewardConfig.GetRewardConfig(tonumber(data.Reward))
			
	local jsonItems = RewardContentSys.GetRewardListString(rewardData.RewardString)
		
	return jsonItems.Items
end

function MonthCardSys.GetGoldData()					--得到黄金月卡的数据

	return MonthCardDataConfig.GetDataById(102)
end

function MonthCardSys.GetSilverData()
	return MonthCardDataConfig.GetDataById(101)		--得到白银月卡的数据
end

function MonthCardSys.BuyMonthCard(_ID)				--购买月卡
	local info = _ID
	WebEvent.BuyMonthlyCard(info , "MonthCardSys.BuyMonthCardCallBack" , MonthCardSys.BuyMonthCardCallBack)
end

function MonthCardSys.BuyMonthCardCallBack(data , returnId)
	local uIMonthRightTar = MainGameUI.FindPanelTarget("UIMonthRight")
	if uIMonthRightTar~=nil then
		uIMonthRightTar:ShowBuyInfo()
	end
end

function MonthCardSys.ReceiveMonthCard(_ID)			--领取月卡
	local info = _ID
	WebEvent.ReceiveMonthlyCardReward(info , "MonthCardSys.ReceiveMonthCardCallBack",MonthCardSys.ReceiveMonthCardCallBack)
end

function MonthCardSys.ReceiveMonthCardCallBack(data , returnId)
	local uIMonthRightTar = MainGameUI.FindPanelTarget("UIMonthRight")
	if uIMonthRightTar~=nil then
		uIMonthRightTar:ShowBuyInfo()
	end
end

function MonthCardSys.IsHasBuyGod()				--是否已经购买了黄金月卡
	local curTime = ClinetInfomation.WorldTime
	if curTime < MonthCardSys.GoldExpireTime then
		return true
	else
		return false
	end
end

function MonthCardSys.IsHasBuySilver()			--是否已经购买了白银月卡
	local curTime = ClinetInfomation.WorldTime
	if curTime < MonthCardSys.SilverExpireTime then
		return true
	else
		return false
	end
end

function MonthCardSys.IsRwdGod()				--是否已经领取黄金月卡
	local curToday = GameMain.ConvertToInt (ClinetInfomation.WorldTime/86400)
	local lastRwdToday =GameMain.ConvertToInt( MonthCardSys.GoldLastRwdTime/86400)
	if curToday~=lastRwdToday then
		return false
	else
		return true
	end
--	local Math.ceil ((过期时间-当前时间) / 86400 )
end

function MonthCardSys.IsRwdSilver()				--是否已经领取白银月卡
	local curToday = GameMain.ConvertToInt (ClinetInfomation.WorldTime/86400)
	local lastRwdToday =GameMain.ConvertToInt( MonthCardSys.SilverLastRwdTime /86400)
	if curToday~=lastRwdToday then
		return false
	else
		return true
	end
end

function MonthCardSys.GoldElusDays()			--黄金月卡的剩余领取次数	
	
	if MonthCardSys.GoldExpireTime == 0 then
		return 30
	else
		local curTime = GameMain.ConvertToInt(ClinetInfomation.WorldTime/86400)
		local lastRecTime = GameMain.ConvertToInt(MonthCardSys.GoldLastRwdTime/86400)
		local expireTime = GameMain.ConvertToInt(MonthCardSys.GoldExpireTime/86400)
		local days = 0
		if curTime == lastRecTime then
			days = expireTime-curTime - 1
		else
			days = expireTime - curTime
		end
		 
		return days
	end
end

function MonthCardSys.SilverElusDays()			--白银月卡的剩余领取次数	
	if MonthCardSys.SilverExpireTime == 0 then
		return 30
	else
		local curTime = GameMain.ConvertToInt(ClinetInfomation.WorldTime/86400)
		local lastRecTime = GameMain.ConvertToInt(MonthCardSys.SilverLastRwdTime/86400)
		local expireTime = GameMain.ConvertToInt(MonthCardSys.SilverExpireTime /86400)
		local days = 0
		if curTime == lastRecTime then
			days = expireTime-curTime - 1
		else
			days = expireTime - curTime
		end
		 
		return days
	end
end

function MonthCardSys.CommonInfoCallBack(data)	
	MonthCardSys.GoldExpireTime = 0		
	MonthCardSys.SilverExpireTime = 0	
	MonthCardSys.GoldLastRwdTime = 0	
	MonthCardSys.SilverLastRwdTime = 0	
	
	local monthData = data["monthlyCard"]
	if monthData ~= nil then
		local goldData = monthData["102"]
		if goldData~=nil then
			local expire = tonumber(goldData["expire"])
			if expire~=nil then
				MonthCardSys.GoldExpireTime = expire
			end 
			local lastRecv = tonumber(goldData["lastRecv"])
			if lastRecv~=nil then
				MonthCardSys.GoldLastRwdTime = lastRecv
			end
		end
		local silverData = monthData["101"]
		if silverData~= nil then
			local expire = tonumber(silverData["expire"])
			if expire~=nil then
				MonthCardSys.SilverExpireTime = expire
			end 
			local lastRecv = tonumber(silverData["lastRecv"])
			if lastRecv~=nil then
				MonthCardSys.SilverLastRwdTime = lastRecv
			end
		end
	end
end


return MonthCardSys
--endregion
