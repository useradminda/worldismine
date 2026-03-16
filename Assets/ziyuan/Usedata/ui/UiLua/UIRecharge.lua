--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

UIRecharge = {}
UIRecharge = BasePanel:new()
local this = UIRecharge
--UI相关
UIRecharge.UIRechargeGod = nil
UIRecharge.UIRechargeGodList = {}	
UIRecharge.Controls = {}
--Data相关
UIRecharge.RechargeDataList = {}	--充值的元宝list数据
UIRecharge.RechargeOtherDataList = {}	--其他的list数据
UIRecharge.CurMyDiamoned = 0		--当前的钻石
UIRecharge.CurGoldTicket = 0		--当前的金券
UIRecharge.ClickTag = 0				--当前点击的Tag 1 元宝 2 other
UIRecharge.BuyClickIndex = 0		--点击购买的index 

function UIRecharge:OpenUI(_PanelName , _LuaName)
	if UIRecharge.UIRechargeGod == nil then
		UIRecharge.UIRechargeGod = MainGameUI.FindPanel("UIRecharge")
		this:GetControls()
		UIRecharge.ClickTag = 1
		this:ShowInitInfo()
	else
		UIRecharge.ClickTag = 1
		this:ShowTagClickInfo(1)
		this:ShowPanelInfo()
	end
end

function UIRecharge:GetControls()
	UIRecharge.Controls.UIWrap = UIRecharge.UIRechargeGod.transform:FindChild("RechargePanel/RechargeListPanel"):GetComponent("UIWrap")
	UIRecharge.Controls.Grid = UIRecharge.Controls.UIWrap.transform:FindChild("Grid"):GetComponent("UIGrid")
	UIRecharge.Controls.UIPanel = UIRecharge.Controls.UIWrap:GetComponent("UIPanel")
	UIRecharge.Controls.MyOwn = UIRecharge.UIRechargeGod.transform:FindChild("gold/goldCount"):GetComponent("UILabel")
	UIRecharge.Controls.OtherTagClick = UIRecharge.UIRechargeGod.transform:FindChild("OtherTagBtn/click")
	UIRecharge.Controls.GoldTagClick = UIRecharge.UIRechargeGod.transform:FindChild("GoldTagBtn/click")
	UIRecharge.Controls.OtherTagNoClick = UIRecharge.UIRechargeGod.transform:FindChild("OtherTagBtn/noclick")
	UIRecharge.Controls.GoldTagNoClick = UIRecharge.UIRechargeGod.transform:FindChild("GoldTagBtn/noclick")
	
end

function UIRecharge:ShowInitInfo()			--初始化信息请求数据后显示
	this:ShowTagClickInfo(1)
	this:SetInitData()
	this:ShowPanelInfo()
end

