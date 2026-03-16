EventTemplateConfig={}
EventTemplateConfig.EventTemplateConfig={}

function EventTemplateConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("EventTemplate")
	while (sqReader:Read()~=false) do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
		EventTemplateConfig.EventTemplateConfig[id]=
        {
			TID=id,	--活动ID
			Type =  tonumber(ObjectInfo[1]),--sqReader:GetInt32(1),            --阵容Type
            EventType = sqReader:GetInt32(2),       --事件Type
            EventName = sqReader:GetString(3),      --事件名称
            Descrip1 = sqReader:GetString(4),       --描述1
            Descrip2 = sqReader:GetString(5),       --描述1
		}
	end
end

function EventTemplateConfig.GetEventTemplate(_Id)		--根据活动ID获得数据
	if EventTemplateConfig.EventTemplateConfig[tonumber(_Id)]~=nil then
       return EventTemplateConfig.EventTemplateConfig[tonumber(_Id)]
    end
    Debug.LogError("EventTemplate表配置错误:")
    Debug.LogError(_Id)
    return nil
end


return EventTemplateConfig