SoliderQualityUpConfig = {}                                                            
SoliderQualityUpConfig.SoliderQualityUpData = {}
function SoliderQualityUpConfig.IniSome()

	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Soldier_Quality_Up")
	while (sqReader:Read() ~= false) 
	do
		local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local _Id= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
--        local _Id = sqReader:GetInt32(0)
        SoliderQualityUpConfig.SoliderQualityUpData[_Id] =
        {        
            Id = _Id,                        --ID          
            Quality = tonumber(ObjectInfo[1]),--sqReader:GetInt32(1),                     --名字  
            QualityLvl = tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),                  --名字  
            UpToId = tonumber(ObjectInfo[3]),--sqReader:GetInt32(3),                 --名字         
            UpNeed = tostring(ObjectInfo[4]),--sqReader:GetString(4),               --Start1_Time            
		}
    end
end

function SoliderQualityUpConfig.GetSoliderQualityInfoById(_Id)	
    if SoliderQualityUpConfig.SoliderQualityUpData[tonumber(_Id)] ~=nil then
       return SoliderQualityUpConfig.SoliderQualityUpData[tonumber(_Id)]
    end
    Debug.LogError("数据库配置Soldier_Quality_Up错误id:")
    Debug.LogError(_Id)
    return nil
end

function SoliderQualityUpConfig.GetNextQualityInfo(_Id)
   local _QualityInfo = SoliderQualityUpConfig.GetSoliderQualityInfoById(_Id)
   local _NextInfoId = _QualityInfo.UpToId
   if _QualityInfo~=nil then
      local _NextQualityInfo  = SoliderQualityUpConfig.GetSoliderQualityInfoById(_NextInfoId)
      if _NextQualityInfo==nil then
         Debug.LogError("已达到最高品质")
         return nil     
      else
         return _NextQualityInfo
      end
   else
      Debug.LogError("数据库配置Soldier_Quality_Up错误id:")
      Debug.LogError(_Id)
      return nil
   end
end

function SoliderQualityUpConfig.GetDBByQuilityAndLv(_Quility , _lvl)			
	for key,value in pairs(SoliderQualityUpConfig.SoliderQualityUpData) do
		if value.Quality == _Quility and value.QualityLvl == _lvl then
			return value
		end
	end
	Debug.LogError("数据库配置Soldier_Quality_Up错误id:")
    Debug.LogError(_Quility)
	return nil
end
return SoliderQualityUpConfig