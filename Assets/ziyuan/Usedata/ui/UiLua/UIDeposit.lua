--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
UIDeposit = {}
UIDeposit = BasePanel:new()
local this = UIDeposit

--UI
UIDeposit.DepositGod = nil

UIDeposit.ClickTag = nil

UIDeposit.Controls = {}

UIDeposit.BuyGodList = {}	
UIDeposit.BuyClassGodList = {}		--购买的类型标签
UIDeposit.BuyTypeGodlist = {}		--购买的类型标签
UIDeposit.SellControls = {}			
UIDeposit.SellGodList = {}

UIDeposit.SellItemGodList = {}		--上架出售的玩家的godlist
UIDeposit.SellItemControls = {}	
UIDeposit.BuyControls = {}			--购买的控件	
--Data
UIDeposit.BuyTypeTagName =				--购买的标签名
{
	[1] = "装备",
}
UIDeposit.BuyMyTagName = 
{
	[1] = "全部",
	[2] = "装备"
}

UIDeposit.BuyTypeDataList = {}		--标签下的所有的Class

UIDeposit.ClickBuyType = 0			--点击购买的类型
UIDeposit.ClickBuyClass = 0			--点击购买的具体商品

UIDeposit.BuyAllServeProducts = {}	--全服的数据
UIDeposit.BuyMyServeProducts = {}	--本服的数据

UIDeposit.ClickBuyTag = 1			--1 全服 2 本服

UIDeposit.ClickBuyIndex = 0			--点击购买的那个index

UIDeposit.SellDataList = {}			--出售的商品数据

UIDeposit.SellItemDataList = {}
UIDeposit.SellTmepItem = nil		--要出售的临时商品

UIDeposit.SellTempPrice = 0			--出售商品的价格
UIDeposit.SellTempCount = 0			--出售商品的数量

UIDeposit.MyShelvesDataList = {}	--我的上架商品

UIDeposit.ClickMyProductIndex = 0		--我的上架商品Index

UIDeposit.BuyTempProduct = nil			--购买的商品
UIDeposit.BuyProductCount = 0			--购买商品的数量

function UIDeposit:OpenUI(_PanelName , _LuaName)
	if UIDeposit.DepositGod == nil then
		UIDeposit.DepositGod = MainGameUI.FindPanel("UIDeposit")
		this:GetControls()
	end
	this:ShowBuyWebInfo()
end

function UIDeposit:ShowBuyWebInfo()
	UIDeposit.ClickBuyTag = 1
	UIDeposit.ClickBuyClass = 1
	UIDeposit.ClickBuyType = 1

	DepositSys.GetAllWebProducts()
end

function UIDeposit.ShowCurBuyWebInfo()
	DepositSys.GetAllWebProducts()
end


function UIDeposit:ShowTagInfo(_God)
	if UIDeposit.ClickTag~=nil then
		local click = UIDeposit.ClickTag.transform:FindChild("click")
		local normal = UIDeposit.ClickTag.transform:FindChild("normal")
		GameMain.CloseObj(click)
		GameMain.OpenObj(normal)
	end
	UIDeposit.ClickTag = _God
	local click = UIDeposit.ClickTag.transform:FindChild("click")
	local normal = UIDeposit.ClickTag.transform:FindChild("normal")
	GameMain.OpenObj(click)
	GameMain.CloseObj(normal)
end


function UIDeposit:GetControls()			--得到相关控件
	UIDeposit.Controls.BuyListWrap = UIDeposit.DepositGod.transform:FindChild("BuyList/BuyListPanel"):GetComponent("UIWrap")
	UIDeposit.Controls.BuyListGrid = UIDeposit.Controls.BuyListWrap.transform:FindChild("BuyGrid"):GetComponent("UIGrid")
	
	UIDeposit.Controls.MyInfo = UIDeposit.DepositGod.transform:FindChild("MyInfo")
	UIDeposit.Controls.BuyInfo = UIDeposit.DepositGod.transform:FindChild("BuyInfo")
	UIDeposit.Controls.BuyNoInfo = UIDeposit.DepositGod.transform:FindChild("BuyList/NoBuyInfo")
	UIDeposit.Controls.SellNoInfo = UIDeposit.DepositGod.transform:FindChild("BuyList/NoSellInfo")
	UIDeposit.Controls.MyWebBtn = UIDeposit.Controls.BuyInfo.transform:FindChild("myWeb")
	UIDeposit.Controls.AllWebBtn = UIDeposit.Controls.BuyInfo.transform:FindChild("allWeb")

	UIDeposit.Controls.GoldTicket = UIDeposit.DepositGod.transform:FindChild("GoldenCount/Label"):GetComponent("UILabel")
	
	UIDeposit.Controls.BuyChooseTypePanel = UIDeposit.DepositGod.transform:FindChild("BuyInfo/ChoseTypePanel")
	UIDeposit.Controls.BuyChooseClassPanel = UIDeposit.DepositGod.transform:FindChild("BuyInfo/ChoseClassPanel")
	UIDeposit.Controls.BuyTypeGrid = UIDeposit.Controls.BuyChooseTypePanel.transform:FindChild("ChoseTypeGrid"):GetComponent("UIGrid")
	UIDeposit.Controls.BuyClassGrid = UIDeposit.Controls.BuyChooseClassPanel.transform:FindChild("ChoseClassGrid"):GetComponent("UIGrid")
	
	UIDeposit.Controls.BuyTypeTagNameTxt = UIDeposit.DepositGod.transform:FindChild("BuyInfo/ChooseTypeBtn/Label"):GetComponent("UILabel")
	UIDeposit.Controls.BuyClassTagNameTxt = UIDeposit.DepositGod.transform:FindChild("BuyInfo/ChooseClassBtn/Label"):GetComponent("UILabel")

	UIDeposit.Controls.SellListWrap = UIDeposit.DepositGod.transform:FindChild("SellList/SellListPanel"):GetComponent("UIWrap")
	UIDeposit.Controls.MySellProductPanel = UIDeposit.DepositGod.transform:FindChild("MySellItemPanel")
	UIDeposit.Controls.BuyCountPanel = UIDeposit.DepositGod.transform:FindChild("BuyCountPanel")
end

function UIDeposit:ShowGoldInfo()
	UIDeposit.Controls.GoldTicket.text = tostring(ClinetInfomation.goldticket)
