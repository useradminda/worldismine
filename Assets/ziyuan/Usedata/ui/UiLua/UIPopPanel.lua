UIPopPanel = {}

local UIPopPanel = BasePanel:new()                                                  
local this = UIPopPanel
UIPopPanel.UIPopPanelGob = nil

UIPopPanel.NowTime = 0
UIPopPanel.TotalTime = 1
UIPopPanel.State = 0
UIPopPanel.NowX = 0
UIPopPanel.TarX = 0


UIPopPanel.PopNowTime = 0
UIPopPanel.PopPropTotalTime = 0.5
UIPopPanel.PopState = 0
UIPopPanel.PopNumber = 1
UIPopPanel.GobNumber = 1
UIPopPanel.PopList = nil


function UIPopPanel:OpenUI(_PanelName , _LuaName)	 
	UIPopPanel.UIPopPanelGob = MainGameUI.FindPanel("UIPopPanel")
    --UIPopPanel.UIPopPanelGob.transform.localPosition = Vector3(10000 , 0 , -1000)
    GameMain.AddUpdateLua(this.UpdatePanel)
end

UIPopPanel.TipWord = nil
function UIPopPanel:PopTip(_Msg ,_FontSize, _NowY , _TarY)
   UIPopPanel.UIPopPanelGob.gameObject:SetActive(true)
   if UIPopPanel.TipWord==nil then
      UIPopPanel.TipWord = UIPopPanel.UIPopPanelGob.transform:FindChild("PopText")
   end
   UIPopPanel.TipWord.gameObject:SetActive(true)
   UIPopPanel.TipWord.transform:FindChild("WordMsg"):GetComponent("UILabel").text = _Msg
   if _FontSize == nil then
	  UIPopPanel.TipWord.transform:FindChild("WordMsg"):GetComponent("UILabel").fontSize = 30
   else
	  UIPopPanel.TipWord.transform:FindChild("WordMsg"):GetComponent("UILabel").fontSize = _FontSize
   end
   --[[local MsgHight = GameMain.StringSplit(_Msg , "\n")
   local HightCount = #MsgHight
   UIPopPanel.TipWord.transform:FindChild("Bg"):GetComponent("UISprite").height = 42*HightCount--]]
   if _NowY==nil then
      UIPopPanel.NowY = 100
   else
      UIPopPanel.NowY = _NowY
   end
   if _TarY==nil then
      UIPopPanel.TarY = 200
   else
      UIPopPanel.TarY = _TarY
   end
   UIPopPanel.NowTime = 0
   UIPopPanel.State = 1
end

UIPopPanel.PropChangePanel = nil
function UIPopPanel:StartPopProp(_PropList)
   UIPopPanel.UIPopPanelGob.gameObject:SetActive(true)
   if UIPopPanel.PropChangePanel==nil then
      UIPopPanel.PropChangePanel = UIPopPanel.UIPopPanelGob.transform:FindChild("PropChangePanel")
   end
   UIPopPanel.PropChangePanel.gameObject:SetActive(true)

   for i = 1 , 5 , 1 do
       UIPopPanel.PropChangePanel:FindChild(tonumber(i)).gameObject:SetActive(false)
   end

   UIPopPanel.PopList = _PropList 
   UIPopPanel.PopNumber = 1
   UIPopPanel.GobNumber = 1
   UIPopPanel.PopNowTime = 0
   this:PopProp(UIPopPanel.GobNumber , UIPopPanel.PopNumber)
   UIPopPanel.PopState = 1
end

function UIPopPanel:PopProp(_GobNumber , _PopNumber)
   UIPopPanel.PropChangePanel:FindChild(tonumber(_GobNumber)).gameObject:SetActive(true)
   UIPopPanel.PropChangePanel:FindChild(tonumber(_GobNumber)):GetComponent("UILabel").text = UIPopPanel.PopList[_PopNumber]
   UIPopPanel.PropChangePanel:FindChild(tonumber(_GobNumber)):GetComponent("TweenPosition"):ResetToBeginning()
   UIPopPanel.PropChangePanel:FindChild(tonumber(_GobNumber)):GetComponent("TweenAlpha"):ResetToBeginning()
   UIPopPanel.PropChangePanel:FindChild(tonumber(_GobNumber)):GetComponent("TweenPosition"):Play()
   UIPopPanel.PropChangePanel:FindChild(tonumber(_GobNumber)):GetComponent("TweenAlpha"):Play()
end

UIPopPanel.CallBack = nil
function UIPopPanel:PopTipPanel(_Data)
   UIPopPanel.UIPopPanelGob.gameObject:SetActive(true)

   if _Data.Type == "Buy_SellItems" then
      this:PopBuy_SellPanel(_Data.Data)
   end

   if _Data.Type=="BuySta" or _Data.Type=="BuyEnergy" then
      this:PopBuySta_EnergyPanel(_Data.Data)
   end

   if _Data.Type=="UseItem" then
      this:PopUseItemPanel(_Data.Data)
   end
   
   if _Data.Type=="BuyDiamon" then
      this:PopBuyDiamond(_Data.Data)
   end
   if _Data.Type=="BuyCoin" then
      this:PopBuyCoin(_Data.Data)
   end

   if _Data.Type=="BuyMoreMaterial" then
      this:PopBuyMoreMaterial(_Data.Data)
   end

   if _Data.Type=="Production" then
      this:PopProductionPanel(_Data.Data)
   end

   if _Data.Type=="SkillInfo" then
      this:PopSkillPanel(_Data.Data)
   end

   if _Data.Type=="Resign" then
      this:PopResignPanel(_Data.Data)
   end

   if _Data.Type=="ItemInfo" then
      this:PopItemInfoPanel(_Data.Data)
   end

   if _Data.Type=="ChoseRule" then
      this:PopChoseRulePanel(_Data.Data)
   end

   if _Data.Type=="NetError" then
      this:PopNetErrorPanel(_Data.Data)
   end

   if _Data.Type == "ChangeTeam" then
      this:PopTeamChangePanel(_Data.Data)
   end 

   if _Data.Type == "CostMoney" then
      this:PopCostMoneyPanel(_Data.Data)
   end

   UIPopPanel.CallBack = _Data.CallBack
