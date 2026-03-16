UIGuide = {}
local UIGuide = BasePanel:new()     
local this = UIGuide
UIGuide.UIGuideGob = nil                                        --总控制                        
UIGuide.Guide = nil                                             --大步骤GOb
UIGuide.TempStepGob = nil                                       --小步骤GOb                                 
UIGuide.GuideEventName = nil
UIGuide.GuideData = nil
UIGuide.TarPos = nil

function UIGuide:OpenUI(_PanelName , _LuaName)
    UIGuide.UIGuideGob = MainGameUI.FindPanel("UIGuide")
    UIGuide.UIGuideGob.gameObject:SetActive(true)
end

function UIGuide:UIHand(_LuaName , _Gob)
MusicManagerSys.ButtonClick()
    if _Gob.name == "chat" then
       this:GoToNextGuide()
       return
    end

    if _Gob.transform.parent==nil or _Gob.transform.parent.name ==nil then
       return
    end
    local _ParentName = _Gob.transform.parent.name
    
    if _ParentName=="UIGuide" or _ParentName=="Camera" then
       return
    end
    if _ParentName=="input" or _ParentName=="ModifyNamePanel" then
       return
    end

    if _Gob.name == "RandonButton" then
       UIGuide.Guide.transform:FindChild("ClickGetName"):FindChild("ModifyNamePanel"):FindChild("input/Label"):GetComponent("UIInput").value = ClinetSys.GetXing()..ClinetSys.GetMing()
       return
    end

    --**引导1
    if _ParentName == "ClickOneSoldier" then                              --出一个小兵
       GameMain.OutSoldier(1)
                                                     --解除暂停
       --this:GoToNextGuide()
    elseif _ParentName == "ClickOneSkill" then                                   --拖动技能演示
       --this:GoToNextGuide()
    end

    --**引导2
    if _ParentName == "ClickZhengZhan" then
       local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
       if _UIControlTar~=nil then 
          GameMain.SetBattleYindao()                 
          this:CloseGuide()
          this:GoToNextGuide()
          _UIControlTar:OpenZhengZhan()
          return
       end
       --this:GoToNextGuide()
    elseif _ParentName == "ClickRound" then

    elseif _ParentName == "ClickHumanNum" then
 
    elseif _ParentName == "ClickRoundSecond" then

    elseif _ParentName == "ClickOnePic" then
       
    elseif _ParentName == "ClickTwoPic" then

    elseif _ParentName == "ClickThreePic" then

    elseif _ParentName == "ClickFourPic" then

   --[[ elseif _ParentName == "ClickOneSoldier" then
        GameMain.OutSoldier(1)--]]
    elseif _ParentName == "ClickTwoSoldier" then
        GameMain.OutSoldier(2)
        GameMain.StartBattleGame() 
    elseif _ParentName == "ClickThreeSoldier" then
        GameMain.OutSoldier(3)
        GameMain.StartBattleGame() 
    end

    --**引导3
    if _ParentName == "ClickZhaoMu" then
       local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
       if _UIControlTar~=nil then
          DataUIInstance.OpenHireHero(this.GoToNextGuide)
       end
       return

    elseif _ParentName == "ClickGetName" then
       local _Name = UIGuide.Guide.transform:FindChild("ClickGetName"):FindChild("ModifyNamePanel"):FindChild("input/Label"):GetComponent("UIInput").value
       local _Can = ClinetSys.JudgeName(_Name)
       if _Can==true then
          ClinetSys.CreateNameGuide(_Name , this.GoToNextGuide)
       else
          
       end
       return
    elseif _ParentName == "ClickDes" then

    elseif _ParentName == "ClickMidHire" then

       local _UIHireHero = MainGameUI.FindPanelTarget("UIHireHero")
       if _UIHireHero~=nil then
          _UIHireHero:HireHero(2)
       end

    elseif _ParentName == "ClickHireOneHero" then
       
       local _UIHireHero = MainGameUI.FindPanelTarget("UIHireHero")
       if _UIHireHero~=nil and _UIHireHero.HireHeroTempList[1]~=nil then                       
		 _UIHireHero:ShowClickHeroInfo(1)             				
	   end

    elseif _ParentName == "ClickHireHero" then

       local _UIHireHero = MainGameUI.FindPanelTarget("UIHireHero")
       if _UIHireHero~=nil then
          _UIHireHero:lotteryHero()
       end

    elseif _ParentName == "ClickHireTwoHero" then

       local _UIHireHero = MainGameUI.FindPanelTarget("UIHireHero")
       if _UIHireHero~=nil and _UIHireHero.HireHeroTempList[1]~=nil then                       
		 _UIHireHero:ShowClickHeroInfo(1)             				
	   end

    elseif _ParentName == "ClickHireThreeHero" then

       local _UIHireHero = MainGameUI.FindPanelTarget("UIHireHero")
       if _UIHireHero~=nil and _UIHireHero.HireHeroTempList[1]~=nil then                       
		 _UIHireHero:ShowClickHeroInfo(1)             				
	   end

    elseif _ParentName == "ClickCloseHirePanel" then

       local _UIHireHero = MainGameUI.FindPanelTarget("UIHireHero")
       if _UIHireHero~=nil then                       
		 _UIHireHero:CloseHireHeroInfoPanel()             				
	   end
    
    elseif _ParentName == "ClickHeroButton" then

       local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
       if _UIControlTar~=nil then
          DataUIInstance.OpenHeroInfo(this.GoToNextGuide)
       end
       return

    elseif _ParentName == "ClickOneHero" then

       local _UIHero = MainGameUI.FindPanelTarget("UIHero")
       if _UIHero~=nil and _UIHero.HeroList[1]~=nil then     
	      _UIHero:SendWebAboutEquip(1)    
       end

    elseif _ParentName == "ClickGoFight" then
       
       local _UIHero = MainGameUI.FindPanelTarget("UIHero")
       if _UIHero~=nil then     
	      _UIHero:ShowGoAtkInfo(2)    
       end

    elseif _ParentName == "ClickGoFightDes" then

    elseif _ParentName == "ClickTwoHero" then
       
       local _UIHero = MainGameUI.FindPanelTarget("UIHero")
       if _UIHero~=nil and _UIHero.HeroList[2]~=nil then     
	      _UIHero:SendWebAboutEquip(2)    
       end

    elseif _ParentName == "ClickCloseHeroPanel" then
       
       local _UIHero = MainGameUI.FindPanelTarget("UIHero")
       if _UIHero~=nil then     
	      _UIHero:CloseObj(UIHero.UIHeroGob.gameObject)
		
		  _UIHero:CloseSendWebEquip()
          TeamSys.SaveThePveTeam()    
       end

    elseif _ParentName == "ClickBattleOneHero" then 
        GameMain.OutHero(1)   
    elseif _ParentName == "ClickSkillDes" then

    end

    --*引导4
    if _ParentName == "ClickEquipPanel" then
        local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
       if _UIControlTar~=nil then
          DataUIInstance.OpenEquip(this.GoToNextGuide)
       end
       return
    elseif _ParentName == "ClickMidEquip" then

       local _UIEquipTar = MainGameUI.FindPanelTarget("UIEquip")
       if _UIEquipTar~=nil then
          _UIEquipTar:SmeltEquipType(2)
       end

    elseif _ParentName == "ClickBuyOneEquip" then

       local _UIEquipTar = MainGameUI.FindPanelTarget("UIEquip")
       if _UIEquipTar~=nil then
          _UIEquipTar:ShowBuyEquipItemInfo(1)
       end
      
    elseif _ParentName == "ClickBuyTwoEquip" then
       
       local _UIEquipTar = MainGameUI.FindPanelTarget("UIEquip")
       if _UIEquipTar~=nil then
          _UIEquipTar:ShowBuyEquipItemInfo(2)
       end

    elseif _ParentName == "ClickBuyThreeEquip" then

       local _UIEquipTar = MainGameUI.FindPanelTarget("UIEquip")
       if _UIEquipTar~=nil then
          _UIEquipTar:ShowBuyEquipItemInfo(3)
       end

    elseif _ParentName == "ClickBuyFourEquip" then

       local _UIEquipTar = MainGameUI.FindPanelTarget("UIEquip")
       if _UIEquipTar~=nil then
          _UIEquipTar:ShowBuyEquipItemInfo(4)
       end

    elseif _ParentName == "ClickBuyFiveEquip" then

       local _UIEquipTar = MainGameUI.FindPanelTarget("UIEquip")
       if _UIEquipTar~=nil then
          _UIEquipTar:ShowBuyEquipItemInfo(5)
       end

    elseif _ParentName == "ClickCloseEquipPanel" then

       local _UIEquipTar = MainGameUI.FindPanelTarget("UIEquip")
       if _UIEquipTar~=nil then        
          GameMain.CloseObj(_UIEquipTar.UIEquipGod)
		  _UIEquipTar:StopAutoPurify()
       end
    
    elseif _ParentName == "ClickHeroPanel" then

       local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
       if _UIControlTar~=nil then
          DataUIInstance.OpenHeroInfo(this.GoToNextGuide)
       end
       return

    elseif _ParentName == "ClickOneEquip" then                                      --给英雄穿装备
        
       local _UIHero = MainGameUI.FindPanelTarget("UIHero")
       if _UIHero~=nil and _UIHero.HeroList[1]~=nil then     
	      _UIHero:ShowDressEquipListInfo(1)    
       end

    elseif _ParentName == "ClickTrain" then
       
       local _UIHero = MainGameUI.FindPanelTarget("UIHero")
       if _UIHero~=nil then     
          _UIHero:CloseSendWebEquip()
	      _UIHero:ShowHeroTrainPanel() 
       end

    elseif _ParentName == "ClickNormalTrain" then
       
       local _UIHero = MainGameUI.FindPanelTarget("UIHero")
       if _UIHero~=nil then     
	      _UIHero:SendWebToTrain(1) 
       end

    elseif _ParentName == "ClickTrainDes" then
       
      

    elseif _ParentName == "ClickTrainFly" then
       
       local _UIHero = MainGameUI.FindPanelTarget("UIHero")
       if _UIHero~=nil then     
	      _UIHero:SendWebToAddExp(1)
       end

    end

    --**********************引导5
    -- if _ParentName == "ClickEquipPanel" then
       --[[ local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
       if _UIControlTar~=nil then
          DataUIInstance.OpenEquip(this.GoToNextGuide)
       end
       return--]]
    if _ParentName == "ClickStrongEquip" then

       local _UIEquipTar = MainGameUI.FindPanelTarget("UIEquip")
       if _UIEquipTar~=nil then
          _UIEquipTar:ChangePanel(_UIEquipTar.UIEquipGod.transform:FindChild("Tags"):FindChild("StrongTag"))
       end

    elseif _ParentName == "ClickEquipHero" then

       local _UIEquipTar = MainGameUI.FindPanelTarget("UIEquip")
       if _UIEquipTar~=nil then
          _UIEquipTar:ShowHeroEquipInfo(1)
       end
      
    elseif _ParentName == "ClickFirstEquip" then
       
       local _UIEquipTar = MainGameUI.FindPanelTarget("UIEquip")
       if _UIEquipTar~=nil then
          _UIEquipTar:ShowClickEquipItemInfo(2) 
       end

    elseif _ParentName == "ClickStrongButton" then

       local _UIEquipTar = MainGameUI.FindPanelTarget("UIEquip")
       if _UIEquipTar~=nil then
          _UIEquipTar:SendWebToStrengthEquip(0)
       end

    elseif _ParentName == "ClickSecondEquip" then

       local _UIEquipTar = MainGameUI.FindPanelTarget("UIEquip")
       if _UIEquipTar~=nil then
          _UIEquipTar:ShowClickEquipItemInfo(3)
       end

    elseif _ParentName == "ClickThirdEquip" then

       local _UIEquipTar = MainGameUI.FindPanelTarget("UIEquip")
       if _UIEquipTar~=nil then
          _UIEquipTar:ShowClickEquipItemInfo(1)
       end

    elseif _ParentName == "ClickForthEquip" then

       local _UIEquipTar = MainGameUI.FindPanelTarget("UIEquip")
       if _UIEquipTar~=nil then
          _UIEquipTar:ShowClickEquipItemInfo(5)
       end

    elseif _ParentName == "ClickFaithEquip" then

       local _UIEquipTar = MainGameUI.FindPanelTarget("UIEquip")
       if _UIEquipTar~=nil then
          _UIEquipTar:ShowClickEquipItemInfo(4)
       end
    
    elseif _ParentName == "ClickCloseEquipPanel" then

       local _UIEquipTar = MainGameUI.FindPanelTarget("UIEquip")
       if _UIEquipTar~=nil then
          GameMain.CloseObj(_UIEquipTar.UIEquipGod)
		  _UIEquipTar:StopAutoPurify()
       end
    
    end

    --**********************引导6
    if _ParentName == "ClickMissionPanel" then
       local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
       if _UIControlTar~=nil then
          DataUIInstance.OpenMission(this.GoToNextGuide)
       end
       return
    elseif _ParentName == "ClickGetMissionReward" then

       local _UIMissionTar = MainGameUI.FindPanelTarget("UIMission")
       if _UIMissionTar~=nil then
          local _Mission = _UIMissionTar.MainMissions[1].MainMission
          _UIMissionTar:ReceiveMainMission(_Mission , 1)
       end

    elseif _ParentName == "ClickCloseMission" then

       local _UIMissionTar = MainGameUI.FindPanelTarget("UIMission")
       if _UIMissionTar~=nil then    
          _UIMissionTar:CloseMissionPanel()              
       end
      
    elseif _ParentName == "ClickBag" then
       
       local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
       if _UIControlTar~=nil then
          DataUIInstance.CreateBag(this.GoToNextGuide)
       end
       return

    elseif _ParentName == "ClickGift" then

       local _UIBagTar = MainGameUI.FindPanelTarget("UIBag")
       if _UIBagTar~=nil then
          _UIBagTar:ClearBtnsState(_UIBagTar.SwitchBtns.libao)
		  _UIBagTar:UpDateInfo()      
       end

    elseif _ParentName == "ClickCloseBag" then     

       local _UIBagTar = MainGameUI.FindPanelTarget("UIBag")
       if _UIBagTar~=nil then
          _UIBagTar:ClosePanel()     
       end
    
    end

    --**********************引导7
    if _ParentName == "ClickTechnologyPanel" then
       local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
       if _UIControlTar~=nil then
          DataUIInstance.OpenTechnology(this.GoToNextGuide)
       end
       return
    elseif _ParentName == "ClickHeroUpNumber" then     

       local _UITechnologyTar = MainGameUI.FindPanelTarget("UITechnology")
       if _UITechnologyTar~=nil then
          _UITechnologyTar:ShowClickItemInfo(1 ,  UITechnology.HeroDataList[1])
       end

    elseif _ParentName == "ClickTechDes" then

      
      
    elseif _ParentName == "ClickTechMoney" then
       
       local _UITechnologyTar = MainGameUI.FindPanelTarget("UITechnology")
       if _UITechnologyTar~=nil then
          _UITechnologyTar:SendWebEvent()
       end 

    elseif _ParentName == "ClickTechStudy" then

       local _UITechnologyTar = MainGameUI.FindPanelTarget("UITechnology")
       if _UITechnologyTar~=nil then
          _UITechnologyTar:SendWebEvent()
       end 

    elseif _ParentName == "ClickCloseTechnologyPanel" then     

       local _UITechnologyTar = MainGameUI.FindPanelTarget("UITechnology")
       if _UITechnologyTar~=nil then
          GameMain.CloseObj(_UITechnologyTar.UITechnologyGob)
       end 
    
    elseif _ParentName == "ClickThreeHero" then     

       local _UIHero = MainGameUI.FindPanelTarget("UIHero")
       if _UIHero~=nil and _UIHero.HeroList[3]~=nil then     
	      _UIHero:SendWebAboutEquip(3)    
       end
    
    elseif _ParentName == "ClickThreeHero" then     

       local _UIHero = MainGameUI.FindPanelTarget("UIHero")
       if _UIHero~=nil and _UIHero.HeroList[3]~=nil then     
	      _UIHero:SendWebAboutEquip(3)    
       end

    end

    --**********************引导8
    if _ParentName == "ClickZhengShouPanel" then

       local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
       if _UIControlTar~=nil then
          DataUIInstance.OpenCollect(this.GoToNextGuide)
       end
       return

    elseif _ParentName == "ClickNormalZhengShou" then     

       local _UICollectTar = MainGameUI.FindPanelTarget("UICollect")
       if _UICollectTar~=nil then
          _UICollectTar:SendShowFreeCollectInfo()
       end

    elseif _ParentName == "ClickCloseZhengShouPanel" then

       GameMain.CloseObj(UICollect.UICollectGod)
       local _UICollectTar = MainGameUI.FindPanelTarget("UICollect")
       if _UICollectTar~=nil then
          GameMain.CloseObj(_UICollectTar.UICollectGod)
       end

    elseif _ParentName == "ClickCloseSoldierTip" then
       
    end

    --**********************引导9
    if _ParentName == "ClickTeamMake" then

       local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
       if _UIControlTar~=nil then
          _UIControlTar:OpenTeamMake(this.GoToNextGuide)
       end
       return

    elseif _ParentName == "ClickCloseTeamMake" then         

       local _UITeamMakeTar = MainGameUI.FindPanelTarget("UITeamMake")
       if _UITeamMakeTar~=nil then
          _UITeamMakeTar:SaveHero()
       end

    elseif _ParentName == "ClickDrawOneHero" then
       return
    elseif _ParentName == "ClickDrawOneSoldier" then
       return
    elseif _ParentName == "ClickWorldMapPanel" then      
       
       local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
       if _UIControlTar~=nil then
          DataUIInstance.CreateChooseCamp(this.GoToNextGuide)
       end
       return

    elseif _ParentName == "ClickWorldMapPanelSecond" then      
       
       this:OpenWorldMap(60 , 33004 , this.OpenChangeScene , 1)
       
      
    elseif _ParentName == "ClickChoseContry" then
       if _Gob.name == "ClickShu" then

           local _UITransferCountryTar = MainGameUI.FindPanelTarget("UITransferCountry")
           if _UITransferCountryTar~=nil then
              _UITransferCountryTar:ChooseCamp(1)
           end         
           return
       elseif _Gob.name == "ClickWei" then

          local _UITransferCountryTar = MainGameUI.FindPanelTarget("UITransferCountry")
          if _UITransferCountryTar~=nil then
             _UITransferCountryTar:ChooseCamp(2)
          end
          return
       elseif _Gob.name == "ClickWu" then

          local _UITransferCountryTar = MainGameUI.FindPanelTarget("UITransferCountry")
          if _UITransferCountryTar~=nil then
             _UITransferCountryTar:ChooseCamp(3)
          end
          return
       elseif _Gob.name == "ClickSuiji" then

          local _UITransferCountryTar = MainGameUI.FindPanelTarget("UITransferCountry")
          if _UITransferCountryTar~=nil then
             _UITransferCountryTar:ChooseCamp(0)
          end
          return

       end
    elseif _ParentName == "ClickSanJiang" then
       
       this:OpenCityInfo(true , "三江口" , "蜀国")

     --[[  local _UIWorldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
       if _UIWorldMapTar~=nil then
          _UIWorldMapTar.UIWorldMapGob.transform:FindChild("CityInfoPanel").gameObject:SetActive(true)
          _UIWorldMapTar.UIWorldMapGob.transform:FindChild("CityInfoPanel"):FindChild("ButtonList").gameObject:SetActive(false)
          _UIWorldMapTar.UIWorldMapGob.transform:FindChild("CityInfoPanel"):FindChild("IdleButton").gameObject:SetActive(true)
          _UIWorldMapTar.UIWorldMapGob.transform:FindChild("CityInfoPanel"):FindChild("CityInfo"):FindChild("CityName"):GetComponent("UILabel").text = "三江口"
          _UIWorldMapTar.UIWorldMapGob.transform:FindChild("CityInfoPanel"):FindChild("CityType"):FindChild("CityType"):GetComponent("UILabel").text = "蜀国"
       end      --]]
        GameMain.DelUpdateLua(this.UpdateUIPos)
    elseif _ParentName == "ClickMoveSanJiangKou" then 
      
       this:MoveToSomePlace(33004 , 45044)  
       GameMain.AddUpdateLua(this.UpdateWaitMeIntoCity)  
       return

    elseif _ParentName == "ClickRewardItem" then           --点击奖励道具

       local _UIWorldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")      
       if _UIWorldMapTar~=nil then
          _UIWorldMapTar.UIWorldMapGob.transform:FindChild("TempEventPanel").gameObject:SetActive(true)     
          _UIWorldMapTar.UIWorldMapGob.transform:FindChild("TempEventPanel").transform:FindChild("MoveButtonTempEvent").gameObject:SetActive(false)  
          _UIWorldMapTar.UIWorldMapGob.transform:FindChild("TempEventPanel").transform:FindChild("GetRewardTempEvent").gameObject:SetActive(true)  
       end

       GameMain.DelUpdateLua(this.UpdateUIPos)

    elseif _ParentName == "ClickGetRewad" then           --点击获取奖励
       
       UIGuide.RewardTrans.gameObject:SetActive(false)
       local _UIWorldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")     
       if _UIWorldMapTar~=nil then
          _UIWorldMapTar.UIWorldMapGob.transform:FindChild("TempEventPanel").gameObject:SetActive(false)             
       end

       DataUIInstance.PopTip("L8")
       UIGuide.Guide.transform:FindChild("AnchorReward").gameObject:SetActive(false) 

       GameMain.DelUpdateLua(this.UpdateRewardPos)
       GameMain.DelUpdateLua(this.UpdateUIPos)

    elseif _ParentName == "ClickChaiSang" then
       
       this:OpenCityInfo(true , "柴桑" , "中立")
     
       GameMain.DelUpdateLua(this.UpdateRewardPos)
       GameMain.DelUpdateLua(this.UpdateUIPos)
    
    elseif _ParentName == "ClickMovetoChaiSang" then
       
       this:MoveToSomePlace(45044 , 45045)
       GameMain.AddUpdateLua(this.UpdateWaitMeIntoCity)  
       return

    elseif _ParentName == "ClickChaiSangSecond" then
       
       this:OpenCityInfo(false , "柴桑" , "中立")

      
       GameMain.DelUpdateLua(this.UpdateRewardPos)
       GameMain.DelUpdateLua(this.UpdateUIPos)
    
    elseif _ParentName == "ClickSeeChaiSang" then       --观战柴桑
       
       MainGameUI.ReleaseAllPanel()
       GameMain.EnterZQBattle(3 , 2001 , false)
       GuideSys.UIYindao = true

    elseif _ParentName == "ClickArmyPower" then         --购买兵力

       DataUIInstance.PopTip("U2")
       local _UIWorldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
       if _UIWorldMapTar~=nil then     
          _UIWorldMapTar:SetArmyNum(60 , 60)    
       end

    elseif _ParentName == "ClickJiangXia" then         

       this:OpenCityInfo(true , "江夏" , "中立")
     
       GameMain.DelUpdateLua(this.UpdateRewardPos)
       GameMain.DelUpdateLua(this.UpdateUIPos)

     elseif _ParentName == "ClickMovetoJiangXia" then
       
       this:MoveToSomePlace(45045 , 45041)
       GameMain.AddUpdateLua(this.UpdateWaitMeIntoCity)  
       return
    
    elseif _ParentName == "ClickJiangXiaSecond" then
       
       this:OpenCityInfo(false , "江夏" , "中立")

      
       GameMain.DelUpdateLua(this.UpdateRewardPos)
       GameMain.DelUpdateLua(this.UpdateUIPos)

    elseif _ParentName == "ClickSeeJiangXia" then       --观战柴桑
       
       MainGameUI.ReleaseAllPanel()
       GameMain.EnterZQBattle(3 , 2002 , false)
       GuideSys.UIYindao = true

    elseif _ParentName == "ClickHanYang" then         

       this:OpenCityInfo(true , "汉阳" , "中立")
     
       GameMain.DelUpdateLua(this.UpdateRewardPos)
       GameMain.DelUpdateLua(this.UpdateUIPos)

     elseif _ParentName == "ClickMovetoHanYang" then
       
       this:MoveToSomePlace(45041 , 45042)
       GameMain.AddUpdateLua(this.UpdateWaitMeIntoCity)  
       return
    
    elseif _ParentName == "ClickHanYangSecond" then
       
       this:OpenCityInfo(false , "汉阳" , "中立")

      
       GameMain.DelUpdateLua(this.UpdateRewardPos)
       GameMain.DelUpdateLua(this.UpdateUIPos)

    elseif _ParentName == "ClickSeeHanYang" then       --观战汉阳
       
       MainGameUI.ReleaseAllPanel()
       GameMain.EnterZQBattle(3 , 2003 , false)
       GuideSys.UIYindao = true
    
    elseif _ParentName == "ClickEndHanYangDes" then

    elseif _ParentName == "ClickGlory" then 
       
       local _UIWorldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
       if _UIWorldMapTar~=nil then     
          _UIWorldMapTar.UIWorldMapGob.transform:FindChild("GloryPanel").gameObject:SetActive(true)
       end


    elseif _ParentName == "ClickGloryBox" then 

       local _UIWorldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
       if _UIWorldMapTar~=nil then     
          _UIWorldMapTar.UIWorldMapGob.transform:FindChild("GloryPanel").gameObject:SetActive(false)
       end

       local _Reward = RewardConfig.GetRewardConfig(100)
       local list = RewardContentSys.GetRewardResourceString(_Reward.RewardString)
       DataUIInstance.OpenRewards(list.Items)

    elseif _ParentName == "ClickCloseReward" then 

       local _UIShowRewardsTar = MainGameUI.FindPanelTarget("UIShowRewards")
       if _UIShowRewardsTar~=nil then
          _UIShowRewardsTar:ClosePanel()
       end
   
    elseif _ParentName == "ClickCloseWorldMap" then    
       
       this:CloseWorldMap()
       GuideSys.SendGuideWebEvent()
       return
    end

    --引导10
    if _ParentName == "ClickSoldierPanel" then

       local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
       if _UIControlTar~=nil then
          DataUIInstance.OpenSoliderInfo(this.GoToNextGuide)
       end
       return

    elseif _ParentName == "ClickPaoSoldier" then         

       local _UISoldierTar = MainGameUI.FindPanelTarget("UISoldier")
       if _UISoldierTar~=nil then
          _UISoldierTar.ClickInfoType = 2
          _UISoldierTar:ShowSoliderItemInfo(_UISoldierTar.UISoldierGob.transform:FindChild("SoldierInfo"):FindChild("SoldierS"):FindChild("Gong"):FindChild("HeroPanel"):FindChild("GongGrid"):FindChild("2") ,  _UISoldierTar.GongDataList[2])
       end

    elseif _ParentName == "ClickSoldierTrain" then
       
       local _UISoldierTar = MainGameUI.FindPanelTarget("UISoldier")
       if _UISoldierTar~=nil then
          _UISoldierTar.FirstCreateInfoModel = false
          _UISoldierTar:ShowPanel("SoliderTrain")
       end
      
    elseif _ParentName == "ClickSoldierNormalTrain" then
       
       local _UISoldierTar = MainGameUI.FindPanelTarget("UISoldier")
       if _UISoldierTar~=nil then
          _UISoldierTar:SendWebToTrain(1)
       end

    elseif _ParentName == "ClickSoldierTrainFly" then
   
       local _UISoldierTar = MainGameUI.FindPanelTarget("UISoldier")
       if _UISoldierTar~=nil then
          _UISoldierTar:SendWebToAddExp(1)
       end

    elseif _ParentName == "ClickCloseSoldierPanel" then     

       local _UISoldierTar = MainGameUI.FindPanelTarget("UISoldier")
       if _UISoldierTar~=nil then
          _UISoldierTar:CloseObj(_UISoldierTar.UISoldierGob)
       end
    
    elseif _ParentName == "ClickChoseTeam" then     

       local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
       if _UIControlTar~=nil then
          _UIControlTar:ChangeTeamGuide()
       end

    end--]]

    this:GoToNextGuide()
