--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
HeroShop = {}
HeroShop.__index = HeroShop

HeroShop.Name = ""		
HeroShop.NeedPrice = 0	--需要的金钱
HeroShop.Dbid = 0
HeroShop.Reward = 0		--获得的奖励

HeroShop.BuyCount = 1	--购买的数量
HeroShop.Type = 1		--类型 1 武将 2 将魂

HeroShop.AtlasName = ""
HeroShop.SpriteName = ""
HeroShop.Count = 0
HeroShop.Quality = 1
HeroShop.Name = ""

function HeroShop:new(o)
    o=o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function HeroShop:Init(_Data)
	self.Type = _Data.Type
	self.BuyCount =1
	self.Name = _Data.Name
	self.NeedPrice = _Data.NeedPrice
	self.Dbid = _Data.Id
	self.Reward = _Data.Reward
	self:SetBasicValue()
end

function HeroShop:SetBasicValue()
	if self.Type == 1 then
		local heroData = RoleDataConfig.GetRoleById(self.Reward)
		self.AtlasName = heroData.AtlasName
		self.SpriteName = heroData.SpriteName
		self.Quality = heroData.Quality
		self.Name = heroData.Name
	end
	if self.Type == 2 then
		local hunData = DebrisConfig.GetDebrisById(self.Reward)
		self.AtlasName = hunData.AtlasName
		self.SpriteName = hunData.SpriteName
		self.Quality = hunData.Quality
		self.Name = hunData.Name
	end
	self.Count = self.BuyCount
end

function HeroShop:SetBuyCount(_Count)
	self.BuyCount = _Count
	self.Count = _Count
end

return HeroShop
--endregion