end

--*********************************************购买使用界面
UIPopPanel.Buy_SellPanel = nil
UIPopPanel.Buy_SellType = 0                 --1 表示购买 2 出售
UIPopPanel.Buy_SellItemInfo = 0             --道具信息
UIPopPanel.UseCount = 0
function UIPopPanel:PopBuy_SellPanel(data) 
   if UIPopPanel.Buy_SellPanel == nil then
      MainGameUI.CreateLittleItem("UIBagSellPanel" , "UIBagSellPanel" , UIPopPanel.UIPopPanelGob , data , this.CreatePopBuy_SellPanelCallBack , "UIPopPanel")
   else
      this:CreatePopBuy_SellPanelCallBack(UIPopPanel.Buy_SellPanel , data)
   end
end

function UIPopPanel:CreatePopBuy_SellPanelCallBack(_Gob , _Info)
   _Gob.gameObject:SetActive(true)
   UIPopPanel.Buy_SellPanel = _Gob
	UIPopPanel.Buy_SellPanel.transform.localPosition = Vector3(0,0,-460)
   UIPopPanel.Buy_SellType = _Info.Buy_SellType
   UIPopPanel.Buy_SellItemInfo = _Info.Item
	local useCount = _Info.BuyCount
	if useCount == nil then
		useCount = 1
	end
   this:SetName()
   this:SetIcon()
   this:SetUseCount(useCount)
   this:SetDescrip()
   this:SetHaveCount()
   this:SetMoneyIcom()
end

function UIPopPanel:SetIcon()
   local _Sprite = UIPopPanel.Buy_SellPanel.transform:FindChild("itemIcon"):FindChild("Img"):GetComponent("UISprite")
   AtlasMsg.SetAtlas(_Sprite , UIPopPanel.Buy_SellItemInfo.ShopItem.AtlasName , UIPopPanel.Buy_SellItemInfo.ShopItem.SpriteName) 
   local _QSprite = UIPopPanel.Buy_SellPanel.transform:FindChild("itemIcon"):FindChild("BG"):GetComponent("UISprite")
   AtlasMsg.SetAtlas(_QSprite , UIstring.QualityBGAtlasName , UIstring.ItemFg[UIPopPanel.Buy_SellItemInfo.ShopItem.Quality])
   local _FSprite = UIPopPanel.Buy_SellPanel.transform:FindChild("itemIcon"):FindChild("FG"):GetComponent("UISprite")
   AtlasMsg.SetAtlas(_FSprite , UIstring.QualityAtlasName , UIstring.ItemFg[UIPopPanel.Buy_SellItemInfo.ShopItem.Quality])
end

function UIPopPanel:SetName()
   UIPopPanel.Buy_SellPanel.transform:FindChild("name"):GetComponent("UILabel").text = UIstring.WordColor[UIPopPanel.Buy_SellItemInfo.ShopItem.Quality]..UIPopPanel.Buy_SellItemInfo.ShopItem.Name
end

function UIPopPanel:SetHaveCount()
   --GameMain.Print(UIPopPanel.Buy_SellItemInfo)
   local _ItemId = UIPopPanel.Buy_SellItemInfo.ShopItem.Id
   local _Item = nil
   if UIPopPanel.Buy_SellItemInfo.ShopItem.Series==nil then  --普通刀具
      _Item = ItemPackageSys.GetItemById(_ItemId)   
   else                                                      --符文                                                                       
      _Item = BattleFlagSys.FindFlagByDBId(_ItemId)
   end
   local _Count = 0
   if _Item==nil then
      _Count = 0
   else
      _Count = _Item.Count
   end
   UIPopPanel.Buy_SellPanel.transform:FindChild("havecount"):GetComponent("UILabel").text = tostring(_Count)
end

function UIPopPanel:SetUseCount(_Count)
   UIPopPanel.Buy_SellPanel.transform:FindChild("useCount"):GetComponent("UILabel").text = tostring(_Count)
   UIPopPanel.UseCount = _Count
   this:SetMoney(_Count)
end

function UIPopPanel:SetMoney(_Count)
   local _NeedMoney = UIPopPanel.Buy_SellItemInfo.ShopCostCount* _Count
   UIPopPanel.Buy_SellPanel.transform:FindChild("money"):FindChild("Label"):GetComponent("UILabel").text = tostring(_NeedMoney)
end

function UIPopPanel:SetMoneyIcom()
   local _Type = UIPopPanel.Buy_SellItemInfo.ShopCostType
   local _Resource = ResourceConfig.GetResourceConfig(_Type)
   local _Sprite = UIPopPanel.Buy_SellPanel.transform:FindChild("money"):FindChild("icon"):GetComponent("UISprite")
   AtlasMsg.SetAtlas(_Sprite , _Resource.AtlasName , _Resource.SpriteName)
end

function UIPopPanel:SetDescrip()
   UIPopPanel.Buy_SellPanel.transform:FindChild("info"):GetComponent("UILabel").text = UIPopPanel.Buy_SellItemInfo.ShopItem.Description
end

function UIPopPanel:Plus(num)
    UIPopPanel.UseCount = UIPopPanel.UseCount + num
    this:SetUseCount(UIPopPanel.UseCount)
end

function UIPopPanel:Sub(num)
	UIPopPanel.UseCount =  UIPopPanel.UseCount - num
   if UIPopPanel.UseCount <= 1 then
      UIPopPanel.UseCount = 1
   end
   
   this:SetUseCount(UIPopPanel.UseCount)
end

function UIPopPanel:CloseBuy_SellPanel()
   if UIPopPanel.Buy_SellPanel~=nil then
      UIPopPanel.Buy_SellPanel.gameObject:SetActive(false)
   end
end



