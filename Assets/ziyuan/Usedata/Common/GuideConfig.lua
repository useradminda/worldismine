GuideConfig = {}
GuideConfig.GuideConfig = {}

function GuideConfig.InitSome()
  
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Guide")
	while (sqReader:Read() ~= false) 
	do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
        local _BigStep = tonumber(ObjectInfo[5])--sqReader:GetInt32(0)
        local _SmallStep = tonumber(ObjectInfo[1])
        if GuideConfig.GuideConfig[_BigStep] == nil then
           GuideConfig.GuideConfig[_BigStep] = {}
        end 
        GuideConfig.GuideConfig[_BigStep][_SmallStep] = 
        {           
            Quality = tonumber(ObjectInfo[1]),
            Type = tostring(ObjectInfo[2]),  
            ChatContent = tostring(ObjectInfo[3]),  
            Icon = tostring(ObjectInfo[4]),     
            Pos = tonumber(ObjectInfo[6]),    
            Sound = tostring(ObjectInfo[7]), 
            Must = tonumber(ObjectInfo[8]), 
        }
    end
    
end

function GuideConfig.GetGuideConfigById(_BigStep , _SmallStep)
    if GuideConfig.GuideConfig[tonumber(_BigStep)]~=nil then
        if GuideConfig.GuideConfig[tonumber(_BigStep)][tonumber(_SmallStep)]~=nil then
           return GuideConfig.GuideConfig[tonumber(_BigStep)][tonumber(_SmallStep)]
        end
    end
    Debug.LogError("数据库Guide大步骤配置错误_BigStep:")
    Debug.LogError(_BigStep)
    Debug.LogError("数据库Guide小步骤配置错误_SmallStep:")
    Debug.LogError(_SmallStep)
    return nil
end


return GuideConfig