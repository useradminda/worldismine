ItemBase = {}                                                                      --道具基类
ItemBase.__index = ItemBase

function ItemBase:new(o)
    o=o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

ItemBase.nickname = ""                                                                 --道具姓名
ItemBase.Dbid = 0																	--道具唯一ID
ItemBase.Description=""																--道具描述
                                                                
ItemBase.AtlasName = ""                                                             --Atlas名字
ItemBase.SpriteName = ""															--Sprit名字

ItemBase.Quality=0																	--品质
ItemBase.ItemType = 0                                                               --物品类型  1道具 2碎片 3资源 4装备
ItemBase.Type=0		
ItemBase.Layer_count=0																--叠加上限			
ItemBase.CanSell = 0                                                                --是否可以出售
ItemBase.Price = 0                                                                  --基础出售价格
ItemBase.Useable = 0                                                                --是否可见
ItemBase.IsUse=0                                                                    --是否可以使用
--ItemBase.DBdata ={}                                                                 --DB数据


function ItemBase:SetDBdata(_DBdata)
    if _DBdata~=nil then
--        self.DBdata = _DBdata   
		self.Dbid = tonumber(_DBdata.Id)
        self.nickname = tostring(_DBdata.Name)
        self.Description=tostring(_DBdata.Description)

        self.Quality = tonumber(_DBdata.Quality)
        self.Type=tonumber(_DBdata.Type)
		self.Layer_count=tonumber(_DBdata.Layer_count)

        self.CanSell = tonumber(_DBdata.Is_Sell)
        self.Price = tonumber(_DBdata.Price)
        self.Useable = tonumber(_DBdata.Is_Visible)
		
		self.IsUse=tonumber(_DBdata.IsUse)
	
        self:GetAtlasName(_DBdata.Icon)
    end
end

function ItemBase:GetAtlasName(_IconString)
    local Icon =  GameMain.StringSplit(_IconString , ",")
    self.AtlasName = Icon[1]
    self.SpriteName = Icon[2]
end

return ItemBase