UIPopPanel.BuySta_EnergyPanel = nil
function UIPopPanel:PopBuySta_EnergyPanel(data)                                 --购买体力 精力面板
   if UIPopPanel.BuySta_EnergyPanel==nil then
      MainGameUI.CreateLittleItem("PopPanelSta_Energy" , "PopPanelSta_Energy" , UIPopPanel.UIPopPanelGob , data , this.CreateSta_EnergyCallBack , "UIPopPanel")
   else
      this:CreateSta_EnergyCallBack(UIPopPanel.BuySta_EnergyPanel , data)
   end
end

function UIPopPanel:CreateSta_EnergyCallBack(_Gob , _Info)
   UIPopPanel.BuySta_EnergyPanel = _Gob 
end

UIPopPanel.UseItemPanel = nil
UIPopPanel.UseItem = nil
function UIPopPanel:PopUseItemPanel(data)                                   --使用道具面板
   if UIPopPanel.UseItemPanel==nil then
      MainGameUI.CreateLittleItem("UseItemPanel" , "UseItemPanel" , UIPopPanel.UIPopPanelGob , data , this.CreatePopUsePanel , "UIPopPanel")
   else
      this:CreatePopUsePanel(UIPopPanel.UseItemPanel , data) 
   end
end

function UIPopPanel:CreatePopUsePanel(_Gob , _Info)
   _Gob.gameObject:SetActive(true)
   UIPopPanel.UseItemPanel = _Gob
   UIPopPanel.UseItemPanel.transform.localPosition = Vector3(0 , 0 , -1000)
   UIPopPanel.UseItem = _Info
   this:SetUseItem(UIPopPanel.UseItem)
end

function UIPopPanel:SetUseItem(_Item)
    UIPopPanel.UseItemPanel.transform:FindChild("ItemInfo"):FindChild("ItemName"):GetComponent("UILabel").text = _Item.name
    UIPopPanel.UseItemPanel.transform:FindChild("ItemInfo"):FindChild("Descrip"):GetComponent("UILabel").text = _Item.Descrip
    local _Sprite = UIPopPanel.UseItemPanel.transform:FindChild("ItemHead"):FindChild("ItemIcon"):FindChild("ItemIMG"):GetComponent("UISprite")
    AtlasMsg.SetAtlas(_Sprite , _Item.AtlasName , _Item.SpriteName)
    UIPopPanel.UseItemPanel.transform:FindChild("ItemHead"):FindChild("ItemIcon"):FindChild("ItemFg"):GetComponent("UISprite").spriteName = UIstring.ItemFg[_Item.quality]
end

UIPopPanel.UseMoreItemPanel = nil                                                                             --道具批量使用界面
UIPopPanel.UseItemNum = 1
function UIPopPanel:PopUseMoreItemPanel()
   if UIPopPanel.UseItemPanel~=nil then
      if UIPopPanel.UseMoreItemPanel==nil then
         UIPopPanel.UseMoreItemPanel = UIPopPanel.UseItemPanel.transform:FindChild("UseMorePanel")
      end
   end
   UIPopPanel.UseMoreItemPanel.gameObject:SetActive(true)
   this:SetUseItemNum(UIPopPanel.UseItemNum)
end

function UIPopPanel:SetUseItemNum(_Num)                                                   --设置批量使用道具的数量
   UIPopPanel.UseMoreItemPanel.transform:FindChild("Num"):FindChild("Num"):GetComponent("UILabel").text = tostring(_Num)
end

function UIPopPanel:SetRightNum()
   local Count = UIPopPanel.UseItem.Count                                                            --道具一共有多少个
   UIPopPanel.UseItemNum = UIPopPanel.UseItemNum + 10
   if UIPopPanel.UseItemNum > Count then
      UIPopPanel.UseItemNum = Count
   end
   this:SetUseItemNum(UIPopPanel.UseItemNum)
end

function UIPopPanel:SetLeftNum()
   if UIPopPanel.UseItemNum==1 then
      return
   end
   if UIPopPanel.UseItemNum<=11 then
      UIPopPanel.UseItemNum = 1
   else
      UIPopPanel.UseItemNum = UIPopPanel.UseItemNum - 10
   end
   this:SetUseItemNum(UIPopPanel.UseItemNum)
end

function UIPopPanel:CloseUseMorePanel()
   if UIPopPanel.UseMoreItemPanel~=nil then
      UIPopPanel.UseMoreItemPanel.gameObject:SetActive(false)
   end
   this:CloseUIPopPanel()
end

function UIPopPanel:CloseUseItemPanel()
   if UIPopPanel.UseItemPanel~=nil then
      UIPopPanel.UseItemPanel.gameObject:SetActive(false)
   end
   if UIPopPanel.UseMoreItemPanel~=nil then
      UIPopPanel.UseMoreItemPanel.gameObject:SetActive(false)
   end
   UIPopPanel.UseItemNum = 1 
   this:CloseUIPopPanel()
end

UIPopPanel.BuyDiamondPanel = nil
function UIPopPanel:PopBuyDiamond(data)                                         --购买钻石面板

end

UIPopPanel.BuyCoinPanel = nil
function UIPopPanel:PopBuyCoin(data)                                            --购买金币面板

end

UIPopPanel.BuyMorePanel = nil                                                        --购买多个道具使用面板
UIPopPanel.BuyNum = 0
UIPopPanel.BuyMoreItem = nil
function UIPopPanel:PopBuyMoreMaterial(data)
   if UIPopPanel.BuyMorePanel==nil then
      MainGameUI.CreateLittleItem("BuyMoreMaterialPanel" , "BuyMoreMaterialPanel" , UIPopPanel.UIPopPanelGob , data , this.CreatePopBuyItemsPanel , "UIPopPanel")
   else
      this:CreatePopBuyItemsPanel(UIPopPanel.BuyMorePanel , data) 
   end
end

