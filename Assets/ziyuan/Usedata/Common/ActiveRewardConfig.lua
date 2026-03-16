ActiveRewardConfig = {}
ActiveRewardConfig.ActiveRewardConfig = {}
ActiveRewardConfig.Number = 0
function ActiveRewardConfig.IniSome()

	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Active_Reward")
	while (sqReader:Read() ~= false) 
	do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
        
        ActiveRewardConfig.Number = ActiveRewardConfig.Number + 1    
        local _Active = tonumber(ObjectInfo[0])--sqReader:GetInt32(0)
        ActiveRewardConfig.ActiveRewardConfig[ActiveRewardConfig.Number] = {        
            Active = _Active,        --lvl       
            RewardId = tostring(ObjectInfo[1]),--sqReader:GetString(1),          --exp        
		}         
    end
end

function ActiveRewardConfig.GetActiveRewardByActive(_Active) 
    for i = 1 , #ActiveRewardConfig.ActiveRewardConfig , 1 do
        if ActiveRewardConfig.ActiveRewardConfig[i].Active == _Active then
           return ActiveRewardConfig.ActiveRewardConfig[i]
        end
    end
    Debug.LogError("数据库Active_Reward等级配置错误_Active:")
    Debug.LogError(_Active)
    return nil
end

function ActiveRewardConfig.GetActiveRewardConfig()
    
    return ActiveRewardConfig.ActiveRewardConfig

end

return ActiveRewardConfig