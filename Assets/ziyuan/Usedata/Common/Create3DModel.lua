Create3DModel = {}                                              --创建3D模型的浏览系统

Create3DModel.Models =                                          --模型缓存
{

}

function Create3DModel.CreateThModel(_ModelName, _ModelActionName , _Layer , _Father , _CallBack , _Copy , _Data)                                          --创建某个模型 （_Copy是否需要拷贝 有可能两个相同的模型出现）
		if _ModelActionName == nil then
			_ModelActionName = "run"
		end
	    
	if Create3DModel.Models[_ModelName]==nil then          
           local data = 
           {
               modelName = _ModelName,
               CallBack = _CallBack,
               ModelActionName = _ModelActionName,
               Layer = _Layer,
               Father = _Father,
               IsCopy = _Copy,
               Data = _Data,
           }
			LoadingPanel.OpenModelLoading()
           ResourceManager.LoadAssetByObject(data , _ModelName , Create3DModel.CreateThModelCallBack)
        else
           local Model = Create3DModel.Models[_ModelName]
           local NeedModel = nil 
           if _Copy==true then                                                      --需要拷贝
               local anotherModle = GameObject.Instantiate(Model)      
               NeedModel = anotherModle
           else
               NeedModel = Model
           end
           NeedModel.transform.parent = _Father.transform 
           NeedModel.gameObject:SetActive(true)

           lgNoDelCsFun.Ins:SetGobLayer(NeedModel.transform , _Layer)        
           lgNoDelCsFun.Ins:PlayAnimation(NeedModel , _ModelName ,_ModelActionName)   
           if _CallBack~=nil then 
              _CallBack(NeedModel , _Data)
           end
           
        end
end

function Create3DModel.CreateThModelCallBack(_data , _prefab)  
    local ModelName = _data.modelName
    --local Model = GameObject.Instantiate(_prefab)
    --Model.transform.name = ModelName
    
    --Model.gameObject:SetActive(true)
    local Model = nil
    if _data.IsCopy==true then
       Model = GameObject.Instantiate(_prefab)
    else     
       Model = GameObject.Instantiate(_prefab)
       if Create3DModel.Models[ModelName]==nil then
          Create3DModel.Models[ModelName] = Model
       end
    end

    if _data.Father~=nil then
       Model.transform.parent = _data.Father.transform  
       Model.transform.localPosition = Vector3(0 , 0 , 0)
       Model.transform.localEulerAngles = Vector3(0 , 0 , 0)
       Model.transform.localScale = Vector3(1 , 1 , 1)
    end

    Model.gameObject:SetActive(true)
    lgNoDelCsFun.Ins:SetGobLayer(Model.transform , _data.Layer)
    lgNoDelCsFun.Ins:PlayAnimation(Model , _data.modelName , _data.ModelActionName)
    if _data.CallBack~=nil then 
		_data.CallBack(Model , _data.Data)
    end
	 LoadingPanel.StopLoadingModel()
end

function Create3DModel.CreateHorse(_Father , _Cb)
    Create3DModel.CreateThModel("Mount1_1" , nil , 5 , _Father , _Cb , true , nil)  
end

function Create3DModel.Rlease()
    Create3DModel.Models =                                          --模型缓存
    { 

    }
end

return Create3DModel