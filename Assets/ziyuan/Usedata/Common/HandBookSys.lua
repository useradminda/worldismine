HandBookSys = {}
HandBookSys.HandBookList = {}

function HandBookSys.Init()
   for i = 1 , #HandBookConfig.HandBookConfig , 1 do
       local _HandBookData = HandBookConfig.HandBookConfig[i]
       local _Type = _HandBookData.Type
       local _Quality = _HandBookData.Quality
       local _Id = _HandBookData.RoleId
       local _Order = _HandBookData.Order
       local _Data = RoleDataConfig.GetRoleById(_Id)
       if HandBookSys.HandBookList[_Type]==nil then
          HandBookSys.HandBookList[_Type] = {}
       end
       if HandBookSys.HandBookList[_Type][_Quality]==nil then
          HandBookSys.HandBookList[_Type][_Quality] = {}
       end
       HandBookSys.HandBookList[_Type][_Quality][_Order] = _Data
   end
end

function HandBookSys.Comp(_Type , _Quality)
   local _Data = {}
   if HandBookSys.HandBookList[_Type]~=nil and HandBookSys.HandBookList[_Type][_Quality]~=nil then
       _Data = HandBookSys.HandBookList[_Type][_Quality]
       return _Data
   end
   return _Data
end

return HandBookSys