function UIPopPanel:CreatePopBuyItemsPanel(_Gob , _Info)
   
   _Gob.gameObject:SetActive(true)
   _Gob.transform:FindChild("Materials"):FindChild("MaterialIMG"):GetComponent("UISprite").spriteName = ItemsDataSys.GetResourceIMG(_Info.NeedId)
   UIPopPanel.BuyMoreItem = _Info
   UIPopPanel.BuyMorePanel = _Gob
   UIPopPanel.BuyMorePanel.transform.localPosition = Vector3(0 , 0 , -1000)
   UIPopPanel.BuyNum = 1
   this:SetMateralNum(UIPopPanel.BuyNum)
end

function UIPopPanel:SetMateralNum(_Num)
   UIPopPanel.BuyMorePanel.transform:FindChild("MaterialNum"):FindChild("Num"):GetComponent("UILabel").text = tostring(_Num)
   UIPopPanel.BuyMorePanel.transform:FindChild("Materials"):FindChild("MatericalNum"):GetComponent("UILabel").text = tostring(_Num*UIPopPanel.BuyMoreItem.NeedQtt)
end


function UIPopPanel:SetMaterialLeftNum()
   if UIPopPanel.BuyNum==1 then
      return
   end
   UIPopPanel.BuyNum = UIPopPanel.BuyNum - 1
   this:SetMateralNum(UIPopPanel.BuyNum)
end

function UIPopPanel:SetMaterialRightNum()
   local ItemCount = UIPopPanel.BuyMoreItem.CanBuyNum
   if ItemCount==-1 then
      ItemCount = 999
   end
   if UIPopPanel.BuyNum==ItemCount then
      return
   end
   UIPopPanel.BuyNum = UIPopPanel.BuyNum + 1
   this:SetMateralNum(UIPopPanel.BuyNum)
end

function UIPopPanel:CloseBuyMorePanel()
   if UIPopPanel.BuyMorePanel~=nil then
      UIPopPanel.BuyMorePanel.gameObject:SetActive(false)
   end
   this:CloseUIPopPanel()
end

--产出地
UIPopPanel.ProductionPanel = nil
UIPopPanel.ProductionList = {}                  --产出地
function UIPopPanel:PopProductionPanel(data)
   if UIPopPanel.ProductionPanel==nil then
      MainGameUI.CreateLittleItem("ProductionPanel" , "ProductionPanel" , UIPopPanel.UIPopPanelGob , data , this.CreateProductionPanel , "UIPopPanel")
   else
      this:CreateProductionPanel(UIPopPanel.ProductionPanel , data) 
   end
end

function UIPopPanel:CreateProductionPanel(_Gob , _Info)
    _Gob.gameObject:SetActive(true)
    UIPopPanel.ProductionPanel = _Gob
    UIPopPanel.ProductionPanel.transform.localPosition = Vector3(0 , 0 , -1000)


    
    local father = _Gob.transform:FindChild("ProductionPanel"):FindChild("ProductionPanel"):FindChild("ProductionGrid")
    local Count = #UIPopPanel.ProductionList
    for i = 1 , Count , 1 do
        UIPopPanel.ProductionList[i].Gob.gameObject:SetActive(false)
    end

    local Production = GameMain.JsonDecode(tostring(_Info))
  
   -- local Production = GameMain.JsonDecode(tostring(_Info.ProductionInfo))
    local ProductionCount = #Production
    for i = 1 , ProductionCount , 1 do
        if Production[i]~=nil then
           local ProData = Production[i]
           if UIPopPanel.ProductionList[i]~=nil then
              local data =
              {
                 ProData = ProData,
                 Number = i,
                 Father = father,
              }
              this:CreateProductionItems(UIPopPanel.ProductionList[i].Gob , data)
           else
              local data =
              {
                 ProData = ProData,
                 Number = i,
                 Father = father,
              }
              MainGameUI.CreateLittleItem(tostring(i) , "ProductionItem" , father , data , this.CreateProductionItems , "UIPopPanel")
           end
        end 
    end
end

function UIPopPanel:CreateProductionItems(_Gob , _Info)
   _Gob.gameObject:SetActive(true)
   GameMain.AddComponent(_Gob,"UIDragScrollView")
   this:SetProductionItem(_Gob , _Info.ProData)

   UIPopPanel.ProductionList[_Info.Number] =
   {
      Gob = _Gob,
      ProData = _Info.ProData,
   }

   _Info.Father:GetComponent("UIGrid").enabled = true
   _Info.Father:GetComponent("UIGrid"):Reposition()
end

function UIPopPanel:SetProductionItem(_Gob , _Info)
    UIPopPanel.ProductionPanel.transform:FindChild("ProductionPanel").gameObject:SetActive(false)
    UIPopPanel.ProductionPanel.transform:FindChild("ProductionDescrip").gameObject:SetActive(false)
    local Position  = _Info.p
    local Id = _Info.id
    if Position == "map" then
       UIPopPanel.ProductionPanel.transform:FindChild("ProductionPanel").gameObject:SetActive(true)
       local Map = MapDataSys.GetNowMapById(tonumber(Id))
       if Map~=nil then
           _Gob.transform:FindChild("StarInfo"):FindChild("StarNum"):FindChild("StarImg1").gameObject:SetActive(false)
           _Gob.transform:FindChild("StarInfo"):FindChild("StarNum"):FindChild("StarImg2").gameObject:SetActive(false)
           _Gob.transform:FindChild("StarInfo"):FindChild("StarNum"):FindChild("StarImg3").gameObject:SetActive(false)
           if Map.Star==1 then
              _Gob.transform:FindChild("StarInfo"):FindChild("StarNum"):FindChild("StarImg1").gameObject:SetActive(true)
           elseif Map.Star==2 then
              _Gob.transform:FindChild("StarInfo"):FindChild("StarNum"):FindChild("StarImg1").gameObject:SetActive(true)
              _Gob.transform:FindChild("StarInfo"):FindChild("StarNum"):FindChild("StarImg2").gameObject:SetActive(true)
           elseif Map.Star==3 then
              _Gob.transform:FindChild("StarInfo"):FindChild("StarNum"):FindChild("StarImg1").gameObject:SetActive(true)
              _Gob.transform:FindChild("StarInfo"):FindChild("StarNum"):FindChild("StarImg2").gameObject:SetActive(true)
              _Gob.transform:FindChild("StarInfo"):FindChild("StarNum"):FindChild("StarImg3").gameObject:SetActive(true)
           end

           _Gob.transform:FindChild("MapInfo"):FindChild("MapName"):GetComponent("UILabel").text = Map.Name
           _Gob.transform:FindChild("MapInfo"):FindChild("MapTimes"):GetComponent("UILabel").text = tostring(Map.LeftTimes)
       end
    else
        UIPopPanel.ProductionPanel.transform:FindChild("ProductionDescrip").gameObject:SetActive(true)
        UIPopPanel.ProductionPanel.transform:FindChild("ProductionDescrip"):FindChild("Descrip"):GetComponent("UILabel").text = Id
        if Position == "jjc" then

        elseif Position == "tt" then

        elseif Position == "xs" then

        elseif Position == "qjgc" then

        elseif Position == "qt" then
           

        end
    end
