--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
HeroDiscConfig={}
HeroDiscConfig.HeroDiscData={}

function HeroDiscConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("HeroDisc")
	while (sqReader:Read()~=false) do
		local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
		HeroDiscConfig.HeroDiscData[id]={
			Id = id, 
			Reward = tonumber(ObjectInfo[1]),--sqReader:GetInt32(1),
			Chance = tonumber(ObjectInfo[2])--sqReader:GetInt32(2),
			}
	end
end

function HeroDiscConfig.GetDataById(_Id)		--根据VIP等级获取相关数据
	if HeroDiscConfig.HeroDiscData[tonumber(_Id)]~=nil then
       return HeroDiscConfig.HeroDiscData[tonumber(_Id)]
    end
    Debug.LogError("HeroDisc表配置错误:")
    Debug.LogError(_Id)
    return nil
end

function HeroDiscConfig.GetAllDBData()
	return HeroDiscConfig.HeroDiscData
end

return HeroDiscConfig

--endregion
