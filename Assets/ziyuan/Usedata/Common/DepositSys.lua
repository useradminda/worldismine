--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
DepositSys = {}
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

function DepositSys.GetAllWebProducts()				--请求全服的商品数据
	local info = nil
	WebEvent.MarketAllProduct(info , "DepositSys.GetAllWebProductsCallBack" , DepositSys.GetAllWebProductsCallBack)	
end

function DepositSys.GetAllWebProductsCallBack(data , returnId)
	local UIDepositTar = MainGameUI.FindPanelTarget("UIDeposit")
	if UIDepositTar ~= nil then
		UIDepositTar:ShowBuyPanelInfoCallBack()
	end
end

function DepositSys.GetMySellProducts()					--请求我上架的数据
	local info = nil
	WebEvent.MarketMyProduct(info , "DepositSys.GetMySellProductsCallBack" , DepositSys.GetMySellProductsCallBack)
end

function DepositSys.GetMySellProductsCallBack(data , returnId)
	local UIDepositTar = MainGameUI.FindPanelTarget("UIDeposit")
	if UIDepositTar ~= nil then
		UIDepositTar:ShowMyPanelCallBack()
	end
end

function DepositSys.SellProduct(_Id , _Count , _Price)				--出售商品
	local info = _Id .. "," .. _Count .. "," .. _Price
	WebEvent.MarketSellProduct(info , "DepositSys.SellProductCallBack" ,DepositSys.SellProductCallBack)
end

function DepositSys.SellProductCallBack(data , returnId)
	local UIDepositTar = MainGameUI.FindPanelTarget("UIDeposit")
	if UIDepositTar ~= nil then
		UIDepositTar:ShowSellItemCallBack()
	end
end

function DepositSys.ReceiveProduct(_Id)							--领取商品
	local info = _Id
	WebEvent.MarketReceiveMoney(info , "DepositSys.ReceiveProductCallBack" , DepositSys.ReceiveProductCallBack)
end

function DepositSys.ReceiveProductCallBack(data , returnId)
	local UIDepositTar = MainGameUI.FindPanelTarget("UIDeposit")
	if UIDepositTar ~= nil then
		UIDepositTar:ControlMyProductAfter()
	end 
end

function DepositSys.RemoveProduct(_Id)							--下架商品
	local info = _Id
	WebEvent.MarketRemoveProduct(info , "DepositSys.RemoveProductCallBack" , DepositSys.RemoveProductCallBack)
end

function DepositSys.RemoveProductCallBack(data , returnId)
	local UIDepositTar = MainGameUI.FindPanelTarget("UIDeposit")
	if UIDepositTar ~= nil then
		UIDepositTar:ControlMyProductAfter()
	end
end

function DepositSys.BuyProduct(_Id , _Count)					--购买商品
	
	local info = _Id .. "," .. _Count
	DepositSys.BuyTempId = _Id
	WebEvent.MarketBuyProduct(info , "DepositSys.BuyProductCallBack" , DepositSys.BuyProductCallBack)
end

function DepositSys.BuyProductCallBack(data , returnId)
	local UIDepositTar = MainGameUI.FindPanelTarget("UIDeposit")
	if UIDepositTar~=nil then
		local data = DepositSys.GetProductById(DepositSys.BuyTempId)
		UIDepositTar:ShowBuyProductCallBack(data)
	end
end

function DepositSys.GetTypeAllProducts(_Type , _Class)			--得到不同类型的全服商品数据
	local class = _Type .. "_" .. _Class

