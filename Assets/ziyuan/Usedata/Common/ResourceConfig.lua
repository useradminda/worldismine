ResourceConfig={}
ResourceConfig.ResourceConfig={}

function ResourceConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Resources")
	while (sqReader:Read()~=false) do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0])--sqReader:GetInt32(0)
		ResourceConfig.ResourceConfig[id]=
		{
			Id=id,
			Name= tostring(ObjectInfo[1]),--sqReader:GetString(1),
			Description=tostring(ObjectInfo[2]),--sqReader:GetString(2),
			Icon=tostring(ObjectInfo[3]),--sqReader:GetString(3),
			Quality=tonumber(ObjectInfo[4]),--sqReader:GetInt32(4),--品质
			Type=tonumber(ObjectInfo[5]),--sqReader:GetInt32(5),--类型
			Is_Visiable=tonumber(ObjectInfo[6]),--sqReader:GetInt32(6),
			Is_Sell=tonumber(ObjectInfo[7]),--sqReader:GetInt32(7),--能否被出售 int 1-可以，0-不行
			Price=tonumber(ObjectInfo[8]),--sqReader:GetInt32(8),
			Is_Use=tonumber(ObjectInfo[9]),--sqReader:GetInt32(9),--是否使用
			
     
		}
		local _Icons = GameMain.StringSplit(ResourceConfig.ResourceConfig[id].Icon , ",")
        ResourceConfig.ResourceConfig[id].AtlasName = _Icons[1]
        ResourceConfig.ResourceConfig[id].SpriteName = _Icons[2]
	end
end

function ResourceConfig.GetResourceConfig(_Type)		
    local Type = tonumber(_Type)
    for key , value in pairs(ResourceConfig.ResourceConfig) do
	    if value.Id == Type then
           return value
        end
    end
    Debug.LogError("Resources表配置错误Type:")
    Debug.LogError(Type)
    return nil
end

function ResourceConfig.GetResourceConfigByType(_Type)
   local Type = tonumber(_Type)
    for key , value in pairs(ResourceConfig.ResourceConfig) do
	    if value.Type == Type then
           return value
        end
    end
    Debug.LogError("Resources表配置错误Type:")
    Debug.LogError(Type)
    return nil
end

return ResourceConfig