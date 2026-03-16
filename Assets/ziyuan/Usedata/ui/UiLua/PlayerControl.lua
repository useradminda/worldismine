PlayerControl = {}															   --鼠标点击事件和角色控制

local this = PlayerControl

PlayerControl.MainCamera = nil												   --场景中的主摄像机父亲
PlayerControl.MainCityCamera = nil
PlayerControl.MainCameraTransform = nil
PlayerControl.UICamera = nil
PlayerControl.TheMeCharacter = nil											   --获得玩家操作对象
PlayerControl.UICallBack = nil												   --玩家移动到某个位置的UI事件


PlayerControl.PlayerList = {}
PlayerControl.WorldId = nil

PlayerControl.MyMapCityGob = nil 
PlayerControl.MyMapCityTrans = nil

function PlayerControl.CreateMy()
   if ClinetInfomation.GetMyGuaShuaiHeroImg()==nil then
      return
   end
  
   if PlayerControl.TheMeCharacter==nil and LoginData.PlayerID~=0 then
       local lua = GameMain.requireLuaFile("CharacterBase")
       local Character = lua:new()
       Character:SetOwner(ClinetInfomation.MyOwner)
       Character:SetVipOfficer(ClinetInfomation.Vip , 12)
       Character:CreatePlayer(LoginData.PlayerID , 0 , ClinetInfomation.Name  , ClinetInfomation.GetMyGuaShuaiHeroImg())
       PlayerControl.TheMeCharacter = Character
   elseif PlayerControl.TheMeCharacter~=nil and LoginData.PlayerID~=0 then
      PlayerControl.TheMeCharacter:CreateGuaShuai(ClinetInfomation.GetMyGuaShuaiHeroImg())
      PlayerControl.TheMeCharacter.World_Id = LoginData.PlayerID
      PlayerControl.TheMeCharacter:ChangeName(ClinetInfomation.Name)
   end
end

function PlayerControl.InitSome()
    PlayerControl.PlayerList = {}
    PlayerControl.MainCamera = GameMain.WorldMapSys.transform:FindChild("MainCamera")
    PlayerControl.MainCityCamera = PlayerControl.MainCamera:GetComponent("Camera")
    PlayerControl.MainCameraTransform = PlayerControl.MainCamera.transform

    if PlayerControl.TheMeCharacter~=nil then
       PlayerControl.TheMeCharacter:SetOwner(ClinetInfomation.MyOwner)
       PlayerControl.TheMeCharacter:SetOwnerUI()
    end

	GameMain.AddUpdateLua(PlayerControl.Update)
end

function PlayerControl.ClickCityEvent(_City)
  

   local UIWorldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
   if UIWorldMapTar~=nil then
      UIWorldMapTar:OpenCityInfoPanel(_City)
   end
end

function PlayerControl.CreateMyMapCity(_Info , _Prefab)
   local Gob = GameObject.Instantiate(_Prefab,Vector3.zero,Quaternion.identity)

   Gob.transform.name = "MyMapPoint"
   Gob.transform.localScale = Vector3(1 , 1 , 1)
   Gob.transform.localEulerAngles = Vector3(0 , 0 , 0)
   Gob.transform.localPosition = Vector3(-568 , 0 , -320) --_Info.Pos.x/128)/2.5 , 0 , (_Info.Pos.z/128)/3.5)
   PlayerControl.MyMapCityGob = Gob.transform:FindChild("MyPoint")
   PlayerControl.MyMapCityTrans = PlayerControl.MyMapCityGob.transform
   lgNoDelCsFun.Ins:SetSpriteColor(PlayerControl.MyMapCityGob:GetComponent("SpriteRenderer") , 255/255 , 255/255 , 0/255)
end


