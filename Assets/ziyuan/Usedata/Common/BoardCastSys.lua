BoardCastSys = {}
BoardCastSys.CastList = {}

function BoardCastSys.PushCast(_Cast)
   table.insert(BoardCastSys.CastList , #BoardCastSys.CastList + 1 , _Cast)
end

function BoardCastSys.FindCastById(_ID)
   for i = 1 , #BoardCastSys.CastList , 1 do
       if BoardCastSys.CastList[i].ID == _ID then
          return
       end
   end
end

function BoardCastSys.PopCast()            --出来一条
   if #BoardCastSys.CastList > 0 then
      local _Cast = BoardCastSys.CastList[1]
      table.remove(BoardCastSys.CastList , 1)
      if _Cast~=nil then
         return _Cast
      else
         return nil
      end
   end
   return nil
end

function BoardCastSys.Comminfo(data)
    for key , value in pairs(data) do
       local _ID = tonumber(key)	  
       if _ID~=nil then
		    local _Id= tonumber(value["_id"])
			local _Text = tostring(value["txt"])			
            local data =
            {
               ID = _Id,
               Text = _Text,             
            }
            BoardCastSys.PushCast(data)
        end
    end

    if #BoardCastSys.CastList > 0 then
       local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
       if _UIControlTar~=nil then
          if _UIControlTar.UIControlGob~=nil then         
             _UIControlTar:InitBoradCast()
          end
       end
    end

end

function BoardCastSys.ReleaseData()
   BoardCastSys.CastList = {}
end

return BoardCastSys