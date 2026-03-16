EquipDataSys = {}
EquipDataSys.EquipTypes = 
{
    [1] = "Weapon",                     --名字  
    [2] = "Casque" ,                  --名字  
    [3] = "Breastplate",                 --等级modify     
    [4] = "Wrister",                 --
    [5] = "Shoes",                 --          
    [6] = "Cloak", 
    [7] = "Amulet",
    [8] = "Ring",
}

function EquipDataSys.GetEquipById(_DBid)
   local _EquipData = EquipDataConfig.GetEquipDBConfig(_DBid)
   if _EquipData~=nil then
      return _EquipData
   else  
      return nil
   end
end

function EquipDataSys.CreateEquip(_UUID , _DBid , _Lvl , _QualityLvl , _AttackAdd , _HpAdd , _AttackSpeedAdd)
   local lua = GameMain.requireLuaFile("Equip")
   local EquipMent = lua:new()
   local _EquipData = EquipDataSys.GetEquipById(_DBid)
   EquipMent:Init(_EquipData , _UUID , _Lvl , _QualityLvl , _AttackAdd , _HpAdd , _AttackSpeedAdd)
   return EquipMent
end

function EquipDataSys.CreateTempEquip(_DBid  , _IsBuy)				--根据ID创建临时的装备
	local lua = GameMain.requireLuaFile("Equip")
	local EquipItem = lua:new()
	local _EquipData = EquipDataSys.GetEquipById(_DBid)
	EquipItem:SetEquipDb(_EquipData)
	EquipItem:BuyInfo(_IsBuy)
	return EquipItem
end

function EquipDataSys.GetUpLvlExpByLvl(_Lvl , _Type)
   local _EquipLvlData = EquipLvlUpConfig.GetEquipExpByLvl(_Lvl)
   local _NeedExp = _EquipLvlData[EquipDataSys.EquipTypes[_Type]]
   if _NeedExp==nil then
      Debug.LogError("装备已经达到最高等级")
      return nil
   else
      return _NeedExp
   end
end

function EquipDataSys.GetEquipQualityData(_Quality , _QualityLvl)
   if _Quality<=3 then
      Debug.LogError("该品质无法升阶")
      return nil
   end
   local _EquipQualityData = EquipQualityUpConfig.GetEquipQualityByQuality(_Quality , _QualityLvl)
   if _EquipQualityData~=nil then
      return _EquipQualityData
   else
      return nil
   end
end

function EquipDataSys.GetEquipQualityUpNeed(_Quality , _QualityLvl)
   if _Quality<=3 then
      Debug.LogError("该品质无法升阶")
      return nil
   end
   local _EquipQualityData = EquipQualityUpConfig.GetEquipQualityByQuality(_Quality , _QualityLvl)
   if _EquipQualityData~=nil then
      return _EquipQualityData.UpNeed
   else
      return nil
   end
end

function EquipDataSys.GetNextEquipQualityData(_Quality , _QualityLvl)
   if _Quality<=2 then
      Debug.LogError("该品质无法查询下一个品质")
      return nil
   end
   local _EquipNextQualityData = EquipQualityUpConfig.GetNextEquipByQuality(_Quality , _QualityLvl)
   if _EquipNextQualityData~=nil then
      return _EquipNextQualityData
   else
      return nil
   end
end

function EquipDataSys.GetEquipByQuality( _Id , _Quality)                                   --查询该品质下的装备
   local _EquipData = EquipDataConfig.GetEquipByQuality( _Id ,_Quality)
   if _EquipData~=nil then
      return _EquipData
   else
      return nil
   end
end

return EquipDataSys