end

UIGuide.EnterIndex = 0
function UIGuide:OpenWorldMap(_Power , _CityId , CB , _EnterIndex)
   local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
   if _UIControlTar~=nil then
      UIGuide.EnterIndex = _EnterIndex
      LoadingPanel.OpenChangeScenePanel()
      WorldMapSys.CreateCityNodes()
      PlayerControl.InitSome()
      

      

      local _StartNode = WorldMapSys.FindCityNodeById(_CityId)           
      PlayerControl.TheMeCharacter:SetNodeInfo(_StartNode)
      PlayerControl.TheMeCharacter:SetPos(_StartNode.Pos)
      PlayerControl.TheMeCharacter:ChangeVipOfficer(0 , 0)    
      PlayerControl.TheMeCharacter:SetPower(_Power)
      PlayerControl.TheMeCharacter:SetOwner(ClinetInfomation.MyOwner)
      PlayerControl.TheMeCharacter:SetOwnerUI()
      PlayerControl.MainCamera.transform.localPosition = Vector3(3668 , 0 , 2333)

     
     -- GameMain.Print(_StartNode)
      _UIControlTar:OpenWorldMapEvent(CB)        
       
   end
end

function UIGuide:ChangeNodeOwner(_CityId)
   local _ChangeNode = WorldMapSys.FindCityNodeById(_CityId) 
   if _ChangeNode~= nil then
      _ChangeNode:SetNowOwnerShip(ClinetInfomation.MyOwner)
      _ChangeNode:SetNameMesh()
   end