end

function UIPopPanel.GoMap(_Key)                              --打开副本界面
   local ProData = UIPopPanel.ProductionList[_Key].ProData
   local Position  = ProData.p
   local Id = ProData.id
   if Position == "map" then
      local Map = MapDataSys.GetNowMapById(tonumber(Id))
      local Chapter = Map.Chapter
      local MapPos = Map.MapId
      local UIMapTar = MainGameUI.FindPanelTarget("UIMap")
      if UIMapTar~=nil then
         UIMapTar:OpenMapChatperPanel(Chapter , MapPos , Map.BattleType)
      end
   end
end

function UIPopPanel:OpenMap(_Key)
    local _father =  MainGameUI.FindPanel("UIControl")	
	MainGameUI.OpenOnePanel("UIMap" , "UIMap" , "UIMap" , _father , UIPopPanel.GoMap , _Key)
end

function UIPopPanel:CloseProductionPanel()
   if UIPopPanel.ProductionPanel~=nil then
      UIPopPanel.ProductionPanel.gameObject:SetActive(false)
   end
   this:CloseUIPopPanel()
end


--技能描述面板
UIPopPanel.SkillPanel = nil
function UIPopPanel:PopSkillPanel(_SkillInfo)
   local data =
   {
       SkillInfo = _SkillInfo,
   }
   if UIPopPanel.SkillPanel==nil then
      MainGameUI.CreateLittleItem("SkillInfoPanel" , "SkillInfoPanel" , UIPopPanel.UIPopPanelGob , data , this.CreateSkillPanel , "UIPopPanel")
   else
      this:CreateSkillPanel(UIPopPanel.SkillPanel , data) 
   end
end

function UIPopPanel:CreateSkillPanel(_Gob , _Info)

   _Gob.gameObject:SetActive(true)
   UIPopPanel.SkillPanel = _Gob
   UIPopPanel.SkillPanel.transform:FindChild("SkillName"):GetComponent("UILabel").text = _Info.SkillInfo.SkillName
   local _Sprite = UIPopPanel.SkillPanel.transform:FindChild("SkillHead"):FindChild("SkillIcon"):FindChild("SkillIMG"):GetComponent("UISprite")
   AtlasMsg.SetAtlas(_Sprite , _Info.SkillInfo.AtlasName , _Info.SkillInfo.SpriteName)

   local SkillData = SkillData.GetSkillDataCf(tonumber(_Info.SkillInfo.SkillId))
  -- GameMain.Print(SkillData , "SkillData")
   local Descrip = SkillBuffDescrip.GetSkillDescrip(_Info.SkillInfo.SkillLevel , _Info.SkillInfo.SkillQuality , SkillData)
   UIPopPanel.SkillPanel.transform:FindChild("SkillDescrip"):GetComponent("UILabel").text = Descrip
end

function UIPopPanel:CloseSkillPanel()
   if UIPopPanel.SkillPanel~=nil then
      UIPopPanel.SkillPanel.gameObject:SetActive(false)
   end
   this:CloseUIPopPanel()
end

--补签提示面板
UIPopPanel.ResignPanel = nil
UIPopPanel.ResignDays = 0
function UIPopPanel:PopResignPanel(_ResignData)
   if UIPopPanel.ResignPanel==nil then
      MainGameUI.CreateLittleItem("ResignPanel" , "ResignPanel" , UIPopPanel.UIPopPanelGob , _ResignData , this.CreateResignPanel , "UIPopPanel")
   else
      this:CreateResignPanel(UIPopPanel.ResignPanel , _ResignData) 
   end
end

function UIPopPanel:CreateResignPanel(_Gob , _Info)
   _Gob.gameObject:SetActive(true)
   UIPopPanel.ResignDays = _Info
   UIPopPanel.ResignPanel = _Gob
   UIPopPanel.ResignPanel.transform:FindChild("Descrip"):GetComponent("UILabel").text = UIstring.ResignTip..tostring(UIPopPanel.ResignDays)..UIstring.AntCi
   UIPopPanel.ResignPanel.transform:FindChild("ResignOne"):FindChild("DiamondNum"):GetComponent("UILabel").text = tostring(99)
   UIPopPanel.ResignPanel.transform:FindChild("ResignN"):FindChild("DiamondNum"):GetComponent("UILabel").text = tostring(99*UIPopPanel.ResignDays)
   UIPopPanel.ResignPanel.transform:FindChild("ResignN"):FindChild("Word"):GetComponent("UILabel").text = UIstring.Resign..tostring(UIPopPanel.ResignDays)..UIstring.AntCi
end

function UIPopPanel:CloseResignPanel()
   if UIPopPanel.ResignPanel~=nil then
      UIPopPanel.ResignPanel.gameObject:SetActive(false)
   end
   this:CloseUIPopPanel()
end


