UITeamMake = {}

local UITeamMake = BasePanel:new()     
local this = UITeamMake
UITeamMake.UITeamMakeGob = nil
UITeamMake.TeamMakeFather = nil

UITeamMake.UICamera = nil
UITeamMake.TeamCa = nil
UITeamMake.MoveTeamMaker = nil
UITeamMake.BoxBg = nil
UITeamMake.Red = nil
UITeamMake.Green = nil

UITeamMake.UPHeros = {}

UITeamMake.NowTeamType = 1

UITeamMake.TeamMakeType = 1                        --pvp 1 JJC 2
UITeamMake.UpTeamLimit = 0
UITeamMake.CanChange = false
function UITeamMake:OpenUI(_PanelName , _LuaName)

    if UITeamMake.UITeamMakeGob==nil then
        UITeamMake.UITeamMakeGob = MainGameUI.FindPanel("UITeamMake")
        UITeamMake.UITeamMakeGob.transform.localPosition = Vector3(0 , 0 , -300)
        UITeamMake.UICamera = MainGameUI.GetUICameraInMainCity().gameObject:GetComponent("Camera")
        UITeamMake.TeamCa = GameMain.TeamMakeSys.transform:FindChild("TeamMakeCa").gameObject:GetComponent("Camera")
        UITeamMake.TeamMakeFather = GameMain.TeamMakeSys.transform:FindChild("TeamMake")
    end
    if UITeamMake.BoxBg == nil then
       UITeamMake.BoxBg = UITeamMake.UITeamMakeGob.transform:FindChild("BoxBg")
    end

    local UIControlTar = MainGameUI.FindPanelTarget("UIControl")
    UIControlTar:SetOutSideUIList(false)
    UIControlTar:SetAnchorTop(false)
    UIControlTar:SetAnchorTopLeft(false)    
    --UITeamMake.UITeamMakeGob.gameObject:SetActive(true)
   -- UITeamMake.TeamMakeFather.gameObject:SetActive(true)
   --GameMain.Print(TeamSys.PvpTeamInfo)
    UITeamMake.UpTeamLimit = LimitDataSys.GetPvPLimitCount()
    UITeamMake.NowTeamType = 0
    UITeamMake.CanChange = true
    this:ChangeType(1)
    this:CreateHeros()
    this:CreateSoliders()   
    this:InitGrayButton()    
    GameVersion.ChangeTeamVersion()
    LoadingPanel.StopChangeScenePanel()
end