end

function UIGuide:ChangeGuideOwner()
  if UIGuide.EnterIndex==1 then
       this:ChangeNodeOwner(33004)
       this:ChangeNodeOwner(45044)--]]
    elseif UIGuide.EnterIndex==2 then
       this:ChangeNodeOwner(45044)
       this:ChangeNodeOwner(33004)
       this:ChangeNodeOwner(45045)--]]
    elseif UIGuide.EnterIndex==3 then
       this:ChangeNodeOwner(45044)
       this:ChangeNodeOwner(33004)
       this:ChangeNodeOwner(45045)
       this:ChangeNodeOwner(45041)--]]
    elseif UIGuide.EnterIndex==4 then
       this:ChangeNodeOwner(45044)
       this:ChangeNodeOwner(33004)
       this:ChangeNodeOwner(45045)
       this:ChangeNodeOwner(45041)
       this:ChangeNodeOwner(45042)
    end
end

function UIGuide:OpenChangeScene()
   --this:GoToNextGuide()
  -- LoadingPanel.StopChangeScenePanel() 
   local _UIWorldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
   if _UIWorldMapTar~=nil then
      if UIGuide.EnterIndex==1 then
         _UIWorldMapTar:SetArmyNum(60 , 60)
      elseif UIGuide.EnterIndex==2 then
         _UIWorldMapTar:SetArmyNum(15 , 60)
      elseif UIGuide.EnterIndex==3 then
         _UIWorldMapTar:SetArmyNum(15 , 60)
      end     
   end

    