function PlayerControl.CreateCharacter(_WordldId , _ArmyId  ,_Nodes , _NodeCount , _GuaShuaiID , _ArmyCamp , _VipLevel , _Officer , _PlayerName)           --本玩家和其他玩家的移动
   if _WordldId==PlayerControl.WorldId then                         --对于本玩家来说
      local SaveNodes = {}
      for i = 1 , #_Nodes , 1 do
          local NodeId = _Nodes[i]
          SaveNodes[i] = WorldMapSys.CityNodes[NodeId]
      end
      --GameMain.Print(SaveNodes)
      PlayerControl.TheMeCharacter:SendNetEvent(SaveNodes)  
      PlayerControl.TheMeCharacter:ChangeVipOfficer(_VipLevel , _Officer)  
   else          
       local SaveNodes = {}                                         --其他玩家
       for i = 1 , #_Nodes , 1 do
           local NodeId = _Nodes[i]
           SaveNodes[i] = WorldMapSys.CityNodes[NodeId]
       end                                                     
       if PlayerControl.PlayerList[_ArmyId]==nil then               --玩家不在缓存中
          local lua = GameMain.requireLuaFile("CharacterBase")
	      local Character = lua:new()
          PlayerControl.PlayerList[_ArmyId] = Character
          local StartNode = SaveNodes[1]
          local CallBack = PlayerControl.CreateCallBack1
          local data = 
          {
             Character = Character,
             StartPos = StartNode.Pos,
             SaveNodes = SaveNodes,
          }
          Character:SetNodeInfo(StartNode)
          Character:CreatePlayer(_WordldId , _ArmyId , _PlayerName  , ClinetInfomation.GetWorldGuaShuaiName(_GuaShuaiID) , 0 , 0 , data , CallBack , _ArmyCamp , _VipLevel , _Officer)
          
          --Character:SetPos(StartNode.Pos)
          --Character:SetMoveState("Idle") 
         -- Character:SendNetEvent(SaveNodes)
       else                                                     --玩家存在
          local Character = PlayerControl.PlayerList[_ArmyId]
          Character:SendNetEvent(SaveNodes)   
          Character:CreateGuaShuai(ClinetInfomation.GetWorldGuaShuaiName(_GuaShuaiID))
          Character:ChangeVipOfficer(_VipLevel , _Officer)  
       end    
   end
end

function PlayerControl.CreateCallBack1(_Data)
   _Data.Character:SetPos(_Data.StartPos)
   _Data.Character:SetMoveState("Idle")           
   _Data. Character:SendNetEvent(_Data.SaveNodes)      
end

function PlayerControl.ClearTheMeNode()
   if PlayerControl.TheMeCharacter~=nil then
      PlayerControl.TheMeCharacter:ClearNodeInfo()
   end
end