UITeamMake.HeroGrid = nil
UITeamMake.HeroList = {}
UITeamMake.HeroGobList = {}
UITeamMake.HeroWrap = nil
UITeamMake.HeroPanelScrollView = nil
function UITeamMake:CreateHeros()
    if UITeamMake.HeroGrid == nil then
       UITeamMake.HeroGrid = UITeamMake.UITeamMakeGob.transform:FindChild("HeroList"):FindChild("Heros"):FindChild("HerosPanel"):FindChild("HeroGrid")
    end
    
    if UITeamMake.HeroPanelScrollView==nil then
       UITeamMake.HeroPanelScrollView = UITeamMake.UITeamMakeGob.transform:FindChild("HeroList"):FindChild("Heros"):FindChild("HerosPanel"):GetComponent("UIScrollView")
    end

    HeroPackageSys.GetHero()

    for i = 1 , #HeroPackageSys.Heros , 1 do
        UITeamMake.HeroList[i] =
        {
           HeroData = HeroPackageSys.Heros[i],
        } 
    end

    if #UITeamMake.HeroGobList==0 then
        for i = 1 ,  20 , 1 do
            local data = 
            {
                Index = i,
            }
            MainGameUI.CreateLittleItem("Hero_"..tostring(i) , "HeroItem" , UITeamMake.HeroGrid , data , this.CreateHerosCallBack  , "UITeamMake")
        end
    else
       
       UITeamMake.UITeamMakeGob.transform:FindChild("HeroList"):FindChild("Heros"):FindChild("HerosPanel").transform.localPosition = Vector3(0 , 0 , 0)
       UITeamMake.HeroWrap:ResetTrans(#HeroPackageSys.Heros)   
       UITeamMake.HeroGrid:GetComponent("UIGrid").enabled = true
       UITeamMake.HeroGrid:GetComponent("UIGrid"):Reposition()
    end
end

function UITeamMake:CreateHerosCallBack(_Gob , _Info)
    _Gob.transform:FindChild("HaveUp").gameObject:SetActive(false)
    if UITeamMake.HeroList[_Info.Index]~=nil then
        AtlasMsg.SetAtlas(_Gob.transform:FindChild("IMG"):GetComponent("UISprite") , UITeamMake.HeroList[_Info.Index].HeroData.AtlasName , UITeamMake.HeroList[_Info.Index].HeroData.SpriteName)
        AtlasMsg.SetAtlas(_Gob.transform:FindChild("FG"):GetComponent("UISprite") , UIstring.QualityAtlasName , UIstring.ItemFg[UITeamMake.HeroList[_Info.Index].HeroData.quality])
        AtlasMsg.SetAtlas(_Gob.transform:FindChild("bg"):GetComponent("UISprite") , UIstring.QualityBGAtlasName , UIstring.ItemFg[UITeamMake.HeroList[_Info.Index].HeroData.quality])
        _Gob.transform:FindChild("name"):GetComponent("UILabel").text = UIstring.WordColor[UITeamMake.HeroList[_Info.Index].HeroData.quality]..UITeamMake.HeroList[_Info.Index].HeroData.nickname    
        _Gob.transform:FindChild("Lvl"):GetComponent("UILabel").text = "Lv."..tostring(UITeamMake.HeroList[_Info.Index].HeroData:GetLvl())   
        if UITeamMake.UPHeros[UITeamMake.HeroList[_Info.Index].HeroData.UUID]~=nil then
           _Gob.transform:FindChild("HaveUp").gameObject:SetActive(true)
        end
    end
       
    UITeamMake.HeroGobList[_Info.Index] = 
    {
        HeroGob = _Gob,
    }

    if _Info.Index==20 then
       UITeamMake.HeroGrid:GetComponent("UIGrid").enabled = true
       UITeamMake.HeroGrid:GetComponent("UIGrid"):Reposition()
       if UITeamMake.HeroWrap==nil then
          UITeamMake.HeroWrap = UITeamMake.UITeamMakeGob.transform:FindChild("HeroList"):GetComponent("UIWrap")
       end
       UITeamMake.HeroWrap:SetData(#HeroPackageSys.Heros , "UITeamMake")
    end
end

UITeamMake.SoldierGrid = nil
UITeamMake.SoldierList = {}
UITeamMake.SoldierGobList = {}
UITeamMake.SoldierWrap = nil
UITeamMake.SoldierPanelScrollView = nil
function UITeamMake:CreateSoliders()
    if UITeamMake.SoldierGrid == nil then      
       UITeamMake.SoldierGrid = UITeamMake.UITeamMakeGob.transform:FindChild("SoldierList"):FindChild("Soldiers"):FindChild("SoldierPanel"):FindChild("SoldierGrid")
    end

    if UITeamMake.SoldierPanelScrollView==nil then
       UITeamMake.SoldierPanelScrollView = UITeamMake.UITeamMakeGob.transform:FindChild("SoldierList"):FindChild("Soldiers"):FindChild("SoldierPanel"):GetComponent("UIScrollView")
    end

    if TeamSys.TeamSysType==2 then
       UITeamMake.UITeamMakeGob.transform:FindChild("SoldierList").gameObject:SetActive(false)
       return
    else
       UITeamMake.UITeamMakeGob.transform:FindChild("SoldierList").gameObject:SetActive(true)
    end

    SoliderPackageSys.GetSoliders()

    for i = 1 , #SoliderPackageSys.Soliders , 1 do
        UITeamMake.SoldierList[i] = 
        {
            SoldierData = SoliderPackageSys.Soliders[i]
        }
    end

    if #UITeamMake.SoldierGobList==0 then
        for i = 1 ,  20 , 1 do
            local data = 
            {
                Index = i,
            }
            MainGameUI.CreateLittleItem("Soldier_"..tostring(i) , "HeroItem" , UITeamMake.SoldierGrid , data , this.CreateSoldierCallBack  , "UITeamMake")
        end
    else
       UITeamMake.UITeamMakeGob.transform:FindChild("SoldierList"):FindChild("Soldiers"):FindChild("SoldierPanel").transform.localPosition = Vector3(0 , 0 , 0)
       UITeamMake.SoldierWrap:ResetTrans(#SoliderPackageSys.Soliders)
       UITeamMake.SoldierGrid:GetComponent("UIGrid").enabled = true
       UITeamMake.SoldierGrid:GetComponent("UIGrid"):Reposition()
    end
end

function UITeamMake:CreateSoldierCallBack(_Gob , _Info)
    if UITeamMake.SoldierList[_Info.Index]~=nil then
        AtlasMsg.SetAtlas(_Gob.transform:FindChild("IMG"):GetComponent("UISprite") , UITeamMake.SoldierList[_Info.Index].SoldierData.AtlasName , UITeamMake.SoldierList[_Info.Index].SoldierData.SpriteName)
        AtlasMsg.SetAtlas(_Gob.transform:FindChild("FG"):GetComponent("UISprite") , UIstring.QualityAtlasName , UIstring.ItemFg[UITeamMake.SoldierList[_Info.Index].SoldierData.quality])
        AtlasMsg.SetAtlas(_Gob.transform:FindChild("bg"):GetComponent("UISprite") , UIstring.QualityBGAtlasName , UIstring.ItemFg[UITeamMake.SoldierList[_Info.Index].SoldierData.quality])
        _Gob.transform:FindChild("name"):GetComponent("UILabel").text = UIstring.WordColor[UITeamMake.SoldierList[_Info.Index].SoldierData.quality]..UITeamMake.SoldierList[_Info.Index].SoldierData.nickname
        _Gob.transform:FindChild("Lvl"):GetComponent("UILabel").text = "Lv."..tostring(UITeamMake.SoldierList[_Info.Index].SoldierData:GetLvl())
    end
    UITeamMake.SoldierGobList[_Info.Index] = 
    {
        SoldierGob = _Gob,
    }
    if _Info.Index==20 then
       UITeamMake.SoldierGrid:GetComponent("UIGrid").enabled = true
       UITeamMake.SoldierGrid:GetComponent("UIGrid"):Reposition()
       if UITeamMake.SoldierWrap == nil then
          UITeamMake.SoldierWrap = UITeamMake.UITeamMakeGob.transform:FindChild("SoldierList"):GetComponent("UIWrap")
       end
       UITeamMake.SoldierWrap:SetData(#SoliderPackageSys.Soliders , "UITeamMake")
    end 
end

function UITeamMake:Create3DHeroModel(_FbxName)
   if UITeamMake.MoveTeamMaker==nil then    
      Create3DModel.CreateThModel(_FbxName , "run" , 10 , nil , UITeamMake.Create3DHeroModelCallBack  , true , data)         
   end
end

function UITeamMake.Create3DHeroModelCallBack(_Model , _Data)
   _Model.transform.localPosition = Vector3(-100000 ,-100000 , 0)
   local data =
   {
       Model = _Model,
   }
   MainGameUI.CreateLittleItem("Model" , "HeroMake" , UITeamMake.TeamMakeFather  , data , this.Create3DHeroModelCallBack2 , "UITeamMake")
end

function UITeamMake:Create3DHeroModelCallBack2(_Gob , _Info)
   if UITeamMake.MoveTeamMaker==nil then
      _Gob.transform.localScale = Vector3(1 , 1 , 1)
      _Gob.transform.localEulerAngles = Vector3(0 , 0 , 0)
      _Gob.transform.localPosition = Vector3(-100000 ,-100000 , 0)
      _Info.Model.transform.parent = _Gob.transform:FindChild("Position")
      _Info.Model.transform.localPosition = Vector3(0 , 0 , 0)
      _Info.Model.transform.localScale = Vector3(1 , 1 , 1)
      _Info.Model.transform.localEulerAngles = Vector3(0 , 0 , 0)
      UITeamMake.MoveTeamMaker = _Gob
      UITeamMake.Red = UITeamMake.MoveTeamMaker.transform:FindChild("Red")
      UITeamMake.Green = UITeamMake.MoveTeamMaker.transform:FindChild("Green")
   else
      GameObject.Destroy(_Gob)
   end
end

function UITeamMake:Create3DSoldierModel(_FbxName) 
    local data = 
    {
       ModelName = _FbxName,
    }
    MainGameUI.CreateLittleItem("Model" , _FbxName , UITeamMake.TeamMakeFather  , data , this.Create3DSoldierModelCallBack , "UITeamMake")   
end

function UITeamMake:Create3DSoldierModelCallBack(_Gob , _Info)
   if UITeamMake.MoveTeamMaker==nil then    
      _Gob.transform.localScale = Vector3(1 , 1 , 1)
      _Gob.transform.localEulerAngles = Vector3(0 , 0 , 0)
      _Gob.transform.localPosition = Vector3(-100000 ,-100000 , 0)
      UITeamMake.MoveTeamMaker = _Gob
      UITeamMake.Red = UITeamMake.MoveTeamMaker.transform:FindChild("Red")
      UITeamMake.Green = UITeamMake.MoveTeamMaker.transform:FindChild("Green")
   else
      GameObject.Destroy(_Gob)
   end
end

function UITeamMake:Create3DHeroModelInit(_UpHeroInfo , i , _TotalIndex)          --刚进入界面需要创建上次布阵的人物
    local _Hero = HeroPackageSys.GetOneHeroBy_UUID(_UpHeroInfo.HeroData.UUID)
    local data = 
    {
        UpHeroInfo = _UpHeroInfo,
        Index = i,
        TotalIndex = _TotalIndex,
    }
  
    Create3DModel.CreateThModel(_Hero.roleData.FbxName , "run" , 10 , nil , UITeamMake.Create3DHeroModelInitCallBack  , true , data)        
end

function UITeamMake.Create3DHeroModelInitCallBack(_Model , _data)
   _Model.transform.localPosition = Vector3(-100000 ,-100000 , 0)
   local data = 
   {
      Model = _Model,
      UpHeroInfo = _data.UpHeroInfo,
      Index = _data.Index,
      TotalIndex = _data.TotalIndex,
   }

   local Name = "TeamHero_"..tostring(_data.UpHeroInfo.X).."_"..tostring(_data.UpHeroInfo.Y)
   MainGameUI.CreateLittleItem(Name , "HeroMake" , UITeamMake.TeamMakeFather  , data , this.Create3DHeroModelInitCallBack2 , "UITeamMake")
end

function UITeamMake:Create3DHeroModelInitCallBack2(_Gob , _Info)
    _Info.UpHeroInfo.HeroModel = _Gob
    _Info.Model.transform.parent = _Gob.transform:FindChild("Position")
    _Info.Model.transform.localPosition = Vector3(0 , 0 , 0)
    _Info.Model.transform.localScale = Vector3(1 , 1 , 1)
    _Info.Model.transform.localEulerAngles = Vector3(0 , 0 , 0)
    local Point = TeamMakeSys.GetPointByNum(_Info.UpHeroInfo.X , _Info.UpHeroInfo.Y)
    _Gob.transform.localPosition = Vector3(Point.PosX , Point.PosY , 0)
    if TeamSys.TeamSysType == 1 then
       this:Create3DSoldierModelInit(_Info.UpHeroInfo , _Info.Index , _Info.TotalIndex)
    end
    if TeamSys.TeamSysType==2 then
       if _Info.TotalIndex == _Info.Index then
          UITeamMake.CanChange = true
       end
    end
end


function UITeamMake:Create3DSoldierModelInit(_UpHeroInfo , _Index , _TotalIndex)       --刚进入界面需要创建上次布阵的人物 士兵
   

    local _SoldierData = SoliderPackageSys.GetOneSolider(_UpHeroInfo.SoldierId)--_UpHeroInfo.SoldierId)
    if _SoldierData==nil then
       
    end

    local data = 
    {
       UpHeroInfo = _UpHeroInfo,
       Index = _Index,
       TotalIndex = _TotalIndex,
    }
--	GameMain.Print(_SoldierData , "data")
    MainGameUI.CreateLittleItem("Model" , _SoldierData.roleData.FbxName , UITeamMake.TeamMakeFather  , data , this.Create3DSoldierModelInitCallBack , "UITeamMake")
end

function UITeamMake:Create3DSoldierModelInitCallBack(_Gob , _Info)
    local _UpHero = _Info.UpHeroInfo
    _Gob.transform.parent = _UpHero.HeroModel.transform
    _Gob.transform.localPosition = Vector3(-0.4 , 0 , 0) 
    _Gob.transform.name = "SoldierModel"  
    if _Info.Index == _Info.TotalIndex then
       UITeamMake.CanChange = true
    end
end

function UITeamMake:UIOnPress( _LuaName , _Gob , _isPress)   
   -- Debug.LogError(_Gob)
    if _isPress==false then                                     --抬起放下队伍
       local NameList = GameMain.StringSplit(_Gob.name , "_")
       if #NameList==2 then
          if NameList[1]=="Hero" then
             this:PutDownHero()       
          end
          if NameList[1]== "Soldier" then            
             this:PutDownSolider()
          end
       end
       if #NameList==3 then
          if NameList[1]=="TeamHero" then
             this:PutDownHero()
          end 
       end
    end
end

UITeamMake.TempHero = nil
UITeamMake.TempSoldier = nil
UITeamMake.MoveType = 1
function UITeamMake:UIDragEvent( _LuaName , _Gob , _Detal)   
   --Debug.LogError(_Gob)
 -- Debug.LogError(_Detal)
    if UITeamMake.MoveTeamMaker==nil then
       local NameList = GameMain.StringSplit(_Gob.name , "_")
       if #NameList==2 then
          if NameList[1]=="Hero" then           
             UITeamMake.MoveType = 1
             local Index = tonumber(NameList[2])
             local HeroData = UITeamMake.HeroList[Index].HeroData
             local TempHero = this:FindHeroByUUID(HeroData.UUID)
             if TempHero~=nil then
                DataUIInstance.PopTip("V9")
                return
             end
             UITeamMake.TempHero = HeroData
             local FbxName = HeroData.roleData.FbxName
             this:Create3DHeroModel(FbxName)
          elseif NameList[1]=="Soldier" then
             UITeamMake.MoveType = 2
             local Index = tonumber(NameList[2])
             local SoldierData = UITeamMake.SoldierList[Index].SoldierData
             UITeamMake.TempSoldier = SoldierData
             local FbxName = SoldierData.roleData.FbxName
             this:Create3DSoldierModel(FbxName)
          end
       end 
       if #NameList==3 then
          --Debug.LogError(GuideSys.NowSmallStep)
          if NameList[1]=="TeamHero" and GuideSys.NowBigStep~=2 and GuideSys.NowSmallStep~=5 then  
             UITeamMake.MoveType = 1      
             local PointInfo = GameMain.StringSplit(_Gob.name , "_")         
             local TempX = tonumber(PointInfo[2])
             local TempY = tonumber(PointInfo[3])
             TeamMakeSys.ClearPutPoint(TempX , TempY)             --选择当前摆放好的队伍 清除队伍占用点
             local TempHero = this:FindUpHeroByPos(TempX , TempY).HeroData
             if TempHero~=nil then
                UITeamMake.TempHero = TempHero
                --UITeamMake.UPHeros[UITeamMake.TempHero.UUID] = nil
             end
             UITeamMake.MoveTeamMaker = _Gob 
             UITeamMake.Red = UITeamMake.MoveTeamMaker.transform:FindChild("Red")
             UITeamMake.Green = UITeamMake.MoveTeamMaker.transform:FindChild("Green")  
          end
       end
    end
   
    if UITeamMake.MoveTeamMaker~=nil then
       local ray = UITeamMake.TeamCa:ScreenPointToRay(Input.mousePosition)
       GameMain.GetHitRay(ray,1000,UITeamMake.LateUpdateRay)
    end 
end

function UITeamMake:UIDragUpEvent( _LuaName , _Gob , _UpGob , _DragGob)
 -- Debug.LogError(_Gob)
 -- Debug.LogError(_UpGob)
 -- Debug.LogError(_DragGob)

   if _Gob.name == "Model" then
      if UITeamMake.MoveTeamMaker~=nil then
          UITeamMake.MoveTeamMaker.transform.position = Vector3(-100 , -100 , 0)--]]
          GameObject.Destroy(UITeamMake.MoveTeamMaker.gameObject)
          UITeamMake.MoveTeamMaker = nil
          this:CloseColor()
      end
      return
   end
   --[[local Type = GameMain.StringSplit(_UpGob.name , "_")  
   if Type[1]=="Soldier" then
       local PointInfo = GameMain.StringSplit(_Gob.name , "_")  
       if PointInfo==nil then
          return
       end       
       local TempX = tonumber(PointInfo[2])
       local TempY = tonumber(PointInfo[3])
       this:PutDownSolider(TempX , TempY)
   end--]]
end


function UITeamMake:UIHand(_LuaName , _Gob)
  MusicManagerSys.ButtonClick()
	 if _Gob.name == "BackButton" then
   
   elseif _Gob.name == "TeamOne" then
      this:ChangeType(1)
      this:UpdateUpHerosFlag()
   elseif _Gob.name == "TeamTwo" then
      this:ChangeType(2)
      this:UpdateUpHerosFlag()
   elseif _Gob.name == "TeamThree" then
      this:ChangeType(3)
      this:UpdateUpHerosFlag()
   elseif _Gob.name == "TeamFour" then
      this:ChangeType(4)
      this:UpdateUpHerosFlag()
   elseif _Gob.name == "SaveTeam" then
      this:JudgeSaveTeam()  
   elseif _Gob.name == "Sure" then
      this:TipSaveTeam()  
   elseif _Gob.name == "Cancel" then     
      this:CloseTipPanel() 
   end
   
end

function UITeamMake:UpdateItem(_LuaName , _Item)
   local ParentName = _Item.parent.name
   if ParentName~=nil then
      if ParentName == "SoldierGrid" then
         local _Info = GameMain.StringSplit(_Item.name , "_") 
         if #_Info==2 then
            local _Index = tonumber(_Info[2])
            if UITeamMake.SoldierList[_Index]==nil then
               return
            end
            local _Sprite = _Item.transform:FindChild("IMG"):GetComponent("UISprite")
            AtlasMsg.SetAtlas(_Sprite , UITeamMake.SoldierList[_Index].SoldierData.AtlasName , UITeamMake.SoldierList[_Index].SoldierData.SpriteName)
            _Sprite = _Item.transform:FindChild("FG"):GetComponent("UISprite")
            AtlasMsg.SetAtlas(_Sprite , UIstring.QualityAtlasName , UIstring.ItemFg[UITeamMake.SoldierList[_Index].SoldierData.quality])
            _BSprite = _Item.transform:FindChild("bg"):GetComponent("UISprite")
            AtlasMsg.SetAtlas(_BSprite , UIstring.QualityBGAtlasName , UIstring.ItemFg[UITeamMake.SoldierList[_Index].SoldierData.quality])
            _Item.transform:FindChild("name"):GetComponent("UILabel").text = UIstring.WordColor[UITeamMake.SoldierList[_Index].SoldierData.quality]..UITeamMake.SoldierList[_Index].SoldierData.nickname            
            _Item.transform:FindChild("Lvl"):GetComponent("UILabel").text = "Lv."..tostring(UITeamMake.SoldierList[_Index].SoldierData:GetLvl())         
         elseif #_Info==1 then
            local _Index = tonumber(_Info[1])
            if UITeamMake.SoldierList[_Index]==nil then
               return
            end
            local _Sprite = _Item.transform:FindChild("IMG"):GetComponent("UISprite")
            AtlasMsg.SetAtlas(_Sprite , UITeamMake.SoldierList[_Index].SoldierData.AtlasName , UITeamMake.SoldierList[_Index].SoldierData.SpriteName)
            _Sprite = _Item.transform:FindChild("FG"):GetComponent("UISprite")
            AtlasMsg.SetAtlas(_Sprite , UIstring.QualityAtlasName , UIstring.ItemFg[UITeamMake.SoldierList[_Index].SoldierData.quality])
            _BSprite = _Item.transform:FindChild("bg"):GetComponent("UISprite")
            AtlasMsg.SetAtlas(_BSprite , UIstring.QualityBGAtlasName , UIstring.ItemFg[UITeamMake.SoldierList[_Index].SoldierData.quality])
            _Item.transform:FindChild("name"):GetComponent("UILabel").text =UIstring.WordColor[UITeamMake.SoldierList[_Index].SoldierData.quality]..UITeamMake.SoldierList[_Index].SoldierData.nickname         
            _Item.transform:FindChild("Lvl"):GetComponent("UILabel").text = "Lv."..tostring(UITeamMake.SoldierList[_Index].SoldierData:GetLvl())
            _Item.name = "Soldier_".._Item.name
         end
        
      end
      if ParentName == "HeroGrid" then
         local _Info = GameMain.StringSplit(_Item.name , "_") 
         if #_Info==2 then
            local _Index = tonumber(_Info[2])
            if UITeamMake.HeroList[_Index]==nil then
               return
            end
            local _Sprite = _Item.transform:FindChild("IMG"):GetComponent("UISprite")          
            AtlasMsg.SetAtlas(_Sprite , UITeamMake.HeroList[_Index].HeroData.AtlasName , UITeamMake.HeroList[_Index].HeroData.SpriteName)
            _Sprite = _Item.transform:FindChild("FG"):GetComponent("UISprite")
            AtlasMsg.SetAtlas(_Sprite , UIstring.QualityAtlasName , UIstring.ItemFg[UITeamMake.HeroList[_Index].HeroData.quality])
            _BSprite = _Item.transform:FindChild("bg"):GetComponent("UISprite")
            AtlasMsg.SetAtlas(_BSprite , UIstring.QualityBGAtlasName , UIstring.ItemFg[UITeamMake.HeroList[_Index].HeroData.quality])
            _Item.transform:FindChild("name"):GetComponent("UILabel").text =UIstring.WordColor[UITeamMake.HeroList[_Index].HeroData.quality]..UITeamMake.HeroList[_Index].HeroData.nickname
            _Item.transform:FindChild("Lvl"):GetComponent("UILabel").text = "Lv."..tostring(UITeamMake.HeroList[_Index].HeroData:GetLvl())  
            _Item.transform:FindChild("HaveUp").gameObject:SetActive(false)
            if UITeamMake.UPHeros[UITeamMake.HeroList[_Index].HeroData.UUID]~=nil then
               _Item.transform:FindChild("HaveUp").gameObject:SetActive(true)
            end
         elseif #_Info==1 then
            local _Index = tonumber(_Info[1])
            if UITeamMake.HeroList[_Index]==nil then
               return
            end
            local _Sprite = _Item.transform:FindChild("IMG"):GetComponent("UISprite")
            AtlasMsg.SetAtlas(_Sprite , UITeamMake.HeroList[_Index].HeroData.AtlasName , UITeamMake.HeroList[_Index].HeroData.SpriteName)
            _Sprite = _Item.transform:FindChild("FG"):GetComponent("UISprite")
            AtlasMsg.SetAtlas(_Sprite , UIstring.QualityAtlasName , UIstring.ItemFg[UITeamMake.HeroList[_Index].HeroData.quality])
            _BSprite = _Item.transform:FindChild("bg"):GetComponent("UISprite")
            AtlasMsg.SetAtlas(_BSprite , UIstring.QualityBGAtlasName , UIstring.ItemFg[UITeamMake.HeroList[_Index].HeroData.quality])
            _Item.transform:FindChild("name"):GetComponent("UILabel").text =UIstring.WordColor[UITeamMake.HeroList[_Index].HeroData.quality]..UITeamMake.HeroList[_Index].HeroData.nickname
            _Item.transform:FindChild("Lvl"):GetComponent("UILabel").text = "Lv."..tostring(UITeamMake.HeroList[_Index].HeroData:GetLvl())  
            _Item.transform:FindChild("HaveUp").gameObject:SetActive(false)
            if UITeamMake.UPHeros[UITeamMake.HeroList[_Index].HeroData.UUID]~=nil then
               _Item.transform:FindChild("HaveUp").gameObject:SetActive(true)
            end
            _Item.name = "Hero_".._Item.name
         end
        
      end
   end
end

function UITeamMake.LateUpdateRay(terHit,hitInfo)
   if terHit==false then
      return
   end

   UITeamMake.HitInfo = hitInfo
   local pos = Vector3(hitInfo.point.x,hitInfo.point.y,hitInfo.point.z)
   this:SetTeamPos(UITeamMake.MoveTeamMaker , pos.x , pos.y , hitInfo)
end

UITeamMake.Point = nil
UITeamMake.TempGreen = nil
UITeamMake.HitInfo = nil
function UITeamMake:SetTeamPos(_Gob , _WorldX , _WorldY , hitInfo)                --实时更新拖动位置
   local Point = TeamMakeSys.GetPoint(_WorldX , _WorldY)
   if Point==nil then    
      return
   end
   if UITeamMake.Point ~= Point then
      UITeamMake.Point = Point
      _Gob.transform.position = Vector3(Point.PosX ,Point.PosY , 0)
      if UITeamMake.MoveType == 1 then
          if TeamMakeSys.JudgePoint(UITeamMake.Point)==true then            --是否有位置被占 或者 在范围之外
             UITeamMake.HeroPanelScrollView.enabled = false
             if _Gob~=nil  then                                                              --合法
                if UITeamMake.Red~=nil then
                    if UITeamMake.Red.gameObject.activeInHierarchy==true then
                       UITeamMake.Red.gameObject:SetActive(false)
                    end
                    if UITeamMake.Green.gameObject.activeInHierarchy==false then
                       UITeamMake.Green.gameObject:SetActive(true)
                    end 
                end
             end
          else
             UITeamMake.HeroPanelScrollView.enabled = false
             if _Gob~=nil  then                                                              --非合法
                if UITeamMake.Red~=nil then
                    if UITeamMake.Red.gameObject.activeInHierarchy==false then
                       UITeamMake.Red.gameObject:SetActive(true)
                    end
                    if UITeamMake.Green.gameObject.activeInHierarchy==true then
                       UITeamMake.Green.gameObject:SetActive(false)
                    end 
                end
             end
          end
      elseif UITeamMake.MoveType == 2 then                                                   --士兵
                                                          
          UITeamMake.SoldierPanelScrollView.enabled = false
          if hitInfo.transform.name~="TeamMakeBox" then
             local nameList = GameMain.StringSplit(hitInfo.transform.name , "_")
             if #nameList==3 then
                 local _X = tonumber(nameList[2])
                 local _Y = tonumber(nameList[3])
                 local TempHero = this:FindUpHeroByPos(_X , _Y).HeroData
                 if TempHero~=nil then
                    local _UUID = TempHero.UUID
                    local _UpHero = UITeamMake.UPHeros[_UUID]                    
                    _UpHero.HeroModel.transform:FindChild("Green").gameObject:SetActive(true)
                    if UITeamMake.TempGreen==nil then
                       UITeamMake.TempGreen = _UpHero.HeroModel.transform:FindChild("Green").gameObject                  
                    else 
                        if UITeamMake.TempGreen~=_UpHero.HeroModel.transform:FindChild("Green").gameObject then
                           UITeamMake.TempGreen.gameObject:SetActive(false) 
                           UITeamMake.TempGreen = _UpHero.HeroModel.transform:FindChild("Green").gameObject                     
                        end                  
                    end
                 else
                    if UITeamMake.TempGreen~=nil then
                       UITeamMake.TempGreen.gameObject:SetActive(false)
                    end
                 end
             end
          else
              if UITeamMake.TempGreen~=nil then
                 UITeamMake.TempGreen.gameObject:SetActive(false)
              end
          end
          
      end
      --[[if UITeamMake.BoxBg~=nil then
         if UITeamMake.BoxBg.gameObject.activeInHierarchy==false then
            UITeamMake.BoxBg.gameObject:SetActive(true)
         end
      end--]]
   end
end

function UITeamMake:PutDownHero()
  -- GameMain.Print(UITeamMake.Point)
   if UITeamMake.MoveTeamMaker~=nil then
       if TeamMakeSys.JudgePoint(UITeamMake.Point)==true then               --当前35个点没有被占 放下英雄
          if UITeamMake.MoveTeamMaker.transform.name=="Model" then         
             if UITeamMake.HeroNum + 1 > UITeamMake.UpTeamLimit then
                DataUIInstance.PopTip("U8")
                UITeamMake.Point = nil
                GameObject.Destroy(UITeamMake.MoveTeamMaker.gameObject) 
                UITeamMake.MoveTeamMaker = nil
                UITeamMake.HeroPanelScrollView.enabled = true                 
                this:CloseColor()
                return
             end
          end
          TeamMakeSys.PutDownTeamMake(UITeamMake.Point)  
          UITeamMake.MoveTeamMaker.transform.name = "TeamHero_"..tostring(UITeamMake.Point.X).."_"..tostring(UITeamMake.Point.Y)   
          this:SetTeamHero(UITeamMake.TempHero , UITeamMake.Point.X , UITeamMake.Point.Y , UITeamMake.MoveTeamMaker)   
          this:UpdateUpHerosFlag()
          this:SetTeamHeroNum()
       else
          local _Poses = GameMain.StringSplit(UITeamMake.MoveTeamMaker.transform.name , "_")                                                                 --当前格子超出范围 也就是取消该英雄的布阵
          local _UpHeroInfo = this:FindUpHeroByPos(tonumber(_Poses[2]) , tonumber(_Poses[3]))
          if _UpHeroInfo ~= nil then
             local _UUID = _UpHeroInfo.HeroData.UUID
             UITeamMake.UPHeros[_UUID] = nil
             this:UpdateUpHerosFlag()
             this:SetTeamHeroNum()
          end
          UITeamMake.MoveTeamMaker.transform.position = Vector3(-100 , -100 , 0)
          GameObject.Destroy(UITeamMake.MoveTeamMaker.gameObject)     
       end
   end
   if UITeamMake.TempGreen~=nil then
      UITeamMake.TempGreen.gameObject:SetActive(false)
      UITeamMake.TempGreen = nil
   end
   UITeamMake.Point = nil
   UITeamMake.MoveTeamMaker = nil
   UITeamMake.HeroPanelScrollView.enabled = true
   this:CloseColor()
end

function UITeamMake:GuidePutHero()
   UITeamMake.Point = TeamMakeSys.GetPoint(5.25 , 6.45)
   UITeamMake.MoveTeamMaker.transform.position = Vector3(UITeamMake.Point.PosX ,UITeamMake.Point.PosY , 0)
   this:PutDownHero()
end

function UITeamMake:PutDownSolider()--_X , _Y)                              --放下士兵 设置士兵信息到队伍系统 
    --Debug.LogError("2222")
    local _X = 0
    local _Y = 0
   -- Debug.LogError(UITeamMake.HitInfo.transform)
    if UITeamMake.HitInfo==nil then 
       return
    end
    if UITeamMake.HitInfo.transform==nil  then
       return
    end
    if UITeamMake.MoveTeamMaker==nil then
       return
    end
    if UITeamMake.HitInfo.transform.name~="TeamMakeBox" then
       local nameList = GameMain.StringSplit(UITeamMake.HitInfo.transform.name , "_")
       if #nameList==3 then
          _X = tonumber(nameList[2])
          _Y = tonumber(nameList[3])              
       end         
    else
       GameObject.Destroy(UITeamMake.MoveTeamMaker.gameObject)
       if UITeamMake.TempGreen~=nil then
          UITeamMake.TempGreen.gameObject:SetActive(false)
          UITeamMake.TempGreen = nil
       end
       UITeamMake.MoveTeamMaker = nil  
       UITeamMake.SoldierPanelScrollView.enabled = true    
       this:CloseColor()
       return
    end
 

   local TempHero = this:FindUpHeroByPos(_X , _Y).HeroData
   if TempHero~=nil then
      local _UUID = TempHero.UUID
      local _UpHero = UITeamMake.UPHeros[_UUID]
      if _UpHero~=nil then
         local _LastSoldierModel = _UpHero.HeroModel.transform:FindChild("SoldierModel")
         if _LastSoldierModel~=nil then
            GameObject.Destroy(_LastSoldierModel.gameObject)
         end
         UITeamMake.MoveTeamMaker.transform.parent = _UpHero.HeroModel.transform
         UITeamMake.MoveTeamMaker.transform.localPosition = Vector3(-0.4 , 0 , 0) 
         UITeamMake.MoveTeamMaker.transform.name = "SoldierModel"     
         this:SetTeamSoldier(_UUID , UITeamMake.TempSoldier.Dbid)
        
         UITeamMake.MoveTeamMaker = nil
         UITeamMake.SoldierPanelScrollView.enabled = true
         this:CloseColor()
         if UITeamMake.TempGreen~=nil then
            UITeamMake.TempGreen.gameObject:SetActive(false)
            UITeamMake.TempGreen = nil
         end
      end
   
   else
      GameObject.Destroy(UITeamMake.MoveTeamMaker.gameObject)
       if UITeamMake.TempGreen~=nil then
          UITeamMake.TempGreen.gameObject:SetActive(false)
          UITeamMake.TempGreen = nil
       end
       UITeamMake.MoveTeamMaker = nil  
       UITeamMake.SoldierPanelScrollView.enabled = true    
       this:CloseColor()
       return
   end
