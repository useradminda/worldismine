--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
ItemDataConfig={}
ItemDataConfig.ItemData={}

function ItemDataConfig.IniSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Item")
	while (sqReader:Read()~=false) do
--		local id=sqReader:GetInt32(0)
		 local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
		ItemDataConfig.ItemData[id]=
		{
			Id=id,
			Name=tostring(ObjectInfo[1]),--sqReader:GetString(1),
			Description= tostring(ObjectInfo[2]),--sqReader:GetString(2),
			Icon= tostring(ObjectInfo[3]),--sqReader:GetString(3),
			Quality= tonumber(ObjectInfo[4]),--sqReader:GetInt32(4),--品质
			Type= tonumber(ObjectInfo[5]),--sqReader:GetInt32(5),--类型
			Layer_count= tonumber(ObjectInfo[6]),--sqReader:GetInt32(6),
			Is_Sell= tonumber(ObjectInfo[7]),--sqReader:GetInt32(7),--能否被出售 int 1-可以，0-不行
			Price= tonumber(ObjectInfo[8]),--sqReader:GetInt32(8),
			Is_Visible= tonumber(ObjectInfo[9]),--sqReader:GetInt32(9),--背包是否可见 1可以0不可以
			Using= tonumber(ObjectInfo[10]),--sqReader:GetInt32(10),
			IsUse= tonumber(ObjectInfo[11]),--sqReader:GetInt32(11)
     
		}
		local _Icons = GameMain.StringSplit(ItemDataConfig.ItemData[id].Icon , ",")
        ItemDataConfig.ItemData[id].AtlasName = _Icons[1]
        ItemDataConfig.ItemData[id].SpriteName = _Icons[2]
	end
end
function ItemDataConfig.GetItemDBConfig(id)
	if ItemDataConfig.ItemData[tonumber(id)]~=nil then
		return ItemDataConfig.ItemData[tonumber(id)]
	end

	Debug.LogError("Item表配置错误ID:")
    Debug.LogError(id)
    return nil
end


return ItemDataConfig
--endregion