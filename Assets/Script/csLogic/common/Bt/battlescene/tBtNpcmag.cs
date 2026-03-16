using UnityEngine;
using System.Collections;
using System.Collections.Generic;
public class tBtNpcmag  {

	private tMapPointInfo MyMapPointMag;
	

	public Dictionary<roletype_ ,int> cmap1NowInBsRoleNum = new Dictionary<roletype_ ,int>();//当前场景中生成出来的 角色 种类 和数量
	public Dictionary<roletype_ ,int> cmap2NowInBsRoleNum = new Dictionary<roletype_ ,int>();//当前场景中生成出来的 角色 种类 和数量


	public List<testdybroleai> cmap1Rolelist = new List<testdybroleai>();  //阵营1角色列表
	public List<testdybroleai> cmap2Rolelist = new List<testdybroleai>();  //阵营2角色列表

	public List<testdybroleai> cmap1DieRolelist = new List<testdybroleai>();  //阵营1角色列表
	public List<testdybroleai> cmap2DieRolelist = new List<testdybroleai>();  //阵营2角色列表
	public Dictionary<string,testdybroleai> rolelist = new Dictionary<string, testdybroleai> (); 

	public GameObject testrolemodle;

	public List<testdybroleai> cmap1DieRoleWaitlist = new List<testdybroleai>();  //阵营1角色死亡播放动画等待列表
	public List<testdybroleai> cmap2DieRoleWaitlist = new List<testdybroleai>();  //阵营2角色死亡播放动画等待列表

	//public  //地图信息
	//public testdyb testdybcs ;

    public btbuffmag MybtBuffMag;
	public bttype_ MyBtType;
	public void IniSome(int mapl,int maph)
	{
		MyBtType=lgbtmag.Ins.GetMapType ();
		pausegame = true;
		if(MyMapPointMag==null)
		{
			MyMapPointMag = new tMapPointInfo ();
		}
		MyMapPointMag.IniSome (mapl,maph);
        if (MybtBuffMag==null)
        {
            MybtBuffMag = new btbuffmag();
        }
        MybtBuffMag.IniSome();
	}
	
	public void StartGame()
	{
		SetPause (false);

	}
	public bool pausegame = false;

	public void SetPause(bool ispause)
	{
		pausegame = ispause;

	}
	public void SetPauseOnce()
	{
		pausegame = !pausegame;
		
	}
	public void update (float dt) {
        //Debug.Log("~~~~~~~~~~~~~~~" + pausegame);
		if(pausegame==false)
		{
            MybtBuffMag.updata(dt);
			for(int i = 0; i < cmap1Rolelist.Count; i++)
			{
				cmap1Rolelist[i].update(dt);
			}
			for(int i = 0; i < cmap2Rolelist.Count; i++)
			{
				
				cmap2Rolelist[i].update(dt);
			}
			for(int i = 0; i < cmap1DieRoleWaitlist.Count; i++)
			{
				cmap1DieRoleWaitlist[i].update(dt);
			}
			for(int i = 0; i < cmap2DieRoleWaitlist.Count; i++)
			{
				cmap2DieRoleWaitlist[i].update(dt);
			}
			tModleFactory.Ins.MyammoFactory.update(dt);
			tModleFactory.Ins.MyTxFactory.update(dt);
		}
	}
	public testdybroleai CreateRole(IniRoleP_ inip)//,int num,int Createtype)
	{
		return CreateRole (inip, 0);
	}
    //Createtype =1 随机左边产生  0 按给的点创建  2 按方阵
	public testdybroleai CreateRole(IniRoleP_ inip,int callui)//int num,int Createtype,int callui)
	{
		//for(int i=0;i<num;i++)
		//{

			testdybroleai thisrole = GetOneRoleCS(inip.camp);
			thisrole.CreateFinishCallUI(callui);

			thisrole.Pcreate(inip, MyMapPointMag, this);
			/*
            if (Createtype==1)
            {
				IniRoleP_ temp = inip;
                if(inip.camp==1)
				{
					temp.MyInimapPoint.x =lgbtmag.Ins.camp1createposx;
					temp.MyInimapPoint.z =	Random.Range(lgbtmag.Ins.camp1createposzmin,lgbtmag.Ins.camp1createposzmax);
				}
				else
				{
					temp.MyInimapPoint.x = lgbtmag.Ins.camp2createposx;
					temp.MyInimapPoint.z =	Random.Range(lgbtmag.Ins.camp2createposzmin,lgbtmag.Ins.camp2createposzmax);
				}
				thisrole.Pcreate(temp, MyMapPointMag, this);
            }
			else  if (Createtype==0)
			{
				thisrole.Pcreate(inip, MyMapPointMag, this);
			}
			else  if (Createtype==2)
			{
				thisrole.Pcreate(inip, MyMapPointMag, this);
			}
			*/
            //thisrole.SetUUID(tModleFactory.Ins.GetBtUuid().ToString());

		//}
		return thisrole;
	}

