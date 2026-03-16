--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
UIEveryDaySign = {}
UIEveryDaySign = BasePanel:new()
local this = UIEveryDaySign
--UI相关
UIEveryDaySign.UIEveryDaySignGod = nil
UIEveryDaySign.Controls = {}

UIEveryDaySign.EveryDayGodList = {}
UIEveryDaySign.TotalSignGodList = {}		--总共签到

--Data 相关
UIEveryDaySign.TotalSignDataList = {}
UIEveryDaySign.EveryDataList = {}			--每日签到的数据

function UIEveryDaySign:OpenUI(_PanelName , _LuaName)
	if UIEveryDaySign.UIEveryDaySignGod == nil then
		UIEveryDaySign.UIEveryDaySignGod = MainGameUI.FindPanel("UIEveryDaySign")
		this:GetControls()
		this:SetDataList()
		this:ShowEveryDayInfo()
	end
	this:ShowInitInfo()
    local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
    if _UIControlTar~=nil then
       _UIControlTar:OpenTip(false , "Sign")
    end
end


function UIEveryDaySign:GetControls()
	UIEveryDaySign.Controls.SignDes = UIEveryDaySign.UIEveryDaySignGod.transform:FindChild("HasSigned"):GetComponent("UILabel")
	UIEveryDaySign.Controls.EveryDaySignPanel = UIEveryDaySign.UIEveryDaySignGod.transform:FindChild("EveryDaySign/EveryDaySignPanel"):GetComponent("UIPanel")
	UIEveryDaySign.Controls.EveryDaySignGrid = UIEveryDaySign.Controls.EveryDaySignPanel.transform:FindChild("EveryDaySignGrid"):GetComponent("UIGrid")

	UIEveryDaySign.Controls.AlwaysSignWrap = UIEveryDaySign.UIEveryDaySignGod.transform:FindChild("AlwaysSign"):GetComponent("UIWrap")
	UIEveryDaySign.Controls.AlwaysSignPanel = UIEveryDaySign.Controls.AlwaysSignWrap.transform:FindChild("AlwaysSignPanel"):GetComponent("UIPanel")
	UIEveryDaySign.Controls.AlwaysSignGrid = UIEveryDaySign.Controls.AlwaysSignPanel.transform:FindChild("AlwaysSignGrid"):GetComponent("UIGrid")
	
	for i=1,30,1  do
		UIEveryDaySign.EveryDayGodList[i] = UIEveryDaySign.Controls.EveryDaySignGrid.transform:FindChild(tostring(i))
	end
end

function UIEveryDaySign:SetDataList()
	local list =  SignTotalDataConfig.GetAll()
	for i=1,#list,1 do
		UIEveryDaySign.TotalSignDataList[i] = list[i]
	end
	local everyList = SignSys.GetEverySignData()
	for i=1,#everyList,1 do
		local rewardData = RewardConfig.GetRewardConfig(tonumber(everyList[i].Reward))
			
		local jsonItems = RewardContentSys.GetRewardListString(rewardData.RewardString)
		
		UIEveryDaySign.EveryDataList[i] = jsonItems.Items[1]
	end
	
end

function UIEveryDaySign:ShowEveryDayInfo()	--显示每天的奖励
	for i=1,#UIEveryDaySign.EveryDataList,1 do
		local Img = UIEveryDaySign.EveryDayGodList[i].transform:FindChild("icon"):GetComponent("UISprite")
		local Quality = UIEveryDaySign.EveryDayGodList[i].transform:FindChild("quality"):GetComponent("UISprite")
		local count = UIEveryDaySign.EveryDayGodList[i].transform:FindChild("Label"):GetComponent("UILabel")
		local FG = UIEveryDaySign.EveryDayGodList[i].transform:FindChild("FG"):GetComponent("UISprite")
		
		FG.spriteName = UIstring.ItemFg[UIEveryDaySign.EveryDataList[i].Quality]
		Quality.spriteName = UIstring.ItemFg[UIEveryDaySign.EveryDataList[i].Quality]
		AtlasMsg.SetAtlas(Img , UIEveryDaySign.EveryDataList[i].AtlasName , UIEveryDaySign.EveryDataList[i].SpriteName)
		count.text = tostring(UIEveryDaySign.EveryDataList[i].Count)
	end
end

function UIEveryDaySign:ShowInitInfo()
	UIEveryDaySign.Controls.SignDes.text = UIstring.GrayColor..UIstring.SignHasSigned.."[-]" .. UIstring.Red.. tostring(SignSys.TotalCount).."[-]" .. UIstring.GrayColor..UIstring.SignTimes.."[-]"
	this:ShowTotalList()

	local monthTimes = SignSys.TotalCount
	for i=1,30,1 do
		this:ShowMonthItemInfo(i , monthTimes)
	end
	
