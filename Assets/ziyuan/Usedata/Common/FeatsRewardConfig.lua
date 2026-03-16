FeatsRewardConfig={}
FeatsRewardConfig.FeatsRewardConfig={}

function FeatsRewardConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("FeatsReward")
	while (sqReader:Read()~=false) do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local _Lvl= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
		FeatsRewardConfig.FeatsRewardConfig[_Lvl]=
        {
			Lvl= _Lvl,	--活动ID
			TopFeats = tonumber(ObjectInfo[1]),-- sqReader:GetInt32(1),            --总荣耀
            Feats1 = tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),              --
            Feats2 = tonumber(ObjectInfo[3]),--sqReader:GetInt32(3),             --事件名称
            Feats3 = tonumber(ObjectInfo[4]),--sqReader:GetInt32(4),             --描述1
            Feats4 = tonumber(ObjectInfo[5]),--sqReader:GetInt32(5),             --描述1
            Feats5 = tonumber(ObjectInfo[6]),--sqReader:GetInt32(6),             --描述1
         
		}
        if FeatsRewardConfig.FeatsRewardConfig[_Lvl].Feats == nil then
           FeatsRewardConfig.FeatsRewardConfig[_Lvl].Feats = {}
        end
        table.insert(FeatsRewardConfig.FeatsRewardConfig[_Lvl].Feats , #FeatsRewardConfig.FeatsRewardConfig[_Lvl].Feats + 1 , FeatsRewardConfig.FeatsRewardConfig[_Lvl].Feats1)
        table.insert(FeatsRewardConfig.FeatsRewardConfig[_Lvl].Feats , #FeatsRewardConfig.FeatsRewardConfig[_Lvl].Feats + 1, FeatsRewardConfig.FeatsRewardConfig[_Lvl].Feats2)
        table.insert(FeatsRewardConfig.FeatsRewardConfig[_Lvl].Feats , #FeatsRewardConfig.FeatsRewardConfig[_Lvl].Feats + 1, FeatsRewardConfig.FeatsRewardConfig[_Lvl].Feats3)
        table.insert(FeatsRewardConfig.FeatsRewardConfig[_Lvl].Feats , #FeatsRewardConfig.FeatsRewardConfig[_Lvl].Feats + 1, FeatsRewardConfig.FeatsRewardConfig[_Lvl].Feats4)
        table.insert(FeatsRewardConfig.FeatsRewardConfig[_Lvl].Feats , #FeatsRewardConfig.FeatsRewardConfig[_Lvl].Feats + 1, FeatsRewardConfig.FeatsRewardConfig[_Lvl].Feats5)
	end
end

function FeatsRewardConfig.GetFeatsRewardByLvl(_Lvl)		            --根据活动ID获得数据
    if _Lvl > 1 and _Lvl < 20 then
       return FeatsRewardConfig.FeatsRewardConfig[1]
    elseif _Lvl >= 20 and _Lvl < 30 then
       return FeatsRewardConfig.FeatsRewardConfig[20]
    elseif _Lvl >= 30 and _Lvl < 40 then
       return FeatsRewardConfig.FeatsRewardConfig[30]
    elseif _Lvl >= 40 and _Lvl < 50 then
       return FeatsRewardConfig.FeatsRewardConfig[40]
    elseif _Lvl >= 50 and _Lvl < 60 then
       return FeatsRewardConfig.FeatsRewardConfig[50]
    elseif _Lvl >= 60 and _Lvl < 70 then
       return FeatsRewardConfig.FeatsRewardConfig[60]
    elseif _Lvl >= 70 and _Lvl < 80 then
       return FeatsRewardConfig.FeatsRewardConfig[70]
    elseif _Lvl >= 80 and _Lvl <= 90 then
       return FeatsRewardConfig.FeatsRewardConfig[80]
    elseif _Lvl >= 90 and _Lvl < 100 then
       return FeatsRewardConfig.FeatsRewardConfig[90]
    elseif _Lvl == 100 then
       return FeatsRewardConfig.FeatsRewardConfig[100]
    end

    Debug.LogError("FeatsReward表配置错误:")
    Debug.LogError(_Lvl)
    return nil
end


return FeatsRewardConfig