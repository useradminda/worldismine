GuideSys = {}
GuideSys.TotalSmallStep = 0                         --小步骤总数

GuideSys.NowBigStep = 0                             --当前大步骤Index
GuideSys.NowSmallStep = 0                           --当前小步骤Index

GuideSys.NowStepData = 0                            --当前步骤数据
GuideSys.GuideState = true                          --全部引导结束false  引导true

GuideSys.OutUI = true                               --外层UI True   战斗UI false
GuideSys.UIYindao = false

GuideSys.WaitFlag = false
GuideSys.WaitNowTime = 0
GuideSys.WaitTotalTime = 0

GuideSys.Need = false

function GuideSys.InitGuide()
  -- Debug.LogError(GameMain.GuideNeed)
   if GameMain.GuideNeed == false then
      GuideSys.NowBigStep = 100
      return
   end 
  -- GuideSys.NowBigStep = 9                     --服务器下发大引导步数
   GuideSys.NowSmallStep = 1
   if GuideSys.GetGuide()==nil then                 --当前没有引导选项 引导结束了
      return
   else
      GuideSys.GuideState = true                    --引导开始
      GuideSys.JudgeGuide()
   end
   GuideSys.GetGuideTotalSmallStep(GuideSys.NowBigStep)  
   GuideSys.UIYindao = false

   if GuideSys.GuideState == true then                                          --第一个大引到
      if GuideSys.NowBigStep == 1 then          
         local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
         if _UIControlTar~=nil then
            GameMain.SetBattleYindao()
            _UIControlTar:OpenZhengZhan()
         end
      else
         GuideSys.CreateOutUIGuide()
        
      end
   end

   GameMain.AddUpdateLua(GuideSys.UpdateGuide)
end

function GuideSys.CreateOutUIGuide()
   if GuideSys.NowBigStep > 0 and GuideSys.NowBigStep < 7 then
      GuideSys.CreateBigStepGob()
   else
     -- Debug.LogError(GuideSys.NowBigStep)
    --  Debug.LogError(MapSys.NowMap)
      if GuideSys.NowBigStep==7 and MapSys.NowMap > 6 then        --当前打第7关
         GuideSys.CreateBigStepGob()
      end

      if GuideSys.NowBigStep==8 then
         GuideSys.CreateBigStepGob()
      end

      if GuideSys.NowBigStep==9 and MapSys.NowMap > 8 then       --当前打第9关
         GuideSys.CreateBigStepGob()
      end

      if GuideSys.NowBigStep==10 and MapSys.NowMap > 9 then      --当前打第10关
         GuideSys.CreateBigStepGob()
      end
   end
end

GuideSys.BeforeNextCB = nil
function GuideSys.MoveNextGuide()                  --前进到下一个步骤
   
   if GuideSys.BeforeNextCB~=nil then
      GuideSys.BeforeNextCB()
      GuideSys.BeforeNextCB = nil
   end

   GuideSys.NowSmallStep = GuideSys.NowSmallStep + 1
   --Debug.LogError(GuideSys.NowSmallStep)
   if GuideSys.NowSmallStep >  GuideSys.TotalSmallStep then     --大步骤已经完结

      if GuideSys.OutUI==true then
         GuideSys.SendGuideWebEventUIPanel()
      end

      local _UIGuideTar = MainGameUI.FindPanelTarget("UIGuide")
      if _UIGuideTar~=nil then
         _UIGuideTar.UIGuideGob.gameObject:SetActive(false)
      end

   elseif GuideSys.NowSmallStep <=  GuideSys.TotalSmallStep then
      --GuideSys.NowBigStep = GuideSys.NowBigStep + 1
      GuideSys.GetGuide()
      GuideSys.JudgeGuide()
      GuideSys.SendGuideUI()
   end
end

function GuideSys.GetGuide()                        --获取某个步骤的信息
   GuideSys.NowStepData = GuideDataSys.GetOneGuide(GuideSys.NowBigStep , GuideSys.NowSmallStep)
   if GuideSys.NowStepData==nil then     
      GuideSys.GuideState = false
   else
      GuideSys.GuideState = true      
   end
   return GuideSys.NowStepData
end