function PlayerControl.SetArmy(_WordldId , _ArmyId , _Nodes , _TempTime , _NodeCount , _ArmyPower , _ConfigId , _GuaShuaiId , _ArmyCamp , _State , _VipLevel , _Officer , _PlayerName)  --本玩家 和其他玩家
   if _WordldId==PlayerControl.WorldId then                         --对于本玩家来说
      local SaveNodes = {}
      for i = 1 , #_Nodes , 1 do
          local NodeId = _Nodes[i]
          SaveNodes[i] = WorldMapSys.CityNodes[NodeId]
      end
      if _NodeCount==1 then                                         --进入世界地图 初始位置
         PlayerControl.TheMeCharacter:SetNodeInfo(SaveNodes[1])
         PlayerControl.TheMeCharacter:SetPos(SaveNodes[1].Pos)
         PlayerControl.TheMeCharacter:SetPower(_ArmyPower)
         PlayerControl.TheMeCharacter:SetArmyId(_ArmyId)  
         PlayerControl.TheMeCharacter:ChangeVipOfficer(_VipLevel , _Officer)        
      else                                                         
          if _TempTime~=nil then                   --登陆后 上次移动还没有结束
             PlayerControl.TheMeCharacter:SendNetEventTempTime(SaveNodes , _TempTime , _State)
          end        
      end

       local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")                            --等到我的数据下发下来了 再创建界面
       if _UIControlTar~=nil then
          _UIControlTar:OpenWorldMapEvent()
       end

     --[[ local _UIWorldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
      if _UIWorldMapTar~=nil then
         _UIWorldMapTar:SetCameraPosition()
      end
      --]]

     -- LoadingPanel.StopChangeScenePanel()
   else          
       local SaveNodes = {}                                         --其他玩家
       for i = 1 , #_Nodes , 1 do
           local NodeId = _Nodes[i]
           SaveNodes[i] = WorldMapSys.CityNodes[NodeId]
       end
                                                          
       if _NodeCount==1 then
          if PlayerControl.PlayerList[_ArmyId]==nil then
              local lua = GameMain.requireLuaFile("CharacterBase")
	          local Character = lua:new()
              PlayerControl.PlayerList[_ArmyId] = Character
              local StartNode = SaveNodes[1]
              local CallBack = PlayerControl.CreateCallBack2
              local data = 
              {   
                 Character = PlayerControl.PlayerList[_ArmyId],                    
                 StartPos = SaveNodes[1].Pos,               
              }
              PlayerControl.PlayerList[_ArmyId]:SetNodeInfo(SaveNodes[1])
              --PlayerControl.PlayerList[_ArmyId]:SetPos(SaveNodes[1].Pos)
              PlayerControl.PlayerList[_ArmyId]:SetPower(_ArmyPower)
              PlayerControl.PlayerList[_ArmyId]:SetArmyId(_ArmyId)
              --PlayerControl.PlayerList[_ArmyId]:SetMoveState("Idle")
              --PlayerControl.PlayerList[_ArmyId]:InitMoveState()
              Character:CreatePlayer(_WordldId , _ArmyId , _PlayerName  , ClinetInfomation.GetWorldGuaShuaiName(_GuaShuaiID) , 0 , _ConfigId  , data , CallBack , _ArmyCamp , _VipLevel , _Officer)
          else        
              PlayerControl.PlayerList[_ArmyId]:SetNodeInfo(SaveNodes[1])
              PlayerControl.PlayerList[_ArmyId]:SetPos(SaveNodes[1].Pos)
              PlayerControl.PlayerList[_ArmyId]:SetPower(_ArmyPower)
              PlayerControl.PlayerList[_ArmyId]:SetArmyId(_ArmyId)
              PlayerControl.PlayerList[_ArmyId]:SetMoveState("Idle")
              PlayerControl.PlayerList[_ArmyId]:InitMoveState()
              PlayerControl.PlayerList[_ArmyId]:ChangeVipOfficer(_VipLevel , _Officer)
          end
          return
       end        
       if _TempTime~=nil then                  --更新其他玩家已经在移动的状态
           if PlayerControl.PlayerList[_ArmyId]==nil then
              local lua = GameMain.requireLuaFile("CharacterBase")
	          local Character = lua:new()
              PlayerControl.PlayerList[_ArmyId] = Character
              local StartNode = SaveNodes[1]
              local CallBack = PlayerControl.CreateCallBack3
              local data = 
              {   
                 Character = PlayerControl.PlayerList[_ArmyId],                    
                 StartPos = StartNode.Pos,  
                 SaveNodes = SaveNodes,
                 _TempTime = _TempTime, 
                 State = _State,
              }
              Character:SetNodeInfo(StartNode)
              --Character:SetPos(StartNode.Pos)
              Character:SetPower(_ArmyPower)
              Character:SetArmyId(_ArmyId)
              --Character:SetMoveState("Idle")
              --Character:SendNetEventTempTime(SaveNodes , _TempTime)  
              Character:CreatePlayer(_WordldId , _ArmyId , _PlayerName  , ClinetInfomation.GetWorldGuaShuaiName(_GuaShuaiID) , 0 , _ConfigId , data , CallBack , _ArmyCamp , _VipLevel , _Officer)             

                  
           else
              local Character = PlayerControl.PlayerList[_ArmyId]
              Character:SendNetEventTempTime(SaveNodes , _TempTime , _State)
              Character:ChangeVipOfficer(_VipLevel , _Officer)
           end

       end
   end
end

function PlayerControl.CreateCallBack2(_Data)
    _Data.Character:SetPos(_Data.StartPos)
    _Data.Character:SetMoveState("Idle")
    _Data.Character:InitMoveState()
end

