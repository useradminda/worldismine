using UnityEngine;
using System.Collections;
using System.Collections.Generic;
public struct showNumMission_
{
	public int num;
	public Vector3 showpos;
	public bool hasfuhao;
}
public class lgUiTipNumMag 
{

	GameObject uirootobj = null;
	List<UiTipNum> DieTipList = new List<UiTipNum> ();
	List<UiTipNum> ShowTipList = new List<UiTipNum> ();
	List<UiTipNum> WaitShowTipList = new List<UiTipNum> ();
	string tippname="uitip_num";
	List<showNumMission_> showmission = new List<showNumMission_> ();
	float xishu = 1f;
	public void IniSome(GameObject uiroot)
	{
		uirootobj = uiroot;
		xishu = -uiroot.transform.localPosition.x*2f/Screen.width;
	}

	public void GetOneTip(int num,Vector3 showpos,bool hasfuhao)
	{
		showpos = showpos * xishu;
		if (DieTipList.Count > 0) {
			UiTipNum newone = DieTipList [0];
			DieTipList.Remove (newone);
			WaitShowTipList.Add(newone);
			DoOneMission(newone,num,showpos,hasfuhao);
		} else {
			showNumMission_ onemission;
			onemission.num = num;
			onemission.showpos = showpos;
			onemission.hasfuhao = hasfuhao;
			showmission.Add(onemission);
			tModleFactory.Ins.GetOneObj(tippname,GetObjCB,true);
		}
	}

	public void GetObjCB(GameObject obj)
	{
		obj.transform.parent = uirootobj.transform;
		obj.transform.localScale = Vector3.one;
		UiTipNum me = obj.GetComponent<UiTipNum>() as UiTipNum;

		DoOneMission (me);

	}
	public void DoOneMission(UiTipNum me,int num,Vector3 showpos,bool hasfuhao)
	{
		WaitShowTipList.Add(me);
		me.StartTip (num,showpos,this,hasfuhao);
	}
	public void DoOneMission(UiTipNum me)
	{
		if(showmission.Count>0)
		{
			me.StartTip (showmission[0].num,showmission[0].showpos,this,showmission[0].hasfuhao);
			showmission.RemoveAt(0);
		}
	}
	public void StartShow(UiTipNum me)
	{
		WaitShowTipList.Remove (me);
		ShowTipList.Add (me);
	}
	public void MissionComplete(UiTipNum me)
	{
		ShowTipList.Remove (me);
		DieTipList.Add (me);
	}
	public void updata(float dt)
	{
		for(int i=0;i<ShowTipList.Count;i++)
		{
			ShowTipList[i].updata(dt);
		}
	}
	public void Exit()
	{
		for(int i=0;i<ShowTipList.Count;i++)
		{
			ShowTipList[i].Exit();
		}
		for(int i=0;i<DieTipList.Count;i++)
		{
			DieTipList[i].Exit();
		}
		for(int i=0;i<WaitShowTipList.Count;i++)
		{
			WaitShowTipList[i].Exit();
		}
		ShowTipList.Clear ();
		DieTipList.Clear ();
		WaitShowTipList.Clear ();
		showmission.Clear ();
	}

}
