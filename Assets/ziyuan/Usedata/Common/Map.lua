Map = {}                                                                        --副本关卡类

local this = Map
Map.__index = Map

function  Map:new(o)
    o=o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

Map.DBid = 0                                                                      --副本ID
Map.Name = nil
Map.Descrip = nil
Map.Config = nil
Map.BattleType = nil                                                            --副本类型 1 普通 3Boss
Map.Chapter_Id = 0                                                                 --第几章
Map.Icon = nil                                                                  --副本的前框
Map.Need_Sta = 0                                                                --需要的体力
Map.Need_Lvl = 0                                                                --需要的等级
Map.Day_Times = 0                                                               --一天可以挑战次数
Map.Reward = nil                                                                --副本奖励

Map.Turn = 0                                                                    --当前第几关
Map.Star = 0                                                                    --副本当前星级
Map.FightTimes = 0                                                              --已经挑战次数
Map.LeftTimes = 0                                                               --剩余挑战次数

Map.MapTotalTime = 0                                                            --关卡可消耗的总时间

Map.MapData = nil                                                               --数据库表
Map.Music = nil                                                                 --关卡播放什么音乐

function Map:InitSome(_MapData)

    self.MapData = _MapData
    self.DBid = _MapData.DBid
    self.Name = _MapData.Name
    self.Descrip = _MapData.Descrip
    self.Config = _MapData.Config
    self.BattleType = _MapData.Type                                         --副本类型 3 普通 4精英
    self.Chapter_Id = _MapData.Chapter_Id                                             --第几章
    self.Icon = _MapData.Icon                                                     --副本的前框
    self.Need_Sta = _MapData.Need_Sta                                             --需要的体力
    self.Need_Lvl = _MapData.Need_Lvl                                             --需要的等级
    self.Day_Times = _MapData.Day_Times                                           --一天可以挑战次数
    self.Reward = _MapData.Reward                                                 --关卡奖励
    self.Music = _MapData.Music
    self.Turn = _MapData.Turn
end

return Map