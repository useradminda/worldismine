MailSys = {}
MailSys.MailList = {}

MailSys.Id = 0
function MailSys.GetMailRewad(_Id)
   MailSys.Id = _Id
   local _info = tostring(_Id)
   WebEvent.GetMail(_info , "MailSys.GetMailRewadCallBack" , MailSys.GetMailRewadCallBack)
end

function MailSys.GetMailRewadCallBack(_data , _returnId)
   --GameMain.Print(_data)
   if _returnId == 0 then
      local _UIMailTar = MainGameUI.FindPanelTarget("UIMail")
      if _UIMailTar~=nil then
         local _Mail , _Index = MailSys.FindMailById(MailSys.Id)
         if _Mail~=nil then
            table.remove(MailSys.MailList , _Index)
         end
         if #MailSys.MailList==0 then
            local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
            if _UIControlTar~=nil then
               _UIControlTar.UIControlGob.transform:FindChild("Camera/OutSideUIList/AnchorTopRight/Mail").gameObject:SetActive(false)
            end
         end
         _UIMailTar:CreateMailGob()
      end
   end
end

function MailSys.FindMailById(_ID)
   for i = 1 , #MailSys.MailList , 1 do
       if MailSys.MailList[i].ID == _ID then
          return MailSys.MailList[i] , i
       end
   end
   return nil , nil
end

function MailSys.MailComminfo(data)
   --GameMain.Print(data)
   MailSys.MailList = {}
   for key , value in pairs(data) do
       local _ID = tonumber(key)	  
       if _ID~=nil then
		    local _Time = tonumber(value["create_time"])
			local _Title = tostring(value["title"])
			local _rwd = tostring(value["rwd"])	   
            local _Reward = RewardContentSys.GetRewardResourceString(_rwd)      			
            local _MailReward = _Reward.Items[1]
            local data =
            {
               ID = _ID,
               MailReward = _MailReward,
               Title = _Title,
               Time = _Time,
            }
            table.insert(MailSys.MailList , #MailSys.MailList + 1 , data)
        end
    end
    if #MailSys.MailList > 0 then
       local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
       if _UIControlTar~=nil then
          _UIControlTar.UIControlGob.transform:FindChild("Camera/OutSideUIList/AnchorTopRight/Mail").gameObject:SetActive(true)
       end
    end
    table.sort(MailSys.MailList , MailSys.Comp)
end

function MailSys.Comp(A , B)
   return A.Time > B.Time
end

return MailSys