function UIRecharge:SetInitData()
	local list = RechargeSys.GetList()
	for i=1,#list,1 do
		if list[i].Type == 1 then
			table.insert(UIRecharge.RechargeDataList , #UIRecharge.RechargeDataList+1 , list[i])
		else
			table.insert(UIRecharge.RechargeOtherDataList , #UIRecharge.RechargeOtherDataList +1 , list[i])
		end
	end
end

function UIRecharge:ShowMyOwnGold()
	UIRecharge.Controls.MyOwn.text = tostring(ClinetInfomation.GetDiamond())
end
function UIRecharge:ShowPanelInfo()
	this:ShowMyOwnGold()
	this:ClearGodList()
	UIRecharge.Controls.UIPanel.transform.localPosition = Vector3(0 ,0 , 0)
	UIRecharge.Controls.clipOffset = Vector2(0,0)
	local len = 0
	if UIRecharge.ClickTag == 1 then
		len = #UIRecharge.RechargeDataList
	else
		len = #UIRecharge.RechargeOtherDataList
	end
	UIRecharge.Controls.UIWrap:ResetTrans(len)
	for i=1,16,1  do
		local data =
		{
			Index = i,
			Len = len,
		}
		if UIRecharge.UIRechargeGodList[i] == nil then
			MainGameUI.CreateLittleItem(tostring(i) , "RechargeItem" , UIRecharge.Controls.Grid , data , this.CreateListCallBack , "UIRecharge") 
		else		
			this:CreateListCallBack(UIRecharge.UIRechargeGodList[i] , data)
		end
	end
end

function UIRecharge:ClearGodList()
	if #UIRecharge.UIRechargeGodList ~= 0 then
		for i=1,#(UIRecharge.UIRechargeGodList),1 do
			GameMain.CloseObj(UIRecharge.UIRechargeGodList[i])
		end
	end
end

function UIRecharge:CreateListCallBack(_Gob , _Info)
	if _Info.Index == 16 then
		UIRecharge.Controls.Grid.enabled = true
		UIRecharge.Controls.Grid:Reposition()
		UIRecharge.Controls.UIWrap:SetData(_Info.Len , "UIRecharge")
	end
	
	local index = _Info.Index
	UIRecharge.UIRechargeGodList[index] = _Gob
	this:ShowItemInfo(_Gob , index)
end

function UIRecharge:UpdateItem(_LuaName , _Item) 
	local index = tonumber(_Item.name)
	UIRecharge.UIRechargeGodList[index] = _Item
	this:ShowItemInfo(_Item , index)
end

function UIRecharge:ShowItemInfo(_Gob , _Index)
	local data = nil
	if UIRecharge.ClickTag == 1 then
		data = UIRecharge.RechargeDataList[_Index]
	else
		data = UIRecharge.RechargeOtherDataList[_Index]
	end
	if data ==nil then
		GameMain.CloseObj(_Gob)
		return
	end
	GameMain.OpenObj(_Gob)
	
	local des = _Gob.transform:FindChild("Descrip")
	local price = des.transform:FindChild("RechargeC"):GetComponent("UILabel")
	local rwd = des.transform:FindChild("MoneyC"):GetComponent("UILabel")
	local img = _Gob.transform:FindChild("Icon"):GetComponent("UISprite")
	local quan = des.transform:FindChild("QuanImg")
	local gold = des.transform:FindChild("MoneyImg")
	local isDouble = _Gob.transform:FindChild("IsDouble")

	AtlasMsg.SetAtlas(img , data.AtlasName , data.SpriteName)
	if data.Type == 2 then
		GameMain.CloseObj(gold)
		GameMain.OpenObj(quan)
	end
	if data.Type == 1 then
		GameMain.CloseObj(quan)
		GameMain.OpenObj(gold)
	end
	price.text = "￥" .. tostring(data.Price)
	if data.Count == 0 then
		if data.FirstRechargeBonus == 0 then
			rwd.text = tostring(data.Diamond)
			GameMain.CloseObj(isDouble)
		else
			rwd.text = tostring(data.Diamond)-- .. "+" .. tostring(data.FirstRechargeBonus)
			GameMain.OpenObj(isDouble)
		end
	else
		if data.OtherRechargeBonus == 0 then
			rwd.text = tostring(data.Diamond)
			GameMain.CloseObj(isDouble)
		else
			rwd.text = tostring(data.Diamond)-- .. "+" .. tostring(data.OtherRechargeBonus)
			GameMain.OpenObj(isDouble)
		end
	end

end

function UIRecharge:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
	if _Gob.name == "CloseBtn" then
		this:ClosePanel()
	end
	if _Gob.name == "BuyButton" then
		local index = tonumber(_Gob.transform.parent.name)
		this:BuyDiamond(index)
	end

	if _Gob.name == "GoldTagBtn" then
		this:ShowTagClickInfo(1)
		this:ShowPanelInfo()
	end
	if _Gob.name == "OtherTagBtn" then
		this:ShowTagClickInfo(2)
		this:ShowPanelInfo()
	end
end

function UIRecharge:ShowTagClickInfo(_Index)
	UIRecharge.ClickTag = _Index
	if UIRecharge.ClickTag == 1 then
		GameMain.OpenObj(UIRecharge.Controls.GoldTagClick)
		GameMain.CloseObj(UIRecharge.Controls.GoldTagNoClick)
		GameMain.CloseObj(UIRecharge.Controls.OtherTagClick)
		GameMain.OpenObj(UIRecharge.Controls.OtherTagNoClick)
	end
	if UIRecharge.ClickTag == 2 then
		GameMain.CloseObj(UIRecharge.Controls.GoldTagClick)
		GameMain.OpenObj(UIRecharge.Controls.GoldTagNoClick)
		GameMain.OpenObj(UIRecharge.Controls.OtherTagClick)
		GameMain.CloseObj(UIRecharge.Controls.OtherTagNoClick)
	end
end

function UIRecharge:BuyDiamond(_Index)
	UIRecharge.BuyClickIndex = _Index
	UIRecharge.CurMyDiamoned = ClinetInfomation:GetDiamond()
	UIRecharge.CurGoldTicket = ClinetInfomation.goldticket
	local data = nil
	if UIRecharge.ClickTag == 1 then
		data = UIRecharge.RechargeDataList[_Index]
	end
	if UIRecharge.ClickTag == 2 then
		data = UIRecharge.RechargeOtherDataList[_Index]
	end
--	RechargeSys.BuyDiamond(data.Dbid)
	RechargeSys.BuyDiamond(data.AppStore_Id)
end

function UIRecharge:ShowBuyAfter()
	local data = nil
	if UIRecharge.ClickTag == 1 then
		data = UIRecharge.RechargeDataList[UIRecharge.BuyClickIndex]
	end
	if UIRecharge.ClickTag == 2 then
		data = UIRecharge.RechargeOtherDataList[UIRecharge.BuyClickIndex]
	end
	local rwd =UIRecharge.UIRechargeGodList[UIRecharge.BuyClickIndex].transform:FindChild("Descrip/MoneyC"):GetComponent("UILabel")

	if data.OtherRechargeBonus == 0 then
		rwd.text = tostring(data.Diamond)
		GameMain.CloseObj(UIRecharge.UIRechargeGodList[UIRecharge.BuyClickIndex].transform:FindChild("IsDouble"))
	else
		rwd.text = tostring(data.Diamond) --.. "+" .. tostring(data.OtherRechargeBonus)
--		GameMain.CloseObj(UIRecharge.UIRechargeGodList[_InUIRecharge.BuyClickIndexdex].transform:FindChild("IsDouble"))
	end
	this:ShowMyOwnGold()
	local Count = 0
	local _Reward = nil
	if UIRecharge.ClickTag == 1 then
		Count = ClinetInfomation:GetDiamond() - UIRecharge.CurMyDiamoned
		_Reward = ItemDataSys.GetResourceData(1 , Count)
	end
	if UIRecharge.ClickTag == 2 then
		Count = ClinetInfomation.goldticket - UIRecharge.CurGoldTicket
		_Reward = ItemDataSys.GetResourceData(8 , Count)
	end
	local data = {}
	
	data = _Reward.Item
	data.Count = Count
	local list =
	{
		[1] = data
	}
	DataUIInstance.OpenRewards(list)
end

function UIRecharge:ClosePanel()
	GameMain.CloseObj(UIRecharge.UIRechargeGod);
end

function UIRecharge:ReleasPanel()
	--UI相关
	UIRecharge.UIRechargeGod = nil
	UIRecharge.UIRechargeGodList = {}	
	UIRecharge.Controls = {}
	--Data相关
	UIRecharge.RechargeDataList = {}	--充值的list数据
	UIRecharge.RechargeOtherDataList = {}	--其他的list数据
	UIRecharge.CurMyDiamoned = 0		--当前的钻石
	UIRecharge.CurGoldTicket = 0		--当前的金券
	UIRecharge.ClickTag = 0				--当前点击的Tag 1 元宝 2 other
	UIRecharge.BuyClickIndex = 0		--点击购买的index 
end

function UIRecharge:ReleasData()
	RechargeSys.RechargeDataList = {}
	RechargeSys.IsFrist = 0		-- 0没有首冲， 1 已经首充值
	RechargeSys.IsRecFrist = 0	--是否领取了首冲奖励

end

return UIRecharge
--endregion