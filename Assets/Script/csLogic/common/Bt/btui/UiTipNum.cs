using UnityEngine;
using System.Collections;
using System.Collections.Generic;
public class UiTipNum : MonoBehaviour {

	int nownum = -1;
	int needshownum ;
	Vector3 needshowpos;
	lgUiTipNumMag Mymag;
	bool isshow = false;
	public float showtime = 1f;
	float useshowtime = 1f;
	List<UISprite> hassp = new List<UISprite> ();
	List<int> shownumlist = new List<int> ();
	public string numpname;
	public float xadd;
	Vector3 objpos;
	public float Movestep1time = 0.3f;
	float tempMovestep1time = 0f;
	//public float Movestep1addy = 50f;
	//public float Movestep2addy = 50f;
	public float Movestep1addyspeed = 200f;
	public float Movestep2addyspeed = 50f;
	public UIPanel showpanel;
	public float afrom =0.5f;
	public void StartTip(int num,Vector3 showpos,lgUiTipNumMag mymag,bool hasfuhao)
	{

		if(num<0)
		{
			Debug.LogError("Tip ui error num="+num);
			return;
		}
		tempMovestep1time = 0f;
		needshownum = num;
		needshowpos = showpos;
		objpos.x = needshowpos.x;
		objpos.y = needshowpos.y;
		objpos.z = 0;
		gameObject.transform.localPosition = objpos;
		Mymag = mymag;
		useshowtime = 0f;
		shownumlist.Clear ();
		//设置数字
		int tempnum = needshownum;

		for(;tempnum>10;)
		{
			int num_ = tempnum%10;
			shownumlist.Add(num_);
			tempnum = tempnum/10;
		}
		shownumlist.Add(tempnum);
		if(hasfuhao==true)
		{
			shownumlist.Add(-1);	//添加负号
		}
		if (hassp.Count >= shownumlist.Count) 
		{
			EnoughSp();
		} 
		else 
		{
			for (int i =hassp.Count; i<shownumlist.Count; i++) 
			{
				tModleFactory.Ins.GetOneObj(numpname,GetObj,true);

			}
		}

	}

	public void GetObj(GameObject obj)
	{
		if(isshow == true||obj==null)
		{
			return;
		}
		obj.transform.parent = gameObject.transform;
		obj.transform.transform.localScale = Vector3.one;
		UISprite num =  obj.GetComponent<UISprite>() as UISprite;
		hassp.Add (num);
		if (hassp.Count >= shownumlist.Count) 
		{
			EnoughSp();
		} 
	}


	public void EnoughSp()
	{
		Vector3 pos = Vector3.zero;
		for (int k =0,i=shownumlist.Count-1; i>=0; i--,k++) 
		{
			string spname;
			if(shownumlist[i]==-1)
			{
				spname = "xue_";
			}
			else
			{
				spname = "xue"+shownumlist[i].ToString();
			}
			lgNoDelCsFun.Ins.SetIcon(hassp[k],"BtUi",spname);

			pos.x = xadd*k;
			hassp[k].gameObject.transform.localPosition = pos;
			hassp[k].gameObject.SetActive(true);
			hassp[k].MakePixelPerfect();
		}


		isshow = true;

		SetNumFinish ();
	}



	//显示的数字都创建完成了
	public void SetNumFinish()
	{
		gameObject.SetActive (true);
		isshow = true;
		//通知创建完成
		Mymag.StartShow(this);
	}

	public void updata(float dt)
	{
		if(isshow == true)
		{
			useshowtime+=dt;
			if(useshowtime>=showtime)
			{
				MissionComplete();
			}
			objpos = gameObject.transform.localPosition;
			if(useshowtime<=Movestep1time)
			{
				objpos.y=objpos.y+Movestep1addyspeed*dt;
				showpanel.alpha =afrom+(1.0f- afrom)*(useshowtime/Movestep1time);
				if(showpanel.alpha >1)
				{
					showpanel.alpha =1;
				}
			}
			else
			{
				objpos.y=objpos.y+Movestep2addyspeed*dt;
				showpanel.alpha =1.0f-(useshowtime-Movestep1time)/(showtime-Movestep1time);
				if(showpanel.alpha <0)
				{
					showpanel.alpha =0;
				}
			}

			gameObject.transform.localPosition = objpos;
			

		}
	}


	public void MissionComplete()
	{
		isshow = false;
		for (int i =0; i<hassp.Count; i++) 
		{
			hassp[i].gameObject.SetActive(false);
		}
		gameObject.SetActive (false);
		Mymag.MissionComplete (this);
	}

	public void Exit()
	{
		isshow = false;
		gameObject.SetActive (false);
		tModleFactory.Ins.TempRecoveryObj (numpname,gameObject);
		//GameObject.Destroy (gameObject);
	}
}
