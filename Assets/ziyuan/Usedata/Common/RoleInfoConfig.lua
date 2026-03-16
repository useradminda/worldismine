RoleInfoConfig = {}                                                            


function RoleInfoConfig.IniSome()

	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("RoleInfo")
	sqReader:Read()
	local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))

    RoleInfoConfig.AttackPriority = tostring(ObjectInfo[0])--sqReader:GetString(0)                     --攻击优先级
    RoleInfoConfig.RoleCellCfg = tostring(ObjectInfo[1])--sqReader:GetString(1)                   --单位占用格子
    RoleInfoConfig.DepartAddDam = tostring(ObjectInfo[2])--sqReader:GetString(2)      			--系别伤害加成
	RoleInfoConfig.HeroTroops = tonumber(ObjectInfo[3])--sqReader:GetInt32(3)    				--英雄兵力
	RoleInfoConfig.SoldierTroops = tostring(ObjectInfo[4])--sqReader:GetString(4)    			--小兵兵力
	RoleInfoConfig.Skill_Range = tostring(ObjectInfo[5])--sqReader:GetString(5)    				--技能提示图片名字
    RoleInfoConfig.BattleFlag = tostring(ObjectInfo[6])--sqReader:GetString(6)    				--战旗信息

end

function RoleInfoConfig.GetRoleInfoConfig()
    return RoleInfoConfig
end

function RoleInfoConfig.GetBattleFlagInfo()
    local _BattleInfo = GameMain.StringSplit(RoleInfoConfig.BattleFlag , ",")
    local _BattleProp = {}
    for i = 1 , #_BattleInfo , 1 do
        local _x , _y = math.modf(i/2)
        if _y==0 then                   --偶数
           table.insert( _BattleProp , #_BattleProp + 1 , tonumber(_BattleInfo[i]))     
        end

    end
    return _BattleProp
end

return RoleInfoConfig