function PlayerControl.CreateCallBack3(_Data)
    _Data.Character:SetPos(_Data.StartPos)
    _Data.Character:SetMoveState("Idle")
    _Data.Character:SendNetEventTempTime(_Data.SaveNodes , _Data._TempTime , _Data.State)
end 

function PlayerControl.SetArmyAi(_WordldId , _ArmyId , _Nodes , _ConfigId)                      --推送 创建Ai士兵             
       local SaveNodes = {}                                         
       for i = 1 , #_Nodes , 1 do
           local NodeId = tonumber(_Nodes[i])
           SaveNodes[i] = WorldMapSys.CityNodes[NodeId]
       end
                                                          
       if PlayerControl.PlayerList[_ArmyId]==nil then
          local lua = GameMain.requireLuaFile("CharacterBase")
	      local Character = lua:new()
          PlayerControl.PlayerList[_ArmyId] = Character
          local StartNode = SaveNodes[1]
          local CallBack = PlayerControl.CreateCallBack4
          local data = 
          {   
              Character = PlayerControl.PlayerList[_ArmyId],                    
              StartPos = StartNode.Pos,  
              SaveNodes = SaveNodes,
                   
          }
          PlayerControl.PlayerList[_ArmyId]:SetNodeInfo(SaveNodes[1])
          PlayerControl.PlayerList[_ArmyId]:SetConfigId(_ConfigId)
          -- PlayerControl.PlayerList[_ArmyId]:SetPos(SaveNodes[1].Pos)
          -- PlayerControl.PlayerList[_ArmyId]:SetMoveState("Idle")
          -- PlayerControl.PlayerList[_ArmyId]:InitMoveState()
          -- PlayerControl.PlayerList[_ArmyId]:SendNetEvent(SaveNodes) 
          Character:CreatePlayer(0 , _ArmyId , "my"  , ClinetInfomation.GetWorldGuaShuaiName(_GuaShuaiID) , 1 , _ConfigId , data , CallBack)
       else
           PlayerControl.PlayerList[_ArmyId]:SetNodeInfo(SaveNodes[1])
           PlayerControl.PlayerList[_ArmyId]:SetConfigId(_ConfigId)
           PlayerControl.PlayerList[_ArmyId]:SetPos(SaveNodes[1].Pos)
           PlayerControl.PlayerList[_ArmyId]:SetMoveState("Idle")
           PlayerControl.PlayerList[_ArmyId]:InitMoveState()
           PlayerControl.PlayerList[_ArmyId]:SendNetEvent(SaveNodes) 
      end
end

function PlayerControl.CreateCallBack4(_Data)
    _Data.Character:SetPos(_Data.StartPos)
    _Data.Character:SetMoveState("Idle")
    _Data.Character:InitMoveState()
    _Data.Character:SendNetEvent(_Data.SaveNodes)
end 

function PlayerControl.SetArmyAiTempTime(_WordldId , _ArmyId , _Nodes , _TempTime , _ConfigId , _GuaShuaiID , _ArmyCamp , _State , _VipLevel , _Officer , _PlayerName) --更新满族士兵已经在移动的状态
     if _TempTime~=nil and _TempTime~=0 then    
           --GameMain.Print(_Nodes)       
           local SaveNodes = {}                                         
           for i = 1 , #_Nodes , 1 do
               local NodeId = tonumber(_Nodes[i])
               SaveNodes[i] = WorldMapSys.CityNodes[NodeId]
           end                                                               
           if PlayerControl.PlayerList[_ArmyId]==nil then
              local lua = GameMain.requireLuaFile("CharacterBase")
	          local Character = lua:new()
              PlayerControl.PlayerList[_ArmyId] = Character
              local StartNode = SaveNodes[1]
              local CallBack = PlayerControl.CreateCallBack3
              local data = 
              {   
                 Character = PlayerControl.PlayerList[_ArmyId],                    
                 StartPos = StartNode.Pos,  
                 SaveNodes = SaveNodes,
                 _TempTime = _TempTime,  
                 State = _State,       
              }
              Character:SetNodeInfo(StartNode)
             -- Character:SetPos(StartNode.Pos)
             -- Character:SetMoveState("Idle")
             -- Character:SendNetEventTempTime(SaveNodes , _TempTime)      
              Character:CreatePlayer(0 , _ArmyId , _PlayerName  , ClinetInfomation.GetWorldGuaShuaiName(_GuaShuaiID) , 1 , _ConfigId , data , CallBack , _ArmyCamp , _VipLevel , _Officer)
              
           else
              local Character = PlayerControl.PlayerList[_ArmyId]
              Character:SendNetEventTempTime(SaveNodes , _TempTime , _State)  
              Character:ChangeVipOfficer(_VipLevel , _Officer)   
           end
       end
