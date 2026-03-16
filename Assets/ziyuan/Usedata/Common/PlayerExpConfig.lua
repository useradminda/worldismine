PlayerExpConfig = {}
PlayerExpConfig.PlayerExpConfig = {}
function PlayerExpConfig.InitSome()

	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("PlayerExp")
	while (sqReader:Read() ~= false) 
	do
		local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
        local _Lvl = tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
        PlayerExpConfig.PlayerExpConfig[_Lvl] = {        
            Id = _Lvl,           --lvl       
            Exp = tonumber(ObjectInfo[1]),          --exp
			AllExp = tonumber(ObjectInfo[2]),		--allExp
		}     
    end
end

function PlayerExpConfig.GetPlayerExpConfig(_Lvl)
    
    if PlayerExpConfig.PlayerExpConfig[tonumber(_Lvl)]~=nil then
       return PlayerExpConfig.PlayerExpConfig[tonumber(_Lvl)]
    end
    Debug.LogError("数据库PlayerExp等级配置错误_Lvl:")
    Debug.LogError(_Id)
    return nil
end

function PlayerExpConfig.GetAllPlayerExpConfig()
    
    return PlayerExpConfig.PlayerExpConfig

end

return PlayerExpConfig