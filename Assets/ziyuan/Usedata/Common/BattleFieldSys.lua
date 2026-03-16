BattleFieldSys = {}
BattleFieldSys.BattleFieldList = {}                --沙场点兵 带兵
BattleFieldSys.BattleHeroList = {}                 --斗将台  不带兵
BattleFieldSys.BattleFieldTopList = {}             --排名前五
BattleFieldSys.BattleHeroTopList = {}             --排名前五
BattleFieldSys.MyBattleFieldRank = 0
BattleFieldSys.MyBattleHeroRank = 0
BattleFieldSys.BattleFieldType = 0
BattleFieldSys.TempPlayerInfo = nil
BattleFieldSys.BattleFieldTime = 0
BattleFieldSys.BattleHeroTime = 0

function BattleFieldSys.RequestBFList()
   WebEvent.RequestBattleField(nil , "BattleFieldSys.RequestBFListCallBack" , BattleFieldSys.RequestBFListCallBack)
end

function BattleFieldSys.RequestBFListCallBack(data , returnId)
   if returnId==0 then
      --GameMain.Print(BattleFieldSys.BattleFieldList)
       local UIBattleFieldTar = MainGameUI.FindPanelTarget("UIBattleField")
       if UIBattleFieldTar~=nil then
          UIBattleFieldTar:CreateModels()--CreateHeroItems()
          UIBattleFieldTar:CreateHeroItems()
          UIBattleFieldTar:SetMyRank()
          UIBattleFieldTar:SetTime()
       end
   end
end

function BattleFieldSys.RequestBHList()
   WebEvent.RequestBattleHero(nil , "BattleFieldSys.RequestBHListCallBack" , BattleFieldSys.RequestBHListCallBack)
end

function BattleFieldSys.RequestBHListCallBack(data , returnId)
   if returnId==0 then     
       local UIBattleFieldTar = MainGameUI.FindPanelTarget("UIBattleField")
       if UIBattleFieldTar~=nil then
          UIBattleFieldTar:CreateModels()--CreateHeroItems()
          UIBattleFieldTar:CreateHeroItems()
          UIBattleFieldTar:SetMyRank()
          UIBattleFieldTar:SetTime()
       end
   end
end

--********************************沙场点兵
BattleFieldSys.PlayerId = 0
function BattleFieldSys.BattleFieldFight(_PlayerId)        --沙场点兵打架
   BattleFieldSys.PlayerId = _PlayerId
   local _info = tostring(_PlayerId)
   WebEvent.StartBattleField(_info , "BattleFieldSys.BattleFieldFightCallBack" , BattleFieldSys.BattleFieldFightCallBack)
end

function BattleFieldSys.BattleFieldFightCallBack(data , returnId)        --沙场点兵打架回调
   if returnId == 0 then
      GameMain.EnterPvpBattle()
      --BattleFieldSys.BattleFieldOver(1 , nil)
   end
end

BattleFieldSys.RewardList = nil
BattleFieldSys.Win = nil
function BattleFieldSys.BattleFieldOver(_Win , _SpriteFather)       --沙场点兵结束
   if _SpriteFather~=nil then
      _SpriteFather.gameObject:SetActive(true)
   end
   BattleFieldSys.RewardList = _SpriteFather
   BattleFieldSys.Win = _Win
   local _Result = 0
   if _Win==1 then
      _Result = _Win
   end
   if _Win == -1 then
      _Result = 0
   end

   local _info = tostring(BattleFieldSys.PlayerId)..","..tostring(_Result)
   WebEvent.OverBattleField(_info , "BattleFieldSys.BattleFieldOverCallBack" , BattleFieldSys.BattleFieldOverCallBack)
end

function BattleFieldSys.BattleFieldOverCallBack(data , returnId)
  if returnId == 0 then
     if BattleFieldSys.RewardList==nil then
         return
      end

      RewardContentSys.ShowFightOver(BattleFieldSys.RewardList , data , BattleFieldSys.Win)

     
  elseif returnId == 1 then

  end
