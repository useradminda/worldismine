WorldMapSys = {}
WorldMapSys.CityNodes = {}
WorldMapSys.Lines = {}
WorldMapSys.LineFather = nil
WorldMapSys.CityFather = nil
WorldMapSys.BuyArmyPower = 0

function WorldMapSys.CreateCityNodes()                                              --创建所有的城市点
    PlayerControl.WorldId = LoginData.PlayerID  
    if WorldMapSys.LineFather==nil then
       WorldMapSys.LineFather = GameMain.WorldMapSys.transform:FindChild("LineFather")
       WorldMapSys.CityFather = GameMain.WorldMapSys.transform:FindChild("CityFather")
    end

   lgNoDelCsFun.Ins:CreateTexture()


   local CityNodesData = WorldMapDataSys.GetCityNodesData()                 --赋予城市点信息
   if CityNodesData~=nil then
      for i = 1 , #CityNodesData , 1 do
          local NodeData = CityNodesData[i]

          if WorldMapSys.CityNodes[NodeData.CityId]==nil then

              local lua = GameMain.requireLuaFile("CityNode")
	          local CityNode = lua:new()
              CityNode:Init(NodeData)

              WorldMapSys.CityNodes[NodeData.CityId] = CityNode
              WorldMapSys.SetMapCityColor(Vector3(NodeData.PosX *128 , 0 , NodeData.PosY * 128)  , NodeData.OwnerShip)
              local data =
              {
                  Pos = CityNode.Pos,
                  CityId = CityNode.NodeId,
                  CityNode = CityNode,
                  Index = i,
              }
              MainGameUI.CreateLittleItem("WorldCity" , "WorldCity" , WorldMapSys.CityFather , data , WorldMapSys.CallBack , "")
          end             
      end
   end
   
   for key , value in pairs(WorldMapSys.CityNodes) do                   --创建连线    
       for i = 1 , #value.NeighbourNodesId , 1 do           
           local NeNode = WorldMapSys.CityNodes[value.NeighbourNodesId[i]]
           if NeNode~=nil then
               local _StartPoint = value.Pos
               local _EndPoint = NeNode.Pos
              
               local _ID = tostring(value.NodeId).."_"..tostring(NeNode.NodeId)
               local _ChangeId = tostring(NeNode.NodeId).."_"..tostring(value.NodeId)
               if WorldMapSys.Lines[_ID]==nil and WorldMapSys.Lines[_ChangeId]==nil then
                  local data =
                  {                  
                     StartPoint = _StartPoint,
                     EndPoint = _EndPoint,
                     Froward = _Froward,
                     Id = _ID,
                  }
                  MainGameUI.CreateLittleItem("Line" , "Line" , WorldMapSys.LineFather , data , WorldMapSys.CallBackLine , "")
               end
           end
       end      
   end
end

function WorldMapSys:CallBack(Gob , _Info)
   Gob.transform.parent = WorldMapSys.CityFather.transform
   Gob.transform.localScale = Vector3(100 , 100 , 100)
   Gob.transform.localPosition = _Info.Pos
   Gob.name = tostring(_Info.CityId)  
   _Info.CityNode:GetCityGob(Gob)
   _Info.CityNode:SetNameMesh()
   _Info.CityNode:SetCitySprite()
   if _Info.Index == 254 then
      WorldMapSys.MakeMapColor()
      if GuideSys.NowBigStep == 9 then
         local UIGuideTar = MainGameUI.FindPanelTarget("UIGuide")
         if UIGuideTar~=nil then
            UIGuideTar:ChangeGuideOwner()
         end
      end
   end
end

function WorldMapSys:CallBackLine(Gob , _Info)
   Gob.transform.parent = WorldMapSys.LineFather.transform
   Gob:GetComponent("LineRenderer"):SetPosition(0 , Vector3(_Info.StartPoint.x , -10 , _Info.StartPoint.z))
   Gob:GetComponent("LineRenderer"):SetPosition(1 , Vector3(_Info.EndPoint.x ,-10 , _Info.EndPoint.z))
   Gob.transform:FindChild("Point"):GetComponent("LineRenderer"):SetPosition(0 , Vector3(_Info.StartPoint.x , -10 , _Info.StartPoint.z))
   Gob.transform:FindChild("Point"):GetComponent("LineRenderer"):SetPosition(1 , Vector3(_Info.EndPoint.x , -10 , _Info.EndPoint.z))
   WorldMapSys.Lines[_Info.Id] =
   {
      Id = _Info.Id,
      Point = Gob.transform:FindChild("Point").gameObject,
   } 
end

function WorldMapSys.AstarBegin(_StarNode , _EndNode)                              --寻路入口
   local Nodes = Astar.AstarBegin(_StarNode , _EndNode)
   if Nodes==nil then
      return nil
   end
   WorldMapSys.SaveNodes = {}
   for i = 1 , #Nodes , 1 do
       WorldMapSys.SaveNodes[i] = Nodes[#Nodes + 1 - i]
   end
   return WorldMapSys.SaveNodes
end



function WorldMapSys.FindCityNodeById(_CityId)
    if WorldMapSys.CityNodes[_CityId]~=nil then
       return WorldMapSys.CityNodes[_CityId]
    else
       Debug.LogError("未查询城市,ID:")
       Debug.LogError(_CityId)
       return nil
    end
end

function WorldMapSys.SetNodeStates(_NodeData)

    local CityId = _NodeData.CityId
    local CityNode = WorldMapSys.FindCityNodeById(CityId)
    
    local OwnerShipNow = _NodeData.Owner
    local CityState = _NodeData.CityState
    local DefenceNum = _NodeData.DefenceNum
    local AttackNum = _NodeData.AttackNum

    if CityNode==nil then
       return
    end
    
    if CityNode.OwnerShipNow ~= OwnerShipNow then
       
       CityNode:SetNowOwnerShip(OwnerShipNow)
       WorldMapSys.SetMapCityColor(Vector3(CityNode.PosX * 128 , 0 , CityNode.PosY * 128)  , OwnerShipNow)
       WorldMapSys.MakeMapColor()
       CityNode:SetNameMesh()
      -- CityNode:SetCitySprite()
    end
 
    CityNode:SetCityState(CityState)
    CityNode:SetDefenceNum(DefenceNum)
    CityNode:SetAttackNum(AttackNum)
    CityNode:SetCityCountryState(_NodeData)
    WorldMapSys.MakeMapColor()
end

function WorldMapSys.SetMapCityColor(_Pos , _OwnerShip)

   lgNoDelCsFun.Ins:SetTexture(_Pos.x/8 , _Pos.z/8 , _OwnerShip)
end

function WorldMapSys.MakeMapColor()
   lgNoDelCsFun.Ins:SetTexApply()
end

function WorldMapSys.GetHomeByOwner(_OwnerShip)             --找到专属屯田区
    for key , value in pairs(WorldMapSys.CityNodes) do
        if value.OwnerShip==_OwnerShip then
           if value.CityType == 2 then
              return WorldMapSys.CityNodes[key]
           end
        end
    end
    return nil
end

function WorldMapSys.GetMyCityNum() 
   local _Count = 0
   for key , value in pairs(WorldMapSys.CityNodes) do
       if value.OwnerShipNow==ClinetInfomation.MyOwner then
          _Count = _Count + 1
       end
   end
   return _Count
end


function WorldMapSys.Release()
    WorldMapSys.CityNodes = {}
    WorldMapSys.Lines = {}
    WorldMapSys.LineFather = nil
    WorldMapSys.CityFather = nil
end

return WorldMapSys