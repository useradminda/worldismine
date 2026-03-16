using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using SLua;
/*所有挂载的脚本继承这个脚本*/
/*挂脚本的脚本名字必须和事件处理的Lua文件名一样*/

[CustomLuaClass]
public abstract class BasePanel : MonoBehaviour {
	public List<GameObject> Panel_Items = new List<GameObject>();
	public static List<BasePanel> All_Panel = new List<BasePanel>();

	private string _ScripName;
	public string ScripName
	{
		get
		{
			_ScripName = this.GetType().Name;
			return _ScripName;
		}
	}
	
	// Use this for initialization
	 void Start () 
	{
	   
		//Relogin_BasePanel(this);
		Box_Add_Event();
	}
	
	public virtual void OnClickItem(GameObject _Gob)
	{
		//Debug.Log(_Gob.name + "     " + ScripName);
		
		//AudioManager.Instance.Play("Effect_button" , lgNoDelCsFun.Ins.gameObject.transform ,  1 , false , 0);
		lgNoDelCsFun.Ins.GetUIEvent(_Gob , ScripName);
	}
	
	public virtual void OnDrapUpItem(GameObject _Gob , GameObject _go)	//放鼠标之后 第一个是起手Gob 第二个是拖动GOB
	{
		lgNoDelCsFun.Ins.GetUIDragUpEvent(_Gob , ScripName , _go);
	}
	
	public virtual void OnDrapItem(GameObject _Gob , Vector2 _detal)   //拖动事件
	{
		lgNoDelCsFun.Ins.GetUIDragEvent(_Gob , ScripName , _detal);
	}
	public virtual void OnPressItem(GameObject _Gob , bool ispress)   //长按事件事件
	{
		lgNoDelCsFun.Ins.GetUIPressItemEvent(_Gob , ScripName , ispress);
	}
	void Relogin_BasePanel(BasePanel _Bpanel)							//注册当前界面z
	{
		if(!All_Panel.Contains(_Bpanel))
		{
			All_Panel.Add(_Bpanel);
		}
	}
	
	void Box_Add_Event()											//给所有带BOX的按钮加事件z
	{
		if(transform.GetComponent<BoxCollider>()!=null)
		{
			AddEventLisnter(gameObject);
		}
		
		/*Component[] Components = transform.GetComponentsInChildren<Component>();
		for(int i = 0 ; i < Components.Length ; i++)
		{
			if(Components[i] is BoxCollider)
			{
				Debug.Log(Components[i].gameObject.name);
				AddEventLisnter(Components[i].gameObject);
			}
		}*/
		
		AddUIEvent(transform);
		
		for(int i = 0 ; i < Panel_Items.Count ; i++)
		{
			if(Panel_Items[i].GetComponent<BoxCollider>()!=null)
			{
				AddEventLisnter(Panel_Items[i]);
			}
		}
	}
	
	public static void Cancle_BasePanel(string _BpanelName)				//注销某个界面z
	{
		for(int i = 0 ; i < All_Panel.Count ; i++)
		{
			if(All_Panel[i].ScripName==_BpanelName)
			{
				All_Panel.Remove(All_Panel[i]);
				break;
			}
		}
	}
	
	public static BasePanel FindBpane(string _BpanelName)				//找到某个注册的界面z
	{
		for(int i = 0 ; i < All_Panel.Count ; i++)
		{
			if(All_Panel[i].ScripName==_BpanelName)
			{
				return All_Panel[i];
			}
		}
		return null;
	}
	
	public static void Relogin_OneBpanel(BasePanel _Bpanel)				//注册某个界面z
	{
		if(!All_Panel.Contains(_Bpanel))
		{
			Debug.Log( "successRelogin" + _Bpanel.ScripName);
			All_Panel.Add(_Bpanel);
		}
		else 
		{
			return;
		}
	}
	
	public static GameObject FindPanel_Item(string _ItemName , string _ScripName)		//根据界面名字找到某个物体z
	{
	 	for(int i =0 ; i <	BasePanel.All_Panel.Count ; i++)
		{
			if(_ScripName==BasePanel.All_Panel[i].ScripName)
			{
				for(int j = 0 ; i < BasePanel.All_Panel[i].Panel_Items.Count ; j++)
				{
					if(BasePanel.All_Panel[i].Panel_Items[i].name==_ItemName)
					{
						Debug.Log("Get"+"ItemName" + _ItemName + "ScripName:" + _ScripName);
						return BasePanel.All_Panel[i].Panel_Items[i];
					}
				}	
			}	
		}
		Debug.Log("Empty"+"ItemName:" + _ItemName  +"\n" + "ScripName:" + _ScripName);
		return null;
	}
	
	public GameObject FindPanel_Item(string _ItemName)							//找到当前界面的某个物体z
	{
		for(int i = 0 ; i < Panel_Items.Count ; i++)
		{
			if(_ItemName==Panel_Items[i].name)
			{
				Debug.Log("Get " + ScripName + " " + _ItemName);
				return Panel_Items[i];
			}
		}
		Debug.Log("Empty"+"ItemName:" + _ItemName  +"\n" + "ScripName:" + ScripName);
		return null;
	}
	
	public GameObject FindPanel_Item(int _Id)								//根据ID找到当前界面挂载下面的物体z
	{
		if(_Id < Panel_Items.Count - 1)
		{
			if(Panel_Items[_Id]!=null)
			{
				Debug.Log("Get " + ScripName + " ItemID: " + _Id.ToString());
				return Panel_Items[_Id];
			}
		}
		Debug.Log("Empty"+"ItemID: " + _Id.ToString()  +"\n" + "ScripName:" + _ScripName);
		return null;
	}
	
	
	public void AddEventLisnter(GameObject _Gob)									
	{
		if(_Gob.GetComponent<UIEventListener>()==null)
		{
			_Gob.AddComponent<UIEventListener>();
		}
		_Gob.GetComponent<UIEventListener>().onClick = OnClickItem;
		_Gob.GetComponent<UIEventListener>().onDrop = OnDrapUpItem;
		_Gob.GetComponent<UIEventListener>().onDrag = OnDrapItem;
		_Gob.GetComponent<UIEventListener>().onPress = OnPressItem;
	}

	public void AddUIEvent(Transform _transform)								//给BOX添加UIListener 给Scale进行初始化z
	{
		Transform[] Components = _transform.GetComponentsInChildren<Transform>(true);
		for(int i = 0 ; i < Components.Length ; i++)
		{
			if(_transform!=Components[i].transform&&Components[i].GetComponent<BasePanel>()!=null)
			{

				break;
			}
			if(Components[i]!=null)
			{
				if(Components[i].GetComponent<BoxCollider>()!=null)
				{
					AddEventLisnter(Components[i].gameObject);
				}
				
			}
		}
		
	}
	
	/*void InitLanguage(List<Transform> _TempTrans)																	//打开界面时的初始化 多国化z
	{
		for(int i = 0 ; i < _TempTrans.Count ; i++)
		{
			if(_TempTrans[i]!=null&&_TempTrans[i].GetComponent<UILabel>()!=null)
			{
				string _Key = _TempTrans[i].GetComponent<UILabel>().text;
				_TempTrans[i].GetComponent<UILabel>().text  = UIString.Ins.GetString(_Key);
			}
		}
	}
	*/
}
