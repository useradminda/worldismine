RoleExpConfig = {}
RoleExpConfig.RoleExpConfig = {}
function RoleExpConfig.IniSome()

	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("RoleExp")
	while (sqReader:Read() ~= false) 
	do
		local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local _Lvl= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
--        local _Lvl = sqReader:GetInt32(0)
        RoleExpConfig.RoleExpConfig[_Lvl] = {        
            Lvl = _Lvl,           --lvl       
            Exp = tonumber(ObjectInfo[1]),--sqReader:GetInt32(1),          --exp
            Train_8_need = tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),          --exp
            Train_12_need = tonumber(ObjectInfo[3]),--sqReader:GetInt32(3),          --exp
            Train_24_need = tonumber(ObjectInfo[4]),--sqReader:GetInt32(4),          --exp
			AllExp = tonumber(ObjectInfo[5]),--sqReader:GetInt32(5),			--所有的exp
		}     
    end
end

function RoleExpConfig.GetRoleExpConfig(_Lvl)
    
    if RoleExpConfig.RoleExpConfig[tonumber(_Lvl)]~=nil then
       return RoleExpConfig.RoleExpConfig[tonumber(_Lvl)]
    end
    Debug.LogError("数据库RoleExp等级配置错误_Lvl:")
    Debug.LogError(_Lvl)
    return nil
end

function RoleExpConfig.GetRoleExp()
    
    return RoleExpConfig.RoleExpConfig

end

return RoleExpConfig