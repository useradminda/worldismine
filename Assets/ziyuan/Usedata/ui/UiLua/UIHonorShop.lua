--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
UIHonorShop = {}
UIHonorShop=BasePanel:new()
local this = UIHonorShop
--UI
UIHonorShop.UIHonorShopGod = nil
UIHonorShop.Controls = {}
UIHonorShop.GodList = {}
--Data
UIHonorShop.DataList = {}
UIHonorShop.Type = 0		--1沙场点兵  2 豆酱台

function UIHonorShop:OpenUI(_PanelName , _LuaName , _Type)
	if UIHonorShop.UIHonorShopGod == nil then
		UIHonorShop.UIHonorShopGod=MainGameUI.FindPanel("UIHonorShop")
		this:GetControls()
	end
	UIHonorShop.Type = _Type
	this:SetInitData()
	this:ShowInfo()
end

function UIHonorShop:SetInitData()
	if UIHonorShop.Type == 1 then
		UIHonorShop.DataList = HonerShopSys.GetAllShaChangData()
	end
	if UIHonorShop.Type == 2 then
		UIHonorShop.DataList = HonerShopSys.GetAllDouJiangTaiData()
	end
end

function UIHonorShop:GetControls()
	UIHonorShop.Controls.UIWrap = UIHonorShop.UIHonorShopGod.transform:FindChild("ListPanel"):GetComponent("UIWrap")
	UIHonorShop.Controls.Grid = UIHonorShop.Controls.UIWrap.transform:FindChild("Grid"):GetComponent("UIGrid")
	UIHonorShop.Controls.HonorValue = UIHonorShop.UIHonorShopGod.transform:FindChild("HonorValue/Label"):GetComponent("UILabel")
	UIHonorShop.Controls.ListPanel = UIHonorShop.UIHonorShopGod.transform:FindChild("ListPanel"):GetComponent("UIPanel")
end

function UIHonorShop:ShowInfo()
	this:ShowShopList()
	this:ShowHonorInfo()
end

function UIHonorShop:ShowHonorInfo()
	UIHonorShop.Controls.HonorValue.text = tostring(ClinetInfomation.Honour)
end

function UIHonorShop:ShowShopList()
	UIHonorShop.Controls.UIWrap:ResetTrans(#UIHonorShop.DataList)
	UIHonorShop.Controls.ListPanel.clipOffset = Vector2(0,0)
	UIHonorShop.Controls.ListPanel.transform.localPosition = Vector3(0,0,0)

	for i=1,12,1 do
		local data = 
		{
			Index =i,
		}
		if UIHonorShop.GodList[i] == nil then
			MainGameUI.CreateLittleItem(tostring(i) , "HonorShopItem" , UIHonorShop.Controls.Grid , data , this.CreateListCallBack , "UIHonorShop") 
		else
			this:CreateListCallBack(UIHonorShop.GodList[i],data)
		end
	end
end

function UIHonorShop:CreateListCallBack(_God , _Info)
	local index = _Info.Index
	if index == 12 then
		UIHonorShop.Controls.Grid.enabled = true
		UIHonorShop.Controls.Grid:Reposition()
		UIHonorShop.Controls.UIWrap:SetData(#UIHonorShop.DataList , "UIHonorShop")
	end
	this:ShowShopItemInfo(_God , index)
end

function UIHonorShop:ShowShopItemInfo(_Gob , _Index)
	UIHonorShop.GodList[_Index] = _Gob
	local data = UIHonorShop.DataList[_Index]
	if data == nil then
		GameMain.CloseObj(_Gob)
		return
	end
	GameMain.OpenObj(_Gob)
	
	local img = _Gob.transform:FindChild("Icon"):GetComponent("UISprite")
	local quality =  _Gob.transform:FindChild("type"):GetComponent("UISprite")
	local name = _Gob.transform:FindChild("Name"):GetComponent("UILabel")
	local fg = _Gob.transform:FindChild("FG"):GetComponent("UISprite")--FG
	AtlasMsg.SetAtlas(img , data.RewardData.AtlasName , data.RewardData.SpriteName)
	quality.spriteName = UIstring.ItemFg[data.RewardData.Quality]
	fg.spriteName = UIstring.ItemFg[data.RewardData.Quality]
	name.text = UIstring.WordColor[data.RewardData.Quality] .. data.RewardData.Name .. "[-]"
	this:ShowItemPrice(_Gob , data)
end

function UIHonorShop:ShowItemPrice(_Gob , _Data)
	local price = _Gob.transform:FindChild("price"):GetComponent("UILabel")
	local addNum = _Gob.transform:FindChild("addNum"):GetComponent("UILabel")

	addNum.text = tostring(_Data.BuyCount)
	price.text = tostring(_Data:GetAllPrice())
end

function UIHonorShop:UpdateItem(_LuaName , _Item)
	local index = tonumber(_Item.name)
	this:ShowShopItemInfo(_Item , index)
end

function UIHonorShop:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
	if _Gob.name == "CloseBtn" then
		this:ClosePanel()
	end
	if _Gob.name == "addNumBtn" then
		local index = tonumber(_Gob.transform.parent.name)
		this:ToShopItemAdd(index ,1)
	end
	if _Gob.name == "subNumBtn" then
		local index = tonumber(_Gob.transform.parent.name)
		this:ToShopItemAdd(index ,-1)
	end
	if _Gob.name == "buyBtn" then
		local index = tonumber(_Gob.transform.parent.name)
		this:ToBuyShopItem(index)
	end
end

function UIHonorShop:ToShopItemAdd(_Index ,_Num)
	local god = UIHonorShop.GodList[_Index]
	local data = UIHonorShop.DataList[_Index]
	data:AddCount(_Num)
	this:ShowItemPrice(god , data)
end

function UIHonorShop:ToBuyShopItem(_Index)
	local data = UIHonorShop.DataList[_Index]
	if ClinetInfomation.Honour<data:GetAllPrice() then
		DataUIInstance.PopTip("荣誉值不足")
		return
	end
	HonerShopSys.BuyShop(data, UIHonorShop.Type)
end

function UIHonorShop:ClosePanel()
	GameMain.CloseObj(UIHonorShop.UIHonorShopGod)
end

function UIHonorShop:ReleasPanel()
	--UI
	UIHonorShop.UIHonorShopGod = nil
	UIHonorShop.Controls = {}
	UIHonorShop.GodList = {}
	--Data
	UIHonorShop.DataList = {}
	UIHonorShop.Type = 0		--1沙场点兵  2 豆酱台
end

return UIHonorShop
--endregion
