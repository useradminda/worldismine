ShopConfig = {}
ShopConfig.ShopConfig = {}
function ShopConfig.IniSome()

	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("GoldShop")
	while (sqReader:Read() ~= false) 
	do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
        local _Id = tonumber(ObjectInfo[0])--sqReader:GetInt32(0)
        ShopConfig.ShopConfig[_Id] = 
        {        
            Id = tonumber(ObjectInfo[0]),--sqReader:GetInt32(0),                   --ID       
            Type = tonumber(ObjectInfo[1]),--sqReader:GetInt32(1),                 --商品类型
            GoodsId = tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),              --物品ID
            GoodsPos = tonumber(ObjectInfo[3]),--sqReader:GetInt32(3),             --物品Pos
            CurrencyType = tonumber(ObjectInfo[4]),--sqReader:GetInt32(4),         --货币类型
            CurrencyParam = tonumber(ObjectInfo[5]),--sqReader:GetInt32(5),        --数量
		}     
    end
end

function ShopConfig.GetShopConfigById(_Id)   
    if ShopConfig.ShopConfig[tonumber(_Id)]~=nil then
       return ShopConfig.ShopConfig[tonumber(_Id)]
    end
    Debug.LogError("数据库GoldShop等级配置错误_Id:")
    Debug.LogError(_Id)
    return nil
end

function ShopConfig.GetShopConfigByType(_Type)
    local data = {}
    for key , value in pairs(ShopConfig.ShopConfig) do
        if value.Type == _Type then 
           table.insert(data , #data + 1 , value)
        end
    end
    return data
end

function ShopConfig.GetShopConfig()
    
    return ShopConfig.ShopConfig

end

return ShopConfig