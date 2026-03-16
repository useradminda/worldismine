UIShop = {}
local UIShop = BasePanel:new()     
local this = UIShop
UIShop.UIShopGob = nil
UIShop.ShopType = 0
UIShop.TempPanel = nil
UIShop.TempButton = nil

function UIShop:OpenUI(_PanelName , _LuaName)
	
   UIShop.UIShopGob=MainGameUI.FindPanel("UIShop")
   UIShop.ShopType = 1  
	if UIShop.UIShopGob ~= nil then
		
	end
   this:ShowMyOwnDiamond() 
   this:ShowMyKing() 
   UIShop.ShopItemsData = ShopSys.ItemsList
   UIShop.ShopBossItems = ShopSys.Bosses
   if UIShop.NormalPanel==nil then
      UIShop.NormalPanel = UIShop.UIShopGob.transform:FindChild("SellPanel")
   end
   if UIShop.BossPanel== nil then
      UIShop.BossPanel = UIShop.UIShopGob.transform:FindChild("SellBoosPanel")
   end
   UIShop.NormalPanel.gameObject:SetActive(true)
   UIShop.BossPanel.gameObject:SetActive(false)
   this:CreateNormalShopItems()
   this:CreateBossShopItems()
   this:ChangeButton(UIShop.UIShopGob.transform:FindChild("Tags"):FindChild("ItemButton"))
   
end

UIShop.MyDiamoned = nil
function UIShop:ShowMyOwnDiamond()
	if UIShop.MyDiamoned == nil then
		UIShop.MyDiamoned = UIShop.UIShopGob.transform:FindChild("MyDiamoned/Label"):GetComponent("UILabel")
	end
	UIShop.MyDiamoned.text = tostring(ClinetInfomation:GetDiamond())
end

function UIShop:ShowMyKing()
   UIShop.UIShopGob.transform:FindChild("MyKing/Label"):GetComponent("UILabel").text = tostring(ClinetInfomation.King)
end

function UIShop:ChangeButton(_TempButton)
    if UIShop.TempButton~=nil then
       UIShop.TempButton.transform:FindChild("click").gameObject:SetActive(false)
    end
    UIShop.TempButton = _TempButton
    UIShop.TempButton.transform:FindChild("click").gameObject:SetActive(true)
end

function UIShop:OpenPanelType(_Type)
   if UIShop.ShopType==_Type then
      return
   end

   UIShop.ShopType = _Type
   this:OpenPanel(_Type)

end