end

function BattleFieldSys.GetBattleFieldReward()                      --领取沙场点兵俸禄
   local _info = nil
   WebEvent.GetBattleFieldReward(_info , "BattleFieldSys.GetBattleFieldRewardCallBack" , BattleFieldSys.GetBattleFieldRewardCallBack)
end

function BattleFieldSys.GetBattleFieldRewardCallBack(data , returnId)
   if returnId==0 then
      DataUIInstance.PopTip("L8")
   elseif returnId == 1 then
      DataUIInstance.PopTip("U9")
   end
end

--****************************斗奖台
function BattleFieldSys.BattleHeroFight(_PlayerId)          --斗将台打架 
   BattleFieldSys.PlayerId = _PlayerId
   local _info = tostring(_PlayerId)
   WebEvent.StartBattleHero(_info , "BattleFieldSys.BattleHeroFightCallBack" , BattleFieldSys.BattleHeroFightCallBack)
end

function BattleFieldSys.BattleHeroFightCallBack(data , returnId)          --斗将台打架 回调
   if returnId == 0 then
      GameMain.EnterPvpBattle()
     -- BattleFieldSys.BattleHeroOver(1 , nil)
   end
end

function BattleFieldSys.BattleHeroOver(_Win , _SpriteFather)        --斗奖台结束
   if _SpriteFather~=nil then
      _SpriteFather.gameObject:SetActive(true)
   end
   BattleFieldSys.RewardList = _SpriteFather
   BattleFieldSys.Win = _Win
   local _Result = 0
   if _Win==1 then
      _Result = _Win
   end
   if _Win == -1 then
      _Result = 0
   end
   local _info = tostring(BattleFieldSys.PlayerId)..","..tostring(_Result)
   WebEvent.OverBattleHero(_info , "BattleFieldSys.BattleHeroOverCallBack" , BattleFieldSys.BattleHeroOverCallBack)
end

function BattleFieldSys.BattleHeroOverCallBack(data , returnId)
   if returnId==0 then
      if BattleFieldSys.RewardList==nil then
         return
      end
      RewardContentSys.ShowFightOver(BattleFieldSys.RewardList , data , BattleFieldSys.Win)
      --DataUIInstance.PopTip("L8")
   elseif returnId == 1 then
     -- DataUIInstance.PopTip("U9")
   end
end

function BattleFieldSys.GetBattleHeroReward()               --领取斗奖台俸禄
   local _info = nil
   WebEvent.GetBattleHeroReward(_info , "BattleFieldSys.GetBattleHeroRewardCallBack" , BattleFieldSys.GetBattleHeroRewardCallBack)
end

function BattleFieldSys.GetBattleHeroRewardCallBack(data , returnId)
   if returnId==0 then
      DataUIInstance.PopTip("L8")
   elseif returnId == 1 then
      DataUIInstance.PopTip("U9")
   end
end

function BattleFieldSys.SetBattleFieldRank(_Rank)   --设置我的沙场点兵排名
   BattleFieldSys.MyBattleFieldRank = _Rank
end

function BattleFieldSys.SetBattleHeroRank(_Rank)    --设置我的斗奖台排名
   BattleFieldSys.MyBattleHeroRank = _Rank
end

BattleFieldSys.BattleInfo = {}
function BattleFieldSys.RequestBattleFieldInfo()    --请求沙场点兵战报
   BattleFieldSys.BattleInfo = {}
   WebEvent.RequestBattleFieldInfo(nil , "BattleFieldSys.RequestBattleFieldInfoCallBack" , BattleFieldSys.RequestBattleFieldInfoCallBack)
end

function BattleFieldSys.RequestBattleFieldInfoCallBack(data , returnId)    --请求沙场点兵战报
   if returnId == 0 then
       local UIBattleFieldTar = MainGameUI.FindPanelTarget("UIBattleField")
       if UIBattleFieldTar~=nil then         
          UIBattleFieldTar:ReflashBattleInfo()
       end
   end
