using UnityEngine;
using System.Collections;
using System.Collections.Generic;
public delegate void GetOneObjCB(GameObject obj);
public class tModleFactory  {

	//public AssetLoder MyAssetLoder; //资源加载器
	public Dictionary<string, List<GameObject>> CreateObjFactory = new Dictionary<string, List<GameObject>>();
	public GameObject testobj1;
	public lgammomag MyammoFactory=null;
	//public bool b_Ini=false;
	private static tModleFactory _ins =null ;

    private int uuid_int = 0;
	public lgAnimationCurveList MyAnimationCurveList;
	public lgTxMag MyTxFactory = null;

	public Dictionary<string, List<GetOneObjCB>> CSLoadObjCBList = new Dictionary<string, List<GetOneObjCB>>();

	public static tModleFactory Ins
	{
		get
		{
			if (_ins == null)
			{
				_ins =new tModleFactory();
				
			}
			return _ins;
		}
	}
    public void IniSome()
    {
        MyammoFactory = new lgammomag();
        MyammoFactory.IniSome();
		MyTxFactory = new lgTxMag ();
		MyTxFactory.IniSome ();

		GameObject obj= Resources.Load ("AnimationCurveObj")as GameObject;
			
		GameObject testobj = GameObject.Instantiate(obj);
		GameObject.DontDestroyOnLoad (testobj);
		MyAnimationCurveList = testobj.GetComponent<lgAnimationCurveList>() as lgAnimationCurveList;
	}

	public int GetBtUuid()
    {
        uuid_int--;
        return uuid_int;

    }
    public void ClearBtUuid()
    {
        uuid_int=0;
    }
    /// <summary>
    /// 测试用
    
    private Dictionary<string ,GameObject> hasloadobj = new Dictionary<string,GameObject>();


    /// </summary>
	public bool GetOneObj(string pname,GetOneObjCB thiscb)
	{
		return GetOneObj (pname, thiscb, false);
	}

	public bool GetOneObj(string pname,GetOneObjCB thiscb,bool isui)
	{
		if(pname==""||pname==null)
		{
			Debug.LogError("tModleFactory GetOneObj pname=null");
		}
		GameObject result=null;
		List<GameObject> list;
		if (CreateObjFactory.TryGetValue (pname, out list) == true) {
			if(list.Count>0)
			{
				result = list[0];
				list.RemoveAt(0);
				thiscb(result);
				return true;
			}

		} 

		if (hasloadobj.TryGetValue(pname,out result)==true)
		{

			GameObject testobj = GameObject.Instantiate(result);
			thiscb(testobj);
			return true;
		}




		List<GetOneObjCB> tempcb;
		if (CSLoadObjCBList.TryGetValue (pname,out tempcb) == false) {
			tempcb = new List<GetOneObjCB> ();
			tempcb.Add (thiscb);
			CSLoadObjCBList.Add(pname,tempcb);

		} else {
			tempcb.Add (thiscb);
		}
		//向 AssetLoder 申请加载资源
		lgNoDelCsFun.Ins.CSLoadAssetAsset (pname,isui);
		//测试用
		/*
		if(true)
		{
            GameObject pobj;
            if (hasloadobj.TryGetValue(pname,out pobj)==false)
            {
                pobj = Resources.Load(pname) as GameObject;
                hasloadobj.Add(pname, pobj);

            }
			if(pobj==null)
			{
				Debug.LogError("No Prefab name = "+pname);
			}
            GameObject testobj = GameObject.Instantiate(pobj);
			thiscb(testobj);
			return true;
		}
		*/
		return false;

	}

	public void GetAbObj(string name,GameObject Obj)
	{
		if(Obj==null)
		{
			Debug.LogError("obj==null name = "+name);
		}
		hasloadobj.Add (name,Obj);

		List<GetOneObjCB> tempcb;
		if (CSLoadObjCBList.TryGetValue (name, out tempcb) == true) {

			for(int i=0;i<tempcb.Count;i++)
			{
				GameObject testobj = GameObject.Instantiate(Obj);
				tempcb[i](testobj);
			}
			CSLoadObjCBList.Remove(name);
		}
	}



	public void TempRecoveryObj(string pname,GameObject obj)
	{
		obj.SetActive (false);
		obj.transform.parent = null;
		obj.transform.position = Vector3.zero;
		List<GameObject> list;
		if (CreateObjFactory.TryGetValue (pname, out list) == true) {
			list.Add (obj);
		} else {
			list = new List<GameObject>();
			list.Add(obj);

			CreateObjFactory.Add(pname,list);
		}

	}

	public void ClearObj()
	{
		List<string> keylist = new List<string>(CreateObjFactory.Keys);
		List<GameObject> list;
		for(int i=0;i<keylist.Count;i++)
		{
			if(CreateObjFactory.TryGetValue(keylist[i], out list)==true)
			{

				for(int k=0;k<list.Count;k++)
				{
					GameObject.Destroy(list[k]);
				}
				list.Clear();
			}

		}
		CreateObjFactory.Clear ();
	}
}
