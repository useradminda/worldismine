--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
OfficialDataConfig = {}
OfficialDataConfig.OfficialData = {}

function OfficialDataConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Official")
	while (sqReader:Read() ~= false) 
	do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
        local _DBid = tonumber(ObjectInfo[0])--sqReader:GetInt32(0)
        OfficialDataConfig.OfficialData[_DBid] = {        
            Id = tonumber(ObjectInfo[0]),-- sqReader:GetInt32(0),                      --ID                                  
            Name = tostring(ObjectInfo[1]),-- sqReader:GetString(1),					--官职名称
		}

    end
end

function OfficialDataConfig.GetDB()
	return OfficialDataConfig.OfficialData
end

function OfficialDataConfig.GetDataById(_ID)
	 if OfficialDataConfig.OfficialData[tonumber(_ID)]~=nil then
       return OfficialDataConfig.OfficialData[tonumber(_ID)]
    end
    Debug.LogError("数据库Official配置错误id:")
    Debug.LogError(_ID)
    return nil
end
return OfficialDataConfig
--endregion
