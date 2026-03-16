--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
HeroShopConfig={}
HeroShopConfig.HeroShopData={}

function HeroShopConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("HeroShop")
	while (sqReader:Read()~=false) do
		local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
		HeroShopConfig.HeroShopData[id]={
			Id = id,				--礼包ID	
			Type = tonumber(ObjectInfo[1]),--sqReader:GetInt32(1),--类型
			Reward = tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),	--获得的武将/将魂
			NeedPrice = tonumber(ObjectInfo[3]) --sqReader:GetInt32(3), 
			
			}
	end
end

function HeroShopConfig.GetHeroShopItemById(_Id)		--根据id获得数据
	if HeroShopConfig.HeroShopData[tonumber(_Id)]~=nil then
       return HeroShopConfig.HeroShopData[tonumber(_Id)]
    end
    Debug.LogError("HeroShop表配置错误:")
    Debug.LogError(_Id)
    return nil
end

function HeroShopConfig.GetAllData()
	return HeroShopConfig.HeroShopData
end


return HeroShopConfig

--endregion
