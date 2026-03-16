
CharacterBase = {}                                                                      --世界地图角色控制类
local this = CharacterBase
CharacterBase.__index = CharacterBase

CharacterBase.Id = nil																	--玩家ID
CharacterBase.name = nil																--玩家名字

CharacterBase.PlayerObj = nil															--玩家模型GOb
CharacterBase.PlayerTrans = nil
CharacterBase.NameMeshTrans = nilCreatePlayer
CharacterBase.NameText = nil                                                            --玩家姓名的mesh

CharacterBase.World_Id = 0                                                             --世界ID
CharacterBase.PlayerName = ""
CharacterBase.PlayerRealId = 0
CharacterBase.Power = 0                                                                 --兵力

CharacterBase.OwnerShip = 1                                                             --归属国

CharacterBase.MoveState = "Idle"                                                      --玩家状态  Idle 停止在城市 Move移动在路上 Fight 在城池中战斗 Watch 在城池中观看
CharacterBase.MoveStates = {"Idle" , "Move" , "WatchFight" ,"WaitFight" , "OnFight" , "Dead" }
CharacterBase.MoveTimeCD = 9                                                          --移动CD
CharacterBase.IdleTime = 0                                                         --需要停留停留时间CD
CharacterBase.MoveCDState = false                                                     --是否可以移动
CharacterBase.nowIdleTime = 0                                                       --当前停留状态时间

CharacterBase.NowNode = nil                                                           --当前点
CharacterBase.LastNode = nil                                                          --上一个点
CharacterBase.StartNode = nil                                                         --开始寻路点
CharacterBase.EndNode = nil                                                           --终点

CharacterBase.Starpos = nil
CharacterBase.Temppos = nil

CharacterBase.nowTime = 0                                                             --当前行走时间                 
CharacterBase.MoveTime = 3                                                            --城池的移动时间
CharacterBase.StartMoveState = false                                                  --开始移动标记
CharacterBase.NextMoveNode = nil
CharacterBase.NextMoveNodeId = 0
CharacterBase.SaveNodes = nil

CharacterBase.tempEndNode = nil                                                        --当前移动状态的临时终点

CharacterBase.GoInCity = false                                                          --进入城池

CharacterBase.NetMoveEventCome = false                                                  --移动变更
CharacterBase.StopState = false                                                         --拉停设置
CharacterBase.ArmyAi = 0
CharacterBase.ArmyID = 0                                                                --军队ID

CharacterBase.ConfigId = 0                                                              --数据库ID
CharacterBase.VipLevel = 0
CharacterBase.Officer = 0
function  CharacterBase:new(o)
    o=o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function CharacterBase:CreatePlayer(_WorldId , _ArmyId , _PlayerName , _ModelName , _ArmyAi , _ConfigId , _data , _CallBack , _ArmyCamp , _VipLevel , _Officer )
   self.World_Id = _WorldId
   self.NetMoveEventCome = false
   self.MoveTimeCD = 9
   self.GoInCity = false
   self.ArmyID = _ArmyId
   self.ConfigId = _ConfigId
   self.PlayerName = _PlayerName
   self.VipLevel = _VipLevel
   self.Officer = _Officer
   if _ArmyCamp~=nil then
      self.OwnerShip = _ArmyCamp
   end
   if _ArmyAi~=nil then
      self.ArmyAi = _ArmyAi
   else
      self.ArmyAi = 0
   end
   local data =
   {
      Charc = self,
      Param = _data,
      CallBack = _CallBack,
   }

   if _WorldId==LoginData.PlayerID then
      MainGameUI.CreateLittleItem("My" , _ModelName , nil , data , CharacterBase.InitSomeCallback , "")
   else
      MainGameUI.CreateLittleItem(_ModelName , _ModelName , nil , data , CharacterBase.InitSomeCallback , "")
   end
end

function CharacterBase.InitSomeCallback(ttt , Gob , _data)    
   _data.Charc.PlayerObj = Gob
   _data.Charc.PlayerTrans = Gob.transform
   _data.Charc.PlayerTrans.localScale = Vector3(100 , 100 , 1)
   _data.Charc.PlayerTrans.localPosition = Vector3(10000 , 10000 , 10000)
   _data.Charc.PlayerTrans.localEulerAngles = Vector3(90 , 0 , 0)

   MainGameUI.CreateLittleItem("ShaderName" , "ShaderName" , nil , _data , CharacterBase.CreateShaderCallback , "")

   if _data.CallBack~=nil then
      _data.CallBack(_data.Param)
   end
                                                                        --移动CD时间
