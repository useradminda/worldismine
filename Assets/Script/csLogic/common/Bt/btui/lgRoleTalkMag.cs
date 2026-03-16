using UnityEngine;
using System.Collections;
using System.Collections.Generic;


public struct talkinfo_
{
	public int Dbid;
	public int Type; //1 冲锋 2 死亡
	public string saywords;
	public string colour1;
	public string colour2;
}
public struct showTalkMission_
{
	public int tiptype;
	public int id;
	public testdybroleai showrole;
}

public class lgRoleTalkMag 
{

	GameObject uirootobj = null;
	List<UiOneTalk> DieTipList = new List<UiOneTalk> ();
	List<UiOneTalk> ShowTipList = new List<UiOneTalk> ();
	List<UiOneTalk> WaitShowTipList = new List<UiOneTalk> ();


	string tippname="uitip_talk";
	List<showTalkMission_> showmission = new List<showTalkMission_> ();

	int dierandnum = 40;	//角色死亡概率说话
	float starttime = 5f;	//战斗后5秒开始 随机单位 
	float jiangetime =20f;	// 每隔20秒随机一次
	int randrolemin = 1;
	int randrolemax = 5;	//随机角色数
	int rolerandtimemin = 5;	//角色随机过多少秒后提示
	int rolerandtimemax = 20;	

	lgBtUiMag MyBtUiMag;
	bool startAi =false;
	bool startrand =false;
	float usestarttime = 0f;
	float usejiangetime = 0f;

	int talknum =0;
	int dietalknum =0;
	float GameTime =0f;

	List<float> TalkMission = new List<float> ();
	public float xuanzhuan =20f;	//旋转角度
	public Quaternion look1;
	public Quaternion look2;
	float xishu = 1f;
	public void IniSome(GameObject uiroot,lgBtUiMag thismag)
	{
		uirootobj = uiroot;
		MyBtUiMag = thismag;
		startAi =false;

		talknum = lgCfgMag.Ins.GetTalkNum ();
		
		dietalknum =lgCfgMag.Ins.GetDieTalkNum ();
		TalkMission.Clear ();
		look1= Quaternion.Euler (new Vector3(0f, 0f, xuanzhuan));
		look2= Quaternion.Euler (new Vector3(0f, 0f, -xuanzhuan));
		xishu = -uiroot.transform.localPosition.x*2f/Screen.width;
	}

	//
	public void StartGame()
	{
		startAi = true;
		startrand =false;
		usejiangetime = 0f;
		usestarttime = 0f;
	}

	//随机一轮抽奖
	void RandOnce()
	{
		int randmisnum = Random.Range (randrolemin,randrolemax+1);
		for(int i=0;i<randmisnum;i++)
		{
			float delaytime = GameTime+ Random.Range (rolerandtimemin,rolerandtimemax+1);
			TalkMission.Add(delaytime);
		}
		TalkMission.Sort ();
	}

	void RandRoleToTalk()
	{
		int talkid = Random.Range (0,talknum);
		//talkinfo_ talkinfo=lgCfgMag.Ins.GetTalkinfo (1,talkid);
		testdybroleai randrole = lgbtmag.Ins.GetAllRandRole ();
		GetOneTip (1, talkid, randrole);
	}

	public void RoleDieTalk(testdybroleai thisrole)
	{
		int gailv = Random.Range (0,101);
		if(gailv<dierandnum)
		{
			int talkid = Random.Range (0,dietalknum);
			GetOneTip(2,talkid, thisrole);
		}
	}


	//tiptype =1 冲锋提示  2 死亡提示
	public void GetOneTip(int tiptype,int id,testdybroleai showrole)
	{
		if (DieTipList.Count > 0) {
			UiOneTalk newone = DieTipList [0];
			DieTipList.Remove (newone);
			WaitShowTipList.Add(newone);
			DoOneMission(newone,tiptype,id,showrole);
		} else {
			showTalkMission_ onemission;
			onemission.tiptype=tiptype;
			onemission.id=id;
			onemission.showrole=showrole;

			showmission.Add(onemission);
			tModleFactory.Ins.GetOneObj(tippname,GetObjCB,true);
		}
	}
	
	public void GetObjCB(GameObject obj)
	{
		obj.transform.parent = uirootobj.transform;
		obj.transform.localScale = Vector3.one;
		UiOneTalk me = obj.GetComponent<UiOneTalk>() as UiOneTalk;
		
		DoOneMission (me);
		
	}
	public void DoOneMission(UiOneTalk me,int tiptype,int id,testdybroleai showrole)
	{
		WaitShowTipList.Add(me);
		talkinfo_ thisshowinfo = lgCfgMag.Ins.GetTalkinfo(tiptype,id);
		me.StartTip ( this, showrole, thisshowinfo);
	}
	public void DoOneMission(UiOneTalk me)
	{
		if(showmission.Count>0)
		{
			talkinfo_ thisshowinfo = lgCfgMag.Ins.GetTalkinfo(showmission[0].tiptype,showmission[0].id);
			me.StartTip (this,showmission[0].showrole, thisshowinfo);
			showmission.RemoveAt(0);
		}
	}
	public void StartShow(UiOneTalk me)
	{
		WaitShowTipList.Remove (me);
		ShowTipList.Add (me);
	}
	public void MissionComplete(UiOneTalk me)
	{
		ShowTipList.Remove (me);
		DieTipList.Add (me);
	}
	public void updata(float dt)
	{
		if(startAi == true)
		{
			GameTime +=dt;
			if(startrand==false)
			{
				usestarttime += dt;
				if(usestarttime>=starttime)
				{
					startrand=true;
				}
			}
			else
			{
				usejiangetime-=dt;
				if(usejiangetime<=0f)
				{
					usejiangetime = jiangetime;
					//随机一轮说话
					RandOnce();
				}
				//
				for(int i=0;i<TalkMission.Count;)
				{
					if(GameTime>TalkMission[i])
					{
						//随机角色 随机说话
						RandRoleToTalk();

						TalkMission.RemoveAt(i);
					}
					else
					{
						i++;
					}
				}
			}


			for(int i=0;i<ShowTipList.Count;i++)
			{
				ShowTipList[i].updata(dt);
			}
		}
	}
	public void Exit()
	{
		for(int i=0;i<ShowTipList.Count;i++)
		{
			ShowTipList[i].Exit();
			ShowTipList[i].gameObject.transform.parent = null;
			tModleFactory.Ins.TempRecoveryObj (tippname,ShowTipList[i].gameObject);
		}
		for(int i=0;i<DieTipList.Count;i++)
		{
			DieTipList[i].Exit();
			DieTipList[i].gameObject.transform.parent = null;
			tModleFactory.Ins.TempRecoveryObj (tippname,DieTipList[i].gameObject);
		}
		for(int i=0;i<WaitShowTipList.Count;i++)
		{
			WaitShowTipList[i].Exit();
			WaitShowTipList[i].gameObject.transform.parent = null;
			tModleFactory.Ins.TempRecoveryObj (tippname,WaitShowTipList[i].gameObject);
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
}