end

function UIGuide:MoveToSomePlace(_NowCityId , _TarId)
    local _UIWorldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
    if _UIWorldMapTar~=nil then
       _UIWorldMapTar.UIWorldMapGob.transform:FindChild("CityInfoPanel").gameObject:SetActive(false)        
    end
       
    PlayerControl.TheMeCharacter:ClearMe()
    PlayerControl.TheMeCharacter:SetMoveState("Idle")
    PlayerControl.TheMeCharacter.SaveNodes = {}
    local _Node = WorldMapSys.FindCityNodeById(_NowCityId) 
    PlayerControl.TheMeCharacter.SaveNodes[1] = _Node
    _Node = WorldMapSys.FindCityNodeById(_TarId) 
    PlayerControl.TheMeCharacter.SaveNodes[2] = _Node
    PlayerControl.TheMeCharacter:StartMove()

    if UIGuide.TempStepGob~=nil then
      UIGuide.TempStepGob.gameObject:SetActive(false)
   end
end

function UIGuide:OpenCityInfo(_IsMove , _CityName , _CityCampName)

    local _UIWorldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
    if _UIWorldMapTar~=nil then
       _UIWorldMapTar.UIWorldMapGob.transform:FindChild("CityInfoPanel").gameObject:SetActive(true)
       if _IsMove==true then
          _UIWorldMapTar.UIWorldMapGob.transform:FindChild("CityInfoPanel"):FindChild("ButtonList").gameObject:SetActive(false)
          _UIWorldMapTar.UIWorldMapGob.transform:FindChild("CityInfoPanel"):FindChild("IdleButton").gameObject:SetActive(true)
       else
          _UIWorldMapTar.UIWorldMapGob.transform:FindChild("CityInfoPanel"):FindChild("ButtonList").gameObject:SetActive(false)
          _UIWorldMapTar.UIWorldMapGob.transform:FindChild("CityInfoPanel"):FindChild("IdleButton").gameObject:SetActive(false)
          _UIWorldMapTar.UIWorldMapGob.transform:FindChild("CityInfoPanel"):FindChild("IdleAndSeeButton").gameObject:SetActive(true)
       end
       _UIWorldMapTar.UIWorldMapGob.transform:FindChild("CityInfoPanel"):FindChild("CityInfo"):FindChild("CityName"):GetComponent("UILabel").text = _CityName
       _UIWorldMapTar.UIWorldMapGob.transform:FindChild("CityInfoPanel"):FindChild("CityType"):FindChild("CityType"):GetComponent("UILabel").text = _CityCampName
    end  
           
