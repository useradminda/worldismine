GuideDataSys = {}

function GuideDataSys.GetOneGuide(_BigStep , _SmallStep)
   return GuideConfig.GetGuideConfigById(_BigStep , _SmallStep)
end

function GuideDataSys.GetTotalSmallStep(_BigStep)
   if GuideConfig.GuideConfig[tonumber(_BigStep)]~=nil then
      return #GuideConfig.GuideConfig[tonumber(_BigStep)]
   else
     -- Debug.LogError("没有当前步骤 GetTotalSmallStep:")
     -- Debug.LogError(_BigStep)
   end
   return nil
end

function GuideDataSys.GetBigStep(_BigStep)
   if GuideConfig.GuideConfig[tonumber(_BigStep)]~=nil then
      return GuideConfig.GuideConfig[tonumber(_BigStep)]
   else
    --  Debug.LogError("没有当前步骤 GetBigStep:")
    --  Debug.LogError(_BigStep)
   end
   return nil
end

return GuideDataSys