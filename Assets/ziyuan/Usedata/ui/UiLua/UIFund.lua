--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
UIFund = {}
UIFund = BasePanel:new()
local this = UIFund
--UI相关
UIFund.UIFundGod = nil
UIFund.Controls = {}
UIFund.GodList = {}
--Data相关
UIFund.DataList = {}
UIFund.PrincipalIndex = 0			--收回成本的那个点

UIFund.ReturnRateIndex = 0			--返回的那个点

function UIFund:OpenUI(_PanelName , _LuaName)
	if UIFund.UIFundGod == nil then
		UIFund.UIFundGod = MainGameUI.FindPanel("UIFund")
		this:GetControls()
		this:SetInitData()
		FundDataSys.InitWeb()
	else
		this:ShowInfo()
	end
end

function UIFund:GetControls()
	local info = UIFund.UIFundGod.transform:FindChild("Info")
	UIFund.Controls.TotalGet = info.transform:FindChild("TotalGet"):GetComponent("UILabel")
	UIFund.Controls.UpRate = info.transform:FindChild("UpRate"):GetComponent("UILabel")

	local pourInfo = UIFund.UIFundGod.transform:FindChild("PourInfo")
	UIFund.Controls.PourMoney = pourInfo.transform:FindChild("PourMoney"):GetComponent("UILabel")
	UIFund.Controls.ListPanel = pourInfo.transform:FindChild("List/ListPanel"):GetComponent("UIPanel") 
	UIFund.Controls.Grid = UIFund.Controls.ListPanel.transform:FindChild("Grid"):GetComponent("UIGrid")
	UIFund.Controls.PourMoneyBtn = pourInfo.transform:FindChild("PourMoneyBtn")
	UIFund.Controls.HasPour = pourInfo.transform:FindChild("HasPour")
	
	UIFund.Controls.Info = info.transform:FindChild("Sprite")

	if GameMain.IOSTest == true then
		GameMain.CloseObj(UIFund.Controls.Info)
	else
		GameMain.OpenObj(UIFund.Controls.Info)
	end
end

function UIFund:SetInitData()
	UIFund.Controls.TotalGet.text = tostring(FundDataSys.GetRewardDiamonds())
	local num = FundDataSys.GetPourPricipal()
	UIFund.Controls.PourMoney.text = tostring(num)
	local rewardRate = GameMain.ConvertToInt( FundDataSys.GetRewardRate() *100)
	UIFund.Controls.UpRate.text = tostring(rewardRate) .. "%"

	local index = FundDataSys.GetPrincipalIndex()
	if index ==nil then
		UIFund.PrincipalIndex = 0
	else
		UIFund.PrincipalIndex = index
	end

	local returnIndex = FundDataSys.GetReturnRateIndex()
	if returnIndex ==nil then
		UIFund.ReturnRateIndex = 0
	else
		UIFund.ReturnRateIndex = returnIndex
	end
end

