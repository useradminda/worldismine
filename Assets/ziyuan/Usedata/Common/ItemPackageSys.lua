--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
ItemPackageSys = {}                                                              

local this = ItemPackageSys

ItemPackageSys.ItemList =                                                        --背包物品列表
{

}

ItemPackageSys.IsSort = true													 --是否排序

function ItemPackageSys.ComminfoResource(data)
	for key , dataItem in pairs(data) do
        local ID = tonumber(key)
        if ID ~= nil then
			local id = ID
			local num = tonumber(dataItem)
			if num <= 0 then
				ItemPackageSys.DelItem(id)
			else
				ItemPackageSys.AddItem(id,num)
			end
        end
    end
end



function ItemPackageSys.AddItem(_Id, _Count)
	ItemPackageSys.IsSort = true
	local index = ItemPackageSys.GetIndex(_Id)
	if index ~=nil and ItemPackageSys.ItemList[index] ~=nil then
		ItemPackageSys.ItemList[index].Count = _Count
	else
		local lua = GameMain.requireLuaFile("ItemInfo")
		local itemInfo = lua:new()
		local itemData=ItemDataConfig.GetItemDBConfig(_Id)
		itemInfo:InitSome(itemData, tonumber(_Count))
		table.insert(ItemPackageSys.ItemList,#ItemPackageSys.ItemList+1,itemInfo)
	end
end

function ItemPackageSys.DelItem(_Id)
	ItemPackageSys.IsSort = true
	local index = ItemPackageSys.GetIndex(_Id)
	if index~=nil then
		table.remove(ItemPackageSys.ItemList , index)
	end
end

function ItemPackageSys.RefrashItem(_Id , _Count)
	local index = ItemPackageSys.GetIndex(_Id)
	if index ~=nil and ItemPackageSys.ItemList[index] ~=nil then
		if _Count ==0 then
			ItemPackageSys.IsSort = true
			table.remove(ItemPackageSys.ItemList , index)
		else
			ItemPackageSys.IsSort = false
			ItemPackageSys.ItemList[index].Count = _Count
		end
	end
end


function ItemPackageSys.GetIndex(_Id)
	local list = ItemPackageSys.ItemList
	for key,value in pairs(list) do
		if value.Dbid == _Id then
			return key
		end
	end
	return nil
end

function ItemPackageSys.GetItemById(_Id)
	local list = ItemPackageSys.ItemList
	for key,value in pairs(list) do
		if value.Dbid == _Id then
			return value
		end
	end
end

function ItemPackageSys.GetItemCountById(_Id)
    local list = ItemPackageSys.GetItemList()
	for key,value in pairs(list) do
		if value.Dbid == _Id then
			return value.Count
		end
	end
    return 0
end

function ItemPackageSys.GetItemCountById(_Id)				--通过ID获得物品的数量
	local item = ItemPackageSys.GetItemById(_Id)
	if item ==nil then
		return 0
	else
		return item.Count
	end
end

function ItemPackageSys.Comp(A , B)
    if A == nil then
		return false
    end
	if B == nil then
		return false
	end
    if A.Quality>B.Quality then
       return true
	end
	if A.Quality==B.Quality then
		if A.Dbid > B.Dbid then
          return true         
		end   
       if A.Dbid < B.Dbid then
			return false   
       end  
                    
       if A.Dbid==B.Dbid then 
          return false   
		end       
	end  
                         
	if A.Quality<B.Quality then
		return false
	end
    
end



function ItemPackageSys.GetItemList()
	if ItemPackageSys.IsSort == true then
		table.sort(ItemPackageSys.ItemList , ItemPackageSys.Comp)
		ItemPackageSys.IsSort=false
	end
	
	return ItemPackageSys.ItemList
end
function ItemPackageSys.SellItem(_Id , count)--出售道具
	local data= tostring(_Id) .. "," .. tostring(count)
	WebEvent.SellFactoryItem(data,"ItemPackageSys.SellItemCallBack",ItemPackageSys.SellItemCallBack)
end

function ItemPackageSys.SellItemCallBack(data , returnId)
	
end

function ItemPackageSys.UseItem(_Id , count)   --使用道具
	local data = tostring(_Id) .. "," .. tostring(count)
	WebEvent.UseFactoryItem(data , "ItemPackageSys.UseItemCallBack" , ItemPackageSys.UseItemCallBack)
end

function ItemPackageSys.SellGiftItemCallBack(data , returnId)

end

function ItemPackageSys.UseItemCallBack(data , returnId)
	
end

function ItemPackageSys.ClearAllData()
	ItemPackageSys.ItemList =                                                        --背包物品列表
	{

	}

	ItemPackageSys.IsSort = true	
end
--endregion
return ItemPackageSys