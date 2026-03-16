using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class UIWrap : MonoBehaviour {
	public UIPanel mpanel;
	public Transform mtrans;
	private UIScrollBar UISB;

	private UIScrollView _Sc = null;
	private UIScrollView Sc 
	{
		get
		{
			if(_Sc==null)
			{
				if(mpanel.GetComponent<UIScrollView>()==null)
				{
					mpanel.gameObject.AddComponent<UIScrollView>();
				}
				_Sc = mpanel.GetComponent<UIScrollView>();
			}
			return _Sc;
		}
	}

	
	public List<Transform> TransChild = new List<Transform>();					//列表子个数 根据显示的大小摆放
	
	
	private int _MaxLineCount = 0;
	private int MaxLineCount													//最高 列行 行数
	{
		get
		{
			if(_MaxLineCount==0)
			{
				int _C = DataNum/ItemCount;
				int _T = DataNum%ItemCount;
				if(_T==0)																//整除
				{
					_MaxLineCount = _C;
				}
				else
				{
					_MaxLineCount = _C + 1;
				}
			}
			return _MaxLineCount;
		}
	}
	
	public int ItemWith;														//每个道具的规模 尺寸 外部设置	
	private int DataNum;															//数据个数	
	
	public int ItemCount;														//单位列行 个数 外部设置 根据界面设置
	
	private int _WrapLine = 0;
	private int WrapLine 
	{
		get
		{
			if(_WrapLine==0)
			{
				_WrapLine = TransChild.Count/ItemCount;
			}
			return _WrapLine;
		}
	}
	
	private string LuaName = "";
	
	//public int MinLineCount;
	// Use this for initialization
	void Start ()
	{

	}

    void OnEnable()
    {
        mpanel.clipOffset=Vector2.zero;
		if(Sc.GetComponent<SpringPanel>()!=null)
		{
			Sc.GetComponent<SpringPanel>().target = new Vector3(0 , 0 , 0);
		}
    }
	public void ResetTrans(int _ReDataNum) 														//排序之后界面回拉至顶端
	{
		Sc.currentMomentum = Vector3.zero;
		mpanel.clipOffset=Vector2.zero;
		if(Sc.GetComponent<SpringPanel>()!=null)
		{
			Sc.GetComponent<SpringPanel>().target = new Vector3(0 , 0 , 0);
		}
        for (int i = 0 ; i < TransChild.Count ; i++)
		{
			Transform _itemTan = TransChild[i];	
			_itemTan.name = (i+1).ToString();
			if(Sc.movement == UIScrollView.Movement.Horizontal)
			{
				_itemTan.localPosition = new Vector3((i/ItemCount)*ItemWith , 0 , 0);
			}
			else if(Sc.movement == UIScrollView.Movement.Vertical)
			{
				_itemTan.localPosition = new Vector3(0 , -(i/ItemCount)*ItemWith , 0);
			}
			if(i > _ReDataNum - 1)
			{
				_itemTan.transform.gameObject.SetActive(false); 
			}
			
		}
		
		_MaxLineCount = 0;
		DataNum = _ReDataNum;
		for (int i = 0 ; i < TransChild.Count ; i++)
		{
			Transform _itemTan = TransChild[i];	
			if(i <= _ReDataNum - 1)
			{
			   lgNoDelCsFun.Ins.UpdateWrapItem(_itemTan , this.LuaName);
			}
		} 
		Sc.currentMomentum = Vector3.zero;
		//Sc.currentMomentum = Vector3.zero;
	}
	
	public void SetData(int _DataNum , string _LuaName)
	{
		TransChild.Clear();
		DataNum = _DataNum;
		LuaName = _LuaName;
		mpanel.onClipMove = OnMove;
		for(int i = 0 ; i < mtrans.childCount ; i++)
		{
			Transform _itemTan = mtrans.GetChild(i);	
			//_itemTan.name = (i+1).ToString();
			if(i > DataNum - 1)
			{	   
				if(_itemTan.gameObject.activeInHierarchy==true)
				   _itemTan.transform.gameObject.SetActive(false);   
			}
			else
			{
				if(_itemTan.gameObject.activeInHierarchy==false)
				   _itemTan.transform.gameObject.SetActive(true);   
			}
			TransChild.Add(_itemTan);
		}		

	}
	
	public Transform GetChildTrans(int _Index)
	{
		return TransChild[_Index - 1];
	}
	
	void OnMove(UIPanel _Panel)
	{
		bool allWithinRange = true;
		
		Vector3[] corners = _Panel.worldCorners;
		
		for (int i = 0; i < 4; ++i)
		{
			Vector3 v = corners[i];
			
			v = mtrans.InverseTransformPoint(v);
			corners[i] = v;
		}
		
		Vector3 center = Vector3.Lerp(corners[0], corners[2], 0.5f);
		if(Sc.movement == UIScrollView.Movement.Vertical)
		{
			
		}
		else
		{
			//center = Vector3.Lerp(corners[1], corners[3], 0.5f);
		}	
			
		for(int i = 0 ; i < TransChild.Count ; i++)
		{
			if(Sc.movement == UIScrollView.Movement.Vertical)
			{
				float distance = TransChild[i].transform.localPosition.y - center.y;
				if(distance >= ((float)ItemWith/2)*WrapLine)
				{
					Vector3 pos = TransChild[i].transform.localPosition;
					pos.y = TransChild[i].localPosition.y +(-WrapLine*ItemWith);
					int realLineIndex = Mathf.RoundToInt(-pos.y / ItemWith);
					++realLineIndex;
					//Debug.LogError(TransChild[i].transform.name);
					if(realLineIndex>0&&realLineIndex<=MaxLineCount)
					{
					   TransChild[i].transform.localPosition = new Vector3(TransChild[i].localPosition.x , TransChild[i].localPosition.y +(-WrapLine*ItemWith) , 0f);
					   UpdateItem(realLineIndex , TransChild[i]);
					}			
				}
				else if(distance <= -((float)ItemWith/2)*WrapLine)
				{
					Vector3 pos = TransChild[i].transform.localPosition;
					pos.y = TransChild[i].localPosition.y +(WrapLine*ItemWith);
					int realLineIndex = Mathf.RoundToInt(pos.y / ItemWith);
					--realLineIndex;
					//Debug.LogError(TransChild[i].transform.name);
					if(-realLineIndex>0&&-realLineIndex<=MaxLineCount)
					{
					   TransChild[i].transform.localPosition = new Vector3(TransChild[i].localPosition.x , TransChild[i].localPosition.y +(WrapLine*ItemWith) , 0f);
					   UpdateItem(-realLineIndex , TransChild[i]);
					}
				}
			}
			else if(Sc.movement == UIScrollView.Movement.Horizontal)
			{
				float distance = TransChild[i].transform.localPosition.x - center.x;	
				//Debug.LogError(center.x);
				if(distance >= ((float)ItemWith/2)*WrapLine)
				{
					/*Vector3 pos = TransChild[i].transform.localPosition;
					pos.x = TransChild[i].localPosition.x +(WrapLine*ItemWith);
					int realLineIndex = Mathf.RoundToInt(pos.x / ItemWith);
					--realLineIndex;
					Debug.LogError(realLineIndex);
					Debug.LogError(MaxLineCount);
					//Debug.LogError(realLineIndex);
					//Debug.LogError(TransChild[i].transform.name);
					if(-realLineIndex>0&&-realLineIndex<=MaxLineCount)
					{
					   TransChild[i].transform.localPosition = new Vector3(TransChild[i].localPosition.x +(WrapLine*ItemWith) , TransChild[i].localPosition.y , 0f);
					   UpdateItem(-realLineIndex , TransChild[i]);
					}*/
					
					Vector3 pos = TransChild[i].transform.localPosition;
					pos.x = TransChild[i].localPosition.x +(-WrapLine*ItemWith);
					int realLineIndex = Mathf.RoundToInt(pos.x / ItemWith);
					++realLineIndex;
					
					//Debug.LogError(realLineIndex);
					//Debug.LogError(TransChild[i].transform.name);
					if(realLineIndex>0&&realLineIndex<=MaxLineCount)
					{
					   TransChild[i].transform.localPosition = new Vector3(TransChild[i].localPosition.x +(-WrapLine*ItemWith) , TransChild[i].localPosition.y  , 0f);
					   UpdateItem(realLineIndex , TransChild[i]);
					}			
				}
				else if(distance <= -((float)ItemWith/2)*WrapLine)
				{
					//Debug.LogError(center.x);
					//Debug.LogError(distance);
					//Debug.LogError(-((float)ItemWith/2)*WrapLine);
					Vector3 pos = TransChild[i].transform.localPosition;
					pos.x = TransChild[i].localPosition.x +(WrapLine*ItemWith);
					int realLineIndex = Mathf.RoundToInt(-pos.x / ItemWith);
					--realLineIndex;
					
					//Debug.LogError(realLineIndex);
					//Debug.LogError(TransChild[i].transform.name);
					if(-realLineIndex>0&&-realLineIndex<=MaxLineCount)
					{
					   TransChild[i].transform.localPosition = new Vector3(TransChild[i].localPosition.x +(WrapLine*ItemWith) , TransChild[i].localPosition.y , 0f);
					   UpdateItem(-realLineIndex , TransChild[i]);
					}
					
					/*Vector3 pos = TransChild[i].transform.localPosition;
					pos.x = TransChild[i].localPosition.x +(-WrapLine*ItemWith);
					int realLineIndex = Mathf.RoundToInt(-pos.x / ItemWith);
					++realLineIndex;
					
					//Debug.LogError(TransChild[i].transform.name);
					if(realLineIndex>0&&realLineIndex<=MaxLineCount)
					{
					   TransChild[i].transform.localPosition = new Vector3(TransChild[i].localPosition.x +(-WrapLine*ItemWith) , TransChild[i].localPosition.y  , 0f);
					   UpdateItem(realLineIndex , TransChild[i]);
					}*/			
				}
			}
				
		}
	}
	
	void UpdateItem(int _NowLine , Transform _NowTans)
	{
		int _NameIndex = 0;
		string[] Names = _NowTans.name.Split('_');
		if(Names.Length == 2)
		{
			_NameIndex = System.Convert.ToInt32(Names[1]);
		}
		else
		{
			_NameIndex = System.Convert.ToInt32(_NowTans.name);
		}
        
        var surplus = _NameIndex%ItemCount;
	    int _Name = (_NowLine - 1)*ItemCount +(surplus == 0 ?ItemCount: surplus);
        _NowTans.name = (_Name).ToString();	
		lgNoDelCsFun.Ins.UpdateWrapItem(_NowTans , this.LuaName);
	}
	
	public void ReflashItems(int _DataNum)							//添加删除道具之后 直接刷新 不需要回拉
	{
		_MaxLineCount = 0;
		DataNum = _DataNum;
		for (int i = 0 ; i < TransChild.Count ; i++)
		{
			Transform _itemTan = TransChild[i];	
			lgNoDelCsFun.Ins.UpdateWrapItem(_itemTan , this.LuaName);
			
		} 
	}


    private UIGrid _Grid = null;
    private UIGrid Grid
    {
        get
        {
            if (_Grid == null)
            {
                _Grid = mtrans.GetComponent<UIGrid>();
            }
            return _Grid;
        }
    }

    public void SetGridCenter()
    {
        Grid.pivot = UIWidget.Pivot.Center;
    }

    public void SetGridTopLeft()
    {
        Grid.pivot = UIWidget.Pivot.TopLeft;
    }
}