end

function UITeamMake:GuidePutSoldier()
   local _X = 17
   local _Y = 21
   local TempHero = this:FindUpHeroByPos(_X , _Y).HeroData
  -- GameMain.Print(TempHero)
   if TempHero~=nil then
      local _UUID = TempHero.UUID
      local _UpHero = UITeamMake.UPHeros[_UUID]
      if _UpHero~=nil then
         local _LastSoldierModel = _UpHero.HeroModel.transform:FindChild("SoldierModel")
         if _LastSoldierModel~=nil then
            GameObject.Destroy(_LastSoldierModel.gameObject)
         end
         UITeamMake.MoveTeamMaker.transform.parent = _UpHero.HeroModel.transform
         UITeamMake.MoveTeamMaker.transform.localPosition = Vector3(-0.4 , 0 , 0) 
         UITeamMake.MoveTeamMaker.transform.name = "SoldierModel"     
         this:SetTeamSoldier(_UUID , UITeamMake.TempSoldier.Dbid)
        
         UITeamMake.MoveTeamMaker = nil
         UITeamMake.SoldierPanelScrollView.enabled = true
         this:CloseColor()
         if UITeamMake.TempGreen~=nil then
            UITeamMake.TempGreen.gameObject:SetActive(false)
            UITeamMake.TempGreen = nil
         end
      end
   else
      GameObject.Destroy(UITeamMake.MoveTeamMaker.gameObject)
       if UITeamMake.TempGreen~=nil then
          UITeamMake.TempGreen.gameObject:SetActive(false)
          UITeamMake.TempGreen = nil
       end
       UITeamMake.MoveTeamMaker = nil  
       UITeamMake.SoldierPanelScrollView.enabled = true    
       this:CloseColor()
       return
   end