end

function BattleFieldSys.RequestBattleHeroInfo()      --请求斗奖台战报
   BattleFieldSys.BattleInfo = {}
   WebEvent.RequestBattleHeroInfo(nil , "BattleFieldSys.RequestBattleHeroInfoCallBack" , BattleFieldSys.RequestBattleHeroInfoCallBack)
end

function BattleFieldSys.RequestBattleHeroInfoCallBack(data , returnId)      --请求斗奖台战报
   if returnId == 0 then
       local UIBattleFieldTar = MainGameUI.FindPanelTarget("UIBattleField")
       if UIBattleFieldTar~=nil then        
          UIBattleFieldTar:ReflashBattleInfo()
       end
   end
end

--*************查询的沙场点兵奖励
BattleFieldSys.BattleFieldReward = {}
function BattleFieldSys.InquireBattleFieldReward()
   if #BattleFieldSys.BattleFieldReward==0 then
      BattleFieldSys.BattleFieldReward = RewardConfig.GetBattleFieldReward()
   end
   return BattleFieldSys.BattleFieldReward
end

--*************查询斗将台奖励
BattleFieldSys.GetBattleHeroRewards = {}
function BattleFieldSys.InquireBattleHeroReward()
   if #BattleFieldSys.GetBattleHeroRewards==0 then
      BattleFieldSys.GetBattleHeroRewards = RewardConfig.GetBattleHeroReward()
   end
   return BattleFieldSys.GetBattleHeroRewards
end

function BattleFieldSys.FindMyRankReward(_Rank , _Rewards)
   if _Rank==1 then
      return _Rewards[1]
   elseif _Rank==2 then
      return _Rewards[2]
   elseif _Rank==3 then
      return _Rewards[3]
   elseif _Rank>=4 and _Rank<=10 then
      return _Rewards[4]
   elseif _Rank>=11 and _Rank<=50 then
      return _Rewards[5]
   elseif _Rank>=51 and _Rank<=100 then
      return _Rewards[6]
   elseif _Rank>=101 and _Rank<=200 then
      return _Rewards[7]
   elseif _Rank>=201 then
      return _Rewards[8]
   end
   return nil
end