end

function CharacterBase.CreateShaderCallback(ttt, Gob , _data) 
   if Gob~=nil and _data.Charc~=nil and _data.Charc.PlayerTrans~=nil then
       Gob.transform.parent = _data.Charc.PlayerTrans.transform
       Gob.transform.localScale = Vector3(0.05 , 0.05 , 1)
       Gob.transform.localPosition = Vector3(0 , 1 , 0)
       Gob.transform.localEulerAngles = Vector3(0 , 0 , 0)

       _data.Charc.NameMeshTrans = Gob.transform -- _data.Charc.PlayerTrans:FindChild("Name")
       _data.Charc.NameText = Gob.transform:GetComponent("TextMesh")
       _data.Charc:SetOwnerUI()
       _data.Charc:SetVipOfficerInfo()
       if _data.Charc.World_Id==0 then
          _data.Charc.NameText.text = UIstring.FarMan
       else 
          if _data.Charc.PlayerName=="my" then
             _data.Charc.NameText.text = tostring(_data.Charc.World_Id)
          else
             _data.Charc.NameText.text = tostring(_data.Charc.PlayerName)
          end
       end
   end
end

function CharacterBase:CreateGuaShuai(_GuaShuaiName)
   if self.PlayerTrans==nil then
      return
   end
   if self.PlayerTrans.transform.name == _GuaShuaiName then
      return
   else
      local data = 
      {
         Charc = self,
      }
      MainGameUI.CreateLittleItem(_GuaShuaiName , _GuaShuaiName , nil , data , CharacterBase.CreateGuaShuaiCallBack , "")
   end
end

function CharacterBase.CreateGuaShuaiCallBack(ttt , Gob , _data)
   local TempGob = _data.Charc.PlayerObj
   _data.Charc.PlayerObj = Gob
   _data.Charc.PlayerTrans = Gob.transform 
   _data.Charc.PlayerTrans.localScale = Vector3(100 , 100 , 1)
   _data.Charc.PlayerTrans.localPosition = TempGob.transform.localPosition
   _data.Charc.PlayerTrans.localEulerAngles = Vector3(90 , 0 , 0)
   _data.Charc.PlayerObj.gameObject:SetActive(true)

   MainGameUI.CreateLittleItem("ShaderName" , "ShaderName" , nil , _data , CharacterBase.CreateShaderCallback , "")

   GameObject.Destroy(TempGob.gameObject)
end

function CharacterBase:SetVipOfficer(_VipLevel , _Officer)
   self.VipLevel = _VipLevel 
   self.Officer = _Officer
end

function CharacterBase:SetOwner(_OwnerShip)
   self.OwnerShip = _OwnerShip 
end

function CharacterBase:SetOwnerUI()
   if self.NameText==nil then
      return
   end

   if self.OwnerShip==1 then           --蜀国    
      lgNoDelCsFun.Ins:SetNameMeshColor(self.NameText , 255/255 , 153/255 , 0/255) 
   elseif self.OwnerShip==2 then       --魏国
      lgNoDelCsFun.Ins:SetNameMeshColor(self.NameText , 0/255 , 245/255 , 255/255)
   elseif self.OwnerShip==3 then       --吴国
      lgNoDelCsFun.Ins:SetNameMeshColor(self.NameText , 30/255 , 255/255 , 0/255)
   elseif self.OwnerShip==4 then       --中立
      lgNoDelCsFun.Ins:SetNameMeshColor(self.NameText , 255/255 , 0/255 , 227/255)
   end
end

function CharacterBase:SetVipOfficerInfo()
   if self.NameText==nil then
      return
   end

   if self.VipLevel~=nil then 
      if self.VipLevel == 0 then
         self.NameText.transform:FindChild("VipLevel"):GetComponent("TextMesh").text = ""
      else
         self.NameText.transform:FindChild("VipLevel"):GetComponent("TextMesh").text = "VIP."..tostring(self.VipLevel)  
      end                  
   end
   
   if self.Officer~=nil then     
      self.NameText.transform:FindChild("OfficerName"):GetComponent("TextMesh").text = UIstring.OfficerName[self.Officer]   
   end
end