end

function UITeamMake:GuideDelete(args)

end

function UITeamMake:SetTeamHero(_Hero , _X , _Y , _HeroGob)             --设置上阵英雄的数据层
   if TeamSys.TeamSysType == 1 then
       if UITeamMake.UPHeros[_Hero.UUID]==nil then
          local _SoldierId = 0
          if _Hero.DefaultSoldier~=nil then
             for i = 1 , #SoliderPackageSys.Soliders , 1 do
                 if _Hero.DefaultSoldier==SoliderPackageSys.Soliders[i].roleData.RealId then
                    _SoldierId = SoliderPackageSys.Soliders[i].roleData.Id
                 end
             end
          end
          UITeamMake.UPHeros[_Hero.UUID] = 
          {
             X = _X,
             Y = _Y,
             HeroData = _Hero,
             HeroModel = _HeroGob,
             SoldierId = _SoldierId,
          }
          this:Create3DSoldierModelInit(UITeamMake.UPHeros[_Hero.UUID])
       else
          UITeamMake.UPHeros[_Hero.UUID] = 
          {
             X = _X,
             Y = _Y,
             HeroData = _Hero,
             HeroModel = _HeroGob,
             SoldierId = UITeamMake.UPHeros[_Hero.UUID].SoldierId,
          }
       end
   else       
       UITeamMake.UPHeros[_Hero.UUID] = 
       {
          X = _X,
          Y = _Y,
          HeroData = _Hero,
          HeroModel = _HeroGob,
       }       
   end
