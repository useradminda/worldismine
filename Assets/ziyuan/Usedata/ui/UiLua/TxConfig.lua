TxConfig = {}
TxConfig.TxConfigTable = {}
function TxConfig.IniSome()

	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Effect")
	while (sqReader:Read() ~= false) 
	do
		local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local _Id= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
--        local _Id = sqReader:GetInt32(0)
        TxConfig.TxConfigTable[_Id] = {        
            Id = _Id,                        --ID          
            LifeTime = tonumber(ObjectInfo[1]),--sqReader:GetFloat(1),                    
            Type = tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),                   
            PrefabName = tostring(ObjectInfo[3]),--sqReader:GetString(3),                 -- 
            Mounttype =  tonumber(ObjectInfo[4]),--sqReader:GetInt32(4),                 --
            Mountid = tonumber(ObjectInfo[5]),--sqReader:GetInt32(5),                 --
            Description =  tostring(ObjectInfo[6]),--sqReader:GetString(6),     
		}     
    end
end

function TxConfig.GetTxById(_Id)
    
    if TxConfig.TxConfigTable[tonumber(_Id)]~=nil then
       return TxConfig.TxConfigTable[tonumber(_Id)]
    end
    Debug.LogError(" ˝æ›ø‚Buff≈‰÷√¥ÌŒÛid:")
    Debug.LogError(_Id)
    return nil
end

function TxConfig.GetTxData()
    
    return TxConfig.TxConfigTable

end

return TxConfig