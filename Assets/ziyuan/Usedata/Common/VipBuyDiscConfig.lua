--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
VipBuyDiscConfig={}
VipBuyDiscConfig.VipBuyDiscData={}

function VipBuyDiscConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Vip_Buy_Disc")
--	local index = 1
	while (sqReader:Read()~=false) do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local _ID = tonumber(ObjectInfo[0])
		VipBuyDiscConfig.VipBuyDiscData[_ID]={
			Id = tonumber(ObjectInfo[0]),
			HeroId = tostring(ObjectInfo[1]),--sqReader:GetInt32(1),
			Icon = tostring(ObjectInfo[2]),-- sqReader:GetInt32(2),
			Name = tostring(ObjectInfo[3]),
			Quality = tonumber(ObjectInfo[4]),
			}
		local iconList = GameMain.StringSplit(VipBuyDiscConfig.VipBuyDiscData[_ID].Icon ,"," )
		VipBuyDiscConfig.VipBuyDiscData[_ID].AtlasName = iconList[1]
		VipBuyDiscConfig.VipBuyDiscData[_ID].SpriteName = iconList[2]
--		index = index +1
	end
end

function VipBuyDiscConfig.GetDataById(_Id)		--根据VIP等级获取相关数据
	if VipBuyDiscConfig.VipBuyDiscData[tonumber(_Id)]~=nil then
       return VipBuyDiscConfig.VipBuyDiscData[tonumber(_Id)]
    end
    Debug.LogError("Vip_Buy_Disc表配置错误:")
    Debug.LogError(_Id)
    return nil
end

function VipBuyDiscConfig.GetAllListById(_ID)
	local data = VipBuyDiscConfig.GetDataById(_ID).HeroId
	local list = GameMain.StringSplit(data , ";")
	local heroIdList = {}
	for key,value in pairs(list) do
		local itemLists =  GameMain.StringSplit(value,",")
		table.insert(heroIdList , #heroIdList +1 , itemLists[1])
	end
	return heroIdList
end

function VipBuyDiscConfig.GetAllData()
	return VipBuyDiscConfig.VipBuyDiscData
end

return VipBuyDiscConfig

--endregion
