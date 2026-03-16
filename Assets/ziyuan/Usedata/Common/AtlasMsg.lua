AtlasMsg = {}

AtlasMsg.AtlasGob =
{
    
}

AtlasMsg.GrayAtlasGob =
{
    
}

AtlasMsg.MaskAtlasGob = 
{

}



local this = AtlasMsg

function AtlasMsg.SetAtlas(_Sprite , _AtlasName , _SpriteName)
    if AtlasMsg.AtlasGob[_AtlasName] ~=nil then
       _Sprite.atlas = AtlasMsg.AtlasGob[_AtlasName]
       _Sprite.spriteName = _SpriteName
       return
    end

    local  data =
    {
        Sprite = _Sprite,
        AtlasName = _AtlasName,
        SpriteName = _SpriteName,
    }
    ResourceManager.LoadAssetByObjectUI(data , _AtlasName , AtlasMsg.GetAtlasCallBack)

end

function AtlasMsg.GetAtlasCallBack(info , prefab)
    local AtlasName = info.AtlasName
    if prefab~=nil then
        local _Atlas = prefab.transform:GetComponent("UIAtlas")
        AtlasMsg.AtlasGob[AtlasName] = _Atlas
        info.Sprite.atlas = _Atlas
        info.Sprite.spriteName = info.SpriteName
    else
       Debug.LogError(info.AtlasName.."没有该Atlas")
       Debug.LogError(info.SpriteName.."没有该SpriteName")
    end
end

function AtlasMsg.GetGrayAtlas(oldAtlas , _type)            --1 normal 2 softclip
    if oldAtlas==nil then
       return
    end
    local GrayName = oldAtlas.name

    local AtlasNameGray = GameMain.StringSplit(GrayName , "_")

    if AtlasNameGray[1]=="normal" or AtlasNameGray[1]=="softclip" then
       if AtlasMsg.GrayAtlasGob[GrayName]~=nil  then
          return AtlasMsg.GrayAtlasGob[GrayName]
       end
    end

    if _type==1 then
       GrayName = "normal".."_"..oldAtlas.name.."Gray"
    elseif _type==nil or _type==2 then
       GrayName = "softclip".."_"..oldAtlas.name.."Gray"
    end
    if AtlasMsg.GrayAtlasGob[GrayName]~=nil  then
        return AtlasMsg.GrayAtlasGob[GrayName]
    end
    local GrayATlas = nil 
    if _type==1 then
       GrayATlas = lgNoDelCsFun.Ins:transGrayAtlasNormal(oldAtlas)
    elseif _type==nil or _type==2 then
       GrayATlas = lgNoDelCsFun.Ins:transGrayAtlasSoftClip(oldAtlas)
    end
    AtlasMsg.GrayAtlasGob[GrayName] = GrayATlas
    return GrayATlas
end

function AtlasMsg.SetGrayAtlas(_Sprite , _SpriteName , _type)
    local GrayAtlas = AtlasMsg.GetGrayAtlas(_Sprite.atlas , _type)
   -- Debug.LogError(_Sprite.atlas)
    _Sprite.atlas = GrayAtlas
    _Sprite.spriteName = _SpriteName
end

function AtlasMsg.GetMaskAtlas(oldAtlas)
    if oldAtlas==nil then
       return
    end
    local MaskAtlasName = oldAtlas.name

    local AtlasNameGray = GameMain.StringSplit(MaskAtlasName , "+")

    if AtlasMsg.MaskAtlasGob["Mask".."+"..oldAtlas.name]~=nil then
       return AtlasMsg.MaskAtlasGob["Mask".."+"..oldAtlas.name]
    end

    if AtlasNameGray[1]=="Mask" then
       
       if AtlasMsg.MaskAtlasGob[MaskAtlasName]~=nil then
           return AtlasMsg.MaskAtlasGob[MaskAtlasName]
        end

    elseif AtlasNameGray[1]=="GrayMask" then
       
       if AtlasMsg.MaskAtlasGob["Mask".."+"..AtlasNameGray[2]]~=nil then
          return AtlasMsg.MaskAtlasGob["Mask".."+"..AtlasNameGray[2]]
       else
          local MaskAtlas = nil
          MaskAtlas = lgNoDelCsFun.Ins:SetAtlasMask(oldAtlas)
          AtlasMsg.MaskAtlasGob["Mask".."+"..AtlasNameGray[2]] = MaskAtlas
          return MaskAtlas
       end
    else     
       local MaskAtlas = nil
       MaskAtlas = lgNoDelCsFun.Ins:SetAtlasMask(oldAtlas)
       AtlasMsg.MaskAtlasGob["Mask".."+"..oldAtlas.name] = MaskAtlas
       return MaskAtlas
    end

   
    
