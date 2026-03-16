ArmyTemplateConfig = {}
ArmyTemplateConfig.ArmyTemplateConfig = {}
function ArmyTemplateConfig.IniSome()

	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("ArmyTemplate")
	while (sqReader:Read() ~= false) 
	do  
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
        local _Id = tonumber(ObjectInfo[0])--sqReader:GetInt32(0)
        ArmyTemplateConfig.ArmyTemplateConfig[_Id] = {        
            Id = tonumber(ObjectInfo[0]), --sqReader:GetInt32(0),           --ID       
            Description = tostring(ObjectInfo[1]), --sqReader:GetString(1),          --exp
            FormationCfg = tostring(ObjectInfo[2]), --sqReader:GetString(2),
            Reward = tostring(ObjectInfo[3]), --sqReader:GetString(3),
		} 
        
    end
end

function ArmyTemplateConfig.GetArmyTemplateByConfigId(_Id) 
    if ArmyTemplateConfig.ArmyTemplateConfig[_Id]~=nil then
       return ArmyTemplateConfig.ArmyTemplateConfig[_Id]
    end
    Debug.LogError("数据库ArmyTemplate等级配置错误_Id:")
    Debug.LogError(_Id)
    return nil
end

function ArmyTemplateConfig.GetArmyTemplateConfig()
    
    return ArmyTemplateConfig.ArmyTemplateConfig

end

return ArmyTemplateConfig