	public testdybroleai GetOneRoleCS(int campid)
	{
		testdybroleai result = null;
		// 不考虑从死亡里面的拿 防止复活等
		/*
		if (campid == 1  ) {
			if(cmap1DieRolelist.Count > 0)
			{
				result = cmap1DieRolelist [0];
				cmap1DieRolelist.RemoveAt (0);
				return result;
			}
		} else {
			if(cmap2DieRolelist.Count > 0)
			{
				result = cmap2DieRolelist [0];
				cmap2DieRolelist.RemoveAt (0);
				return result;
			}	
	
		}
		*/
		result = new testdybroleai();
		return result;
	}


	public void CreateFinish(testdybroleai thisrole)
	{
		//如果游戏已经结束 进入结算时处理
		if (false) {
			thisrole.Exit ();
			return;
		}
		//角色创建完成 则添加到地图格子 
		List<tPoint_> addlist = thisrole.GetOncemapPos ();
		MyMapPointMag.MoveSetUse (thisrole.camp, 1, thisrole, null, addlist);
		if(thisrole.camp==1)
		{
			//角色种类计数
			if (cmap1NowInBsRoleNum.ContainsKey (thisrole.roletype) == true)
			{
				cmap1NowInBsRoleNum[thisrole.roletype]=cmap1NowInBsRoleNum[thisrole.roletype]+1;
			} 
			else 
			{
				cmap1NowInBsRoleNum.Add(thisrole.roletype,1);
			}
			cmap1Rolelist.Add(thisrole);
		}
		else{
			//角色种类计数
			if (cmap2NowInBsRoleNum.ContainsKey (thisrole.roletype) == true)
			{
				cmap2NowInBsRoleNum[thisrole.roletype]=cmap2NowInBsRoleNum[thisrole.roletype]+1;
			} 
			else 
			{
				cmap2NowInBsRoleNum.Add(thisrole.roletype,1);
			}
			cmap2Rolelist.Add(thisrole);
		}
		if(MyBtType==bttype_.fuben)
		{
			rolelist.Add (thisrole.MyUUID,thisrole);
		}
		else if(MyBtType==bttype_.pvp||MyBtType==bttype_.bosspvp)
		{
			rolelist.Add (thisrole.MyPvpUUID,thisrole);
		}
	}

	//pvp 用的
	public testdybroleai GetThisRoleByUUid(string uuid)
	{
		testdybroleai result;
		if(rolelist.TryGetValue(uuid,out result)==true)
		{
			return result;
		}
		return null;
	}

	public void RecoveryRole(testdybroleai thisrole)
	{
		if(thisrole.camp==1)
		{

			cmap1DieRoleWaitlist.Remove(thisrole);
			cmap1DieRolelist.Add(thisrole);
			
			
			
		}
		else{

			cmap2DieRoleWaitlist.Remove(thisrole);
			cmap2DieRolelist.Add(thisrole);
			
		}
	}