end

function UIGuide:CloseWorldMap()
   local _UIWorldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
   if _UIWorldMapTar~=nil then
       _UIWorldMapTar.UIWorldMapGob.gameObject:SetActive(false)
       GameMain.WorldMapSys.gameObject:SetActive(false)
       local UIControlTar = MainGameUI.FindPanelTarget("UIControl")
       if UIControlTar~=nil then
          UIControlTar:SetOutSideUIList(true)
          UIControlTar:SetAnchorTopLeft(true)
          UIControlTar:SetAnchorTop(true)
       end
       PlayerControl.Release()
       PlayerControl.TheMeCharacter:ClearMe()
   end
end

UIGuide.UITeamMakeTar = nil
function UIGuide:UIOnPress(_LuaName , _Gob , _isPress)
   
   if UIGuide.UITeamMakeTar==nil then
      UIGuide.UITeamMakeTar = MainGameUI.FindPanelTarget("UITeamMake")
   end
   
   if _isPress==false then     
            
      if UIGuide.UITeamMakeTar~=nil and UIGuide.UITeamMakeTar.HitInfo~=nil then
        
         --if UIGuide.UITeamMakeTar.HitInfo.point.x >=4 and UIGuide.UITeamMakeTar.HitInfo.point.x <= 6 and UIGuide.UITeamMakeTar.HitInfo.point.y >= 4 and UIGuide.UITeamMakeTar.HitInfo.point.y<=6.5 then            

                if _Gob.name == "ClickEventHero" then
                   UIGuide.UITeamMakeTar:GuidePutHero()
                   this:GoToNextGuide()
                elseif _Gob.name == "ClickEventDrawSoldier" then                 
                   --UIGuide.UITeamMakeTar:UIOnPress( nil , UIGuide.UITeamMakeTar.SoldierGrid.transform:FindChild("Soldier_1") , false)
                   UIGuide.UITeamMakeTar:GuidePutSoldier()
                   this:GoToNextGuide()
                end
             
         -- end
       end
      
   end
   
