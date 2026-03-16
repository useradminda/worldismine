BattleFlag = {}											--人物属性基类
BattleFlag.__index = BattleFlag

BattleFlag.BattleFlagData = nil								--人物数据库信息
BattleFlag.Dbid = 0
BattleFlag.Name = ""								   --装备名称
BattleFlag.AtlasName = ""                               --装备Atlas
BattleFlag.SpriteName = ""                              --装备Sprite
BattleFlag.BattleFlagType = 0                      --装备类型
BattleFlag.Lvl = 0
BattleFlag.Quality = 0                                  --装备品质
BattleFlag.Descrip = ""
--BattleFlag.IsOn = 0                                  --0表示没有被穿 1 表示被穿
BattleFlag.Quality = 0
BattleFlag.Series = 0                                   --系别 1 天罚 2 鼓舞 3 强壮
BattleFlag.Type = 0                                     --类型 1 弓 2 盾 3 枪

BattleFlag.Count = 0
BattleFlag.Prop = 
{
    Hp = 0,
    Attack = 0,
    Reduction = 0, 
}


function  BattleFlag:new(o)
    o=o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function BattleFlag:Init(_BattleFlagDB , _Cout)
   
    self:SetData(_BattleFlagDB)
    self.Count = _Cout
end

function BattleFlag:SetData(_BattleDB)
    
   self.Dbid = _BattleDB.Id 
   self.Descrip = _BattleDB.Description
   self.Series = _BattleDB.Series
   self.Type = _BattleDB.Type
   self.Name = _BattleDB.Name
   self.AtlasName = _BattleDB.AtlasName
   self.SpriteName = _BattleDB.SpriteName
   self.Lvl = _BattleDB.Lvl
   self.Quality = _BattleDB.Quality
   self.Prop =
   {
      Hp = _BattleDB.HP,
      Attack = _BattleDB.Attack,
      Reduction = _BattleDB.Reduction,
   }
end

function BattleFlag:SetSeriesIcon(_Series)
   
end

--[[function BattleFlag:UpFlag()
   BattleFlagSys.UpBattleFlag(self)
end--]]

--[[function BattleFlag:DownFlag()
   --BattleFlagSys.DownFlag(self)
end--]]


return BattleFlag