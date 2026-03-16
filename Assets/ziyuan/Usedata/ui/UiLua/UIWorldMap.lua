UIWorldMap = {}

local UIWorldMap = BasePanel:new()
local this = UIWorldMap
UIWorldMap.UIWorldMapGob = nil
UIWorldMap.X = 0
UIWorldMap.Y = 0
UIWorldMap.EndX = 0
UIWorldMap.EndZ = 0
UIWorldMap.TempArmyPower = 0
UIWorldMap.TempArmyDaoJu = 0
UIWorldMap.HireCount = 0

function UIWorldMap:OpenUI(_PanelName , _LuaName)
    UIWorldMap.UIWorldMapGob = MainGameUI.FindPanel("UIWorldMap")
    local UIControlTar = MainGameUI.FindPanelTarget("UIControl")
    if UIControlTar~=nil then
       UIControlTar:SetOutSideUIList(false)
       UIControlTar:SetAnchorTopLeft(false)
       UIControlTar:SetAnchorTop(false)
       if UIWorldMap.UICamera==nil then
          UIWorldMap.UICamera = UIControlTar.UICamera
       end
    end
    --GameMain.SocketTestCase()
	MusicManagerSys.ControyBattleMusic()
    this:SetLittleMap()
    this:SetNowGlory()
    this:SetMyGuaShuai()
    this:SetCountry()
    this:SetVip()
    this:SetHireArmyTime()
    this:SetNowTeam(WorldMapEventSys.NowTeam)
    this:SetCameraPosition()
    this:SetArmyNum(WorldMapEventSys.NowArmyNum , WorldMapEventSys.TotalArmyNum)
    this:SetBuyArmyPowerCount()
    this:SetArmyPower(WorldMapSys.BuyArmyPower)
    WorldMapEventSys.AddTempEventList()
    
    LoadingPanel.StopChangeScenePanel()
end


function UIWorldMap:UIHand(_LuaName , _Gob)

 MusicManagerSys.ButtonClick()
   if _Gob.name == "MoveButton" then
      this:MoveEvent()
   elseif _Gob.name == "CityInfoPanel" then
      this:CloseCityInfoPanel()
   elseif _Gob.name == "BackChose" then
      this:BackChose()
   elseif _Gob.name == "MyPosition" then
      this:SetCameraPosition()
   elseif _Gob.name == "SeeDantiao" then
      this:SeeDantiao()
   elseif _Gob.name == "Fairy" then
      this:SetCameraToFairy()
   elseif _Gob.name == "YellowAttack" then
      this:SetCameraToYellowAttack()
   elseif _Gob.name == "Question" then
      this:OpenWorldActivityPanel()
   elseif _Gob.name == "CloseWorldActivityPanel" then
      this:CloseWorldActivityPanel()
    

   elseif _Gob.name == "CloseRewardFromSkyPanel" then  
      this:CloseRewardFromSky()
   elseif _Gob.name == "MoveButtonRFS" then
      this:MoveEvent()
   elseif _Gob.name == "SkyRewardOnCity" then
      this:OpenRewardFromSkyPanel()
   elseif _Gob.name == "GetRewardRFS" then
      this:GetWinReward()
   elseif _Gob.name == "WorldActivity" then
      this:SetActivity()

   elseif _Gob.name == "GetDeadManReward" then 
      this:OpenGetRewardPanel()              
   elseif _Gob.name == "GetDeadManRank" then 
      this:OpenRankPanel()
   elseif _Gob.name == "CloseDeadManPanel" then
      this:CloseDeadManPanel()
   elseif _Gob.name == "DeadManImg" then
      this:WorldRankEvent(2)
      this:OpenDeadManPanel()

   elseif _Gob.name == "GetYellowManReward" then    
       this:GetOtherReward()
   elseif _Gob.name == "GetYellowManWinReward" then  
       this:GetWinReward() 
   elseif _Gob.name == "CloseYellowManPanel" then  
       this:CloseYellowManPanel() 
       
   elseif _Gob.name == "GetSouthManReward" then    
       this:OpenGetRewardPanel()
   elseif _Gob.name == "GetSouthManRank" then  
       this:OpenRankPanel() 
   elseif _Gob.name == "CloseSouthManPanel" then  
       this:CloseSouthManPanel()    
       
   elseif _Gob.name == "CloseWorldFightPanel" then 
        this:CloseWorldFightPanel()
   elseif _Gob.name == "GetWorldFightReward" then
        this:GetWinReward()

   elseif _Gob.name == "CloseGetRewardPanel" then
      this:CloseGetRewardPanel()   
   elseif _Gob.name == "GetReward" then
      this:GetOtherReward()
   elseif _Gob.name == "CloseRankPanel" then
      this:CloseRankPanel()

   elseif _Gob.name == "CloseFairyPanel" then
      this:CloseFairyPanel()
    
   elseif _Gob.name == "TeamPanel" then                     --设置队伍界面
      this:CloseTeamPanel()
   elseif _Gob.name == "TeamButton" then
      this:OpenTeamPanel()
   elseif _Gob.transform.parent.name == "TeamPanel" then
      if _Gob.name == "1" then
         this:ChangeTeam(1)
      elseif _Gob.name == "2" then
         this:ChangeTeam(2)
      elseif _Gob.name == "3" then
         this:ChangeTeam(3)
      elseif _Gob.name == "4" then
         this:ChangeTeam(4)
      end
   elseif _Gob.name == "BuyArmy" then                   --购买兵力
      this:BuyArmy()
   
   elseif _Gob.transform.parent.name == "TempEventReward" then
      this:OpenTempEventPanel(_Gob.transform.name)
   elseif _Gob.name == "MoveButtonTempEvent" then
      this:MoveEvent()
   elseif _Gob.name == "GetRewardTempEvent" then
      this:GetEventReward()  
   elseif _Gob.name == "DrawRewardTempEvent" then
      this:DrawEventReward()
   elseif _Gob.name == "CloseTempEventPanel" then
      this:CloseTempEventPanel()  
   elseif _Gob.transform.parent.name == "ActivityList" then
      this:ClickTempEventTip(_Gob.transform.name)

   elseif _Gob.name == "JieBingButton" then                                                     --借兵
      this:HireArmy()
   elseif _Gob.name == "GoAttackButton" then                                                    --突进
      this:GoAttack()
   elseif _Gob.name == "BackButton" then                                                        --撤退
      this:Back()
   elseif _Gob.name == "GuanZhan" then                                                          --观战
      this:SendRequestSeeFight()
   elseif _Gob.name == "DanTiao" then                                                           --单挑
      this:SendDatiao()
   elseif _Gob.name == "ZhaoJi" then                                                            --召集
      DataUIInstance.PopTip("暂未开放")
      --this:Zhaoji()
   elseif _Gob.name == "DrawRewardPanel" then                                                   --关闭抽奖界面
      this:CloseDrawRewardPanel()
   elseif _Gob.name == "Draw" then 
      this:GetDrawReward()

   elseif _Gob.name == "WorldInfo" then
      this:OpenArmyMoneyPanel()
   elseif _Gob.name == "CloseArmyMoney" then
      this:CloseArmyMoneyPanel()
   elseif _Gob.name == "GetArmyMoneyButton" then
      this:GetArmyMoney()

   elseif _Gob.name == "Honour" then
      this:OpenGloryPanel()  
   elseif _Gob.name == "BuyGloryReward" then
      this:BuyGloryReward()
   elseif _Gob.name == "GetGloryReward" then
      this:GetGloryReward()
   elseif _Gob.name == "GloryRank" then
      this:GetGloryRank()
   elseif _Gob.name == "CloseGloryRankPanel" then
      this:CloseGloryRankPanel()

   elseif _Gob.name == "CloseGloryPanel" then
      this:CloseGloryPanel()  
   
   elseif _Gob.transform.parent.name == "ImgOnCity" then
      this:SetEmemyEventPanel(tonumber(_Gob.transform.name))

   elseif _Gob.transform.parent.name == "CallPanel" then            --点击弹开召集界面   
      this:OpenReCallPanel(tonumber(_Gob.name))

   elseif _Gob.transform.name == "ReCallGoButton" then       --点击召集
      this:AnswerCallEvent()
   elseif _Gob.transform.name == "CancelButton" then         
      this:CloseReCallPanel()
   elseif _Gob.transform.name == "CloseReCallPanel" then
      this:CloseReCallPanel()

   elseif _Gob.transform.parent.name == "QuestionButton" then
      this:OpenQuestionPanel()
   elseif _Gob.transform.parent.name == "CloseQuestionPanel" then
      this:CloseQuestionPanel()
   
   end
     
end

UIWorldMap.ArmyMoneyPanel = nil
function UIWorldMap:OpenArmyMoneyPanel()                                                        --打开军资
   if UIWorldMap.ArmyMoneyPanel==nil then
      UIWorldMap.ArmyMoneyPanel = UIWorldMap.UIWorldMapGob.transform:FindChild("ArmyMoneyPanel")
   end
   UIWorldMap.ArmyMoneyPanel.gameObject:SetActive(true)
   this:SetArmyMoneyPanel()
end

UIWorldMap.TempCoin = 0
function UIWorldMap:SetArmyMoneyPanel()
   local _TempArmyMoney = ArmyMoneySys.GetNowArmyMoney()
   local tt = 0
   local dd = 0
   local bei = 1
   if _TempArmyMoney~=nil then
       dd =  GameMain.modf(_TempArmyMoney.Time , 100)  
       if dd==0 then 
          tt = 0*100
       else
          tt = GameMain.RetainPoint(dd , 2)*100
       end
       bei = 1
       if tt==0 then
          bei= 1
       elseif tt==3 then
          bei= 3
       elseif tt==6 then
          bei= 6
       elseif tt==9 then
          bei= 3
       elseif tt==12 then
          bei= 6
       elseif tt==15 then
          bei= 10
       elseif tt==18 then
          bei= 6
       elseif tt==21 then
          bei= 1
       end
   end

   if _TempArmyMoney==nil then
      UIWorldMap.ArmyMoneyPanel.transform:FindChild("ArmyReward"):FindChild("Count"):GetComponent("UILabel").text = tostring(0) 
      UIWorldMap.ArmyMoneyPanel.transform:FindChild("GetArmyMoney"):FindChild("Count"):GetComponent("UILabel").text = tostring(0) 
   else
      UIWorldMap.ArmyMoneyPanel.transform:FindChild("TimeTitle"):FindChild("ArmyMoneyTitle"):GetComponent("UILabel").text = tostring(tt)..":00"..UIstring.ArmyTitle.."("..tostring(bei)..UIstring.Bei..")"
      UIWorldMap.ArmyMoneyPanel.transform:FindChild("ArmyReward"):FindChild("Count"):GetComponent("UILabel").text = tostring(_TempArmyMoney.Money) 
      UIWorldMap.TempCoin = _TempArmyMoney.Money
      local _Count = ArmyMoneySys.GetArmyMoneyCount()
      UIWorldMap.ArmyMoneyPanel.transform:FindChild("GetArmyMoney"):FindChild("Count"):GetComponent("UILabel").text = tostring(_Count) 
   end
   local _Count = WorldMapSys.GetMyCityNum() 
   UIWorldMap.ArmyMoneyPanel.transform:FindChild("MyCityNum"):FindChild("Count"):GetComponent("UILabel").text = tostring(_Count) 
end

function UIWorldMap:GetArmyMoneyCallBack()
   local _TempArmyMoney = ArmyMoneySys.GetNowArmyMoney()
   DataUIInstance.PopTip(UIstring.Y3..tostring(UIWorldMap.TempCoin))  
end

function UIWorldMap:GetArmyMoney()
   ArmyMoneySys.GetArmyMoney()
end

function UIWorldMap:CloseArmyMoneyPanel()                                                      --关闭军资界面
   UIWorldMap.ArmyMoneyPanel.gameObject:SetActive(false)
end

UIWorldMap.GloryPanel = nil
function UIWorldMap:OpenGloryPanel()                                                            --功勋界面
   if UIWorldMap.GloryPanel==nil then
      UIWorldMap.GloryPanel = UIWorldMap.UIWorldMapGob.transform:FindChild("GloryPanel")
   end
   UIWorldMap.GloryPanel.gameObject:SetActive(true)
   this:SetGloryPanel()
end

UIWorldMap.LeftBoxNum = 0
function UIWorldMap:SetGloryPanel()
   UIWorldMap.LeftBoxNum = ArmyGloryDataSys.GetTotalBoxNumLeft()
   UIWorldMap.GloryPanel.transform:FindChild("GetRewardPanel"):FindChild("GloryRewardNum"):GetComponent("UILabel").text = tostring(UIWorldMap.LeftBoxNum)
   local _totalCount = ArmyGloryDataSys.GetGloryRewardTotalNum()
   local _FeatsList = ArmyGloryDataSys.GetGloryRewardFeatList()
   UIWorldMap.GloryPanel.transform:FindChild("GloryBoxPanel"):FindChild("GloryBoxSlider"):GetComponent("UISlider").value = ClinetInfomation.Feats / _totalCount
   UIWorldMap.GloryPanel.transform:FindChild("MyInfoPanel"):FindChild("Glory"):FindChild("GloryC"):GetComponent("UILabel").text = tostring(ClinetInfomation.Feats)
   for i = 1 , 5 , 1 do
       local _TempFeat = _FeatsList[i]
       UIWorldMap.GloryPanel.transform:FindChild("GloryBoxPanel"):FindChild("GloryTar"):FindChild(tostring(i)):GetComponent("UILabel").text = tostring(_TempFeat)
   end
   this:SetNowGlory()
end

function UIWorldMap:BuyGloryReward()
   local _Count = ArmyGloryDataSys.GetGloryRewardTotalNum()
   if ClinetInfomation.Feats >= _Count then
      DataUIInstance.PopTip("W9")
   else
      local t1 , t2 = math.modf((_Count - ClinetInfomation.Feats)/10)
      local data = 
      {
         Money = tonumber(t1),
      }
      DataUIInstance.PopTipPanel("CostMoney" , this.BuyGloryEvent , data)
   end  