end

function UIGuide:UIDragEvent( _LuaName , _Gob , _Detal) 
   --Debug.LogError(_Gob)
   if UIGuide.UITeamMakeTar==nil then
      UIGuide.UITeamMakeTar = MainGameUI.FindPanelTarget("UITeamMake")
   else
      if _Gob.name == "ClickEventHero" then
         UIGuide.UITeamMakeTar:UIDragEvent(nil , UIGuide.UITeamMakeTar.HeroGrid.transform:FindChild("Hero_1") , nil)
      elseif _Gob.name == "ClickEventDrawSoldier" then 
         UIGuide.UITeamMakeTar:UIDragEvent(nil , UIGuide.UITeamMakeTar.SoldierGrid.transform:FindChild("Soldier_1") , nil)
      end
   end
end

UIGuide.UIGuideMusic = nil
function UIGuide:SetGuide(_Guide)                                                   --设置引导步骤信息
  if UIGuide.UIGuideMusic ~= nil then
	MusicManagerSys.StopSomeMusic(UIGuide.UIGuideMusic)
  end
	 
	UIGuide.GuideData = _Guide
   UIGuide.GuideEventName = UIGuide.GuideData.Type
   this:OpenOneStep()
   this:SetGuideUI()
	local soundName = UIGuide.GuideData.Sound
	UIGuide.UIGuideMusic = MusicManagerSys.GuideSound( soundName)