end
--region * 购买界面相关

function UIDeposit:ShowBuyPanelInfoCallBack()
	local clickTag = UIDeposit.DepositGod.transform:FindChild("Tags/BuyTag")
	this:ShowChooseTagNames()
	this:ShowGoldInfo()
	this:ShowBuyPanelInfo(clickTag)
	this:ShowChooseWebInfo()
end

function UIDeposit:ShowChooseTagNames()
	UIDeposit.BuyTypeDataList = {}
	if UIDeposit.ClickBuyTag == 1 then
		UIDeposit.Controls.BuyTypeTagNameTxt.text = UIDeposit.BuyTypeTagName[UIDeposit.ClickBuyType]
		UIDeposit.BuyTypeDataList = DepositSys.GetBuyAllTag(UIDeposit.ClickBuyTag)
		if UIDeposit.BuyTypeDataList[1] == "全部" then
			table.remove(UIDeposit.BuyTypeDataList , 1)
		end
	end
	if UIDeposit.ClickBuyTag == 2 then
		UIDeposit.Controls.BuyTypeTagNameTxt.text = UIDeposit.BuyMyTagName[UIDeposit.ClickBuyType]
		if UIDeposit.ClickBuyType ==1 then
			UIDeposit.Controls.BuyClassTagNameTxt.text = "全部"
			UIDeposit.ClickBuyClass = 1
			return
		else
			UIDeposit.BuyTypeDataList = DepositSys.GetBuyAllTag(UIDeposit.ClickBuyTag-1)
			if UIDeposit.BuyTypeDataList[1] == "全部" then
				table.insert(UIDeposit.BuyTypeDataList , 1, "全部")
			end
		end
	end
	UIDeposit.Controls.BuyClassTagNameTxt.text = UIDeposit.BuyTypeDataList[UIDeposit.ClickBuyClass]
end

