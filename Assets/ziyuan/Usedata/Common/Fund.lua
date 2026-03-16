--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
Fund = {}
Fund._index = Fund

Fund.Lvl = 0
Fund.Restore = 0

Fund.IsRwd = false --是否领取了奖励

function  Fund:new(o)
    o=o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function Fund:Init(_Data)
	self.Lvl = _Data.Lvl
	self.Restore = _Data.Restore

	self.IsRwd = false
end

function Fund:SetIsRwd(IsRecived)
	self.IsRwd = IsRecived
end

return Fund
--endregion