end

function UIGuide:SetGuideUI()   
   if UIGuide.GuideData.ChatContent~="0" then
      UIGuide.TempStepGob.transform:FindChild("Descrip"):GetComponent("UILabel").text = UIGuide.GuideData.ChatContent
   end  
end

UIGuide.RewardTrans = nil
function UIGuide:OpenOneStep()
   if UIGuide.TempStepGob~=nil then
      UIGuide.TempStepGob.gameObject:SetActive(false)
   end
   local _TempGob = nil
  -- GameMain.Print(UIGuide.GuideData)
  -- Debug.LogError(UIGuide.GuideEventName)
   if UIGuide.GuideData.Type=="chat" then
      _TempGob = UIGuide.UIGuideGob.transform:FindChild(UIGuide.GuideEventName)
   else
      _TempGob = UIGuide.Guide.transform:FindChild(UIGuide.GuideEventName)
   end 

   UIGuide.TempStepGob = _TempGob
   UIGuide.TempStepGob.gameObject:SetActive(true)  

  

   if GuideSys.NowBigStep==9 and GuideSys.NowSmallStep == 10 then --需点击三江口
      this:ClacuCityPos(45044 , true , true)
      GameMain.AddUpdateLua(this.UpdateRewardPos)
      GameMain.AddUpdateLua(this.UpdateUIPos)
   end

   if GuideSys.NowBigStep==9 and GuideSys.NowSmallStep == 12 then --需点击点击物资
      GameMain.AddUpdateLua(this.UpdateUIPos)
   end

   if GuideSys.NowBigStep==9 and GuideSys.NowSmallStep == 17 then --需要点击柴桑
      this:ClacuCityPos(45045 , false , false)
      GameMain.AddUpdateLua(this.UpdateRewardPos)
      GameMain.AddUpdateLua(this.UpdateUIPos)

   end

   if GuideSys.NowBigStep==9 and GuideSys.NowSmallStep == 19 then --需要点击柴桑
      this:ClacuCityPos(45045 , false , false)
      GameMain.AddUpdateLua(this.UpdateRewardPos)
      GameMain.AddUpdateLua(this.UpdateUIPos)
   end

   if GuideSys.NowBigStep==9 and GuideSys.NowSmallStep == 21 then 
      this:OpenWorldMap(15 , 45045 , this.OpenChangeScene , 2)
   end


   if GuideSys.NowBigStep==9 and GuideSys.NowSmallStep == 24 then --需要点击江夏
      this:ClacuCityPos(45041 , false , false)
      GameMain.AddUpdateLua(this.UpdateRewardPos)
      GameMain.AddUpdateLua(this.UpdateUIPos)

   end

   if GuideSys.NowBigStep==9 and GuideSys.NowSmallStep == 26 then --需要点击江夏
      this:ClacuCityPos(45041 , false , false)
      GameMain.AddUpdateLua(this.UpdateRewardPos)
      GameMain.AddUpdateLua(this.UpdateUIPos)
   end
  
   if GuideSys.NowBigStep==9 and GuideSys.NowSmallStep == 28 then 
      this:OpenWorldMap(15 , 45041 , this.OpenChangeScene , 3)
   end

   if GuideSys.NowBigStep==9 and GuideSys.NowSmallStep == 30 then --需要点击hanyang
      this:ClacuCityPos(45042 , false , false)
      GameMain.AddUpdateLua(this.UpdateRewardPos)
      GameMain.AddUpdateLua(this.UpdateUIPos)

   end

   if GuideSys.NowBigStep==9 and GuideSys.NowSmallStep == 32 then --需要点击江夏
      this:ClacuCityPos(45042 , false , false)
      GameMain.AddUpdateLua(this.UpdateRewardPos)
      GameMain.AddUpdateLua(this.UpdateUIPos)
   end
  
   if GuideSys.NowBigStep==9 and GuideSys.NowSmallStep == 34 then 
      this:OpenWorldMap(15 , 45042 , this.OpenChangeScene , 4)
   end

   if GuideSys.NowBigStep==10 and GuideSys.NowSmallStep == 10 then 
      this:OpenGuide()
   end