function CharacterBase:ChangeVipOfficer(_VipLevel , _Officer)
   if self.NameText==nil then
      return
   end

   self.VipLevel = _VipLevel
   if self.VipLevel~=nil then            
      if self.VipLevel == 0 then
         self.NameText.transform:FindChild("VipLevel"):GetComponent("TextMesh").text = ""
      else
         self.NameText.transform:FindChild("VipLevel"):GetComponent("TextMesh").text = "VIP."..tostring(self.VipLevel)  
      end 
   end

   self.Officer = _Officer   
   if self.Officer~=nil then
      self.NameText.transform:FindChild("OfficerName"):GetComponent("TextMesh").text = UIstring.OfficerName[self.Officer]     
   end
  
end

function CharacterBase:ChangeName(_Name)
   if self.NameText==nil then
      return
   end
   self.PlayerName = _Name

   if self.PlayerName=="my" then
      self.NameText.text = tostring(self.World_Id)
   else
      self.NameText.text = self.PlayerName
   end
end


function CharacterBase:SetArmyId(_ArmyId)
   self.ArmyID = _ArmyId
end

function CharacterBase:SetNodeInfo(_Node)
   self.NowNode = _Node
   --self:SetMyMapCityPosition(self.NowNode.Pos) 
end

function CharacterBase:SetPos(_Pos)
   if self.PlayerTrans~=nil then
      self.PlayerTrans.localPosition = _Pos
   end
end

function CharacterBase:SetConfigId(_ConfigId)
   self.ConfigId = _ConfigId
end

function CharacterBase:SetMoveState(_MoveState)
   self.MoveState = _MoveState
end

function CharacterBase:InitMoveState()
   self.StartMoveState = false
   self.GoInCity = false 
   self:ShowMeInWorldMap(false)
end

function CharacterBase:ShowMeInWorldMap(_Show)
   if self.World_Id~=PlayerControl.WorldId then
      self.PlayerObj.gameObject:SetActive(_Show)
   end 
end

function CharacterBase:SetMyMapCityPosition()
   
   if self.World_Id==PlayerControl.WorldId then 
      if PlayerControl.MyMapCityTrans~=nil then
         PlayerControl.MyMapCityTrans.localPosition = Vector3((self.NowNode.Pos.x/8) + 1892 , -100 , (self.NowNode.Pos.z/8) + 882)
      end
   end
end

function CharacterBase:SetPlayerTrun(_LastNodeX , _NextNodeX)
   local TurnX = _LastNodeX - _NextNodeX
   if self.NameMeshTrans~=nil then
      if TurnX > 0 then
         self.NameMeshTrans.localEulerAngles = Vector3(0 , 180 , 0)
         self.PlayerTrans.localEulerAngles = Vector3(-90 , 180 , 0)
      elseif TurnX < 0 then
         self.NameMeshTrans.localEulerAngles = Vector3(0 , 0 , 0)
         self.PlayerTrans.localEulerAngles = Vector3(90 , 0 , 0)
      end
   end
end

function CharacterBase:SetPower(_Power)
   self.Power = _Power
end

function CharacterBase:SetNextMoveNodeId(_NextId)
   self.NextMoveNodeId = _NextId
end

function CharacterBase:SetSaveNodes(_Nodes)
   
   self.SaveNodes = _Nodes
   self:ShowPoints()
end

function CharacterBase:SetGobActive()
   if self.PlayerTrans~=nil then
      self.PlayerTrans.gameObject:SetActive(true)
   end
end

function CharacterBase:StartMove()
   if self.MoveState=="Idle" and self.SaveNodes~=nil and #self.SaveNodes~=0 then                                                                           --开始移动      
       self.NextMoveNode = self.SaveNodes[2]
       self.NextMoveNodeId = 2
       self.Temppos = Vector3(0 , 0 ,0)
       self.Starpos = Vector3(self.NowNode.Pos.x , 0 ,self.NowNode.Pos.z)--Vector3(self.PlayerTrans.localPosition.x , 0 ,self.PlayerTrans.localPosition.z)
       self.MoveState = "Move"                                                                          --移动状态
       self.MoveTime = self.NowNode.NeighbourPassTime[tostring(self.NowNode.NodeId).."_"..tostring(self.NextMoveNode.NodeId)]   --城池之间的移动时间    
       self:SetPlayerTrun(self.NowNode.Pos.x , self.NextMoveNode.Pos.x)                                                                              
       self.NowNode = self.NextMoveNode
       self:SetMyMapCityPosition(self.NowNode.Pos) 
       self.LastNode = self.SaveNodes[1]
       self.nowTime = 0                                                                                   --当前移动过程中的当前时间
       self.MoveTimeCD = 9                                                                                --移动CD总时间
       self.IdleTime = self.MoveTimeCD - self.MoveTime                                                    --需要停靠的时间
       self.nowIdleTime = 0                                                                               --当前停靠的多少时间
       self.GoInCity = false                                                                              --是否入城
       self.StopState = false                                                                             --是否拉停
       self:ShowMeInWorldMap(true)                                                                        --在世界中显示
       self.StartMoveState = true     
   end
