RoleSkillConfig = {}
RoleSkillConfig.RoleSkillConfig = {}
function RoleSkillConfig.IniSome()

	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Skill")
    RoleSkillConfig.Number = 1
	while (sqReader:Read() ~= false)
	do
		local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
        RoleSkillConfig.RoleSkillConfig[RoleSkillConfig.Number] = {
            Id = tonumber(ObjectInfo[0]),--sqReader:GetInt32(0),                        --ID
            Name = tostring(ObjectInfo[1]),--sqReader:GetString(1),                     --名字
            ColdTime = tonumber(ObjectInfo[2]),--sqReader:GetFloat(2),                  --名字
            SkillTime = tonumber(ObjectInfo[3]),--sqReader:GetFloat(3),                 --名字
            Start1_Time = tonumber(ObjectInfo[4]),--sqReader:GetFloat(4),               --Start1_Time
            Start2_Time = tonumber(ObjectInfo[5]),--sqReader:GetFloat(5),               --Start2_Time
            Ammo1_id = tostring(ObjectInfo[6]),--sqReader:GetString(6),                   --攻击参数
            Ammo2_id = tostring(ObjectInfo[7]),--sqReader:GetString(7),                   --攻击参数
            Buff1_id = tostring(ObjectInfo[8]),--sqReader:GetString(8),                   --攻击参数
            Buff2_id = tostring(ObjectInfo[9]),--sqReader:GetString(9),                   --攻击参数
            Start1_Effect = tonumber(ObjectInfo[10]),--sqReader:GetInt32(10),                   --攻击参数
            Start2_Effect = tonumber(ObjectInfo[11]),--sqReader:GetInt32(11),                   --攻击参数
            ChosePos = tonumber(ObjectInfo[12]),--sqReader:GetInt32(12),                   --人物类型
            LogicName = tostring(ObjectInfo[13]),--sqReader:GetString(13),                 --逻辑脚本
            Param = tostring(ObjectInfo[14]),--sqReader:GetString(14),                 --人物类型
            Descrip = tostring(ObjectInfo[15]),--sqReader:GetString(15),                 --人物类型
            Music = tostring(ObjectInfo[16]),--sqReader:GetString(16),                 --人物类型
            Icon = tostring(ObjectInfo[17]),--sqReader:GetString(17),                 --人物类型
			SkillTipid= tonumber(ObjectInfo[18]),-- sqReader:GetInt32(18),				--技能提示圈ID
			PlayMusic= tostring(ObjectInfo[19]),--sqReader:GetString(19),			--播放声音
			Range = tostring(ObjectInfo[20]),--sqReader:GetString(20),				--使用范围
			Rate = tonumber(ObjectInfo[21]),--sqReader:GetInt32(21),			--起效次数	
		}

        local _Icons = GameMain.StringSplit(RoleSkillConfig.RoleSkillConfig[RoleSkillConfig.Number].Icon , ",")
        RoleSkillConfig.RoleSkillConfig[RoleSkillConfig.Number].AtlasName = _Icons[1]
        RoleSkillConfig.RoleSkillConfig[RoleSkillConfig.Number].SpriteName = _Icons[2]

        RoleSkillConfig.Number = RoleSkillConfig.Number + 1
    end
end

function RoleSkillConfig.GetRoleSkillById(_Id)

    for i = 1 , #RoleSkillConfig.RoleSkillConfig  ,1 do
        if RoleSkillConfig.RoleSkillConfig[i].Id == _Id then
           return RoleSkillConfig.RoleSkillConfig[i]
        end
    end
    return nil
end

function  RoleSkillConfig.GetRoleSkillData()

    return RoleSkillConfig.RoleSkillConfig

end

return RoleSkillConfig