UIShop.ShopItemGobs = {}
UIShop.ShopGrid = nil
UIShop.NormalShopWrap = nil
function UIShop:CreateNormalShopItems()
   if UIShop.ShopGrid==nil then
      UIShop.ShopGrid = UIShop.UIShopGob.transform:FindChild("SellPanel"):FindChild("SellPanelGrid")
   end
   if UIShop.NormalShopWrap == nil then
      UIShop.NormalShopWrap = UIShop.UIShopGob.transform:FindChild("SellPanel"):GetComponent("UIWrap")
   end
    
   if #UIShop.ShopItemGobs==0 then
      for i = 1 , 16 , 1 do
          local data = 
          {
              Index = i,
          }
          MainGameUI.CreateLittleItem(tostring(i) , "ShopItem" , UIShop.ShopGrid , data , this.CreateNormalShopItemsCallBack  , "UIShop")
      end
   else
      UIShop.UIShopGob.transform:FindChild("SellPanel").localPosition = Vector3(0 , 0 , 0)
      UIShop.NormalShopWrap:ResetTrans(#UIShop.ShopItemsData)
      UIShop.ShopGrid:GetComponent("UIGrid").enabled = true
      UIShop.ShopGrid:GetComponent("UIGrid"):Reposition()
      --this:OpenPanelType(1)
   end
end

function UIShop:CreateNormalShopItemsCallBack(_Gob , _Info)
   
   local _ShopItem = UIShop.ShopItemsData[_Info.Index]
   if _ShopItem~=nil then
      this:SetNormalGob(_Gob , _ShopItem) 
   end

   UIShop.ShopItemGobs[_Info.Index] =
   {
      ShopGob = _Gob
   }
   if _Info.Index==16 then
      UIShop.ShopGrid:GetComponent("UIGrid").enabled = true
      UIShop.ShopGrid:GetComponent("UIGrid"):Reposition()
      UIShop.NormalShopWrap:SetData(#UIShop.ShopItemsData , "UIShop")
    --  this:OpenPanelType(1)
   end
end

UIShop.ShopBossItemGobs = {}
UIShop.ShopBossGrid = nil
UIShop.BossShopWrap = nil
UIShop.ShopBossItems = {}
function UIShop:CreateBossShopItems()
   if UIShop.ShopBossGrid==nil then
      UIShop.ShopBossGrid = UIShop.UIShopGob.transform:FindChild("SellBoosPanel"):FindChild("SellBoosGrid")
   end
   if UIShop.BossShopWrap == nil then
      UIShop.BossShopWrap = UIShop.UIShopGob.transform:FindChild("SellBoosPanel"):GetComponent("UIWrap")
   end
    
   if #UIShop.ShopBossItemGobs==0 then
      for i = 1 , 6 , 1 do
          local data = 
          {
              Index = i,
          }
          MainGameUI.CreateLittleItem(tostring(i) , "ShopBossItem" , UIShop.ShopBossGrid , data , this.CreateBossShopItemsCallBack  , "UIShop")
      end
   else
      UIShop.UIShopGob.transform:FindChild("SellPanel").localPosition = Vector3(0 , 0 , 0)
      UIShop.BossShopWrap:ResetTrans(#UIShop.ShopBossItems)
      UIShop.ShopBossGrid:GetComponent("UIGrid").enabled = true
      UIShop.ShopBossGrid:GetComponent("UIGrid"):Reposition()
   end
end

function UIShop:CreateBossShopItemsCallBack(_Gob , _Info)
    local _ShopItem = UIShop.ShopBossItems[_Info.Index]
   if _ShopItem~=nil then
      this:SetBossGob(_Gob , _ShopItem) 
   end

   UIShop.ShopBossItemGobs[_Info.Index] =
   {
      ShopGob = _Gob
   }
   if _Info.Index==6 then
      UIShop.ShopBossGrid:GetComponent("UIGrid").enabled = true
      UIShop.ShopBossGrid:GetComponent("UIGrid"):Reposition()
      UIShop.BossShopWrap:SetData(#UIShop.ShopBossItems , "UIShop")
   end
end

UIShop.NormalPanel = nil
UIShop.BossPanel = nil
function UIShop:OpenPanel(_Type)
   if UIShop.NormalPanel==nil then
      UIShop.NormalPanel = UIShop.UIShopGob.transform:FindChild("SellPanel")
   end
   if UIShop.BossPanel== nil then
      UIShop.BossPanel = UIShop.UIShopGob.transform:FindChild("SellBoosPanel")
   end

   if _Type==1 or _Type==2 or _Type==3 or _Type==4 then
      UIShop.BossPanel.gameObject:SetActive(false)
      UIShop.NormalPanel.gameObject:SetActive(true)  
      UIShop.UIShopGob.transform:FindChild("SellPanel").localPosition = Vector3(0 , 0 , 0)
      
   elseif _Type==5 then
      UIShop.NormalPanel.gameObject:SetActive(false)
      UIShop.BossPanel.gameObject:SetActive(true)
      UIShop.UIShopGob.transform:FindChild("SellBoosPanel").localPosition = Vector3(0 , 0 , 0)
      
   end

   this:SetItems(_Type)
end

UIShop.ShopItemsData = {}
function UIShop:SetItems(_Type)
   
   if _Type==1 then
      UIShop.ShopItemsData = ShopSys.ItemsList
   elseif _Type==2 then
      UIShop.ShopItemsData = ShopSys.RewardBags
   elseif _Type==3 then
      UIShop.ShopItemsData = ShopSys.Flags
   elseif _Type==4 then 
      UIShop.ShopItemsData = ShopSys.Others
   elseif _Type==5 then
      UIShop.ShopBossItems = ShopSys.Bosses
   end

   if _Type==1 or _Type==2 or _Type==3 or _Type==4 then
       local _DataNum = #UIShop.ShopItemsData
       UIShop.NormalShopWrap:ResetTrans(_DataNum)
       UIShop.ShopGrid:GetComponent("UIGrid").enabled = true
       UIShop.ShopGrid:GetComponent("UIGrid"):Reposition()   
   elseif _Type==5 then
       local _DataNum = #UIShop.ShopBossItems
       UIShop.BossShopWrap:ResetTrans(_DataNum)
       UIShop.ShopBossGrid:GetComponent("UIGrid").enabled = true
       UIShop.ShopBossGrid:GetComponent("UIGrid"):Reposition()
   end

   --this:SetGob(_Type)

end

--[[function UIShop:SetGob(_Type)
   if _Type==1 or _Type==2 or _Type==3 or _Type==4 then
      for i = 1 , #UIShop.ShopItemsData , 1 do        
          local _ShopItem = UIShop.ShopItemsData[i]
          if _ShopItem~=nil then
             this:SetNormalGob(UIShop.ShopItemGobs[i].ShopGob , _ShopItem)    
          end    
      end
   elseif _Type==5 then
      for i = 1 , #UIShop.ShopBossItems , 1 do
          local _ShopItem = UIShop.ShopBossItems[i]
          if _ShopItem~=nil then
             this:SetBossGob(UIShop.ShopBossItemGobs[i].ShopGob , _ShopItem)   
          end    
      end
   end
end--]]

function UIShop:SetNormalGob(_Gob , _ShopItem)   

   _Gob.gameObject:SetActive(true)
   local _Resource = ResourceConfig.GetResourceConfig(_ShopItem.ShopCostType)
   local _Sprite = _Gob.transform:FindChild("Money"):FindChild("Icon"):GetComponent("UISprite")
   AtlasMsg.SetAtlas(_Sprite , _Resource.AtlasName , _Resource.SpriteName)

   _Gob.transform:FindChild("Money"):FindChild("Count"):GetComponent("UILabel").text = tostring(_ShopItem.ShopCostCount)
   _Gob.transform:FindChild("Name"):GetComponent("UILabel").text = UIstring.WordColor[_ShopItem.ShopItem.Quality].._ShopItem.ShopItem.Name

   local _Sprite = _Gob.transform:FindChild("Item"):FindChild("Img"):GetComponent("UISprite")
   AtlasMsg.SetAtlas(_Sprite , _ShopItem.ShopItem.AtlasName , _ShopItem.ShopItem.SpriteName) 
   local _FSprite = _Gob.transform:FindChild("Item"):FindChild("FG"):GetComponent("UISprite")
   AtlasMsg.SetAtlas(_FSprite , UIstring.QualityAtlasName , UIstring.ItemFg[_ShopItem.ShopItem.Quality]) 
   local _BSprite = _Gob.transform:FindChild("Item"):FindChild("BG"):GetComponent("UISprite")
   AtlasMsg.SetAtlas(_BSprite , UIstring.QualityBGAtlasName , UIstring.ItemFg[_ShopItem.ShopItem.Quality])
end

UIShop.TempItem = nil
UIShop.ItemNum = 0
function UIShop:BuyNormalItem(_Index)
   local _ShopItemData = UIShop.ShopItemsData[_Index]
   local data =
   {
      Buy_SellType = 1,
      Item = _ShopItemData,
   }
   DataUIInstance.PopTipPanel("Buy_SellItems" , UIShop.BuyNormalCallBack , data) 
end

function UIShop.BuyNormalCallBack(_Data)
    if _Data==nil then
       return
    end
    local _Item = _Data.Item
    if _Item.ShopCostType==1001 then   --Ôª±¦
       if _Item.ShopCostCount * _Data.Num > ItemDataSys.GetResourceByIdCount(1001) then
          DataUIInstance.OpenRecharge()
          DataUIInstance.PopTip("W2")
          return
       end
    end
    UIShop.TempItem = _Item
    UIShop.ItemNum = _Data.Num
    ShopSys.BuyNormalItem(_Item.ShopId , _Data.Num)
end

function UIShop:PopReward()
    local data = 
    {
        SpriteName = UIShop.TempItem.ShopItem.SpriteName,
        AtlasName = UIShop.TempItem.ShopItem.AtlasName,
        Count = UIShop.ItemNum,
        Quality = UIShop.TempItem.ShopItem.Quality,
    }
    local Reward = {}
    Reward[1] = data
    DataUIInstance.OpenRewards(Reward)
	this:ShowMyOwnDiamond()
end

function UIShop:SetBossGob(_Gob , _ShopItem)
   --GameMain.Print(_ShopItem)
   _Gob.gameObject:SetActive(true)
   local _Resource = ResourceConfig.GetResourceConfig(_ShopItem.ShopCostType)
   local _Sprite = _Gob.transform:FindChild("Money"):FindChild("Icon"):GetComponent("UISprite")
   AtlasMsg.SetAtlas(_Sprite , _Resource.AtlasName , _Resource.SpriteName)

   _Gob.transform:FindChild("Money"):FindChild("Count"):GetComponent("UILabel").text = tostring(_ShopItem.ShopCostCount)
   _Gob.transform:FindChild("Name"):GetComponent("UILabel").text = UIstring.WordColor[_ShopItem.ShopItem.Quality].._ShopItem.ShopItem.Name
   local _Sprite = _Gob.transform:FindChild("HeadImg"):GetComponent("UISprite")
   AtlasMsg.SetAtlas(_Sprite , _ShopItem.ShopItem.AtlasName , _ShopItem.ShopItem.SpriteName) 

   local _SkillId = _ShopItem.ShopItem.Spell_Id
   local _PropData = CalculateRoleProp.CalculatProp(_ShopItem.ShopItem.Id , 1 , 1) 
   local _Skill = RoleSkillConfig.GetRoleSkillById(_SkillId)

   _Gob.transform:FindChild("Props"):FindChild("Blood"):GetComponent("UILabel").text = tostring(_PropData.life)
   _Gob.transform:FindChild("Props"):FindChild("Attack"):GetComponent("UILabel").text = tostring(_PropData.Attack)
   local _Sprite = _Gob.transform:FindChild("Skill"):FindChild("SkillImg"):GetComponent("UISprite")
   local _QSprite = _Gob.transform:FindChild("Skill"):FindChild("SkillBg"):GetComponent("UISprite")
   if _Skill~=nil then
      AtlasMsg.SetAtlas(_Sprite , _Skill.AtlasName , _Skill.SpriteName)  
      _Gob.transform:FindChild("Props"):FindChild("Skill"):GetComponent("UILabel").text = tostring(_Skill.Name)  
      AtlasMsg.SetAtlas(_QSprite , UIstring.QualityAtlasName , UIstring.ItemFg[_ShopItem.ShopItem.Quality])
   end
end

function UIShop:BuyBossItem(_Index)
   local _ShopItemData = UIShop.ShopBossItems[_Index]
   ShopSys.BuyBossItem(_ShopItemData.ShopId)
   UIShop.TempItem = _ShopItemData
   UIShop.ItemNum = 1
end


function UIShop:UIHand(_LuaName , _Gob)
   MusicManagerSys.ButtonClick()
	if _Gob.name == "ItemButton" then
      this:OpenPanelType(1)
      this:ChangeButton(_Gob)
   elseif _Gob.name == "RewardButton" then
      this:OpenPanelType(2)
      this:ChangeButton(_Gob)
   elseif _Gob.name == "FlagButton" then
      this:OpenPanelType(3)
      this:ChangeButton(_Gob)
   elseif _Gob.name == "OtherButton" then
      this:OpenPanelType(4)
      this:ChangeButton(_Gob)
   elseif _Gob.name == "BossButton" then
      this:OpenPanelType(5)
      this:ChangeButton(_Gob)
   elseif _Gob.name == "CloseBtn" then
      this:CloseShopPanel()
   elseif _Gob.transform.parent.parent.name == "SellPanelGrid" then
      local _Index = tonumber(_Gob.transform.parent.name)
      this:BuyNormalItem(_Index)
   elseif _Gob.transform.parent.parent.name == "SellBoosGrid" then
      local _Index = tonumber(_Gob.transform.parent.name)
      this:BuyBossItem(_Index)
   end
end

function UIShop:UpdateItem(_LuaName , _Item)
   this:ReflashItem(_Item)
end

function UIShop:ReflashItem(_Item)
   if _Item.transform.parent.name == "SellPanelGrid" then      
      local _ShopItem = UIShop.ShopItemsData[tonumber(_Item.name)]
      if _ShopItem~=nil then
         this:SetNormalGob(_Item.gameObject , _ShopItem)
      end
   elseif _Item.transform.parent.name == "SellBoosGrid" then
      local _ShopItem = UIShop.ShopBossItems[tonumber(_Item.name)]
      if _ShopItem~=nil then
        this:SetBossGob(_Item.gameObject , _ShopItem)
      end
   end
end

function UIShop:CloseShopPanel()
   if UIShop.UIShopGob~=nil then
      UIShop.UIShopGob.gameObject:SetActive(false)
		local UIConsumpGiftTar = MainGameUI.FindPanelTarget("UIConsumpGift")
		if UIConsumpGiftTar ~=nil then
			UIConsumpGiftTar:ShowInfo()
		end
   end
end

function UIShop:ReleasPanel()
    
    UIShop.UIShopGob = nil
    UIShop.ShopType = 0
    UIShop.TempPanel = nil
    UIShop.TempButton = nil

    UIShop.ShopItemGobs = {}
    UIShop.ShopGrid = nil
    UIShop.NormalShopWrap = nil

    UIShop.ShopBossItemGobs = {}
    UIShop.ShopBossGrid = nil
    UIShop.BossShopWrap = nil
    UIShop.ShopBossItems = {}

    UIShop.NormalPanel = nil
    UIShop.BossPanel = nil
	UIShop.MyDiamoned = nil
    UIShop.ShopItemsData = {}

end

return UIShop