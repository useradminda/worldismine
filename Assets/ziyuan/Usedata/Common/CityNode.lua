CityNode = {}                                                                      --城池类
local this = CityNode
CityNode.__index = CityNode

function  CityNode:new(o)
    o=o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

CityNode.NodeId = 0                                                                  --城市ID
CityNode.Pos = Vector3(0 , 0 , 0)                                                    --位置点
CityNode.CityName = ""                                                               --名字
CityNode.NameMesh = nil
CityNode.SpriteRenderer = nil
CityNode.FightSprite = nil
CityNode.CitySprites = nil
CityNode.Arrow = nil
CityNode.Can_Go = true                                                               --是否可以通行
CityNode.Is_InCloseList = false                                                      --是否在开放列表
CityNode.FatherNode = nil                                                            --父亲点
CityNode.NeighbourNodesId = nil                                                      --附近的邻居
CityNode.NeighbourPassTime = nil                                                     --通往附近邻居的时间
--CityNode.CityNodeData = NodeData,                                                  --城市点数据库信息
CityNode.CityStates = {"Fight" , "Idle"}
CityNode.CityState = "Idle"

CityNode.CityType = 1                                                                 -- 1首都 2屯田 3关隘 4城池 5野地
CityNode.OwnerShip = 1                                                                --1 , 2 , 3 蜀 魏国 吴 中立 初始归属
CityNode.OwnerShipName = "魏蜀吴中立"

CityNode.OwnerShipNow = 1                                                             --当前归属
CityNode.OwnerShipNameNow = "魏蜀吴中立"
CityNode.DefenceNum = 0                                                               --防守人数


CityNode.AttackNum = 0                                                                --进攻人数


CityNode.CityGob = nil
CityNode.PosX = 0
CityNode.PosY = 0

function CityNode:Init(_NodeData)
   self.NodeId = _NodeData.CityId                                                 --城市ID
   self.Pos = Vector3(_NodeData.PosX *128 , 0 , _NodeData.PosY * 128)                        --位置点
   self.PosX = _NodeData.PosX
   self.PosY = _NodeData.PosY
   self.CityName = _NodeData.CityName                                             --名字
   self.Can_Go = true                                                             --是否可以通行
   self.Is_InCloseList = false                                                    --是否在开放列表
   self.FatherNode = nil                                                          --父亲点
   self.NeighbourNodesId = _NodeData.CityAround                                   --附近的邻居
   self.NeighbourPassTime = _NodeData.CityTime                                    --通往附近邻居的时间

   self.CityState = "Idle"

   self.CityType = _NodeData.CityType
   self.OwnerShip = _NodeData.OwnerShip
   self.OwnerShipNow = _NodeData.OwnerShip
   self.OwnerShipName = UIstring.Ownerships[self.OwnerShip]
   self.OwnerShipNameNow = UIstring.Ownerships[self.OwnerShipNow]
  
   self.DefenceNum = 0                                                               --防守人数
   self.AttackNum = 0  
end

function CityNode:SetDefenceNum(_Num)
   self.DefenceNum = _Num
end

function CityNode:SetAttackNum(_Num)
   self.AttackNum = _Num
end

function CityNode:SetNowOwnerShip(_OwnerShip)
   self.OwnerShipNow = _OwnerShip   
   self.OwnerShipNameNow = UIstring.Ownerships[self.OwnerShipNow]   
end

function CityNode:GetCityGob(_Gob)
   self.NameMesh = _Gob.transform:FindChild("CityName"):GetComponent("TextMesh") 
   self.SpriteRenderer = _Gob.transform:FindChild("CitySprite"):GetComponent("SpriteRenderer") 
   self.FightSprite = _Gob.transform:FindChild("Fight")
   self.Arrow = _Gob.transform:FindChild("Arrow")
   self.CitySprites = _Gob.transform:GetComponent("ClickEvent").sprites

   self.CityGob = _Gob
end

function CityNode:SetNameMesh()
   if self.NameMesh~=nil then
       self.NameMesh.text = self.OwnerShipNameNow..self.CityName
       if self.OwnerShipNow==1 then           --蜀国
          lgNoDelCsFun.Ins:SetNameMeshColor(self.NameMesh , 255/255 , 153/255 , 0/255) 
       elseif self.OwnerShipNow==2 then       --魏国
          lgNoDelCsFun.Ins:SetNameMeshColor(self.NameMesh , 107/255 , 249/255 , 255/255)
       elseif self.OwnerShipNow==3 then       --吴国
          lgNoDelCsFun.Ins:SetNameMeshColor(self.NameMesh , 133/255 , 255/255 , 94/255)
       elseif self.OwnerShipNow==4 then       --中立
          lgNoDelCsFun.Ins:SetNameMeshColor(self.NameMesh , 255/255 , 122/255 , 255/255)
       end
   end
end

function CityNode:SetCitySprite()
   if self.CityType==1 then
      if OwnerShip==1 then
         self.SpriteRenderer.sprite = self.CitySprites[3]
      elseif OwnerShip==2 then
         self.SpriteRenderer.sprite = self.CitySprites[4]
      elseif OwnerShip==3 then
         self.SpriteRenderer.sprite = self.CitySprites[5]
      end
   elseif self.CityType==2 then
      self.SpriteRenderer.sprite = self.CitySprites[0]
   elseif self.CityType==3 then
      self.SpriteRenderer.sprite  = self.CitySprites[1]
   elseif self.CityType==4 then
      self.SpriteRenderer.sprite  = self.CitySprites[2]
   elseif self.CityType==5 then
      self.SpriteRenderer.sprite = self.CitySprites[0]
   end 
end


function CityNode:SetCityState(_CityState)
   if _CityState==0 then
      self.CityState = "Idle"
      self.FightSprite.gameObject:SetActive(false)
   elseif _CityState==1 or _CityState==2 then
      self.CityState = "Fight"
      self.FightSprite.gameObject:SetActive(true)
   end
end

function CityNode:SetCanMove(_IsActive)
    self.Arrow.gameObject:SetActive(_IsActive)
end

CityNode.DefenceShuNum = 0
CityNode.DefenceWeiNum = 0
CityNode.DefenceWuNum  = 0
CityNode.DefenceMidNum = 0

CityNode.AttackShuNum =0
CityNode.AttackWeiNum =0
CityNode.AttackWuNum =0
CityNode.AttackMidNum =0

function CityNode:SetCityCountryState(_Data)  

   self.DefenceShuNum = _Data.DefenceShuNum
   self.DefenceWeiNum = _Data.DefenceWeiNum
   self.DefenceWuNum  = _Data.DefenceWuNum
   self.DefenceMidNum = _Data.DefenceMidNum

   self.AttackShuNum = _Data.AttackShuNum
   self.AttackWeiNum = _Data.AttackWeiNum
   self.AttackWuNum  = _Data.AttackWuNum
   self.AttackMidNum = _Data.AttackMidNum

end

return CityNode