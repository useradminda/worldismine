--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
DepositItem = {}
DepositItem.__index = DepositItem

DepositItem.UUID = ""
DepositItem.Dbid = 0
DepositItem.PlayerId = ""
DepositItem.TotalNum = 0		--
DepositItem.ElusNum = 0			--剩余数量
DepositItem.SellPrice = 0		--出售价格
	
DepositItem.PlayerName = ""		--玩家名字
DepositItem.ExpireTime = 0		--过期时间
DepositItem.ServeId = ""		--服务器ID

--DepositItem.BasicPrice = 0	
DepositItem.Name = ""			--商品名
DepositItem.Description = ""	--商品描述
DepositItem.AtlasName = ""
DepositItem.SpriteName = ""
DepositItem.Quality = 0			--品质

DepositItem.Type = 0			--
DepositItem.Class = ""			--类型

DepositItem.IsMyShelvesProduct = 0	--是否是我上架的商品 0 否，1 是
DepositItem.SellCount = 0

DepositItem.WebInitData = nil

function DepositItem:new(o)
    o=o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function DepositItem:Init(_Data , _IsMy)

	self.WebInitData = _Data
	
	local id = tostring(_Data["_id"]["$id"])
	self.UUID = id
	local playerId = tostring(_Data["playerID"])
	self.PlayerId = playerId
	local debirsId = tonumber(_Data["debrisID"])
	self.Dbid = debirsId
	local totalNum = tonumber(_Data["totalQtt"])
	self.TotalNum = totalNum
	local elusNum = tonumber(_Data["leftQtt"])
	self.ElusNum = elusNum
	local price = tonumber(_Data["price"])
	self.SellPrice = price
	local name = tostring(_Data["name"])
	self.PlayerName = name
	local expire = tonumber(_Data["expire"])
	self.ExpireTime = expire

	local srvId = tostring(_Data["srvID"])
	self.ServeId = srvId

	self.SellCount = 0
	self.IsMyShelvesProduct = _IsMy
	self:SetBasicInfo()
end

function DepositItem:GetDelTime()
	local curTime = ClinetInfomation.WorldTime
	if curTime<self.ExpireTime then
		local delTime = self.ExpireTime - curTime
		local time = delTime/3600
		return math.ceil(time)
	end
	return 0
end

function DepositItem:IsOverTime()			--是否已经过期
	local curTime = ClinetInfomation.WorldTime
	if curTime>=self.ExpireTime then
		return true
	end
	return false
end

function DepositItem:SetBasicInfo()
	local data = DebrisConfig.GetDebrisById(self.Dbid)
	if data~=nil then
		self.Name = data.Name
		self.AtlasName = data.AtlasName
		self.SpriteName = data.SpriteName
		self.Quality = data.Quality
		self.Description = data.Description
	end
	local basicData = ConsignmentConfig.GetDataById(self.Dbid)
	if basicData~=nil then
		self.Type = basicData.Type
		self.Class = basicData.Type .."_"..basicData.Class
	end
end

function DepositItem:IsSell()			--是否已经出售了
	if self.ElusNum < self.TotalNum then
		return true
	else
		return false
	end
end

function DepositItem:SetSellCount()
	self.SellCount = self.TotalNum - self.ElusNum
end

function DepositItem:GetMyCount()
	local num = self.TotalNum
	if self.TotalNum > self.ElusNum then
		return self.ElusNum
	else
		return num
	end
end

return DepositItem
--endregion