function UIDeposit:ShowChooseBuyType()			--显示type标签
	GameMain.OpenObj(UIDeposit.Controls.BuyChooseTypePanel)
	local list = {}
	if UIDeposit.ClickBuyTag == 1 then
		list = UIDeposit.BuyTypeTagName
	end
	if UIDeposit.ClickBuyTag == 2 then
		list = UIDeposit.BuyMyTagName
	end
	UIDeposit.Controls.BuyChooseTypePanel:GetComponent("UIWrap"):ResetTrans(#list)
	UIDeposit.Controls.BuyChooseTypePanel:GetComponent("UIPanel").clipOffset = Vector2(0,0)
	UIDeposit.Controls.BuyChooseTypePanel.transform.localPosition = Vector3(0,0,0)
	for i=1,7,1 do
		local data = 
		{
			Index = i,
			Data = list[i],
			Len = #list,
		}
		if UIDeposit.BuyTypeGodlist[i]==nil then
			MainGameUI.CreateLittleItem(tostring(i) , "DepositBuyTag" , UIDeposit.Controls.BuyTypeGrid , data , this.CreateBuyTypeCallBack , "UIDeposit") 
		else
			this:CreateBuyTypeCallBack(UIDeposit.BuyTypeGodlist[i] , data)
		end
	end
end

function UIDeposit:CreateBuyTypeCallBack(_Gob , _Info)--创建物品列表并做信息显示
	if _Info.Index==7   then
		UIDeposit.Controls.BuyTypeGrid.enabled = true
		UIDeposit.Controls.BuyTypeGrid:Reposition()
		UIDeposit.Controls.BuyChooseTypePanel.transform:GetComponent("UIWrap"):SetData(_Info.Len , "UIDeposit")
	end
	UIDeposit.BuyTypeGodlist[_Info.Index] = _Gob
	this:ShowTagName(_Info.Data , _Gob)
end

function UIDeposit:ShowChooseBuyClass()
	local index = UIDeposit.ClickBuyType
	UIDeposit.BuyTypeDataList = {}
	if UIDeposit.ClickBuyTag == 1 then
		UIDeposit.BuyTypeDataList = DepositSys.GetBuyAllTag(index)
	end
	if UIDeposit.ClickBuyTag == 2 then
		if index ==1 then
			UIDeposit.Controls.BuyClassTagNameTxt.text = "全部"
			UIDeposit.ClickBuyClass = 1
			return
		else
			UIDeposit.BuyTypeDataList = DepositSys.GetBuyAllTag(index-1)
			if UIDeposit.BuyTypeDataList[1] ~= "全部" then
				table.insert(UIDeposit.BuyTypeDataList , 1, "全部")
			end
		end
	end
	GameMain.OpenObj(UIDeposit.Controls.BuyChooseClassPanel)
	UIDeposit.Controls.BuyChooseClassPanel:GetComponent("UIWrap"):ResetTrans(#UIDeposit.BuyTypeDataList)
	UIDeposit.Controls.BuyChooseClassPanel:GetComponent("UIPanel").clipOffset = Vector2(0,0)
	UIDeposit.Controls.BuyChooseClassPanel.transform.localPosition = Vector3(0,0,0)

	for i=1,7,1 do
		local data = 
		{
			Index = i,
			Data = UIDeposit.BuyTypeDataList[i],
			Len = #UIDeposit.BuyTypeDataList,
		}
		if UIDeposit.BuyClassGodList[i]==nil then
			MainGameUI.CreateLittleItem(tostring(i) , "DepositBuyTag" , UIDeposit.Controls.BuyClassGrid , data , this.CreateBuyClassCallBack , "UIDeposit") 
		else
			this:CreateBuyClassCallBack(UIDeposit.BuyClassGodList[i] , data)
		end
	end
end

function UIDeposit:CreateBuyClassCallBack(_Gob , _Info)--创建物品列表并做信息显示
	if _Info.Index==7   then
		UIDeposit.Controls.BuyClassGrid.enabled = true
		UIDeposit.Controls.BuyClassGrid:Reposition()
		UIDeposit.Controls.BuyChooseClassPanel.transform:GetComponent("UIWrap"):SetData(_Info.Len , "UIDeposit")
	end
	UIDeposit.BuyClassGodList[_Info.Index] = _Gob
	this:ShowTagName(_Info.Data , _Gob)
end

function UIDeposit:ShowTagName(_Data , _God)
	if _Data == nil then
		GameMain.CloseObj(_God)
		return
	end
	GameMain.OpenObj(_God)
	local info = _God.transform:FindChild("Word"):GetComponent("UILabel")
	info.text = _Data
end

function UIDeposit:CloseBuyTypePanel()
	GameMain.CloseObj(UIDeposit.Controls.BuyChooseTypePanel)
end

function UIDeposit:CloseBuyClassPanel()
	GameMain.CloseObj(UIDeposit.Controls.BuyChooseClassPanel)
end

function UIDeposit:ToChooseBuyType(Index)						--选择大的类型标签
	UIDeposit.ClickBuyType = Index
	local str = ""
	if UIDeposit.ClickBuyTag == 1 then
		str = UIDeposit.BuyTypeTagName[Index]
	end
	if UIDeposit.ClickBuyTag == 2 then
		str =  UIDeposit.BuyMyTagName[Index]
		if Index == 1 then
			UIDeposit.Controls.BuyClassTagNameTxt.text = "全部"
		end
	end
	UIDeposit.Controls.BuyTypeTagNameTxt.text = str
	this:CloseBuyTypePanel()
	UIDeposit.ClickBuyClass = 1
	this:ShowTypeBuyListInfo()
end

function UIDeposit:ToChooseBuyClass(Index)							--选举具体的类型标签
	UIDeposit.ClickBuyClass = Index
	local str = ""

	str = UIDeposit.BuyTypeDataList[Index]
	
	UIDeposit.Controls.BuyClassTagNameTxt.text = str
	
	this:CloseBuyClassPanel()
	this:ShowTypeBuyListInfo()
end

function UIDeposit:ShowBuyPanelInfo(_God)
	GameMain.OpenObj(UIDeposit.Controls.BuyInfo)
	GameMain.CloseObj(UIDeposit.Controls.MyInfo)
	GameMain.OpenObj(UIDeposit.Controls.BuyListWrap.transform.parent)
	GameMain.CloseObj(UIDeposit.Controls.SellListWrap.transform.parent)
	
	this:ShowTagInfo(_God)
	this:ShowGoldInfo()
	this:ShowTypeBuyListInfo()
end

function UIDeposit:ShowChooseWebInfo()							--选择了不同的服务器
	this:SetBuyWebTagInfo()
	UIDeposit.ClickBuyType = 1
	UIDeposit.ClickBuyClass = 1
	this:ShowChooseTagNames()
	this:ShowTypeBuyListInfo()
end

function UIDeposit:ShowTypeBuyListInfo()						--根据不同的type 和class显示list
	local list = {}
	if UIDeposit.ClickBuyTag == 1 then
		list = this:ChooseAllBuyClass(UIDeposit.ClickBuyType , UIDeposit.ClickBuyClass)
	end	
	if UIDeposit.ClickBuyTag == 2 then
		list = this:ChooseMyBuyClass(UIDeposit.ClickBuyType-1 , UIDeposit.ClickBuyClass-1)
	end
	GameMain.CloseObj(UIDeposit.Controls.SellNoInfo)
	if #list>0 then
		GameMain.OpenObj(UIDeposit.Controls.BuyListWrap)
		GameMain.CloseObj(UIDeposit.Controls.BuyNoInfo)
		this:ShowBuyListInfo(list)
	else
		GameMain.CloseObj(UIDeposit.Controls.BuyListWrap)
		GameMain.OpenObj(UIDeposit.Controls.BuyNoInfo)
	end
end

function UIDeposit:ChooseAllBuyClass(_Type , _Class)					--选择不同的商品类型
	local list = DepositSys.GetTypeAllProducts(_Type , _Class)
	UIDeposit.BuyAllServeProducts = {}
	if list == nil then
		return nil
	end
	for key,value in pairs(list) do
		table.insert(UIDeposit.BuyAllServeProducts , #UIDeposit.BuyAllServeProducts +1 , value)
	end
	return UIDeposit.BuyAllServeProducts
end

function UIDeposit:ChooseMyBuyClass(_Type , _Class)					--选择本服不同的商品类型
	UIDeposit.BuyMyServeProducts = {}
	if _Type ==0 and _Class == 0  then
		local myList = DepositSys.GetMyServeProducts()
		if myList == nil then
			return nil
		end
		for key1,value1 in pairs(myList) do
			table.insert(UIDeposit.BuyMyServeProducts , #UIDeposit.BuyMyServeProducts +1 ,value1)
		end
		return UIDeposit.BuyMyServeProducts
	end
	local list = DepositSys.GetTypeMyProducts(_Type , _Class)
	if list==nil then
		return nil
	end
	for key,value in pairs(list) do
		table.insert(UIDeposit.BuyMyServeProducts , #UIDeposit.BuyMyServeProducts +1 , value)
	end
	return UIDeposit.BuyMyServeProducts
end

function UIDeposit:ShowBuyListInfo(list)			--显示购买的List信息
		UIDeposit.Controls.BuyListWrap:ResetTrans(#list)
		UIDeposit.Controls.BuyListWrap.transform.localPosition = Vector3(0,0,0)
		UIDeposit.Controls.BuyListWrap.transform:GetComponent("UIPanel").clipOffset = Vector2(0 , 0)

	for i=1,6,1  do
		local data = 
		{
			Index = i,
			Len = #list,
			Data = list[i],
		}
		if UIDeposit.BuyGodList[i] == nil then
			MainGameUI.CreateLittleItem(tostring(i) , "DepositBuyItem" , UIDeposit.Controls.BuyListGrid , data , this.CreateBuyListCallBack , "UIDeposit") 
		else
			this:CreateBuyListCallBack(UIDeposit.BuyGodList[i],data)
		end
	end
	
end

function UIDeposit:CreateBuyListCallBack(_God , _Info)
	if _Info.Index == 6 then
		UIDeposit.Controls.BuyListGrid.enabled = true
		UIDeposit.Controls.BuyListGrid:Reposition()
		UIDeposit.Controls.BuyListWrap:SetData(_Info.Len , "UIDeposit")
	
	end
	
	local Index = _Info.Index
	UIDeposit.BuyGodList[Index] = _God
	
	local data = _Info.Data
	this:ShowBuyItem(_God , data)
end

function UIDeposit:ShowBuyItem(_God , _Data)				--显示单个的物品购买信息
	if _Data == nil then
		GameMain.CloseObj(_God)
		return
	end
	GameMain.OpenObj(_God)
	if _God == nil then
		return
	end
	local img = _God.transform:FindChild("img"):GetComponent("UISprite")
	local quality = _God.transform:FindChild("quality"):GetComponent("UISprite")
	local price = _God.transform:FindChild("price"):GetComponent("UILabel")
	local name =  _God.transform:FindChild("name"):GetComponent("UILabel")
	local elusTime = _God.transform:FindChild("elusTime"):GetComponent("UILabel")
	local playerName = _God.transform:FindChild("playerName"):GetComponent("UILabel")
	local num = _God.transform:FindChild("Num"):GetComponent("UILabel")
	
	local buyBtn = _God.transform:FindChild("BuyBtn")
	local recBtn = _God.transform:FindChild("RecMyItemBtn")
	local downBtn = _God.transform:FindChild("DownMyItemBtn")

	GameMain.CloseObj(downBtn)
	GameMain.CloseObj(recBtn)

	AtlasMsg.SetAtlas(img ,_Data.AtlasName , _Data.SpriteName)
	quality.spriteName = UIstring.ItemFg[_Data.Quality]
	price.text = tostring(_Data.SellPrice)
	name.text = _Data.Name
	elusTime.text = tostring(_Data:GetDelTime()) .. "小时"
	
	if _Data.IsMyShelvesProduct == 1 then
		--我的货架
		GameMain.CloseObj(buyBtn)
		local isOver = _Data:IsOverTime()
		
		if _Data.SellCount ~= 0 then
			num.text = tostring(_Data.SellCount)
			GameMain.OpenObj(recBtn)
			playerName.text = "已出售"
		else
			num.text = tostring(_Data:GetMyCount())
			GameMain.OpenObj(downBtn)
			if isOver == true then
				playerName.text = "已过期"
			else
				playerName.text = "寄售中"
			end
		end
	else	
		num.text = tostring(_Data.ElusNum)
		playerName.text = _Data.PlayerName
		GameMain.OpenObj(buyBtn)
	end
end

function UIDeposit:ToBuyProduct(Index)						--购买商品
--	DataUIInstance.pop
	UIDeposit.ClickBuyIndex = Index
	local data = nil
	if UIDeposit.ClickBuyTag == 1 then
		data = UIDeposit.BuyAllServeProducts[UIDeposit.ClickBuyIndex]
		local isOver = data:IsOverTime()
		if isOver == true then
			this:ShowBuyCallBackListInfo(UIDeposit.BuyAllServeProducts , UIDeposit.ClickBuyIndex)
			DataUIInstance.PopTip("该物品已过期，请重新购买其他物品！")
			return
		end
	end
	if UIDeposit.ClickBuyTag == 2 then
		data = UIDeposit.BuyMyServeProducts[UIDeposit.ClickBuyIndex]
		local isOver = data:IsOverTime()
		if isOver == true then
			DataUIInstance.PopTip("该物品已过期，请重新购买其他物品！")
			this:ShowBuyCallBackListInfo(UIDeposit.BuyMyServeProducts , Index)
			return
		end
	end

	if data.PlayerId == ClinetInfomation.Player_id then
		DataUIInstance.PopTip("不能购买自己的物品")
		return
	end

	this:OpenAddNumPanel(data)
end

function UIDeposit:OpenAddNumPanel(_Data)
	GameMain.OpenObj(UIDeposit.Controls.BuyCountPanel)
	if UIDeposit.BuyControls.Img == nil then
		this:GetBuyControls()
	end
	UIDeposit.BuyTempProduct = _Data
	UIDeposit.BuyProductCount = 1
	UIDeposit.BuyControls.BuyCount.text = tostring(UIDeposit.BuyProductCount)

	AtlasMsg.SetAtlas(UIDeposit.BuyControls.Img , _Data.AtlasName , _Data.SpriteName)
	UIDeposit.BuyControls.Quality.spriteName = UIstring.ItemFg[_Data.Quality]
	UIDeposit.BuyControls.ItemName.text = _Data.Name
	UIDeposit.BuyControls.Info.text = _Data.Description
	UIDeposit.BuyControls.Ticket.text = tostring(_Data.SellPrice)
end

function UIDeposit:GetBuyControls()
	UIDeposit.BuyControls.Img = UIDeposit.Controls.BuyCountPanel.transform:FindChild("itemIcon/Img"):GetComponent("UISprite")
	UIDeposit.BuyControls.Quality = UIDeposit.Controls.BuyCountPanel.transform:FindChild("itemIcon/BG"):GetComponent("UISprite")
	UIDeposit.BuyControls.ItemName = UIDeposit.Controls.BuyCountPanel.transform:FindChild("name"):GetComponent("UILabel")
	UIDeposit.BuyControls.OwnCount = UIDeposit.Controls.BuyCountPanel.transform:FindChild("havecount"):GetComponent("UILabel")
	UIDeposit.BuyControls.BuyCount = UIDeposit.Controls.BuyCountPanel.transform:FindChild("useCount"):GetComponent("UILabel")
	UIDeposit.BuyControls.Info = UIDeposit.Controls.BuyCountPanel.transform:FindChild("info"):GetComponent("UILabel")
	UIDeposit.BuyControls.Ticket = UIDeposit.Controls.BuyCountPanel.transform:FindChild("money/Label"):GetComponent("UILabel")
end

function UIDeposit:BuyCountProduct()
	local myOwn = ClinetInfomation.goldticket
	local needCost = UIDeposit.BuyTempProduct.SellPrice * UIDeposit.BuyProductCount
	if myOwn<needCost then
		DataUIInstance.PopTip("金券不足")
		return
	end
	DepositSys.BuyProduct(UIDeposit.BuyTempProduct.UUID, UIDeposit.BuyProductCount)
	UIDeposit.BuyTempProduct.ElusNum = UIDeposit.BuyTempProduct.ElusNum - UIDeposit.BuyProductCount
	if UIDeposit.BuyTempProduct.ElusNum<=0 then
		UIDeposit.BuyTempProduct = nil
	end
	this:ShowBuyProductCallBack(UIDeposit.BuyTempProduct)
	this:CloseBuyProductPanel()
end

function UIDeposit:CloseBuyProductPanel()
	GameMain.CloseObj(UIDeposit.Controls.BuyCountPanel)
end

function UIDeposit:ChangeBuyProductCount(_AddNum , _IsMax)
	local max = UIDeposit.BuyTempProduct.ElusNum
	if _IsMax == true then
		UIDeposit.BuyProductCount = max
	else
		UIDeposit.BuyProductCount = UIDeposit.BuyProductCount + _AddNum
		
		if UIDeposit.BuyProductCount <=1 then
			UIDeposit.BuyProductCount = 1
		end
		if UIDeposit.BuyProductCount >=max then
			UIDeposit.BuyProductCount = max
		end
	end
	UIDeposit.BuyControls.BuyCount.text = tostring(UIDeposit.BuyProductCount)
	local needTicket = UIDeposit.BuyProductCount * UIDeposit.BuyTempProduct.SellPrice
	UIDeposit.BuyControls.Ticket.text = tostring(needTicket)
end
function UIDeposit:ShowBuyProductCallBack(_Data)
--	GameMain.Print(_Data , "data")
	if UIDeposit.ClickBuyTag == 1 then
		if _Data == nil then
			this:ShowBuyCallBackListInfo(UIDeposit.BuyAllServeProducts , UIDeposit.ClickBuyIndex)
			return
		else
			UIDeposit.BuyAllServeProducts[UIDeposit.ClickBuyIndex] = _Data
		end
	end
	if UIDeposit.ClickBuyTag == 2 then
		if _Data == nil then
			this:ShowBuyCallBackListInfo(UIDeposit.BuyMyServeProducts , UIDeposit.ClickBuyIndex)
			return
		end
		UIDeposit.BuyMyServeProducts[UIDeposit.ClickBuyIndex] = _Data
	end
	this:ShowBuyItem(UIDeposit.BuyGodList[UIDeposit.ClickBuyIndex] , _Data)
	this:ShowGoldInfo()
end

function UIDeposit:ShowBuyCallBackListInfo(_List , _Index)				--显示购买之后的信息
	table.remove(_List, _Index)
	UIDeposit.ClickBuyIndex = 0
	this:ShowBuyListInfo(_List)
end

function UIDeposit:SetBuyWebTagInfo()
	local allClose = UIDeposit.Controls.AllWebBtn.transform:FindChild("close")
	local allChoose = UIDeposit.Controls.AllWebBtn.transform:FindChild("choose")
	local myClose = UIDeposit.Controls.MyWebBtn.transform:FindChild("close")
	local myChoose = UIDeposit.Controls.MyWebBtn.transform:FindChild("choose")
	if UIDeposit.ClickBuyTag == 1 then
		GameMain.CloseObj(allChoose)
		GameMain.CloseObj(myClose)
		GameMain.OpenObj(myChoose)
		GameMain.OpenObj(allClose)
	end
	if UIDeposit.ClickBuyTag == 2 then
		GameMain.OpenObj(allChoose)
		GameMain.OpenObj(myClose)
		GameMain.CloseObj(myChoose)
		GameMain.CloseObj(allClose)
	end
end
--endregion

--region * 出售界面相关

function UIDeposit:ShowSellPanelInfo(_God)
	GameMain.CloseObj(UIDeposit.Controls.BuyInfo)
	GameMain.CloseObj(UIDeposit.Controls.MyInfo)
	GameMain.CloseObj(UIDeposit.Controls.BuyListWrap.transform.parent)
	GameMain.OpenObj(UIDeposit.Controls.SellListWrap.transform.parent)
	if UIDeposit.SellControls.Gird == nil then
		this:GetSellControls()
	end
	this:ShowSellInfo()
	this:ShowTagInfo(_God)
	
end

function UIDeposit:GetSellControls()
	UIDeposit.SellControls.Gird = UIDeposit.Controls.SellListWrap.transform:FindChild("SellGrid"):GetComponent("UIGrid")
	UIDeposit.SellControls.NoSellInfo = UIDeposit.DepositGod.transform:FindChild("SellList/NoSellProductInfo")
end

function UIDeposit:ShowSellInfo()
	UIDeposit.SellDataList = {}
	local list = DepositSys.GetCanSellProducts()
	if #list<=0 then
		GameMain.OpenObj(UIDeposit.SellControls.NoSellInfo)
		GameMain.CloseObj(UIDeposit.SellControls.Gird)
		return
	end
	GameMain.OpenObj(UIDeposit.SellControls.Gird)
	GameMain.CloseObj(UIDeposit.SellControls.NoSellInfo)
	for i=1,#list,1 do
		UIDeposit.SellDataList[i] = list[i]
	end
	
	this:ShowSellListInfo()
end

function UIDeposit:ShowSellListInfo()					--显示所有能够出售的商品
	UIDeposit.Controls.SellListWrap:ResetTrans(#UIDeposit.SellDataList)
	UIDeposit.Controls.SellListWrap:GetComponent("UIPanel").clipOffset = Vector2(0,0)
	UIDeposit.Controls.SellListWrap.transform.localPosition = Vector3(0,0,0)

	for i=1,15,1  do
		local data = 
		{
			Index = i,
		}
		if UIDeposit.SellGodList[i] == nil then
			MainGameUI.CreateLittleItem(tostring(i) , "DepositSellItem" , UIDeposit.SellControls.Gird, data , this.CreateSellListCallBack , "UIDeposit") 
		else
			this:CreateSellListCallBack(UIDeposit.SellGodList[i],data)
		end 
	end
	
end

function UIDeposit:CreateSellListCallBack(_God , _Info)
	if _Info.Index == 15 then
		UIDeposit.SellControls.Gird.enabled = true
		UIDeposit.SellControls.Gird:Reposition()
		UIDeposit.Controls.SellListWrap:SetData(#UIDeposit.SellDataList , "UIDeposit")
	end
	
	local Index = _Info.Index
	UIDeposit.SellGodList[Index] = _God
	this:ShowSellItem(_God , Index)
end

function UIDeposit:ShowSellItem(_God , _Index)
	local data = UIDeposit.SellDataList[_Index]
	if data == nil then
		GameMain.CloseObj(_God)
		return
	end
	GameMain.OpenObj(_God)
	local item = DebrisPackageSys.GetDataById(data.Goods)
	local img = _God.transform:FindChild("IMG"):GetComponent("UISprite")
	local quality = _God.transform:FindChild("Quility"):GetComponent("UISprite")
	local name = _God.transform:FindChild("name"):GetComponent("UILabel")
	local price = _God.transform:FindChild("price"):GetComponent("UILabel")
	local count = _God.transform:FindChild("Count"):GetComponent("UILabel")
	count.text = tostring(item.Count)
	AtlasMsg.SetAtlas(img, item.AtlasName ,item.SpriteName)
	quality.spriteName = UIstring.ItemFg[item.Quality]
	name.text = item.nickname
	price.text = data.Price_Min .. "~" .. data.Price_Max
end

function UIDeposit:ToOpenSellProductPanel(_Index)					--打开出售竞价的界面
	local data = UIDeposit.SellDataList[_Index]
	UIDeposit.SellTmepItem = data
	GameMain.OpenObj(UIDeposit.Controls.MySellProductPanel)
	if UIDeposit.SellItemControls.Name == nil then
		this:GetSellProductControls()
	end
	this:ShowMySellItemInfo()
	this:ShowSellItemList()
end


function UIDeposit:CloseSellItemPanel()
	GameMain.CloseObj(UIDeposit.Controls.MySellProductPanel)
end

function UIDeposit:GetSellProductControls()						
	UIDeposit.SellItemControls.Name = UIDeposit.Controls.MySellProductPanel.transform:FindChild("name"):GetComponent("UILabel")
	UIDeposit.SellItemControls.Tips = UIDeposit.Controls.MySellProductPanel.transform:FindChild("des"):GetComponent("UILabel")
	UIDeposit.SellItemControls.Count = UIDeposit.Controls.MySellProductPanel.transform:FindChild("count"):GetComponent("UILabel")
	UIDeposit.SellItemControls.UIWrap = UIDeposit.Controls.MySellProductPanel.transform:FindChild("CompeteList/ListPanel"):GetComponent("UIWrap")
	UIDeposit.SellItemControls.Grid = UIDeposit.SellItemControls.UIWrap.transform:FindChild("ItemGrid"):GetComponent("UIGrid")
	
	UIDeposit.SellItemControls.SellFee = UIDeposit.Controls.MySellProductPanel.transform:FindChild("fee"):GetComponent("UILabel")
	UIDeposit.SellItemControls.SellCount = UIDeposit.Controls.MySellProductPanel.transform:FindChild("SellCount/SellNum"):GetComponent("UILabel")
	UIDeposit.SellItemControls.SellPrice = UIDeposit.Controls.MySellProductPanel.transform:FindChild("SellPrice/priceValue"):GetComponent("UILabel")
	UIDeposit.SellItemControls.SellBasicPrice = UIDeposit.Controls.MySellProductPanel.transform:FindChild("SellPrice/Basic"):GetComponent("UILabel")
end

function UIDeposit:ShowMySellItemInfo()					--显示要出售的物品的基本信息
	local debirs = DebrisPackageSys.GetDataById(UIDeposit.SellTmepItem.Goods)--708+68*2
	UIDeposit.SellItemControls.Tips.text = debirs.Description
	UIDeposit.SellItemControls.Count.text = debirs.Count .. "件"
	UIDeposit.SellItemControls.Name.text = UIstring.WordColor[debirs.Quality] .. debirs.nickname .. "[-]"
	UIDeposit.SellTempCount = 1
	UIDeposit.SellTempPrice = UIDeposit.SellTmepItem.Price_Reconmmend
	this:ShowSellCountPrice()
end

function UIDeposit:ShowSellCountPrice()						--显示出售商品的价格和数量
	UIDeposit.SellItemControls.SellCount.text = tostring(UIDeposit.SellTempCount)
	UIDeposit.SellItemControls.SellPrice.text = tostring(UIDeposit.SellTempPrice)
	UIDeposit.SellItemControls.SellBasicPrice.text = "推荐单价：".. tostring(UIDeposit.SellTmepItem.Price_Reconmmend)
	UIDeposit.SellItemControls.SellFee.text = tostring(UIDeposit.SellTempPrice *120)
end

function UIDeposit:ShowSellItemList()
	UIDeposit.SellItemDataList = {}
	local list = DepositSys.GetOthersPlayerProduct(UIDeposit.SellTmepItem.Goods)
	
	if list == nil then
		return
	end
	for i=1,#list,1  do
		UIDeposit.SellItemDataList[i] = list[i]
	end
	UIDeposit.SellItemControls.UIWrap:ResetTrans(#UIDeposit.SellDataList)
	UIDeposit.SellItemControls.UIWrap:GetComponent("UIPanel").clipOffset = Vector2(0,0)
	UIDeposit.SellItemControls.UIWrap.transform.localPosition = Vector3(0,0,0)
	for i=1,6,1  do
		local data = 
		{
			Index = i,
		}
		if UIDeposit.SellItemGodList[i] == nil then
			MainGameUI.CreateLittleItem(tostring(i) , "DepositCompleteItem" , UIDeposit.SellItemControls.Grid, data , this.CreateSellItemListCallBack , "UIDeposit") 
		else
			this:CreateSellItemListCallBack(UIDeposit.SellItemGodList[i],data)
		end 
	end
end

function UIDeposit:CreateSellItemListCallBack(_God , _Info)
	if _Info.Index == 6 then
		UIDeposit.SellItemControls.Grid.enabled = true
		UIDeposit.SellItemControls.Grid:Reposition()
		UIDeposit.SellItemControls.UIWrap:SetData(#UIDeposit.SellItemDataList , "UIDeposit")
	end
	UIDeposit.SellItemGodList[_Info.Index] = _God
	this:ShowSellCompleteItem(_God , _Info.Index)
end

function UIDeposit:ShowSellCompleteItem(_God , _Index)
	local data = UIDeposit.SellItemDataList[_Index]
	if data == nil then
		GameMain.CloseObj(_God)
		return
	end
	GameMain.OpenObj(_God)
	local img = _God.transform:FindChild("img"):GetComponent("UISprite")
	local quality = _God.transform:FindChild("quality"):GetComponent("UISprite")
	local count = _God.transform:FindChild("count"):GetComponent("UILabel")
	local name =  _God.transform:FindChild("name"):GetComponent("UILabel")
	local price = _God.transform:FindChild("price"):GetComponent("UILabel")

	AtlasMsg.SetAtlas(img , data.AtlasName , data.SpriteName)
	quality.spriteName = UIstring.ItemFg[data.Quality]
	count.text = tostring(data.ElusNum)
	name.text = UIstring.WordColor[data.Quality].. data.Name .. "[-]"
	price.text = tostring(data.SellPrice)
end

function UIDeposit:SetSellProductPrice(_Num , _Max)
	if _Max == true then
		UIDeposit.SellTempPrice =UIDeposit.SellTmepItem.Price_Max
	else
		UIDeposit.SellTempPrice = UIDeposit.SellTempPrice + _Num
		if UIDeposit.SellTempPrice >=UIDeposit.SellTmepItem.Price_Max then
			UIDeposit.SellTempPrice = UIDeposit.SellTmepItem.Price_Max
		end
		if UIDeposit.SellTempPrice <= UIDeposit.SellTmepItem.Price_Min then
			UIDeposit.SellTempPrice = UIDeposit.SellTmepItem.Price_Min
		end
	end
	this:ShowSellCountPrice()
end

function UIDeposit:SetSellProductCount(_Num , _Max)
	local count = DebrisPackageSys.GetCountById(UIDeposit.SellTmepItem.Goods)
	if _Max == true then
		UIDeposit.SellTempCount = count
	else
		UIDeposit.SellTempCount = UIDeposit.SellTempCount + _Num
		if UIDeposit.SellTempCount >= count then
			UIDeposit.SellTempCount = count
		end
		if UIDeposit.SellTempCount <= 1 then
			UIDeposit.SellTempCount = 1
		end
	end
	this:ShowSellCountPrice()
end

function UIDeposit:ToSellProduct()
	if UIDeposit.SellTempCount<=0 then
		DataUIInstance.PopTip("请选择物品数量")
		return
	end
	local item = DebrisPackageSys.GetDataById(UIDeposit.SellTmepItem.Goods)
	item.Count = item.Count - UIDeposit.SellTempCount
	DepositSys.SellProduct(UIDeposit.SellTmepItem.Goods , UIDeposit.SellTempCount , UIDeposit.SellTempPrice)
	
end

function UIDeposit:ShowSellItemCallBack()
	this:CloseSellItemPanel()
	this:ShowSellInfo()
end

--endregion

--region * 我的货架相关

function UIDeposit:ShowMyPanelInfo(_Gob)
	GameMain.CloseObj(UIDeposit.Controls.BuyInfo)
	GameMain.OpenObj(UIDeposit.Controls.MyInfo)
	GameMain.OpenObj(UIDeposit.Controls.BuyListWrap.transform.parent)
	GameMain.CloseObj(UIDeposit.Controls.SellListWrap.transform.parent)
	
	this:ShowTagInfo(_Gob)
	DepositSys.GetMySellProducts()	
end

function UIDeposit:ShowMyPanelCallBack()
	GameMain.CloseObj(UIDeposit.Controls.BuyNoInfo)
	UIDeposit.MyShelvesDataList = {}
	local list = DepositSys.GetMyProducts()
	
	if #list>0 then
		GameMain.CloseObj(UIDeposit.Controls.SellNoInfo)
		GameMain.OpenObj(UIDeposit.Controls.BuyListWrap)
		for i=1,#list,1 do
--			GameMain.Print(list[i].IsMyShelvesProduct , "true")
			UIDeposit.MyShelvesDataList[i] = list[i]
		end
		this:ShowBuyListInfo(UIDeposit.MyShelvesDataList)
	else
		GameMain.OpenObj(UIDeposit.Controls.SellNoInfo)
		GameMain.CloseObj(UIDeposit.Controls.BuyListWrap)
	end
end

function UIDeposit:ToRecMyProduct(Index)		--领取我的商品
	UIDeposit.ClickMyProductIndex = Index
	local data = UIDeposit.MyShelvesDataList[Index]
	DepositSys.ReceiveProduct(data.UUID)
end

function UIDeposit:ToDownMyProduct(Index)		--下架我的商品
	UIDeposit.ClickMyProductIndex = Index
	local data = UIDeposit.MyShelvesDataList[Index]
	DepositSys.RemoveProduct(data.UUID)
	DataUIInstance.PopTip("下架成功，物品进入背包")
end

function UIDeposit:ControlMyProductAfter()
	local id = UIDeposit.MyShelvesDataList[UIDeposit.ClickMyProductIndex].Dbid
	local item = ItemPackageSys.GetItemById(id)
	if item ~= nil then
		item.Count = item.Count - UIDeposit.MyShelvesDataList[UIDeposit.ClickMyProductIndex]:GetMyCount()
	end
	
	table.remove(UIDeposit.MyShelvesDataList , UIDeposit.ClickMyProductIndex)
	
	if #UIDeposit.MyShelvesDataList>0 then
		GameMain.CloseObj(UIDeposit.Controls.SellNoInfo)
		GameMain.OpenObj(UIDeposit.Controls.BuyListWrap)
		this:ShowBuyListInfo(UIDeposit.MyShelvesDataList)
	else
		GameMain.OpenObj(UIDeposit.Controls.SellNoInfo)
		GameMain.CloseObj(UIDeposit.Controls.BuyListWrap)
	end
	this:ShowGoldInfo()
end
--endregion

function UIDeposit:UpdateItem(_LuaName , _Item)
	local parentName = _Item.transform.parent.name
	if parentName == "BuyGrid" then
		local index = tonumber(_Item.name)
		UIDeposit.BuyGodList[index] = _Item
		local data = nil	
		if UIDeposit.ClickBuyTag == 1 then
			data = UIDeposit.BuyAllServeProducts[index]
			this:ShowBuyItem(_Item , data)
		end
	end 

	if parentName == "SellGrid" then
		local index = tonumber(_Item.name)
		UIDeposit.SellGodList[index] = _Item
		this:ShowSellItem(_Item , index)
	end

	if parentName == "ItemGrid" then
		local index = tonumber(_Item.name)
		UIDeposit.SellItemGodList[index] = _Item
		this:ShowSellCompleteItem(_Item , index)
	end
end

function UIDeposit:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
	if _Gob.name == "CloseBtn" then
		this:ClosePanel()
	end

	if _Gob.name == "BuyTag" then
		this:ShowCurBuyWebInfo()
	end

	if _Gob.name == "SellTag" then
		this:ShowSellPanelInfo(_Gob)
	end
	
	if _Gob.name == "MyGoodTag" then
		this:ShowMyPanelInfo(_Gob)
	end
	
	if _Gob.name == "ChooseTypeBtn" then
		this:ShowChooseBuyType()
	end

	if _Gob.name == "ChooseClassBtn" then
		this:ShowChooseBuyClass()
	end
	
	if _Gob.name == "choose" then
		local parentName = _Gob.transform.parent.name
		if parentName == "allWeb" then
			UIDeposit.ClickBuyTag = 1
		end
		if parentName == "myWeb" then
			UIDeposit.ClickBuyTag = 2
		end
		this:ShowChooseWebInfo()
	end
	if _Gob.name == "BuyProductBtn" then
		local index = tonumber(_Gob.transform.parent.name)
		this:ToBuyProduct(index)
	end

	local key = tonumber(_Gob.name)
	if key~=nil then
		local parentName = _Gob.transform.parent.name
		if parentName == "ChoseTypeGrid" then
			this:ToChooseBuyType(key)
		end
		if parentName == "ChoseClassGrid" then
			this:ToChooseBuyClass(key)
		end
	end
	if _Gob.name == "choseTypePanel" then
		this:CloseBuyTypePanel()
	end
	if _Gob.name == "choseClassPanel" then
		this:CloseBuyClassPanel()
	end

	if _Gob.name == "BuyBtn" then
		local index = tonumber(_Gob.transform.parent.name)
		this:ToBuyProduct(index)
	end
	if _Gob.name == "SellBtn" then
		local index = tonumber(_Gob.transform.parent.name)
		this:ToOpenSellProductPanel(index)
	end

	if _Gob.name == "CloseMySellPanel" then
		this:CloseSellItemPanel()
	end

	if _Gob.name == "addCountBtn" then
		this:SetSellProductCount(1)
	end
	if _Gob.name == "subCountBtn" then
		this:SetSellProductCount(-1)
	end
	if _Gob.name == "addPriceBtn" then
		this:SetSellProductPrice(1)
	end
	if _Gob.name == "subPriceBtn" then
		this:SetSellProductPrice(-1)
	end
	if _Gob.name == "sellPriceMax" then
		this:SetSellProductPrice(1,true)
	end
	if _Gob.name == "sellCountMax" then
		this:SetSellProductCount(1,true)
	end
	if _Gob.name == "ToSellBtn" then
		this:ToSellProduct()
	end

	if _Gob.name == "DownMyItemBtn" then
		local index = tonumber(_Gob.transform.parent.name)
		this:ToDownMyProduct(index)
	end

	if _Gob.name == "RecMyItemBtn" then
		local index = tonumber(_Gob.transform.parent.name)
		this:ToRecMyProduct(index)
	end

	if _Gob.name == "RechargeBtn" then
		DataUIInstance.OpenRecharge()
	end

	if _Gob.name == "maxBuyCount" then
		this:ChangeBuyProductCount(1 ,true)
	end
	if _Gob.name == "subBuyCount" then
		this:ChangeBuyProductCount(-1 ,false)
	end
	if _Gob.name == "addBuyCount" then
		this:ChangeBuyProductCount(1 ,false)
	end
	if _Gob.name == "ConfirmBuy" then
		this:BuyCountProduct()
	end
	if _Gob.name == "BuyCountPanelBlackBg" then
		this:CloseBuyProductPanel()
	end
end

function UIDeposit:ClosePanel()				--关闭寄售行界面
	GameMain.CloseObj(UIDeposit.DepositGod)
end

function UIDeposit:ReleasPanel()
	--UI
	UIDeposit.DepositGod = nil

	UIDeposit.ClickTag = nil

	UIDeposit.Controls = {}

	UIDeposit.BuyGodList = {}	
	UIDeposit.BuyClassGodList = {}		--购买的类型标签
	UIDeposit.BuyTypeGodlist = {}		--购买的类型标签
	UIDeposit.SellControls = {}			
	UIDeposit.SellGodList = {}

	UIDeposit.SellItemGodList = {}		--上架出售的玩家的godlist
	UIDeposit.SellItemControls = {}	
	UIDeposit.BuyControls = {}			--购买的控件	
	--Data
	UIDeposit.BuyTypeTagName =				--购买的标签名
	{
		[1] = "装备",
	}
	UIDeposit.BuyMyTagName = 
	{
		[1] = "全部",
		[2] = "装备"
	}

	UIDeposit.BuyTypeDataList = {}		--标签下的所有的Class

	UIDeposit.ClickBuyType = 0			--点击购买的类型
	UIDeposit.ClickBuyClass = 0			--点击购买的具体商品

	UIDeposit.BuyAllServeProducts = {}	--全服的数据
	UIDeposit.BuyMyServeProducts = {}	--本服的数据

	UIDeposit.ClickBuyTag = 1			--1 全服 2 本服

	UIDeposit.ClickBuyIndex = 0			--点击购买的那个index

	UIDeposit.SellDataList = {}			--出售的商品数据

	UIDeposit.SellItemDataList = {}
	UIDeposit.SellTmepItem = nil		--要出售的临时商品

	UIDeposit.SellTempPrice = 0			--出售商品的价格
	UIDeposit.SellTempCount = 0			--出售商品的数量

	UIDeposit.MyShelvesDataList = {}	--我的上架商品

	UIDeposit.ClickMyProductIndex = 0		--我的上架商品Index

	UIDeposit.BuyTempProduct = nil			--购买的商品
	UIDeposit.BuyProductCount = 0			--购买商品的数量
end

function UIDeposit:ReleasData()
	DepositSys.AllProducts = {}				--全服所有的道具
	DepositSys.MyProducts = {}				--本服的所有商品
	DepositSys.MyShelvesProducts = {}		--我上架的所有商品

	DepositSys.BuyTempId = ""				--购买的临时uuid
	DepositSys.BuyTagTitleDataList = {}		--购买的标签list
	DepositSys.BuyTagNumDataList = {}		--不同type下的class数量

	DepositSys.BuyTypeProductsList = {}		--不同种类的商品
	DepositSys.BuyTypeMyProductList = {}	--不同种类的本服商品

	DepositSys.BuyTypeIsNeedGetList = {}	--是否需要重新获取不同种类的商品

	DepositSys.SellProductList = {}			--出售的商品的数据
end

return UIDeposit
--endregion