end

function UIEveryDaySign:ShowTotalList()
	UIEveryDaySign.Controls.AlwaysSignPanel.transform.localPosition = Vector3(0 ,0 ,0)
	UIEveryDaySign.Controls.AlwaysSignPanel.clipOffset = Vector2(0,0)
	UIEveryDaySign.Controls.AlwaysSignWrap:ResetTrans(#UIEveryDaySign.TotalSignDataList)
	if #UIEveryDaySign.TotalSignGodList == 0 then
		for i=1,6,1  do
			local data =
			{
				Index = i,
			}
			MainGameUI.CreateLittleItem(tostring(i) , "AlwaysSignItem" , UIEveryDaySign.Controls.AlwaysSignGrid , data , this.CreateTotalListCallBack , "UIEveryDaySign") 
		end
	else
		for i=1,6,1 do
			local data =
			{
				Index = i,
			}
			if UIEveryDaySign.TotalSignGodList[i] ~= nil then
				this:CreateTotalListCallBack(UIEveryDaySign.TotalSignGodList[i] , data)
			else
				MainGameUI.CreateLittleItem(tostring(i) , "AlwaysSignItem" , UIEveryDaySign.Controls.AlwaysSignGrid , data , this.CreateTotalListCallBack , "UIEveryDaySign") 
			end
		end
		
		
	end
end

function UIEveryDaySign:CreateTotalListCallBack(_Gob , _Info)
	if _Info.Index == 6 then
		UIEveryDaySign.Controls.AlwaysSignGrid.enabled = true
		UIEveryDaySign.Controls.AlwaysSignGrid:Reposition()
		UIEveryDaySign.Controls.AlwaysSignWrap:SetData(#UIEveryDaySign.TotalSignDataList , "UIEveryDaySign")
	end

	local id =_Info.Index
	UIEveryDaySign.TotalSignGodList[id] = _Gob
	
	local data = UIEveryDaySign.TotalSignDataList[id]
	this:ShowTotalSignItemInfo(data , _Gob)
end

function UIEveryDaySign:UpdateItem(_LuaName , _Item)
	local data = UIEveryDaySign.TotalSignDataList[tonumber(_Item.name)]
	this:ShowTotalSignItemInfo(data , _Item)
end

function UIEveryDaySign:ShowTotalSignItemInfo(_Data , _God)
	if _Data == nil then
		GameMain.CloseObj(_God)
		return
	end
	
	GameMain.OpenObj(_God)
	local hasRecvTimes = SignSys.TotalRecv
	local count = tonumber(_God.name)
	local des = _God.transform:FindChild("des"):GetComponent("UILabel")
	local canRwdBtn = _God.transform:FindChild("AlwaysRwdBtn")
	local tips = _God.transform:FindChild("Label"):GetComponent("UILabel")
	local icon = _God.transform:FindChild("icon"):GetComponent("UISprite")
	local FG = _God.transform:FindChild("FG"):GetComponent("UISprite")
	local quality = _God.transform:FindChild("Quality"):GetComponent("UISprite")

	local rewardData = RewardConfig.GetRewardConfig(tonumber(_Data.Reward))
	local jsonItems = RewardContentSys.GetRewardListString(rewardData.RewardString)
	local showReward = jsonItems.Items[1]
	AtlasMsg.SetAtlas(icon , showReward.AtlasName , showReward.SpriteName)
	FG.spriteName = UIstring.ItemFg[showReward.Quality]
	quality.spriteName = UIstring.ItemFg[showReward.Quality]
	tips.text = _Data.Tips
	if count<=hasRecvTimes then
		des.text = UIstring.SignHasRecived
	else
		local TotalTimes = SignSys.TotalCount
		local data = SignTotalDataConfig.GetSignTotalDBConfig(hasRecvTimes+1)
		if TotalTimes >= data.NeedTimes then
			GameMain.OpenObj(canRwdBtn)
			GameMain.CloseObj(des)
		else
			GameMain.CloseObj(canRwdBtn)
			GameMain.OpenObj(des)
			des.text = tostring(_Data.Description)
		end
		
	end
end

function UIEveryDaySign:ShowMonthItemInfo(Index , signTimes)
	local item = UIEveryDaySign.EveryDayGodList[Index]
	if Index <= signTimes then
		--显示已经签到
		GameMain.OpenObj(item.transform:FindChild("mask"))
		GameMain.CloseObj(item.transform:FindChild("clickSign"))
		GameMain.OpenObj(item.transform:FindChild("signed"))
	else
		if Index == signTimes+1 then
			local isCanSign = SignSys.MonthIsSign()
			if isCanSign == false then
				--没有签到
				GameMain.OpenObj(item.transform:FindChild("clickSign"))
				GameMain.CloseObj(item.transform:FindChild("mask"))
				GameMain.CloseObj(item.transform:FindChild("signed"))
			else
				--不能签到了
				GameMain.CloseObj(item.transform:FindChild("mask"))
				GameMain.CloseObj(item.transform:FindChild("clickSign"))
				GameMain.CloseObj(item.transform:FindChild("signed"))
			end
		else
			GameMain.CloseObj(item.transform:FindChild("mask"))
			GameMain.CloseObj(item.transform:FindChild("clickSign"))
			GameMain.CloseObj(item.transform:FindChild("signed"))
		end
		
	end
end


function UIEveryDaySign:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
	if _Gob.name == "CloseBtn" then
		GameMain.CloseObj(UIEveryDaySign.UIEveryDaySignGod)
	end

	if _Gob.name == "AlwaysRwdBtn" then
		local index = tonumber(_Gob.transform.parent.name)
		this:ShowSendTotalInfo(index)
	end

	local key = tonumber(_Gob.name)
	if key~=nil then
		local parentName = _Gob.transform.parent.name
		if parentName == "EveryDaySignGrid" then
			this:ShowSendMonthInfo(key)
		end
	end
end

function UIEveryDaySign:ShowSendMonthInfo(Index)
	
	
	local isCanSign = SignSys.MonthIsSign()
	if isCanSign == true then
		DataUIInstance.PopTip("本日已签到，请明日再来！")
		return
	end

	local times = SignSys.TotalCount +1
	if Index ~= times then
		return
	end

	SignSys.ReceiveMonthRwd(times)
	DataUIInstance.PopTip("签到成功")
	local item = UIEveryDaySign.EveryDayGodList[Index]
	
	GameMain.OpenObj(item.transform:FindChild("mask"))
	GameMain.CloseObj(item.transform:FindChild("clickSign"))
	GameMain.OpenObj(item.transform:FindChild("signed"))
	UIEveryDaySign.Controls.SignDes.text = UIstring.GrayColor..UIstring.SignHasSigned.."[-]" .. UIstring.Red.. tostring(times).."[-]" .. UIstring.GrayColor..UIstring.SignTimes.."[-]"

	local list = 
	{
		[1] = UIEveryDaySign.EveryDataList[Index]
	}
	this:ShowRewardsTip(list)
end

function UIEveryDaySign:ShowSendTotalInfo(Index)
	local Recvtimes = SignSys.TotalRecv
	if Index ~= Recvtimes+1 then
		return
	end

	local TotalTimes = SignSys.TotalCount
	local data = SignTotalDataConfig.GetSignTotalDBConfig(Index)
	if data.NeedTimes >TotalTimes then
		return
	end
	
	SignSys.ReceiveTotalRwd(Index)
	local btn =  UIEveryDaySign.TotalSignGodList[Index].transform:FindChild("AlwaysRwdBtn")
	local txt = UIEveryDaySign.TotalSignGodList[Index].transform:FindChild("des"):GetComponent("UILabel")
	txt.text = UIstring.SignHasRecived
	GameMain.CloseObj(btn)
--	local list = 
--	{
--		[1] = UIEveryDaySign.TotalSignDataList[Index]
--	}
--	this:ShowRewardsTip(list)
end

function UIEveryDaySign:ShowRewardsTip(_List)
	DataUIInstance.OpenRewards(_List)
end

function UIEveryDaySign:ReleasPanel()
	--UI相关
	UIEveryDaySign.UIEveryDaySignGod = nil
	UIEveryDaySign.Controls = {}

	UIEveryDaySign.EveryDayGodList = {}
	UIEveryDaySign.TotalSignGodList = {}		--总共签到

	--Data 相关
	UIEveryDaySign.TotalSignDataList = {}
end

function UIEveryDaySign:ReleasData()
	SignSys.SevenDayTimes = 0 --7日签到的次数
	SignSys.SevenDayTimeFrame = 0 --7日签到的时间戳
	SignSys.MonthTimes = 0	--每月签到的次数
	SignSys.MonthTimeFrame = 0	--每月签到的时间戳
	SignSys.TotalCount = 0	--总共签到的次数
	SignSys.TotalRecv = 0 --累计签到领取的次数
end

return UIEveryDaySign

--endregion
