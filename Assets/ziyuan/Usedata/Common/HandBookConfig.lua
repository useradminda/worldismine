HandBookConfig = {}
HandBookConfig.HandBookConfig = {}
HandBookConfig.HandBookConfigNum = 0
function HandBookConfig.InitSome()
    HandBookConfig.HandBookConfigNum = 0
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Handbook")
	while (sqReader:Read() ~= false) 
	do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
        local _Id = tonumber(ObjectInfo[0])--sqReader:GetInt32(0)
        HandBookConfig.HandBookConfigNum = HandBookConfig.HandBookConfigNum + 1 
        HandBookConfig.HandBookConfig[HandBookConfig.HandBookConfigNum] = 
        {        
            Type = tonumber(ObjectInfo[0]),--sqReader:GetInt32(0),            --类型  
            Quality = tonumber(ObjectInfo[1]),--sqReader:GetInt32(1),         --品质       
            Order = tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),          --顺序
            RoleId = tonumber(ObjectInfo[3]),--sqReader:GetInt32(3),          --ID           
		}    
    end
end

function HandBookConfig.GetHandBookConfigById(_Id)
    if HandBookConfig.HandBookConfig[tonumber(_Id)]~=nil then
       return HandBookConfig.HandBookConfig[tonumber(_Id)]
    end
    Debug.LogError("数据库Handbook等级配置错误_Id:")
    Debug.LogError(_Id)
    return nil
end

function HandBookConfig.GetHandBookConfig()
    
    return HandBookConfig.HandBookConfig

end

return HandBookConfig