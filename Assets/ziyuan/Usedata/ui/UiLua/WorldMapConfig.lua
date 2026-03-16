WorldMapConfig = {}                                                             --世界地图数据表
WorldMapConfig.WorldMapConfig = {}
WorldMapConfig.Number = 0
function WorldMapConfig.IniSome()

	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("WorldMap")
    WorldMapConfig.Number = 1
	while (sqReader:Read() ~= false) 
	do
		local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
	
		WorldMapConfig.WorldMapConfig[WorldMapConfig.Number] = {        
            CityId = tonumber(ObjectInfo[0]),-- sqReader:GetInt32(0),                                                                 
            CityName = tostring(ObjectInfo[1]),--sqReader:GetString(1),                    --城市名字
            OwnerShip = tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),                    --城市归属  
            CityType = tonumber(ObjectInfo[3]),--sqReader:GetInt32(3),                     --郡 县 首都
            CityPosition = tostring(ObjectInfo[4]),--sqReader:GetString(4),                --城市坐标
            CityGuard = tonumber(ObjectInfo[5]),--sqReader:GetInt32(5),                   --城市守卫
            CityAround1 = tostring(ObjectInfo[6]),--sqReader:GetString(6),                 --相邻城池
            CityAround2 = tostring(ObjectInfo[7]),--sqReader:GetString(7),                 --相邻城池
            CityAround3 = tostring(ObjectInfo[8]),--sqReader:GetString(8),                 --相邻城池
            CityAround4 = tostring(ObjectInfo[9]),--sqReader:GetString(9),                 --相邻城池
            CityAround5 = tostring(ObjectInfo[10]),--sqReader:GetString(10),                --相邻城池
            --SpecialGuard = sqReader:GetString(11),               --特殊守卫

		}
        local Poses = GameMain.StringSplit(WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityPosition , ",")
        WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].PosX = tonumber(Poses[1])    
        WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].PosY = tonumber(Poses[2])

        if WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityGuard=="0" then
           WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].GuardNumber = 0
           WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].GuardType = 0
        else
           local Guards = GameMain.StringSplit(WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityGuard , ",")
           WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].GuardType = tonumber(Guards[1])
           WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].GuardNumber = tonumber(Guards[2])
        end

        local CityAroundNum = 1
        if WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityAround==nil then
           WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityAround = {}
        end
        if WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityTime==nil then
           WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityTime = {}
        end

        if WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityAround1~="0" then          
           local CityAround1 = GameMain.StringSplit(WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityAround1 , ",")
           local CityMapId = WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityId
           WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityAround[CityAroundNum] = tonumber(CityAround1[1])
           WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityTime[tostring(CityMapId).."_"..tostring(CityAround1[1])] = tonumber(CityAround1[2])
           CityAroundNum = CityAroundNum + 1
        end

        if WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityAround2~="0" then          
           local CityAround2 = GameMain.StringSplit(WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityAround2 , ",")
           local CityMapId = WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityId
           WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityAround[CityAroundNum] = tonumber(CityAround2[1])
           WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityTime[tostring(CityMapId).."_"..tostring(CityAround2[1])] = tonumber(CityAround2[2])
           CityAroundNum = CityAroundNum + 1
        end

        if WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityAround3~="0" then          
           local CityAround3 = GameMain.StringSplit(WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityAround3 , ",")
           local CityMapId = WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityId
           WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityAround[CityAroundNum] = tonumber(CityAround3[1])
           WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityTime[tostring(CityMapId).."_"..tostring(CityAround3[1])] = tonumber(CityAround3[2])
           CityAroundNum = CityAroundNum + 1
        end

        if WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityAround4~="0" then          
           local CityAround4 = GameMain.StringSplit(WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityAround4 , ",")
           local CityMapId = WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityId
           WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityAround[CityAroundNum] = tonumber(CityAround4[1])
           WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityTime[tostring(CityMapId).."_"..tostring(CityAround4[1])] = tonumber(CityAround4[2])
           CityAroundNum = CityAroundNum + 1
        end
        
        if WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityAround5~="0" then          
           local CityAround5 = GameMain.StringSplit(WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityAround5 , ",")
           local CityMapId = WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityId
           WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityAround[CityAroundNum] = tonumber(CityAround5[1])
           WorldMapConfig.WorldMapConfig[WorldMapConfig.Number].CityTime[tostring(CityMapId).."_"..tostring(CityAround5[1])] = tonumber(CityAround5[2])
           CityAroundNum = CityAroundNum + 1
        end

        WorldMapConfig.Number = WorldMapConfig.Number + 1
	end
end


function WorldMapConfig.GetCityById(_Id)              --根据VIP等级查询VIP特权
   
   for i = 1 , #WorldMapConfig.WorldMapConfig , 1 do
       if WorldMapConfig.WorldMapConfig[i].CityId == _Id then
          return WorldMapConfig.WorldMapConfig[i]
       end
   end
   Debug.LogError("查询的城市ID错误，ID：")
   Debug.LogError(_Id)
   return nil
end

function WorldMapConfig.GetMaxLevel()


end

return WorldMapConfig