end

function UIGuide:ClacuCityPos(_CityId , _IsOpen , _IsOpenReward)
   UIGuide.Guide.transform:FindChild("AnchorReward").gameObject:SetActive(true) 
   UIGuide.RewardTrans = UIGuide.Guide.transform:FindChild("AnchorReward"):FindChild("WorldReward")
   UIGuide.RewardTrans.transform:FindChild("Rewad").gameObject:SetActive(_IsOpenReward) 
   UIGuide.RewardTrans.gameObject:SetActive(_IsOpen)
   local _Node = WorldMapSys.FindCityNodeById(_CityId)             --三江口
   UIGuide.TarPos = _Node.Pos
end

function UIGuide:GoToNextGuide()
   GuideSys.MoveNextGuide()
end

function UIGuide:OpenGuide()                                                    --开启大引导Gob
   if UIGuide.Guide~=nil then
      UIGuide.Guide.gameObject:SetActive(true)
   end
end

function UIGuide:CloseGuide()                                                   --开启小引导Gob
   if UIGuide.Guide~=nil then
      UIGuide.Guide.gameObject:SetActive(false)
   end
end

function UIGuide:CreateSomeGuide(_BigStep , _CB)                                    --创建一个大引导Gob
   if UIGuide.UIGuideGob~=nil then
      local GuideName = "Guide_"..tostring(_BigStep)
      data = 
      {
           CB = _CB,
      }
      MainGameUI.CreateLittleItem(GuideName , GuideName , UIGuide.UIGuideGob , data , this.CreateSomeGuideCallBack , "UIGuide")
   end
end

function UIGuide:CreateSomeGuideCallBack(_Gob , _Info)
   _Gob.transform.localPosition = Vector3(0 , 0 ,0)
   _Gob.transform.localScale = Vector3(1 , 1 , 1)
   UIGuide.Guide = _Gob
   _Info.CB()
end

UIGuide.UIWorldMapTar = nil
function UIGuide:UpdateRewardPos()
      if UIGuide.UIWorldMapTar==nil then
         UIGuide.UIWorldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
      end
   --if UIGuide.GuideEventName=="ClickSanJiang" then
      if UIGuide.UIWorldMapTar~=nil then
         if PlayerControl.MainCityCamera~=nil and UIGuide.UIWorldMapTar.UICamera~=nil and UIGuide.TarPos~=nil then           
              local _ScreenPosition = PlayerControl.MainCityCamera:WorldToScreenPoint(UIGuide.TarPos)
              local _ttt = Vector3(_ScreenPosition.x , _ScreenPosition.y , 0)
              local _TarPos = UIGuide.UIWorldMapTar.UICamera:ScreenToWorldPoint(_ttt)
              UIGuide.RewardTrans.position = Vector3(_TarPos.x , _TarPos.y , _TarPos.z)
         end
      end
   --end
end

function UIGuide:UpdateUIPos()
      if UIGuide.RewardTrans~=nil then        
         UIGuide.TempStepGob.position = UIGuide.RewardTrans.position
      end
end

function UIGuide:UpdateAttakPos()
   if UIGuide.UIWorldMapTar==nil then
      UIGuide.UIWorldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
   end
   if UIGuide.UIWorldMapTar~=nil then
      if PlayerControl.MainCityCamera~=nil and UIGuide.UIWorldMapTar.UICamera~=nil and UIGuide.TarPos~=nil then           
         local _ScreenPosition = PlayerControl.MainCityCamera:WorldToScreenPoint(UIGuide.TarPos)
         local _ttt = Vector3(_ScreenPosition.x , _ScreenPosition.y , 0)
         local _TarPos = UIGuide.UIWorldMapTar.UICamera:ScreenToWorldPoint(_ttt)
         UIGuide.TempStepGob.position = Vector3(_TarPos.x , _TarPos.y , _TarPos.z)
      end
   end
end

function UIGuide:UpdateWaitMeIntoCity()
   if PlayerControl.TheMeCharacter.GoInCity == true then
      this:GoToNextGuide()
      GameMain.DelUpdateLua(this.UpdateWaitMeIntoCity)
   end
end

function UIGuide:ReleasPanel()               									 --退出界面时释放和界面初始化
    UIGuide.UIGuideGob = nil                                        --总控制                        
    UIGuide.Guide = nil                                             --大步骤GOb
    UIGuide.TempStepGob = nil                                       --小步骤GOb                                 
    UIGuide.GuideEventName = nil
    UIGuide.GuideData = nil
    UIGuide.TarPos = nil

    UIGuide.UITeamMakeTar = nil
    UIGuide.RewardTrans = nil
    UIGuide.UIWorldMapTar = nil
	UIGuide.UIGuideMusic = nil
end

return UIGuide