end

function UIWorldMap:BuyGloryEvent()
   ArmyGlorySys.BuyGlory()
end

function UIWorldMap:GetGloryReward()
   if UIWorldMap.LeftBoxNum<=0 then
      DataUIInstance.PopTip("U7")
      return
   end
   ArmyGlorySys.GetGloryReward()
end

function UIWorldMap:GetGloryRank()
   ArmyGlorySys.GetGloryRank()
end

UIWorldMap.GloryRankPanel=nil
UIWorldMap.GloryRankList = {}
function UIWorldMap:GetGloryRankCallBack()
  if UIWorldMap.GloryRankPanel==nil then
     UIWorldMap.GloryRankPanel = UIWorldMap.UIWorldMapGob.transform:FindChild("GloryRankPanel")
  end

  UIWorldMap.GloryRankPanel.gameObject:SetActive(true)
  if #UIWorldMap.GloryRankList==0 then
     for i = 1 , 10 , 1 do
         UIWorldMap.GloryRankList[i] = UIWorldMap.GloryRankPanel.transform:FindChild("InfoPanel"):FindChild("RankGrid"):FindChild(tostring(i))
     end
  end
  for i = 1 , 10 , 1 do
		if ArmyGlorySys.GloryRankList[i] ~= nil then
			GameMain.OpenObj(UIWorldMap.GloryRankList[i])
			 UIWorldMap.GloryRankList[i].transform:FindChild("Rank"):GetComponent("UILabel").text = tostring(ArmyGlorySys.GloryRankList[i].Rank)
			  UIWorldMap.GloryRankList[i].transform:FindChild("Country"):GetComponent("UILabel").text = tostring(ArmyGlorySys.GloryRankList[i].Camp)
			  UIWorldMap.GloryRankList[i].transform:FindChild("Name"):GetComponent("UILabel").text = tostring(ArmyGlorySys.GloryRankList[i].Name)
			  UIWorldMap.GloryRankList[i].transform:FindChild("Vip"):GetComponent("UILabel").text = "Vip."..tostring(ArmyGlorySys.GloryRankList[i].Vip)
			  UIWorldMap.GloryRankList[i].transform:FindChild("Glory"):GetComponent("UILabel").text = tostring(ArmyGlorySys.GloryRankList[i].Feats)
		else
			GameMain.CloseObj(UIWorldMap.GloryRankList[i])
		end
     
  end
  UIWorldMap.GloryRankPanel.transform:FindChild("MyRank"):GetComponent("UILabel").text = tostring(ArmyGlorySys.MyGloryRank)
end

function UIWorldMap:CloseGloryRankPanel()
   if UIWorldMap.GloryRankPanel~=nil then
      UIWorldMap.GloryRankPanel.gameObject:SetActive(false)
  end
end

function UIWorldMap:CloseGloryPanel()
   UIWorldMap.GloryPanel.gameObject:SetActive(false)
end

UIWorldMap.TeamPanel = nil
function UIWorldMap:OpenTeamPanel()                                                            --打开选择队伍界面
   if UIWorldMap.TeamPanel==nil then
      UIWorldMap.TeamPanel = UIWorldMap.UIWorldMapGob.transform:FindChild("MyInfo"):FindChild("TeamPanel")
   end
   if UIWorldMap.TeamPanel.gameObject.activeInHierarchy ==true then
      UIWorldMap.TeamPanel.gameObject:SetActive(false)
   else
      UIWorldMap.TeamPanel.gameObject:SetActive(true)
   end
end 

function UIWorldMap:ChangeTeam(_TeamNumber)                                                    --改变队伍 
   this:CloseTeamPanel()
   if WorldMapEventSys.NowArmyNum==0 then
      DataUIInstance.PopTip("T3")
      return
   end
   if _TeamNumber == UIWorldMap.NowTeam then
      DataUIInstance.PopTip("W8")
      return
   end
   local _TeamInfo = TeamSys.GetTeamInfoByType(_TeamNumber)
   if _TeamInfo==nil then
      DataUIInstance.PopTip("T7")
      return
   else
      if #_TeamInfo==0 then
         DataUIInstance.PopTip("T7")
         return
      end
   end  
   WorldMapSocketSys.SendRequestChangeTeam(_TeamNumber)  
end

UIWorldMap.Country = nil
function UIWorldMap:SetCountry()              --设置国家
   if UIWorldMap.Country == nil then
      UIWorldMap.Country = UIWorldMap.UIWorldMapGob.transform:FindChild("MyInfo"):FindChild("Country"):GetComponent("UISprite")
   end
   if ClinetInfomation.MyOwner==1 then
      UIWorldMap.Country.spriteName = "shu" 
   elseif ClinetInfomation.MyOwner==2 then
      UIWorldMap.Country.spriteName = "wei" 
   elseif ClinetInfomation.MyOwner==3 then
      UIWorldMap.Country.spriteName = "wu"
   end
end

UIWorldMap.Vip = nil
UIWorldMap.VipFirst = nil
function UIWorldMap:SetVip()
   if UIWorldMap.Vip == nil then
      UIWorldMap.Vip = UIWorldMap.UIWorldMapGob.transform:FindChild("MyInfo"):FindChild("Vip"):GetComponent("UISprite")
      UIWorldMap.VipFirst = UIWorldMap.UIWorldMapGob.transform:FindChild("MyInfo"):FindChild("VipFirst"):GetComponent("UISprite")
   end
   if ClinetInfomation.Vip < 10 then
      UIWorldMap.VipFirst.gameObject:SetActive(false)
      UIWorldMap.Vip.spriteName = "vip_"..tostring(ClinetInfomation.Vip)
   else
      UIWorldMap.Vip.spriteName = "vip_1"
      UIWorldMap.VipFirst.gameObject:SetActive(true)
      if ClinetInfomation.Vip ==11 then
         UIWorldMap.VipFirst.spriteName = "vip_1"
      elseif ClinetInfomation.Vip ==12 then
         UIWorldMap.VipFirst.spriteName = "vip_2"
      elseif ClinetInfomation.Vip ==13 then
         UIWorldMap.VipFirst.spriteName = "vip_3"
      end
   end
end

function UIWorldMap:SetLittleMap()
   local _Tex = lgNoDelCsFun.Ins:CreateTexture()
   if _Tex~=nil then
   UIWorldMap.UIWorldMapGob.transform:FindChild("LittleMap/Cube"):GetComponent("MeshRenderer").material.mainTexture = _Tex--lgNoDelCsFun.Ins:CreateTexture()
   UIWorldMap.UIWorldMapGob.transform:FindChild("LittleMap/Cube"):GetComponent("MeshRenderer").material.renderQueue = 4000
   end
end

function UIWorldMap:SetNowGlory()               --设置功勋
   UIWorldMap.UIWorldMapGob.transform:FindChild("Honour"):FindChild("Count"):GetComponent("UILabel").text = tostring(ClinetInfomation.Feats)
end

UIWorldMap.WorldHead = nil
function UIWorldMap:SetMyGuaShuai()             --设置挂刷头像
   if UIWorldMap.WorldHead == nil then
      UIWorldMap.WorldHead = UIWorldMap.UIWorldMapGob.transform:FindChild("MyInfo"):FindChild("HeadImg"):GetComponent("UISprite")
   end
   UIWorldMap.WorldHead.spriteName = ClinetInfomation.GetMyGuaShuaiSpriteName()
end

UIWorldMap.NowTeam = 0
function UIWorldMap:SetNowTeam(_TeamNumber)                                                 --设置当前队伍UI
   UIWorldMap.NowTeam = _TeamNumber
   UIWorldMap.UIWorldMapGob.transform:FindChild("MyInfo"):FindChild("MyState"):GetComponent("UILabel").text = UIstring.WorldTeam[_TeamNumber]

end

function UIWorldMap:CloseTeamPanel()
   if UIWorldMap.TeamPanel~=nil then
      UIWorldMap.TeamPanel.gameObject:SetActive(false)
   end
end


function UIWorldMap:BuyArmy()                                                                --购买兵力
   if WorldMapSys.BuyArmyPower <= 0 then
      DataUIInstance.PopTip("Z7")
      return
   end
   WorldMapSocketSys.SendRequestBuyArmy()
end

function UIWorldMap:SetArmyNum(_NowArmy , _TotalArmy)                                         --设置兵力UI
   UIWorldMap.UIWorldMapGob.transform:FindChild("MyInfo"):FindChild("ArmyNum"):GetComponent("UILabel").text = tostring(_NowArmy).."/"..tostring(_TotalArmy)
end

function UIWorldMap:SetArmyPower(_ArmyPower)
   
   UIWorldMap.UIWorldMapGob.transform:FindChild("BuyArmy"):FindChild("Title"):GetComponent("UILabel").text = UIstring.BuyArmyPower.."("..tostring(_ArmyPower)..")"
end

function UIWorldMap:SetBuyArmyPowerCount()
   local _Count = ItemPackageSys.GetItemCountById(1131)
   UIWorldMap.TempArmyDaoJu = _Count
end

function UIWorldMap:SetHireArmyTime()
   local _Count = ItemPackageSys.GetItemCountById(9999)
   UIWorldMap.HireCount = _Count
end

UIWorldMap.HireMoney = false
function UIWorldMap:HireArmy()                                                  --借兵
   if UIWorldMap.HireCount <= 0 then
      if ClinetInfomation.Diamond < 100 then
         DataUIInstance.PopTip("W2")

         return
      end
      UIWorldMap.HireMoney = true                               --使用金钱
      local data = 
      {
         Money = 100,
      }
      DataUIInstance.PopTipPanel("CostMoney" , this.HireArmyEvent , data)
   else
      UIWorldMap.HireMoney = false--]]
      this:HireArmyEvent()
   end 
end

function UIWorldMap:HireArmyEvent()
   if UIWorldMap.HireMoney == true then
      WorldMapSocketSys.SendRequestHireArmy(100)
   else
      WorldMapSocketSys.SendRequestHireArmy(0)
   end
end

function UIWorldMap:HireArmyCallBack()
   this:CloseCityInfoPanel()
   if UIWorldMap.HireMoney == true then

   else
      UIWorldMap.HireCount = UIWorldMap.HireCount - 1
   end
end

UIWorldMap.AttackState = false
UIWorldMap.TempGoAttackCitys = {}
function UIWorldMap:GoAttack()                                                  --突进
        if PlayerControl.TheMeCharacter.NowNode.NodeId~=UIWorldMap.ChoseCityNode.NodeId then 
           return
        end
        UIWorldMap.TempGoAttackCitys = {}
        UIWorldMap.AttackState = false
    
        local _CityAround = PlayerControl.TheMeCharacter.NowNode.NeighbourNodesId
        for i = 1 , #_CityAround , 1 do
            local _CityId = _CityAround[i]
            local _TCity = WorldMapSys.CityNodes[_CityId]
            if _TCity.OwnerShipNow ~= ClinetInfomation.MyOwner then
               UIWorldMap.TempGoAttackCitys[_CityId] = _CityId
               _TCity:SetCanMove(true)
               UIWorldMap.AttackState = true
               this:CloseCityInfoPanel()
            end
        end

       if UIWorldMap.AttackState==false then
          DataUIInstance.PopTip("T6")
       end
end

UIWorldMap.BackState = false
UIWorldMap.TempBackCitys = {}
function UIWorldMap:Back()                                                      --撤退
        if PlayerControl.TheMeCharacter.NowNode.NodeId~=UIWorldMap.ChoseCityNode.NodeId then 
           return
        end
        UIWorldMap.TempBackCitys = {}
        UIWorldMap.BackState = false
  -- if PlayerControl.TheMeCharacter.NowNode.CityState == "Fight" then      
        local _CityAround = PlayerControl.TheMeCharacter.NowNode.NeighbourNodesId
        for i = 1 , #_CityAround , 1 do
            local _CityId = _CityAround[i]
            local _TCity = WorldMapSys.CityNodes[_CityId]
            if _TCity.OwnerShipNow == ClinetInfomation.MyOwner then
               UIWorldMap.TempBackCitys[_CityId] = _CityId
               _TCity:SetCanMove(true)
               UIWorldMap.BackState = true
               this:CloseCityInfoPanel()
            end
        end
        if UIWorldMap.BackState==false then
           DataUIInstance.PopTip("T5")
        end
  -- end
   --WorldMapSocketSys.SendRequestBack()
end



function UIWorldMap:MoveEvent()                                                 --移动
   PlayerControl.TheMeCharacter:SetEndNode(UIWorldMap.ChoseCityNode)
   this:CloseCityInfoPanel()
   this:CloseRewardFromSky()
   this:CloseTempEventPanel()
end

function UIWorldMap:SetCameraPosition()                                         --我的位置
   if PlayerControl.TheMeCharacter~=nil then
      local X , Z = this:JudgeCameraPosition(PlayerControl.TheMeCharacter.PlayerTrans.localPosition.x , PlayerControl.TheMeCharacter.PlayerTrans.localPosition.z)
     
      PlayerControl.MainCameraTransform.localPosition = Vector3(X , PlayerControl.TheMeCharacter.PlayerTrans.localPosition.y , Z)
      this:SetCameraTarPos()
   end
end

function UIWorldMap:JudgeCameraPosition(_X , _Z)
   local X = _X
   local Z = _Z
   if _X >=5712 then
      X = 5712 
   end
   if _X <=806 then 
      X = 806
   end
   if _Z >= 4627 then
      Z = 4627
   end
   if _Z <= 500 then
      Z = 500
   end
   return X , Z
end