--物品详细说明
UIPopPanel.ItemInfoPanel = nil
function UIPopPanel:PopItemInfoPanel(_ItemData)
   if UIPopPanel.ItemInfoPanel==nil then
      MainGameUI.CreateLittleItem("ItemInfoPanel" , "ItemInfoPanel" , UIPopPanel.UIPopPanelGob , _ItemData , this.CreateItemInfoPanel , "UIPopPanel")
   else
      this:CreateItemInfoPanel(UIPopPanel.ItemInfoPanel , _ItemData) 
   end
end

function UIPopPanel:CreateItemInfoPanel(_Gob , _Info)
   if _Info~=nil then
      _Gob.gameObject:SetActive(true)
      UIPopPanel.ItemInfoPanel = _Gob
      UIPopPanel.ItemInfoPanel.transform:FindChild("ItemInfo"):FindChild("ItemName"):GetComponent("UILabel").text = _Info.Name
      UIPopPanel.ItemInfoPanel.transform:FindChild("ItemInfo"):FindChild("Descrip"):GetComponent("UILabel").text = _Info.Descrip
      local _Sprite = UIPopPanel.ItemInfoPanel.transform:FindChild("ItemHead"):FindChild("ItemIcon"):FindChild("ItemIMG"):GetComponent("UISprite")
      AtlasMsg.SetAtlas(_Sprite , _Info.AtlasName , _Info.SpriteName)
      UIPopPanel.ItemInfoPanel.transform:FindChild("ItemHead"):FindChild("ItemIcon"):FindChild("ItemFg"):GetComponent("UISprite").spriteName = UIstring.ItemFg[_Info.Quality]

      UIPopPanel.ItemInfoPanel.transform:FindChild("ItemHead"):FindChild("ItemIcon"):FindChild("ItemDebris").gameObject:SetActive(false)
      if _Info.ItemType==2 then 
         UIPopPanel.ItemInfoPanel.transform:FindChild("ItemHead"):FindChild("ItemIcon"):FindChild("ItemDebris").gameObject:SetActive(true)
      end

   end
end

function UIPopPanel:CloseItemInfoPanel()
   if UIPopPanel.ItemInfoPanel~=nil then
      UIPopPanel.ItemInfoPanel.gameObject:SetActive(false)
   end
   this:CloseUIPopPanel()
end

--选择性面板 确定 取消
UIPopPanel.ChoseRulePanel = nil
function UIPopPanel:PopChoseRulePanel(_Data)
   if UIPopPanel.ChoseRulePanel==nil then
      MainGameUI.CreateLittleItem("ChoseRulePanel" , "ChoseRulePanel" , UIPopPanel.UIPopPanelGob , _Data , this.CreateChoseRulePanel , "UIPopPanel")
   else
      this:CreateChoseRulePanel(UIPopPanel.ChoseRulePanel , _Data) 
   end
end

function UIPopPanel:CreateChoseRulePanel(_Gob , _Info)
   if _Info~=nil then
      _Gob.gameObject:SetActive(true)
      UIPopPanel.ChoseRulePanel = _Gob     
      UIPopPanel.ChoseRulePanel.transform:FindChild("Descrip"):GetComponent("UILabel").text = _Info.Descrip
   end
end

function UIPopPanel:CloseChoseRulePanel()
   if UIPopPanel.ChoseRulePanel~=nil then
      UIPopPanel.ChoseRulePanel.gameObject:SetActive(false)
   end
   this:CloseUIPopPanel()
end

--网络错误
UIPopPanel.NetErrorPanel = nil
function UIPopPanel:PopNetErrorPanel(_Data)
   if UIPopPanel.NetErrorPanel==nil then
      MainGameUI.CreateLittleItem("NetErrorPanel" , "NetErrorPanel" , UIPopPanel.UIPopPanelGob , _Data , this.CreateNetErrorPanel , "UIPopPanel")
   else
      this:CreateNetErrorPanel(UIPopPanel.NetErrorPanel , _Data) 
   end
end

function UIPopPanel:CreateNetErrorPanel(_Gob , _Info)
   if _Info~=nil then
      _Gob.gameObject:SetActive(true)
      LoadingPanel.StopLoading() 
      UIPopPanel.NetErrorPanel = _Gob     
      --UIPopPanel.NetErrorPanel.transform:FindChild("Descrip"):GetComponent("UILabel").text = ""
      UIPopPanel.NetErrorPanel.transform.localPosition = Vector3(0 , 0 , -2000)
   end
end

function UIPopPanel:CloseNetErrorPanel()
   if UIPopPanel.NetErrorPanel~=nil then
      UIPopPanel.NetErrorPanel.gameObject:SetActive(false)
   end
   this:CloseUIPopPanel()
end

--改变阵型
UIPopPanel.TeamChangePanel = nil
function UIPopPanel:PopTeamChangePanel(_Data)
   if UIPopPanel.TeamChangePanel == nil then
      MainGameUI.CreateLittleItem("ChangeTeamPanel" , "ChangeTeamPanel" , UIPopPanel.UIPopPanelGob , _Data , this.CreateTeamChangePanel , "UIPopPanel")
   else
      this:CreateTeamChangePanel(UIPopPanel.TeamChangePanel , _Data) 
   end
end

function UIPopPanel:CreateTeamChangePanel(_Gob , _Info)
   _Gob.gameObject:SetActive(true)
   for i = 1 , 4 , 1 do
       if _Info[i]==0 then
          _Gob.transform:FindChild(tostring(i)):FindChild("BG"):GetComponent("UISprite").spriteName = "huiseanniu"
          _Gob.transform:FindChild(tostring(i)):GetComponent("BoxCollider").enabled = false
       elseif _Info[i]==1 then
          _Gob.transform:FindChild(tostring(i)):FindChild("BG"):GetComponent("UISprite").spriteName = "anniu"
          _Gob.transform:FindChild(tostring(i)):GetComponent("BoxCollider").enabled = true
       end
   end
   UIPopPanel.TeamChangePanel = _Gob     
   UIPopPanel.TeamChangePanel.transform.localPosition = Vector3(0 , 0 , -2000)
