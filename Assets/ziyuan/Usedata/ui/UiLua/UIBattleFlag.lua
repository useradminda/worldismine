UIBattleFlag = {}
local UIBattleFlag = BasePanel:new()     
local this = UIBattleFlag
UIBattleFlag.UIBattleFlagGob = nil

UIBattleFlag.FlagPanelType = 1                    --1 穿战旗界面  2 战旗合成 3 战旗转换
UIBattleFlag.TempPanel = nil

function UIBattleFlag:OpenUI(_PanelName , _LuaName)
	if UIBattleFlag.UIBattleFlagGob==nil then
	   UIBattleFlag.UIBattleFlagGob=MainGameUI.FindPanel("UIBattleFlag")		
	end
	
    UIBattleFlag.FlagPanelType = 0
    this:InitButton()
    this:OpenPanel(1)
    this:CreateFlags()
    this:InitComp()
    UIBattleFlag.TypePanelOpenState = 0
    UIBattleFlag.LvlPanelOpenState = 0
end

function UIBattleFlag:OpenPanel(_Type)                                              --打开某个战旗界面
   if _Type==UIBattleFlag.FlagPanelType then
      return
   end
   if UIBattleFlag.TempPanel~=nil then
      UIBattleFlag.TempPanel.transform.localPosition = Vector3(-300 , 1000 , 0)
   end

   UIBattleFlag.FlagPanelType = _Type
   if _Type==1 then
      this:OpenUpFlagsPanel()
      this:ChangeButton(UIBattleFlag.FlagBtn)
      UIBattleFlag.TempPanel = UIBattleFlag.UpFlagsPanel
   elseif _Type==2 then
      this:OpenCombinePanel()
      this:ChangeButton(UIBattleFlag.CombineBtn)
      UIBattleFlag.TempPanel = UIBattleFlag.CombineFlagPanel
   elseif _Type==3 then
      this:OpenTransFlag()
      this:ChangeButton(UIBattleFlag.TransformBtn)
      UIBattleFlag.TempPanel = UIBattleFlag.TransFlagPanel
   end 
end

UIBattleFlag.FlagBtn = nil
UIBattleFlag.CombineBtn = nil
UIBattleFlag.TransformBtn = nil
UIBattleFlag.TempBtn = nil
function UIBattleFlag.InitButton()
   if UIBattleFlag.FlagBtn==nil then
      UIBattleFlag.FlagBtn = UIBattleFlag.UIBattleFlagGob.transform:FindChild("left"):FindChild("Flag")
      UIBattleFlag.CombineBtn = UIBattleFlag.UIBattleFlagGob.transform:FindChild("left"):FindChild("Combine")
      UIBattleFlag.TransformBtn = UIBattleFlag.UIBattleFlagGob.transform:FindChild("left"):FindChild("Transform")
   end
end

function UIBattleFlag:ChangeButton(_Btn) 
   if UIBattleFlag.TempBtn ~=nil then
      UIBattleFlag.TempBtn.transform:FindChild("ChoseBG").transform.localPosition = Vector3(0 , 1000 , 0)
      UIBattleFlag.TempBtn.transform:FindChild("BG").transform.localPosition = Vector3(0 , 0 , 0)
   end
   UIBattleFlag.TempBtn = _Btn
   UIBattleFlag.TempBtn.transform:FindChild("ChoseBG").transform.localPosition = Vector3(0 , 0 , 0)
   UIBattleFlag.TempBtn.transform:FindChild("BG").transform.localPosition = Vector3(0 ,1000 , 0)
end