function GuideSys.JudgeGuide()                      --判断当前跳转的引导需要做的事情

   if GuideSys.NowStepData~=nil then
      
      if GuideSys.OutUI==false then
         if GuideSys.NowBigStep==1 and GuideSys.NowSmallStep ==1 then
            GameMain.SetNoHumanHero(0)
            GuideSys.WaitSecond(3 , GameMain.PauseBattleGame)                                   
         end     

        
         if GuideSys.NowBigStep==1 and GuideSys.NowSmallStep == 3 then
            GameMain.PauseBattleGame()                                  --解除暂停
         end

         if GuideSys.NowBigStep==1 and GuideSys.NowSmallStep ==4 then
            GameMain.OutHero(1)
            GuideSys.CloseTempGuide()
            GuideSys.WaitSecond(2 , GuideSys.OpenTempGuide)                                               
         end

         if GuideSys.NowBigStep==1 and GuideSys.NowSmallStep ==5 then
            GameMain.OutHero(2)   
            GuideSys.CloseTempGuide()
            GuideSys.WaitSecond(2 , GuideSys.OpenTempGuide)                                 
         end

         if GuideSys.NowBigStep==1 and GuideSys.NowSmallStep ==6 then
            GameMain.OutHero(3)
            GuideSys.CloseTempGuide()
            GuideSys.WaitSecond(2 , GuideSys.OpenTempGuide)                                          
         end

         if GuideSys.NowBigStep==1 and GuideSys.NowSmallStep ==7 then
            GameMain.OutHero(4)    
            GuideSys.CloseTempGuide()
            GuideSys.WaitSecond(2 , GuideSys.OpenTempGuide)                             
         end

         if GuideSys.NowBigStep==1 and GuideSys.NowSmallStep ==8 then
            GameMain.OutHero(5) 
            GameMain.SetNoHumanHero(-1)                            
         end

         --第二关
         if GuideSys.NowBigStep == 2 and GuideSys.NowSmallStep ==9 then
            GameMain.PauseBattleGame()                                   --发起暂停                           
         end
         
         if GuideSys.NowBigStep == 2 and GuideSys.NowSmallStep ==12 then
            GuideSys.BeforeNextCB = GameMain.PauseBattleGame                       
         end

         if GuideSys.NowBigStep == 2 and GuideSys.NowSmallStep ==13 then   --发起点击第二波小兵
            GuideSys.CloseTempGuide()
            GuideSys.WaitSecond(16 , GuideSys.OpenTempGuide)
            GuideSys.PauseGameCB = GameMain.PauseBattleGame                         
         end

         
         if GuideSys.NowBigStep == 2 and GuideSys.NowSmallStep ==14 then  --发起点击第二波小兵
            GuideSys.CloseTempGuide()
            GuideSys.WaitSecond(15 , GuideSys.OpenTempGuide)
            GuideSys.PauseGameCB = GameMain.PauseBattleGame                                
           --[[ GameMain.SetNoHumanHero(0)
            GameMain.OutHero(1)
            GameMain.SetNoHumanHero(-1) --]]
         end
         
         if GuideSys.NowBigStep > 0 and GuideSys.NowBigStep < 9 then                                 
            local BattleGob = GameMain.GetBattleUIGob()
            --Debug.LogError(BattleGob)
            if BattleGob~=nil then
               BattleGob.transform:FindChild("Camera"):FindChild("backbt").gameObject:SetActive(false)
            end
         end

      elseif GuideSys.OutUI==true then 
            
         if GuideSys.NowBigStep==1 and GuideSys.NowSmallStep ==1 then
            GuideSys.AddHero(1017)
            GuideSys.AddHero(1027)
            GuideSys.AddHero(1037)
            GuideSys.AddHero(1047)
            GuideSys.AddHero(1057)
         end
         
         if GuideSys.NowBigStep==2 and GuideSys.NowSmallStep ==8 then
            --GuideSys.AddHero(1017)
            
         end


         if GuideSys.NowBigStep==3 and GuideSys.NowSmallStep == 1 then          --判断取名字
             if ClinetInfomation.Name ~= tostring(LoginData.PlayerID) then           
                GuideSys.NowSmallStep = 3
                GuideSys.GetGuide()
                GuideSys.SendGuideUI()
                return          
             end      
         end

         if GuideSys.NowBigStep==3 and GuideSys.NowSmallStep == 18 then          --出战第一个英雄
            local _UIHero = MainGameUI.FindPanelTarget("UIHero")
            if _UIHero~=nil then
                if _UIHero.HeroList[1]~=nil then
                   if _UIHero.HeroList[1].IsUp == true then
                      GuideSys.NowSmallStep = 19
                      GuideSys.GetGuide()
                      GuideSys.SendGuideUI()
                      return
                   end
                end
            end
         end
        
        if GuideSys.NowBigStep==3 and GuideSys.NowSmallStep == 21 then          --出战第二个
           local _UIHero = MainGameUI.FindPanelTarget("UIHero")
           if _UIHero~=nil then
               if _UIHero.HeroList[2]~=nil then
                  if _UIHero.HeroList[2].IsUp == true then
                     GuideSys.NowSmallStep = 23
                     GuideSys.GetGuide()
                     GuideSys.SendGuideUI()
                     return
                  end
               end
           end
        end



         if GuideSys.NowBigStep==4 and GuideSys.NowSmallStep == 3 then
             local _UIEquip = MainGameUI.FindPanelTarget("UIEquip")
             if _UIEquip~=nil then                  
	            if _UIEquip.EquipSmeltDataList[1]~=nil then                  
                      GuideSys.NowSmallStep = 4
                      if _UIEquip.EquipSmeltDataList[5].IsBuy == true then
                         GuideSys.NowSmallStep = 9
                      end
                      GuideSys.GetGuide()
                      GuideSys.SendGuideUI()
                      return                  
                end
             end        
         end

         if GuideSys.NowBigStep==4 and GuideSys.NowSmallStep == 11 then
            local _UIHero = MainGameUI.FindPanelTarget("UIHero")
            if _UIHero~=nil then
               if _UIHero.HeroList[1]~=nil then
                    if _UIHero.HeroList[1].Equips[5]~=nil then      --已经穿了五件了
                       GuideSys.NowSmallStep = 16
                       GuideSys.GetGuide()
                       GuideSys.SendGuideUI()
                       return
                    end
                end
            end
         end


         if GuideSys.NowBigStep==4 and GuideSys.NowSmallStep == 18 then
             local _UIHero = MainGameUI.FindPanelTarget("UIHero")
             if _UIHero~=nil then     
	            if _UIHero.HeroList[1]~=nil then
                   if _UIHero.HeroList[1]:IsTrain()==true then                              --英雄已经在训练了
                      GuideSys.NowSmallStep = 27
                      GuideSys.GetGuide()
                      GuideSys.SendGuideUI()
                      return
                   end
                end
             end        
         end

         if GuideSys.NowBigStep==5 and GuideSys.NowSmallStep == 6 then
            local _UIEquip = MainGameUI.FindPanelTarget("UIEquip")
            if _UIEquip~=nil then

               local heroData = _UIEquip.HeroDataList[_UIEquip.ClickHeroIndex]

	           local equipData1 = EquipSys.FindEquipByUUID(heroData.Equips[2])          --第一件装备
               if equipData1.Lvl == 2 then                                              --第一件升过级了
                                                                   
                  GuideSys.NowSmallStep = 8

                  local equipData2 = EquipSys.FindEquipByUUID(heroData.Equips[3])       --拿第二件装备
                  if equipData2.Lvl == 2 then                                           --第二件胜过级了

                     GuideSys.NowSmallStep = 10

                     local equipData3 = EquipSys.FindEquipByUUID(heroData.Equips[1])       --拿第三件装备
                     if equipData3.Lvl == 2 then                                           --第二件胜过级了

                        GuideSys.NowSmallStep = 12

                         local equipData4 = EquipSys.FindEquipByUUID(heroData.Equips[5])       --拿第二件装备
                         if equipData4.Lvl == 2 then                                           --第二件胜过级了
                            GuideSys.NowSmallStep = 14

                            local equipData5 = EquipSys.FindEquipByUUID(heroData.Equips[4])       --拿第二件装备
                            
                            if equipData5.Lvl == 2 then
                               GuideSys.NowSmallStep = 16
                            end
                         end
                      end
                   end
                end
                  GuideSys.GetGuide()
                  GuideSys.SendGuideUI()
                  return               
            end         
         end

         
          if GuideSys.NowBigStep==7 and GuideSys.NowSmallStep == 2 then
             local _UITechnologyTar = MainGameUI.FindPanelTarget("UITechnology")
             if _UITechnologyTar~=nil then     
	            if _UITechnologyTar.HeroDataList[1]~=nil then
                   if _UITechnologyTar.HeroDataList[1].State == 4 or _UITechnologyTar.HeroDataList[1].State == 3 then                  --第一个科技已经学完 或者已经在研究 直接关闭
                      GuideSys.NowSmallStep = 7
                      GuideSys.GetGuide()
                      GuideSys.SendGuideUI()
                      return
                   end
                   if _UITechnologyTar.HeroDataList[1].State == 2 then
                      GuideSys.NowSmallStep = 5
                      GuideSys.GetGuide()
                      GuideSys.SendGuideUI()
                      return
                   end
                end
             end        
         end
         
         if GuideSys.NowBigStep==7 and GuideSys.NowSmallStep == 9 then                  --第三个已经上阵了
            local _UIHero = MainGameUI.FindPanelTarget("UIHero")
            if _UIHero~=nil then
              if _UIHero.HeroList[3]~=nil then
                 if _UIHero.HeroList[3].IsUp == true then
                    GuideSys.NowSmallStep = 11
                    GuideSys.GetGuide()
                    GuideSys.SendGuideUI()
                    return
                 end
               end
            end
         end



         if GuideSys.NowBigStep==8 then
            if GuideSys.NowSmallStep == 2 then  
               if  CollectSys.FreeCollectTimes ==5 then
                   GuideSys.NowSmallStep = 6
                   GuideSys.MoveNextGuide()
                   return 
               end                                 
                                         --已经征收了五次
                GuideSys.NowSmallStep = 2 + CollectSys.FreeCollectTimes
                GuideSys.GetGuide()
                GuideSys.SendGuideUI()
		        return
	           
            end
         end       

         if GuideSys.NowBigStep==9 and GuideSys.NowSmallStep == 3 then
            local _TeamInfo = TeamSys.GetTeamInfoByType(1) 
            if _TeamInfo~=nil and _TeamInfo[1]~=nil then
               GuideSys.NowSmallStep = 5
               GuideSys.GetGuide()
               GuideSys.SendGuideUI()
               return
            end
         end       

         if GuideSys.NowBigStep==9 and GuideSys.NowSmallStep == 6 then
            if ClinetInfomation.MyOwner~=0 then                                                 --已经加入过国家了
               GuideSys.NowSmallStep = 8
               GuideSys.GetGuide()
               GuideSys.SendGuideUI()
               return
            end
         end 
         
         if GuideSys.NowBigStep==10 and GuideSys.NowSmallStep == 4 then
             local _UISoldierTar = MainGameUI.FindPanelTarget("UISoldier")
             if _UISoldierTar~=nil then     
	            if _UISoldierTar.SoldierDataList[1]~=nil then
                   if _UISoldierTar.SoldierDataList[1]:IsTrain()==true then                              --英雄已经在训练了
                      GuideSys.NowSmallStep = 8
                      GuideSys.GetGuide()
                      GuideSys.SendGuideUI()
                      return
                   end
                end
             end        
         end
    
         

      end

   else
      if GuideSys.OutUI==false then

         if GuideSys.NowBigStep > 0 and GuideSys.NowBigStep < 9 then                                 
            local BattleGob = GameMain.GetBattleUIGob()
            --Debug.LogError(BattleGob)
            if BattleGob~=nil then
               BattleGob.transform:FindChild("Camera"):FindChild("backbt").gameObject:SetActive(false)
            end
         end

      end
   end
