Astar = {}
Astar.OpenList ={}
Astar.CloseList = {}

Astar.StartNode = nil
Astar.EndNode = nil
Astar.CurrentNode = nil
Astar.CurrentNodeId = nil

Astar.AllNodes = {}                     --所有的城池数据
Astar.SaveNodes = {}                    --最终搜索到的数据
Astar.Is_Fond = false                   --是否发现最终路线
Astar.StartId = 0                       --起始点ID
Astar.EndId = 0                         --终点ID


function Astar.AstarBegin(_StarNode , _EndNode)
   Astar.StartNode = _StarNode
   Astar.EndNode = _EndNode

   Astar.ClearOpenList()
   Astar.ClearCloseList()
   Astar.SaveNodes = {}

   table.insert(Astar.OpenList , #Astar.OpenList + 1 , Astar.StartNode)   
   Astar.StartNode.FatherNodeId = nil
   Astar.SearchPath()

   if Astar.Is_Fond==false then
      --Debug.LogError("No Path")
      return nil
   else
      return Astar.SaveNodes
   end
end

function Astar.AddNodeToOpenList(_NeighbourNodes)  
   for i = 1 , #_NeighbourNodes , 1 do
       local NodeId = _NeighbourNodes[i]
       if WorldMapSys.CityNodes[NodeId]~=nil and WorldMapSys.CityNodes[NodeId].Can_Go==true then
          local FindInOpen = Astar.FindNodeInOpenList(WorldMapSys.CityNodes[NodeId].NodeId)
          if FindInOpen==false and WorldMapSys.CityNodes[NodeId].Is_InCloseList==false  then
             if WorldMapSys.CityNodes[NodeId].CityState=="Idle" and WorldMapSys.CityNodes[NodeId].OwnerShipNow == PlayerControl.TheMeCharacter.OwnerShip then          
                WorldMapSys.CityNodes[NodeId].FatherNodeId = Astar.CurrentNode.NodeId
                WorldMapSys.CityNodes[NodeId].Distance = Vector3.Distance(WorldMapSys.CityNodes[NodeId].Pos , Astar.StartNode.Pos) + Vector3.Distance(WorldMapSys.CityNodes[NodeId].Pos , Astar.EndNode.Pos) 
                table.insert(Astar.OpenList , #Astar.OpenList + 1 , WorldMapSys.CityNodes[NodeId])   
             elseif WorldMapSys.CityNodes[NodeId].CityState=="Fight" or WorldMapSys.CityNodes[NodeId].OwnerShipNow ~= PlayerControl.TheMeCharacter.OwnerShip then
                if WorldMapSys.CityNodes[NodeId].NodeId == Astar.EndNode.NodeId then
                   WorldMapSys.CityNodes[NodeId].FatherNodeId = Astar.CurrentNode.NodeId
                   WorldMapSys.CityNodes[NodeId].Distance = Vector3.Distance(WorldMapSys.CityNodes[NodeId].Pos , Astar.StartNode.Pos) + Vector3.Distance(WorldMapSys.CityNodes[NodeId].Pos , Astar.EndNode.Pos)                  
                   table.insert(Astar.OpenList , #Astar.OpenList + 1 , WorldMapSys.CityNodes[NodeId])
                end
             elseif WorldMapSys.CityNodes[NodeId].CityState=="Idle" and  WorldMapSys.CityNodes[NodeId].OwnerShipNow ~= PlayerControl.TheMeCharacter.OwnerShip then 
                if WorldMapSys.CityNodes[NodeId].NodeId == Astar.EndNode.NodeId then
                   WorldMapSys.CityNodes[NodeId].FatherNodeId = Astar.CurrentNode.NodeId
                   WorldMapSys.CityNodes[NodeId].Distance = Vector3.Distance(WorldMapSys.CityNodes[NodeId].Pos , Astar.StartNode.Pos) + Vector3.Distance(WorldMapSys.CityNodes[NodeId].Pos , Astar.EndNode.Pos)                   
                   table.insert(Astar.OpenList , #Astar.OpenList + 1 , WorldMapSys.CityNodes[NodeId])
                end 
             end
          end
       end
   end

   table.sort(Astar.OpenList , Astar.Comp)
end

function Astar.Comp(A , B)  
   return A.Distance<B.Distance
end

function Astar.SearchPath()
       Astar.Is_Fond = false

       while true do
          if #Astar.OpenList==0 then           
             Astar.Is_Fond = false
             --Debug.LogError("No Path")
             return
          end

          Astar.CurrentNode = Astar.OpenList[1]                                           --当前搜索点
          table.remove(Astar.OpenList , 1)
          Astar.CurrentNode.Is_InCloseList = true
          Astar.CloseList[Astar.CurrentNode.NodeId] = Astar.CurrentNode                   --把关闭的点加入关闭列表
          
          if Astar.CurrentNode.NodeId == Astar.EndNode.NodeId and Astar.CurrentNode.Pos == Astar.EndNode.Pos then
             Astar.Is_Fond = true
             Astar.CreatePath()
             return
         end

         if Astar.Is_Fond == false then
            Astar.AddNodeToOpenList(Astar.CurrentNode.NeighbourNodesId)
         end

       end

       if Astar.Is_Fond == false then
          --Debug.LogError("No Path")
          return
       end
end

function Astar.CreatePath()
    Astar.CurrentNode = Astar.EndNode

    Astar.CurrentNodeId = Astar.CurrentNode.NodeId
    while Astar.CurrentNodeId~=nil do
          table.insert(Astar.SaveNodes , #Astar.SaveNodes + 1 , WorldMapSys.CityNodes[Astar.CurrentNodeId])
          Astar.CurrentNodeId = WorldMapSys.CityNodes[Astar.CurrentNodeId].FatherNodeId         
    end
end

function Astar.FindNodeInOpenList(_NodeId)
    for i = 1 , #Astar.OpenList , 1 do
        if _NodeId==Astar.OpenList[i].NodeId then
           return true
        end
    end
    return false
end

function Astar.ClearOpenList()
   Astar.OpenList = {}
  
end

function Astar.ClearCloseList()
    for key , value in pairs(Astar.CloseList) do
        Astar.CloseList[key].Is_InCloseList = false
    end
    Astar.CloseList = {}
end

return Astar