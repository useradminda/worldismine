TimeControl = {}

TimeControl.Times = 
{

}


function TimeControl.InitTime()

    GameMain.AddUpdateLua(TimeControl.UpdataTime)
    
end

function TimeControl.UpdataTime(dt)
    for key , value in pairs(TimeControl.Times) do
        if TimeControl.Times[key]~=nil and TimeControl.Times[key] > 0 then
           TimeControl.Times[key] = TimeControl.Times[key] - dt
        end
        if TimeControl.Times[key]~=nil and TimeControl.Times[key]<=0 then
           TimeControl.Times[key] = 0
        end
    end
end

function TimeControl.LoginTime(_StartTime , _TimeType) 

    TimeControl.Times[_TimeType] = tonumber(_StartTime)

end

function TimeControl.GetTime(_TimeType)
    if TimeControl.Times[_TimeType]~=nil then
       return TimeControl.Times[_TimeType]
    end
    return nil
end

function TimeControl.SetTime(_TimeType , _Time)
	if TimeControl.Times[_TimeType]~= nil then
		TimeControl.Times[_TimeType] = _Time
	end
end

function TimeControl.GetTimeString(_Time)
   if _Time==nil then
      return
   end
   local TimeHour = math.floor(_Time/3600)
   local StringHour = tostring(TimeHour)..":"
   if TimeHour<10 then
      StringHour = "0"..tostring(TimeHour)..":"
   end
   local TimeMinite = math.floor((_Time - TimeHour*3600)/60)
   local StringMinite = tostring(TimeMinite)..":"
   if TimeMinite<10 then
      StringMinite = "0"..tostring(TimeMinite)..":"
   end
   local TimeSecond = math.floor((_Time - TimeHour*3600 - TimeMinite*60))
   local StringSecond = tostring(TimeSecond)
   if TimeSecond<10 then
      StringSecond = "0"..tostring(TimeSecond)
   end
   local TimeString = StringHour..StringMinite..StringSecond
   return TimeString
end

function TimeControl.GetTimeString2(_Type)
   local _Time = TimeControl.GetTime(_Type)
   if _Time~=nil then
      local _TimeString = TimeControl.GetTimeString(_Time)
      return _TimeString
   end
   return 0
end


return TimeControl