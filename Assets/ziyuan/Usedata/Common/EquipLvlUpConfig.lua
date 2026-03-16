EquipLvlUpConfig = {}
EquipLvlUpConfig.EquipLvlUpConfigData = {}
function EquipLvlUpConfig.IniSome()

	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Equip_Lvl_Up")
	while (sqReader:Read() ~= false) 
	do
		local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local _Lvl= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
--        local _Lvl = sqReader:GetInt32(0)
        EquipLvlUpConfig.EquipLvlUpConfigData[_Lvl] = {        
            Id = _Lvl,--sqReader:GetInt32(0),                        --ID          
            Weapon = tonumber(ObjectInfo[1]),--sqReader:GetInt32(1),                     --名字  
            Casque = tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),                  --名字  
            Breastplate = tonumber(ObjectInfo[3]),--sqReader:GetInt32(3),                 --等级modify     
            Wrister = tonumber(ObjectInfo[4]),--sqReader:GetInt32(4),                 --
            Shoes = tonumber(ObjectInfo[5]),--sqReader:GetInt32(5),                 --          
            Cloak = tonumber(ObjectInfo[6]),--sqReader:GetInt32(6), 
            Amulet = tonumber(ObjectInfo[7]),--sqReader:GetInt32(7),
            Ring = tonumber(ObjectInfo[8]),--sqReader:GetInt32(8),
		}     
    end
end

function EquipLvlUpConfig.GetEquipExpByLvl(_Id)				--根据等级获得
    
    if EquipLvlUpConfig.EquipLvlUpConfigData[tonumber(_Id)]~=nil then
       return EquipLvlUpConfig.EquipLvlUpConfigData[tonumber(_Id)]
    end
    Debug.LogError("数据库Equip_Lvl_Up等级配置错误Lvl:")
    Debug.LogError(_Id)
    return nil
end

function EquipLvlUpConfig.GetEquipUpLvlCost(_Id , _Type)
	local data = EquipLvlUpConfig.GetEquipExpByLvl(_Id)
	if data == nil then
		return 0
	end
	if _Type ==1 then
		return data.Weapon
	end
	if _Type ==2 then
		return data.Casque
	end
	if _Type ==3 then
		return data.Breastplate
	end
	if _Type ==4 then
		return data.Wrister
	end
	if _Type ==5 then
		return data.Shoes
	end
	if _Type ==6 then
		return data.Cloak
	end
	if _Type ==7 then
		return data.Amulet
	end
	if _Type ==8 then
		return data.Ring
	end
end

function EquipLvlUpConfig.GetEquipLvlUpConfig()
    
    return EquipLvlUpConfig.EquipLvlUpConfigData

end

return EquipLvlUpConfig