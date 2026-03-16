using UnityEngine;
using System.Collections;

public class lgUiJiesuoRoleTipMag : MonoBehaviour {

	public UILabel name;
	public UILabel jieshao;
	public GameObject roleroot;
	public BtUIEventListener backbt;
	GameObject showrole;
	int showroledbid=-1;
	string showrolepname="";
	lgBtUiMag Mymag;
	bool isshow=false;
	public GameObject waitloadtipobj;
	public void IniSome(lgBtUiMag thismag,int thisshowroledbid)
	{
		if(showroledbid!=thisshowroledbid&&showrole!=null)
		{
			showrole.transform.parent = null;
			GameObject.Destroy(showrole,0f);
			showrole = null;
			showroledbid =-1;
		}
		Mymag = thismag;
		showroledbid = thisshowroledbid;
		backbt.GexingP_i = 1;
		backbt.GexingP_s = "jixuyouxi";
		backbt.onClick = JixuyouxiBtClick;

		waitloadtipobj.SetActive (true);
		Roledata_ roledata = lgCfgMag.Ins.Get_RoleData(showroledbid);
		showrolepname = roledata.prefabname;
		name.text = roledata.name;
		jieshao.text = roledata.Description;
		isshow=true;
		tModleFactory.Ins.GetOneObj (showrolepname, GetOneObjCB);
	}
	public void GetOneObjCB(GameObject role)
	{
		if(isshow==false)
		{
			return;
		}
		waitloadtipobj.SetActive (false);
		showrole = role;
		showrole.transform.parent = roleroot.transform;
		showrole.transform.localScale = Vector3.one;
		showrole.transform.localPosition = Vector3.zero;
		showrole.transform.localRotation = Quaternion.identity;

		showrole.layer=5;
		Transform[] child = showrole.GetComponentsInChildren<Transform>();
		for(int i=0;i<child.Length;i++)
		{
			child[i].gameObject.layer = 5;
		}
		showrole.SetActive (true);
	}
	public void JixuyouxiBtClick(GameObject thisobj, int Order,string key)
	{
		if (isshow == true) {
			Exit ();
		}
	}
	public void Exit()
	{
		isshow=false;
		if(showrole!=null)
		{
			tModleFactory.Ins.TempRecoveryObj (showrolepname, showrole);
			showrole = null;
			showrolepname="";
			showroledbid=-1;
		}
		//gameObject.transform.parent = null;
		//gameObject.SetActive (false);
		Mymag.JiesuoRoleTipFinish ();
		Mymag = null;
	}
}
