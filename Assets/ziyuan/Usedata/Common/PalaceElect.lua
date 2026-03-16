--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
PalaceElect = {}											--人物属性基类
PalaceElect.__index = PalaceElect
PalaceElect.Dbid = ""			--玩家的ID
PalaceElect.OwnCount =	0		--玩家获得的票数 
PalaceElect.CreateTime = 0		--武将进入的时间
PalaceElect.VipLvl = 0			--玩家VIP等级
PalaceElect.Name = ""			--玩家姓名

function PalaceElect:new(o)
    o=o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function PalaceElect:Init(_Id , _Num , _Lvl , _CreateTime , _Name)
	self.Dbid = _Id
	self.OwnCount = _Num
	self.VipLvl = _Lvl
	self.CreateTime = _CreateTime
	self.Name = _Name
	
end


return PalaceElect

--endregion