end

function CharacterBase:ClearStarData()
   self:ClearAllShowPoints()
   self.SaveNodes = {}
   self.EndNode = nil
   self.NextMoveNode = nil
   self.tempEndNode = nil
   self.Temppos = Vector3(0 , 0 ,0)
   self.NextMoveNodeId = 2
end

function CharacterBase:GoInCityEvent()                                 --进城设置点信息
    --GameMain.Print(self.NowNode)
    if self.LastNode~=nil and self.NowNode~=nil then
       self:SetOnePoint(self.LastNode.NodeId , self.NowNode.NodeId , false)
    end 
    self.GoInCity = true                                               --进入城池状态
    self:ShowMeInWorldMap(false)
    self:IntCitySetNodeEvent()                                          --入城发包
end

function CharacterBase:IntCitySetNodeEvent()                           --入城事件 
  
   if self.World_Id==PlayerControl.WorldId then
      if self.tempEndNode~=nil  then                                   --我是否有临时改变点 已经计算好下次路径
         Debug.LogError("入城发送包") 
         self.tempEndNode = nil 
         WorldMapSocketSys.SendMoveSocketEvent(self.TempNodes)              
      --[[else
         self:OutCitySetNode()                                          --没有临时改变点 按照上次路径继续--]]
      end
   else     
   end
end

function CharacterBase:JudgeState()
   if self.MoveState=="WatchFight" or self.MoveState=="WaitFight" or self.MoveState=="OnFight" then                                     --出城状态判断 如果状态改成战斗停止移动   
      self.StartMoveState = false
      self.nowTime = 0
      self.GoInCity = false
      return true
   end
   return false
end

function CharacterBase:OutCitySetNode()                                --出城设置点信息
    --Debug.LogError("CD 结束出城设置")
    local _Pass = self:JudgeState()
    if _Pass==true then
       return
    end
    if self.SaveNodes==nil then
       self.StartMoveState = false
       self:ClearStarData()     
       self.MoveState = "Idle"
       return
    end
    if self.SaveNodes~=nil and #self.SaveNodes==0 then
       self.StartMoveState = false
       self:ClearStarData()     
       self.MoveState = "Idle"
       return
    end
    self.NextMoveNodeId = self.NextMoveNodeId + 1
    --GameMain.Print(self.SaveNodes[self.NextMoveNodeId])
    if self.SaveNodes[self.NextMoveNodeId]~=nil then                   --非终点
       
       self.NextMoveNode = self.SaveNodes[self.NextMoveNodeId]
       self.MoveTime = self.NowNode.NeighbourPassTime[tostring(self.NowNode.NodeId).."_"..tostring(self.NextMoveNode.NodeId)]   --城池之间的移动时间      
       self.Starpos = self.PlayerTrans.localPosition  
       self:SetPlayerTrun(self.NowNode.Pos.x , self.NextMoveNode.Pos.x)
       self.IdleTime = self.MoveTimeCD - self.MoveTime       
       self.NowNode = self.SaveNodes[self.NextMoveNodeId]
       self.LastNode = self.SaveNodes[self.NextMoveNodeId - 1]  
       self:SetMyMapCityPosition(self.NowNode.Pos) 
       self:ShowMeInWorldMap(true)
       self.nowTime = 0
       self.GoInCity = false
       self.StartMoveState = true   
    else                                                                     --终点              
       self.StartMoveState = false
       self:ClearStarData()     
       self.MoveState = "Idle"       
    end
    
end

