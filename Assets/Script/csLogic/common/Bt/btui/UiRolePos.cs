using UnityEngine;
using System.Collections;

public class UiRolePos : MonoBehaviour {
	#if MinMap
	public UISprite pos_sp;

	bool isshow = false;
	
	//Vector3 objpos;
	
	testdybroleai showrole;

	lgSmallMapMag Mymag;

	Vector3 Inipos = Vector3.zero; 
	public void StartTip(lgSmallMapMag thismag, testdybroleai thisrole)
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
				pos_sp.spriteName = "xingxing22";
				
			}
			else
			{
				pos_sp.spriteName = "xingxing22";
			}

			updatapos (showrole.MymapPoint);

			showrole.SetPosTip(this);
			
			gameObject.SetActive(true);
			Mymag.StartShow (this);
		} 
		else 
		{
			Mymag.MissionComplete (this);
		}
	}
	
	
	

	public void updatapos(tPoint_ rolepos )
	{
		//pos.y = pos.y + RoleHigh;
		//Vector3 pos_2d = Mymag.GetGm3DPosTo2D (pos);
		//gameObject.transform.localPosition = pos_2d;
		Inipos.x = -rolepos.x*4;
		Inipos.y = -rolepos.z*4;
		Inipos.z = 0f;
		gameObject.transform.localPosition = Inipos;
	}
	
	//被动更新
	public void updatapos_by()
	{
		if(showrole.IsMoveing()==false)
		{
			//Vector3 pos = showrole.GetRolePos ();
			tPoint_ rolepos = showrole.MymapPoint;
			//pos.y = pos.y + RoleHigh;
			//Vector3 pos_2d = Mymag.GetGm3DPosTo2D (pos);

			//gameObject.transform.localPosition = pos_2d;
			Inipos.x = -rolepos.x*4;
			Inipos.y = -rolepos.z*4;
			Inipos.z = 0f;
			gameObject.transform.localPosition = Inipos;
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
		//tModleFactory.Ins.TempRecoveryObj (numpname,gameObject);
		//GameObject.Destroy (gameObject);
	}
#endif
}
