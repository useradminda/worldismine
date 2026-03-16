TeamMakeSys = {}

local this = TeamMakeSys
TeamMakeSys = 
{
    With = 30,
    High = 31,
    WithAnt = 1,
    HighAnt = 1,
    WithAntNum = 0.3,
    HighAntNum = 0.3,
}

TeamMakeSys.AllPoints=
{
}

TeamMakeSys.PutPoint =
{

}

function TeamMakeSys.InitPonts()
   if TeamMakeSys.AllPoints[1] ~=nil then
      return
   end
   local NumX = tonumber(TeamMakeSys.With/TeamMakeSys.WithAnt)
   local NumY = tonumber(TeamMakeSys.High/TeamMakeSys.HighAnt)
   for i = 1 , NumX , 1 do
       for j = 1 , NumY , 1 do
           if i <= 25 then
               if j <= 31 then 
               local data = 
               {    
                   StartX = 0,
                   EndX = 0,
                   StartY = 0,
                   EndY = 0,
                   PosX = 0,
                   PosY = 0,
                   X = 0,
                   Y = 0,
                   IsEmpty = true,
                   IsCanPut = true,
                   --MainPoint = nil,
               }
               if TeamMakeSys.AllPoints[i]==nil then
                  TeamMakeSys.AllPoints[i] = {}
               end
               data.StartX = (i) * TeamMakeSys.WithAntNum
               data.EndX = (i + 1)* TeamMakeSys.WithAntNum
               data.StartY = (j) * TeamMakeSys.HighAntNum
               data.EndY = (j+1) * TeamMakeSys.HighAntNum
               data.PosX = (data.StartX + data.EndX)/2
               data.PosY = (data.StartY + data.EndY)/2
               data.X = i
               data.Y = j       
               TeamMakeSys.AllPoints[i][j] = data
               end
           end
           if i > 25 and i <=30 then
              if j <= 31 then 
                   local data = 
                   {    
                       StartX = 0,
                       EndX = 0,
                       StartY = 0,
                       EndY = 0,
                       PosX = 0,
                       PosY = 0,
                       X = 0,
                       Y = 0,
                       IsEmpty = true,
                       IsCanPut = false,
                       --MainPoint = nil,
                   }
                   if TeamMakeSys.AllPoints[i]==nil then
                      TeamMakeSys.AllPoints[i] = {}
                   end
                   data.StartX = (i) * TeamMakeSys.WithAntNum
                   data.EndX = (i + 1)* TeamMakeSys.WithAntNum
                   data.StartY = (j) * TeamMakeSys.HighAntNum
                   data.EndY = (j+1) * TeamMakeSys.HighAntNum
                   data.PosX = (data.StartX + data.EndX)/2
                   data.PosY = (data.StartY + data.EndY)/2
                   data.X = i
                   data.Y = j       
                   TeamMakeSys.AllPoints[i][j] = data
              end
           end
       end
   end
    
   --GameMain.Print(TeamMakeSys.AllPoints)
end

function TeamMakeSys.GetPoint(_WorldX , _WorldY)
    local NumX = math.floor(_WorldX/TeamMakeSys.WithAntNum) 
    local NumY = math.floor(_WorldY/TeamMakeSys.WithAntNum)
    --Debug.LogError(NumX)
   -- Debug.LogError(NumY)
    if TeamMakeSys.AllPoints[NumX]~=nil and TeamMakeSys.AllPoints[NumX][NumY] then
       return TeamMakeSys.AllPoints[NumX][NumY]
    else
       return nil
    end
end

function  TeamMakeSys.JudgePoint(_Point)
   if _Point==nil then
      return false
   end 
   local X = _Point.X
   local Y = _Point.Y 
   for i = 1 , 7 , 1 do
       for j = 1 , 5 , 1 do
           local _X = X - 4 + i  
           local _Y = Y - 3 + j      
           if TeamMakeSys.AllPoints[_X]~=nil and TeamMakeSys.AllPoints[_X][_Y]~=nil then
              if TeamMakeSys.AllPoints[_X][_Y].IsEmpty == false or TeamMakeSys.AllPoints[_X][_Y].IsCanPut==false then
                 return false
              end
           else
              return false
           end
       end
   end
   return true
end

function TeamMakeSys.PutDownTeamMake(_Point)
   local X = _Point.X
   local Y = _Point.Y
  -- GameMain.Print(_Point)
   for i = 1 , 7 , 1 do
       for j = 1 , 5 , 1 do
           local _X = X - 4 + i 
           local _Y = Y - 3 + j
           if TeamMakeSys.AllPoints[_X]~=nil and TeamMakeSys.AllPoints[_X][_Y]~=nil then
              TeamMakeSys.AllPoints[_X][_Y].IsEmpty = false           
              --TeamMakeSys.AllPoints[_X][_Y].MainPoint = _Point
           end
       end
   end
   if TeamMakeSys.PutPoint[X]==nil then
      TeamMakeSys.PutPoint[X] = {}
   end
   TeamMakeSys.PutPoint[X][Y] = _Point
end

function TeamMakeSys.GetPutSoliderPoint(_Point)                --¸ü»»±øÖÖ
    if _Point.IsEmpty==false then
       if _Point.MainPoint~=nil then
          return _Point.MainPoint
       else
          return nil
       end
    else
       return nil
    end
end

function TeamMakeSys.ClearPutPoint(X , Y)
   for i = 1 , 7 , 1 do
       for j = 1 , 5 , 1 do
           local _X = X - 4 + i 
           local _Y = Y - 3 + j
           if TeamMakeSys.AllPoints[_X]~=nil and TeamMakeSys.AllPoints[_X][_Y]~=nil then
              TeamMakeSys.AllPoints[_X][_Y].IsEmpty = true
              --TeamMakeSys.AllPoints[_X][_Y].MainPoint = nil
           end
       end
   end
end

function TeamMakeSys.ClearAllPoints()
   for i = 1 , 30 , 1 do
       for j = 1 , 30 , 1 do
           if TeamMakeSys.AllPoints[i]~=nil and TeamMakeSys.AllPoints[i][j]~=nil then
              TeamMakeSys.AllPoints[i][j].IsEmpty = true
           end
       end
   end
end

function TeamMakeSys.GetPointByNum(_X , _Y)
   if TeamMakeSys.AllPoints[_X][_Y]~=nil then
      return TeamMakeSys.AllPoints[_X][_Y]
   else
      return nil
   end
end

return TeamMakeSys