UIWorldMap.CameraTar = nil
function UIWorldMap:SetCameraTarPos()
   if UIWorldMap.CameraTar == nil then
      UIWorldMap.CameraTar = UIWorldMap.UIWorldMapGob.transform:FindChild("CameraTarPanel/ImgOnCity/CameraTar").transform
   end
   if UIWorldMap.CameraTar==nil then
      return
   end
   local _TotalX = 4906
   local _OffX = PlayerControl.MainCameraTransform.localPosition.x - 806
   local bl = _OffX/_TotalX
   if _OffX < 0 then
      bl = 0
   end

   local _OffCameraX = 174 * bl
   local _EndX = 939 + _OffCameraX
   local _TotalY = 4127
   local _OffY = PlayerControl.MainCameraTransform.localPosition.z - 500
   local blY = _OffY/_TotalY
   if _OffY < 0 then
      blY = 0
   end
   local _OffCameraY = 125 * blY
   local _EndY = 495 + _OffCameraY

   UIWorldMap.CameraTar.transform.localPosition = Vector3(_EndX , _EndY , 0)

end

UIWorldMap.WorldActivityPanel = nil
function UIWorldMap:OpenWorldActivityPanel()                                    --世界站活动
   if UIWorldMap.WorldActivityPanel==nil then
      UIWorldMap.WorldActivityPanel = UIWorldMap.UIWorldMapGob.transform:FindChild("WorldActivityPanel")
      for i = 1 , 7 , 1 do
          for j = 1 , 3 , 1 do
              local _string = "Day"..tostring(i).."_"..tostring(j)
              UIWorldMap.WorldActivityPanel.transform:FindChild("WorldActivity"):FindChild("WorldActivityGrid"):FindChild(tostring(i)):FindChild(tostring(j)):GetComponent("UILabel").text = UIstring[_string]
          end
      end
   end
   UIWorldMap.WorldActivityPanel.gameObject:SetActive(true)
end

function UIWorldMap:CloseWorldActivityPanel()                                    --关闭世界站活动
   UIWorldMap.WorldActivityPanel.gameObject:SetActive(false)
end


UIWorldMap.GetRewardPanel = nil
function UIWorldMap:OpenGetRewardPanel()                                   --打开领取名次奖励界面
   if UIWorldMap.GetRewardPanel==nil then
      UIWorldMap.GetRewardPanel = UIWorldMap.UIWorldMapGob.transform:FindChild("GetRewardPanel")
   end
   UIWorldMap.GetRewardPanel.gameObject:SetActive(true)
   if WorldMapEventSys.EventType== 1 then
      UIWorldMap.GetRewardPanel.transform:FindChild("RewardPanel"):FindChild("RewardPanelGrid"):FindChild("1"):FindChild("BoxLvl"):GetComponent("UILabel").text = UIstring.SHJL1
      UIWorldMap.GetRewardPanel.transform:FindChild("RewardPanel"):FindChild("RewardPanelGrid"):FindChild("2"):FindChild("BoxLvl"):GetComponent("UILabel").text = UIstring.SHJL2
      UIWorldMap.GetRewardPanel.transform:FindChild("RewardPanel"):FindChild("RewardPanelGrid"):FindChild("3"):FindChild("BoxLvl"):GetComponent("UILabel").text = UIstring.SHJL3
      UIWorldMap.GetRewardPanel.transform:FindChild("RewardPanel"):FindChild("RewardPanelGrid"):FindChild("4"):FindChild("BoxLvl"):GetComponent("UILabel").text = UIstring.SHJL4
      UIWorldMap.GetRewardPanel.transform:FindChild("RewardPanel"):FindChild("RewardPanelGrid"):FindChild("5"):FindChild("BoxLvl"):GetComponent("UILabel").text = UIstring.SHJL5
   elseif WorldMapEventSys.EventType== 2 then
      UIWorldMap.GetRewardPanel.transform:FindChild("RewardPanel"):FindChild("RewardPanelGrid"):FindChild("1"):FindChild("BoxLvl"):GetComponent("UILabel").text = UIstring.NMRQ1
      UIWorldMap.GetRewardPanel.transform:FindChild("RewardPanel"):FindChild("RewardPanelGrid"):FindChild("2"):FindChild("BoxLvl"):GetComponent("UILabel").text = UIstring.NMRQ2
      UIWorldMap.GetRewardPanel.transform:FindChild("RewardPanel"):FindChild("RewardPanelGrid"):FindChild("3"):FindChild("BoxLvl"):GetComponent("UILabel").text = UIstring.NMRQ3
      UIWorldMap.GetRewardPanel.transform:FindChild("RewardPanel"):FindChild("RewardPanelGrid"):FindChild("4"):FindChild("BoxLvl"):GetComponent("UILabel").text = UIstring.NMRQ4
      UIWorldMap.GetRewardPanel.transform:FindChild("RewardPanel"):FindChild("RewardPanelGrid"):FindChild("5"):FindChild("BoxLvl"):GetComponent("UILabel").text = UIstring.NMRQ5
   end
   this:SetRewardPanel()
end

function UIWorldMap:SetRewardPanel()
   UIWorldMap.GetRewardPanel.transform:FindChild("MyRank"):GetComponent("UILabel").text = tostring(WorldMapEventSys.MyRank)
   UIWorldMap.GetRewardPanel.transform:FindChild("MyDemage"):GetComponent("UILabel").text = tostring(WorldMapEventSys.MyDemage)
end

function UIWorldMap:CloseGetRewardPanel()
   if UIWorldMap.GetRewardPanel~=nil then
      UIWorldMap.GetRewardPanel.gameObject:SetActive(false)
   end
end

UIWorldMap.QuestionPanel = nil
UIWorldMap.RuleText = nil
function UIWorldMap:SetQuestionPanel(_Des)
   if UIWorldMap.QuestionPanel==nil then
      UIWorldMap.QuestionPanel = UIWorldMap.UIWorldMapGob.transform:FindChild("QuestionPanel")
      UIWorldMap.RuleText = UIWorldMap.QuestionPanel.transform:FindChild("RuleTitle"):GetComponent("UILabel")
   end   
   UIWorldMap.RuleText.text = _Des
end

function UIWorldMap:OpenQuestionPanel()
   if UIWorldMap.QuestionPanel==nil then
      UIWorldMap.QuestionPanel = UIWorldMap.UIWorldMapGob.transform:FindChild("QuestionPanel")     
   end   
   UIWorldMap.QuestionPanel.gameObject:SetActive(true)
end

function UIWorldMap:CloseQuestionPanel()
   if UIWorldMap.QuestionPanel==nil then
      UIWorldMap.QuestionPanel = UIWorldMap.UIWorldMapGob.transform:FindChild("QuestionPanel")     
   end   
   UIWorldMap.QuestionPanel.gameObject:SetActive(false)
end


UIWorldMap.RankPanel = nil
function UIWorldMap:OpenRankPanel()                                        --打开输出排行界面
   if UIWorldMap.RankPanel==nil then
      UIWorldMap.RankPanel = UIWorldMap.UIWorldMapGob.transform:FindChild("RankPanel")
   end
   UIWorldMap.RankPanel.gameObject:SetActive(true)
   this:SetRankPanel()
end

function UIWorldMap:SetRankPanel()                                         --设置输出排行
   for i = 1 , 21 , 1 do    
       UIWorldMap.RankPanel.transform:FindChild("InfoPanel"):FindChild("RankGrid"):FindChild(tostring(i)).gameObject:SetActive(false)
   end
   UIWorldMap.DeadManPanel.transform:FindChild("MyRank"):FindChild("Rank"):GetComponent("UILabel").text = tostring(WorldMapEventSys.MyRank)
   for i = 1 , #WorldMapEventSys.DemageRankList , 1 do
       if i > 21 then
          return
       end
       UIWorldMap.RankPanel.transform:FindChild("InfoPanel"):FindChild("RankGrid"):FindChild(tostring(i)).gameObject:SetActive(true)
       UIWorldMap.RankPanel.transform:FindChild("InfoPanel"):FindChild("RankGrid"):FindChild(tostring(i)):FindChild("Rank"):GetComponent("UILabel").text = tostring(i)
       UIWorldMap.RankPanel.transform:FindChild("InfoPanel"):FindChild("RankGrid"):FindChild(tostring(i)):FindChild("Name"):GetComponent("UILabel").text = tostring(WorldMapEventSys.DemageRankList[i].Name)
       UIWorldMap.RankPanel.transform:FindChild("InfoPanel"):FindChild("RankGrid"):FindChild(tostring(i)):FindChild("Demage"):GetComponent("UILabel").text = tostring(WorldMapEventSys.DemageRankList[i].Demage)
       UIWorldMap.RankPanel.transform:FindChild("InfoPanel"):FindChild("RankGrid"):FindChild(tostring(i)):FindChild("Lvl"):GetComponent("UILabel").text = tostring(WorldMapEventSys.DemageRankList[i].Lvl)
   end
end

function UIWorldMap:CloseRankPanel()                                        --关闭输出排行
   if UIWorldMap.RankPanel~=nil then
      UIWorldMap.RankPanel.gameObject:SetActive(false)
   end
end

function UIWorldMap:SendRequestSeeFight()                                       --请求观战
   WorldMapSocketSys.SendRequestSeeFight(1 , UIWorldMap.ChoseCityNode.NodeId)
end

function UIWorldMap:SendDatiao()                                                --请求单挑
   WorldMapSocketSys.SendRequestDantiao()
end

function UIWorldMap:SetDantiaoName(_Name)                                       --设置单挑对象
   UIWorldMap.UIWorldMapGob.transform:FindChild("SeeDantiaoPanel").gameObject:SetActive(true) 
   UIWorldMap.UIWorldMapGob.transform:FindChild("SeeDantiaoPanel"):FindChild("MyName"):GetComponent("UILabel").text = ClinetInfomation.Name
   UIWorldMap.UIWorldMapGob.transform:FindChild("SeeDantiaoPanel"):FindChild("AnemyName"):GetComponent("UILabel").text = _Name
end

function UIWorldMap:SeeDantiao()                                                --请求观战单挑
   WorldMapSocketSys.SendRequestSeeFight(2 , 0)
end

function UIWorldMap:Zhaoji()                                                    --请求召集
   WorldMapSocketSys.SendRequestCallFriend(1)
end

UIWorldMap.CallItems = {}
UIWorldMap.CallList = {}
function UIWorldMap:SetCall(_CallId , _TotalTime)                                                   --设置召集
   if #UIWorldMap.CallItems==0 then
       for i = 1 , 10 , 1 do
           if UIWorldMap.CallItems[i]==nil then
              UIWorldMap.CallItems[i] = {}
           end
           UIWorldMap.CallItems[i].Item = UIWorldMap.UIWorldMapGob.transform:FindChild("CallPanel"):FindChild(tostring(i))
           UIWorldMap.CallItems[i].Label = UIWorldMap.CallItems[i].Item.transform:FindChild("Time"):GetComponent("UILabel")
           UIWorldMap.CallItems[i].IsUse = false
       end
   end

   if UIWorldMap.CallList[_CallId] == nil then
      UIWorldMap.CallList[_CallId] = {}
   end
   UIWorldMap.CallList[_CallId].CallId = _CallId
   UIWorldMap.CallList[_CallId].TotalTime = _TotalTime
   TimeControl.LoginTime(_TotalTime , tostring(_CallId))
   GameMain.AddUpdateLua(this.UpdateCallEventTime)
   for i = 1 , 10 , 1 do
       if UIWorldMap.CallItems[i].IsUse == false then
          UIWorldMap.CallItems[i].IsUse = true
          UIWorldMap.CallItems[i].Item.gameObject:SetActive(true)
          UIWorldMap.CallItems[i].Item.name = tostring(_CallId)
          UIWorldMap.CallList[_CallId].Item = UIWorldMap.CallItems[i].Item
          UIWorldMap.CallList[_CallId].Label = UIWorldMap.CallItems[i].Label
          return
       end
   end
end

function UIWorldMap.UpdateCallEventTime()
   for key , value in pairs(UIWorldMap.CallList) do
       local _Time = TimeControl.GetTime(tostring(key))
       local _TimeString = TimeControl.GetTimeString(_Time)
       if UIWorldMap.CallList[key]~=nil then
          UIWorldMap.CallList[key].Label.text = _TimeString
       end
       if _Time<=0 then
          WorldMapEventSys.DeleteCallEventList(key)
       end
   end
end

function UIWorldMap:DeleteCallEvent(_CallId)
   if UIWorldMap.CallList[_CallId]~=nil then 
      for i = 1 , 10 , 1 do
          if UIWorldMap.CallItems[i].Item.name == tostring(_CallId) then
             UIWorldMap.CallItems[i].Item.gameObject:SetActive(false)
             UIWorldMap.CallItems[i].IsUse = false
          end
      end     
      UIWorldMap.CallList[_CallId] = nil
   end
end

UIWorldMap.ReCallPanel = nil
UIWorldMap.AnswerId = 0
function UIWorldMap:OpenReCallPanel(_CallId)
   if UIWorldMap.ReCallPanel == nil then
      UIWorldMap.ReCallPanel = UIWorldMap.UIWorldMapGob.transform:FindChild("ReCallPanel")
   end
   UIWorldMap.ReCallPanel.gameObject:SetActive(true)
   UIWorldMap.AnswerId = _CallId
   this:SetReCallInfo(_CallId)
end

function UIWorldMap:SetReCallInfo(_CallId)
   local _City = WorldMapSys.FindCityNodeById(WorldMapEventSys.CallEventList[(_CallId)].RoomId)
   UIWorldMap.ReCallPanel.transform:FindChild("ReCallCity"):FindChild("CityName"):GetComponent("UILabel").text = _City.CityName
end

function UIWorldMap:CloseReCallPanel()

   if UIWorldMap.ReCallPanel~=nil then
      UIWorldMap.ReCallPanel.gameObject:SetActive(false)
   end
end

function UIWorldMap:AnswerCallEvent()
   this:CloseReCallPanel()
   WorldMapSocketSys.SendRequestCallFriend(2 , UIWorldMap.AnswerId)
end

function UIWorldMap:AnswerCallEventCallBack()

end

