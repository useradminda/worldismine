--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
OnlineRwdSys = {}
OnlineRwdSys.OnlineBeginTime = 0					--当天登录的时间
OnlineRwdSys.OnlineRwdId = 0						--上次领取的ID


function OnlineRwdSys.ComminfoCallBack(data)
	if data~=nil then
		local onlineBeginTime = tonumber(data["onlineBeginTime"])
		if onlineBeginTime~=nil then
			OnlineRwdSys.OnlineBeginTime = onlineBeginTime
		end
		local onlineRwdId = tonumber(data["onlineRwdId"])
		if onlineRwdId~=nil then
			OnlineRwdSys.OnlineRwdId = onlineRwdId
		end
		OnlineRwdSys.SetDelTime()
	end
end

function OnlineRwdSys.ReceiveOnlineReward()					--领取在线奖励
	local info =nil
	WebEvent.ReceiveOnlineReward(info ,"OnlineRwdSys.ReceiveOnlineRewardCallBack" ,OnlineRwdSys.ReceiveOnlineRewardCallBack)
end

function OnlineRwdSys.ReceiveOnlineRewardCallBack(data , returnId)
	
end

function OnlineRwdSys.GetCurRecItemList()
	local data = nil
	if OnlineRwdSys.OnlineBeginTime == 0 then
		data = OnlineRwdConfig.GetDBDataById(1)
	else
		local lastRecId = OnlineRwdSys.OnlineRwdId +1
		data = OnlineRwdConfig.GetDBDataById(lastRecId)
	end

	if data~=nil then
	
		local rewardData = RewardConfig.GetRewardConfig(tonumber(data.Reward))
			
		local jsonItems = RewardContentSys.GetRewardListString(rewardData.RewardString)
	
		return jsonItems.Items
	end
	
end

function OnlineRwdSys.SetDelTime()
	
	if OnlineRwdSys.OnlineRwdId == 0 then
		local data = OnlineRwdConfig.GetDBDataById(1)
		TimeControl.LoginTime(data.Time*60 , "OnLineTimeDel")
		OnlineRwdSys.ShowMainInfo()
		return 
	end
	local nextRecId = OnlineRwdSys.OnlineRwdId+1
	local data = OnlineRwdConfig.GetDBDataById(nextRecId)
	if data~=nil then
		local curTime = ClinetInfomation.WorldTime
		local delTime = curTime - OnlineRwdSys.OnlineBeginTime
		if delTime == 0 then
			TimeControl.LoginTime(data.Time*60 , "OnLineTimeDel")
			OnlineRwdSys.ShowMainInfo()
			return
		end
		local lastData = OnlineRwdConfig.GetDBDataById(OnlineRwdSys.OnlineRwdId)
		local limitTime = (data.Time + lastData.Time)*60
		if delTime<=limitTime then
			local loginTime = limitTime - delTime
			TimeControl.LoginTime(loginTime , "OnLineTimeDel")
		else
			TimeControl.LoginTime(0 , "OnLineTimeDel")
		end
	else
		TimeControl.SetTime("OnLineTimeDel" , nil)
	end
	OnlineRwdSys.ShowMainInfo()
end

function OnlineRwdSys.ShowMainInfo()
	local uiControlTar = MainGameUI.FindPanelTarget("UIControl")
	if uiControlTar~=nil then
		uiControlTar:ShowOnLineInfo()
	end
end


function OnlineRwdSys.IsCanRecRwd()				--是否可以领取奖励
	local time = TimeControl.GetTime("OnLineTimeDel")
	if time == nil then
		return false
	else
		if time ==0 then
			return true
		else
			return false
		end
	end

end

function OnlineRwdSys.IsOpenSys()				--是否打开系统
	local time = TimeControl.GetTime("OnLineTimeDel")
	if time == nil then
		return false
	else
		return true
	end
end

function OnlineRwdSys.GetRecCountStr()			--得到领取的次数
	local lastRec = OnlineRwdSys.OnlineRwdId
	local allData = OnlineRwdConfig.GetAllDBData()
	return lastRec.."/"..#allData
end

return OnlineRwdSys
--endregion
