MapDataSys = {}

function MapDataSys.GetMapByDbId(_MapId)
   if MapConfig.GetMapConfigById(_MapId)~=nil then
      return MapConfig.GetMapConfigById(_MapId)
   end
end

function MapDataSys.GetChapterByDbId(_ChapterId)
   if ChapterConfig.GetChapterConfigById(_ChapterId)~=nil then
      return ChapterConfig.GetChapterConfigById(_ChapterId)
   end
end

function MapDataSys.GetChapterByTurn(_Turn)
   if ChapterConfig.ChapterConfig[_Turn]~=nil then
      return ChapterConfig.ChapterConfig[_Turn]
   end
end

function MapDataSys.GetChapterMapCount(_ChapterId)
   local Chapter = MapDataSys.GetChapterByDbId(_ChapterId)
   if Chapter~=nil then
      return Chapter.Count
   end
   return 0
end

return MapDataSys