	public void RoleDie(testdybroleai thisrole)
	{
		if(thisrole.camp==1)
		{
			//角色种类计数
			if (cmap1NowInBsRoleNum.ContainsKey (thisrole.roletype) == true)
			{
				cmap1NowInBsRoleNum[thisrole.roletype]=cmap1NowInBsRoleNum[thisrole.roletype]-1;
			} 
			cmap1Rolelist.Remove(thisrole);
			//cmap1DieRolelist.Add(thisrole);
			cmap1DieRoleWaitlist.Add(thisrole);


		}
		else{
			//角色种类计数
			if (cmap2NowInBsRoleNum.ContainsKey (thisrole.roletype) == true)
			{
				cmap2NowInBsRoleNum[thisrole.roletype]=cmap2NowInBsRoleNum[thisrole.roletype]-1;
			} 
			cmap2Rolelist.Remove(thisrole);
			//cmap2DieRolelist.Add(thisrole);
			cmap2DieRoleWaitlist.Add(thisrole);
		}
		//删除角色在场景中占用格子
		List<tPoint_> addlist = thisrole.GetOncemapPos ();
		//Debug.Log ("RoleDie  ~~~ thisrole.Myobjname="+thisrole.name);
		MyMapPointMag.MoveSetUse (thisrole.camp, 1, thisrole, addlist, null);

		if( thisrole.roletype== roletype_.typechengbao)
		{
			if(thisrole.camp==1)
			{
				//通知失败
				lgbtmag.Ins.Camp1ChengbaoDie();
			}
			else
			{
				//通知胜利
				lgbtmag.Ins.Camp2ChengbaoDie();
			}
		}
		if(MyBtType==bttype_.bosspvp||MyBtType==bttype_.pvp_jinjichang)
		{
			if(cmap1Rolelist.Count<=0)
			{
				lgbtmag.Ins.BossPvpEnd(2);
			}
			else if(cmap2Rolelist.Count<=0)
			{
				lgbtmag.Ins.BossPvpEnd(1);
			}
		}

		if(thisrole.roletype!= roletype_.typechengbao)
		{
			lgbtmag.Ins.Call_UI_RoleDieTalk (thisrole);
		}
	}
	public void Exit()
	{
		//回收角色 
		for(int i = 0; i < cmap1Rolelist.Count; i++)
		{
			cmap1Rolelist[i].Exit();
		}
		for(int i = 0; i < cmap2Rolelist.Count; i++)
		{
			cmap2Rolelist[i].Exit();
		}
		for(int i = 0; i < cmap1DieRolelist.Count; i++)
		{
			cmap1DieRolelist[i].Exit();
		}
		for(int i = 0; i < cmap2DieRolelist.Count; i++)
		{
			cmap2DieRolelist[i].Exit();
		}

		for(int i = 0; i < cmap1DieRoleWaitlist.Count; i++)
		{
			cmap1DieRoleWaitlist[i].Exit();
		}
		for(int i = 0; i < cmap2DieRoleWaitlist.Count; i++)
		{
			cmap2DieRoleWaitlist[i].Exit();
		}
		cmap1DieRoleWaitlist.Clear ();
		cmap2DieRoleWaitlist.Clear ();
		cmap1Rolelist.Clear ();
		cmap2Rolelist.Clear ();
		cmap1DieRolelist.Clear ();
		cmap2DieRolelist.Clear ();
		rolelist.Clear ();
		
		//清理地图信息
		if(MyMapPointMag!=null)
		{
			MyMapPointMag.Exit();
		}
		//MyMapPointMag = null;
		tModleFactory.Ins.MyammoFactory.ClearObj();
		tModleFactory.Ins.MyTxFactory.ClearObj ();

	}

    public buffbase CreateOnebuff()
    {
        return MybtBuffMag.CreateOnebuff();
    }
	public testdybroleai GetAllRandRole()
	{
		int id = Random.Range (0, cmap1Rolelist.Count+cmap2Rolelist.Count);
		if (id <cmap1Rolelist.Count) {
			return cmap1Rolelist[id];
		} else {
			return cmap2Rolelist[id-cmap1Rolelist.Count];
		}
		return null;
	}

	public void GetMapCell(out tPoint_ mapcell)
	{
		MyMapPointMag.GetMapCell (out mapcell);
	}
}