function UIFund:ShowInfo()
	if FundDataSys.IsPourMoney ~= 0 then
		GameMain.CloseObj(UIFund.Controls.PourMoneyBtn)
		GameMain.OpenObj(UIFund.Controls.HasPour)
	else
		GameMain.OpenObj(UIFund.Controls.PourMoneyBtn)
		GameMain.CloseObj(UIFund.Controls.HasPour)
	end
	local list = FundDataSys.GetFundList()
	for i=1,#list,1 do
		UIFund.DataList[i] = list[i]
	end
	UIFund.Controls.ListPanel.transform.localPosition = Vector3(0 , 0 , 0)
	UIFund.Controls.ListPanel.clipOffset = Vector2(0 , 0)
	UIFund.UIFundGod.transform:FindChild("PourInfo/List"):GetComponent("UIWrap"):ResetTrans(#UIFund.DataList)
	this:ShowList()
end

function UIFund:ShowList()
	if #UIFund.GodList == 0 then
		for i=1,8,1 do
			local data =
			{
				Index = i,
			}
			MainGameUI.CreateLittleItem(tostring(i) , "FundItem" , UIFund.Controls.Grid , data , this.CreateListCallBack , "UIFund") 
		end
	else
		for i=1,8,1 do
			local data = 
			{
				Index = i,
			}
			if UIFund.GodList[i] == nil then
				MainGameUI.CreateLittleItem(tostring(i) , "FundItem" , UIFund.Controls.Grid , data , this.CreateListCallBack , "UIFund") 
			else
				this:CreateListCallBack(UIFund.GodList[i] , data)
			end
		end
	end
	
end

function UIFund:CreateListCallBack(_Gob , _Info)	--创建列表并做信息显示
	if _Info.Index==8  then
		UIFund.Controls.Grid.enabled = true
		UIFund.Controls.Grid:Reposition()
		UIFund.UIFundGod.transform:FindChild("PourInfo/List"):GetComponent("UIWrap"):SetData(#UIFund.DataList , "UIFund")
	end
	
	local index = _Info.Index
	this:ShowItemInfo(_Gob , index)
end


function UIFund:UpdateItem(_LuaName , _Item)
	
	local index = tonumber(_Item.name)
	
	this:ShowItemInfo(_Item , index)
end

function UIFund:ShowItemInfo(_Gob , _Index)
	local data = UIFund.DataList[_Index]
	UIFund.GodList[_Index] = _Gob
	if data == nil then
		GameMain.CloseObj(_Gob)
		return
	end
	GameMain.OpenObj(_Gob)
	local info = _Gob.transform:FindChild("Info"):GetComponent("UILabel")
	local des = _Gob.transform:FindChild("des"):GetComponent("UILabel")
	local money = _Gob.transform:FindChild("count"):GetComponent("UILabel")
	local hasRwd = _Gob.transform:FindChild("HasRwd")
	local btn = _Gob.transform:FindChild("ReciverBtn")
	GameMain.CloseObj(info)
	if UIFund.PrincipalIndex == _Index then
		GameMain.OpenObj(info)
		info.text = UIstring.Purple .. UIstring.FundHasRwd .. "[-]"
	end
	if UIFund.ReturnRateIndex == _Index then
		GameMain.OpenObj(info)
		local rewardNum = GameMain.ConvertToInt(FundDataSys.GetRewardRate() * 100)
		info.text = UIstring.Yellow.. UIstring.FundReturn .. "[-]" .. UIstring.Green..rewardNum.."%".."[-]"
	end

	if data.IsRwd == true then
		GameMain.CloseObj(btn)
		GameMain.OpenObj(hasRwd)
	else
		GameMain.CloseObj(hasRwd)
		GameMain.OpenObj(btn)
	end
	if data.Lvl == 0 then
		des.text = UIstring.FundTodayRec
	else
		des.text = tostring(data.Lvl) .. UIstring.FundCanRecived
	end
	money.text = tostring(data.Restore)
end

function UIFund:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
	if _Gob.name == "CloseBtn" then
		GameMain.CloseObj(UIFund.UIFundGod)
	end
	if _Gob.name == "ReciverBtn" then
		local parentName = tonumber(_Gob.transform.parent.name)
		this:SendWebToRwd(parentName)
	end
	if _Gob.name == "PourMoneyBtn" then
		this:ShowWebPour()
	end	
end

function UIFund:ShowWebPour()						--投资
	if VipSys.VipLevel <4 then
		DataUIInstance.PopTip("Vip4开启")
		return
	end
	local num = ConstConfig.GetSetNameNeedMoney()
	if ClinetInfomation.Diamond <num then
		DataUIInstance.PopTip("元宝不足")
		return
	end
	FundDataSys.FundPour()						
end

function UIFund:ShowPourAfter(_IsSuccess)			--投资后的显示
	if _IsSuccess == 1 then
--		if GameMain.IOSTest == true then
--			GameMain.OpenObj(UIFund.Controls.PourMoneyBtn)
--			GameMain.CloseObj(UIFund.Controls.HasPour)
--		else
			GameMain.CloseObj(UIFund.Controls.PourMoneyBtn)
			GameMain.OpenObj(UIFund.Controls.HasPour)
		
		DataUIInstance.PopTip("投资成功")
	end
	if _IsSuccess == 2 then	
		DataUIInstance.PopTip("元宝不足")
	end
	
end
function UIFund:SendWebToRwd(_Index)				--领取基金
	if FundDataSys.IsPourMoney ==0 then
		DataUIInstance.PopTip(UIstring.FundNeedPour)
		return
	end
	local data = UIFund.DataList[_Index]
	if ClinetInfomation.Lvl < data.Lvl then
		DataUIInstance.PopTip(UIstring.FundNoLvl)
		return 
	end

	FundDataSys.ReciveRwd(data.Lvl)
	data:SetIsRwd(true)
	
	local btn = UIFund.GodList[_Index].transform:FindChild("ReciverBtn")
	local hasRwd = UIFund.GodList[_Index].transform:FindChild("HasRwd")
	GameMain.CloseObj(btn)
	GameMain.OpenObj(hasRwd)

	local _Reward = ItemDataSys.GetResourceData(1 , data.Restore)
	local rewardData = {}
	rewardData = _Reward.Item
	rewardData.Count = data.Restore
	local list =
	{
		[1] = rewardData
	}
	DataUIInstance.OpenRewards(list)
end

function UIFund:ReleasPanel()
	--UI相关
	UIFund.UIFundGod = nil
	UIFund.Controls = {}
	UIFund.GodList = {}
	--Data相关
	UIFund.DataList = {}
	UIFund.PrincipalIndex = 0			--收回成本的那个点
	
	UIFund.ReturnRateIndex = 0			--返回的那个点
end

function UIFund:ReleasData()
	FundDataSys.FundDataList = {}

	FundDataSys.IsPourMoney = 0 --是否投资
	FundDataSys.RwdRecived = {} --已经领取的投资

	FundDataSys.Principal = 0			--注入的成本
	FundDataSys.ReturnRate = 0			--返回的概率
	FundDataSys.AllRewards = 0			--所有返还的元宝

	FundDataSys.PrincipalIndex = 0		--返回成本的index
	FundDataSys.RateIndex = 0			--返回利率的index

end

return UIFund
--endregion
