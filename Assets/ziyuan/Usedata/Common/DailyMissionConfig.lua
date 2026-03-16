DailyMissionConfig = {}
DailyMissionConfig.DailyMissionConfig = {}
DailyMissionConfig.Number = 0
function DailyMissionConfig.IniSome()

	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Daily")
	while (sqReader:Read() ~= false) 
	do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))

        DailyMissionConfig.Number = DailyMissionConfig.Number + 1    
        local _Id = tonumber(ObjectInfo[0])--sqReader:GetInt32(0)
        DailyMissionConfig.DailyMissionConfig[DailyMissionConfig.Number] = {        
            Id = tonumber(ObjectInfo[0]),--sqReader:GetInt32(0),           --lvl       
            Description =tostring(ObjectInfo[1]),--sqReader:GetString(1),          --exp
            Type = tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),
            NeedTimes = tonumber(ObjectInfo[3]),--sqReader:GetInt32(3),
            Acitve = tonumber(ObjectInfo[4]),--sqReader:GetInt32(4),
		} 
        
    end
end

function DailyMissionConfig.GetDailyById(_Id) 
    for i = 1 , #DailyMissionConfig.DailyMissionConfig , 1 do
        if DailyMissionConfig.DailyMissionConfig[i].Id == _Id then
           return DailyMissionConfig.DailyMissionConfig[i]
        end
    end
    Debug.LogError("数据库Daily等级配置错误_Id:")
    Debug.LogError(_Id)
    return nil
end

function DailyMissionConfig.GetDailyMissionConfig()
    
    return DailyMissionConfig.DailyMissionConfig

end

return DailyMissionConfig