UIBattleFlag.FlagsGrid = nil
UIBattleFlag.FlagItmes = {}
UIBattleFlag.FlagList = {}
UIBattleFlag.UIWrap = nil
function UIBattleFlag:CreateFlags()                                             --创建包裹里的战旗
    if UIBattleFlag.FlagsGrid==nil then
       UIBattleFlag.FlagsGrid = UIBattleFlag.UIBattleFlagGob.transform:FindChild("right"):FindChild("FlagPanel"):FindChild("FlagGrid")
    end
    if UIBattleFlag.UIWrap == nil then
       UIBattleFlag.UIWrap = UIBattleFlag.UIBattleFlagGob.transform:FindChild("right"):GetComponent("UIWrap")
    end

    for i = 1 , #BattleFlagSys.BattleFlagList , 1 do
        UIBattleFlag.FlagList[i] =
        {
           FlagData = BattleFlagSys.BattleFlagList[i],
        }
    end

    if #UIBattleFlag.FlagItmes==0 then
       for i = 1 , 25 , 1 do
           local data = 
           {
               Index = i,
           }
           MainGameUI.CreateLittleItem(tostring(i) , "FlagItem" , UIBattleFlag.FlagsGrid , data , this.CreateFlagsCallBack  , "UIBattleFlag")
       end
    else
       UIBattleFlag.UIBattleFlagGob.transform:FindChild("right"):FindChild("FlagPanel").localPosition = Vector3(0 , 0 , 0)
       UIBattleFlag.UIWrap:ResetTrans(#BattleFlagSys.BattleFlagList)
       UIBattleFlag.FlagsGrid:GetComponent("UIGrid").enabled = true
       UIBattleFlag.FlagsGrid:GetComponent("UIGrid"):Reposition()
    end
end

function UIBattleFlag:CreateFlagsCallBack(_Gob , _Info)
   if UIBattleFlag.FlagList[_Info.Index]~=nil then
      local _IMGSprite = _Gob.transform:FindChild("IMG"):GetComponent("UISprite")
      local _FlagData = UIBattleFlag.FlagList[_Info.Index].FlagData
      AtlasMsg.SetAtlas(_IMGSprite , _FlagData.AtlasName , _FlagData.SpriteName)
      local _FSprite = _Gob.transform:FindChild("FG"):GetComponent("UISprite")     
      AtlasMsg.SetAtlas(_FSprite , UIstring.QualityAtlasName , UIstring.ItemFg[_FlagData.Quality])
      local _BSprite = _Gob.transform:FindChild("BG"):GetComponent("UISprite")     
      AtlasMsg.SetAtlas(_BSprite , UIstring.QualityBGAtlasName , UIstring.ItemFg[_FlagData.Quality])
      _Gob.transform:FindChild("Word"):GetComponent("UILabel").text = tostring(_FlagData.Lvl)..UIstring.Lvl.._FlagData.Name
      _Gob.transform:FindChild("Count"):GetComponent("UILabel").text = tostring(_FlagData.Count)
   end

   UIBattleFlag.FlagItmes[_Info.Index] =
   {
        FlagGob = _Gob,
   }

   if _Info.Index==25 then
       UIBattleFlag.FlagsGrid:GetComponent("UIGrid").enabled = true
       UIBattleFlag.FlagsGrid:GetComponent("UIGrid"):Reposition()
       UIBattleFlag.UIWrap:SetData(#BattleFlagSys.BattleFlagList , "UIBattleFlag")
   end

end

UIBattleFlag.ChoseTypePanel = nil
UIBattleFlag.ChoseLvlPanel = nil
function UIBattleFlag:OpenChoseTypePanel()
   if UIBattleFlag.ChoseTypePanel==nil then
      UIBattleFlag.ChoseTypePanel = UIBattleFlag.UIBattleFlagGob.transform:FindChild("right"):FindChild("ChoseTypePanel")
   end
   if UIBattleFlag.ChoseTypePanel.gameObject.activeInHierarchy == true then
      UIBattleFlag.ChoseTypePanel.gameObject:SetActive(false)
   else
      UIBattleFlag.ChoseTypePanel.gameObject:SetActive(true)
   end
end

function UIBattleFlag:OpenChoseLvlPanel()
   if UIBattleFlag.ChoseLvlPanel==nil then
      UIBattleFlag.ChoseLvlPanel = UIBattleFlag.UIBattleFlagGob.transform:FindChild("right"):FindChild("ChoseLvlPanel")
   end
   if UIBattleFlag.ChoseLvlPanel.gameObject.activeInHierarchy == true then
      UIBattleFlag.ChoseLvlPanel.gameObject:SetActive(false)
   else
      UIBattleFlag.ChoseLvlPanel.gameObject:SetActive(true)
   end
end

UIBattleFlag.ChoseSeries = 0
UIBattleFlag.ChoseType = 0
UIBattleFlag.ChoseLvl = 0
function UIBattleFlag:InitComp()
   UIBattleFlag.ChoseSeries = 0
   UIBattleFlag.ChoseType = 0
   UIBattleFlag.ChoseLvl = 0

   this:SetComp()

end

function UIBattleFlag:SetComp()
   UIBattleFlag.UIBattleFlagGob.transform:FindChild("right"):FindChild("ChoseTypeButton"):FindChild("Word"):GetComponent("UILabel").text = UIstring.Series[tostring(UIBattleFlag.ChoseSeries).."_"..tostring(UIBattleFlag.ChoseType)]
   UIBattleFlag.UIBattleFlagGob.transform:FindChild("right"):FindChild("ChoseLvlButton"):FindChild("Word"):GetComponent("UILabel").text = UIstring.FlagLvl[UIBattleFlag.ChoseLvl]
end

function UIBattleFlag:CompType(_Name)              --根据系别排序
   
   local _SeriesType = GameMain.StringSplit(_Name , "_")
   local _Series = tonumber(_SeriesType[1])
   local _Type = tonumber(_SeriesType[2])
   UIBattleFlag.ChoseSeries = _Series
   UIBattleFlag.ChoseType = _Type
   this:Comp()
   this:OpenChoseTypePanel()
   this:SetComp()
   UIBattleFlag.UIBattleFlagGob.transform:FindChild("right"):FindChild("FlagPanel").localPosition = Vector3(0 , 0 , 0)
   UIBattleFlag.UIBattleFlagGob.transform:FindChild("right"):FindChild("FlagPanel"):GetComponent("UIPanel").clipOffset = Vector2(0 , 0)
end

function UIBattleFlag:CompLvl(_Name)                 --根据等级排序
  local _Lvl = tonumber(_Name)
  UIBattleFlag.ChoseLvl = _Lvl
  this:Comp()
  this:OpenChoseLvlPanel()
  this:SetComp()
  UIBattleFlag.UIBattleFlagGob.transform:FindChild("right"):FindChild("FlagPanel").localPosition = Vector3(0 , 0 , 0)
  UIBattleFlag.UIBattleFlagGob.transform:FindChild("right"):FindChild("FlagPanel"):GetComponent("UIPanel").clipOffset = Vector2(0 , 0)
end

function UIBattleFlag:Comp()
   UIBattleFlag.FlagList = {}
   local _BattleList , _DataNum = BattleFlagSys.CompType(UIBattleFlag.ChoseSeries , UIBattleFlag.ChoseType , UIBattleFlag.ChoseLvl)           
   for i = 1 , #_BattleList , 1 do
       UIBattleFlag.FlagList[i] =
       {
           FlagData = _BattleList[i],
       }
   end
   
   UIBattleFlag.UIWrap:ReflashItems(_DataNum)
   UIBattleFlag.FlagsGrid:GetComponent("UIGrid").enabled = true
   UIBattleFlag.FlagsGrid:GetComponent("UIGrid"):Reposition()
end

function UIBattleFlag:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
   if _Gob.name=="Flag" then
      this:OpenPanel(1)  
   elseif _Gob.name == "BuyFlag" then
      DataUIInstance.OpenShop()    
   elseif _Gob.name=="Combine" then
      this:OpenPanel(2)     
   elseif _Gob.name=="Transform" then 
      this:OpenPanel(3)     
   elseif _Gob.name == "closeBtn" then
      this:CloseBattleFlag()
   elseif _Gob.name == "CombineFlag" then
      this:CombineFlag()
   elseif _Gob.name == "CombineAllFlag" then
      this:CombineFlagAll()
   elseif _Gob.name == "Transflag" then
      this:TransFlagEvent()
   elseif _Gob.name == "Plus" then
      this:Plus()
   elseif _Gob.name == "Sub" then 
      this:Sub()
   elseif _Gob.name == "ChoseTypeButton" then
      this:OpenChoseTypePanel()
   elseif _Gob.name == "ChoseLvlButton" then
      this:OpenChoseLvlPanel()
   elseif _Gob.transform.parent.name == "ChoseTypeGrid" then 
      this:CompType(_Gob.transform.name)
   elseif _Gob.transform.parent.name == "ChoseLvlGrid" then
      this:CompLvl(_Gob.transform.name)
   elseif _Gob.name == "ChoseTypeBox" then
      this:OpenChoseTypePanel()
   elseif _Gob.name == "ChoseLvlBox" then
      this:OpenChoseLvlPanel()   
   else         
         if UIBattleFlag.FlagPanelType ==1 then
            if _Gob.transform.parent.name == "FlagGrid" then
               local _Index = tonumber(_Gob.name)
               if _Index~=nil then
                  this:UpFlag(UIBattleFlag.FlagList[_Index].FlagData , _Index)  
               end           
            elseif _Gob.transform.parent.parent.name == "Flags" then
               local _Index = tonumber(_Gob.transform.parent.name)
               if _Index~=nil then
                  this:DownFlag(_Index)
               end
            end         
         elseif UIBattleFlag.FlagPanelType ==2 then
            local _Index = tonumber(_Gob.name)
            if _Index~=nil then
               this:UpCombineFlag(UIBattleFlag.FlagList[_Index].FlagData)
            end
         elseif UIBattleFlag.FlagPanelType ==3 then
            local _Index = tonumber(_Gob.name)
            if _Index~=nil then
                if _Gob.transform.parent.name == "FlagGrid" then
                   this:UpTransFlag(UIBattleFlag.FlagList[_Index].FlagData)
                elseif _Gob.transform.parent.name == "ChoseFlagGrid" then
                   this:ChoseFlag(_Index)
                end
            end
         end
   end

end

function UIBattleFlag:UIOnPress(_LuaName , _Gob , _isPress)--按钮按下显示相应的信息
	if _isPress==false then  
		this:CloseTipsPanel()	
	end                                
	if _isPress==true then  	 
		 if _Gob.transform.name=="Tip" then			 
	        this:ShowTip()             
		 end
	end
end


function UIBattleFlag:UpdateItem(_LuaName , _Item)
   this:ReflashItem(_Item)
end

function UIBattleFlag:ReflashItem(_Item)
   _Item.gameObject:SetActive(true)
   local _Index = tonumber(_Item.name)
   if UIBattleFlag.FlagList[_Index]~=nil then
      local _FlagData = UIBattleFlag.FlagList[_Index].FlagData
      if _FlagData~=nil then   
          local _IMGSprite = _Item.transform:FindChild("IMG"):GetComponent("UISprite")
          AtlasMsg.SetAtlas(_IMGSprite , _FlagData.AtlasName , _FlagData.SpriteName)
          local _FSprite = _Item.transform:FindChild("FG"):GetComponent("UISprite")     
          AtlasMsg.SetAtlas(_FSprite , UIstring.QualityAtlasName , UIstring.ItemFg[_FlagData.Quality])
          local _BSprite = _Item.transform:FindChild("BG"):GetComponent("UISprite")     
          AtlasMsg.SetAtlas(_BSprite , UIstring.QualityBGAtlasName , UIstring.ItemFg[_FlagData.Quality])
          _Item.transform:FindChild("Word"):GetComponent("UILabel").text = tostring(_FlagData.Lvl)..UIstring.Lvl.._FlagData.Name
          _Item.transform:FindChild("Count"):GetComponent("UILabel").text = tostring(_FlagData.Count)
      end   
   else
      _Item.gameObject:SetActive(false)
   end 

end

UIBattleFlag.TipPanel = nil
function UIBattleFlag:ShowTip()
   
   if UIBattleFlag.TipPanel==nil then
      UIBattleFlag.TipPanel = UIBattleFlag.UIBattleFlagGob.transform:FindChild("TipBg")
   end
   
   if UIBattleFlag.TipPanel.gameObject.activeInHierarchy==false then
      local Descrip = ""
      local Prop = BattleFlagDataSys.GetPropByLvl(BattleFlagSys.TotalFlag + 1) 
      Descrip = Descrip..UIstring.NextBattleLvl.."("..tostring(BattleFlagSys.TotalFlag + 1)..UIstring.Lvl..")" .."\n"
      Descrip = Descrip..UIstring.Attack.."+"..tostring(Prop).."\n"
      Descrip = Descrip..UIstring.Blood.."+"..tostring(Prop)
      UIBattleFlag.TipPanel:FindChild("Descrip"):GetComponent("UILabel").text = Descrip
      UIBattleFlag.TipPanel.gameObject:SetActive(true)
   end  

end

function UIBattleFlag:CloseTipsPanel()
	if UIBattleFlag.TipPanel~=nil then
       UIBattleFlag.TipPanel.gameObject:SetActive(false)
   end
end

--**********************战旗上阵
UIBattleFlag.UpFlagsPanel = nil
function UIBattleFlag:OpenUpFlagsPanel()
   if UIBattleFlag.UpFlagsPanel==nil then
      UIBattleFlag.UpFlagsPanel = UIBattleFlag.UIBattleFlagGob.transform:FindChild("left"):FindChild("BattleFlag")
   end

   UIBattleFlag.UpFlagsPanel.transform.localPosition = Vector3(-300 , -150 , 0)
   this:GetUpFlagsGob()
   UIBattleFlag.UpFlagEvent = false
end

UIBattleFlag.UpFlagsGob = {}                                                                            --1 2 3 4 5 5是天罚战旗
UIBattleFlag.UpFlagsFx = {}
UIBattleFlag.UpFlagsData = {}
UIBattleFlag.UpFlagEvent = false
function UIBattleFlag:GetUpFlagsGob()
   if #UIBattleFlag.UpFlagsGob==0 then
      for i = 1 , 5 , 1 do
          local _FlagsGob = UIBattleFlag.UpFlagsPanel.transform:FindChild("FlagPanel"):FindChild("Flags"):FindChild(tostring(i)):FindChild("FlagItem")
          local _FlagFx = UIBattleFlag.UpFlagsPanel.transform:FindChild("FlagPanel"):FindChild("Flags"):FindChild(tostring(i)):FindChild("FX_fuwen_xiangqian01")
          UIBattleFlag.UpFlagsGob[i] = _FlagsGob
          UIBattleFlag.UpFlagsFx[i] = _FlagFx
      end
      this:InitUpFlag()
   end
   this:SetFlagProps()
end


function UIBattleFlag:UpFlag(_Flag , _FlagNumber)                                                      --穿战旗  
   local _Index = this:GetFlagIndex(_Flag , _FlagNumber)
   if _Index==0 then
      return
   end
   UIBattleFlag.UpFlagEvent = true
   UIBattleFlag.UpFlagsGob[_Index].gameObject:SetActive(true)
   UIBattleFlag.UpFlagsFx[_Index].gameObject:SetActive(true)
   UIBattleFlag.UpFlagsFx[_Index].gameObject:GetComponent("ParticleSystem"):Stop()
   UIBattleFlag.UpFlagsFx[_Index].gameObject:GetComponent("ParticleSystem"):Play()
   local _IMGSp = UIBattleFlag.UpFlagsGob[_Index].transform:FindChild("IMG"):GetComponent("UISprite")
   UIBattleFlag.UpFlagsGob[_Index].transform:FindChild("Word"):GetComponent("UILabel").text = tostring(_Flag.Lvl)..UIstring.Lvl.._Flag.Name
   UIBattleFlag.UpFlagsGob[_Index].transform:FindChild("Count"):GetComponent("UILabel").text = ""
   AtlasMsg.SetAtlas(_IMGSp , _Flag.AtlasName , _Flag.SpriteName)
   this:SetFlagProps()
   DataUIInstance.PopTip("W3")
end

UIBattleFlag.AttackGong = nil
UIBattleFlag.AttackDun = nil
UIBattleFlag.AttackQaing = nil
UIBattleFlag.HPGong = nil
UIBattleFlag.HPDun = nil
UIBattleFlag.HPQaing = nil
UIBattleFlag.ReduceValue = nil
UIBattleFlag.FlagLevel = nil
UIBattleFlag.TotalAttack = nil
UIBattleFlag.TotalHp = nil
function UIBattleFlag:SetFlagProps()
   local _Props = BattleFlagSys.CalculateBattleProp()
   local _MinLvl , _TProps = BattleFlagSys.CalculateTheWholeBattleProp()
   if UIBattleFlag.AttackGong ==nil then
      UIBattleFlag.AttackGong = UIBattleFlag.UpFlagsPanel.transform:FindChild("FlagProp"):FindChild("BaseProp"):FindChild("Attack"):FindChild("Gong"):GetComponent("UILabel")
      UIBattleFlag.AttackDun = UIBattleFlag.UpFlagsPanel.transform:FindChild("FlagProp"):FindChild("BaseProp"):FindChild("Attack"):FindChild("Dun"):GetComponent("UILabel")
      UIBattleFlag.AttackQaing = UIBattleFlag.UpFlagsPanel.transform:FindChild("FlagProp"):FindChild("BaseProp"):FindChild("Attack"):FindChild("Qiang"):GetComponent("UILabel")
      UIBattleFlag.HPGong = UIBattleFlag.UpFlagsPanel.transform:FindChild("FlagProp"):FindChild("BaseProp"):FindChild("Blood"):FindChild("Gong"):GetComponent("UILabel")
      UIBattleFlag.HPDun = UIBattleFlag.UpFlagsPanel.transform:FindChild("FlagProp"):FindChild("BaseProp"):FindChild("Blood"):FindChild("Dun"):GetComponent("UILabel")
      UIBattleFlag.HPQaing = UIBattleFlag.UpFlagsPanel.transform:FindChild("FlagProp"):FindChild("BaseProp"):FindChild("Blood"):FindChild("Qiang"):GetComponent("UILabel")
      UIBattleFlag.ReduceValue = UIBattleFlag.UpFlagsPanel.transform:FindChild("SkyTitle"):FindChild("SkyDescrip"):GetComponent("UILabel")
      UIBattleFlag.FlagLevel = UIBattleFlag.UpFlagsPanel.transform:FindChild("FlagLevel"):FindChild("FlagLevel"):GetComponent("UILabel")
      UIBattleFlag.TotalAttack = UIBattleFlag.UpFlagsPanel.transform:FindChild("FlagLevel"):FindChild("SoldierAttack"):GetComponent("UILabel") 
      UIBattleFlag.TotalHp = UIBattleFlag.UpFlagsPanel.transform:FindChild("FlagLevel"):FindChild("SoldierBlood"):GetComponent("UILabel") 
   end
   UIBattleFlag.AttackGong.text = UIstring.Attack.."+"..tostring(_Props[1].Attack).."%"
   UIBattleFlag.AttackDun.text = UIstring.Attack.."+"..tostring(_Props[2].Attack).."%"
   UIBattleFlag.AttackQaing.text = UIstring.Attack.."+"..tostring(_Props[3].Attack).."%"
   UIBattleFlag.HPGong.text = UIstring.Blood.."+"..tostring(_Props[1].Hp).."%"
   UIBattleFlag.HPDun.text = UIstring.Blood.."+"..tostring(_Props[2].Hp).."%"
   UIBattleFlag.HPQaing.text = UIstring.Blood.."+"..tostring(_Props[3].Hp).."%"

   if UIBattleFlag.UpFlagsData[5]~=nil then
      UIBattleFlag.ReduceValue.text = UIstring.OnSoldier.."("..UIstring.BattleFlagType[UIBattleFlag.UpFlagsData[5].Type] ..")"..UIstring.ReduceHurt..tostring(_Props.Reduction).."%"
   else
      UIBattleFlag.ReduceValue.text = UIstring.OnSoldier..UIstring.ReduceHurt..tostring(_Props.Reduction).."%"
   end

   
   UIBattleFlag.FlagLevel.text =  tostring(_MinLvl)..UIstring.Lvl
   UIBattleFlag.TotalAttack.text = UIstring.Attack.."+"..tostring(_TProps).."%"
   UIBattleFlag.TotalHp.text = UIstring.Blood.."+"..tostring(_TProps).."%"
end

function UIBattleFlag:InitUpFlag()
   UIBattleFlag.UpFlagsData = {}
   --GameMain.Print(BattleFlagSys.UpBattleFlags)
   for key , value in pairs(BattleFlagSys.UpBattleFlags) do
       UIBattleFlag.UpFlagsData[key] = value.FlagData
       UIBattleFlag.UpFlagsGob[key].gameObject:SetActive(true)
       local _IMGSp = UIBattleFlag.UpFlagsGob[key].transform:FindChild("IMG"):GetComponent("UISprite")
       UIBattleFlag.UpFlagsGob[key].transform:FindChild("Word"):GetComponent("UILabel").text = value.FlagData.Lvl..UIstring.Lvl..value.FlagData.Name
       UIBattleFlag.UpFlagsGob[key].transform:FindChild("Count"):GetComponent("UILabel").text = ""
       AtlasMsg.SetAtlas(_IMGSp , value.FlagData.AtlasName , value.FlagData.SpriteName)     
   end
end

function UIBattleFlag:ReflashFlagCount(_Flag , _Index)
   UIBattleFlag.FlagItmes[_Index].FlagGob.transform:FindChild("Count"):GetComponent("UILabel").text = tostring(_Flag.Count)
end

function UIBattleFlag:ReflashFlag()
    --[[UIBattleFlag.FlagList = {}
    for i = 1 , #BattleFlagSys.BattleFlagList , 1 do
        UIBattleFlag.FlagList[i] =
        {
           FlagData = BattleFlagSys.BattleFlagList[i],
        }
    end
    UIBattleFlag.UIWrap:ReflashItems(#BattleFlagSys.BattleFlagList)--]]
    this:Comp()
end

function UIBattleFlag:DownFlag(_Index)                                        --脱战旗
   if UIBattleFlag.UpFlagsData[_Index]==nil then
      Debug.LogError("没有该战旗")
      return
   else
      UIBattleFlag.UpFlagEvent = true
      local _FlagData = UIBattleFlag.UpFlagsData[_Index]
      BattleFlagSys.DownBattleFlag(_FlagData , _Index)
      UIBattleFlag.UpFlagsGob[_Index].gameObject:SetActive(false)
      UIBattleFlag.UpFlagsData[_Index] = nil
      this:SetFlagProps()
      DataUIInstance.PopTip("W4")
   end
end

function UIBattleFlag:GetFlagIndex(_Flag , _FlagNumber)                                                   --判断上阵战旗的可行性 返回位置 0 失败
   if _Flag.Series==1 then                                                                  --天罚战旗
      if UIBattleFlag.UpFlagsData[5]~=nil then
         DataUIInstance.PopTip("S3")
         --Debug.LogError("已镶嵌天罚")
         return 0
      end
      UIBattleFlag.UpFlagsData[5] = _Flag
      BattleFlagSys.UpBattleFlag(_Flag , _FlagNumber , 5)
      return 5
   end

   local _UpCount = 0
   for key , value in pairs(UIBattleFlag.UpFlagsData) do
       _UpCount = _UpCount + 1
   end
   if _UpCount==5 then
      DataUIInstance.PopTip("S2")
     -- Debug.LogError("战旗已满")
      return 0
   end

   local _Pass = this:JudgeFlag(_Flag)
   if _Pass==true then
      for i = 1 , 4 , 1 do
          if UIBattleFlag.UpFlagsData[i] == nil then
             UIBattleFlag.UpFlagsData[i] = {}
             UIBattleFlag.UpFlagsData[i] = _Flag
             BattleFlagSys.UpBattleFlag(_Flag , _FlagNumber , i)
             return i
          end        
      end
   end
   return 0
end

function UIBattleFlag:JudgeFlag(_Flag)                                              --判断战旗是否有相同类型 false 失败
   local _Count = 0
   for key , value in pairs(UIBattleFlag.UpFlagsData) do
       if value.Series == _Flag.Series then
          _Count = _Count + 1
          if _Count==2 then
             DataUIInstance.PopTip("R9")
           --  Debug.LogError("相同战旗已有两个")
             return false
          end
          if _Count == 1 then
             if value.Type == _Flag.Type then
                DataUIInstance.PopTip("S1")
            --    Debug.LogError("相同战旗的相同类型无法穿戴")
                return false
             end
          end
       end
   end
   return true
end

function UIBattleFlag:SaveTheFlag()
   --if UIBattleFlag.FlagPanelType == 2 or UIBattleFlag.FlagPanelType == 3 then
      
          BattleFlagSys.SaveBattleFlag()
            
   --end
end

--*************************战旗合成
UIBattleFlag.CombineFlagPanel = nil
function UIBattleFlag:OpenCombinePanel()                                       --打开合成战旗界面
   if UIBattleFlag.CombineFlagPanel==nil then
      UIBattleFlag.CombineFlagPanel = UIBattleFlag.UIBattleFlagGob.transform:FindChild("left"):FindChild("BattleFlagCombine")
   end
   UIBattleFlag.CombineFlagPanel.transform.localPosition = Vector3(-300 , -150 , 0)
   this:SaveTheFlag()
   this:GetUpCombineGob()
end

UIBattleFlag.UpCombineFlagsGob = {}                                         --1  2  3  4 4是将要合成的战旗
UIBattleFlag.CombineFlags = {}
function UIBattleFlag:GetUpCombineGob()
   if #UIBattleFlag.UpCombineFlagsGob==0 then
      for i = 1 , 4 , 1 do
          local _FlagsGob = UIBattleFlag.CombineFlagPanel.transform:FindChild("FlagPanel"):FindChild("Flags"):FindChild(tostring(i)):FindChild("FlagItem")
          UIBattleFlag.UpCombineFlagsGob[i] = _FlagsGob
          _FlagsGob.gameObject:SetActive(false)
      end
   else
      for i = 1 , 4 , 1 do
          UIBattleFlag.UpCombineFlagsGob[i].gameObject:SetActive(false)
      end
   end
   UIBattleFlag.CombineFlags = {}
end

UIBattleFlag.TempCombineFlagId = nil
function UIBattleFlag:UpCombineFlag(_Flag)
   UIBattleFlag.CombineFlags = {}
   if _Flag.Lvl == 10  then
      Debug.LogError("已经满级")
      return 
   end
   
   for i = _Flag.Count , 4 , 1 do
       UIBattleFlag.UpCombineFlagsGob[i].gameObject:SetActive(false)
   end

   UIBattleFlag.TempCombineFlagId = _Flag.Dbid

   local _Count = 0
   if _Flag.Count > 3 then
      _Count = 3
   else
      _Count = _Flag.Count
   end

   for i = 1 , _Count , 1 do
       UIBattleFlag.CombineFlags[i] = _Flag
       UIBattleFlag.UpCombineFlagsGob[i].gameObject:SetActive(true)
       UIBattleFlag.UpCombineFlagsGob[i].transform:FindChild("Word"):GetComponent("UILabel").text = tostring(_Flag.Lvl)..UIstring.Lvl.._Flag.Name
       UIBattleFlag.UpCombineFlagsGob[i].transform:FindChild("Count"):GetComponent("UILabel").text = ""
       local _IMGSp = UIBattleFlag.UpCombineFlagsGob[i].transform:FindChild("IMG"):GetComponent("UISprite")
       AtlasMsg.SetAtlas(_IMGSp , _Flag.AtlasName , _Flag.SpriteName) 
   end 

   local _NextFlag = BattleFlagDataSys.GetBattleFlagById(tonumber(_Flag.Dbid) + 1)
   if _NextFlag~=nil then
      UIBattleFlag.UpCombineFlagsGob[4].gameObject:SetActive(true)
      local _IMGSp = UIBattleFlag.UpCombineFlagsGob[4].transform:FindChild("IMG"):GetComponent("UISprite")
      UIBattleFlag.UpCombineFlagsGob[4].transform:FindChild("Word"):GetComponent("UILabel").text = tostring(_NextFlag.Lvl)..UIstring.Lvl.._NextFlag.Name
      UIBattleFlag.UpCombineFlagsGob[4].transform:FindChild("Count"):GetComponent("UILabel").text = ""
      AtlasMsg.SetAtlas(_IMGSp , _NextFlag.AtlasName , _NextFlag.SpriteName)
   end
end


function UIBattleFlag:CombineFlag()                                             --合并战旗
   --[[if #UIBattleFlag.CombineFlags < 3 then
    --  Debug.LogError("数量不足 无法合成")
      DataUIInstance.PopTip("S4")
      return
   end--]]
   if UIBattleFlag.CombineFlags[1]==nil then
      DataUIInstance.PopTip("W7")
      return
   end
   if UIBattleFlag.CombineFlags[1].Count < 3 then
      DataUIInstance.PopTip("S4")
      return
   end
   BattleFlagSys.CombineFlag(UIBattleFlag.CombineFlags[1] , 0)
end

function UIBattleFlag:CombineFlagAll()                                             --合并战旗
   --[[if #UIBattleFlag.CombineFlags < 3 then
     -- Debug.LogError("数量不足 无法合成")
      DataUIInstance.PopTip("S4")
      return
   end
   --]]
   if UIBattleFlag.CombineFlags[1]==nil then
      DataUIInstance.PopTip("W7")
      return
   end
   if UIBattleFlag.CombineFlags[1].Count < 3 then
      DataUIInstance.PopTip("S4")
      return
   end
   BattleFlagSys.CombineFlag(UIBattleFlag.CombineFlags[1])
end

UIBattleFlag.HeChengFx = nil
function UIBattleFlag:ReflashCombine()
    --[[UIBattleFlag.FlagList = {}
    for i = 1 , #BattleFlagSys.BattleFlagList , 1 do
        UIBattleFlag.FlagList[i] =
        {
           FlagData = BattleFlagSys.BattleFlagList[i],
        }
    end

    UIBattleFlag.UIWrap:ReflashItems(#BattleFlagSys.BattleFlagList)--]]
    if UIBattleFlag.HeChengFx==nil then
       UIBattleFlag.HeChengFx = UIBattleFlag.CombineFlagPanel.transform:FindChild("FlagPanel"):FindChild("FX_fuwen_hecheng01")
    end--
    UIBattleFlag.HeChengFx.gameObject:SetActive(true)
    UIBattleFlag.HeChengFx.gameObject:GetComponent("ParticleSystem"):Stop()
    UIBattleFlag.HeChengFx.gameObject:GetComponent("ParticleSystem"):Play()
    for i = 1 , 4 , 1 do
        UIBattleFlag.UpCombineFlagsGob[i].gameObject:SetActive(false)
    end

    UIBattleFlag.CombineFlags = {}
    this:Comp()

    local _TempFlag , _Index =   BattleFlagSys.FindFlagByDBId(UIBattleFlag.TempCombineFlagId)
    if _TempFlag~=nil then
       this:UpCombineFlag(_TempFlag)
    end
end

--***************************战旗转换
UIBattleFlag.TransFlagPanel = nil
function UIBattleFlag:OpenTransFlag()                                               --转换战旗
   if UIBattleFlag.TransFlagPanel==nil then
      UIBattleFlag.TransFlagPanel = UIBattleFlag.UIBattleFlagGob.transform:FindChild("left"):FindChild("BattleFlagChange")
   end
   UIBattleFlag.TransFlagPanel.transform.localPosition = Vector3(-300 , -150 , 0)
   this:SaveTheFlag()
   this:GetUpTransGob()
   this:OpenDescripPanel()
   this:InitTrans()
   UIBattleFlag.LeftTempNum = 0
end

UIBattleFlag.UpTransLeft = nil
UIBattleFlag.UpTransRight = nil 
UIBattleFlag.TransFlag = nil
UIBattleFlag.DescripPanel = nil
UIBattleFlag.ChoseFlagPanel = nil
UIBattleFlag.FlagSeries = {}  
UIBattleFlag.FlagSeriesGobs = {}  
UIBattleFlag.ChoseGob = nil
UIBattleFlag.ChoseFlagInfo = nil  
UIBattleFlag.LastFlagData =nil                                
function UIBattleFlag:GetUpTransGob()
   if UIBattleFlag.UpTransLeft==nil then
      UIBattleFlag.UpTransLeft = UIBattleFlag.TransFlagPanel.transform:FindChild("FlagPanel"):FindChild("LeftFlag"):FindChild("FlagItem")
      UIBattleFlag.UpTransRight =  UIBattleFlag.TransFlagPanel.transform:FindChild("FlagPanel"):FindChild("RightFlag"):FindChild("FlagItem")
      UIBattleFlag.DescripPanel = UIBattleFlag.TransFlagPanel.transform:FindChild("DescripPanel")
      UIBattleFlag.ChoseFlagPanel = UIBattleFlag.TransFlagPanel.transform:FindChild("ChoseFlagPanel")
      local _Count = 0
      for i = 1 , 3  , 1 do
          for j = 1 , 3  , 1 do
          _Count = _Count + 1 
          if UIBattleFlag.FlagSeries[_Count]==nil then
             UIBattleFlag.FlagSeries[_Count] = {}
          end
          UIBattleFlag.FlagSeries[_Count] = 
          {      
             Series = i , 
             Type = j ,
          }
          end
      end
      for i = 1 , 9  , 1 do
          UIBattleFlag.FlagSeriesGobs[i] = UIBattleFlag.ChoseFlagPanel.transform:FindChild("ChoseFlags"):FindChild("ChoseFlagGrid"):FindChild(tostring(i))
      end
   end 
end

function UIBattleFlag:InitTrans()
   if UIBattleFlag.TransFlag~=nil then
      UIBattleFlag.TransFlag = nil
      UIBattleFlag.ChoseFlagInfo = nil  
      UIBattleFlag.LastFlagData =nil 
      UIBattleFlag.UpTransLeft.gameObject:SetActive(false)
      UIBattleFlag.UpTransRight.gameObject:SetActive(false)
      UIBattleFlag:SetLeftNum(1)
      UIBattleFlag:SetMoney(0)
   end
end

function UIBattleFlag:UpTransFlag(_Flag)                                                --选择要转换的flag
   if _Flag.Lvl==1 then
      DataUIInstance.PopTip("S5")
      --Debug.LogError("等级1级的无法转化 ")
      return 
   end
   UIBattleFlag.TransFlag = _Flag
   this:CreateLeftImg()
   this:OpenChoseFlagPanel()
   this:SetLeftNum(1)
end

function UIBattleFlag:CreateLeftImg()
   UIBattleFlag.UpTransLeft.gameObject:SetActive(true)
   local _IMGSp = UIBattleFlag.UpTransLeft.transform:FindChild("IMG"):GetComponent("UISprite")
   AtlasMsg.SetAtlas(_IMGSp , UIBattleFlag.TransFlag.AtlasName , UIBattleFlag.TransFlag.SpriteName)
   local _FSprite = UIBattleFlag.UpTransLeft.transform:FindChild("FG"):GetComponent("UISprite")     
   AtlasMsg.SetAtlas(_FSprite , UIstring.QualityAtlasName , UIstring.ItemFg[UIBattleFlag.TransFlag.Quality])
   local _BSprite = UIBattleFlag.UpTransLeft.transform:FindChild("BG"):GetComponent("UISprite")     
   AtlasMsg.SetAtlas(_BSprite , UIstring.QualityBGAtlasName , UIstring.ItemFg[UIBattleFlag.TransFlag.Quality])

   UIBattleFlag.UpTransLeft.transform:FindChild("Word"):GetComponent("UILabel").text = tostring(UIBattleFlag.TransFlag.Lvl)..UIstring.Lvl..UIBattleFlag.TransFlag.Name
   UIBattleFlag.UpTransLeft.transform:FindChild("Count"):GetComponent("UILabel").text = ""

   if UIBattleFlag.ChoseFlagInfo~=nil then
      local _ChoseFlagData = BattleFlagDataSys.GetBattleFlagByType_Series(UIBattleFlag.ChoseFlagInfo.Type , UIBattleFlag.ChoseFlagInfo.Series)
      this:CreateRightImg(_ChoseFlagData)
   end
end

function UIBattleFlag:CreateRightImg(_ChoseFlagData)                    
   UIBattleFlag.UpTransRight.gameObject:SetActive(true)
   local _IMGSp = UIBattleFlag.UpTransRight.transform:FindChild("IMG"):GetComponent("UISprite")
   local _FSprite = UIBattleFlag.UpTransRight.transform:FindChild("FG"):GetComponent("UISprite")     
   local _BSprite = UIBattleFlag.UpTransRight.transform:FindChild("BG"):GetComponent("UISprite") 
   UIBattleFlag.UpTransRight.transform:FindChild("Count"):GetComponent("UILabel").text = ""  
   if UIBattleFlag.TransFlag.Lvl==10 then
      local _LastFlag = BattleFlagDataSys.GetBattleFlagByType_Series_Lvl(_ChoseFlagData.Type , _ChoseFlagData.Series , UIBattleFlag.TransFlag.Lvl)
      UIBattleFlag.UpTransRight.transform:FindChild("Word"):GetComponent("UILabel").text = tostring(_LastFlag.Lvl)..UIstring.Lvl.._LastFlag.Name
      AtlasMsg.SetAtlas(_IMGSp , _LastFlag.AtlasName , _LastFlag.SpriteName)
      AtlasMsg.SetAtlas(_FSprite , UIstring.QualityAtlasName , UIstring.ItemFg[_LastFlag.Quality])
      AtlasMsg.SetAtlas(_BSprite , UIstring.QualityBGAtlasName , UIstring.ItemFg[_LastFlag.Quality])
      UIBattleFlag.LastFlagData = _LastFlag
   else
      local _LastFlag = BattleFlagDataSys.GetBattleFlagByType_Series_Lvl(_ChoseFlagData.Type , _ChoseFlagData.Series , UIBattleFlag.TransFlag.Lvl - 1)      
      UIBattleFlag.UpTransRight.transform:FindChild("Word"):GetComponent("UILabel").text = tostring(_LastFlag.Lvl)..UIstring.Lvl.._LastFlag.Name
      AtlasMsg.SetAtlas(_IMGSp , _LastFlag.AtlasName , _LastFlag.SpriteName)
      AtlasMsg.SetAtlas(_FSprite , UIstring.QualityAtlasName , UIstring.ItemFg[_LastFlag.Quality])
      AtlasMsg.SetAtlas(_BSprite , UIstring.QualityBGAtlasName , UIstring.ItemFg[_LastFlag.Quality])
      UIBattleFlag.LastFlagData = _LastFlag
   end 
end

UIBattleFlag.LeftTempNum = 0
function UIBattleFlag:Plus()   
   if UIBattleFlag.LastFlagData ==nil then
      DataUIInstance.PopTip("S8")
      return 
   end
   if UIBattleFlag.LeftTempNum + 1> UIBattleFlag.TransFlag.Count then
      DataUIInstance.PopTip("S6")
      --Debug.LogError("数量不足")
      return   
   else
      UIBattleFlag.LeftTempNum = UIBattleFlag.LeftTempNum + 1
   end
   this:SetLeftNum(UIBattleFlag.LeftTempNum)
end

function UIBattleFlag:Sub()  
   if UIBattleFlag.LastFlagData ==nil then
      DataUIInstance.PopTip("S8")
      return 
   end
   if UIBattleFlag.LeftTempNum<=1 then
      DataUIInstance.PopTip("S7")
      --Debug.LogError("数量不可小于1")
      return   
   else
      UIBattleFlag.LeftTempNum = UIBattleFlag.LeftTempNum - 1
   end
   this:SetLeftNum(UIBattleFlag.LeftTempNum)
end

function UIBattleFlag:SetLeftNum(_Num)
   
   UIBattleFlag.LeftTempNum = _Num
   UIBattleFlag.TransFlagPanel.transform:FindChild("FlagPanel"):FindChild("LeftNum"):GetComponent("UILabel").text = tostring(_Num)
   this:SetRightNum(UIBattleFlag.LeftTempNum * 2)
   this:SetMoney(UIBattleFlag.LeftTempNum)
end

function UIBattleFlag:SetRightNum(_Num)
   UIBattleFlag.TransFlagPanel.transform:FindChild("FlagPanel"):FindChild("RightNum"):GetComponent("UILabel").text = tostring(_Num)
end

function UIBattleFlag:SetMoney(_Num)
   UIBattleFlag.TransFlagPanel.transform:FindChild("FlagPanel"):FindChild("NeedMoney"):FindChild("Money"):GetComponent("UILabel").text = tostring(10000*_Num)
end

function UIBattleFlag:ChoseFlag(_Index)                                       --选择某个战旗Gob
   if UIBattleFlag.TransFlag==nil then
      DataUIInstance.PopTip("S8")
      --Debug.LogError("请先选择一个需要转换的战旗")
      return 
   end
   if UIBattleFlag.ChoseGob~=nil then
      UIBattleFlag.ChoseGob.transform:FindChild("click").gameObject:SetActive(false)
   end
   UIBattleFlag.ChoseGob = UIBattleFlag.FlagSeriesGobs[_Index]
   UIBattleFlag.ChoseGob.transform:FindChild("click").gameObject:SetActive(true)

   UIBattleFlag.ChoseFlagInfo = UIBattleFlag.FlagSeries[_Index]
   local _ChoseFlagData = BattleFlagDataSys.GetBattleFlagByType_Series(UIBattleFlag.ChoseFlagInfo.Type , UIBattleFlag.ChoseFlagInfo.Series)
   this:CreateRightImg(_ChoseFlagData)
end

function UIBattleFlag:TransFlagEvent()                                        --转化战旗
   if UIBattleFlag.TransFlag==nil or UIBattleFlag.LastFlagData == nil then
      DataUIInstance.PopTip("S8")
      --Debug.LogError("请选择一个战旗")
      return
   else

   end
   BattleFlagSys.TransFlag(UIBattleFlag.TransFlag , UIBattleFlag.LastFlagData.Id , UIBattleFlag.LeftTempNum)
end

UIBattleFlag.ZhuanHuanFx = nil  
function UIBattleFlag:ReflashTransFlag()                                       --战旗转化回调刷新
   --[[UIBattleFlag.FlagList = {}
    for i = 1 , #BattleFlagSys.BattleFlagList , 1 do
        UIBattleFlag.FlagList[i] =
        {
           FlagData = BattleFlagSys.BattleFlagList[i],
        }
    end

    UIBattleFlag.UIWrap:ReflashItems(#BattleFlagSys.BattleFlagList)--]]

    if UIBattleFlag.ZhuanHuanFx==nil then
       UIBattleFlag.ZhuanHuanFx = UIBattleFlag.TransFlagPanel.transform:FindChild("FX_fuwen_zhuanhuan01")
    end 
    UIBattleFlag.ZhuanHuanFx.gameObject:SetActive(true)
    UIBattleFlag.ZhuanHuanFx.gameObject:GetComponent("ParticleSystem"):Stop()
    UIBattleFlag.ZhuanHuanFx.gameObject:GetComponent("ParticleSystem"):Play()

    this:Comp()
    UIBattleFlag.UpTransLeft.gameObject:SetActive(false)
    UIBattleFlag.UpTransRight.gameObject:SetActive(false)
    UIBattleFlag.TransFlag = nil

    UIBattleFlag.LastFlagData = nil
    UIBattleFlag.ChoseGob.transform:FindChild("click").gameObject:SetActive(false)
    this:OpenDescripPanel()
end

function UIBattleFlag:OpenDescripPanel()                                        --打开描述界面
   UIBattleFlag.DescripPanel.gameObject:SetActive(true)
   UIBattleFlag.ChoseFlagPanel.gameObject:SetActive(false)
end

function UIBattleFlag:OpenChoseFlagPanel()                                      --打开选择战旗界面
   UIBattleFlag.DescripPanel.gameObject:SetActive(false)
   UIBattleFlag.ChoseFlagPanel.gameObject:SetActive(true)
end

function UIBattleFlag:CloseBattleFlag()
   if UIBattleFlag.UIBattleFlagGob~=nil then
      UIBattleFlag.UIBattleFlagGob.gameObject:SetActive(false)
      this:SaveTheFlag()
   end
end

function UIBattleFlag:ReleasPanel()
   UIBattleFlag.UIBattleFlagGob = nil
   UIBattleFlag.FlagPanelType = 1                    --1 穿战旗界面  2 战旗合成 3 战旗转换
   UIBattleFlag.TempPanel = nil

   UIBattleFlag.FlagBtn = nil
   UIBattleFlag.CombineBtn = nil
   UIBattleFlag.TransformBtn = nil
   UIBattleFlag.TempBtn = nil

   UIBattleFlag.FlagsGrid = nil
   UIBattleFlag.FlagItmes = {}
   UIBattleFlag.FlagList = {}
   UIBattleFlag.UIWrap = nil

   UIBattleFlag.UpFlagsPanel = nil
   UIBattleFlag.UpFlagsGob = {}
   UIBattleFlag.UpFlagsFx = {}
   UIBattleFlag.UpFlagsData = {}
   UIBattleFlag.AttackGong = nil
   UIBattleFlag.AttackDun = nil
   UIBattleFlag.AttackQaing = nil
   UIBattleFlag.HPGong = nil
   UIBattleFlag.HPDun = nil
   UIBattleFlag.HPQaing = nil
   UIBattleFlag.ReduceValue = nil
   UIBattleFlag.FlagLevel = nil
   UIBattleFlag.TotalAttack = nil
   UIBattleFlag.TotalHp = nil

   UIBattleFlag.CombineFlagPanel = nil
   UIBattleFlag.UpCombineFlagsGob = {} 
   UIBattleFlag.CombineFlags = {} 
   UIBattleFlag.HeChengFx = nil

    UIBattleFlag.TransFlagPanel = nil
    UIBattleFlag.UpTransLeft = nil
    UIBattleFlag.UpTransRight = nil 
    UIBattleFlag.TransFlag = nil
    UIBattleFlag.DescripPanel = nil
    UIBattleFlag.ChoseFlagPanel = nil
    UIBattleFlag.FlagSeries = {}  
    UIBattleFlag.FlagSeriesGobs = {}  
    UIBattleFlag.ChoseGob = nil
    UIBattleFlag.ChoseFlagInfo = nil  
    UIBattleFlag.LastFlagData =nil  

    UIBattleFlag.ZhuanHuanFx = nil  
end

function UIBattleFlag.InitPanel()
    UIBattleFlag.UIBattleFlagGob.gameObject:SetActive(false)
end

return UIBattleFlag