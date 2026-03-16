UIMail = {}
local UIMail = BasePanel:new()
local this = UIMail
UIMail.UIMailGod = nil


function UIMail:OpenUI(_PanelName , _LuaName)
   if UIMail.UIMailGod==nil then
      UIMail.UIMailGod=MainGameUI.FindPanel("UIMail") 
   end   
   this:CreateMailGob()
end

UIMail.MailListGob = {}
UIMail.MailGrid = nil
function UIMail:CreateMailGob()
   -- GameMain.Print(MailSys.MailList)
   if UIMail.MailGrid==nil then
      UIMail.MailGrid = UIMail.UIMailGod.transform:FindChild("MailPanel/MailGrid")
   end
   if #UIMail.MailListGob==0 then     
       for i = 1 , 20 , 1 do
           local data = 
           {
               Index = i,
           }
           MainGameUI.CreateLittleItem(tostring(i) , "MailItem" , UIMail.MailGrid , data , this.CreateMailGobCallBack  , "UIMail")
       end
   else
       for i = 1 , 20 , 1 do
           UIMail.MailListGob[i].Gob.gameObject:SetActive(false)
           if MailSys.MailList[i]~=nil then   
              this:SetMailItem(MailSys.MailList[i] , UIMail.MailListGob[i].Gob)
           end         
       end
       UIMail.MailGrid:GetComponent("UIGrid").enabled = true
       UIMail.MailGrid:GetComponent("UIGrid"):Reposition()
   end
end

function UIMail:CreateMailGobCallBack(_Gob , _Info)
  
   _Gob.gameObject:SetActive(false)

   if MailSys.MailList[_Info.Index]~=nil then     
      this:SetMailItem(MailSys.MailList[_Info.Index] , _Gob)
   end

   UIMail.MailListGob[_Info.Index] =
   {
        Gob = _Gob,
   }

   if _Info.Index==20 then
      UIMail.MailGrid:GetComponent("UIGrid").enabled = true
      UIMail.MailGrid:GetComponent("UIGrid"):Reposition()      
   end

end

function UIMail:SetMailItem(_Mail , _Gob)
   _Gob.gameObject:SetActive(true)
   _Gob.transform:FindChild("Title"):GetComponent("UILabel").text = _Mail.Title
   _Gob.transform:FindChild("itemIcon/Count"):GetComponent("UILabel").text = tostring(_Mail.MailReward.Count)
   local _BQ = _Gob.transform:FindChild("itemIcon/BFG"):GetComponent("UISprite")
   AtlasMsg.SetAtlas(_BQ , UIstring.QualityBGAtlasName , UIstring.ItemFg[_Mail.MailReward.Quality])
   local _FQ = _Gob.transform:FindChild("itemIcon/QFG"):GetComponent("UISprite")
   AtlasMsg.SetAtlas(_FQ , UIstring.QualityAtlasName , UIstring.ItemFg[_Mail.MailReward.Quality])
   local _Img = _Gob.transform:FindChild("itemIcon/Img"):GetComponent("UISprite")
   AtlasMsg.SetAtlas(_Img , _Mail.MailReward.AtlasName , _Mail.MailReward.SpriteName)
end

function UIMail:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
  -- Debug.LogError(_Gob)
   if _Gob.transform.name=="closeBtn" then
      this:CloseMailPanel()
   end

   if _Gob.transform.name == "ReceiveButton" then
      local _Index = tonumber(_Gob.transform.parent.name) 
      if _Index~=nil then
        this:GetMailReward(_Index)
      end
   end

end

function UIMail:GetMailReward(_Index)
   local _Mail = MailSys.MailList[_Index]
   local _Id = _Mail.ID
   MailSys.GetMailRewad(_Id)
end


function UIMail:CloseMailPanel()
   if UIMail.UIMailGod~=nil then
      UIMail.UIMailGod.gameObject:SetActive(false)
   end
end

function UIMail:ReleasPanel()               									 --退出界面时释放和界面初始化
    UIMail.UIMailGod = nil 
    UIMail.MailListGob = {}
    UIMail.MailGrid = nil
end

return UIMail