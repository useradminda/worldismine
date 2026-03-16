--背包界面  后续将使用界面和出售界面分离开
UIBag = {}
local UIBag = BasePanel:new()
local this = UIBag
UIBag.UIBagGod = nil

UIBag.TabPage=nil --标签页
UIBag.Grid=nil --存放道具列表的父物体
UIBag.ItemList={} --存放物品列表的数组（key,item）
UIBag.ItemGobList ={} --专门用来存放物体
UIBag.ItemClick=nil --点击的那个物品

UIBag.NullPanel =nil		--当物品为nil时做这个显示
UIBag.MoneyCount = nil

UIBag.SwitchBtns=
{
	daoju=nil,
	libao=nil,
	zhuangbei=nil,
	suipian=nil,
	shizhuang=nil,
}

UIBag.ItemInfoPanel={}
UIBag.ItemSellAndUsePanel={}
UIBag.ItemSellPanel=nil
UIBag.itemSellControls={}
UIBag.UIWrap= nil
UIBag.BagScrollView = nil

function UIBag:OpenUI(_PanelName , _LuaName)
	if UIBag.UIBagGod==nil then
		UIBag.UIBagGod=MainGameUI.FindPanel("UIBag")

		this:GetControls()
		this:GetSwitchBtns()
		this:GetItemInfoPanel()
		this:GetItemSellAndUsePanel()
		this:GetItemSellPanel()
	end
	this:ClearBtnsState(UIBag.SwitchBtns.daoju)
	this:UpDateInfo()
	this:ShowBasicInfo()
end

function UIBag:ShowBasicInfo()
	if UIBag.MoneyCount==nil then
		UIBag.MoneyCount = UIBag.UIBagGod.transform:FindChild("right/jinbi/Label"):GetComponent("UILabel")
	end
	UIBag.MoneyCount.text = tostring(ClinetInfomation.GetCoin())
end

function UIBag:GetControls()
	UIBag.Grid=UIBag.UIBagGod.transform:FindChild("right"):FindChild("scrollView"):FindChild("Grid"):GetComponent("UIGrid")
	UIBag.UIBagUseItemPanel=UIBag.UIBagGod.transform:FindChild("UIBagItemUsePanel")
	UIBag.ItemSellPanel=UIBag.UIBagGod.transform:FindChild("UIBagItemSellPanel")
	UIBag.NullPanel = UIBag.UIBagGod.transform:FindChild("ShowNull")
	UIBag.UIWrap = UIBag.UIBagGod.transform:FindChild("right"):GetComponent("UIWrap")
	UIBag.BagScrollView = UIBag.UIWrap.transform:FindChild("scrollView"):GetComponent("UIScrollView")
	UIBag.MoneyCount = UIBag.UIBagGod.transform:FindChild("right/jinbi/Label"):GetComponent("UILabel")
end

function UIBag:GetItemInfoPanel()
	local left=UIBag.UIBagGod.transform:FindChild("left")
	UIBag.ItemInfoPanel.border=left.transform:FindChild("item"):FindChild("BG"):GetComponent("UISprite")--品质框
	UIBag.ItemInfoPanel.icon=left.transform:FindChild("item"):FindChild("Img"):GetComponent("UISprite")
	UIBag.ItemInfoPanel.name=left.transform:FindChild("item"):FindChild("LabelName"):GetComponent("UILabel")--名称
	UIBag.ItemInfoPanel.labelInfo=left.transform:FindChild("item"):FindChild("Labelinfo"):GetComponent("UILabel")--相关说明
	UIBag.ItemInfoPanel.des=left.transform:FindChild("infoPanel"):FindChild("infodes"):GetComponent("UILabel")
	UIBag.ItemInfoPanel.FG = left.transform:FindChild("item"):FindChild("FG"):GetComponent("UISprite")
end

function UIBag:GetItemSellPanel()--得到出售面板的相关控件

	UIBag.itemSellControls.Icon=UIBag.ItemSellPanel:FindChild("info/IMG"):GetComponent("UISprite")
	UIBag.itemSellControls.Type=UIBag.ItemSellPanel:FindChild("info/type"):GetComponent("UISprite")
	UIBag.itemSellControls.Name=UIBag.ItemSellPanel:FindChild("info/name"):GetComponent("UILabel")
	UIBag.itemSellControls.OwnNum=UIBag.ItemSellPanel:FindChild("info/OwnCount"):GetComponent("UILabel")
	UIBag.itemSellControls.Bg = UIBag.ItemSellPanel:FindChild("info/BG"):GetComponent("UISprite")
	UIBag.itemSellControls.SellItemPrice=UIBag.ItemSellPanel:FindChild("SellItemPrice/SellPrice"):GetComponent("UILabel")
	UIBag.itemSellControls.ChooseItemNum=UIBag.ItemSellPanel:FindChild("Sell/count"):GetComponent("UILabel")
	UIBag.itemSellControls.GetAllCost=UIBag.ItemSellPanel:FindChild("GetPrice/SellPrice"):GetComponent("UILabel")
	
end

