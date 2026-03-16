using UnityEngine;
using System.Collections;
using System.Collections.Generic;
public class lgSmallMapMag  {
	#if MinMap
	public UISprite bg;
	GameObject uirootobj = null;
	List<UiRolePos> DieTipList = new List<UiRolePos> ();
	List<UiRolePos> ShowTipList = new List<UiRolePos> ();
	List<UiRolePos> WaitShowTipList = new List<UiRolePos> ();
	string tippname="RolePosTip";
	
	List<showHpMission_> showmission = new List<showHpMission_> ();
	
	lgBtUiMag MyBtUiMag;
	float xishu = 1f;
	public void IniSome(GameObject uiroot,lgBtUiMag thismag,int mapx,int mapy)
	{
		uirootobj = uiroot;
		MyBtUiMag = thismag;
		xishu = -uiroot.transform.localPosition.x*2f/Screen.width;
	}

	public void GetOneTip(testdybroleai thisrole)
	{
		if (DieTipList.Count > 0) {
			UiRolePos newone = DieTipList [0];
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
		UiRolePos me = obj.GetComponent<UiRolePos>() as UiRolePos;
		
		DoOneMission (me);
		
	}
	public void DoOneMission(UiRolePos me,testdybroleai thisrole)
	{
		WaitShowTipList.Add(me);
		me.StartTip (this,thisrole);
	}
	public void DoOneMission(UiRolePos me)
	{
		if(showmission.Count>0)
		{
			me.StartTip (this,showmission[0].showrole);
			showmission.RemoveAt(0);
		}
	}
	public void StartShow(UiRolePos me)
	{
		WaitShowTipList.Remove (me);
		ShowTipList.Add (me);
	}
	public void MissionComplete(UiRolePos me)
	{
		ShowTipList.Remove (me);
		DieTipList.Add (me);
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
#endif
}
