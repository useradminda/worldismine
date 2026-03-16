using UnityEngine;
using System.Collections;

public class UiTipHp : MonoBehaviour {


	bool isshow = false;

	//Vector3 objpos;

	testdybroleai showrole;
	public UISlider hpslider;
	lgUiTipHpMag Mymag;
	int basenum;
	int nownum;
	public float RoleHigh = 1f;
	public UISprite lvse;
	public UISprite hongse;
	public void StartTip(lgUiTipHpMag thismag, testdybroleai thisrole)
	{
		if(thisrole==null)
		{
			Debug.LogError("UiTipHp error thisrole=null");
			return;
		}
		showrole = thisrole;
		Mymag = thismag;
		if (showrole.IsDie == false) 
		{
			isshow = true;
			if(showrole.camp==1)
			{
				hongse.gameObject.SetActive(false);
				lvse.gameObject.SetActive(true);
				hpslider.foregroundWidget = lvse;

			}
			else
			{
				hongse.gameObject.SetActive(true);
				lvse.gameObject.SetActive(false);
				hpslider.foregroundWidget = hongse;
			}
			basenum= showrole.GetBasePop_Life();
			nownum=showrole.GetNowPop_Life();
			updatapos (showrole.GetRolePos ());

			updatahp (nownum);

			showrole.SetHpTip(this);

			gameObject.SetActive(true);
			Mymag.StartShow (this);
		} 
		else 
		{
			Mymag.MissionComplete (this);
		}
	}


	
	public void updatahp(int nowhp)
	{
		nownum = nowhp;
		hpslider.value = 1.0f*nowhp/basenum;
	}
	public void updatapos(Vector3 pos)
	{
		pos.y = pos.y + RoleHigh;
		Vector3 pos_2d = Mymag.GetGm3DPosTo2D (pos);
		gameObject.transform.localPosition = pos_2d;

	}

	//被动更新
	public void updatapos_by()
	{
		if(showrole.IsMoveing()==false)
		{
			Vector3 pos = showrole.GetRolePos ();
			pos.y = pos.y + RoleHigh;
			Vector3 pos_2d = Mymag.GetGm3DPosTo2D (pos);
			gameObject.transform.localPosition = pos_2d;
		}
		
	}

	public void RoleDie()
	{
		isshow = false;
		gameObject.SetActive (false);
		Mymag.MissionComplete (this);

	}

	
	public void Exit()
	{
		isshow = false;
		gameObject.SetActive (false);
		tModleFactory.Ins.TempRecoveryObj (Mymag.tippname,gameObject);
		//GameObject.Destroy (gameObject);
	}
}