end

function AtlasMsg.SetMaskAtlas(_Sprite , _SpriteName)
    local MaskAtlas = AtlasMsg.GetMaskAtlas(_Sprite.atlas)
    _Sprite.atlas = MaskAtlas
    _Sprite.spriteName = _SpriteName
end


function AtlasMsg.GetGrayMaskAtlas(oldAtlas)
    if oldAtlas==nil then
       return
    end
    local MaskAtlasName = oldAtlas.name

    local AtlasNameGray = GameMain.StringSplit(MaskAtlasName , "+")

    if AtlasMsg.MaskAtlasGob["GrayMask".."+"..oldAtlas.name]~=nil then
       return AtlasMsg.MaskAtlasGob["GrayMask".."+"..oldAtlas.name]
    end

    if AtlasNameGray[1]=="GrayMask" then
       
       if AtlasMsg.MaskAtlasGob[MaskAtlasName]~=nil then
          return AtlasMsg.MaskAtlasGob[MaskAtlasName]
       end

    elseif AtlasNameGray[1]=="Mask" then
       
       if AtlasMsg.MaskAtlasGob["GrayMask".."+"..AtlasNameGray[2]]~=nil then
          return AtlasMsg.MaskAtlasGob["GrayMask".."+"..AtlasNameGray[2]]
       else
          local MaskAtlas = nil
          MaskAtlas = lgNoDelCsFun.Ins:SetAtlasGrayMask(oldAtlas)
          AtlasMsg.MaskAtlasGob["GrayMask".."+"..AtlasNameGray[2]] = MaskAtlas
          return MaskAtlas
       end

    else     
       local MaskAtlas = nil
       MaskAtlas = lgNoDelCsFun.Ins:SetAtlasGrayMask(oldAtlas)
       AtlasMsg.MaskAtlasGob["GrayMask".."+"..oldAtlas.name] = MaskAtlas
       return MaskAtlas
    end
end

function AtlasMsg.SetGrayMaskAtlas(_Sprite , _SpriteName)
    local GrayMaskAtlas = AtlasMsg.GetGrayMaskAtlas(_Sprite.atlas)
    _Sprite.atlas = GrayMaskAtlas
    _Sprite.spriteName = _SpriteName
end

function AtlasMsg.Rlease()
    
    for key , value in pairs(AtlasMsg.AtlasGob) do
      --  GameObject.Destroy(AtlasMsg.AtlasGob[key])
        AtlasMsg.AtlasGob[key] = nil     
	end
    for key , value in pairs(AtlasMsg.GrayAtlasGob) do
        AtlasMsg.GrayAtlasGob[key].spriteMaterial = nil

        GameObject.Destroy(AtlasMsg.GrayAtlasGob[key])
        AtlasMsg.GrayAtlasGob[key] = nil     
	end
    for key , value in pairs(AtlasMsg.MaskAtlasGob) do
        AtlasMsg.MaskAtlasGob[key].spriteMaterial = nil
        GameObject.Destroy(AtlasMsg.MaskAtlasGob[key])
        AtlasMsg.MaskAtlasGob[key] = nil     
	end

   AtlasMsg.AtlasGob ={}
   AtlasMsg.GrayAtlasGob ={}
   AtlasMsg.MaskAtlasGob = {}
end

return AtlasMsg