end

function GuideSys.AddHero(_DBId)
    local _UUID = "sss"..tostring(_DBId)
    role = RoleDataSys.CreateHero(_DBId , _UUID , 1)   
    table.insert(HeroPackageSys.Heros , #HeroPackageSys.Heros + 1 , role)
    local _Hero =
	{ 
		UUID = _UUID,
	}
    table.insert(TeamSys.PveHeroList , 1 , _Hero) 
   -- GameMain.Print(TeamSys.PveHeroList)
end

function GuideSys.ClearHero(_DBId)
   local _UUID = "sss"..tostring(_DBId)
   role = RoleDataSys.CreateHero(_DBId , _UUID , 1)
   TeamSys.RePveHero(role)
   local index = HeroPackageSys.GetOneHeroIndex(_UUID)
       if index~=nil then
       table.remove(HeroPackageSys.Heros,index)
      -- GameMain.Print(HeroPackageSys.Heros)      
   end
   role = nil
end

function GuideSys.GetGuideTotalSmallStep(_BigStep)     --获得大步骤的总步数
   local _Count = GuideDataSys.GetTotalSmallStep(_BigStep)
   GuideSys.TotalSmallStep = _Count
end

function GuideSys.CreateBigStepGob()
   --Debug.LogError("CreateBigStepGob")
   --Debug.LogError(GuideSys.NowBigStep)
   --Debug.LogError(GuideSys.NowSmallStep)
   local _UIGuidelGob = nil
   
   if GuideSys.OutUI==true then
      local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
      if _UIControlTar~=nil then
         _UIGuidelGob = _UIControlTar.UIControlGob.transform:FindChild("Camera"):FindChild("UIGuide").gameObject
      end
   else
      _UIGuidelGob = GameMain.GetBattleUIGob().transform:FindChild("Camera"):FindChild("UIGuide").gameObject
   end
   GuideSys.GetGuideTotalSmallStep(GuideSys.NowBigStep) 
   GuideSys.GetGuide()
   GuideSys.JudgeGuide()
   --Debug.LogError(GuideSys.NowSmallStep)
   if GuideSys.NowStepData==nil then
      return
   end
   
   local _UIGuideTar = MainGameUI.FindPanelTarget("UIGuide")

   if _UIGuideTar~=nil then
      _UIGuideTar:OpenUI()
      _UIGuideTar:CreateSomeGuide(GuideSys.NowBigStep , GuideSys.SendGuideUI)
   else
	  local lua = GameMain.requireLuaFile("UIGuide")
	  local obj1 = lua:new()
	  MainGameUI["target"]["UIGuide"] = obj1

      if MainGameUI["GameObject"]["UIGuide"]==nil then
         MainGameUI["GameObject"]["UIGuide"] = _UIGuidelGob
      end
      MainGameUI["target"]["UIGuide"]:OpenUI()  
      MainGameUI["target"]["UIGuide"]:CreateSomeGuide(GuideSys.NowBigStep , GuideSys.SendGuideUI)
   end
end

function GuideSys.SendGuideUI()
   local _UIGuideTar = MainGameUI.FindPanelTarget("UIGuide")
   if _UIGuideTar~=nil then
      if GuideSys.WaitFlag == true then
         return
      end
      _UIGuideTar:SetGuide(GuideSys.NowStepData)
   end
end

function GuideSys.BattleOutGuide(_Map , _IsWin)                  --副本战斗完之后
   if GameMain.GuideNeed == false then
      return
   end
      GuideSys.WaitFlag = false
      GuideSys.CloseGuide()

      if GuideSys.NowBigStep==1 then                    --第一次副本结束后把背包的临时英雄清除
         GuideSys.ClearHero(1017)
         GuideSys.ClearHero(1027)
         GuideSys.ClearHero(1037)
         GuideSys.ClearHero(1047)
         GuideSys.ClearHero(1057)
      elseif GuideSys.NowBigStep ==2 then--and GuideSys.NowBigStep<=8 then  
         --GuideSys.ClearHero(1017)    
      end
       
     

     if _Map.Chapter_Id==1001 then
         if _Map.Turn > 0 and _Map.Turn < 11 then                 --引导第一关结束 第一关结束 大引导结束
            if GuideSys.NowBigStep <= 5 then                     --引导1-5 副本结束 强制外部引导
                GuideSys.UIYindao = true
                 if _IsWin==0 then
                    GuideSys.NowSmallStep = 1
                 elseif _IsWin==1 then
                    GuideSys.SendGuideWebEvent()
                end
            end

            if GuideSys.NowBigStep==7 then
               if _Map.Turn == 6 then
                  if _IsWin==1 then
                     GuideSys.UIYindao = true
                  else
                     
                  end
               end
            end

            if GuideSys.NowBigStep==7 then
               if _Map.Turn == 7 then
                  GuideSys.UIYindao = true
                  if _IsWin==0 then
                     GuideSys.NowSmallStep = 1
                  elseif _IsWin==1 then
                     GuideSys.SendGuideWebEvent()
                  end
               end
            end

            if GuideSys.NowBigStep==9 then
               if _Map.Turn == 8 then
                  GuideSys.UIYindao = true
               end
            end

            if GuideSys.NowBigStep==10 then
               if _Map.Turn == 9 then
                  GuideSys.UIYindao = true
               end
            end

            if GuideSys.NowBigStep==10 then
               if _Map.Turn == 10 then
                  GuideSys.UIYindao = true
                  if _IsWin==0 then
                     GuideSys.NowSmallStep = 1
                  elseif _IsWin==1 then
                     GuideSys.SendGuideWebEvent()
                  end
               end
            end
         end
      end
     
end

function GuideSys.SendGuideWebEventUIPanel()
   if GuideSys.NowBigStep == 5 or GuideSys.NowBigStep == 7  then
      return
   end
   GuideSys.SendGuideWebEvent()
end

function GuideSys.SendGuideWebEvent()              --发送某个完结的引导到服务器
   local _info = tonumber(GuideSys.NowBigStep)
   WebEvent.SendGuide(_info , "GuideSys.SendGuideWebEventCallBack" , GuideSys.SendGuideWebEventCallBack)
end

function GuideSys.SendGuideWebEventCallBack(data , returnId)
   if returnId == 0 then
     --Debug.LogError("+1")          
     --Debug.LogError(GuideSys.NowBigStep) 
      GuideSys.NowSmallStep = 1   
      local _UIGuideTar = MainGameUI.FindPanelTarget("UIGuide")
      if _UIGuideTar~=nil then
         _UIGuideTar.UIGuideGob.gameObject:SetActive(false)
      end     
   end
end

GuideSys.WaitCB = nil
GuideSys.PauseGameCB = nil
function GuideSys.UpdateGuide(dt)
   if GuideSys.WaitFlag==true then
      GuideSys.WaitNowTime = GuideSys.WaitNowTime + dt
      if GuideSys.WaitNowTime >= GuideSys.WaitTotalTime then
         GuideSys.WaitFlag = false
         GuideSys.SendGuideUI()
         if GuideSys.WaitCB~=nil then
            GuideSys.WaitCB()
         end
         if GuideSys.PauseGameCB~=nil then
            GuideSys.PauseGameCB()
         end
      end
   end
end

function GuideSys.WaitSecond(_WaitSecond , CB)
    GuideSys.WaitCB = CB--GameMain.PauseBattleGame                            
    GuideSys.WaitFlag = true
    GuideSys.WaitNowTime = 0
    GuideSys.WaitTotalTime = _WaitSecond     
end

function GuideSys.CloseGuide()
   local _UIGuideTar = MainGameUI.FindPanelTarget("UIGuide")
   if _UIGuideTar~=nil then
      _UIGuideTar.UIGuideGob.gameObject:SetActive(false)
   end     
end

function GuideSys.OpenGuide()
   local _UIGuideTar = MainGameUI.FindPanelTarget("UIGuide")
   if _UIGuideTar~=nil then
      _UIGuideTar.UIGuideGob.gameObject:SetActive(true)
   end 
end

function GuideSys.CloseTempGuide()
   local _UIGuideTar = MainGameUI.FindPanelTarget("UIGuide")
   if _UIGuideTar~=nil then
      _UIGuideTar.TempStepGob.gameObject:SetActive(false)
   end     
end

function GuideSys.OpenTempGuide()
   local _UIGuideTar = MainGameUI.FindPanelTarget("UIGuide")
   if _UIGuideTar~=nil then
      _UIGuideTar.TempStepGob.gameObject:SetActive(true)
   end 
end

GuideSys.HeroIndex = 0
function GuideSys.OutHeroCallBack()
   GameMain.OutHero(GuideSys.HeroIndex)
end

function GuideSys.GuideSysComminfo(data)
   if data["value"]~=nil then
      GuideSys.NowBigStep = tonumber(data["value"]) + 1
   end
end

function GuideSys.ReleaseGuide()                       --释放引导
    GuideSys.TotalSmallStep = 0                         --小步骤总数

    GuideSys.NowBigStep = 0                             --当前大步骤Index
    GuideSys.NowSmallStep = 0                           --当前小步骤Index

    GuideSys.NowStepData = 0                            --当前步骤数据
    GuideSys.GuideState = true                          --全部引导结束false  引导true

    GuideSys.OutUI = true                               --外层UI True   战斗UI false
    GuideSys.UIYindao = false
    GuideSys.CloseGuide()
    GuideSys.CloseTempGuide()
end

return GuideSys