function UIBag:GetItemSellAndUsePanel()
	local useSellPanel=UIBag.UIBagGod.transform:FindChild("left"):FindChild("UseSellPanel")
	UIBag.ItemSellAndUsePanel.des=useSellPanel.transform:FindChild("des"):GetComponent("UILabel")
	UIBag.ItemSellAndUsePanel.SellPrice=useSellPanel.transform:FindChild("jinbi"):FindChild("Label"):GetComponent("UILabel")
	UIBag.ItemSellAndUsePanel.Price=useSellPanel.transform:FindChild("jinbi")
	UIBag.ItemSellAndUsePanel.OnlySellBtn=useSellPanel.transform:FindChild("OnlySellBtn")
	UIBag.ItemSellAndUsePanel.SellAndUse=useSellPanel.transform:FindChild("sellAndUse")
	UIBag.ItemSellAndUsePanel.OnlyUseBtn=useSellPanel.transform:FindChild("OnlyUseBtn")
end
function UIBag:GetSwitchBtns()
	local _switchBtnsList=UIBag.UIBagGod.transform:FindChild("right")
	UIBag.SwitchBtns.daoju=_switchBtnsList:FindChild("daojuBtn")
	UIBag.SwitchBtns.libao=_switchBtnsList:FindChild("libaoBtn")
	UIBag.SwitchBtns.zhuangbei=_switchBtnsList:FindChild("zhuangbeiBtn")
	UIBag.SwitchBtns.suipian=_switchBtnsList:FindChild("suipianBtn")
	UIBag.SwitchBtns.shizhuang=_switchBtnsList:FindChild("shizhuangBtn")

	
end

function UIBag:UpDateInfo()--每切换一次都要更新显示

	if UIBag.TabPage==UIBag.SwitchBtns.daoju then
		this:ClearPanel()	
		this:ShowDaoJuPanel()
		
	end
	if UIBag.TabPage==UIBag.SwitchBtns.libao then	
		this:ClearPanel()
		this:ShowGiftPanel()
		
	end
	if UIBag.TabPage==UIBag.SwitchBtns.zhuangbei then
		this:ClearPanel()
		
		this:ShowEquipPanel()
	end
	if UIBag.TabPage==UIBag.SwitchBtns.suipian then
		this:ClearPanel()

		this:ShowDebrisPanel()
	end
	if UIBag.TabPage==UIBag.SwitchBtns.shizhuang then
		this:ClearPanel()
		GameMain.OpenObj(UIBag.NullPanel)
	end
end

function UIBag:ClearPanel()	--切换界面时，清理一下相关数据
		this:CloseItemPanel(UIBag.ItemSellAndUsePanel.des.transform.parent)
		this:CloseItemPanel(UIBag.ItemInfoPanel.des.transform.parent)
		this:CloseItemPanel(UIBag.ItemInfoPanel.icon.transform.parent)
		UIBag.ItemList = {} 
		for key,value in pairs(UIBag.ItemGobList) do
			GameMain.CloseObj(value)
		end
end
--region *.装备
function UIBag:ShowEquipPanel()
	local list =EquipSys.GetEquipList()
	if #list ==0 then
		GameMain.OpenObj(UIBag.NullPanel)
		return
	end
	GameMain.CloseObj(UIBag.NullPanel)
	
	for i=1, #list ,1 do
		UIBag.ItemList[i] = list[i]
	end

	this:ShowBagList()

end

--endregion

