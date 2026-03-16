using UnityEngine;
using System.Collections;

public class UiOneTalk : MonoBehaviour {

	testdybroleai showrole;
	public float showtime = 1.5f;
	float useshowtime = 0f;
	public UILabel showlabel;
	talkinfo_ showinfo;
	lgRoleTalkMag Mymag;
	bool isshow=false;
	public float yadd = 2f;

	Quaternion look1;
	Quaternion look2;
	public void StartTip(lgRoleTalkMag thismag, testdybroleai thisrole,talkinfo_ thisshowinfo)
	{
		Mymag = thismag;
		showrole = thisrole;
		showinfo = thisshowinfo;
		useshowtime = 0f;
		showlabel.text = showinfo.saywords;
		showlabel.effectColor =lgNoDelCsFun.Ins.hexToColor(showinfo.colour2);
		showlabel.color = lgNoDelCsFun.Ins.hexToColor(showinfo.colour1);
		isshow=true;

		look1=Mymag.look1;
		look2=Mymag.look2;
		int randxuanzhuan = Random.Range (0,2);
		if (randxuanzhuan == 0) {
			gameObject.transform.localRotation = look1;
		} else {
			gameObject.transform.localRotation = look2;
		}
		updatapos_by ();
		gameObject.SetActive (true);
		Mymag.StartShow (this);
	}

	// Update is called once per frame
	public void updata (float dt) 
	{
		if(isshow==true)
		{
			useshowtime+=dt;
			if(useshowtime<=showtime)
			{
				//更新位置
				updatapos_by();
			}
			else
			{
				MissionComplete();
			}
		}
	}
	public void updatapos_by()
	{
		//if(showrole.IsMoveing()==false)
		//{
			Vector3 pos = showrole.GetRolePos ();
			pos.y = pos.y + yadd;
			Vector3 pos_2d = Mymag.GetGm3DPosTo2D (pos);
			gameObject.transform.localPosition = pos_2d;
		//}
		
	}
	public void MissionComplete()
	{
		isshow = false;
		gameObject.SetActive (false);
		Mymag.MissionComplete (this);
	}
	
	public void Exit()
	{
		isshow = false;
		gameObject.SetActive (false);
		//tModleFactory.Ins.TempRecoveryObj (numpname,gameObject);
		//GameObject.Destroy (gameObject);
	}
}
