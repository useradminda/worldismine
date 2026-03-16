UIHandBook = {}
local UIHandBook = BasePanel:new()     
local this = UIHandBook
UIHandBook.UIHandBookGob = nil
UIHandBook.Type = 1
UIHandBook.Quality = 1
UIHandBook.LeftButton = nil
UIHandBook.TopButton = nil

function UIHandBook:OpenUI(_PanelName , _LuaName)
   UIHandBook.UIHandBookGob = MainGameUI.FindPanel("UIHandBook")
   UIHandBook.Type = 0
   UIHandBook.Quality = 0
   this:Comp(1 , 5)
end

UIHandBook.HandBookList = {}
UIHandBook.HandBookData = {}
UIHandBook.HandBookGrid = nil
UIHandBook.UIWrap = nil
function UIHandBook:CreateHandBookList()
    if UIHandBook.HandBookGrid==nil then
       UIHandBook.HandBookGrid = UIHandBook.UIHandBookGob.transform:FindChild("list"):FindChild("Grid")
    end
    if UIHandBook.UIWrap == nil then
       UIHandBook.UIWrap = UIHandBook.UIHandBookGob.transform:FindChild("list"):GetComponent("UIWrap")
    end

    if #UIHandBook.HandBookList==0 then
       for i = 1 ,  12 , 1 do
            local data = 
            {
                Index = i,
            }
            MainGameUI.CreateLittleItem(tostring(i) , "HandBookItem" , UIHandBook.HandBookGrid , data , this.CreateHandBookListCallBack  , "UIHandBook")
        end
    else
       UIHandBook.UIHandBookGob.transform:FindChild("list").localPosition = Vector3(0 , 0 , 0)
       UIHandBook.UIWrap:ResetTrans(#UIHandBook.HandBookData)   
       UIHandBook.HandBookGrid:GetComponent("UIGrid").enabled = true
       UIHandBook.HandBookGrid:GetComponent("UIGrid"):Reposition()
    end

end

function UIHandBook:CreateHandBookListCallBack(_Gob , _Info)
    local _data = UIHandBook.HandBookData[_Info.Index]
    this:SetHandBookInfo(_Gob , _data)
    UIHandBook.HandBookList[_Info.Index] = 
    {
        HandBookGob = _Gob,
    }

    if _Info.Index==12 then
       UIHandBook.HandBookGrid:GetComponent("UIGrid").enabled = true
       UIHandBook.HandBookGrid:GetComponent("UIGrid"):Reposition()     
       UIHandBook.UIWrap:SetData(#UIHandBook.HandBookData , "UIHandBook")
    end
end

function UIHandBook:UpdateItem(_LuaName , _Item)
   local _Index = tonumber(_Item.name)
   local _Data = UIHandBook.HandBookData[_Index]
   this:SetHandBookInfo(_Item , _Data)
end

function UIHandBook:SetHandBookInfo(_Gob , _Info)
   if _Info==nil then
       _Gob.gameObject:SetActive(false)
   else
       _Gob.gameObject:SetActive(true)
       _Gob.transform:FindChild("Name"):GetComponent("UILabel").text = UIstring.WordColor[_Info.Quality]..tostring(_Info.Name)
       local _Sprite = _Gob.transform:FindChild("HeroImg"):FindChild("IMG"):GetComponent("UISprite")
       AtlasMsg.SetAtlas(_Sprite , _Info.AtlasName , _Info.SpriteName)
       local _QSprite = _Gob.transform:FindChild("HeroImg"):FindChild("QFG"):GetComponent("UISprite") 
       AtlasMsg.SetAtlas(_QSprite , UIstring.QualityAtlasName , UIstring.ItemFg[_Info.Quality])
       local _FSprite = _Gob.transform:FindChild("HeroImg"):FindChild("BG"):GetComponent("UISprite") 
       AtlasMsg.SetAtlas(_FSprite , UIstring.QualityBGAtlasName , UIstring.ItemFg[_Info.Quality])
       local _PropData = CalculateRoleProp.CalculatProp(_Info.Id , 1 , 1)
       _Gob.transform:FindChild("Props"):FindChild("Blood"):GetComponent("UILabel").text = tostring(_PropData.life)
       _Gob.transform:FindChild("Props"):FindChild("Attack"):GetComponent("UILabel").text = tostring(_PropData.Attack)
   end
end

function UIHandBook:Comp(_Type , _Quality)
   if _Type==UIHandBook.Type and _Quality==UIHandBook.Quality then
      return
   end  
   UIHandBook.HandBookData = {}
   UIHandBook.HandBookData = HandBookSys.Comp(_Type , _Quality)
   this:CreateHandBookList()
   this:SetButton(_Type , _Quality)
   UIHandBook.Type = _Type
   UIHandBook.Quality = _Quality
end

function UIHandBook:SetButton(_Type , _Quality)
   if _Type~=UIHandBook.Type then
      if UIHandBook.TopButton~=nil then
         UIHandBook.TopButton.transform:FindChild("NoChoseBg").transform.localPosition = Vector3(0 , 0 , 0)
         UIHandBook.TopButton.transform:FindChild("ChoseBg").transform.localPosition = Vector3(10000 , 0 , 0)
      end
      if _Type==1 then
         UIHandBook.TopButton = UIHandBook.UIHandBookGob.transform:FindChild("ButtonTop"):FindChild("HeroBtn")
      elseif _Type==2 then
         UIHandBook.TopButton = UIHandBook.UIHandBookGob.transform:FindChild("ButtonTop"):FindChild("SoldierBtn")
      end 
      UIHandBook.TopButton.transform:FindChild("NoChoseBg").transform.localPosition = Vector3(10000 , 0 , 0)
      UIHandBook.TopButton.transform:FindChild("ChoseBg").transform.localPosition = Vector3(0 , 0 , 0)
   end

   if _Quality ~= UIHandBook.Quality then
      if UIHandBook.LeftButton~=nil then
         UIHandBook.LeftButton.transform:FindChild("NoChoseBg").transform.localPosition = Vector3(0 , 0 , 0)
         UIHandBook.LeftButton.transform:FindChild("ChoseBg").transform.localPosition = Vector3(10000 , 0 , 0)
      end
      UIHandBook.LeftButton = UIHandBook.UIHandBookGob.transform:FindChild("ButtonLeft"):FindChild("Quality"..tostring(_Quality))
      UIHandBook.LeftButton.transform:FindChild("NoChoseBg").transform.localPosition = Vector3(10000 , 0 , 0)
      UIHandBook.LeftButton.transform:FindChild("ChoseBg").transform.localPosition = Vector3(0 , 0 , 0)
   end
end

function UIHandBook:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
   if _Gob.name == "HeroBtn" then
      this:Comp(1 , UIHandBook.Quality)
   elseif _Gob.name == "SoldierBtn" then
      this:Comp(2 , UIHandBook.Quality)
   elseif _Gob.name == "Quality5" then
      this:Comp(UIHandBook.Type , 5)
   elseif _Gob.name == "Quality6" then
      this:Comp(UIHandBook.Type , 6)
   elseif _Gob.name == "Quality7" then
      this:Comp(UIHandBook.Type , 7)
   elseif _Gob.name == "Quality8" then
      this:Comp(UIHandBook.Type , 8)
   elseif _Gob.name == "CloseBtn" then
      this:ClosePanel()
   elseif _Gob.name == "Btn" then
      local _Index = tonumber(_Gob.transform.parent.name)
      this:OpenBookPanel(_Index)
   elseif _Gob.name == "CloseBtn" then
      this:ClosePanel()
   elseif _Gob.name == "InfoPanel" then
      this:CloseBookPanel()
   end
end

UIHandBook.InfoPanel = nil
UIHandBook.TempModel = nil
function UIHandBook:OpenBookPanel(_Index)
   if UIHandBook.InfoPanel == nil then
      UIHandBook.InfoPanel = UIHandBook.UIHandBookGob.transform:FindChild("InfoPanel")
   end
   UIHandBook.InfoPanel.gameObject:SetActive(true)
   this:SetBookInfo(_Index)
end

function UIHandBook:SetBookInfo(_Index)
   local _HeroData = UIHandBook.HandBookData[_Index]
   UIHandBook.InfoPanel.transform:FindChild("Props"):FindChild("Hero"):GetComponent("UILabel").text = tostring(UIstring.WordColor[_HeroData.Quality].._HeroData.Name)  
   UIHandBook.InfoPanel.transform:FindChild("Props"):FindChild("Type"):GetComponent("UILabel").text = tostring(_HeroData.AttackType)
   local _SkillId = _HeroData.Spell_Id
   local _PropData = CalculateRoleProp.CalculatProp(_HeroData.Id , 1 , 1) 
   local _Skill = RoleSkillConfig.GetRoleSkillById(_SkillId) 
   
   UIHandBook.InfoPanel.transform:FindChild("Props"):FindChild("Blood"):GetComponent("UILabel").text = tostring(_PropData.life)
   UIHandBook.InfoPanel.transform:FindChild("Props"):FindChild("Attack"):GetComponent("UILabel").text = tostring(_PropData.Attack)
   local _Sprite = UIHandBook.InfoPanel.transform:FindChild("SkillImg"):FindChild("IMG"):GetComponent("UISprite")
   local _SpQ = UIHandBook.InfoPanel.transform:FindChild("SkillImg"):FindChild("QFG"):GetComponent("UISprite")
   if _Skill~=nil then
      UIHandBook.InfoPanel.transform:FindChild("SkillImg").gameObject:SetActive(true)
      AtlasMsg.SetAtlas(_Sprite , _Skill.AtlasName , _Skill.SpriteName)  
      UIHandBook.InfoPanel.transform:FindChild("Props"):FindChild("Skill"):GetComponent("UILabel").text = tostring(_Skill.Name)
      AtlasMsg.SetAtlas(_SpQ , UIstring.QualityAtlasName , UIstring.ItemFg[_HeroData.Quality])
   else
      UIHandBook.InfoPanel.transform:FindChild("SkillImg").gameObject:SetActive(false)
      UIHandBook.InfoPanel.transform:FindChild("Props"):FindChild("Skill"):GetComponent("UILabel").text = UIstring.Nothing
   end
   this:Create3DModel(_HeroData)
end

function UIHandBook:Create3DModel(_HeroData)
   if UIHandBook.TempModel~=nil then
       if _HeroData.FbxName~=UIHandBook.TempModel.name then
          GameObject.Destroy(UIHandBook.TempModel)
          UIHandBook.TempModel = nil
       end
   end
   
   local data = 
   {
       RoleType = _HeroData.Type_1
   }
   local _ModelFather = UIHandBook.InfoPanel.transform:FindChild("ModelFather")
   Create3DModel.CreateThModel(_HeroData.FbxName , "run" , 5 , _ModelFather , UIHandBook.Create3DModelCallBack , true , data)   
end

function UIHandBook.Create3DModelCallBack(_Model , _Data)
   UIHandBook.TempModel = _Model
   if _Data.RoleType==1 then
      Create3DModel.CreateHorse(UIHandBook.TempModel , UIHandBook.Create3DHorseCallBack) 
      return 
   elseif _Data.RoleType == 2 then
      UIHandBook.TempModel.transform.localPosition = Vector3(0 , -1.5 , 0)
   end 
end

function UIHandBook.Create3DHorseCallBack(_Model , _Data)
   _Model.transform.parent = UIHandBook.TempModel.transform
   _Model.transform.localPosition = Vector3(0 , -2 , 0)
end

function UIHandBook:CloseBookPanel()
   if UIHandBook.InfoPanel~=nil then
      UIHandBook.InfoPanel.gameObject:SetActive(false)
   end
end

function UIHandBook:ClosePanel()
   UIHandBook.UIHandBookGob.gameObject:SetActive(false)
end

function UIHandBook:ReleasPanel()               									 --退出界面时释放和界面初始化
   UIHandBook.UIHandBookGob = nil
   UIHandBook.Type = 1
   UIHandBook.Quality = 1
   UIHandBook.LeftButton = nil
   UIHandBook.TopButton = nil

   UIHandBook.HandBookList = {}
   UIHandBook.HandBookData = {}
   UIHandBook.HandBookGrid = nil
   UIHandBook.UIWrap = nil
   UIHandBook.InfoPanel = nil
   UIHandBook.TempModel = nil
end

return UIHandBook