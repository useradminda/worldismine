WorldActivityConfig = {}
WorldActivityConfig.WorldActivityConfig ={}

function WorldActivityConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("WorldActivity")
	while (sqReader:Read()~=false) do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0])--sqReader:GetInt32(0)
		WorldActivityConfig.WorldActivityConfig[id]={
			DBid = id,	--累计收取的数量
			Name = tostring(ObjectInfo[1]),--sqReader:GetString(1),
			Description = tostring(ObjectInfo[2]),--sqReader:GetString(2),
            ActivityType = tonumber(ObjectInfo[5]),--sqReader:GetInt32(5),
            MovePath =tostring(ObjectInfo[17]),-- sqReader:GetString(17),
            Time = tostring(ObjectInfo[20]),--sqReader:GetString(20),
               
			}
        if WorldActivityConfig.WorldActivityConfig[id].MovePath~="0" then-- and WorldActivityConfig.WorldActivityConfig[id].ActivityType==2 then
           local _MovePathTotal =  GameMain.StringSplit(WorldActivityConfig.WorldActivityConfig[id].MovePath , ",")         
           local _MovePathOne = GameMain.StringSplit(_MovePathTotal[1] , "|") 
           if WorldActivityConfig.WorldActivityConfig[id].MoveNodes == nil then
              WorldActivityConfig.WorldActivityConfig[id].MoveNodes = {}
           end           
           WorldActivityConfig.WorldActivityConfig[id].MoveNodes[1] = _MovePathOne
           local _MovePathTwo = GameMain.StringSplit(_MovePathTotal[2] , "|")     
           WorldActivityConfig.WorldActivityConfig[id].MoveNodes[2] = _MovePathTwo
           local _MovePathThree = GameMain.StringSplit(_MovePathTotal[3] , "|")     
           WorldActivityConfig.WorldActivityConfig[id].MoveNodes[3] = _MovePathThree
        end
	end
end

function WorldActivityConfig.GetWorldActivityConfig(_Index)		--根据领取的次数获得数据
	if WorldActivityConfig.WorldActivityConfig[tonumber(_Index)]~=nil then
       return WorldActivityConfig.WorldActivityConfig[tonumber(_Index)]
    end
    Debug.LogError("WorldActivity表配置错误:")
    Debug.LogError(_Index)
    return nil
end

function WorldActivityConfig.GetArmyNodesByIndex(_RoomId)
   for i = 1 , #WorldActivityConfig.WorldActivityConfig[2].MoveNodes , 1 do 
       for j = 1 , #WorldActivityConfig.WorldActivityConfig[2].MoveNodes[i] - 1 , 1 do
           local _MoveNodeId = tonumber(WorldActivityConfig.WorldActivityConfig[2].MoveNodes[i][j])
           if _RoomId==_MoveNodeId then
              return WorldActivityConfig.WorldActivityConfig[2].MoveNodes[i] , j
           end
       end
   end
   Debug.LogError("WorldActivity表配置错误RoomId:")
   Debug.LogError(_RoomId)
   for i = 1 , #WorldActivityConfig.WorldActivityConfig[301].MoveNodes , 1 do 
       for j = 1 , #WorldActivityConfig.WorldActivityConfig[301].MoveNodes[i] - 1 , 1 do
           local _MoveNodeId = tonumber(WorldActivityConfig.WorldActivityConfig[301].MoveNodes[i][j])
           if _RoomId==_MoveNodeId then
              return WorldActivityConfig.WorldActivityConfig[301].MoveNodes[i] , j
           end
       end
   end
   for i = 1 , #WorldActivityConfig.WorldActivityConfig[302].MoveNodes , 1 do 
       for j = 1 , #WorldActivityConfig.WorldActivityConfig[302].MoveNodes[i] - 1 , 1 do
           local _MoveNodeId = tonumber(WorldActivityConfig.WorldActivityConfig[302].MoveNodes[i][j])
           if _RoomId==_MoveNodeId then
              return WorldActivityConfig.WorldActivityConfig[302].MoveNodes[i] , j
           end
       end
   end
    for i = 1 , #WorldActivityConfig.WorldActivityConfig[303].MoveNodes , 1 do 
       for j = 1 , #WorldActivityConfig.WorldActivityConfig[303].MoveNodes[i] - 1 , 1 do
           local _MoveNodeId = tonumber(WorldActivityConfig.WorldActivityConfig[303].MoveNodes[i][j])
           if _RoomId==_MoveNodeId then
              return WorldActivityConfig.WorldActivityConfig[303].MoveNodes[i] , j
           end
       end
   end
   return nil
end

return WorldActivityConfig