end

function UIPopPanel:CloseTeamChangePanel()
   if UIPopPanel.TeamChangePanel~=nil then
      UIPopPanel.TeamChangePanel.gameObject:SetActive(false)
   end
   --this:CloseUIPopPanel()
end

--使用元宝确认界面
UIPopPanel.CostMoneyPanel = nil
function UIPopPanel:PopCostMoneyPanel(_Data)
   if UIPopPanel.CostMoneyPanel == nil then
      MainGameUI.CreateLittleItem("CostMoneyPanel" , "CostMoneyPanel" , UIPopPanel.UIPopPanelGob , _Data , this.CreateCostMoneyPanel , "UIPopPanel")
   else
      this:CreateCostMoneyPanel(UIPopPanel.CostMoneyPanel , _Data) 
   end
end

function UIPopPanel:CreateCostMoneyPanel(_Gob , _Info)
   _Gob.gameObject:SetActive(true)
   --_Gob.transform:FindChild("Descrip"):GetComponent("UILabel").text = _Info.Descrip
   _Gob.transform:FindChild("Money"):GetComponent("UILabel").text = tostring(_Info.Money)
   UIPopPanel.CostMoneyPanel = _Gob     
   UIPopPanel.CostMoneyPanel.transform.localPosition = Vector3(0 , 0 , -2000)
end

function UIPopPanel:CloseCostMoneyPanel()
   if UIPopPanel.CostMoneyPanel~=nil then
      UIPopPanel.CostMoneyPanel.gameObject:SetActive(false)
   end
   this:CloseUIPopPanel()
end

function UIPopPanel:UIHand(_LuaName , _Gob)
    MusicManagerSys.ButtonClick()   
	if _Gob~=nil then
          if _Gob.name == "useBtn" then
             if UIPopPanel.CallBack~=nil then
                local data = 
                {
                    Item = UIPopPanel.Buy_SellItemInfo,
                    Num = UIPopPanel.UseCount,
                }
                UIPopPanel.CallBack(data)
             end
             this:CloseBuy_SellPanel()
          end
          if _Gob.name == "subOne" then
             this:Sub(1)
          end
		  if _Gob.name == "subTen" then
             this:Sub(10)
          end
          if _Gob.name == "addOne" then
             this:Plus(1)
          end
		  if _Gob.name == "addTen" then
             this:Plus(10)
          end
          if _Gob.name == "BlackBg" then
             this:CloseBuy_SellPanel()
          end


          if _Gob.name=="UseOne" then  --使用道具 
            if UIPopPanel.CallBack~=nil then
                local data = 
                {
                    Item = UIPopPanel.UseItem,
                    Num = 1,
                }
                UIPopPanel.CallBack(data)
             end
             this:CloseUseItemPanel()
	      end 
       
          if _Gob.name=="UseMore" then             
             this:PopUseMoreItemPanel()
          end

          if _Gob.name=="LeftPovin" then
             this:SetLeftNum()
          end

          if _Gob.name=="RightPovin" then
             this:SetRightNum()
          end

          if _Gob.name=="UseItem" then                                             
             if UIPopPanel.CallBack~=nil then
                local data =
                {
                   Item = UIPopPanel.UseItem,
                   Num = UIPopPanel.UseItemNum,
                }
                UIPopPanel.CallBack(data)
                UIPopPanel.CallBack = nil
             end
             this:CloseUseItemPanel()
          end

          if _Gob.name=="UseMorePanel" then
             this:CloseUseMorePanel()
          end

          if _Gob.name=="CloseUseItemButton" then
             this:CloseUseItemPanel()
	      end            

          --购买多个道具
          if _Gob.name=="MaterialBuyButton" then
             if UIPopPanel.CallBack~=nil then
                local data =
                {
                   Num = UIPopPanel.BuyNum,
                }
                UIPopPanel.CallBack(data)
                UIPopPanel.CallBack = nil
             end
             this:CloseBuyMorePanel()
          end

          if _Gob.name=="LeftMaterialPovin" then
             this:SetMaterialLeftNum()
          end

          if _Gob.name=="RightMaterialPovin" then
             this:SetMaterialRightNum()
          end

          if _Gob.name=="BuyMoreMaterialPanel" then
             this:CloseBuyMorePanel()
          end
            
          --产出界面按钮事件
          
          if _Gob.name=="FightButton" then
             if UIPopPanel.CallBack~=nil then
                UIPopPanel.CallBack()
                UIPopPanel.CallBack = nil
             end
             if _Gob.transform.parent~=nil then  
                local key = tonumber(_Gob.transform.parent.name)
                this:OpenMap(key)
                this:CloseProductionPanel()
             end
          end

          if _Gob.name=="CloseProductionButton" then
             this:CloseProductionPanel()
          end

          --技能描述面板
          if _Gob.name == "CloseSkillInfoButton" then
              this:CloseSkillPanel()
          end


          --补签提示
          if _Gob.name == "CloseResignPanelButton" then
             this:CloseResignPanel()
          end       
          if _Gob.name == "ResignOne" then
             if UIPopPanel.CallBack~=nil then
                UIPopPanel.CallBack(1)
                UIPopPanel.CallBack = nil
             end
             this:CloseResignPanel()
          end
          if _Gob.name == "ResignN" then
             if UIPopPanel.CallBack~=nil then
                UIPopPanel.CallBack(UIPopPanel.ResignDays)
                UIPopPanel.CallBack = nil
             end
             this:CloseResignPanel()
          end
           
          --道具信息面板
          if _Gob.name == "CloseItemInfoButton" then
             this:CloseItemInfoPanel()
          end

          if _Gob.name == "ItemInfoPanel" then
             this:CloseItemInfoPanel()
          end

          --选择规则说明面板
          if _Gob.name == "SureButton" then
             UIPopPanel.CallBack()
             UIPopPanel.CallBack = nil
             this:CloseChoseRulePanel()
          end

          if _Gob.name == "CancelButton" then
             UIPopPanel.CallBack = nil
             this:CloseChoseRulePanel()
          end 

          --网络错误面板
          if _Gob.name == "SureNet" then
             if UIPopPanel.CallBack~=nil then
                UIPopPanel.CallBack()
             end
             UIPopPanel.CallBack = nil
             LoadingPanel.StopLoading()
             LoadingPanel.StopLoadingModel()
             this:CloseNetErrorPanel()
          end

          if _Gob.name == "NetErrorPanel" then
             if UIPopPanel.CallBack~=nil then
                UIPopPanel.CallBack()
             end
             UIPopPanel.CallBack = nil
             LoadingPanel.StopLoading()
             LoadingPanel.StopLoadingModel()
             this:CloseNetErrorPanel()
          end

          --更换队伍
          if _Gob.transform.parent.name == "ChangeTeamPanel" then
             UIPopPanel.CallBack(tonumber(_Gob.transform.name))
             UIPopPanel.CallBack = nil   
             this:CloseTeamChangePanel()  
          end

          if _Gob.name == "ChangeTeamPanel" then
             UIPopPanel.CallBack = nil
             this:CloseTeamChangePanel()
          end

          --花费元宝确认框       

          if _Gob.name == "CostMoneyPanel" then
             UIPopPanel.CallBack = nil
             this:CloseCostMoneyPanel()
          end

          if _Gob.name == "SureCostMoney" then
             UIPopPanel.CallBack()
             UIPopPanel.CallBack = nil
             this:CloseCostMoneyPanel()
          end

          if _Gob.name == "CancelCostMoney" then
             UIPopPanel.CallBack = nil
             this:CloseCostMoneyPanel()
          end
	   end