function UIWorldMap:BackChose()                                                 --返回主城
   TimeControl.LoginTime(2 , "GoInWorld")
   UIWorldMap.UIWorldMapGob.gameObject:SetActive(false)
   GameMain.WorldMapSys.gameObject:SetActive(false)  
   this:ReleaseTempEventTip()
   local UIControlTar = MainGameUI.FindPanelTarget("UIControl")
   if UIControlTar~=nil then
      UIControlTar:SetOutSideUIList(true)
      UIControlTar:SetAnchorTopLeft(true)
      UIControlTar:SetAnchorTop(true)
   end
   if UIWorldMap.DeadManImg~=nil then
      UIWorldMap.DeadManImg.transform.localPosition = Vector3(100000 , 0 , 0)
   end
   SocketClient.DisConnect()
   PlayerControl.Release()
   WorldMapEventSys.Release()
   PlayerControl.TheMeCharacter:ClearMe()
   HeartJump.SendHeartJump()
   MusicManagerSys.CastleMusic()
end

function UIWorldMap:UIOnPress(_LuaName , _Gob , _ispress)
    
end

function UIWorldMap:UIDragEvent(_LuaName , _Gob , _Detal)
     if _Gob.name == "MoveBOX" then
        UIWorldMap.X = _Detal.x * 2
        UIWorldMap.Y = _Detal.y * 2
        UIWorldMap.EndX = PlayerControl.MainCameraTransform.localPosition.x - UIWorldMap.X
        UIWorldMap.EndZ = PlayerControl.MainCameraTransform.localPosition.z - UIWorldMap.Y

        if UIWorldMap.EndX <= 806 then
           UIWorldMap.EndX = 806
        elseif  UIWorldMap.EndX >= 5712 then
           UIWorldMap.EndX = 5712
        end

        if UIWorldMap.EndZ <= 500 then
           UIWorldMap.EndZ = 500
        elseif UIWorldMap.EndZ >= 4627 then
           UIWorldMap.EndZ = 4627
        end
        PlayerControl.MainCameraTransform.localPosition = Vector3(UIWorldMap.EndX  , 500 , UIWorldMap.EndZ)
        this:SetCameraTarPos()
     end


end


UIWorldMap.ChoseCityNode = nil
UIWorldMap.CityInfoPanel = nil
UIWorldMap.CityOwnership = nil
UIWorldMap.DefencePeople = nil
UIWorldMap.AttackPeople = nil
UIWorldMap.CityName = nil
UIWorldMap.AttackPanel = nil
UIWorldMap.PeacePanel = nil
UIWorldMap.AttackShu = nil
UIWorldMap.AttackWei = nil
UIWorldMap.AttackWu = nil
UIWorldMap.AttackMid = nil
UIWorldMap.DefenceShu = nil
UIWorldMap.DefenceWei = nil
UIWorldMap.DefenceWu = nil
UIWorldMap.DefenceMid = nil
function UIWorldMap:OpenCityInfoPanel(_CityGob)
    local NodeId = tonumber(_CityGob.name)
    local TempNode = WorldMapSys.CityNodes[NodeId]

    if TempNode.CityType==2 then
       return
    end

    if UIWorldMap.BackState==true then                      --撤退状态
       UIWorldMap.BackState = false
       if UIWorldMap.TempBackCitys[NodeId]~=nil then        --是撤退城池中的一个
          WorldMapSocketSys.SendRequestBack(NodeId)
          for key , value in pairs(UIWorldMap.TempBackCitys) do
              local _TCity = WorldMapSys.CityNodes[value]
              _TCity:SetCanMove(false)
          end
          UIWorldMap.TempBackCitys = {}
       else
          for key , value in pairs(UIWorldMap.TempBackCitys) do
              local _TCity = WorldMapSys.CityNodes[value]
              _TCity:SetCanMove(false)
          end
          UIWorldMap.TempBackCitys = {}
       end
       return
    end

    if UIWorldMap.AttackState==true then                      --突进状态
       UIWorldMap.AttackState = false
       if UIWorldMap.TempGoAttackCitys[NodeId]~=nil then        --是突进城池中的一个
          WorldMapSocketSys.SendRequestGoAttack(NodeId)
          for key , value in pairs(UIWorldMap.TempGoAttackCitys) do
              local _TCity = WorldMapSys.CityNodes[value]
              _TCity:SetCanMove(false)
          end
          UIWorldMap.TempGoAttackCitys = {}
       else
          for key , value in pairs(UIWorldMap.TempGoAttackCitys) do
              local _TCity = WorldMapSys.CityNodes[value]
              _TCity:SetCanMove(false)
          end
          UIWorldMap.TempGoAttackCitys = {}
       end
       return
    end

    if UIWorldMap.CityInfoPanel == nil then
       UIWorldMap.CityInfoPanel = UIWorldMap.UIWorldMapGob.transform:FindChild("CityInfoPanel")
    end
    if UIWorldMap.CityOwnership==nil then
       UIWorldMap.CityOwnership = UIWorldMap.CityInfoPanel:FindChild("CityType"):FindChild("CityType"):GetComponent("UILabel")
    end
    if UIWorldMap.DefencePeople==nil then
       UIWorldMap.DefencePeople = UIWorldMap.CityInfoPanel:FindChild("CityPeople"):FindChild("CityNum"):GetComponent("UILabel")
    end
    if UIWorldMap.AttackPeople==nil then
       UIWorldMap.AttackPeople = UIWorldMap.CityInfoPanel:FindChild("AttackPeople"):FindChild("AttackNum"):GetComponent("UILabel")
    end
    if UIWorldMap.CityName == nil then
       UIWorldMap.CityName = UIWorldMap.CityInfoPanel:FindChild("CityInfo"):FindChild("CityName"):GetComponent("UILabel")
    end

    if UIWorldMap.AttackPanel == nil then
       UIWorldMap.AttackPanel = UIWorldMap.CityInfoPanel:FindChild("AttackPanel")
       UIWorldMap.AttackShu = UIWorldMap.AttackPanel.transform:FindChild("AttackPeople"):FindChild("Shu")
       UIWorldMap.AttackWei = UIWorldMap.AttackPanel.transform:FindChild("AttackPeople"):FindChild("Wei")
       UIWorldMap.AttackWu = UIWorldMap.AttackPanel.transform:FindChild("AttackPeople"):FindChild("Wu")
       UIWorldMap.AttackMid = UIWorldMap.AttackPanel.transform:FindChild("AttackPeople"):FindChild("ZhongLi")

       UIWorldMap.DefenceShu = UIWorldMap.AttackPanel.transform:FindChild("DefencePeople"):FindChild("Shu")
       UIWorldMap.DefenceWei = UIWorldMap.AttackPanel.transform:FindChild("DefencePeople"):FindChild("Wei")
       UIWorldMap.DefenceWu = UIWorldMap.AttackPanel.transform:FindChild("DefencePeople"):FindChild("Wu")
       UIWorldMap.DefenceMid = UIWorldMap.AttackPanel.transform:FindChild("DefencePeople"):FindChild("ZhongLi")
    end

    if UIWorldMap.PeacePanel ==nil then
       UIWorldMap.PeacePanel = UIWorldMap.CityInfoPanel:FindChild("PeacePanel")       
    end


    if TempNode.CityState == "Idle" then
       UIWorldMap.CityInfoPanel.transform:FindChild("ButtonList").gameObject:SetActive(false)
       UIWorldMap.CityInfoPanel.transform:FindChild("IdleButton").gameObject:SetActive(true)
       UIWorldMap.CityInfoPanel.transform:FindChild("IdleAndSeeButton").gameObject:SetActive(false)
    elseif TempNode.CityState == "Fight" and PlayerControl.TheMeCharacter.NowNode.NodeId == TempNode.NodeId then        --战斗城池 是我所在的城池
       UIWorldMap.CityInfoPanel.transform:FindChild("ButtonList").gameObject:SetActive(true)
       UIWorldMap.CityInfoPanel.transform:FindChild("ButtonList").transform:FindChild("JieBingButton"):FindChild("Move"):GetComponent("UILabel").text = UIstring.HireArmy.."("..tostring(UIWorldMap.HireCount)..")"
       UIWorldMap.CityInfoPanel.transform:FindChild("IdleButton").gameObject:SetActive(false)
       UIWorldMap.CityInfoPanel.transform:FindChild("IdleAndSeeButton").gameObject:SetActive(false)
    elseif TempNode.CityState == "Fight" and PlayerControl.TheMeCharacter.NowNode.NodeId ~= TempNode.NodeId then        --战斗城池 不是我所在的城池
       UIWorldMap.CityInfoPanel.transform:FindChild("ButtonList").gameObject:SetActive(false)
       UIWorldMap.CityInfoPanel.transform:FindChild("IdleButton").gameObject:SetActive(false)
       UIWorldMap.CityInfoPanel.transform:FindChild("IdleAndSeeButton").gameObject:SetActive(true)
    end

    UIWorldMap.ChoseCityNode = TempNode

    if TempNode.CityState == "Idle" then             --和平城池
       UIWorldMap.AttackPanel.gameObject:SetActive(false)
       UIWorldMap.PeacePanel.gameObject:SetActive(true)
    elseif TempNode.CityState == "Fight" then        --战斗城池     
       UIWorldMap.AttackPanel.gameObject:SetActive(true)
       UIWorldMap.PeacePanel.gameObject:SetActive(false)
       this:SetCityCountry(UIWorldMap.ChoseCityNode.AttackShuNum , UIWorldMap.AttackShu)
       this:SetCityCountry(UIWorldMap.ChoseCityNode.AttackWeiNum , UIWorldMap.AttackWei)
       this:SetCityCountry(UIWorldMap.ChoseCityNode.AttackWuNum , UIWorldMap.AttackWu)
       this:SetCityCountry(UIWorldMap.ChoseCityNode.AttackMidNum , UIWorldMap.AttackMid)
       this:SetCityCountry(UIWorldMap.ChoseCityNode.DefenceShuNum , UIWorldMap.DefenceShu)
       this:SetCityCountry(UIWorldMap.ChoseCityNode.DefenceWeiNum , UIWorldMap.DefenceWei)
       this:SetCityCountry(UIWorldMap.ChoseCityNode.DefenceWuNum , UIWorldMap.DefenceWu)
       this:SetCityCountry(UIWorldMap.ChoseCityNode.DefenceMidNum , UIWorldMap.DefenceMid)
    end

    UIWorldMap.CityInfoPanel.gameObject:SetActive(true)
    

    UIWorldMap.CityOwnership.text = UIWorldMap.ChoseCityNode.OwnerShipNameNow
    UIWorldMap.DefencePeople.text = tostring(UIWorldMap.ChoseCityNode.DefenceNum)
    UIWorldMap.AttackPeople.text = tostring(UIWorldMap.ChoseCityNode.AttackNum)
    UIWorldMap.CityName.text = tostring(UIWorldMap.ChoseCityNode.CityName)
end

function UIWorldMap:SetCityCountry(_Num  , _Gob)
   if _Num >0 then
      _Gob.gameObject:SetActive(true)
      _Gob.transform:FindChild("CityNum"):GetComponent("UILabel").text = tostring(_Num)      
   else
      _Gob.gameObject:SetActive(false)
   end
end

function UIWorldMap:CloseCityInfoPanel()
   if UIWorldMap.CityInfoPanel~=nil then
      UIWorldMap.CityInfoPanel.gameObject:SetActive(false)
   end
end

--*****************世界物品掉落 
UIWorldMap.RewardCity = nil
function UIWorldMap:RewardOnCity()                    --道具下发在哪个城池
   local _TempCity = WorldMapSys.FindCityNodeById(WorldMapEventSys.RewardCity.RewardCityId)
  -- GameMain.Print(WorldMapEventSys.RewardCity)
   UIWorldMap.RewardCity = _TempCity
   this:SetRewardOnCity()
end

UIWorldMap.RewardImg = nil
UIWorldMap.RewardLeftTime = nil
function UIWorldMap:SetRewardOnCity()
   if UIWorldMap.RewardImg==nil then
      UIWorldMap.RewardImg = UIWorldMap.UIWorldMapGob.transform:FindChild("SkyRewardAnchor"):FindChild("SkyRewardOnCity")
   end
   if UIWorldMap.RewardLeftTime==nil then
      UIWorldMap.RewardLeftTime = UIWorldMap.UIWorldMapGob.transform:FindChild("SkyRewardAnchor"):FindChild("SkyRewardOnCity"):FindChild("Time"):GetComponent("UILabel")
      UIWorldMap.RewardLeftTime.text = "00:05:00"
   end
   UIWorldMap.RewardPosition = UIWorldMap.RewardCity.Pos
   GameMain.AddUpdateLua(this.UpdateRewardPosition)
end

function UIWorldMap:HideRewardImg()                                                                     --物品消失
   GameMain.DelUpdateLua(this.UpdateRewardPosition)
   if UIWorldMap.RewardImg~=nil then
      UIWorldMap.RewardImg.transform.localPosition = Vector3(100000 , 0 , 0)
   end
end

--****************刷新位置 倒计时
UIWorldMap.UICamera = nil
UIWorldMap.RewardPosition = nil
function UIWorldMap:UpdateRewardPosition()                                                              --道具处在哪个城池
   if PlayerControl.MainCityCamera~=nil and UIWorldMap.UICamera~=nil and UIWorldMap.RewardImg~=nil then
       local _ScreenPosition = PlayerControl.MainCityCamera:WorldToScreenPoint(UIWorldMap.RewardPosition )
       local _ttt = Vector3(_ScreenPosition.x , _ScreenPosition.y , 0)
       local _TarPos = UIWorldMap.UICamera:ScreenToWorldPoint(_ttt)
       UIWorldMap.RewardImg.position = Vector3(_TarPos.x , _TarPos.y + 0.1 , _TarPos.z)
   end
end

