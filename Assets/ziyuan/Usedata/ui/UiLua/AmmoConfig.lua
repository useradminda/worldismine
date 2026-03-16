AmmoConfig = {}
AmmoConfig.AmmoConfig = {}
function AmmoConfig.IniSome()

	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Ammo")
    AmmoConfig.Number = 1
	while (sqReader:Read() ~= false) 
	do
      local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
        AmmoConfig.AmmoConfig[AmmoConfig.Number] = {        
            Id = tonumber(ObjectInfo[0]),--sqReader:GetInt32(0),                        --ID                 
            PrefabName = tostring(ObjectInfo[1]),--sqReader:GetString(1),                 --µÈ¼¶modify     
            LogicName = tostring(ObjectInfo[2]),--sqReader:GetString(2),                 --
            Param = tostring(ObjectInfo[3]),--sqReader:GetString(3),                 --
            Description =  tostring(ObjectInfo[4]),--sqReader:GetString(4),     
		}
        AmmoConfig.Number = AmmoConfig.Number + 1
    end
end

function AmmoConfig.GetAmmoById(_Id)
    
    for i = 1 , #AmmoConfig.AmmoConfig  ,1 do
        if AmmoConfig.AmmoConfig[i].Id == _Id then
           return AmmoConfig.AmmoConfig[i]
        end
    end 
    return nil
end

function AmmoConfig.GetAmmoData()
    
    return AmmoConfig.AmmoConfig

end

return AmmoConfig