function CharacterBase:SendNetEvent(_SaveNodes) 
   self.TempNodes = nil  
   self.tempEndNode = nil                      
   self.StopState = false
   
   if self.World_Id~=PlayerControl.WorldId then 
      if self.MoveState ~= "Idle" and self.MoveState~="Move" then
          self.MoveState = "Idle"
       end
   end
   
   if self.MoveState=="Idle" then                                                                           --当前是停止状态 随时可以移动    
      self:ClearAllShowPoints()
      self.SaveNodes = {}
      self:SetSaveNodes(_SaveNodes)
      self:StartMove()
     
   elseif self.MoveState=="Move" then                                                                       --当前是正在移动的状态
       self:ClearAllShowPoints()
       self.SaveNodes = {}
       self:SetSaveNodes(_SaveNodes)
       self.NowNode = self.SaveNodes[1]                                                                    
       self.NextMoveNode = self.SaveNodes[2]                                                              --开始移动   
       self.NextMoveNodeId = 1
       self.Temppos = Vector3(0 , 0 ,0)
       if self.World_Id==PlayerControl.WorldId then
          if self.StartMoveState==false then                                                                --不在移动         
             self:OutCitySetNode()
          end
       end                                                                                         --其他玩家 新包来就按照新包走       
   end  
end

function CharacterBase:SendNetEventTempTime(_SaveNodes , _TempTime , _State)                  --本人或者他玩家走在路中间的时候
   --Debug.LogError(_TempTime/self.MoveTimeCD)
  
   self.MoveState = "Move" 

   self:ClearAllShowPoints()
   self.SaveNodes = {}
   self:SetSaveNodes(_SaveNodes)   

   if _State == 1 then                                                              --移动中
      local lastNode = self.SaveNodes[1] 
      self.NextMoveNode = self.SaveNodes[2]
      self.NextMoveNodeId = 2
      self.MoveTime = lastNode.NeighbourPassTime[tostring(lastNode.NodeId).."_"..tostring(self.NextMoveNode.NodeId)]   --城池之间的移动时间         
      self.NowNode = _SaveNodes[2]--NodeNum + 2]
      self.LastNode =  lastNode
      self:SetMyMapCityPosition(self.NowNode.Pos) 
      self:SetPlayerTrun(self.LastNode.Pos.x , self.NextMoveNode.Pos.x)

      self.Starpos = Vector3(lastNode.Pos.x , 0 , lastNode.Pos.z)
      self.Temppos = Vector3(0 , 0 ,0)                                                                
      self.nowTime = _TempTime                                                  --当前移动过程中的当前时间

      --GameMain.Print(self.MoveTime , "MoveTime")
     -- GameMain.Print(self.nowTime , "nowTime")

      local beilv = self.nowTime/self.MoveTime
      local x = Mathf.Lerp(self.Starpos.x , self.NextMoveNode.Pos.x , beilv)
      local z = Mathf.Lerp(self.Starpos.z , self.NextMoveNode.Pos.z , beilv)
      self.PlayerTrans.localPosition = Vector3(x , 0 , z)
      self.IdleTime = self.MoveTimeCD - self.MoveTime
      self.nowIdleTime = 0
      self.GoInCity = false                                                         --不在城池里
      self.StartMoveState = true
      self:ShowMeInWorldMap(true)

   elseif _State == 2 then                                                         --在城里
      
      self.NowNode = _SaveNodes[1]
      self.LastNode = _SaveNodes[1]
      self.NextMoveNode = self.SaveNodes[2]
      self.MoveTime = self.LastNode.NeighbourPassTime[tostring(self.LastNode.NodeId).."_"..tostring(self.NextMoveNode.NodeId)]   --城池之间的移动时间   
      self.NextMoveNodeId = 1


      self.PlayerTrans.localPosition = Vector3(self.NowNode.Pos.x , 0 , self.NowNode.Pos.z)
      self.Starpos = Vector3(self.NowNode.Pos.x , 0 , self.NowNode.Pos.z)
      self.Temppos = Vector3(0 , 0 ,0)
      self.nowTime = _TempTime
     -- self:SetPlayerTrun(self.NowNode.Pos.x , self.NextMoveNode.Pos.x)
      --self.IdleTime = self.MoveTimeCD - self.MoveTime
      --self.nowIdleTime = self.MoveTimeCD - _TempTime
      self.GoInCity = true                                                          --在城池里
      self.StartMoveState = true
      self:ShowMeInWorldMap(false)
   end

end 


