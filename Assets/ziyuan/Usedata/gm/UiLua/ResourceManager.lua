ResourceManager = {}
--ResourceManager.isInited = false
--ResourceManager.cacheList = {}

--function ResourceManager.InitFinish()
--	ResourceManager.isInited = true
--	for i = 1,#ResourceManager.cacheList do
--		local item = ResourceManager.cacheList[i]
--		if item.method == "LoadAssetByObject" then
--			ResourceManager.LoadAssetByObject(item.params.info, item.params.prefabName, item.params.cb)
--		elseif item.method == "LoadAsset" then
--			ResourceManager.LoadAsset(item.params.prefabName, item.params.cb)
--		elseif item.method == "LoadAssetUI" then
--			ResourceManager.LoadAssetUI(item.params.prefabName, item.params.cb)
--		elseif item.method == "LoadAssetByObjectUI" then
--			ResourceManager.LoadAssetByObjectUI(item.params.info, item.params.prefabName, item.params.cb)
--		elseif item.method == "LoadAssetBundle" then
--			ResourceManager.LoadAssetBundle(item.params.info, item.params.prefabName, item.params.cb, item.params.isui)
--		end
--	end

--end

----check if init not finish
--function ResourceManager.CacheRequest(method, params)
--	local index = #ResourceManager.cacheList + 1
--	ResourceManager.cacheList[index] = {}
--	ResourceManager.cacheList[index].method = method
--	ResourceManager.cacheList[index].params = params
--end

function ResourceManager.LoadAssetByObject(info, prefabName, cb) 
	--Debug.LogError("ResourceManager.LoadAssetByObject prefabName="..prefabName)
	if prefabName==nil or prefabName=="" or prefabName=="!BattleScene07_1_hen_BOSS1" or prefabName =="tuoyuan2 (1)"  then
		local test =nil
		Debug.LogError(test.name)
	end 
	

--	if ResourceManager.isInited then
--	else
--		local params = {}
--		params.info = info
--		params.prefabName = prefabName 
--		params.cb = cb
--		ResourceManager.CacheRequest("LoadAssetByObject", params)
--		return
--	end
	
    --lgNoDelCsFun.Ins.curBunldType = "gm"  
	--lgNoDelCsFun.Ins:LoadAssetByObject (info, prefabName, cb)
	lgNoDelCsFun.Ins:LoadAssetByObject1(info, prefabName, cb, false)
end

function ResourceManager.LoadAsset(prefabName, cb)
	if prefabName==nil or prefabName==""  then
		local test =nil
		Debug.LogError(test.name)
	end 

--	if ResourceManager.isInited then
--	else
--		local params = {}
--		params.prefabName = prefabName
--		params.cb = cb
--		ResourceManager.CacheRequest("LoadAsset", params)
--		return
--	end

    --lgNoDelCsFun.Ins.curBunldType = "gm"  
	--lgNoDelCsFun.Ins:LoadAsset (prefabName, cb)
	lgNoDelCsFun.Ins:LoadAsset1( prefabName, cb, false)
end

--[[function ResourceManager.LoadLevel(levelName, isAdditive)
	if prefabName==nil or prefabName==""  then
		local test =nil
		Debug.LogError(test.name)
	end 
    lgNoDelCsFun.Ins.curBunldType = "gm"  
	lgNoDelCsFun.Ins:LoadLevel (levelName, isAdditive)
end--]]


function ResourceManager.LoadAssetUI(prefabName, cb)
	if prefabName==nil or prefabName==""  then
		local test =nil
		Debug.LogError(test.name)
	end 


--	if ResourceManager.isInited then
--	else
--		local params = {}
--		params.prefabName = prefabName
--		params.cb = cb
--		ResourceManager.CacheRequest("LoadAssetUI", params)
--		return
--	end

    --lgNoDelCsFun.Ins.curBunldType = "ui"
	--lgNoDelCsFun.Ins:LoadAsset (prefabName, cb)
	lgNoDelCsFun.Ins:LoadAsset1( prefabName, cb, true)
end

function ResourceManager.LoadAssetByObjectUI(info, prefabName, cb)  
	if prefabName==nil or prefabName==""  then
		local test =nil
		Debug.LogError(test.name)
	end 

--	if ResourceManager.isInited then
--	else
--		local params = {}
--		params.info = info
--		params.prefabName = prefabName
--		params.cb = cb
--		ResourceManager.CacheRequest("LoadAssetByObjectUI", params)
--		return
--	end

    --lgNoDelCsFun.Ins.curBunldType = "ui"  
	--lgNoDelCsFun.Ins:LoadAssetByObject (info, prefabName, cb)
	lgNoDelCsFun.Ins:LoadAssetByObject1(info, prefabName, cb, true)
end



--建议都用下面的接口 加载资源

-- isui true 是UI资源  
function ResourceManager.LoadAssetBundle(info, prefabName, cb, isui)  
	if prefabName==nil or prefabName=="" or prefabName=="0"  then
		Debug.LogError("ResourceManager.LoadAssetBundle prefabName="..tostring(prefabName))
		local test =nil
		Debug.LogError(test.name)
	end 

--	if ResourceManager.isInited then
--	else
--		local params = {}
--		params.info = info
--		params.prefabName = prefabName
--		params.cb = cb
--		params.isui = isui
--		ResourceManager.CacheRequest("LoadAssetBundle", params)
--		return
--	end

	if info==nil then
		lgNoDelCsFun.Ins:LoadAsset1( prefabName, cb, isui)
	else
		lgNoDelCsFun.Ins:LoadAssetByObject1(info, prefabName, cb, isui)
	end
	
end

return ResourceManager