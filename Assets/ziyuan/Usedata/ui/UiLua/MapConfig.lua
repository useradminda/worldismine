MapConfig = {}                                                            
MapConfig.MapConfig = {}
MapConfig.Chapter_MapConfig = {}
function MapConfig.IniSome()

	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("LevelMap")
	while (sqReader:Read() ~= false) 
	do
		local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local _DBid= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
--        local _DBid = sqReader:GetInt32(0)
        MapConfig.MapConfig[_DBid] = {        
            DBid = _DBid,                        --ID                                  
            Name = tostring(ObjectInfo[1]),--sqReader:GetString(1),                     --名字  
            Type = tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),                  --模型名字
            Turn = tonumber(ObjectInfo[3]),--sqReader:GetInt32(3),                     --生命
            Descrip = tostring(ObjectInfo[4]),--sqReader:GetString(4),                   --攻击参数
            Chapter_Id = tonumber(ObjectInfo[5]),--sqReader:GetInt32(5),                --移动速度
            Strenth = tonumber(ObjectInfo[6]),--sqReader:GetInt32(6),              --攻击速度
            Reward = tostring(ObjectInfo[7]),--sqReader:GetString(7),                  --防御速度
            Music = tostring(ObjectInfo[8]),--sqReader:GetString(8),               --攻击类型
            Scene = tostring(ObjectInfo[9]),--sqReader:GetString(9),             --警戒范围
            Config = tostring(ObjectInfo[10]),--sqReader:GetString(10),                 --人物类型
            Map_Length = tonumber(ObjectInfo[11]),--sqReader:GetInt32(11),               --人物系别
            Map_Wide = tonumber(ObjectInfo[12]),--sqReader:GetInt32(12),                --进阶材料
            My_Pos = tonumber(ObjectInfo[13]),--sqReader:GetInt32(13),             --材料数量
            Ememy_Pos = tonumber(ObjectInfo[14]),--sqReader:GetInt32(14),                    --头像
            MyCamp_Id = tonumber(ObjectInfo[15]),--sqReader:GetInt32(15),                   --类型1
            MyCamp_PosX = tonumber(ObjectInfo[16]),--sqReader:GetInt32(16),                --普攻技能
            MyCamp_PosZ = tonumber(ObjectInfo[17]),--sqReader:GetInt32(17),                 --携带技能
            EnemyCamp_Id = tonumber(ObjectInfo[18]),--sqReader:GetInt32(18),                 --携带技能
            EnemyCamp_PosX = tonumber(ObjectInfo[19]),--sqReader:GetInt32(19),                 --携带技能
            EnemyCamp_PosZ = tonumber(ObjectInfo[20]),--sqReader:GetInt32(20),                 --携带技能
			 
			Camp1ChengbaoHp = tonumber(ObjectInfo[21]),--sqReader:GetInt32(21),                 --携带技能
            Camp2ChengbaoHp = tonumber(ObjectInfo[22]),--sqReader:GetInt32(22),                 --携带技能
			-- 23 24 不用
			TipOpenRoleDbid = tonumber(ObjectInfo[25]),--sqReader:GetInt32(25),   			--副本开放显示提示角色
			
			
			HpAdd= tonumber(ObjectInfo[27]),--sqReader:GetFloat(27),		--副本血量加成
			AttAdd= tonumber(ObjectInfo[26]),--sqReader:GetFloat(26),	--副本攻击加成
			
			
		}
    end
end

function MapConfig.GetMapConfigById(_Id)
    if MapConfig.MapConfig[tonumber(_Id)]~=nil then
       return MapConfig.MapConfig[tonumber(_Id)]
    end
    Debug.LogError("数据库LevelMap配置错误id:")
    Debug.LogError(_Id)
    return nil
end

function MapConfig.GetMapByChapterIDMapID(_ChapterId , _MapId)
   for key , value in pairs(MapConfig.MapConfig) do
       if value.Chapter_Id == _ChapterId then
          if value.DBid == _MapId then
             return value
          end
       end
   end
   return nil
end

function MapConfig.GetMapByChapterIDMapTurn(_ChapterId , _MapTurn)
   for key , value in pairs(MapConfig.MapConfig) do
       if value.Chapter_Id == _ChapterId then
          if value.Turn == _MapTurn then
             return value
          end
       end
   end
   return nil
end

function  MapConfig.GetMapConfigData()
    
    return MapConfig.MapConfig

end

return MapConfig