end

function PlayerControl.GotoPlace(_WorldId , _ArmyId , _NodeId)
   if _WorldId==PlayerControl.WorldId or PlayerControl.TheMeCharacter.ArmyID==_ArmyId then 
      local _Node = WorldMapSys.CityNodes[_NodeId]
      PlayerControl.TheMeCharacter:SetNodeInfo(_Node)
      PlayerControl.TheMeCharacter:SetPos(_Node.Pos)
      PlayerControl.TheMeCharacter:SetStopState()
      PlayerControl.TheMeCharacter:ClearMe()
   else
      if PlayerControl.PlayerList[_ArmyId]~=nil then
         local _Node = WorldMapSys.CityNodes[_NodeId]
         PlayerControl.PlayerList[_ArmyId]:SetNodeInfo(_Node)
         PlayerControl.PlayerList[_ArmyId]:SetPos(_Node.Pos)
         PlayerControl.PlayerList[_ArmyId]:SetStopState()
      end
   end
end

function PlayerControl.SetArmyState(_ArmyId , _State , _RoomId , _ConfigId)                                       --改变Ai军队状态
   if PlayerControl.TheMeCharacter.ArmyID==_ArmyId then                                                           --玩家
      PlayerControl.TheMeCharacter:ChangeState(_State)
      if _State==2 then
         PlayerControl.GotoPlace(0 ,  _ArmyId ,  _RoomId)               --休整状态
      elseif _State==3 then
         PlayerControl.GotoPlace(0 ,  _ArmyId ,  _RoomId)               --等待进攻 无法行走

      elseif _State==4 then
         PlayerControl.GotoPlace(0 ,  _ArmyId ,  _RoomId)                 --上阵进攻 无法行走

      elseif _State==5 then
         PlayerControl.GotoPlace(0 ,  _ArmyId ,  _RoomId)                 --正在进攻  无法行走

      elseif _State == 6 then 
         PlayerControl.TheMeCharacter:SetPower(0)
         WorldMapEventSys.SetArmyNum(0)
         PlayerControl.GotoPlace(0 ,  _ArmyId ,  _RoomId)
         DataUIInstance.PopTip("X5")
         local _UIWorldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
         if _UIWorldMapTar~=nil then
            _UIWorldMapTar:SetCameraPosition()
         end
      end
   else
      if PlayerControl.PlayerList[_ArmyId]~=nil then
         if _State==2 then
            --[[if PlayerControl.PlayerList[_ArmyId]~=nil then
               local _Node = WorldMapSys.CityNodes[_RoomId]
               --PlayerControl.PlayerList[_ArmyId]:SetNodeInfo(_Node)
               PlayerControl.PlayerList[_ArmyId]:SetPos(_Node.Pos)            
            end--]]
            PlayerControl.GotoPlace(0 ,  _ArmyId ,  _RoomId)
         elseif _State==3 then
            PlayerControl.GotoPlace(0 ,  _ArmyId ,  _RoomId)               --等待进攻 无法行走

         elseif _State==4 then
            PlayerControl.GotoPlace(0 ,  _ArmyId ,  _RoomId)                 --上阵进攻 无法行走

         elseif _State==5 then
            PlayerControl.GotoPlace(0 ,  _ArmyId ,  _RoomId)                 --正在进攻  无法行走

         elseif _State == 6 then  
            PlayerControl.GotoPlace(0 ,  _ArmyId ,  _RoomId)
                           
         end
         PlayerControl.PlayerList[_ArmyId]:ChangeState(_State)

      elseif PlayerControl.PlayerList[_ArmyId]==nil then
         if _State==1  then
             local _Nodes , _index = WorldActivityConfig.GetArmyNodesByIndex(_RoomId)
             local SaveNodes = {}   
                                               
             for i = _index , #_Nodes , 1 do
                 local NodeId = tonumber(_Nodes[i])
                 table.insert(SaveNodes , #SaveNodes + 1 , WorldMapSys.CityNodes[NodeId])
             end

             local lua = GameMain.requireLuaFile("CharacterBase")
	         local Character = lua:new()
             PlayerControl.PlayerList[_ArmyId] = Character
             local StartNode = SaveNodes[1]
             local CallBack = PlayerControl.CreateCallBack5
             local data = 
             {   
                Character = PlayerControl.PlayerList[_ArmyId],                    
                StartPos = StartNode.Pos,  
                State = _State        
             }
             Character:SetNodeInfo(StartNode)
             --Character:SetPos(StartNode.Pos)     
             --Character:SetNextMoveNodeId(1)
             Character:SetSaveNodes(SaveNodes)
             --Character:ChangeState(_State)
             Character:CreatePlayer(0 , _ArmyId , "my"  , ClinetInfomation.GetWorldGuaShuaiName(_GuaShuaiID) , 1 , _ConfigId , data , CallBack)
            
         end
      end
   end
end

function PlayerControl.CreateCallBack5(_Data)
    _Data.Character:SetPos(_Data.StartPos)
    _Data.Character:SetNextMoveNodeId(1)
    _Data.Character:ChangeState(_Data.State)
end

function PlayerControl.SetMeState(_State)
   if _State==6 then
      PlayerControl.TheMeCharacter:SetPower(0)
      WorldMapEventSys.SetArmyNum(0)
   end
end

function PlayerControl.GetCamera()                                                                  --获得玩家主场景控制的摄像机
	return PlayerControl.MainCityCamera	
end

function PlayerControl.ClickEvent()                                                                  --玩家的点击事件
	 if Input.GetMouseButtonDown(0)==true then		
		local pos1 = Input.mousePosition
	
		PlayerControl.PlayerTouch(pos1)			
	end	
end

function PlayerControl.PlayerTouch(pos)

	if DataUIInstance.JudgeUIEvent()==true then                                                     --检查是否点击UI
		return
	end											
	
	local cam = PlayerControl.GetCamera()	
	local ray =cam:ScreenPointToRay(pos)
	GameMain.GetHitRay(ray,1000,PlayerControl.GetHitRayCB)
	
end

function PlayerControl.Update(deletime)
  --  Debug.LogError(deletime)
   PlayerControl.MyActions(deletime)      
   PlayerControl.OthersActions(deletime)
end

function PlayerControl.MyActions(deletime)
    if PlayerControl.TheMeCharacter~=nil then
       PlayerControl.TheMeCharacter:Update(deletime)
    end
end


function PlayerControl.OthersActions(deletime)
   for key , value in pairs(PlayerControl.PlayerList) do
       value:Update(deletime)
   end
end

function PlayerControl.ReleaseMyCharacter()
    if PlayerControl.TheMeCharacter~=nil then
       PlayerControl.TheMeCharacter:Release()
    end
    PlayerControl.TheMeCharacter = nil
end

function PlayerControl.Release()
	GameMain.DelMainSceneUpdateLua(PlayerControl.Update)
  
    PlayerControl.UICallBack = nil												   --玩家移动到某个位置的UI事件
    PlayerControl.MainCamera = nil
    PlayerControl.MainCityCamera = nil
    PlayerControl.UICamera = nil
	PlayerControl.clickEffectObj = nil
    PlayerControl.MainCameraTransform = nil

    for key, value in pairs(PlayerControl.PlayerList) do
		if value~=nil then
		   local charat = value
		   charat:Release()
           PlayerControl.PlayerList[key]=nil
		end
	end

    PlayerControl.MyMapCityGob = nil 
    PlayerControl.MyMapCityTrans = nil
end

function PlayerControl.ReleaseData() 
    PlayerControl.PlayerList = {}
end

return PlayerControl