RoleDataConfig = {}                                                            
RoleDataConfig.RoleDataConfig = {}
function RoleDataConfig.IniSome()

	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Role")
	while (sqReader:Read() ~= false) 
	do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
        --GameMain.Print(ObjectInfo)
        local _DBid = tonumber(ObjectInfo[0])--sqReader:GetInt32(0)
      
        RoleDataConfig.RoleDataConfig[_DBid] = {        
            Id = tonumber(ObjectInfo[0]),-- sqReader:GetInt32(0),                        --ID      
                                       
            RealId = tonumber(ObjectInfo[1]),--sqReader:GetInt32(1),                    --RealId
            Quality = tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),                   --Quality
            Name = tostring(ObjectInfo[3]),--sqReader:GetString(3),                     --名字  
            FbxName = tostring(ObjectInfo[4]),--sqReader:GetString(4),                  --模型名字
            Life = tostring(ObjectInfo[5]),--sqReader:GetString(5),                     --生命
            Attack = tostring(ObjectInfo[6]),--sqReader:GetString(6),                   --攻击参数
            MoveSpeed = tostring(ObjectInfo[7]),--sqReader:GetString(7),                --移动速度
            AttackSpeed = tostring(ObjectInfo[8]),--sqReader:GetString(8),              --攻击速度
            Defence = tostring(ObjectInfo[9]),--sqReader:GetString(9),                  --防御速度
            AttackRange = tonumber(ObjectInfo[10]),--sqReader:GetInt32(10),              --攻击类型
            WarningRange = tonumber(ObjectInfo[11]),--sqReader:GetInt32(11),             --警戒范围
            RoleType = tonumber(ObjectInfo[12]),--sqReader:GetInt32(12),                 --人物类型
            RoleSeries = tonumber(ObjectInfo[13]),--sqReader:GetInt32(13),               --人物系别
            AdvanceId = tonumber(ObjectInfo[14]),--sqReader:GetInt32(14),                --进阶后的ID
            AdvancedNeed = tostring(ObjectInfo[15]),--sqReader:GetString(15),            --进阶所需要的材质数和钱数
            Icon = tostring(ObjectInfo[16]),--sqReader:GetString(16),                    --头像
            Type_1 = tonumber(ObjectInfo[17]),--sqReader:GetInt32(17),                   --类型1
            Attack_Id = tonumber(ObjectInfo[18]),--sqReader:GetInt32(18),                --普攻技能
            Spell_Id = tonumber(ObjectInfo[19]),--sqReader:GetInt32(19),                 --携带技能
            Mount = tostring(ObjectInfo[20]),--sqReader:GetString(20),                   --携带技能
            AttackType = tostring(ObjectInfo[21]),--sqReader:GetString(21),              --攻击类型
            DefaultSoldier = tonumber(ObjectInfo[22]),--sqReader:GetInt32(22),           --默认上阵兵种
            SoldierNumType = tonumber(ObjectInfo[23]),--sqReader:GetInt32(23),           --兵种所占格子
			
			--24  编辑菜单用  客户端不用
			Description = tostring(ObjectInfo[25]),-- sqReader:GetString(25),				--角色描述
			Aptitude = tonumber(ObjectInfo[26]),-- sqReader:GetInt32(26),					--角色的资质
			People = tonumber(ObjectInfo[27]),--sqReader:GetInt32(27),
			Sound = tostring(ObjectInfo[30]),
		}
        
        local LifeList = GameMain.StringSplit(RoleDataConfig.RoleDataConfig[_DBid].Life , ",")
        RoleDataConfig.RoleDataConfig[_DBid].LifeList = LifeList

        local AttackList = GameMain.StringSplit(RoleDataConfig.RoleDataConfig[_DBid].Attack , ",")
        RoleDataConfig.RoleDataConfig[_DBid].AttackList = AttackList

        local MoveSpeedList = GameMain.StringSplit(RoleDataConfig.RoleDataConfig[_DBid].MoveSpeed , ",")
        RoleDataConfig.RoleDataConfig[_DBid].MoveSpeedList = MoveSpeedList

        local AttackSpeedList = GameMain.StringSplit(RoleDataConfig.RoleDataConfig[_DBid].AttackSpeed , ",")
        RoleDataConfig.RoleDataConfig[_DBid].AttackSpeedList = AttackSpeedList

        local DefenceList = GameMain.StringSplit(RoleDataConfig.RoleDataConfig[_DBid].Defence , ",")
        RoleDataConfig.RoleDataConfig[_DBid].DefenceList = DefenceList

		local AdvancedNeedList = GameMain.StringSplit(RoleDataConfig.RoleDataConfig[_DBid].AdvancedNeed , ",")
		RoleDataConfig.RoleDataConfig[_DBid].AdvancedNeedMat = AdvancedNeedList[1]
		RoleDataConfig.RoleDataConfig[_DBid].AdvancedNeedCost = AdvancedNeedList[2]	

        local _Icons = GameMain.StringSplit(RoleDataConfig.RoleDataConfig[_DBid].Icon , ",")
        RoleDataConfig.RoleDataConfig[_DBid].AtlasName = _Icons[1]
        RoleDataConfig.RoleDataConfig[_DBid].SpriteName = _Icons[2]
       
    end

    
end

function RoleDataConfig.GetRoleById(_Id)
    if RoleDataConfig.RoleDataConfig[tonumber(_Id)]~=nil then
       return RoleDataConfig.RoleDataConfig[tonumber(_Id)]
    end
    Debug.LogError("数据库Role配置错误id:")
    Debug.LogError(_Id)
    return nil
end

function RoleDataConfig.GetRoleByQuality( _Id , _Quality)
    for key , value in pairs(RoleDataConfig.RoleDataConfig) do
        if value.Id == _Id and value.Quality == _Quality then
           return value
        end
    end
end

function  RoleDataConfig.GetRoleData()
    
    return RoleDataConfig.RoleDataConfig

end

return RoleDataConfig