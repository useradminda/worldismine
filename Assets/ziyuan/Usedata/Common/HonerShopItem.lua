--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
HonerShopItem = {}
HonerShopItem.__index = HonerShopItem
HonerShopItem.NeedHoner = 0	--需要的荣誉值

HonerShopItem.GoodsId = 0		--获得的奖励id
HonerShopItem.Dbid = 0
HonerShopItem.BuyCount = 1	--购买的数量
HonerShopItem.Type = 1		--类型 1 装备 2 item
HonerShopItem.RewardData = nil

function HonerShopItem:new(o)
    o=o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function HonerShopItem:Init(_Data)
	self.Dbid = _Data.Id
	self.Type = _Data.Type
	self.BuyCount =1
	self.NeedHoner = _Data.NeedHonor
	self.GoodsId = _Data.GoodsId
	self:SetRwdInfo()
end

function HonerShopItem:SetRwdInfo()
	if self.Type == 1 then
		local data = EquipDataConfig.GetEquipDBConfig(self.GoodsId)
		self.RewardData = data
	end
	if self.Type == 2 then
		local data = ItemDataConfig.GetItemDBConfig(self.GoodsId)
		self.RewardData = data
	end
end

function HonerShopItem:SetBuyCount(_Count)
	self.BuyCount = _Count
end

function HonerShopItem:AddCount(_Add)
	self.BuyCount = self.BuyCount + _Add
	if self.BuyCount <= 1 then
		self.BuyCount = 1
	end
end

function HonerShopItem:GetAllPrice()
	local value = self.BuyCount *self.NeedHoner
	return value
end

return HonerShopItem
--endregion
