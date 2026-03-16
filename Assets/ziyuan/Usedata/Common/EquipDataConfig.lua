--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
EquipDataConfig={}
EquipDataConfig.EquipData={}

function EquipDataConfig.IniSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Equip")
	while (sqReader:Read()~=false) do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
		EquipDataConfig.EquipData[id]={
			Id=id,--编号
			Name= tostring(ObjectInfo[1]),--sqReader:GetString(1),--名称
			Type=tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),--类型  1-武器;2-头盔;3-胸甲;4-护腕;5-鞋子;6-披风;7-护符;8-戒指
			Quality=tonumber(ObjectInfo[3]),--sqReader:GetInt32(3),--品质 1-白;2-绿;3-青;4-紫;5-金;6-橙;7-红
			Star=tonumber(ObjectInfo[4]),--sqReader:GetInt32(4),--星级
			UpgradeAtt=tostring(ObjectInfo[5]),--sqReader:GetString(5),--强化攻击(基础值,等级增加值)
			UpgradeHp=tostring(ObjectInfo[6]),--sqReader:GetString(6),--强化生命(基础值,等级增加值)
			UpgradeSpeed=tostring(ObjectInfo[7]),--sqReader:GetString(7),--强化攻速(基础值,等级增加值)
			
			RefineAtt=tostring(ObjectInfo[8]),--sqReader:GetString(8),--洗练攻击
			RefineHp=tostring(ObjectInfo[9]),--sqReader:GetString(9),--洗练生命
			RefineSpeed=tostring(ObjectInfo[10]),--sqReader:GetString(10),--洗练攻速
			IsRecast=tonumber(ObjectInfo[11]),--sqReader:GetInt32(11),--能否重铸
			IsRefine=tonumber(ObjectInfo[12]),--sqReader:GetInt32(12),--能否洗练
			IsSell=tonumber(ObjectInfo[13]),--sqReader:GetInt32(13),--能否出售
			SellPriec=tonumber(ObjectInfo[14]),--sqReader:GetInt32(14),--出售价格
			BuyPrice=tonumber(ObjectInfo[18]),--sqReader:GetInt32(15),--购买价格
			Descrip=tostring(ObjectInfo[15]),--sqReader:GetString(16),--描述
			Icon=tostring(ObjectInfo[16]),--sqReader:GetString(17),--ICon(ID，数量)
			AdvanceId = tostring(ObjectInfo[17]),--sqReader:GetInt32(18),--进阶后的ID
            }
			
			local _upgradeAttList=GameMain.StringSplit(EquipDataConfig.EquipData[id].UpgradeAtt , ",")
			EquipDataConfig.EquipData[id].UpgradeAttList=_upgradeAttList

			local _upgradeHpList=GameMain.StringSplit(EquipDataConfig.EquipData[id].UpgradeHp , ",")
			EquipDataConfig.EquipData[id].UpgradeHpList=_upgradeHpList

			local _upgradeSpeedList=GameMain.StringSplit(EquipDataConfig.EquipData[id].UpgradeSpeed , ",")
			EquipDataConfig.EquipData[id].UpgradeSpeedList=_upgradeSpeedList

			
			local Icons = GameMain.StringSplit(EquipDataConfig.EquipData[id].Icon , ",")
            EquipDataConfig.EquipData[id].AtlasName=Icons[1]
			EquipDataConfig.EquipData[id].SpriteName=Icons[2]
	end
end

function EquipDataConfig.GetEquipDBConfig(id)
	if EquipDataConfig.EquipData[tonumber(id)]~=nil then
       return EquipDataConfig.EquipData[tonumber(id)]
    end
    Debug.LogError("equip表配置错误ID:")
    Debug.LogError(id)
    return nil
end
function EquipDataConfig.GetEquipByQuality( _Id , _Quality)
   for key , value in pairs(EquipDataConfig.EquipData) do
       if value.Id ==_Id and value.Quality == _Qulity then
          return value
       end
   end
   Debug.LogError("equip表配置错误Quality:")
   Debug.LogError(_Quality)
   return nil
end
return EquipDataConfig

--endregion