end

function UIPopPanel:ClosePanel()
    if UIPopPanel.BuySta_EnergyPanel~=nil then

    end
    if UIPopPanel.BuyDiamondPanel~=nil then

    end
    if UIPopPanel.BuyCoinPanel~=nil then

    end
    this:CloseUseItemPanel()
    this:CloseUseMorePanel()
    this:CloseBuyMorePanel()
    this:CloseProductionPanel()
    this:CloseSkillPanel()
    this:CloseResignPanel()
    this:CloseItemInfoPanel()
    this:CloseChoseRulePanel()

    this:InitMainUI()
end

function UIPopPanel.UpdatePanel(deletime)
   if UIPopPanel.State==1 then
		UIPopPanel.NowTime = UIPopPanel.NowTime + deletime
		local beilv = UIPopPanel.NowTime/UIPopPanel.TotalTime
		local MoveY = Mathf.Lerp(UIPopPanel.NowY , UIPopPanel.TarY ,beilv)
        UIPopPanel.TipWord.transform.localPosition = Vector3(UIPopPanel.TipWord.transform.localPosition.x , MoveY , UIPopPanel.TipWord.transform.localPosition.z)
		if UIPopPanel.NowTime >= UIPopPanel.TotalTime then
			UIPopPanel.NowTime = 0
			UIPopPanel.State = 0
            UIPopPanel.TipWord.gameObject:SetActive(false)
--            this:CloseUIPopPanel()
		end
	end

    if UIPopPanel.PopState==1 then
       UIPopPanel.PopNowTime = UIPopPanel.PopNowTime + deletime
       if UIPopPanel.PopNowTime >= UIPopPanel.PopPropTotalTime then        
          UIPopPanel.PopNumber = UIPopPanel.PopNumber + 1     
          if UIPopPanel.PopNumber<=#UIPopPanel.PopList then
             UIPopPanel.GobNumber = UIPopPanel.GobNumber + 1
             this:PopProp(UIPopPanel.GobNumber , UIPopPanel.PopNumber)
             if UIPopPanel.GobNumber==6 then
                UIPopPanel.GobNumber = 1
                this:CloseUIPopPanel()
             end
          else
             UIPopPanel.PopState = 0
          end                 
          UIPopPanel.PopNowTime = 0          
       end
    end
end

function UIPopPanel:CloseUIPopPanel()
   UIPopPanel.UIPopPanelGob.gameObject:SetActive(false)
end

function UIPopPanel:ReleasPanel()               				 --重启游戏时释放和界面初始化
	GameMain.DelUpdateLua(this.UpdatePanel)

    UIPopPanel.UIPopPanelGob = nil

    UIPopPanel.NowTime = 0
    UIPopPanel.TotalTime = 1
    UIPopPanel.State = 0
    UIPopPanel.NowX = 0
    UIPopPanel.TarX = 0

    UIPopPanel.PopNowTime = 0
    UIPopPanel.PopPropTotalTime = 0.5
    UIPopPanel.PopState = 0
    UIPopPanel.PopNumber = 1
    UIPopPanel.GobNumber = 1
    UIPopPanel.PopList = nil

    UIPopPanel.TipWord = nil
    UIPopPanel.PropChangePanel = nil

    UIPopPanel.CallBack = nil
    UIPopPanel.Buy_SellPanel = nil
    UIPopPanel.BuySta_EnergyPanel = nil

    UIPopPanel.UseItemPanel = nil
    UIPopPanel.UseItem = nil
    UIPopPanel.UseMoreItemPanel = nil                                                                            
    UIPopPanel.UseItemNum = 1

    UIPopPanel.BuyDiamondPanel = nil
    UIPopPanel.BuyCoinPanel = nil

    UIPopPanel.BuyMorePanel = nil                                                       
    UIPopPanel.BuyNum = 0
    UIPopPanel.BuyMoreItem = nil

    UIPopPanel.ProductionPanel = nil
    UIPopPanel.ProductionList = {}

    UIPopPanel.SkillPanel = nil

    UIPopPanel.ResignPanel = nil
    UIPopPanel.ResignDays = 0

    UIPopPanel.ItemInfoPanel = nil

    UIPopPanel.ChoseRulePanel = nil
    UIPopPanel.NetErrorPanel = nil

    UIPopPanel.TeamChangePanel = nil
end


return UIPopPanel