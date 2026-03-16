--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
UISevenDaySign = {}
UISevenDaySign = BasePanel:new()
local this = UISevenDaySign
--UI相关
UISevenDaySign.UISevenDaySignGod = nil
UISevenDaySign.SignListControls = {}

--Data
UISevenDaySign.DataList = {}

function UISevenDaySign:OpenUI(_PanelName , _LuaName)
	if UISevenDaySign.UISevenDaySignGod == nil then
		UISevenDaySign.UISevenDaySignGod = MainGameUI.FindPanel("UISevenDaySign")
		this:GetControls()
		this:ShowSevenDayInfo()
	end
    local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
    if _UIControlTar~=nil then
       _UIControlTar:OpenTip(false , "Login")
    end
	this:ShowInitInfo()
end

function UISevenDaySign:ShowSevenDayInfo()			--显示签到的信息
	local list = SignSevenDataConfig.GetAllData()
	for i=1,#list,1 do
		UISevenDaySign.DataList[i] = list[i]
		local rewardData = RewardConfig.GetRewardConfig(tonumber(list[i].Reward))
			
		local jsonItems = RewardContentSys.GetRewardResourceString(rewardData.RewardString)
		local data = jsonItems.Items
		local God = UISevenDaySign.SignListControls[i]
		for j=1,#data,1 do
			local img = God.transform:FindChild(tostring(j)).transform:FindChild("Img"):GetComponent("UISprite")
			local count = God.transform:FindChild(tostring(j)).transform:FindChild("count"):GetComponent("UILabel")
			local quality = God.transform:FindChild(tostring(j)).transform:FindChild("BG"):GetComponent("UISprite")
			local fg = God.transform:FindChild(tostring(j)).transform:FindChild("FG"):GetComponent("UISprite")
			local qualityValue = data[j].Quality
			if qualityValue == nil then
				qualityValue = 1
			end
			quality.spriteName = UIstring.ItemFg[qualityValue]
			fg.spriteName = UIstring.ItemFg[qualityValue]
			AtlasMsg.SetAtlas(img , data[j].AtlasName , data[j].SpriteName)
			count.text = tostring(data[j].Count)
		end
	end
	
end

function UISevenDaySign:ShowInitInfo()
	local times = SignSys.SevenDayTimes
	local isSign = SignSys.SevenDayIsSign()	
	for i=1,7 ,1 do
		this:ShowItemInfo(i , times ,isSign)
	end
end

function UISevenDaySign:ShowItemInfo(Index , signTimes , isSign)
	local item = UISevenDaySign.SignListControls[Index]
	local hasNotRec = item.transform:FindChild("hasnotRec")
	if Index <= signTimes then
		--显示已经签到
		GameMain.CloseObj(item.transform:FindChild("ReciverBtn"))
		GameMain.OpenObj(item.transform:FindChild("Sprite"))
		GameMain.CloseObj(hasNotRec)
	else
		GameMain.CloseObj(item.transform:FindChild("Sprite"))
		if Index == signTimes + 1 and isSign == false then
			GameMain.OpenObj(item.transform:FindChild("ReciverBtn"))
			GameMain.CloseObj(hasNotRec)
		else
			GameMain.CloseObj(item.transform:FindChild("ReciverBtn"))
			GameMain.OpenObj(hasNotRec)
		end
	end
end

function UISevenDaySign:GetControls()
	local list = UISevenDaySign.UISevenDaySignGod.transform:FindChild("list/Grid")
	for i=1,7,1 do
		UISevenDaySign.SignListControls[i] = list.transform:FindChild(tostring(i))
	end
end

function UISevenDaySign:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
	if _Gob.name == "CloseBtn" then
		GameMain.CloseObj(UISevenDaySign.UISevenDaySignGod)
	end

	if _Gob.name == "ReciverBtn" then
		local key = tonumber(_Gob.transform.parent.name)
		this:SendWebSign(key)
	end
	if _Gob.name == "hasnotRec" then
		this:ShowTips()
	end
end

function UISevenDaySign:ShowTips()
	local isEnd = SignSys.SevenDayIsEnd()
	if isEnd == true then
		return
	end

	local isCanSign = SignSys.SevenDayIsSign()
	if isCanSign == true then
		DataUIInstance.PopTip("请隔日领取")
		return
	end
	
end

function UISevenDaySign:SendWebSign(Index)
	local times = SignSys.SevenDayTimes +1
	if Index ~= times then
		return
	end

	local isEnd = SignSys.SevenDayIsEnd()
	if isEnd == true then
		return
	end

	local isCanSign = SignSys.SevenDayIsSign()
	if isCanSign == true then
		return
	end

	SignSys.ReceiveSevenDayRwd(times)
	
	this:ShowRewards(times)
	GameMain.CloseObj(UISevenDaySign.SignListControls[Index].transform:FindChild("ReciverBtn"))
	GameMain.OpenObj(UISevenDaySign.SignListControls[Index].transform:FindChild("Sprite"))
end

function UISevenDaySign:ShowRewards(_Index)
	local data  = UISevenDaySign.DataList[_Index]
	local rewardData = RewardConfig.GetRewardConfig(tonumber(data.Reward))
			
	local jsonItems = RewardContentSys.GetRewardResourceString(rewardData.RewardString)
	
	local list = jsonItems.Items
	DataUIInstance.OpenRewards(list)
end

function UISevenDaySign:ReleasPanel()
	--UI相关
	UISevenDaySign.UISevenDaySignGod = nil
	UISevenDaySign.SignListControls = {}
	--Data
	UISevenDaySign.DataList = {}
end

function UISevenDaySign:ReleasData()
	SignSys.SevenDayTimes = 0 --7日签到的次数
	SignSys.SevenDayTimeFrame = 0 --7日签到的时间戳
	SignSys.MonthTimes = 0	--每月签到的次数
	SignSys.MonthTimeFrame = 0	--每月签到的时间戳
	SignSys.TotalCount = 0	--总共签到的次数
	SignSys.TotalRecv = 0 --累计签到领取的次数

end

return UISevenDaySign
--endregion