function CharacterBase:Update(dt)

     if self.StartMoveState==true then                                                            --移动状态中
        self.nowTime = self.nowTime + dt 
        if self.GoInCity ==false then                                                             --路上走            
           if self.nowTime <= self.MoveTime then
              if self.StopState==false then
                -- Debug.LogError(self.nowTime)
                 local beilv = self.nowTime/self.MoveTime
                 if self.Temppos~=nil then
                    self.Temppos.x = Mathf.Lerp(self.Starpos.x , self.NextMoveNode.Pos.x , beilv)
	                self.Temppos.z = Mathf.Lerp(self.Starpos.z , self.NextMoveNode.Pos.z , beilv)
                    self.PlayerTrans.localPosition = self.Temppos
                 end
              end           
           else                                      
              self:GoInCityEvent()
           end
        end     

        if self.GoInCity==true then                                                                --城池中   
          
           if self.nowTime <= self.MoveTimeCD then
                                                                
          -- self.nowIdleTime = self.nowIdleTime + dt
          -- if self.nowIdleTime <= self.IdleTime then 

           else
              self.nowTime = 0
             -- self.nowIdleTime = 0 
              self:OutCitySetNode()
              
             -- self.GoInCity = false
             -- self.StartMoveState = false             
             --                            
           end 
        end
       
    end
end

function CharacterBase:ChangeState(_State)              --1 行走 2 待命 3等待进攻 4上阵进攻 5正在进攻 6 死亡
    
   --if self.ArmyAi==1 then                               --非玩家
       if _State==1 then                                --行走
          self.MoveState = "Move"
          if self.StartMoveState==true then             --在CD内 还没有走完CD 不管

          end
          if self.StartMoveState==false then            --在CD外 已经停止了 外部需求走动 设置出城事件
             self:OutCitySetNode()
          end
       elseif _State==2 then                            --待命
          self.MoveState = "Idle"
          
          if self.StartMoveState==true then             --在CD内 还没有走完CD 不管

          end
          if self.StartMoveState==false then            --在CD外 已经停止了 外部需求走动 设置出城事件
             self:OutCitySetNode()
          end
       elseif _State==3 then
          self.MoveState = "WatchFight"                 --等待进攻 无法行走

       elseif _State==4 then
          self.MoveState = "WaitFight"                  --上阵进攻 无法行走

       elseif _State==5 then
          self.MoveState = "OnFight"                   --正在进攻  无法行走

       elseif _State==6 then
          self.MoveState = "Dead"
          
         -- Debug.LogError(self.ArmyID)
         -- Debug.LogError("Dead")
       end
   --end
end

function CharacterBase:GetMoveNodes(_EndNode)

   self.StartNode = self.NowNode
   self.EndNode = _EndNode
   local Nodes = WorldMapSys.AstarBegin(self.StartNode , self.EndNode)
   if Nodes==nil then
      return nil
   end

   if Nodes~=nil then     
      return Nodes
   end 

end

CharacterBase.TempNodes = nil
function CharacterBase:SetEndNode(_EndNode)
   if self.MoveState=="Move" then                                                              --移动状态终点存入临时终点 
      
      if self.tempEndNode~=nil and self.tempEndNode.NodeId == _EndNode.NodeId then
         Debug.LogError("请等待走完") 
         return
      end         
       
      if self.EndNode~=nil and self.EndNode.NodeId == _EndNode.NodeId then
         Debug.LogError("开始点和终点是一个点 不移动")                                            
         return
      end     
          
      local Nodes = self:GetMoveNodes(_EndNode)
      if Nodes~=nil then
         self.tempEndNode = _EndNode
         self.TempNodes = Nodes
         
         Debug.LogError("新的终点")
      else
         DataUIInstance.PopTip("T4")
         Debug.LogError("No Path")
         return 
      end

      if self.GoInCity==true then
         self.tempEndNode = nil
         WorldMapSocketSys.SendMoveSocketEvent(Nodes)             
      end
                           
   elseif self.MoveState=="Idle" then                                                          --玩家从站立开始移动

      if self.NowNode~=nil and self.NowNode.NodeId == _EndNode.NodeId then
         Debug.LogError("开始点和终点是一个点 不移动")                                            
         return
      end 

      Debug.LogError("重新开始移动")           
      local Nodes = self:GetMoveNodes(_EndNode)
      if Nodes~=nil then
         Debug.LogError("新的终点")
      else
         DataUIInstance.PopTip("T4")
         Debug.LogError("No Path")
         return 
      end
      WorldMapSocketSys.SendMoveSocketEvent(Nodes)
   else
      DataUIInstance.PopTip("V5")
   end

