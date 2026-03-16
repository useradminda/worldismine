BattleFlagDataSys = {}
BattleFlagDataSys.BattleFlagProp = {}

function BattleFlagDataSys.InitProp()
   BattleFlagDataSys.BattleFlagProp = RoleInfoConfig.GetBattleFlagInfo()
end

function BattleFlagDataSys.GetPropByLvl(_Lvl)
   if BattleFlagDataSys.BattleFlagProp[_Lvl]~=nil then
      return BattleFlagDataSys.BattleFlagProp[_Lvl]
   else   
      Debug.LogError("已达到最高等级")
   end

end

function BattleFlagDataSys.CreateFlag(_DBid , _Count)
   local lua = GameMain.requireLuaFile("BattleFlag")
   local _BattleFlag = lua:new()
   local _BattleFlagData = BattleFlagDataSys.GetBattleFlagById(_DBid)
   _BattleFlag:Init(_BattleFlagData , _Count)
   return _BattleFlag
end

function BattleFlagDataSys.GetBattleFlagById(_DBid)
   local _BattleFlag = BattleFlagConfig.GetBattleFlagConfigById(_DBid)
   if _BattleFlag~=nil then
      return _BattleFlag
   else
      return nil
   end
end

function BattleFlagDataSys.GetBattleFlagByLvl_Series(_Lvl , _Series)
   local _BattleFlag = BattleFlagConfig.GetBattleFlagByLvl_Series(_Lvl , _Series)
   if _BattleFlag~=nil then
      return _BattleFlag
   else 
      return nil
   end
end

function BattleFlagDataSys.GetBattleFlagByType_Series(_Type , _Series)
   local _BattleFlag = BattleFlagConfig.GetBattleFlagByType_Series(_Type , _Series)
   if _BattleFlag~=nil then
      return _BattleFlag
   else 
      return nil
   end
end

function BattleFlagDataSys.GetBattleFlagByType_Series_Lvl(_Type , _Series , _Lvl)
   local _BattleFlag = BattleFlagConfig.GetBattleFlagByType_Series_Lvl(_Type , _Series , _Lvl)
   if _BattleFlag~=nil then
      return _BattleFlag
   else 
      return nil
   end
end

return BattleFlagDataSys