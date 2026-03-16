--region *.lua
--Date   后续完善
--此文件由[BabeLua]插件自动生成
SkillInfo = {}
SkillInfo._index = SkillInfo

SkillInfo.SkillData = nil
SkillInfo.Id = 0
SkillInfo.nickname = ""
SkillInfo.AtlasName = ""
SkillInfo.SpriteName = ""

SkillInfo.ColdTime = 0
function SkillInfo:new(o)
	o = o or {}
	setmetatable(o,self)
	self._index = self
	return o
end

function SkillInfo:Init( _SkillDB)
	SkillInfo.SkillData = _SkillDB
	SkillInfo.nickname = _SkillDB.Name
	SkillInfo.AtlasName = _SkillDB.AtlasName
	SkillInfo.SpriteName = _SkillDB.SpriteName
end

return SkillInfo
--endregion
