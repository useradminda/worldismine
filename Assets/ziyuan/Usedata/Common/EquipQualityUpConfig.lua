EquipQualityUpConfig = {}
EquipQualityUpConfig.EquipQualityUpConfigData = {}
function EquipQualityUpConfig.IniSome()

	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Equip_Quality_Up")
	while (sqReader:Read() ~= false) 
	do
		 local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local _Id= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
--        local Id = sqReader:GetInt32(0)
        EquipQualityUpConfig.EquipQualityUpConfigData[_Id] = {        
            Id = _Id,                        --ID          
            Quality = tonumber(ObjectInfo[1]),--sqReader:GetInt32(1),                     --名字  
            Quality_Lvl = tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),                  --名字  
            Up_To_Id = tonumber(ObjectInfo[3]),--sqReader:GetInt32(3),                 --等级modify     
            UpNeed = tonumber(ObjectInfo[4]),--sqReader:GetInt32(4),                 --
			Cost = tonumber(ObjectInfo[5])--sqReader:GetInt32(5),					
		}     
    end
end


function EquipQualityUpConfig.GetEquipQualityById(_Id)
    
    if EquipQualityUpConfig.EquipQualityUpConfigData[tonumber(_Id)]~=nil then
       return EquipQualityUpConfig.EquipQualityUpConfigData[tonumber(_Id)]
    end
    Debug.LogError("数据库Equip_Quality_Up等级配置错误Id:")
    Debug.LogError(_Id)
    return nil
end

function EquipQualityUpConfig.GetEquipQualityByQuality(_Quality , _QualityLvl)
   for i = 1 , #EquipQualityUpConfig.EquipQualityUpConfigData , 1 do
       if EquipQualityUpConfig.EquipQualityUpConfigData[i].Quality == _Quality and EquipQualityUpConfig.EquipQualityUpConfigData[i].Quality_Lvl == _QualityLvl then
			return EquipQualityUpConfig.EquipQualityUpConfigData[i]
       end
   end
   Debug.LogError("品质等级已经达到最高")
   return nil
end

function EquipQualityUpConfig.GetNextEquipByQuality(_Quality , _QualityLvl)
   local _NowEquipQuality = EquipQualityUpConfig.GetEquipQualityByQuality(_Quality , _QualityLvl)
   if _NowEquipQuality~=nil then
      local _NextQualityId = _NowEquipQuality.Up_To_Id
      local _NextEquipQuality = EquipQualityUpConfig.GetEquipQualityById(_NextQualityId)
      if _NextEquipQuality~=nil then
         return _NextEquipQuality
      else
         Debug.LogError("品质等级已经达到最高")
         return nil
      end
   else
      Debug.LogError("品质等级已经达到最高")
      return nil
   end
end


function EquipQualityUpConfig.GetEquipQualityUpConfig()
    
    return EquipQualityUpConfig.EquipQualityUpConfigData

end

return EquipQualityUpConfig