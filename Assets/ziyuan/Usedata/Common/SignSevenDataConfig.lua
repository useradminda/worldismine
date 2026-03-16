--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
SignSevenDataConfig={}
SignSevenDataConfig.SignSevenData={}

function SignSevenDataConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Seven_Login")
	while (sqReader:Read()~=false) do
		local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
--		local id=sqReader:GetInt32(0)
		SignSevenDataConfig.SignSevenData[id]={
			Day=id,	--累计收取的数量
			Description = tostring(ObjectInfo[1]),--sqReader:GetString(1),
			Reward = tostring(ObjectInfo[2]),--sqReader:GetString(2),
			}
	end
end

function SignSevenDataConfig.GetSignSevenDBConfig(count)		--根据领取的次数获得数据
	if SignSevenDataConfig.SignSevenData[tonumber(count)]~=nil then
       return SignSevenDataConfig.SignSevenData[tonumber(count)]
    end
    Debug.LogError("SignSeven表配置错误:")
    Debug.LogError(count)
    return nil
end

function SignSevenDataConfig.GetAllData()
	return SignSevenDataConfig.SignSevenData
end

return SignSevenDataConfig

--endregion