function UIBag:ShowGiftPanel() --显示礼包
	local list = GiftPackageSys.GetGiftList()
	if #list ==0 then
		GameMain.OpenObj(UIBag.NullPanel)
		return
	end
	GameMain.CloseObj(UIBag.NullPanel)
	
	for key,value in pairs( list) do
		if value.Useable == 1 then
			table.insert(UIBag.ItemList , #UIBag.ItemList +1 , value)
		end
	end
	this:ShowBagList()
end
function UIBag:ShowDaoJuPanel()	--显示道具列表界面
	local list = ItemPackageSys.GetItemList()
	if #list ==0 then
		GameMain.OpenObj(UIBag.NullPanel)
		return
	end
	GameMain.CloseObj(UIBag.NullPanel)
	for key,value in pairs( list) do
		if value.Useable == 1 then
			table.insert(UIBag.ItemList , #UIBag.ItemList +1 , value)
		end
	end
	
	this:ShowBagList()
end

function UIBag:ShowDebrisPanel()
	local list = DebrisPackageSys.GetAllData()
	if #list ==0 then
		GameMain.OpenObj(UIBag.NullPanel)
		return
	end
	GameMain.CloseObj(UIBag.NullPanel)
	for key,value in pairs( list) do
		if value.Useable == 1 then
			table.insert(UIBag.ItemList , #UIBag.ItemList +1 , value)
		end
	end
	
	this:ShowBagList()
end

function UIBag:ClearItemList()
	local num = #UIBag.ItemList
	local len = #UIBag.ItemGobList
	if len ~=0 then
		for i=num , len ,1 do
			GameMain.CloseObj(UIBag.ItemGobList[i])
		end
	end
end

function UIBag:ShowBagList()

	UIBag.Grid.transform.parent.transform.localPosition = Vector3(0,0,0)
	UIBag.Grid.transform.parent.transform:GetComponent("UIPanel").clipOffset = Vector2(0,0)
	UIBag.UIWrap:ResetTrans(#UIBag.ItemList)
	if(UIBag.BagScrollView:GetComponent("SpringPanel")~=null) then
		UIBag.BagScrollView:GetComponent("SpringPanel").target = Vector3(0,0,0)
	end

	if #UIBag.ItemGobList ==0  then
		for i=1 , 30 , 1 do
			local data=
			{
				Index=i,
			}
		MainGameUI.CreateLittleItem(tostring(i) , "itemIcon" , UIBag.Grid.transform , data , this.CreateItemListCallBack , "UIBag")
		end
	else
		for i=1,30,1  do
			local data=
				{
					Index=i,
				}
			if UIBag.ItemGobList[i]~=nil then
				
				this:CreateItemListCallBack(UIBag.ItemGobList[i] , data)
			else
				MainGameUI.CreateLittleItem(tostring(i) , "itemIcon" , UIBag.Grid.transform , data , this.CreateItemListCallBack , "UIBag")
			end
		end
	end
end


function UIBag:CreateItemListCallBack(_Gob , _Info)--创建物品列表并做信息显示

	if _Info.Index==30 then
		UIBag.Grid.enabled = true
		UIBag.Grid:Reposition()
		UIBag.UIWrap:SetData(#UIBag.ItemList , "UIBag")
		this:showItemInfoPanel(1)
	end
	UIBag.ItemGobList[tonumber(_Info.Index)] = _Gob
	local data = UIBag.ItemList[_Info.Index]
	if data == nil then
		GameMain.CloseObj(_Gob)
		return
	else
		GameMain.OpenObj(_Gob)
		
		local numLabel=_Gob.transform:FindChild("count"):GetComponent("UILabel")
		local itemSprite=_Gob.transform:FindChild("Img"):GetComponent("UISprite")
		local itemBorder=_Gob.transform:FindChild("BG"):GetComponent("UISprite")
		local Lv = _Gob.transform:FindChild("Lv"):GetComponent("UILabel")
		local itemBg = _Gob.transform:FindChild("FG"):GetComponent("UISprite")
	
		if  data.Count==nil then
		   GameMain.CloseObj(numLabel)
		else
		   GameMain.OpenObj(numLabel)
		   numLabel.text = tostring(data.Count)
		end
		if data.Lvl ==nil then
			GameMain.CloseObj(Lv)
		else
			GameMain.OpenObj(Lv)
			Lv.text = "Lv." .. tostring(data.Lvl)
		end
		AtlasMsg.SetAtlas(itemSprite , data.AtlasName , data.SpriteName)
		itemBorder.spriteName = UIstring.ItemFg[data.Quality]
		itemBg.spriteName = UIstring.ItemFg[data.Quality]
	end
	


end
function UIBag:UpdateItem(_LuaName , _Item)
	local id = tonumber(_Item.name)
	UIBag.ItemGobList[id] = _Item
	local data = UIBag.ItemList[id]
	
	if data~=nil then
		GameMain.OpenObj(_Item)
		local click = _Item.transform:FindChild("click")
		if UIBag.ItemClick == nil then
			GameMain.CloseObj(click)
		else
			if UIBag.ItemClick.Index~= id then
				GameMain.CloseObj(click)
			else
				GameMain.OpenObj(click)
			end
		end
		
		local numLabel=_Item.transform:FindChild("count"):GetComponent("UILabel")
		local itemSprite=_Item.transform:FindChild("Img"):GetComponent("UISprite")
		local itemBorder=_Item.transform:FindChild("BG"):GetComponent("UISprite")
		local Lv = _Item.transform:FindChild("Lv"):GetComponent("UILabel")
	
		if data.Count==0 then
		   if numLabel.text~="" then
			  numLabel.text = ""
		   end
		else
		   numLabel.text = tostring(data.Count)
		end
		
	    AtlasMsg.SetAtlas(itemSprite , data.AtlasName , data.SpriteName)
		Lv.text = "Lv." .. tostring(data.Lvl)
		itemBorder.spriteName = UIstring.ItemFg[data.Quality]
		
	else
		GameMain.CloseObj(_Item)
	end
end
function UIBag:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
	if _Gob.name == "mask" then
		GameMain.CloseObj(UIBag.UIBagGod)
	end
	if _Gob.name=="daojuBtn" then
		this:ClearBtnsState(UIBag.SwitchBtns.daoju)
		this:UpDateInfo()
	end

	if _Gob.name=="libaoBtn" then
		this:ClearBtnsState(UIBag.SwitchBtns.libao)
		this:UpDateInfo()
	end

	if _Gob.name=="zhuangbeiBtn" then
		this:ClearBtnsState(UIBag.SwitchBtns.zhuangbei)
		this:UpDateInfo()
	end
	if _Gob.name=="suipianBtn" then
		this:ClearBtnsState(UIBag.SwitchBtns.suipian)
		this:UpDateInfo()
	end
	if _Gob.name=="shizhuangBtn" then
		this:ClearBtnsState(UIBag.SwitchBtns.shizhuang)
		this:UpDateInfo()
	end
	if _Gob.name=="closeBtn" then
		this:ClosePanel()
	end
	
	if _Gob.name == "CloseUsePanel" then
		this:CloseItemPanel(UIBag.UIBagUseItemPanel)
	end
	
	if _Gob.name == "ItemSellMask" then
		this:CloseItemPanel(UIBag.ItemSellPanel.gameObject)
	end
	local ItemKey = tonumber(_Gob.name)
       local ItemParentName = _Gob.transform.parent.name
       if ItemKey~=nil and ItemParentName=="Grid" then
           if ItemKey~=nil and UIBag.ItemList[ItemKey]~=nil then                       --点击背包里面的道具
                 this:showItemInfoPanel(ItemKey)             
                 return
           end
     end

	if _Gob.name=="OnlyUseBtn" then
		this:OpenUIBagItemUsePanel()
	end

	if _Gob.name=="OnlySellBtn" then
		this:OpenUIBagItemSellPanel()
	end

	if _Gob.name=="sellBtn" and _Gob.transform.parent.name=="sellAndUse" then
		this:OpenUIBagItemSellPanel()
	end
	
	if _Gob.name=="useBtn" and _Gob.transform.parent.name=="sellAndUse" then
		
		this:OpenUIBagItemUsePanel()
	end
	--使用界面的点击事件，后续独立成一个panel
	if _Gob.name=="useBtn" and  _Gob.transform.parent.name=="UIBagItemUsePanel" then
		--使用界面的使用按钮点击
		
		this:UseItem()
	end
	if _Gob.name=="mask" then
		
		this:CloseItemPanel(UIBag.ItemSellPanel.gameObject)
	end
	if _Gob.name=="add" and  _Gob.transform.parent.name=="UIBagItemUsePanel" then
		this:UseItemCountChange(1)
	end
	if _Gob.name=="sub" and  _Gob.transform.parent.name=="UIBagItemUsePanel" then
		this:UseItemCountChange(-1)
	end
	if _Gob.name=="max" and  _Gob.transform.parent.name=="UIBagItemUsePanel" then
		if UIBag.ItemClick~=nil then
			this:UseItemCountChange(UIBag.ItemClick.ItemData.Count)
		end
	end

	if _Gob.name=="ConfirmSellBtn" then
		this:SellItem()
	end
	if _Gob.name=="add" and  _Gob.transform.parent.name=="Sell" then
		this:SellItemCountChange(1)
	end
	if _Gob.name=="sub" and  _Gob.transform.parent.name=="Sell" then
		this:SellItemCountChange(-1)
	end
	if _Gob.name=="max" and  _Gob.transform.parent.name=="Sell" then
		if UIBag.ItemClick~=nil then
			this:SellItemCountChange(UIBag.ItemClick.ItemData.Count)
		end
	end
	
end
function UIBag:ClearBtnsState(_activeBtn)
	if UIBag.TabPage~=nil then
		local click = UIBag.TabPage.transform:FindChild("click")
		local normal = UIBag.TabPage.transform:FindChild("normal")
		GameMain.CloseObj(click)
		GameMain.OpenObj(normal)
	end
	UIBag.TabPage=_activeBtn
	local click1 = UIBag.TabPage.transform:FindChild("click")
	local normal1 = UIBag.TabPage.transform:FindChild("normal")
	GameMain.CloseObj(normal1)
	GameMain.OpenObj(click1)
end

function UIBag:showItemInfoPanel(id)--显示左侧的物品信息，根据Index来
	
--	if UIBag.TabPage==UIBag.SwitchBtns.daoju then--道具标签
		local item=UIBag.ItemList[id]
	
		if item==nil then
			this:CloseItemPanel(UIBag.ItemInfoPanel.icon.transform.parent)
			this:CloseItemPanel(UIBag.ItemInfoPanel.des.transform.parent)
			this:CloseItemPanel(UIBag.ItemSellAndUsePanel.des.transform.parent)
			return
		end

		if UIBag.ItemClick~=nil then
			UIBag.ItemClick.ItemGod.transform:FindChild("click").gameObject:SetActive(false)
		end
		UIBag.ItemClick=
		{
			ItemGod=UIBag.ItemGobList[id],
			ItemData=UIBag.ItemList[id],
			Index = id,
		}
		
		UIBag.ItemClick.ItemGod.transform:FindChild("click").gameObject:SetActive(true)

		if UIBag.TabPage==UIBag.SwitchBtns.daoju then--道具标签 then
			this:ShowDaoJuItem(item)
		end
		if UIBag.TabPage == UIBag.SwitchBtns.zhuangbei then
			this:ShoweEquipItem(item)
		end

		if UIBag.TabPage == UIBag.SwitchBtns.libao then
			this:ShowDaoJuItem(item)
		end
		if UIBag.TabPage == UIBag.SwitchBtns.suipian then
			this:ShowDaoJuItem(item)
		end

end
function UIBag:ShoweEquipItem(item)
	this:OpenItemPanel(UIBag.ItemInfoPanel.icon.transform.parent)
	local atk = item:GetNoPurfyAtk()
	local hp = item:GetNoPurifyHp()
	local atkSpeed = item:GetNoPurifyAtkSpeed()
	local str = ""
	if atk ~=0 then
		str =  str.. UIstring.NormalWordColor.. "攻击：" .. atk .."[-]".. "\n"
	end
	if hp ~= 0 then
		str = str.. UIstring.NormalWordColor.. "血量：" .. hp .."[-]".. "\n"
	end
	if atkSpeed ~=0 then
		str = str..UIstring.NormalWordColor.."攻速：" .. atkSpeed .."[-]".. "\n"
	end
	local puriftyStr = this:GetPurifyAddValue(item)
	if puriftyStr ~= "" then
		str = str .. UIstring.NormalWordColor .. "洗炼加成：" .."[-]".. "\n" .. puriftyStr
	end
--只有白 绿 蓝 可以出售 
	if item.Quality < 3 then
		this:ShowItemUseAndSellPanel()
		UIBag.ItemSellAndUsePanel.SellPrice.text=tostring(item.Price)
		UIBag.ItemSellAndUsePanel.des.text=str
		GameMain.OpenObj(UIBag.ItemSellAndUsePanel.Price)
		this:ShowGameobj(UIBag.ItemSellAndUsePanel.SellAndUse,false)
		this:ShowGameobj(UIBag.ItemSellAndUsePanel.OnlySellBtn,true)
		this:ShowGameobj(UIBag.ItemSellAndUsePanel.OnlyUseBtn,false)
	else
		GameMain.CloseObj(UIBag.ItemSellAndUsePanel.Price)
		this:OpenItemPanel(UIBag.ItemInfoPanel.icon.transform.parent)
		this:CloseItemPanel(UIBag.ItemSellAndUsePanel.des.transform.parent)
		this:OpenItemPanel(UIBag.ItemInfoPanel.des.transform.parent)
		UIBag.ItemInfoPanel.des.text=str
	end
	
	UIBag.ItemInfoPanel.name.text=tostring(item.nickname)
	UIBag.ItemInfoPanel.labelInfo.text = "Lv" .. tostring(item.Lvl) 
	AtlasMsg.SetAtlas(UIBag.ItemInfoPanel.icon,item.AtlasName,item.SpriteName)
	UIBag.ItemInfoPanel.border.spriteName = UIstring.ItemFg[item.Quality]
	UIBag.ItemInfoPanel.FG.spriteName = UIstring.ItemFg[item.Quality]

--	UIBag.ItemInfoPanel.labelInfo.text="拥有"..tostring(item.Count).."件"
end

function UIBag:GetPurifyAddValue(_Data)
	local str = ""
	if _Data.HpAdd~=0 then
		local color = UIstring.GetHpValueColor(_Data.HpAdd)
		local hpStr = color..  "武将生命+".._Data:GetPurifyHp().."(每级增加".._Data.HpAdd ..")".."[-]"
		str = this:GetAddAttrStr(str , hpStr)
	end
	if _Data.AttackAdd~=0 then
		local color = UIstring.GetAtkValueColor(_Data.AttackAdd)
		local atkStr = color.. "武将攻击+".._Data:GetPurifyAtk().."(每级增加".._Data.AttackAdd ..")" .. "[-]"
		str = this:GetAddAttrStr(str , atkStr)
	end
	if _Data.AttackSpeedAdd~=0 then
		local color = UIstring.GetAtkSpeedValueColor(_Data.AttackSpeedAdd)
		local atkSpeedStr = color.. "武将攻速+".._Data:GetPurifyAtkSpeed().."(每级增加".._Data.AttackSpeedAdd ..")".."[-]"
		str = this:GetAddAttrStr(str , atkSpeedStr)
	end
	return str
end

function UIBag:GetAddAttrStr(_Str , _AddStr)
	if _Str == "" then
		_Str = _AddStr
	else
		_Str = _Str .. "\n" .. _AddStr
	end
	return _Str
end

function UIBag:ShowDaoJuItem(item)
		UIBag.ItemInfoPanel.name.text=tostring(item.nickname)
		AtlasMsg.SetAtlas(UIBag.ItemInfoPanel.icon,item.AtlasName,item.SpriteName)
		UIBag.ItemInfoPanel.border.spriteName = UIstring.ItemFg[item.Quality]
		UIBag.ItemInfoPanel.FG.spriteName = UIstring.ItemFg[item.Quality]
		UIBag.ItemInfoPanel.labelInfo.text="拥有"..tostring(item.Count).."件"

		if item.CanSell==1 and item.IsUse==1 then --既可以出售也可以使用
			this:ShowItemUseAndSellPanel()
			GameMain.OpenObj(UIBag.ItemSellAndUsePanel.Price)
			UIBag.ItemSellAndUsePanel.SellPrice.text=tostring(item.Price)
			UIBag.ItemSellAndUsePanel.des.text=tostring(item.Description)
			
			this:ShowGameobj(UIBag.ItemSellAndUsePanel.SellAndUse,true)
			this:ShowGameobj(UIBag.ItemSellAndUsePanel.OnlySellBtn,false)
			this:ShowGameobj(UIBag.ItemSellAndUsePanel.OnlyUseBtn,false)
		end
		if item.CanSell==0 and item.IsUse==1 then	--只可以使用
			this:ShowItemUseAndSellPanel()
			UIBag.ItemSellAndUsePanel.SellPrice.text=tostring(item.Price)
			UIBag.ItemSellAndUsePanel.des.text=tostring(item.Description)
			GameMain.CloseObj(UIBag.ItemSellAndUsePanel.Price)
			this:ShowGameobj(UIBag.ItemSellAndUsePanel.SellAndUse,false)
			this:ShowGameobj(UIBag.ItemSellAndUsePanel.OnlySellBtn,false)
			this:ShowGameobj(UIBag.ItemSellAndUsePanel.OnlyUseBtn,true)
		end
		if item.CanSell==1 and item.IsUse==0 then --只可以出售
			this:ShowItemUseAndSellPanel()
			GameMain.OpenObj(UIBag.ItemSellAndUsePanel.Price)
			UIBag.ItemSellAndUsePanel.SellPrice.text=tostring(item.Price)
			UIBag.ItemSellAndUsePanel.des.text=tostring(item.Description)
			this:ShowGameobj(UIBag.ItemSellAndUsePanel.SellAndUse,false)
			this:ShowGameobj(UIBag.ItemSellAndUsePanel.OnlySellBtn,true)
			this:ShowGameobj(UIBag.ItemSellAndUsePanel.OnlyUseBtn,false)
		end

		if item.CanSell==0 and item.IsUse==0 then		--只有说明
			GameMain.CloseObj(UIBag.ItemSellAndUsePanel.Price)
			this:OpenItemPanel(UIBag.ItemInfoPanel.icon.transform.parent)
			this:CloseItemPanel(UIBag.ItemSellAndUsePanel.des.transform.parent)
			this:OpenItemPanel(UIBag.ItemInfoPanel.des.transform.parent)
			UIBag.ItemInfoPanel.des.text=tostring( item.Description)
		end
end




function UIBag:RefrashUIBagItem(item ,count)--刷新背包中单个item
	local id=tonumber(item.name)
	if UIBag.ItemList~=nil then
		if count<=0 then
			
			table.remove(UIBag.ItemList , id)
			UIBag.ItemClick = nil
			this:ShowBagList()
			if #UIBag.ItemList>0 then
				if #UIBag.ItemList>=id then
					this:showItemInfoPanel(tonumber(id))
				else
					this:showItemInfoPanel(tonumber(id)-1)
				end
			end
			return
		end
		if count>0  then
			UIBag.ItemList[id].Count=count
			item.transform:FindChild("count"):GetComponent("UILabel").text=tostring(count)
			this:showItemInfoPanel(id)
		end
	end
end

function UIBag:ShowItemUseAndSellPanel()
	this:OpenItemPanel(UIBag.ItemInfoPanel.icon.transform.parent)
	this:CloseItemPanel(UIBag.ItemInfoPanel.des.transform.parent)
	this:OpenItemPanel(UIBag.ItemSellAndUsePanel.des.transform.parent)
end
function UIBag:ClosePanel()
	UIBag.UIBagGod:SetActive(false)
end

function UIBag:OpenItemPanel(panel)
	panel.gameObject:SetActive(true)
end

function UIBag:CloseItemPanel(panel)
	panel.gameObject:SetActive(false)
end

function UIBag:ShowGameobj(obj,isShow)
	obj.gameObject:SetActive(isShow)
end
--排序
function UIBag.Comp(A , B)
    if A~=nil and B~=nil then
       if A.Quality>B.Quality then
          return true
		
		elseif A.Quality==B.Quality then 
             if A.Dbid > B.Dbid then
                return true            
             elseif A.Dbid < B.Dbid then
                return false             
             elseif A.Dbid==B.Dbid then 
                return false                            
			end
       elseif A.Quality<B.Quality then
          return false
       end
    end
--    return false 
end

function UIBag:ReleasPanel()
	UIBag.UIBagGod = nil

	UIBag.TabPage=nil --标签页
	UIBag.Grid=nil --存放道具列表的父物体
	UIBag.ItemList={} --存放物品列表的数组（key,item）
	UIBag.ItemGobList ={} --专门用来存放物体
	UIBag.ItemClick=nil --点击的那个物品

	UIBag.NullPanel =nil		--当物品为nil时做这个显示
	UIBag.MoneyCount = nil

	UIBag.SwitchBtns=
	{
		daoju=nil,
		libao=nil,
		zhuangbei=nil,
		suipian=nil,
		shizhuang=nil,
	}

	UIBag.ItemInfoPanel={}
	UIBag.ItemSellAndUsePanel={}
	UIBag.ItemSellPanel=nil
	UIBag.itemSellControls={}
	UIBag.UIWrap= nil
	UIBag.BagScrollView = nil
end


--[[物品使用的panel，后续将独立出来--]]
UIBag.UIBagUseItemPanel=nil
UIBag.UIBagUseItemPanelName=nil
UIBag.UIBagUseItemPanelCountText=nil
UIBag.UIBagUseItemPanelCount=1
function UIBag:OpenUIBagItemUsePanel()
	if UIBag.ItemClick==nil then
		return
	end
	UIBag.UIBagUseItemPanelCount=1
	if UIBag.ItemClick.ItemData.IsGift == true then
		if ClinetInfomation.Lvl< UIBag.ItemClick.ItemData.UseLvl then
			DataUIInstance.PopTip(UIstring.NoUpLevel)
			return
		end
		if UIBag.ItemClick.ItemData.Type == 1 then--选择
			DataUIInstance.OpenRwdPop(UIBag.ItemClick.ItemData , 1,2)
--			local num = UIBag.ItemClick.ItemData.Count -1
--			this:RefrashUIBagItem(UIBag.ItemClick.ItemGod ,num)
			return
		end
	end
	if UIBag.ItemClick.ItemData.IsDebris == true then
		local num = GameMain.ConvertToInt( UIBag.ItemClick.ItemData.Count / UIBag.ItemClick.ItemData.ComposeNum)
		if num<=0 then
			DataUIInstance.PopTip("碎片不足")
			return
		end
		if num == 1 then
			local count = UIBag.ItemClick.ItemData.Count -UIBag.ItemClick.ItemData.ComposeNum
			UIBag.ItemClick.ItemData:UseItem(UIBag.ItemClick.ItemData.Count)
			this:RefrashUIBagItem(UIBag.ItemClick.ItemGod ,count)
			return
		end
		UIBag.UIBagUseItemPanelCount = UIBag.ItemClick.ItemData.ComposeNum
	end
		this:OpenItemPanel(UIBag.UIBagUseItemPanel.gameObject)
		
		UIBag.UIBagUseItemPanelName=UIBag.UIBagUseItemPanel.transform:FindChild("name"):GetComponent("UILabel")
		UIBag.UIBagUseItemPanelCountText=UIBag.UIBagUseItemPanel.transform:FindChild("count"):GetComponent("UILabel")
		UIBag.UIBagUseItemPanelName.text=tostring(UIBag.ItemClick.ItemData.nickname)
--local max=UIBag.ItemClick.ItemData.Count
		UIBag.UIBagUseItemPanelCountText.text=tostring(UIBag.UIBagUseItemPanelCount)
--
end

function UIBag:ShowUseBagGiftAfter(_UseData, _Id)
	if _UseData.Data == 3 then
		local count = _UseData.Count
		local rewardData = RewardConfig.GetRewardConfig(tonumber(_Id))
			
		local jsonItems = RewardContentSys.GetRewardResourceString(rewardData.RewardString)
		local list = {}
		for key,value in pairs(jsonItems.Items) do
			value.Count = value.Count * count
			table.insert(list , #list+1 , value)
		end
		
		DataUIInstance.OpenRewards(list)
	end
	if UIBag.ItemClick == nil then
		return
	end
	local index = tonumber(UIBag.ItemClick.ItemGod.name)
	UIBag.ItemClick.ItemData = GiftPackageSys.GetDataById(UIBag.ItemClick.ItemData.Dbid)
	if UIBag.ItemClick.ItemData == nil then
		table.remove(UIBag.ItemList , index)
		UIBag.ItemClick = nil
		this:ShowBagList()
		if #UIBag.ItemList>0 then
			if #UIBag.ItemList>=index then
				this:showItemInfoPanel(tonumber(index))
			else
				this:showItemInfoPanel(tonumber(index)-1)
			end
		end
	else
		this:RefrashUIBagItem(UIBag.ItemClick.ItemGod ,UIBag.ItemClick.ItemData.Count)
	end
end

function UIBag:UseItem()
	this:CloseItemPanel(UIBag.UIBagUseItemPanel.gameObject)
	local count=tonumber(UIBag.ItemClick.ItemData.Count)-tonumber(UIBag.UIBagUseItemPanelCount)
	local id=tonumber(UIBag.ItemClick.ItemGod.name)
	
	if UIBag.ItemClick.ItemData.IsGift ==true then
		if UIBag.ItemClick.ItemData.Type ==2 then 
				this:ShowRecTips(UIBag.ItemClick.ItemData , UIBag.UIBagUseItemPanelCount)
		end
	end
	
	if UIBag.UIBagUseItemPanelCount >0 then
		UIBag.ItemClick.ItemData:UseItem(UIBag.UIBagUseItemPanelCount)
	end
	UIBag.UIBagUseItemPanelCount=1

	UIBag.ItemList[id].Count=count
	
	this:RefrashUIBagItem(UIBag.ItemGobList[id] ,count)

end

function UIBag:ShowRecTips(_Data , _Count)
	local rewardData = RewardConfig.GetRewardConfig(tonumber(_Data.TargetList[1]))
			
	local jsonItems = RewardContentSys.GetRewardResourceString(rewardData.RewardString)
	
	local list = {}
	for key,value in pairs(jsonItems.Items) do
		value.Count = value.Count * _Count
		table.insert(list , #list+1 , value)
	end
		
	DataUIInstance.OpenRewards(list)
end

function UIBag:UseItemCountChange(num)
	if UIBag.ItemClick~=nil then
		if UIBag.ItemClick.ItemData.IsDebris == true then
			local maxNum = GameMain.ConvertToInt( UIBag.ItemClick.ItemData.Count / UIBag.ItemClick.ItemData.ComposeNum)
			local addNum = num
			if num ==  UIBag.ItemClick.ItemData.Count then
				addNum = maxNum
			end
			UIBag.UIBagUseItemPanelCount = UIBag.UIBagUseItemPanelCount + addNum*UIBag.ItemClick.ItemData.ComposeNum
			if UIBag.UIBagUseItemPanelCount<=0 then
				UIBag.UIBagUseItemPanelCount = 1
			end
			if UIBag.UIBagUseItemPanelCount >=maxNum*UIBag.ItemClick.ItemData.ComposeNum  then
				UIBag.UIBagUseItemPanelCount =  maxNum*UIBag.ItemClick.ItemData.ComposeNum
			end
		else
			if tonumber( num)>=UIBag.ItemClick.ItemData.Count then
				UIBag.UIBagUseItemPanelCount=UIBag.ItemClick.ItemData.Count
			end
				UIBag.UIBagUseItemPanelCount=UIBag.UIBagUseItemPanelCount+num
			if tonumber(UIBag.UIBagUseItemPanelCount) <= 0 then
				UIBag.UIBagUseItemPanelCount=1
			end
			if tonumber(UIBag.UIBagUseItemPanelCount) >= tonumber(UIBag.ItemClick.ItemData.Count) then
				UIBag.UIBagUseItemPanelCount=UIBag.ItemClick.ItemData.Count
			end
		end
		
		
	UIBag.UIBagUseItemPanelCountText.text=tostring(UIBag.UIBagUseItemPanelCount)
	end
end


UIBag.UIBagSellCount=1
--后续单独弄一个界面，分离开来
function UIBag:OpenUIBagItemSellPanel()
	if UIBag.TabPage == UIBag.SwitchBtns.zhuangbei then
		local coin = ClinetInfomation.GetCoin() + UIBag.ItemClick.ItemData.Price
		UIBag.MoneyCount.text = tostring(coin)
		UIBag.ItemClick.ItemData:SellEquip()
		this:RefrashUIBagItem(UIBag.ItemClick.ItemGod ,0)
		
		return
	end
		this:OpenItemPanel(UIBag.ItemSellPanel.gameObject)
		this:ShowUIBagItemSellInfo()
end

function UIBag:ShowUIBagItemSellInfo()
	UIBag.UIBagSellCount=1
	if UIBag.ItemClick~=nil then
		local data=UIBag.ItemClick.ItemData
		if UIBag.TabPage == UIBag.SwitchBtns.daoju then
			
			UIBag.itemSellControls.Name.text=tostring(data.nickname)
			UIBag.itemSellControls.OwnNum.text=tostring("拥有")..tostring(data.Count)
			UIBag.itemSellControls.SellItemPrice.text=tostring(data.Price)
			UIBag.itemSellControls.ChooseItemNum.text=tostring(UIBag.UIBagSellCount)
			UIBag.itemSellControls.Type.spriteName =UIstring.ItemFg[data.Quality]
			UIBag.itemSellControls.Bg.spriteName = UIstring.ItemFg[data.Quality]
			local img = UIBag.itemSellControls.Icon
			AtlasMsg.SetAtlas(img, data.AtlasName , data.SpriteName)
			local cost=tonumber(UIBag.UIBagSellCount)*tonumber(UIBag.ItemClick.ItemData.Price)
			UIBag.itemSellControls.GetAllCost.text=tostring(cost)
		end
		
	end

end

function UIBag:SellItem()				--出售道具
	local coin = UIBag.ItemClick.ItemData.Price *UIBag.UIBagSellCount
	
	UIBag.MoneyCount.text = tostring(ClinetInfomation.GetCoin()+coin)
	this:CloseItemPanel(UIBag.ItemSellPanel.gameObject)
	UIBag.ItemClick.ItemData:SellItem(UIBag.UIBagSellCount)

	local count=tonumber(UIBag.ItemClick.ItemData.Count)
	local num=tonumber( count)-tonumber( UIBag.UIBagSellCount)
	local id = tonumber(UIBag.ItemClick.ItemGod.name)
	UIBag.ItemList[id].Count=num
	
	this:RefrashUIBagItem(UIBag.ItemGobList[id] ,num)
end

function UIBag:SellItemCountChange(num)
	if num==UIBag.ItemClick.ItemData.Count then
		UIBag.UIBagSellCount=num
	else
		UIBag.UIBagSellCount=UIBag.UIBagSellCount+num
	end
	if UIBag.UIBagSellCount<=1 then
		UIBag.UIBagSellCount=1
	end
	if UIBag.UIBagSellCount>=UIBag.ItemClick.ItemData.Count then
		UIBag.UIBagSellCount=UIBag.ItemClick.ItemData.Count
	end
	
	UIBag.itemSellControls.ChooseItemNum.text=tostring(UIBag.UIBagSellCount)
	local cost=tonumber(UIBag.UIBagSellCount)*tonumber(UIBag.ItemClick.ItemData.Price)
	UIBag.itemSellControls.GetAllCost.text=tostring(cost)
end

function UIBag:ReleasData()
	ItemPackageSys.ItemList = {}
	ItemPackageSys.IsSort = true
	GiftPackageSys.GiftList = {}
	GiftPackageSys.IsSort = true
	UIBag.ItemList = {}
end

function UIBag:InitPanel()
    UIBag.UIBagGod.gameObject:SetActive(false)
end

return UIBag