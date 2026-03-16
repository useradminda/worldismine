WorldMapDataSys = {}

function WorldMapDataSys.GetCityNodesData()
   if WorldMapConfig.WorldMapConfig~=nil then
      if #WorldMapConfig.WorldMapConfig~=0 then
         return WorldMapConfig.WorldMapConfig
      end
   else
      return nil
   end
end


return WorldMapDataSys