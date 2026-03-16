--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
TipsConfig={}
TipsConfig.TipsData={}

function TipsConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Tips")
	while (sqReader:Read()~=false) do
		local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
		TipsConfig.TipsData[id]={
			Id = id,
			Description = tostring(ObjectInfo[1])--sqReader:GetString(1) 
			}
	end
end

function TipsConfig.GetDataById(_Id)		--根据VIP等级获取相关数据
	if TipsConfig.TipsData[tonumber(_Id)]~=nil then
       return TipsConfig.TipsData[tonumber(_Id)]
    end
    Debug.LogError("表配置错误:")
    Debug.LogError(_Id)
    return nil
end

function TipsConfig.GetAllDBData()
	return TipsConfig.TipsData
end

return TipsConfig

--endregion