function UIWorldMap:UpdateRewardLeftTime()
   if UIWorldMap.RewardLeftTime~=nil  then                                 --天降祥瑞活动结束领奖倒计时
      local _LeftTime = TimeControl.GetTime("WorldMapRewardLeftTime")
      UIWorldMap.RewardLeftTime.text = TimeControl.GetTimeString(_LeftTime)
      if _LeftTime<=0 then
         WorldMapEventSys.EndActivity()
         this:SetActivityTitle(UIstring.WorldActivity)
         this:HideRewardImg()
         GameMain.DelUpdateLua(this.UpdateRewardLeftTime)
         return
      end
      if WorldMapEventSys.IsGetWinReward==1 then
         this:HideRewardImg()
         GameMain.DelUpdateLua(this.UpdateRewardLeftTime)
      end
   end
end

function UIWorldMap:UpdateDeadManPos()
   if UIWorldMap.DeadManImg ~=nil then
      if PlayerControl.MainCityCamera~=nil and UIWorldMap.UICamera~=nil and UIWorldMap.DeadCity~=nil then
         local _ScreenPosition = PlayerControl.MainCityCamera:WorldToScreenPoint(UIWorldMap.DeadCity.Pos)
         local _ttt = Vector3(_ScreenPosition.x , _ScreenPosition.y , 0)
         local _TarPos = UIWorldMap.UICamera:ScreenToWorldPoint(_ttt)
         UIWorldMap.DeadManImg.position = Vector3(_TarPos.x , _TarPos.y + 0.1 , _TarPos.z)
      end
   end
end

function UIWorldMap:UpdateDeamMainLeftTime()                               --始皇降临结束倒计时领奖
   if UIWorldMap.WorldActivity~=nil then
      local _LeftTime = TimeControl.GetTime("DeadManLeftTime")
      UIWorldMap.WorldActivity.text = TimeControl.GetTimeString(_LeftTime)
      if _LeftTime<=0 then
         WorldMapEventSys.EndActivity()
         this:SetActivityTitle(UIstring.WorldActivity)
         GameMain.DelUpdateLua(this.UpdateDeamMainLeftTime)
      end
   end
end


function UIWorldMap:UpdateYellowManLeftTime()                               --始皇降临结束倒计时领奖
   if UIWorldMap.WorldActivity~=nil then
      local _LeftTime = TimeControl.GetTime("YellowManLeftTime")
      UIWorldMap.WorldActivity.text = TimeControl.GetTimeString(_LeftTime)
      if _LeftTime<=0 then
         WorldMapEventSys.EndActivity()
         this:SetActivityTitle(UIstring.WorldActivity)
         GameMain.DelUpdateLua(this.UpdateYellowManLeftTime)
      end
   end
end

function UIWorldMap:DeleteAllLeftTimeUpdate()                               --撤销所有非物品的倒计时
   GameMain.DelUpdateLua(this.UpdateRewardLeftTime)
   GameMain.DelUpdateLua(this.UpdateDeamMainLeftTime)
   GameMain.DelUpdateLua(this.UpdateYellowManLeftTime) 
end

UIWorldMap.WorldActivity = nil
function UIWorldMap:SetActivityTitle(_ActivityName)                                         --设置活动名字
   if UIWorldMap.WorldActivity == nil then
      UIWorldMap.WorldActivity = UIWorldMap.UIWorldMapGob.transform:FindChild("WorldActivity"):FindChild("Title"):GetComponent("UILabel")
   end
   UIWorldMap.WorldActivity.text = _ActivityName
end




UIWorldMap.RewardFromSkyPanel = nil
function UIWorldMap:OpenRewardFromSkyPanel()
   if UIWorldMap.RewardFromSkyPanel == nil then
      UIWorldMap.RewardFromSkyPanel = UIWorldMap.UIWorldMapGob.transform:FindChild("RewardFromSkyPanel")
   end

   if PlayerControl.TheMeCharacter.NowNode.NodeId == UIWorldMap.RewardCity.NodeId then              --已经到达这个点了
      UIWorldMap.RewardFromSkyPanel.transform:FindChild("MoveButtonRFS").gameObject:SetActive(false)
      UIWorldMap.RewardFromSkyPanel.transform:FindChild("GetRewardRFS").gameObject:SetActive(true)
   else                                                                                             --还没有到达这个点
      UIWorldMap.RewardFromSkyPanel.transform:FindChild("MoveButtonRFS").gameObject:SetActive(true)
      UIWorldMap.RewardFromSkyPanel.transform:FindChild("GetRewardRFS").gameObject:SetActive(false)
      UIWorldMap.ChoseCityNode = UIWorldMap.RewardCity
   end
   if WorldMapEventSys.EventData~=nil then
      
      --UIWorldMap.RewardFromSkyPanel.transform:FindChild("RewardFromSky"):FindChild("Title2"):GetComponent("UILabel").text =  WorldMapEventSys.EventData.Description 
       local t = tonumber(os.date("%w"))
     -- Debug.LogError(t)
      if t==2 or t == 4 or t==6 then
         --UIWorldMap.TimeRule.text = "15:10~15:30"
         UIWorldMap.RewardFromSkyPanel.transform:FindChild("RewardFromSky"):FindChild("Title2"):GetComponent("UILabel").text =  "宝箱在20:40之后可以领取。,只存在五分钟哦请抓紧时间。"
      end
      if t==0 or t == 1 or t==3 or t==5 then
         --UIWorldMap.TimeRule.text = "20:00~20:30"
         UIWorldMap.RewardFromSkyPanel.transform:FindChild("RewardFromSky"):FindChild("Title2"):GetComponent("UILabel").text =  "宝箱在15:40之后可以领取。,只存在五分钟哦请抓紧时间。"
      end
   end
   UIWorldMap.RewardFromSkyPanel.gameObject:SetActive(true)
end


function UIWorldMap:GetWinReward()                                                               --领取胜利奖励 天降祥瑞是胜利奖励
   WorldMapSocketSys.SendRequestGetReward(WorldMapEventSys.EventConfigID , 1 , 0)
   this:CloseRewardFromSky()
end

function UIWorldMap:GetOtherReward()                                                             --领取其他奖励
   WorldMapSocketSys.SendRequestGetReward(WorldMapEventSys.EventConfigID , 2 , 0)
end

function UIWorldMap:GetEventReward()                                                             --领取事件奖励道具 
   if UIWorldMap.TempEvent.TempEventConfigID==203 then
      this:OpenDrawRewardPanel()
      return
   end
   WorldMapSocketSys.SendRequestGetReward(201 , 3 , UIWorldMap.TempEvent.TempEventConfigID)
   this:CloseTempEventPanel()
end

function UIWorldMap:GetDrawReward()
   WorldMapSocketSys.SendRequestGetReward(201 , 3 , UIWorldMap.TempEvent.TempEventConfigID)
end

function UIWorldMap:DrawEventReward()                                                            --抽奖
   this:OpenDrawRewardPanel()
   this:CloseTempEventPanel()
end

function UIWorldMap:CloseRewardFromSky()
   if UIWorldMap.RewardFromSkyPanel~=nil  then
      UIWorldMap.RewardFromSkyPanel.gameObject:SetActive(false)
   end
end



UIWorldMap.DeadManPanel = nil
UIWorldMap.DeadManTimeRule = nil
UIWorldMap.DeadManDesRule = nil
function UIWorldMap:OpenDeadManPanel()                  --打开始皇降临
   if UIWorldMap.DeadManPanel == nil then
      UIWorldMap.DeadManPanel = UIWorldMap.UIWorldMapGob.transform:FindChild("DeadManPanel")
      UIWorldMap.DeadManTimeRule = UIWorldMap.DeadManPanel.transform:FindChild("ActivityRules"):FindChild("TimeRule"):GetComponent("UILabel")
      UIWorldMap.DeadManTimeRule.text = "12:10~12:30"
      UIWorldMap.DeadManDesRule = UIWorldMap.DeadManPanel.transform:FindChild("ActivityRules"):FindChild("ActRule"):GetComponent("UILabel")
      UIWorldMap.DeadManDesRule.text = UIstring.SHJLDIS
   end
   UIWorldMap.DeadManPanel.transform:FindChild("MyRank"):FindChild("Rank"):GetComponent("UILabel").text = tostring(WorldMapEventSys.MyRank)
   this:SetQuestionPanel(UIstring.SHJLDIS)
   UIWorldMap.DeadManPanel.gameObject:SetActive(true)   
end


function UIWorldMap:CloseDeadManPanel()
   if UIWorldMap.DeadManPanel~=nil then
      UIWorldMap.DeadManPanel.gameObject:SetActive(false)
   end
end


UIWorldMap.YellowManPanel = nil
UIWorldMap.TimeRule = nil
UIWorldMap.DesRule = nil
UIWorldMap.LeftCity = nil
function UIWorldMap:OpenYellowManPanel()                 --打开黄巾界面
   if UIWorldMap.YellowManPanel==nil then
      UIWorldMap.YellowManPanel = UIWorldMap.UIWorldMapGob.transform:FindChild("YellowManPanel")
   end
   if UIWorldMap.TimeRule==nil then
      UIWorldMap.TimeRule = UIWorldMap.YellowManPanel.transform:FindChild("ActivityRules"):FindChild("TimeRule"):GetComponent("UILabel")
      local t = tonumber(os.date("%w"))
     -- Debug.LogError(t)
      if t==2 or t == 4 or t==6 then
         UIWorldMap.TimeRule.text = "15:10~15:30"
      end
      if t==0 or t == 1 or t==3 or t==5 then
         UIWorldMap.TimeRule.text = "20:00~20:30"
      end
      UIWorldMap.DesRule = UIWorldMap.YellowManPanel.transform:FindChild("ActivityRules"):FindChild("ActRule"):GetComponent("UILabel")
      UIWorldMap.DesRule.text = UIstring.HJQYDIS
      UIWorldMap.LeftCity = UIWorldMap.YellowManPanel.transform:FindChild("LeftCity"):GetComponent("UILabel")
   end
   
   this:SetQuestionPanel(UIstring.HJQYDIS)
   UIWorldMap.YellowManPanel.gameObject:SetActive(true)

end


function UIWorldMap:SetYellowManScore()                  --设置黄巾界面三国积分
   if UIWorldMap.YellowManPanel==nil then
      UIWorldMap.YellowManPanel = UIWorldMap.UIWorldMapGob.transform:FindChild("YellowManPanel")
   end
   
   UIWorldMap.YellowManPanel:FindChild("Score"):FindChild("1"):FindChild("ScoreC"):GetComponent("UILabel").text = tostring(WorldMapEventSys.ScoreRankList[1])
   UIWorldMap.YellowManPanel:FindChild("Score"):FindChild("1"):FindChild("ScoreImg"):GetComponent("UISprite").fillAmount = WorldMapEventSys.ScoreRankList[1]/800
   UIWorldMap.YellowManPanel:FindChild("Score"):FindChild("2"):FindChild("ScoreC"):GetComponent("UILabel").text = tostring(WorldMapEventSys.ScoreRankList[2])
   UIWorldMap.YellowManPanel:FindChild("Score"):FindChild("2"):FindChild("ScoreImg"):GetComponent("UISprite").fillAmount = WorldMapEventSys.ScoreRankList[2]/800
   UIWorldMap.YellowManPanel:FindChild("Score"):FindChild("3"):FindChild("ScoreC"):GetComponent("UILabel").text = tostring(WorldMapEventSys.ScoreRankList[3])
   UIWorldMap.YellowManPanel:FindChild("Score"):FindChild("3"):FindChild("ScoreImg"):GetComponent("UISprite").fillAmount = WorldMapEventSys.ScoreRankList[3]/800
   UIWorldMap.YellowManPanel:FindChild("LeftCity"):GetComponent("UILabel").text = tostring(WorldMapEventSys.LeftCityNum)..UIstring.YellowLeftCity
end

function UIWorldMap:GetYellowCityNum()
   local _Count = 0
   for key , value in pairs(WorldMapSys.CityNodes) do
       if value.OwnerShipNow==4 then
          _Count = _Count + 1
       end
   end
   return _Count
end

function UIWorldMap:CloseYellowManPanel()
   if UIWorldMap.YellowManPanel~=nil then
      UIWorldMap.YellowManPanel.gameObject:SetActive(false)
   end
end


UIWorldMap.SouthManPanel = nil
function UIWorldMap:OpenSouthManPanel()                                     --打开南蛮入侵
   if UIWorldMap.SouthManPanel==nil then
      UIWorldMap.SouthManPanel = UIWorldMap.UIWorldMapGob.transform:FindChild("SouthManPanel")
   end
   UIWorldMap.SouthManPanel.gameObject:SetActive(true)
end

function UIWorldMap:CloseSouthManPanel()
   if UIWorldMap.SouthManPanel~=nil then
      UIWorldMap.SouthManPanel.gameObject:SetActive(false)
   end
end

UIWorldMap.WorldFightPanel = nil
function UIWorldMap:OpenWorldFightPanel()
   if UIWorldMap.WorldFightPanel == nil then
      UIWorldMap.WorldFightPanel = UIWorldMap.UIWorldMapGob.transform:FindChild("WorldFightPanel")
   end
   UIWorldMap.WorldFightPanel.gameObject:SetActive(true)
   this:SetWorldFightPanel()
end

function UIWorldMap:SetWorldFightPanel()
   for i = 1 , 3 , 1 do
       if i==WorldMapEventSys.DefenceCity then
          UIWorldMap.WorldFightPanel.transform:FindChild("AttackCamp"):FindChild(tostring(i)).gameObject:SetActive(false)
       else
          UIWorldMap.WorldFightPanel.transform:FindChild("DefenceCamp"):FindChild(tostring(i)).gameObject:SetActive(false)
       end
   end
end

function UIWorldMap:CloseWorldFightPanel()
   if UIWorldMap.WorldFightPanel~=nil then
      UIWorldMap.WorldFightPanel.gameObject:SetActive(false)  
   end
end

UIWorldMap.OpenEvent = 
{    
}