end

function UITeamMake:SetTeamSoldier(_HeroUUID , _SoldierId)           --设置上阵士兵的数据层
   UITeamMake.UPHeros[_HeroUUID].SoldierId = _SoldierId
   --GameMain.Print(UITeamMake.UPHeros)
end

function UITeamMake:FindHeroByUUID(_UUID)
   if UITeamMake.UPHeros[_UUID]~=nil then
      return UITeamMake.UPHeros[_UUID].HeroData
   else
      return nil
   end
end

function UITeamMake:FindUpHeroByPos(_X , _Y)
   for key , value in pairs(UITeamMake.UPHeros) do
       if value.X==_X and value.Y==_Y then
          return value
       end
   end
   return nil
end

function UITeamMake:JudgeSaveTeam()
   if UITeamMake.HeroNum==0 then
      DataUIInstance.PopTip("W1")
      return
   end

   if UITeamMake.HeroNum < UITeamMake.UpTeamLimit then
      this:OpenTipPanel()
   else
      this:SaveHero()
   end
end

function UITeamMake:SaveHero()
   
   if TeamSys.TeamSysType == 1 then
       TeamSys.SetPvpHeroInfo(UITeamMake.UPHeros , UITeamMake.NowTeamType)
       TeamSys.SavePvpTeam()
    else
       TeamSys.SetJJCHeroInfo(UITeamMake.UPHeros , UITeamMake.NowTeamType)
       TeamSys.SaveJJCTeam()
    end   
    this:ClosePanel()
