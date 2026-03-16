--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
Recharge = {}											
Recharge.__index = Role

Recharge.Dbid = 0		--购买的ID
Recharge.Type = 0		--购买的类型
Recharge.Diamond = 0	--购买的元宝数目
Recharge.Price = 0		--购买需要的花费
Recharge.Description = ""	--描述
Recharge.Name = ""		--名字
Recharge.AppStore_Id = ""	--支付的ID	
Recharge.FirstRechargeBonus = 0	--首充获得额外的奖励数目
Recharge.OtherRechargeBonus = 0	--不是首充获得额外的奖励数目

Recharge.Count = 0		--充值的次数
Recharge.AtlasName = ""
Recharge.SpriteName = ""

function  Recharge:new(o)
    o=o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function Recharge:Init(_Data )
	self.Dbid = _Data.Id
	self.Type = _Data.Type
	self.Diamond = _Data.Diamond
	self.Price = _Data.Price
	self.Description = _Data.Description
	self.Name = _Data.Name
	self.AppStore_Id = _Data.AppStore_Id
	self.FirstRechargeBonus = _Data.First_Recharge_Bonus
	self.OtherRechargeBonus = _Data.Other_Recharge_Bonus
	self.AtlasName = _Data.AtlasName
	self.SpriteName = _Data.SpriteName
	self.Count = 0
end


function Recharge:SetTimes(_Count)
	self.Count = _Count
end
return Recharge
--endregion