--	local data = DepositSys.BuyTypeProductsList[class]
--	if data~=nil then
--		return data
--	end
	local list = {}
	for key,value in pairs(DepositSys.AllProducts) do
		if value.Class == class then
			table.insert(list , #list +1, value)
		end
	end
	DepositSys.BuyTypeProductsList[class] = list
	return DepositSys.BuyTypeProductsList[class]
end

function DepositSys.GetTypeMyProducts(_Type , _Class)			--得到不同类型的本服商品数据
	local class = _Type .. "_" .. _Class
	if _Class == 0 then
		class = _Type
	end
--	local data = DepositSys.BuyTypeMyProductList[class]
--	if data~=nil then
--		return data
--	end
	local list = {}
	for key,value in pairs(DepositSys.MyProducts) do
		if _Class == 0 then
			if value.Type == class then
				table.insert(list , #list +1, value)
			end
		else
			if value.Class == class then
				table.insert(list , #list +1, value)
			end
		end
		
	end
	DepositSys.BuyTypeMyProductList[class] = list
	return DepositSys.BuyTypeMyProductList[class]
end

function DepositSys.GetBuyAllTag(_Type)				--根据type获得所有的标签
	if DepositSys.BuyTagTitleDataList[_Type]~=nil then
		return DepositSys.BuyTagTitleDataList[_Type]
	end
	local allData = ConsignmentConfig.GetAllDBData()
	local list = {}
	for key,value in pairs(allData) do
		if value.Type == _Type then
			table.insert(list , #list+1, value)
		end
	end
	
	table.sort(list , DepositSys.CompTag)
	local otherList = {}
	for i=1,#list,1 do
		otherList[i] = list[i].TitleName
	end
	DepositSys.BuyTagTitleDataList[_Type] =	otherList
	return DepositSys.BuyTagTitleDataList[_Type]
end

function DepositSys.CompTag(A , B)
	if A == nil then
		return false
	end
	if B == nil then
		return false
	end
	if A.Class < B.Class then
		return true
	end
	if A.Class == B.Class then
		return true
	end
	if A.Class > B.Class then
		return false
	end
end

function DepositSys.SetAllProducts()					--排序全服所有的数据
	
end

function DepositSys.Comp(A , B)
	if A == nil then
		return false
	end
	if B == nil then
		return false
	end
	if A.SellPrice > B.SellPrice then
		return true
	end
	if A.SellPrice < B.SellPrice then
		return false
	end
	if A.SellPrice == B.SellPrice then
		return false
	end
end

function DepositSys.GetMyServeProducts()				--得到本服的数据
	local allList = DepositSys.AllProducts

	local list = {}
	for key,value in pairs(allList) do
		if value.ServeId == ClinetInfomation.ServeID then
			table.insert(list , #list+1 , value)
		end
	end
	DepositSys.MyProducts = list
	return DepositSys.MyProducts
end


function DepositSys.SetProducts(_Data)						--设置全服所有的商品
	local _IsDelet = tonumber(_Data["isDelete"])
	local _Id = tostring(_Data["_id"]["$id"])
	if _IsDelet~=nil then
		DepositSys.RemoveProduct(_Id)
	else
		local item = DepositSys.CreateItem(_Data , 0)
		DepositSys.AllProducts[_Id] = item
	end
end

function DepositSys.CreateItem(_Data , _IsMy)
	local lua = GameMain.requireLuaFile("DepositItem")
	local depositbaby = lua:new()
	depositbaby:Init(_Data , _IsMy)
	return depositbaby
end

function DepositSys.RemoveProducts(_ID)			
	DepositSys.AllProducts[_ID] = nil
end

function DepositSys.RemoveMyShelvesProducts(_Id)
	DepositSys.MyShelvesProducts[_Id] = nil
end

function DepositSys.IsHasPrductById(_ID)
	local isHas = DepositSys.AllProducts[_ID]
	if isHas~=nil then
		return true
	else
		return false
	end
end

function DepositSys.GetProductById(_ID)					--通过ID找到相应的商品
	local isHas = DepositSys.IsHasPrductById(_ID)
	if isHas == true then
		return DepositSys.AllProducts[_ID]
	end
	return nil
end

function DepositSys.GetAllProductsInfoCallBack(_Data)
	if _Data~=nil then
		DepositSys.AllProducts = {}
		for key,value in pairs(_Data) do
			if tonumber(key)~=nil then
				DepositSys.SetProducts(value)
			end
		end
		table.sort(DepositSys.AllProducts , DepositSys.Comp)
	end
end


function DepositSys.GetCanSellProducts()			--得到可以出售的商品
	local list = ConsignmentConfig.GetAllDBData()
	local myList = {}
	for key,value in pairs(list) do
		local item = DebrisPackageSys.GetDataById(key)
		if item ~=nil and item.Count>0 then
			table.insert(myList , #myList +1 ,value)
		end
	end
	return myList
end


function DepositSys.GetOthersPlayerProduct(_ID)		--得到所有玩家的指定商品
--	if DepositSys.SellProductList[_ID]~=nil then
--		return DepositSys.SellProductList[_ID]
--	end
	local list = {}
	for key,value in pairs(DepositSys.AllProducts) do
		if value.Dbid == _ID then
			table.insert(list,#list+1,value)
		end
	end
	DepositSys.SellProductList[_ID] = list
	return list
end


function DepositSys.GetMyProductsInfoCallBack(_Data)		--得到我的货架的所有商品
	if _Data ~= nil then
		for key,value in pairs(_Data) do
			if tonumber(key)~=nil then
				DepositSys.SetMyShelvesProducts(value)
			end
		end
	end
end

function DepositSys.SetMyShelvesProducts(_Data)					--设置我上架的商品
	local _IsDelet = tonumber(_Data["isDelete"])
	local _Id = tostring(_Data["_id"]["$id"])
	if _IsDelet~=nil then
		DepositSys.RemoveMyShelvesProducts(_Id)
	else
		local item = DepositSys.CreateItem(_Data , 1)
		DepositSys.MyShelvesProducts[_Id] = item
	end
end

function DepositSys.GetMyProducts()
	local list = {}
	for key,value in pairs(DepositSys.MyShelvesProducts) do
		table.insert(list, #list +1 ,value)
		local isSell = value:IsSell()
		if isSell == true then
			local lua = GameMain.requireLuaFile("DepositItem")
			local obj1 = lua:new()
			obj1:Init(value.WebInitData , 1)
			obj1:SetSellCount()
			if value.ElusNum == 0 then
				table.remove(list,#list)
			end
			table.insert(list, #list+1 , obj1)
		end
	end
	return list
end

return DepositSys
--endregion