UIWorldMap.CloseEvent = 
{    
}
function UIWorldMap:Open_CloseEvent(_IsOpen)
    UIWorldMap.OpenEvent = 
    {
         [1] = UIWorldMap.OpenDeadMan,--"屎黄降临",
         [2] = UIWorldMap.OpenSouthMan,--"南蛮",                                                           --南蛮入侵    
         [3] = UIWorldMap.OpenYellowMan,--"黄巾之乱",
         [4] = UIWorldMap.OpenRFS,--"天降祥瑞",                                                              --天降祥瑞
         [5] = UIWorldMap.OpenWorldFight,--"灭国战",
         [6] = UIWorldMap.OpenYellowMan,--"黄巾之乱",
         --[601] = UIWorldMap.OpenYellowAttack,--"黄巾乱入"
         --[701] = UIWorldMap.OpenFairy,--仙人指路
         [7] = UIWorldMap.OpenRFS,--"天降祥瑞", 
    }

    UIWorldMap.CloseEvent = 
    {
         [1] = UIWorldMap.CloseDeadMan,--"屎黄降临",
         [2] = UIWorldMap.CloseSouthMan,--"南蛮",                                                           --南蛮入侵    
         [3] = UIWorldMap.CloseYellowMan,--"黄巾之乱",
         [4] = UIWorldMap.CloseRFS,--"天降祥瑞",                                                              --天降祥瑞
         [5] = UIWorldMap.CloseWorldFight,--"灭国战",
         [6] = UIWorldMap.CloseYellowMan,--"黄巾之乱",
         [7] = UIWorldMap.CloseRFS,--"天降祥瑞",
         --[601] = UIWorldMap.CloseYellowAttack,--"关闭黄巾乱入"
         --[701] = UIWorldMap.CloseFairy,
    }

    if _IsOpen==1 then
       this:DeleteAllLeftTimeUpdate()
       UIWorldMap.OpenEvent[WorldMapEventSys.EventConfigID]()
    elseif _IsOpen==0 then
       UIWorldMap.CloseEvent[WorldMapEventSys.EventConfigID]()
    end
end

function UIWorldMap.OpenRFS()                   --天降祥瑞开启
   --GameMain.AddUpdateLua(this.UpdateRewardPosition)
end

function UIWorldMap.CloseRFS()                  --关闭天降祥瑞
   if UIWorldMap.RewardCity.OwnerShipNow ~= PlayerControl.TheMeCharacter.OwnerShip  then
      this:HideRewardImg()
    --  this:SetActivityTitle(UIstring.WorldActivity)
      return
   end
   local _LeftTime = WorldMapEventSys.RewardEndTime - ClinetInfomation.WorldTime
   TimeControl.LoginTime(_LeftTime , "WorldMapRewardLeftTime")
   GameMain.AddUpdateLua(this.UpdateRewardLeftTime)
end

UIWorldMap.DeadManImg = nil
UIWorldMap.DeadCity = nil
function UIWorldMap.OpenDeadMan()                   --开启始皇降临
   if UIWorldMap.DeadManImg==nil then
      UIWorldMap.DeadManImg = UIWorldMap.UIWorldMapGob.transform:FindChild("SkyRewardAnchor"):FindChild("DeadManImg").transform
   end
   UIWorldMap.DeadCity = WorldMapSys.FindCityNodeById(45040)
   GameMain.AddUpdateLua(this.UpdateDeadManPos)
end

function UIWorldMap.CloseDeadMan()                  --关闭屎黄降临
   local _LeftTime = WorldMapEventSys.RewardEndTime - ClinetInfomation.WorldTime
  -- Debug.LogError(_LeftTime)
   TimeControl.LoginTime(_LeftTime , "DeadManLeftTime")
   GameMain.AddUpdateLua(this.UpdateDeamMainLeftTime)
   GameMain.DelUpdateLua(this.UpdateDeadManPos)
   if UIWorldMap.DeadManImg~=nil then
      UIWorldMap.DeadManImg.transform.localPosition = Vector3(100000 , 0 , 0)
   end
end

function UIWorldMap.OpenYellowMan()                   --开启黄巾之乱

end

function UIWorldMap.CloseYellowMan()                  --关闭黄巾之乱
   local _LeftTime = WorldMapEventSys.RewardEndTime - ClinetInfomation.WorldTime
   Debug.LogError(_LeftTime)
   TimeControl.LoginTime(_LeftTime , "YellowManLeftTime")
   GameMain.AddUpdateLua(this.UpdateYellowManLeftTime)
end

function UIWorldMap.OpenSouthMan()                     --开启南蛮入侵

end

function UIWorldMap.CloseSouthMan()                    --关闭南蛮入侵

end

function UIWorldMap.OpenWorldFight()                     --开启灭国战

end

function UIWorldMap.CloseWorldFight()                    --关闭灭国战

end

function UIWorldMap.OpenYellowAttack()                  --开启黄巾乱入

end

function UIWorldMap.CloseYellowAttack()                --关闭黄巾乱入

end

function UIWorldMap.OpenFairy()                       --开启仙人指路

end

function UIWorldMap.CloseFairy()                      --关闭仙人指路

end


UIWorldMap.SetEvent = 
{
    
}
function UIWorldMap:SetActivity()                                               --点击独立的国战按钮
    UIWorldMap.SetEvent = 
    {
       [1] = UIWorldMap.SetDeadMan,--"屎黄降临",
       [2] = UIWorldMap.SetSouthMan,--"南蛮",                                                             
       [3] = UIWorldMap.SetYellowMan,--"黄巾之乱",
       [4] = UIWorldMap.SetRFS,--"天降祥瑞",                                                              
       [5] = UIWorldMap.SetWorldFight,--"灭国战",
       [6] = UIWorldMap.SetYellowMan,--"灭国战",
       --[601] = UIWorldMap.SetYellowAttack, --"黄巾乱入"
       [7] = UIWorldMap.SetRFS,--"天降祥瑞",   
    }
   if WorldMapEventSys.EventType==0  then
      return
   end
   UIWorldMap.SetEvent[WorldMapEventSys.EventConfigID]()
end

function UIWorldMap.SetRFS()
   local X , Z = this:JudgeCameraPosition(UIWorldMap.RewardCity.Pos.x , UIWorldMap.RewardCity.Pos.z)


 --[[  local X = PlayerControl.TheMeCharacter.PlayerTrans.localPosition.x
   local Z = PlayerControl.TheMeCharacter.PlayerTrans.localPosition.z
   if PlayerControl.TheMeCharacter.PlayerTrans.localPosition.x >=5712 then
      X = 5712 
   end
   if PlayerControl.TheMeCharacter.PlayerTrans.localPosition.x <=806 then 
      X = 806
   end
   if PlayerControl.TheMeCharacter.PlayerTrans.localPosition.z >= 4627 then
      Z = 4627
   end
   if PlayerControl.TheMeCharacter.PlayerTrans.localPosition.z <= 500 then
      Z = 500
   end--]]
   PlayerControl.MainCameraTransform.localPosition = Vector3(X , UIWorldMap.RewardCity.Pos.y , Z)
   this:SetCameraTarPos()
end

function UIWorldMap.SetDeadMan()
   local _LeftTime = TimeControl.GetTime("DeadManLeftTime")
   if _LeftTime~=nil and _LeftTime > 0 then
      this:WorldRankEvent(2)
      this:OpenDeadManPanel()
      return
   end

   local X , Z = this:JudgeCameraPosition(UIWorldMap.DeadCity.Pos.x , UIWorldMap.DeadCity.Pos.z)
   PlayerControl.MainCameraTransform.localPosition = Vector3(X , UIWorldMap.DeadCity.Pos.y , Z)
   this:SetCameraTarPos()
end

function UIWorldMap.SetYellowMan()
   this:WorldRankEvent(1)
   this:OpenYellowManPanel()
end

function UIWorldMap.SetSouthMan()
   --this:WorldRankEvent(2)
   --this:OpenSouthManPanel()
end

function UIWorldMap.SetWorldFight()
   --this:OpenWorldFightPanel()
end

function UIWorldMap.SetYellowAttack()

end




function UIWorldMap:WorldRankEvent(_Type)                                  --请求排行事件
   WorldMapSocketSys.SendRequestCityInfo(_Type)
end


UIWorldMap.TempEvents = {}
function UIWorldMap:SetTempEvent(_EventKey , _TempEvent)
   this:GetTempEventTipGob()
   this:GetMoveImg()

   UIWorldMap.TempEvents[_EventKey] = _TempEvent 
   this:SetTempEventTipGob(_EventKey , _TempEvent)
   this:SetTempEventImgGob(_EventKey , _TempEvent)
   --GameMain.Print(_TempEvent)
   local _Reward = _TempEvent.Reward[1]


   local _Sprite = UIWorldMap.TempEvents[_EventKey].RewardImg:FindChild("Img"):GetComponent("UISprite")
   AtlasMsg.SetAtlas(_Sprite , _Reward.AtlasName , _Reward.SpriteName)
   local _SpriteQ = UIWorldMap.TempEvents[_EventKey].RewardImg:FindChild("FG"):GetComponent("UISprite")
   AtlasMsg.SetAtlas(_SpriteQ , UIstring.QualityAtlasName , UIstring.ItemFg[_Reward.Quality])
   local _BG = UIWorldMap.TempEvents[_EventKey].RewardImg:FindChild("BG"):GetComponent("UISprite")
   AtlasMsg.SetAtlas(_BG , UIstring.QualityBGAtlasName , UIstring.ItemFg[_Reward.Quality])
   UIWorldMap.TempEvents[_EventKey].RewardImg.gameObject:SetActive(true)
   local _TempCity = WorldMapSys.FindCityNodeById(UIWorldMap.TempEvents[_EventKey].TempEventCityId)
   UIWorldMap.TempEvents[_EventKey].City = _TempCity
   this:SetEventRewardOnCity()
end

function UIWorldMap:SetEventRewardOnCity()
   GameMain.AddUpdateLua(this.UpdateEvetRewardPosition)
end

UIWorldMap.TempEventTip = {}
function UIWorldMap:GetTempEventTipGob()
   if #UIWorldMap.TempEventTip~=0 then     
      return
   end
   for i = 1 , 8 , 1 do
       if UIWorldMap.TempEventTip[i]==nil then
          UIWorldMap.TempEventTip[i] = {}
       end
       UIWorldMap.TempEventTip[i].Gob = UIWorldMap.UIWorldMapGob.transform:FindChild("ActivityList"):FindChild(tostring(i))
       UIWorldMap.TempEventTip[i].IsUse = false
   end
end

UIWorldMap.TempEventMoveImg = {}
function UIWorldMap:GetMoveImg()
   if #UIWorldMap.TempEventMoveImg~=0 then
      return
   end
   for i = 1 , 10 , 1 do
       if UIWorldMap.TempEventMoveImg[i]==nil then
          UIWorldMap.TempEventMoveImg[i] = {}
       end
       UIWorldMap.TempEventMoveImg[i].Gob = UIWorldMap.UIWorldMapGob.transform:FindChild("SkyRewardAnchor"):FindChild("TempEventReward"):FindChild(tostring(i))
       UIWorldMap.TempEventMoveImg[i].IsUse = false
   end
   
end

function UIWorldMap:SetTempEventTipGob(_EventKey , _TempEvent)
   for i = 1 , 8 , 1 do
       if UIWorldMap.TempEventTip[i].IsUse==false then          
          UIWorldMap.TempEventTip[i].IsUse = true        
          UIWorldMap.TempEventTip[i].Gob.transform.name = tostring(_EventKey)
          UIWorldMap.TempEventTip[i].Gob.transform:FindChild("Title"):GetComponent("UILabel").text = _TempEvent.TempEventData.EventName
          UIWorldMap.TempEventTip[i].Gob.gameObject:SetActive(true)
          UIWorldMap.UIWorldMapGob.transform:FindChild("ActivityList"):GetComponent("UIGrid").enabled = true
          UIWorldMap.UIWorldMapGob.transform:FindChild("ActivityList"):GetComponent("UIGrid"):Reposition()
          return
          
       end
   end

end

function UIWorldMap:SetTempEventImgGob(_EventKey , _TempEvent)
    
   for i = 1 , 10 , 1 do
       if UIWorldMap.TempEventMoveImg[i].IsUse==false then          
          UIWorldMap.TempEventMoveImg[i].IsUse = true
          UIWorldMap.TempEvents[_EventKey].RewardImg = UIWorldMap.TempEventMoveImg[i].Gob.transform
          UIWorldMap.TempEvents[_EventKey].RewardImg.transform.name = tostring(_EventKey)
          return
       end
   end

end

function UIWorldMap:ClickTempEventTip(_EventKey)
   if UIWorldMap.TempEvents[_EventKey]~=nil then
      local X , Z = this:JudgeCameraPosition(UIWorldMap.TempEvents[_EventKey].City.Pos.x , UIWorldMap.TempEvents[_EventKey].City.Pos.z)
      PlayerControl.MainCameraTransform.localPosition = Vector3(X , UIWorldMap.TempEvents[_EventKey].City.Pos.y , Z)
      this:SetCameraTarPos()
   end
end

function UIWorldMap:CancelTempEventTip(_EventKey)
  for i = 1 , 8 , 1 do
      if UIWorldMap.TempEventTip[i].IsUse==true then
         if UIWorldMap.TempEventTip[i].Gob.transform.name == tostring(_EventKey) then
            UIWorldMap.TempEventTip[i].IsUse = false
            UIWorldMap.TempEventTip[i].Gob.gameObject:SetActive(false)
            UIWorldMap.UIWorldMapGob.transform:FindChild("ActivityList"):GetComponent("UIGrid").enabled = true
            UIWorldMap.UIWorldMapGob.transform:FindChild("ActivityList"):GetComponent("UIGrid"):Reposition()        
         end        
      end
  end

  for i = 1 , 10 , 1 do
       if UIWorldMap.TempEventMoveImg[i].IsUse==true then                    
          if UIWorldMap.TempEventMoveImg[i].Gob.transform.name == tostring(_EventKey) then
             UIWorldMap.TempEventMoveImg[i].IsUse = false        
          end       
       end
   end
end



