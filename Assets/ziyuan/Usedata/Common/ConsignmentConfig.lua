--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
ConsignmentConfig={}
ConsignmentConfig.ConsignmentData={}
ConsignmentConfig.TypeCount = 0

function ConsignmentConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Consignment")
	
	while (sqReader:Read()~=false) do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[2])--sqReader:GetInt32(2)
		ConsignmentConfig.ConsignmentData[id]={
			Id= tonumber(ObjectInfo[0]),--sqReader:GetInt32(0),	
			Type = tonumber(ObjectInfo[1]),--sqReader:GetInt32(1),
			Goods = id,
			Price_Min = tonumber(ObjectInfo[3]),--sqReader:GetInt32(3),
			Price_Max = tonumber(ObjectInfo[4]),--sqReader:GetInt32(4),
			Price_Reconmmend = tonumber(ObjectInfo[5]),--sqReader:GetInt32(5),
			Class = tonumber(ObjectInfo[6]),--sqReader:GetInt32(6),
			TitleName = tostring(ObjectInfo[7]),--sqReader:GetString(7),
			}
	end
end

function ConsignmentConfig.GetDataById(_Id)		--根据id获取相关数据
	if ConsignmentConfig.ConsignmentData[tonumber(_Id)]~=nil then
       return ConsignmentConfig.ConsignmentData[tonumber(_Id)]
    end
    Debug.LogError("Consignment表配置错误:")
    Debug.LogError(_Id)
    return nil
end

function ConsignmentConfig.GetAllDBData()
	return ConsignmentConfig.ConsignmentData
end

return ConsignmentConfig

--endregion