end

function CharacterBase:ShowPoints()
    if self.World_Id~=PlayerControl.WorldId then 
       return
    end
    if self.SaveNodes==nil or #self.SaveNodes==0 then
       return
    end
   
    for i = 1 , #self.SaveNodes , 1 do       
        if self.SaveNodes[i + 1]~=nil then
           local _NodeId = self.SaveNodes[i].NodeId
           local _NextNodeId = self.SaveNodes[i+1].NodeId
           self:SetOnePoint(_NodeId , _NextNodeId , true)
        end
    end
end


function CharacterBase:SetOnePoint(_FirstNodeId , _SecondNodeId , _Show)
    if self.World_Id~=PlayerControl.WorldId then 
       return
    end
    local _Id = tostring(_FirstNodeId).."_"..tostring(_SecondNodeId)
    local _ChangeId = tostring(_SecondNodeId).."_"..tostring(_FirstNodeId)
    if WorldMapSys.Lines[_Id]~=nil then
      -- GameMain.Print(WorldMapSys.Lines[_Id])
       WorldMapSys.Lines[_Id].Point:SetActive(_Show)
    end
    if WorldMapSys.Lines[_ChangeId]~=nil then
      -- GameMain.Print(WorldMapSys.Lines[_ChangeId])
       WorldMapSys.Lines[_ChangeId].Point:SetActive(_Show)
    end
end

function CharacterBase:ClearAllShowPoints()    
    if self.World_Id~=PlayerControl.WorldId then 
       return
    end
    if self.SaveNodes==nil or #self.SaveNodes==0 then
       return
    end

    for i = 1 , #self.SaveNodes , 1 do       
        if self.SaveNodes[i + 1]~=nil then           
           local _NodeId = self.SaveNodes[i].NodeId
           local _NextNodeId = self.SaveNodes[i+1].NodeId
           self:SetOnePoint(_NodeId , _NextNodeId , false)
        end
    end
end

function CharacterBase:SetStopState()                                           --拉停玩家
   self.StopState = true
   self.tempEndNode = nil
   self.EndNode = nil
   self:ClearAllShowPoints()
   self.SaveNodes = {}
end

function CharacterBase:ClearNodeInfo()
   self.tempEndNode = nil
   self.EndNode = nil
   self:ClearAllShowPoints()
   self.SaveNodes = {}
end

function CharacterBase:ClearMe()
   self.StartMoveState = false
   self.MoveState = "Idle"
   self:ClearNodeInfo()
end

function CharacterBase:Release()
    self.Id = nil																	--玩家ID
    self.name = nil																--玩家名字
    if self.PlayerObj~=nil then
       GameObject.Destroy(self.PlayerObj.gameObject)                                   --删除玩家移动模型
    end
    self.PlayerObj = nil															--玩家模型GOb  
    self.PlayerTrans = nil
    self.NameMeshTrans = nil
    self.NameText = nil                                                            --玩家姓名的mesh

    self.World_Id = 0                                                             --世界ID
    self.PlayerName = ""
    self.PlayerRealId = 0

    self.OwnerShip = 1                                                             --归属国

    self.MoveState = "Idle"                                                      --玩家状态  Idle 停止在城市 Move移动在路上 Fight 在城池中战斗 Watch 在城池中观看
    self.MoveStates = {"Idle" , "Move" , "Fight" , "Watch"}
    self.MoveTimeCD = 9                                                          --移动CD
    self.IdleTime = 0                                                         --停留时间CD
    self.MoveCDState = false                                                     --是否可以移动
    self.nowIdleTime = 0                                                       --当前停留状态时间

    self.NowNode = nil                                                           --当前点
    self.LastNode = nil                                                          --上一个点
    self.StartNode = nil                                                         --开始寻路点
    self.EndNode = nil                                                           --终点

    self.Starpos = nil
    self.Temppos = nil

    self.nowTime = 0                   
    self.MoveTime = 3                                                    
    self.StartMoveState = false
    self.NextMoveNode = nil
    self.NextMoveNodeId = 0
    self.SaveNodes = nil

    self.tempEndNode = nil                                                        --当前移动状态的临时终点

    self.GoInCity = false                                                          --进入城池

    self.NetMoveEventCome = false                                                  --移动变更
end

return CharacterBase