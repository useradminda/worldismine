--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
SignDataConfig={}
SignDataConfig.SignData={}

function SignDataConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Sign")
	while (sqReader:Read()~=false) do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[1])--sqReader:GetInt32(1)
		SignDataConfig.SignData[id]={
			Day=id,	--累计收取的数量
			Description = tostring(ObjectInfo[2]),--sqReader:GetString(2),
			Reward = tostring(ObjectInfo[3]),--sqReader:GetString(3),
			}
		local _RewardStrs = GameMain.StringSplit(SignDataConfig.SignData[id].Reward , ",")
		SignDataConfig.SignData[id].RewardAtlasName = _RewardStrs[0]
		SignDataConfig.SignData[id].RewardSpriteName = _RewardStrs[1]
	end
end

function SignDataConfig.GetSignDBConfig(count)		--根据领取的次数获得数据
	if SignDataConfig.SignData[tonumber(count)]~=nil then
       return SignDataConfig.SignData[tonumber(count)]
    end
    Debug.LogError("Sign表配置错误:")
    Debug.LogError(count)
    return nil
end

function SignDataConfig.GetAllData()
	return SignDataConfig.SignData
end

return SignDataConfig

--endregion
