using UnityEngine;
using System.Collections;
using System.Collections.Generic;
public struct showHpMission_
{
	public testdybroleai showrole;

}
public class lgUiTipHpMag 
{
	
	GameObject uirootobj = null;
	List<UiTipHp> DieTipList = new List<UiTipHp> ();
	List<UiTipHp> ShowTipList = new List<UiTipHp> ();
	List<UiTipHp> WaitShowTipList = new List<UiTipHp> ();
	public string tippname="herohptip";

	List<showHpMission_> showmission = new List<showHpMission_> ();

	lgBtUiMag MyBtUiMag;
	float xishu = 1f;

	public void IniSome(GameObject uiroot,lgBtUiMag thismag)
	{
		uirootobj = uiroot;
		MyBtUiMag = thismag;
		xishu = -uiroot.transform.localPosition.x*2f/Screen.width;
	}
	
	public void GetOneTip(testdybroleai thisrole)
	{
		if (DieTipList.Count > 0) {
			UiTipHp newone = DieTipList [0];
			DieTipList.Remove (newone);
			WaitShowTipList.Add(newone);
			DoOneMission(newone,thisrole);
		} else {
			showHpMission_ onemission;

			onemission.showrole = thisrole;
			showmission.Add(onemission);
			tModleFactory.Ins.GetOneObj(tippname,GetObjCB,true);
		}
	}
	
	public void GetObjCB(GameObject obj)
	{
		//Debug.LogError ("GetOneHeroHpTip   GetObjCB ");
		obj.transform.parent = uirootobj.transform;
		obj.transform.localScale = Vector3.one;
		UiTipHp me = obj.GetComponent<UiTipHp>() as UiTipHp;
		
		DoOneMission (me);
		
	}
	public void DoOneMission(UiTipHp me,testdybroleai thisrole)
	{
		WaitShowTipList.Add(me);
		me.StartTip (this,thisrole);
	}
	public void DoOneMission(UiTipHp me)
	{
		if(showmission.Count>0)
		{
			me.StartTip (this,showmission[0].showrole);
			showmission.RemoveAt(0);
		}
	}
	public void StartShow(UiTipHp me)
	{
		WaitShowTipList.Remove (me);
		ShowTipList.Add (me);
	}
	public void MissionComplete(UiTipHp me)
	{
		ShowTipList.Remove (me);
		DieTipList.Add (me);
	}
	//public void updata(float dt)
	//{
	//	for(int i=0;i<ShowTipList.Count;i++)
	//	{
			//ShowTipList[i].updata(dt);
	//	}
	//}
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
	public Vector3 GetGm3DPosTo2D(Vector3 tarpos)
	{
		return MyBtUiMag.GetGm3DPosTo2D (tarpos)*xishu;
	}

	public void CameChangePos()
	{
		for(int i=0;i<ShowTipList.Count;i++)
		{
			ShowTipList[i].updatapos_by();
		}
	}
}