function UIWorldMap:ReleaseTempEventTip()
   for i = 1 , 8 , 1 do 
       if UIWorldMap.TempEventTip[i]~=nil then   
          UIWorldMap.TempEventTip[i].IsUse = false
          UIWorldMap.TempEventTip[i].Gob.gameObject:SetActive(false)  
       end     
   end

   for i = 1 , 10 , 1 do
       if UIWorldMap.TempEventMoveImg[i]~=nil then
        
           UIWorldMap.TempEventMoveImg[i].IsUse = false
           UIWorldMap.TempEventMoveImg[i].Gob.gameObject:SetActive(false) 
       end        
   end

end

function UIWorldMap:UpdateEvetRewardPosition()                                                              --道具处在哪个城池
   if PlayerControl.MainCityCamera~=nil and UIWorldMap.UICamera~=nil then
       for key , value in pairs(UIWorldMap.TempEvents) do
           if value.City~=nil and value.RewardImg~=nil then
              local _ScreenPosition = PlayerControl.MainCityCamera:WorldToScreenPoint(value.City.Pos)
              local _ttt = Vector3(_ScreenPosition.x , _ScreenPosition.y , 0)
              local _TarPos = UIWorldMap.UICamera:ScreenToWorldPoint(_ttt)
              value.RewardImg.position = Vector3(_TarPos.x , _TarPos.y + 0.1 , _TarPos.z)
           end
       end
   end
end

UIWorldMap.DrawRewardPanel = nil                                                                        --打开抽奖界面
function UIWorldMap:OpenDrawRewardPanel()
   if UIWorldMap.DrawRewardPanel==nil then
      UIWorldMap.DrawRewardPanel = UIWorldMap.UIWorldMapGob.transform:FindChild("DrawRewardPanel")
   end
   UIWorldMap.DrawRewardPanel.gameObject:SetActive(true)
   UIWorldMap.DrawRewardPanel:FindChild("Draw").gameObject:SetActive(true)
   this:SetDrawRewad()
   if UIWorldMap.TempChoseBG~=nil then
      UIWorldMap.TempChoseBG.gameObject:SetActive(false)
   end
   UIWorldMap.TempChoseBG = UIWorldMap.DrawItmes[1]:FindChild("ChoseBG")
   UIWorldMap.TempChoseBG.gameObject:SetActive(true)
end

UIWorldMap.DrawItmes = {}
function UIWorldMap:SetDrawRewad()
   if  #UIWorldMap.DrawItmes~=0 then
       return
   end

   local _DrawReward = UIWorldMap.TempEvents[tostring(203).."_"..tostring(PlayerControl.TheMeCharacter.NowNode.NodeId)].Reward
   --GameMain.Print(_DrawReward)
   for i = 1 , #_DrawReward , 1 do
       if UIWorldMap.DrawItmes[i]==nil then
          UIWorldMap.DrawItmes[i] = {}
       end
       UIWorldMap.DrawItmes[i] = UIWorldMap.DrawRewardPanel.transform:FindChild("DrawRewardPanel"):FindChild(tostring(i))
       local _Sprite = UIWorldMap.DrawItmes[i]:FindChild("Img"):GetComponent("UISprite")
       AtlasMsg.SetAtlas(_Sprite , _DrawReward[i].AtlasName , _DrawReward[i].SpriteName)
       local _SpriteQ = UIWorldMap.DrawItmes[i]:FindChild("FG"):GetComponent("UISprite")
       AtlasMsg.SetAtlas(_SpriteQ , UIstring.QualityAtlasName , UIstring.ItemFg[_DrawReward[i].Quality])
       local _SpriteB = UIWorldMap.DrawItmes[i]:FindChild("BG"):GetComponent("UISprite")
       AtlasMsg.SetAtlas(_SpriteB , UIstring.QualityBGAtlasName , UIstring.ItemFg[_DrawReward[i].Quality])
   end
end

UIWorldMap.TempChoseBG = nil
function UIWorldMap:StartDraw(_EventKey ,  _RewardId)                    --开始转盘
   if #UIWorldMap.DrawItmes==0  then
      return
   end
   UIWorldMap.DrawRewardPanel:FindChild("Draw").gameObject:SetActive(false)
   local _DrawReward = UIWorldMap.TempEvents[_EventKey].RewardsDataConfig

   local _Index = 0
   for i = 1 , #_DrawReward , 1 do
       if _DrawReward[i] == _RewardId then
          _Index = i
       end
   end   

   if _Index==0 then
      Debug.LogError(_RewardId)
      Debug.LogError("Bad Id")
      return 
   end

   UIWorldMap.TotalCount = #_DrawReward * 1 + _Index
   UIWorldMap.DrawNowTime = 0
   UIWorldMap.NowCount = 1
   UIWorldMap.Start = 1
   GameMain.AddUpdateLua(this.UpdateDrawReward)

end

UIWorldMap.ClickTime = 0.2
UIWorldMap.DrawNowTime = 0
UIWorldMap.Start = 0
UIWorldMap.NowCount = 0
UIWorldMap.TotalCount = 0
function UIWorldMap.UpdateDrawReward(dt)
    if UIWorldMap.Start == 1 then
       UIWorldMap.DrawNowTime = UIWorldMap.DrawNowTime + dt
       if UIWorldMap.DrawNowTime >= UIWorldMap.ClickTime then          
          if UIWorldMap.NowCount >= UIWorldMap.TotalCount then              --转圈结束
             UIWorldMap.Start = 0
             UIWorldMap.NowCount = 0
             UIWorldMap.TotalCount = 0
             UIWorldMap.DrawNowTime = 0
             GameMain.DelUpdateLua(this.UpdateDrawReward)
          else
             UIWorldMap.NowCount = UIWorldMap.NowCount + 1
             local _key = UIWorldMap.NowCount
             if _key > 8 then
                _key = UIWorldMap.NowCount - 8
             end
             if UIWorldMap.TempChoseBG~=nil then
                UIWorldMap.TempChoseBG.gameObject:SetActive(false)
             end
             UIWorldMap.TempChoseBG = UIWorldMap.DrawItmes[_key]:FindChild("ChoseBG")
             UIWorldMap.TempChoseBG.gameObject:SetActive(true)
             UIWorldMap.DrawNowTime = 0 
          end
       end
    end
end

function UIWorldMap:CloseDrawRewardPanel()
   if UIWorldMap.DrawRewardPanel~=nil then
      UIWorldMap.DrawRewardPanel.gameObject:SetActive(false)
      UIWorldMap.Start = 0
      UIWorldMap.NowCount = 0
      UIWorldMap.TotalCount = 0
      UIWorldMap.DrawNowTime = 0
      GameMain.DelUpdateLua(this.UpdateDrawReward)
   end
end

UIWorldMap.TempEvent = nil
UIWorldMap.TempEventPanel = nil
function UIWorldMap:OpenTempEventPanel(_EventKey)
   UIWorldMap.TempEvent = UIWorldMap.TempEvents[_EventKey]
   if UIWorldMap.TempEventPanel ==nil then
      UIWorldMap.TempEventPanel = UIWorldMap.UIWorldMapGob.transform:FindChild("TempEventPanel")  
   end  

   if PlayerControl.TheMeCharacter.NowNode.NodeId == UIWorldMap.TempEvent.City.NodeId then              --已经到达这个点了
      local _ConfigIds = GameMain.StringSplit(_EventKey , "_")
      local _ConfigId = tonumber(_ConfigIds[1])
      if _ConfigId==203 then                                                                            --特殊抽奖
         UIWorldMap.TempEventPanel.transform:FindChild("MoveButtonTempEvent").gameObject:SetActive(false)
         UIWorldMap.TempEventPanel.transform:FindChild("GetRewardTempEvent").gameObject:SetActive(false)
         UIWorldMap.TempEventPanel.transform:FindChild("DrawRewardTempEvent").gameObject:SetActive(true)   
      else
         UIWorldMap.TempEventPanel.transform:FindChild("MoveButtonTempEvent").gameObject:SetActive(false)
         UIWorldMap.TempEventPanel.transform:FindChild("GetRewardTempEvent").gameObject:SetActive(true)
         UIWorldMap.TempEventPanel.transform:FindChild("DrawRewardTempEvent").gameObject:SetActive(false)      
      end
   else                                                                                             --还没有到达这个点
      UIWorldMap.TempEventPanel.transform:FindChild("MoveButtonTempEvent").gameObject:SetActive(true)
      UIWorldMap.TempEventPanel.transform:FindChild("GetRewardTempEvent").gameObject:SetActive(false)
      UIWorldMap.TempEventPanel.transform:FindChild("DrawRewardTempEvent").gameObject:SetActive(false)  
      UIWorldMap.ChoseCityNode = UIWorldMap.TempEvent.City
   end

   UIWorldMap.TempEventPanel.gameObject:SetActive(true)
   this:SetTempEventPanel()
end

function UIWorldMap:SetTempEventPanel()
   local _Reward = UIWorldMap.TempEvent.Reward[1]
  -- GameMain.Print(_Reward)
   local _Sprite = UIWorldMap.TempEventPanel.transform:FindChild("Reward"):FindChild("Img"):GetComponent("UISprite")
   AtlasMsg.SetAtlas(_Sprite , _Reward.AtlasName , _Reward.SpriteName)
   local _SpriteQ = UIWorldMap.TempEventPanel.transform:FindChild("Reward"):FindChild("FG"):GetComponent("UISprite")
   AtlasMsg.SetAtlas(_SpriteQ , UIstring.QualityAtlasName , UIstring.ItemFg[_Reward.Quality])
   local _BG = UIWorldMap.TempEventPanel.transform:FindChild("Reward"):FindChild("BG"):GetComponent("UISprite")
   AtlasMsg.SetAtlas(_BG , UIstring.QualityBGAtlasName , UIstring.ItemFg[_Reward.Quality])   

   UIWorldMap.TempEventPanel.transform:FindChild("Reward"):FindChild("Count"):GetComponent("UILabel").text = tostring(_Reward.Count)
   UIWorldMap.TempEventPanel.transform:FindChild("TempEventDescrip"):FindChild("Title"):GetComponent("UILabel").text = UIWorldMap.TempEvent.TempEventData.Descrip1
   UIWorldMap.TempEventPanel.transform:FindChild("TempEventDescrip"):FindChild("Title2"):GetComponent("UILabel").text = UIWorldMap.TempEvent.TempEventData.Descrip2
end

function UIWorldMap:CloseTempEventPanel()
   if UIWorldMap.TempEventPanel~=nil then
      UIWorldMap.TempEventPanel.gameObject:SetActive(false)
   end
  -- UIWorldMap.TempEvent = nil
end

