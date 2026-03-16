BattleFlagConfig = {}
BattleFlagConfig.BattleFlagConfig = {}

function BattleFlagConfig.IniSome()

	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Symbol")
	while (sqReader:Read() ~= false) 
	do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
        local _Id = tonumber(ObjectInfo[0])--sqReader:GetInt32(0)
        BattleFlagConfig.BattleFlagConfig[_Id] = {        
            Id = tonumber(ObjectInfo[0]),--sqReader:GetInt32(0),           --lvl       
            Name = tostring(ObjectInfo[1]),--sqReader:GetString(1),          --名字
            Description = tostring(ObjectInfo[2]),--sqReader:GetString(2),          --描述
            Series = tonumber(ObjectInfo[3]),--sqReader:GetInt32(3),          --系别 1 天罚 2 鼓舞 3 强壮
            Type = tonumber(ObjectInfo[4]),--sqReader:GetInt32(4),          --类型 1 弓 2 盾 3 枪
            Attack = tonumber(ObjectInfo[5]),--sqReader:GetInt32(5),         --攻击系数
            HP = tonumber(ObjectInfo[6]),--sqReader:GetInt32(6),         --血量系数
            Reduction = tonumber(ObjectInfo[7]),--sqReader:GetInt32(7),         --衰减系数
            Icon = tostring(ObjectInfo[8]),--sqReader:GetString(8),
            Lvl = tonumber(ObjectInfo[9]),--sqReader:GetInt32(9),
            UpId = tonumber(ObjectInfo[10]),--sqReader:GetInt32(10),
            Quality = tonumber(ObjectInfo[13]),
		}
        if BattleFlagConfig.BattleFlagConfig[_Id].Series == 1 then 
           BattleFlagConfig.BattleFlagConfig[_Id].Description = BattleFlagConfig.BattleFlagConfig[_Id].Description..tostring(BattleFlagConfig.BattleFlagConfig[_Id].Reduction).."%" 
        elseif BattleFlagConfig.BattleFlagConfig[_Id].Series == 2 then  
           BattleFlagConfig.BattleFlagConfig[_Id].Description = BattleFlagConfig.BattleFlagConfig[_Id].Description..tostring(BattleFlagConfig.BattleFlagConfig[_Id].Attack).."%"  
        elseif BattleFlagConfig.BattleFlagConfig[_Id].Series == 3 then 
           BattleFlagConfig.BattleFlagConfig[_Id].Description = BattleFlagConfig.BattleFlagConfig[_Id].Description..tostring(BattleFlagConfig.BattleFlagConfig[_Id].HP).."%"
        end 
        local _Icons = GameMain.StringSplit(BattleFlagConfig.BattleFlagConfig[_Id].Icon , ",")
        BattleFlagConfig.BattleFlagConfig[_Id].AtlasName = _Icons[1]
        BattleFlagConfig.BattleFlagConfig[_Id].SpriteName = _Icons[2]
    end
end

function BattleFlagConfig.GetBattleFlagConfigById(_Id)
    
    if BattleFlagConfig.BattleFlagConfig[tonumber(_Id)]~=nil then
       return BattleFlagConfig.BattleFlagConfig[tonumber(_Id)]
    end
    Debug.LogError("数据库Symbol等级配置错误Id:")
    Debug.LogError(_Id)
    return nil
end

function BattleFlagConfig.GetBattleFlagByLvl_Series(_Lvl , _Series)
    for key , value in pairs(BattleFlagConfig.BattleFlagConfig) do
        if value.Lvl == _Lvl and value.Series==_Series then
           return value
        end
    end
end

function BattleFlagConfig.GetBattleFlagByType_Series(_Type , _Series)
    for key , value in pairs(BattleFlagConfig.BattleFlagConfig) do
        if value.Type == _Type and value.Series==_Series then
           return value
        end
    end
end

function BattleFlagConfig.GetBattleFlagByType_Series_Lvl(_Type , _Series , _Lvl)
    for key , value in pairs(BattleFlagConfig.BattleFlagConfig) do
        if value.Type == _Type and value.Series==_Series and value.Lvl == _Lvl then
           return value
        end
    end
end

function BattleFlagConfig.GetBattleFlagConfig()
    
    return BattleFlagConfig.BattleFlagConfig

end

return BattleFlagConfig