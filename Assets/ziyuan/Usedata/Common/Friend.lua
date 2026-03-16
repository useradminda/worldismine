--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
Friend = {}
Friend.__index = Friend

Friend.Dbid = ""			--玩家的唯一ID
Friend.lvl = 0			--玩家等级
Friend.VipLvl = 0		--玩家的VIP等级
Friend.name = ""		--玩家的名字
Friend.CreateTime = 0	--玩家创建的时间戳
Friend.CommanderId = 0	--玩家的挂帅武将
Friend.Camp = 0			--玩家的所属国家
Friend.AtlasName = ""
Friend.SpriteName = ""

function Friend:new(o)
    o=o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function Friend:Init(_Data)

	if _Data~=nil then
		self.Dbid = tostring(_Data["_id"])
		self.Camp = tonumber(_Data["camp"])
		self.name = tonumber(_Data["name"])
		self.VipLvl = tonumber(_Data["vip"])
		self.lvl = tonumber(_Data["lv"])
		self.CommanderId = tonumber(_Data["commanderId"])
		self.CreateTime = tonumber(_Data["create_time"])
		self.AtlasName = ""
		self.SpriteName = ""
		if self.CommanderId ~= 0 then
			local role = RoleDataConfig.GetRoleById(self.CommanderId)
			if role ~= nil then
				self.AtlasName = role.AtlasName
				self.SpriteName = role.SpriteName
			end
		end
	end
end

--添加好友
function Friend:AddFriend()
	FriendSys.RequestFriend(self.Dbid)
end
--加入黑名单
function Friend:DeleFriend()
	FriendSys.AddBlackFriend(self.Dbid)
end

return Friend
--endregion
