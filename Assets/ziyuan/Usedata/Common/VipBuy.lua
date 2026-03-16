--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
VipBuy = {}
VipBuy.__index = VipBuy

VipBuy.Dbid = 0			--ID
VipBuy.VipExp = 0		--达到这个经验值可以领取
VipBuy.Price = 0		--花费
VipBuy.TotalTimes = 0	--购买总次数
VipBuy.HasBuyTimes =0	--已经购买的次数
VipBuy.Reward = 0		--奖励
VipBuy.DesCription = ""	--描述
VipBuy.ShowName = 0		--是否显示名字
VipBuy.Count = 0		--购买次数
VipBuy.UseId = 0		--是否可以使用VIP抽奖
VipBuy.ShowOrder = 0	--显示的第几个
VipBuy.AppStoreId = ""	--购买的appid

function VipBuy:new(o)
    o=o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function VipBuy:Init(_Data)
	self.Dbid = _Data.Id
	self.VipExp = _Data.Exp
	self.Price = _Data.Price
	self.TotalTimes = _Data.Times
	self.Reward = _Data.Reward
	self.DesCription = _Data.Description
	self.ShowName = _Data.Show_Name
	self.UseId = _Data.UseId
	self.ShowOrder = _Data.ShowOrder
	self.AppStoreId = _Data.AppStore_Id
end

function VipBuy:BuyDiamoned()
	VipSys.BuyVipGoods(self.Dbid)
end

function VipBuy:SetBuyCount(_Count)
	self.Count = _Count
end

return VipBuy
--endregion
