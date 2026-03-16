--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
SignSys = {}
SignSys.SevenDayTimes = 0 --7日签到的次数
SignSys.SevenDayTimeFrame = 0 --7日签到的时间戳
SignSys.MonthTimes = 0	--每月签到的次数
SignSys.MonthTimeFrame = 0	--每月签到的时间戳
SignSys.TotalCount = 0	--总共签到的次数
SignSys.TotalRecv = 0 --累计签到领取的次数


function SignSys.ComminfoCallBack(data)
	local signData = data["loginRwd"]
    if signData==nil then
       return
    end
	SignSys.SevenDayTimes = tonumber(signData["7d"])
	if SignSys.SevenDayTimes >=7 then
		local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
       if _UIControlTar~=nil then
          _UIControlTar:CloseSevenSign()
       end
	end
	SignSys.SevenDayTimeFrame = tonumber(signData["7dRecvTime"])
	SignSys.MonthTimes = tonumber(signData["monthly"])
	SignSys.MonthTimeFrame = tonumber(signData["monthlyRecvTime"])
	SignSys.TotalCount = tonumber(signData["total"])
	SignSys.TotalRecv = tonumber(signData["totalRecv"])

    local _SevenTip = SignSys.isSignByTimeStamp(SignSys.SevenDayTimeFrame)          --七天提示
    if _SevenTip==false then
       local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
       if _UIControlTar~=nil then
          _UIControlTar:OpenTip(true , "Login")
       end
    end
    local _MonthTip = SignSys.isSignByTimeStamp(SignSys.MonthTimeFrame)             --月签提示
    if _MonthTip==false then
       local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
       if _UIControlTar~=nil then
          _UIControlTar:OpenTip(true , "Sign")
       end
    end

	local isRwd = tonumber(signData["vip"])
	if isRwd~=nil then
		VipSys.IsRwd = isRwd
	end
end

function SignSys.isSignByTimeStamp(timestamp)			--根据时间戳来判断是否已经进行了当天的签到
	local today = os.date("*t")
	local startSignTime = os.time({day=today.day, month=today.month,year=today.year, hour=0, minute=0, second=0})
	local endSignTime = startSignTime +24 *60*60

	if timestamp >= startSignTime and timestamp < endSignTime then
		return true
	else
		return false
	end
end

function SignSys.SevenDayIsSign()						--7日签到今天是否已经签到
	local timeStamps = SignSys.SevenDayTimeFrame
	return SignSys.isSignByTimeStamp(timeStamps)
end

function SignSys.MonthIsSign()							--每日签到今天是否已经签到
	local timeStamps = SignSys.MonthTimeFrame
	return SignSys.isSignByTimeStamp(timeStamps)	
end

function SignSys.SevenDayIsEnd()						--是否已经进行了7日签到
	local time = SignSys.SevenDayTimes 
	if time < 7 then
		--7日签到未结束
		return false
	else
		return true
	end
end

function SignSys.ReceiveSevenDayRwd(_Times)				--领取7天奖励
	local info = _Times
	WebEvent.ReceiveSevenDaySign(info, "SignSys.ReceiveSevenDayRwdCallBack" , SignSys.ReceiveSevenDayRwdCallBack)
end

function SignSys.ReceiveSevenDayRwdCallBack(data , _returnId)

end

function SignSys.ReceiveMonthRwd(_Times)				--领取每日签到奖励
	local info = _Times
	WebEvent.ReceiveMonthSign(info, "SignSys.ReceiveMonthRwdCallBack" , SignSys.ReceiveMonthRwdCallBack)
end

function SignSys.ReceiveMonthRwdCallBack(data , _returnId)

end

function SignSys.ReceiveTotalRwd(_Times)				--领取总签到奖励
	local info = _Times
	WebEvent.ReceiveTotalSign(info, "SignSys.ReceiveTotalRwdCallBack" , SignSys.ReceiveTotalRwdCallBack)
end

function SignSys.ReceiveTotalRwdCallBack(data , _returnId)

end

function SignSys.GetEverySignData()
	local list = SignDataConfig.GetAllData()
	return list
end

return SignSys
--endregion