end

function UITeamMake:ClosePanel()
    UITeamMake.UITeamMakeGob.gameObject:SetActive(false)
    GameMain.TeamMakeSys.gameObject:SetActive(false)
    local UIControlTar = MainGameUI.FindPanelTarget("UIControl")
    UIControlTar:SetOutSideUIList(true)
    UIControlTar:SetAnchorTop(true)
    UIControlTar:SetAnchorTopLeft(true)
end

function UITeamMake:ChangeType(_TeamType)
    if UITeamMake.CanChange==false then
       return
    end
    if _TeamType== UITeamMake.NowTeamType then
       return
    end
    UITeamMake.CanChange = false
    if TeamSys.TeamSysType == 1 then
       this:ChangePvpTeam(_TeamType)
    else
       this:ChangeJJCTeam(_TeamType)
    end
    this:ChangeChoseButton(_TeamType)
    --this:UpdateUpHerosFlag()
    this:SetTeamHeroNum()
    --this:SetTeamHeroNumShow()
end

function UITeamMake:ChangePvpTeam(_TeamType)
    TeamSys.SetPvpHeroInfo(UITeamMake.UPHeros , UITeamMake.NowTeamType)        --保存Pvp阵容

    TeamSys.SetPvpTeamType(_TeamType) 
    local _TeamInfo = TeamSys.GetTeamInfoByType(_TeamType)
    UITeamMake.NowTeamType = _TeamType
    this:DestroyHeroModel()

    UITeamMake.UPHeros = {}
    this:ClearPutDownTeam()
    if _TeamInfo~=nil then
       for i = 1 , #_TeamInfo , 1 do         
           if UITeamMake.UPHeros[_TeamInfo[i].PvpHeroUUID]==nil then
              UITeamMake.UPHeros[_TeamInfo[i].PvpHeroUUID] = {}
           end
           local _Hero = HeroPackageSys.GetOneHeroBy_UUID(_TeamInfo[i].PvpHeroUUID)
           UITeamMake.UPHeros[_TeamInfo[i].PvpHeroUUID] = 
           {
                X = _TeamInfo[i].PosX,
                Y = _TeamInfo[i].PosY,
                HeroData = _Hero,
                HeroModel = "",
                SoldierId = _TeamInfo[i].PvpSoldierId,
           }
           this:Create3DHeroModelInit(UITeamMake.UPHeros[_TeamInfo[i].PvpHeroUUID] , i , #_TeamInfo)
           local Point = TeamMakeSys.GetPointByNum(_TeamInfo[i].PosX , _TeamInfo[i].PosY)
           TeamMakeSys.PutDownTeamMake(Point)
           
       end
       if #_TeamInfo==0 then
          UITeamMake.CanChange = true
       end
    else
       UITeamMake.CanChange = true
    end

end

function UITeamMake:ChangeJJCTeam(_TeamType)
    TeamSys.SetJJCHeroInfo(UITeamMake.UPHeros , UITeamMake.NowTeamType)        --保存JJC阵容

    TeamSys.SetJJCTeamType(_TeamType) 
    local _TeamInfo = TeamSys.GetJJCTeamInfoByType(_TeamType)
    UITeamMake.NowTeamType = _TeamType
    this:DestroyHeroModel()

    UITeamMake.UPHeros = {}
    this:ClearPutDownTeam()
    if _TeamInfo~=nil then
       for i = 1 , #_TeamInfo , 1 do         
           if UITeamMake.UPHeros[_TeamInfo[i].PvpHeroUUID]==nil then
              UITeamMake.UPHeros[_TeamInfo[i].PvpHeroUUID] = {}
           end
           local _Hero = HeroPackageSys.GetOneHeroBy_UUID(_TeamInfo[i].PvpHeroUUID)
           UITeamMake.UPHeros[_TeamInfo[i].PvpHeroUUID] = 
           {
                X = _TeamInfo[i].PosX,
                Y = _TeamInfo[i].PosY,
                HeroData = _Hero,
                HeroModel = "",
                --SoldierId = _TeamInfo[i].PvpSoldierId,
           }
           this:Create3DHeroModelInit(UITeamMake.UPHeros[_TeamInfo[i].PvpHeroUUID] , i , #_TeamInfo)
           local Point = TeamMakeSys.GetPointByNum(_TeamInfo[i].PosX , _TeamInfo[i].PosY)
           TeamMakeSys.PutDownTeamMake(Point)
       end
       if #_TeamInfo==0 then
          UITeamMake.CanChange = true
       end
    else
       UITeamMake.CanChange = true
    end
end

UITeamMake.TipPanel = nil
function UITeamMake:OpenTipPanel()
   if UITeamMake.TipPanel == nil then
      UITeamMake.TipPanel = UITeamMake.UITeamMakeGob.transform:FindChild("TipPanel")
   end
   UITeamMake.TipPanel.gameObject:SetActive(true)
end

function UITeamMake:TipSaveTeam()
   this:SaveHero()
   this:CloseTipPanel()
   this:DestroyHeroModel()
end

function UITeamMake:CloseTipPanel()
   if UITeamMake.TipPanel ~= nil then
      UITeamMake.TipPanel.gameObject:SetActive(false)
   end
end

UITeamMake.TempChoseButton = nil
function UITeamMake:ChangeChoseButton(_TeamType)

   if UITeamMake.TempChoseButton~=nil then
      UITeamMake.TempChoseButton.gameObject:SetActive(false)
   end

   if _TeamType==1 then
      UITeamMake.TempChoseButton = UITeamMake.UITeamMakeGob.transform:FindChild("HeroList"):FindChild("Teams"):FindChild("TeamGrid"):FindChild("TeamOne"):FindChild("Chose")
   elseif _TeamType==2 then
      UITeamMake.TempChoseButton = UITeamMake.UITeamMakeGob.transform:FindChild("HeroList"):FindChild("Teams"):FindChild("TeamGrid"):FindChild("TeamTwo"):FindChild("Chose")
   elseif _TeamType==3 then
      UITeamMake.TempChoseButton = UITeamMake.UITeamMakeGob.transform:FindChild("HeroList"):FindChild("Teams"):FindChild("TeamGrid"):FindChild("TeamThree"):FindChild("Chose")
   elseif _TeamType==4 then
      UITeamMake.TempChoseButton = UITeamMake.UITeamMakeGob.transform:FindChild("HeroList"):FindChild("Teams"):FindChild("TeamGrid"):FindChild("TeamFour"):FindChild("Chose")
   end

   UITeamMake.TempChoseButton.gameObject:SetActive(true)

end

function UITeamMake:InitGrayButton()
   
   local _TeamInfo = nil
   local _Sprite = nil
   for i = 1 ,  4 , 1 do
       if TeamSys.TeamSysType == 1 then
          _TeamInfo = TeamSys.GetTeamInfoByType(i)
       else
          _TeamInfo = TeamSys.GetJJCTeamInfoByType(i)
       end
       
       if i==1 then
          _Sprite = UITeamMake.UITeamMakeGob.transform:FindChild("HeroList"):FindChild("Teams"):FindChild("TeamGrid"):FindChild("TeamOne"):FindChild("BG"):GetComponent("UISprite")
       elseif i==2 then
          _Sprite = UITeamMake.UITeamMakeGob.transform:FindChild("HeroList"):FindChild("Teams"):FindChild("TeamGrid"):FindChild("TeamTwo"):FindChild("BG"):GetComponent("UISprite")
       elseif i==3 then
          _Sprite = UITeamMake.UITeamMakeGob.transform:FindChild("HeroList"):FindChild("Teams"):FindChild("TeamGrid"):FindChild("TeamThree"):FindChild("BG"):GetComponent("UISprite")
       elseif i==4 then
          _Sprite = UITeamMake.UITeamMakeGob.transform:FindChild("HeroList"):FindChild("Teams"):FindChild("TeamGrid"):FindChild("TeamFour"):FindChild("BG"):GetComponent("UISprite")
       end

       if _TeamInfo==nil then      
          this:SetGrayButton(i)
       else
         if #_TeamInfo==0 then
            this:SetGrayButton(i)
         else
            this:SetNoGrayButton(i)
         end
       end
   end
end

function UITeamMake:SetNoGrayButton(_TeamType)
   local _Sprite = nil
   if _TeamType==1 then
      _Sprite = UITeamMake.UITeamMakeGob.transform:FindChild("HeroList"):FindChild("Teams"):FindChild("TeamGrid"):FindChild("TeamOne"):FindChild("BG"):GetComponent("UISprite")
   elseif _TeamType==2 then
      _Sprite = UITeamMake.UITeamMakeGob.transform:FindChild("HeroList"):FindChild("Teams"):FindChild("TeamGrid"):FindChild("TeamTwo"):FindChild("BG"):GetComponent("UISprite")
   elseif _TeamType==3 then
      _Sprite = UITeamMake.UITeamMakeGob.transform:FindChild("HeroList"):FindChild("Teams"):FindChild("TeamGrid"):FindChild("TeamThree"):FindChild("BG"):GetComponent("UISprite")
   elseif _TeamType==4 then
      _Sprite = UITeamMake.UITeamMakeGob.transform:FindChild("HeroList"):FindChild("Teams"):FindChild("TeamGrid"):FindChild("TeamFour"):FindChild("BG"):GetComponent("UISprite")
   end
  
   AtlasMsg.SetAtlas(_Sprite , "UI_ZQ_Button" , _Sprite.spriteName)
end

function UITeamMake:SetGrayButton(_TeamType)
   local _Sprite = nil

   if _TeamType==1 then
      _Sprite = UITeamMake.UITeamMakeGob.transform:FindChild("HeroList"):FindChild("Teams"):FindChild("TeamGrid"):FindChild("TeamOne"):FindChild("BG"):GetComponent("UISprite")
   elseif _TeamType==2 then
      _Sprite = UITeamMake.UITeamMakeGob.transform:FindChild("HeroList"):FindChild("Teams"):FindChild("TeamGrid"):FindChild("TeamTwo"):FindChild("BG"):GetComponent("UISprite")
   elseif _TeamType==3 then
      _Sprite = UITeamMake.UITeamMakeGob.transform:FindChild("HeroList"):FindChild("Teams"):FindChild("TeamGrid"):FindChild("TeamThree"):FindChild("BG"):GetComponent("UISprite")
   elseif _TeamType==4 then
      _Sprite = UITeamMake.UITeamMakeGob.transform:FindChild("HeroList"):FindChild("Teams"):FindChild("TeamGrid"):FindChild("TeamFour"):FindChild("BG"):GetComponent("UISprite")
   end

   AtlasMsg.SetGrayAtlas(_Sprite , _Sprite.spriteName , 1)
end

UITeamMake.HeroNum = 0
function UITeamMake:SetTeamHeroNum()
   --[[if UITeamMake.HeroNum==0 then
      this:SetNoGrayButton(UITeamMake.NowTeamType) 
   end--]]
   local _Count = 0
   for key , value in pairs(UITeamMake.UPHeros) do
       _Count = _Count + 1
   end
   UITeamMake.HeroNum = _Count--UITeamMake.HeroNum + 1
   if UITeamMake.HeroNum ==0 then
      this:SetGrayButton(UITeamMake.NowTeamType) 
   else
      this:SetNoGrayButton(UITeamMake.NowTeamType) 
   end
   this:SetTeamHeroNumShow()
end

UITeamMake.HeroText = nil
function UITeamMake:SetTeamHeroNumShow()
   if UITeamMake.HeroText==nil then
      UITeamMake.HeroText = UITeamMake.UITeamMakeGob.transform:FindChild("HeroList"):FindChild("Teams"):FindChild("HeroNum"):GetComponent("UILabel")
   end
   UITeamMake.HeroText.text = tostring(UITeamMake.HeroNum).."/"..tostring(UITeamMake.UpTeamLimit)
end

function UITeamMake:DeleteTeamHeroNum()
   --[[UITeamMake.HeroNum = UITeamMake.HeroNum - 1
   if UITeamMake.HeroNum==0 then
      this:SetGrayButton(UITeamMake.NowTeamType) 
   end
   this:SetTeamHeroNumShow()--]]
end


function UITeamMake:UpdateUpHerosFlag()
   for i =1 , #UITeamMake.HeroGobList , 1 do
       this:UpdateItem("UITeamMake" , UITeamMake.HeroGobList[i].HeroGob.transform)
   end
end

function UITeamMake:DestroyHeroModel()
    for key , value in pairs(UITeamMake.UPHeros) do
        if value.HeroModel~=nil then
           GameObject.Destroy(value.HeroModel.gameObject)
        end
    end
end


function UITeamMake:ClearPutDownTeam()      --清空所有点信息
    TeamMakeSys.ClearAllPoints()
end

function UITeamMake:CloseColor()
    if UITeamMake.Red~=nil then
       UITeamMake.Red.gameObject:SetActive(false)
    end
    if UITeamMake.Green~=nil then
       UITeamMake.Green.gameObject:SetActive(false)
    end 
    --[[if UITeamMake.BoxBg~=nil then
       if UITeamMake.BoxBg.gameObject.activeInHierarchy==true then
          UITeamMake.BoxBg.gameObject:SetActive(false)
       end
    end--]]
    UITeamMake.Red = nil
    UITeamMake.Green = nil 
end

function UITeamMake.Camp(A , B)
   
end

function UITeamMake:ReleasPanel()
UITeamMake.UITeamMakeGob = nil
UITeamMake.TeamMakeFather = nil

UITeamMake.UICamera = nil
UITeamMake.TeamCa = nil
UITeamMake.MoveTeamMaker = nil
UITeamMake.BoxBg = nil
UITeamMake.Red = nil
UITeamMake.Green = nil

UITeamMake.Models = {}
UITeamMake.UPHeros = {}

UITeamMake.NowTeamType = 1   
UITeamMake.TeamMakeType = 1                        --pvp 1 JJC 2
UITeamMake.UpTeamLimit = 0

UITeamMake.HeroGrid = nil
UITeamMake.HeroList = {}
UITeamMake.HeroGobList = {}
UITeamMake.HeroWrap = nil
UITeamMake.HeroPanelScrollView = nil

UITeamMake.SoldierGrid = nil
UITeamMake.SoldierList = {}
UITeamMake.SoldierGobList = {}
UITeamMake.SoldierWrap = nil
UITeamMake.SoldierPanelScrollView = nil

UITeamMake.TempHero = nil
UITeamMake.TempSoldier = nil

UITeamMake.Point = nil
UITeamMake.TempGreen = nil

UITeamMake.TipPanel = nil
UITeamMake.TempChoseButton = nil
UITeamMake.HeroText = nil
end

function UITeamMake:InitPanel()
   this:ClosePanel()
end


return UITeamMake