function UIWorldMap:HideTempEventReward(_EventKey)          --隐藏道具图标
   if UIWorldMap.TempEvents[_EventKey]~=nil and  UIWorldMap.TempEvents[_EventKey].RewardImg~=nil then
      local items = {}
      for i = 1 , #UIWorldMap.TempEvents[_EventKey].Reward , 1 do 
          table.insert(items , #items + 1 , UIWorldMap.TempEvents[_EventKey].Reward[i])
      end
      DataUIInstance.OpenRewards(items)
      UIWorldMap.TempEvents[_EventKey].RewardImg.gameObject:SetActive(false)
   end   
end


function UIWorldMap:DeleteTempEvent(_EventKey)                --删除事件
   this:HideTempEventReward(_EventKey)
   this:CancelTempEventTip(_EventKey)
   UIWorldMap.TempEvents[_EventKey] = nil
end


--*****************************
UIWorldMap.EmemyEvents = {}
UIWorldMap.EmemyEventGob = {}
function UIWorldMap:SetEmemyEvent(_EmemyEventId , _EmemyEvent)                          --设置特殊事件的城池上面的图标
   if _EmemyEvent.EmemyEventId==701 then
      UIWorldMap.UIWorldMapGob.transform:FindChild("ActivityList"):FindChild("Fairy").gameObject:SetActive(true)
      UIWorldMap.UIWorldMapGob.transform:FindChild("ActivityList"):GetComponent("UIGrid").enabled = true
      UIWorldMap.UIWorldMapGob.transform:FindChild("ActivityList"):GetComponent("UIGrid"):Reposition()
   end

   if _EmemyEvent.EmemyEventId==601 then                                                --黄巾乱入
      UIWorldMap.UIWorldMapGob.transform:FindChild("ActivityList"):FindChild("YellowAttack").gameObject:SetActive(true)
      UIWorldMap.UIWorldMapGob.transform:FindChild("ActivityList"):GetComponent("UIGrid").enabled = true
      UIWorldMap.UIWorldMapGob.transform:FindChild("ActivityList"):GetComponent("UIGrid"):Reposition()
   end

   UIWorldMap.EmemyEvents[_EmemyEventId] = _EmemyEvent

   local _TempCity = WorldMapSys.FindCityNodeById(_EmemyEvent.CityId)
   if UIWorldMap.EmemyEvents[_EmemyEventId]==nil then
      UIWorldMap.EmemyEvents[_EmemyEventId] = {}
   end
   UIWorldMap.EmemyEvents[_EmemyEventId] = 
   {
      EmemyEventData = _EmemyEvent.EmemyEventData,
      CityId = _EmemyEvent.CityId,
      Pos = _TempCity.Pos,
      LeftTime = _EmemyEvent.LeftTime,
   }
   if _EmemyEvent.LeftTime ~= 0 then
      TimeControl.LoginTime(_EmemyEvent.LeftTime , _EmemyEventId)
   end

   if UIWorldMap.EmemyEventGob[_EmemyEventId] == nil then
      local _father = UIWorldMap.UIWorldMapGob.transform:FindChild("SkyRewardAnchor"):FindChild("ImgOnCity")
      local data =
      {
         Index = _EmemyEventId,
      }
      if _EmemyEventId==701 then
         MainGameUI.CreateLittleItem(tostring(_EmemyEventId) , "Fairy" , _father , data , this.CreateEmemyEventCallBack , "UIWorldMap")
      elseif _EmemyEventId == 601 then
         MainGameUI.CreateLittleItem(tostring(_EmemyEventId) , "YellowImg" , _father , data , this.CreateEmemyEventCallBack , "UIWorldMap")
      end
   else
      UIWorldMap.EmemyEventGob[_EmemyEventId].Trans.gameObject:SetActive(true)
   end
 
   GameMain.AddUpdateLua(this.UpdateEmemy)
end

function UIWorldMap:CreateEmemyEventCallBack(_Gob , _Info)
   UIWorldMap.EmemyEventGob[_Info.Index] =
   {    
      Trans = _Gob.transform,
      Label = _Gob.transform:FindChild("Time"):GetComponent("UILabel")
   } 
end

function UIWorldMap:UpdateEmemy()
   for key , value in pairs(UIWorldMap.EmemyEvents) do
       if PlayerControl.MainCityCamera~=nil then
           local _ScreenPosition = PlayerControl.MainCityCamera:WorldToScreenPoint(value.Pos)
           local _ttt = Vector3(_ScreenPosition.x , _ScreenPosition.y , 0)
           local _TarPos = UIWorldMap.UICamera:ScreenToWorldPoint(_ttt)
           if UIWorldMap.EmemyEventGob[key]~=nil then
              UIWorldMap.EmemyEventGob[key].Trans.position = Vector3(_TarPos.x , _TarPos.y + 0.1 , _TarPos.z)
              local string = TimeControl.GetTimeString2(key)
              if string=="0" then
                 UIWorldMap.EmemyEventGob[key].Label.text = ""
              else
                 UIWorldMap.EmemyEventGob[key].Label.text = string
              end

              if key==701 then
                 if UIWorldMap.FairyTimeLabel~=nil then                   
                    UIWorldMap.FairyTimeLabel.text = string                    
                 end
              end
              local _Time = TimeControl.GetTime(key)
              if _Time~=nil then
                  if _Time <= 0 then         
                     UIWorldMap.UIWorldMapGob.transform:FindChild("ActivityList"):FindChild("Fairy").gameObject:SetActive(false)
                     UIWorldMap.UIWorldMapGob.transform:FindChild("ActivityList"):GetComponent("UIGrid").enabled = true
                     UIWorldMap.UIWorldMapGob.transform:FindChild("ActivityList"):GetComponent("UIGrid"):Reposition()
                     this:DelEmemyEvent(key)
                  end
              end
           end
       end
   end
end

function UIWorldMap:DelEmemyEvent(_EmemyEventId)
   UIWorldMap.EmemyEvents[_EmemyEventId] = nil
   UIWorldMap.EmemyEventGob[_EmemyEventId].Trans.gameObject:SetActive(false)

end

function UIWorldMap:ShowCityMember(_Type , _Room , _CB)                                         --查看某个城市的人员信息
   WorldMapSocketSys.SendRequestRoomMember(_Type , _Room , _CB)
end

function UIWorldMap:SetEmemyEventPanel(_EmemyEventId)
   if _EmemyEventId == 701 then
      this:ShowFairyInfo()
   elseif _EmemyEventId == 601 then
      this:ShowYellowAttack()
   end

end

function UIWorldMap:ShowFairyInfo()
   if UIWorldMap.EmemyEvents[701]~=nil then
      this:ShowCityMember(2 , UIWorldMap.EmemyEvents[701].CityId , this.OpenFairyPanel)
   end
end

function UIWorldMap:ShowYellowAttack()
   if UIWorldMap.EmemyEvents[601]~=nil then
      if UIWorldMap.TempEventPanel ==nil then
         UIWorldMap.TempEventPanel = UIWorldMap.UIWorldMapGob.transform:FindChild("TempEventPanel")  
      end

         UIWorldMap.TempEventPanel.transform:FindChild("MoveButtonTempEvent").gameObject:SetActive(true)
         UIWorldMap.TempEventPanel.transform:FindChild("GetRewardTempEvent").gameObject:SetActive(false)
         UIWorldMap.TempEventPanel.transform:FindChild("DrawRewardTempEvent").gameObject:SetActive(false)
         local _TempCity = WorldMapSys.FindCityNodeById(UIWorldMap.EmemyEvents[601].CityId)  
         UIWorldMap.ChoseCityNode = _TempCity
         UIWorldMap.TempEventPanel.gameObject:SetActive(true)
         UIWorldMap.TempEventPanel.transform:FindChild("TempEventDescrip"):FindChild("Title2"):GetComponent("UILabel").text = UIWorldMap.EmemyEvents[601].EmemyEventData.Description 
         UIWorldMap.TempEventPanel.transform:FindChild("TempEventDescrip"):FindChild("Title"):GetComponent("UILabel").text = UIWorldMap.EmemyEvents[601].EmemyEventData.Name 
         local _Img = UIWorldMap.TempEventPanel.transform:FindChild("Reward"):FindChild("Img"):GetComponent("UISprite")
         AtlasMsg.SetAtlas(_Img , "UI_Icon_Head" , "Icon_Hero_Head_41")
         local _Bg = UIWorldMap.TempEventPanel.transform:FindChild("Reward"):FindChild("BG"):GetComponent("UISprite")
         AtlasMsg.SetAtlas(_Bg , UIstring.QualityBGAtlasName , UIstring.ItemFg[6])
         local _Fg = UIWorldMap.TempEventPanel.transform:FindChild("Reward"):FindChild("FG"):GetComponent("UISprite")
         AtlasMsg.SetAtlas(_Fg , UIstring.QualityAtlasName , UIstring.ItemFg[6])
         UIWorldMap.TempEventPanel.transform:FindChild("Reward"):FindChild("Count"):GetComponent("UILabel").text = ""
   end
end


function UIWorldMap:SetCameraToFairy()                                           
   if PlayerControl.MainCameraTransform~=nil then
      if UIWorldMap.EmemyEvents[701]~=nil then
         PlayerControl.MainCameraTransform.localPosition = UIWorldMap.EmemyEvents[701].Pos
         this:SetCameraTarPos()
      end
   end
end

function UIWorldMap:SetCameraToYellowAttack()                                           
   if PlayerControl.MainCameraTransform~=nil then
      if UIWorldMap.EmemyEvents[601]~=nil then
         PlayerControl.MainCameraTransform.localPosition = UIWorldMap.EmemyEvents[601].Pos
         this:SetCameraTarPos()
      end
   end
end

UIWorldMap.FairyPanel = nil
UIWorldMap.FairyTimeLabel = nil
UIWorldMap.FairyTimeRule = nil
UIWorldMap.FairyDesRule = nil
function UIWorldMap.OpenFairyPanel(_data)                                                   --打开仙人指路界面
   if UIWorldMap.FairyPanel==nil then
      UIWorldMap.FairyPanel = UIWorldMap.UIWorldMapGob.transform:FindChild("FairyPanel")
      UIWorldMap.FairyTimeLabel = UIWorldMap.FairyPanel.transform:FindChild("TimeLeft"):FindChild("Time"):GetComponent("UILabel")
      UIWorldMap.FairyTimeRule = UIWorldMap.FairyPanel.transform:FindChild("FairyRules"):FindChild("TimeRule"):GetComponent("UILabel")
      UIWorldMap.FairyTimeRule.text = UIstring.XRZLTime
      UIWorldMap.FairyDesRule = UIWorldMap.FairyPanel.transform:FindChild("FairyRules"):FindChild("ActRule"):GetComponent("UILabel")
      UIWorldMap.FairyDesRule.text = UIstring.XRZLDIS
   end
   this:SetQuestionPanel(UIstring.XRZLDIS)
   UIWorldMap.FairyPanel.gameObject:SetActive(true)
   this:SetFairyPanel(_data)
end

UIWorldMap.MemberGobs = {}
function UIWorldMap:SetFairyPanel(_data)                                                    --设置仙人指路
   UIWorldMap.FairyPanel.transform:FindChild("TeamNumber"):FindChild("TeamNum"):GetComponent("UILabel").text = tostring(_data.TotoalNum).."/20"
   if #UIWorldMap.MemberGobs==0 then
      for i = 1 , 20 , 1 do
          UIWorldMap.MemberGobs[i] = UIWorldMap.FairyPanel.transform:FindChild("MembersPanel"):FindChild("Members"):FindChild(tostring(i))
          UIWorldMap.MemberGobs[i].gameObject:SetActive(false)
      end
   end
   for i = 1 , 20 , 1 do
       if i > _data.TotoalNum then
          UIWorldMap.MemberGobs[i].gameObject:SetActive(false)        
       else
          UIWorldMap.MemberGobs[i].gameObject:SetActive(true)
          
          UIWorldMap.MemberGobs[i].transform:FindChild("Name"):GetComponent("UILabel").text = "("..UIstring.Ownerships[tonumber(_data.MembersComp[i+3])]..")".._data.Members[i]
       end
   end
end

function UIWorldMap:CloseFairyPanel()
   UIWorldMap.FairyPanel.gameObject:SetActive(false)
end

function UIWorldMap:ReleaseUpdate()
   GameMain.DelUpdateLua(this.UpdateRewardLeftTime)
   GameMain.DelUpdateLua(this.UpdateDeamMainLeftTime)
   GameMain.DelUpdateLua(this.UpdateYellowManLeftTime) 
   GameMain.DelUpdateLua(this.UpdateEvetRewardPosition)
   GameMain.DelUpdateLua(this.UpdateDrawReward)
   GameMain.DelUpdateLua(this.UpdateEmemy)
   GameMain.DelUpdateLua(this.UpdateCallEventTime)
   GameMain.DelUpdateLua(this.UpdateDeadManPos)
end
   

function UIWorldMap:ReleasPanel()

    UIWorldMap.UIWorldMapGob = nil

    this:ReleaseUpdate()

    UIWorldMap.X = 0
    UIWorldMap.Y = 0
    UIWorldMap.EndX = 0
    UIWorldMap.EndZ = 0
    UIWorldMap.ArmyMoneyPanel = nil
    UIWorldMap.GloryPanel = nil
    UIWorldMap.GloryRankPanel=nil
    UIWorldMap.GloryRankList = {}

    UIWorldMap.TeamPanel = nil
    UIWorldMap.WorldHead = nil
    UIWorldMap.Country = nil
    UIWorldMap.Vip = nil
    UIWorldMap.VipFirst = nil

    UIWorldMap.AttackState = false
    UIWorldMap.TempGoAttackCitys = {}
    UIWorldMap.BackState = false
    UIWorldMap.TempBackCitys = {}

    UIWorldMap.CameraTar = nil

    UIWorldMap.WorldActivityPanel = nil
    UIWorldMap.GetRewardPanel = nil
    UIWorldMap.QuestionPanel = nil
    UIWorldMap.RuleText = nil
    UIWorldMap.RankPanel = nil

    UIWorldMap.CallItems = {}
    UIWorldMap.CallList = {}
    UIWorldMap.ReCallPanel = nil

    UIWorldMap.ChoseCityNode = nil
    UIWorldMap.CityInfoPanel = nil
    UIWorldMap.CityOwnership = nil
    UIWorldMap.DefencePeople = nil
    UIWorldMap.AttackPeople = nil
    UIWorldMap.CityName = nil

    UIWorldMap.AttackPanel = nil
    UIWorldMap.PeacePanel = nil
    UIWorldMap.AttackShu = nil
    UIWorldMap.AttackWei = nil
    UIWorldMap.AttackWu = nil
    UIWorldMap.AttackMid = nil
    UIWorldMap.DefenceShu = nil
    UIWorldMap.DefenceWei = nil
    UIWorldMap.DefenceWu = nil
    UIWorldMap.DefenceMid = nil

    UIWorldMap.RewardCity = nil
    UIWorldMap.RewardImg = nil
    UIWorldMap.RewardLeftTime = nil
    UIWorldMap.UICamera = nil
    UIWorldMap.RewardPosition = nil
    UIWorldMap.WorldActivity = nil
  
    UIWorldMap.RewardFromSkyPanel = nil
    UIWorldMap.DeadManPanel = nil
    UIWorldMap.DeadManTimeRule = nil
    UIWorldMap.DeadManDesRule = nil

    UIWorldMap.YellowManPanel = nil
    UIWorldMap.TimeRule = nil
    UIWorldMap.DesRule = nil
    UIWorldMap.LeftCity = nil

    UIWorldMap.DeadManImg = nil
    UIWorldMap.DeadCity = nil
    UIWorldMap.TempEvents = {}
    UIWorldMap.TempEventTip = {}
    UIWorldMap.TempEventMoveImg = {}
    UIWorldMap.TempEvent = nil
    UIWorldMap.TempEventPanel = nil
    UIWorldMap.EmemyEvents = {}
    UIWorldMap.EmemyEventGob = {}


    UIWorldMap.DrawRewardPanel = nil  
    UIWorldMap.DrawItmes = {}
    UIWorldMap.TempChoseBG = nil
    UIWorldMap.ClickTime = 0.5
    UIWorldMap.DrawNowTime = 0
    UIWorldMap.Start = 0
    UIWorldMap.NowCount = 0
    UIWorldMap.TotalCount = 0

    UIWorldMap.FairyPanel = nil
    UIWorldMap.FairyTimeLabel = nil
    UIWorldMap.FairyTimeRule = nil
    UIWorldMap.FairyDesRule = nil
    UIWorldMap.MemberGobs = {}
end

function UIWorldMap:InitPanel()
   TimeControl.LoginTime(2 , "GoInWorld")
   UIWorldMap.UIWorldMapGob.gameObject:SetActive(false)
   GameMain.WorldMapSys.gameObject:SetActive(false)  
   this:ReleaseTempEventTip()
   local UIControlTar = MainGameUI.FindPanelTarget("UIControl")
   if UIControlTar~=nil then
      UIControlTar:SetOutSideUIList(true)
      UIControlTar:SetAnchorTopLeft(true)
      UIControlTar:SetAnchorTop(true)
   end
   SocketClient.DisConnect()
   PlayerControl.Release()
   WorldMapEventSys.Release()
   PlayerControl.TheMeCharacter:ClearMe()
end

return UIWorldMap
