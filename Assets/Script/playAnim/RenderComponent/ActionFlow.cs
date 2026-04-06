using UnityEngine;
using System.Collections.Generic;
[System.Serializable]
[ExecuteInEditMode]
public class ActionFlow : MonoBehaviour
{
    public GameObject RunEffect;
    private GameObject runEffect;
    private GameObject RunGameObject
    {
        get
        {
            if (RunEffect != null)
            {
                if (runEffect == null)
                {
                    if (Application.isPlaying == true)
                    {
                        //runEffect = RunEffect.GetCatchEntityObject();
                        //runEffect.transform.parent = transform;
                        //runEffect.transform.localPosition = Vector3.zero;
                        //runEffect.transform.localScale = Vector3.one;
                    }
                }
                return runEffect;
            }
            return null;
        }
    }


    private RenderComponent renderComponenter;
    protected RenderComponent RenderComponenter
    {
        get
        {
            if (renderComponenter == null)
                renderComponenter = gameObject.GetComponent<RenderComponent>();
            return renderComponenter;
        }
    }

    private Animator animator;
    protected Animator AnimatorC
    {
        get
        {
            if(animator == null)
            {
                animator = gameObject.GetComponentInChildren<Animator>();
            }
            return animator;
        }
    }

   

    private float attackTime
    {
        get
        {
            return 0;
        }
    }


    public float currentTime;


    public float AnimTime = 1f;
    private float animBeilv = 1;

    public ActionData CurrentActionData => currentActionData;
    private ActionData currentActionData;


    public List<ActionData> ActionDataList = new List<ActionData>();
    public Dictionary<EActionType, ActionData> ActionDataDic = new Dictionary<EActionType, ActionData>();

    // Start is called before the first frame update
    void Awake()
    {             
        initActionData();
        PlayAction(EActionType.Idle);
        //SetActionInfo(AnimTime, null);
    }

    private void OnEnable()
    {
        if(ActionDataList.Count == 0)
        {
            ActionData _data = new ActionData() { ActionType = EActionType.Idle, ActionTime = 1 };
            ActionDataList.Add(_data);
            _data = new ActionData() { ActionType = EActionType.Run, ActionTime = 1.5f };
            ActionDataList.Add(_data);
            _data = new ActionData() { ActionType = EActionType.Attack, ActionTime = 1 };
            ActionDataList.Add(_data);
            _data = new ActionData() { ActionType = EActionType.Die, ActionTime = 1 };
            ActionDataList.Add(_data);
            _data = new ActionData() { ActionType = EActionType.Victory, ActionTime = 2 };
            ActionDataList.Add(_data);
        }
    }

    private void Start()
    {
        //PlayAction(EActionType.Victory);
    }

    public void SetActionInfo(float totalTime, Material material)
    {
        currentTime = Random.Range(0, 1.5f);

        // propertyBlock = new MaterialPropertyBlock();
        // render = GetComponentInChildren<Renderer>();
        // if(material != null)
        // render.sharedMaterial = material;
        //render.GetPropertyBlock(mPropertyBlock);

        RenderComponenter.SetPropertyBlockFloat("_AnimLen", totalTime);
        RenderComponenter.SetPropertyBlockFloat("_CurrentTime", currentTime);


        //propertyBlock.SetFloat("_AnimLen", totalTime);
        //propertyBlock.SetFloat("_CurrentTime", currentTime);
        // 受击闪白
        //propertyBlock.SetColor("_SlashColor", new Color(0.7f,0.7f,0.7f,1f));
        // 冰冻
        //propertyBlock.SetFloat("_ICEState", 1);


        // mPropertyBlock.SetTexture("_AnimMap", tex); // 不可以设置texture
        //render.SetPropertyBlock(propertyBlock);
    }

    // 
    public void ActionFreeze(float _animBeilv)
    {
        animBeilv = 1f/_animBeilv;
        setActionAnimLenth(currentActionData);
    }

    public void ActionExitFreeze()
    {
        animBeilv = 1;
        setActionAnimLenth(currentActionData);
    }


    // 播放一个动画
    public void PlayAction(EActionType _actionType)
    {
        if(ActionDataDic != null && ActionDataDic.ContainsKey(_actionType))
        {
            ActionData _actionData = ActionDataDic[_actionType];        
            currentActionData = _actionData;
            if (_actionData.Mat == null)
            {
                animatorPlay(_actionType.ToString());
                return;
            }
            else
            {
                RenderComponenter.SetMat(_actionData.Mat);
            }
            setActionDataTime(currentActionData);
            setActionAnimLenth(currentActionData);
            if (_actionType == EActionType.Run)
            {
                currentTime = Random.Range(0, 1f);
                RenderComponenter.SetPropertyBlockFloat("_CurrentTime", currentTime);
                RenderComponenter.SetPropertyBlockFloat("_TimeSinceLevelLoad", Time.time);
            }
            else
            {
                currentTime = 0;
                RenderComponenter.SetPropertyBlockFloat("_CurrentTime", currentTime);
                RenderComponenter.SetPropertyBlockFloat("_TimeSinceLevelLoad", Time.time);
            }
            if(_actionType == EActionType.Run)
            {
                if (RunGameObject)
                    RunGameObject.SetActive(true);
            }
            else
            {
                if (RunGameObject)
                    RunGameObject.SetActive(false);
            }
        }
    }
    private void setActionDataTime(ActionData _actionData)
    {
        if (_actionData.ActionType == EActionType.Attack)
        {
            _actionData.ActionTime = attackTime;
        }
    }

    private void setActionAnimLenth(ActionData _actionData)
    {
        float _animLenth = _actionData.ActionTime * animBeilv;
        RenderComponenter.SetPropertyBlockFloat("_AnimLen", _animLenth);
    }

    public float GetActionTime(EActionType _actionType)
    {
        if(ActionDataDic != null && ActionDataDic.ContainsKey(_actionType))
        {
            ActionData _actionData = ActionDataDic[_actionType];
            return _actionData.ActionTime;
        }
        return 1;
    }

    // Update is called once per frame

    private void initActionData()
    {
        for(int i = 0; i < ActionDataList.Count; i++)
        {
            ActionDataDic.Add(ActionDataList[i].ActionType, ActionDataList[i]);           
        }
    }



    private void animatorPlay(string _stateName)
    {
        if(AnimatorC != null)
            AnimatorC.CrossFade(_stateName,0.05f);
    }

}

[System.Serializable]
public class ActionData
{
    public Material Mat;
    public float ActionTime;
    public EActionType ActionType = EActionType.None;
}
[System.Serializable]
public enum EActionType
{
    None,
    Run,
    Attack,
    Die,
    Idle,
    Victory,
}