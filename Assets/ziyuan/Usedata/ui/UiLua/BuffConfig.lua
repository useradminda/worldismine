BuffConfig = {}
BuffConfig.BuffConfig = {}
function BuffConfig.IniSome()

	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Buff")
	while (sqReader:Read() ~= false) 
	do
		local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local _Id= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
--        local _Id = sqReader:GetInt32(0)
        BuffConfig.BuffConfig[_Id] = {        
            Id = _Id,                        --ID          
            Type = tonumber(ObjectInfo[1]),--sqReader:GetInt32(1),                     --名字  
            PropertyId = tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),                  --名字  
            LvlModify = tostring(ObjectInfo[3]),--sqReader:GetString(3),                 --等级modify     
            SpellModify = tostring(ObjectInfo[4]),--sqReader:GetString(4),                 --
            SustainTime = tonumber(ObjectInfo[5]),--sqReader:GetFloat(5),                 --
            --Description =  sqReader:GetString(5),     
		}     
    end
end

function BuffConfig.GetBuffById(_Id)
    
    if BuffConfig.BuffConfig[tonumber(_Id)]~=nil then
       return BuffConfig.BuffConfig[tonumber(_Id)]
    end
    Debug.LogError("数据库Buff配置错误id:")
    Debug.LogError(_Id)
    return nil
end

function BuffConfig.GetBuffData()
    
    return BuffConfig.BuffConfig

end

return BuffConfig