function BattleFieldSys.BattleFieldRankComminfo(data) 
   BattleFieldSys.BattleFieldList = {}
   for key , value in pairs(data) do
       local _Index = tonumber(key)
       if _Index~=nil then
          local data = 
          {
             DBId = tonumber(value["commanderId"]),
             PlayerId = tonumber(value["id"]),
             Rank = tonumber(value["rank"]),
             Vip = tonumber(value["vip"]),
             Name = tostring(value["name"]),
             Camp = tonumber(value["camp"]),
             GuaShuaiId = tonumber(value["commanderId"]),
          }
          if data.DBId==0 then
             data.DBId = 20433
          end
          data.RoleData = RoleDataConfig.GetRoleById(data.DBId)
          table.insert(BattleFieldSys.BattleFieldList , #BattleFieldSys.BattleFieldList + 1 , data) 
           
       end
   end
    table.sort(BattleFieldSys.BattleFieldList , BattleFieldSys.Comp)
end

function BattleFieldSys.Comp(A , B)
   return A.Rank  < B.Rank 
end

function BattleFieldSys.BattleFieldTopComminfo(data)
 --  GameMain.Print(data)
   BattleFieldSys.BattleFieldTopList = {}
   for key , value in pairs(data) do
       local _Index = tonumber(key)
       if _Index~=nil then
          local data = 
          {
             DBId = tonumber(value["commanderId"]),
             PlayerId = tonumber(value["id"]),
             Rank = tonumber(value["rank"]),
             Vip = tonumber(value["vip"]),
             Name = tostring(value["name"]),
             Camp = tonumber(value["camp"]),
             GuaShuaiId = tonumber(value["commanderId"]),
          }
          if data.DBId==0 then
             data.DBId = 20433
          end
          data.RoleData = RoleDataConfig.GetRoleById(data.DBId)
          BattleFieldSys.BattleFieldTopList[data.Rank] = data
          --table.insert(BattleFieldSys.BattleFieldTopList , #BattleFieldSys.BattleFieldList , data) 
           
       end
   end
end

function BattleFieldSys.BattleHeroRankComminfo(data)
   BattleFieldSys.BattleHeroList = {}
   for key , value in pairs(data) do
       local _Index = tonumber(key)
       if _Index~=nil then
          local data = 
          {
             DBId = tonumber(value["commanderId"]),
             PlayerId = tonumber(value["id"]),
             Rank = tonumber(value["rank"]),
             Vip = tonumber(value["vip"]),
             Name = tostring(value["name"]),
             Camp = tonumber(value["camp"]),
             GuaShuaiId = tonumber(value["commanderId"]),
          }
          if data.DBId==0 then
             data.DBId = 20433
          end
          data.RoleData = RoleDataConfig.GetRoleById(data.DBId)         
          table.insert(BattleFieldSys.BattleHeroList , #BattleFieldSys.BattleHeroList + 1 , data) 
           
       end
   end
   table.sort(BattleFieldSys.BattleHeroList , BattleFieldSys.Comp)
end

function BattleFieldSys.BattleHeroTopComminfo(data)
   BattleFieldSys.BattleHeroTopList = {}
   for key , value in pairs(data) do
       local _Index = tonumber(key)
       if _Index~=nil then
          local data = 
          {
             DBId = tonumber(value["commanderId"]),
             PlayerId = tonumber(value["id"]),
             Rank = tonumber(value["rank"]),
             Vip = tonumber(value["vip"]),
             Name = tostring(value["name"]),
             Camp = tonumber(value["camp"]),
             GuaShuaiId = tonumber(value["commanderId"]),
          }
          if data.DBId==0 then
             data.DBId = 20433
          end
          data.RoleData = RoleDataConfig.GetRoleById(data.DBId)
          BattleFieldSys.BattleHeroTopList[data.Rank] = data
          --table.insert(BattleFieldSys.BattleHeroTopList , #BattleFieldSys.BattleFieldList , data) 
           
       end
   end
end

function BattleFieldSys.BattleInfoComminfo(data)
   BattleFieldSys.BattleInfo = {}
   for key , value in pairs(data) do
       local _Index = tonumber(key)
       if _Index~=nil then
          local _Enemy = value["enemy"]
          local _EnemyName = tostring(_Enemy["name"])

          local _Win = tonumber(value["isWin"])
          local _PreRank = tonumber(value["preRank"])
          local _NowRank =  tonumber(value["rank"])
          local WinString = ""
          if _Win==1 then
             WinString = UIstring.WordColor[6]..UIstring.Win.."[-]"..UIstring.From..tostring(_PreRank).. UIstring.RankUp..UIstring.WordColor[6]..tostring(_NowRank).."[-]"
          else
             WinString = UIstring.WordColor[8]..UIstring.Lose.."[-]"..UIstring.From..tostring(_PreRank)..UIstring.RankDown..UIstring.WordColor[6]..tostring(_NowRank).."[-]"
          end
          local _IsActive = tonumber(value["isActive"])     --是否是主动挑战
          local _Des = ""
          if _IsActive==1 then
             _Des = UIstring.YouFight.._EnemyName..","..WinString           
          elseif _IsActive==0 then
             _Des = _EnemyName..UIstring.FightYou..","..WinString 
          end
          table.insert(BattleFieldSys.BattleInfo , #BattleFieldSys.BattleInfo + 1 , _Des)
       end
   end
end

function BattleFieldSys.BattleTimesComminfo(data)
   BattleFieldSys.BattleFieldTime = data["legionCombatCount"]
   BattleFieldSys.BattleHeroTime = data["heroCombatCount"]
end


return BattleFieldSys