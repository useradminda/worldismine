using UnityEngine;
using System.Collections;
using System.Collections.Generic;
public struct tPointInfo_ {
	//public int x;
	//public int z;
	//public testdybroleai standrole ;
	//public List<testdybroleai> standrolelist = new List<testdybroleai> ();
	public List<testdybroleai> moverolelist ;//= new List<testdybroleai> ();
}
public struct tPoint_ {
	public int x;
	public int z;
}
public class tMapPointInfo  {

	public int i_rolecellbimapcell = 2;//角色单元格比地图单元格  1  ,2  , 4  , 8 , 16... 控制精细度
	public bool b_standmore = true;//一个格子可以被多个角色站立


	//public int  cu_xMax = 54;		//策划设定地图x格子最大数
	//public int cu_zMax = 25;		//策划设定地图z格子最大数
	public float cu_mapcell = 2f;	//策划设定地图格子在unity中单位

	public int  u_xMax = 54;		//地图x格子最大数
	public int u_zMax = 25;		//地图z格子最大数
	public float u_mapcell = 2f;	//地图格子在unity中单位

	public float f_updatemovedis = 0f;//角色移动x/z 多少时更新自己的位置单元格
	// Use this for initialization
	//void Start () {

	//}
	
	// Update is called once per frame
	//void Update () {
	
	//}

	//双方阵营数据

	//阵营1
	public int Head_x_1 = -1;
	public int Rear_x_1 = -1;
	//第一层key 是z 值 第二层 key 是x值
	public Dictionary<int ,Dictionary<int,tPointInfo_>> mapInfolise_1 = new Dictionary<int, Dictionary<int, tPointInfo_>>();


	//阵营2
	public int Head_x_2 = -1;
	public int Rear_x_2 = -1;
	public Dictionary<int ,Dictionary<int,tPointInfo_>> mapInfolise_2 = new Dictionary<int, Dictionary<int, tPointInfo_>>();
	public void IniSome(int mapl,int maph)
	{
		Head_x_1 = 1;
		Rear_x_1 = 1;
		Head_x_2 = mapl*i_rolecellbimapcell;
		Rear_x_2 = -1;// mapl*i_rolecellbimapcell;


		u_xMax = mapl*i_rolecellbimapcell;		
		u_zMax = maph*i_rolecellbimapcell;		
		u_mapcell = cu_mapcell/i_rolecellbimapcell;	
		f_updatemovedis = u_mapcell;

		mapInfolise_1.Clear ();
		mapInfolise_2.Clear ();



	}
    /*
	public void update ()
	{
		
	}

	public bool AskMoveTo()
	{

		return true;
	}
     * */

	//移动占用格子更新
	public bool MoveSetUse(int camp,int movetype,testdybroleai thisrole,List<tPoint_> leavelist,List<tPoint_> addlist)
	{
		/*
		Debug.Log("MoveSetUse thisrole.name="+thisrole.name);
		for(int i=0;addlist!=null&&i<addlist.Count;i++)
		{
			Debug.Log("addlist[] ="+i+"  "+addlist[i].ToString());
		}
		for(int i=0;leavelist!=null&&i<leavelist.Count;i++)
		{
			Debug.Log("leavelist[] ="+i+"  "+leavelist[i].ToString());
		}
		*/
		Dictionary<int,tPointInfo_> thislist = null;
		tPointInfo_ pointinfo ;
		bool haspoint = false;
		//考虑先加 还是先删
		if(camp==1)
		{
			int i=0;
			for(i=0;addlist!=null&&i<addlist.Count;i++)
			{
				mapInfolise_1.TryGetValue(addlist[i].x,out thislist); 
				if(null==thislist)	//没有直接加
				{
					Dictionary<int,tPointInfo_> templist =new Dictionary<int, tPointInfo_>();
					tPointInfo_ temppointinfo = new tPointInfo_();
					temppointinfo.moverolelist = new List<testdybroleai>();
					temppointinfo.moverolelist.Add(thisrole);
					templist.Add(addlist[i].z,temppointinfo);
					mapInfolise_1.Add(addlist[i].x,templist);
				}
				else
				{
				//if( thislist = mapInfolise_1.TryGetValue(leavelist[i].x)==
					haspoint = thislist.TryGetValue(addlist[i].z,out pointinfo);
					if(haspoint==false)
					{
						tPointInfo_ temppointinfo = new tPointInfo_();
						temppointinfo.moverolelist = new List<testdybroleai>();
						temppointinfo.moverolelist.Add(thisrole);
						thislist.Add(addlist[i].z,temppointinfo);

					}
					else
					{
						pointinfo.moverolelist.Add(thisrole);
					}
				}
				if(movetype!=0)	//左右移动
				{
					//检查头尾
					if(addlist[i].x>Head_x_1)
					{
						Head_x_1 = addlist[i].x;
					}
					if(addlist[i].x<Rear_x_1)
					{
						Rear_x_1=addlist[i].x;
					}
				}

			}

			for(i=0;leavelist!=null&&i<leavelist.Count;i++)
			{
				mapInfolise_1.TryGetValue(leavelist[i].x,out thislist); //前面加个 所以肯定有
				//if( thislist = mapInfolise_1.TryGetValue(leavelist[i].x)==
				if(thislist==null)
				{
					Debug.Log("error MoveSetUse 1111");
				}
				thislist.TryGetValue(leavelist[i].z,out pointinfo);
				pointinfo.moverolelist.Remove(thisrole);
				if(pointinfo.moverolelist.Count<=0)
				{
					thislist.Remove(leavelist[i].z);
				}
				if(thislist.Count<=0)
				{
					mapInfolise_1.Remove(leavelist[i].x);
					if(movetype!=0)	//左右移动
					{
						//检查头尾
						if(leavelist[i].x==Head_x_1)
						{
							for(int k = Head_x_1-1;k>=Rear_x_1;k--)
							{
								if(mapInfolise_1.ContainsKey(k)==true)
								{
									Head_x_1 = k;
									break;
								}
							}
						}
						if(leavelist[i].x==Rear_x_1)
						{
							for(int k = Rear_x_1+1;k<=Head_x_1;k++)
							{
								if(mapInfolise_1.ContainsKey(k)==true)
								{
									Rear_x_1 = k;
									break;
								}
							}
						}
					}
				}

			}
		}
		else
		{
			int i=0;
			for(i=0;addlist!=null&&i<addlist.Count;i++)
			{
				mapInfolise_2.TryGetValue(addlist[i].x,out thislist); 
				if(null==thislist)	//没有直接加
				{
					Dictionary<int,tPointInfo_> templist =new Dictionary<int, tPointInfo_>();
					tPointInfo_ temppointinfo = new tPointInfo_();
					temppointinfo.moverolelist = new List<testdybroleai>();
					temppointinfo.moverolelist.Add(thisrole);
					templist.Add(addlist[i].z,temppointinfo);
					mapInfolise_2.Add(addlist[i].x,templist);
				}
				else
				{
					//if( thislist = mapInfolise_1.TryGetValue(leavelist[i].x)==
					haspoint=thislist.TryGetValue(addlist[i].z,out pointinfo);
					if(haspoint==false)
					{
						tPointInfo_ temppointinfo = new tPointInfo_();
						temppointinfo.moverolelist = new List<testdybroleai>();
						temppointinfo.moverolelist.Add(thisrole);
						thislist.Add(addlist[i].z,temppointinfo);
						
					}
					else
					{
						pointinfo.moverolelist.Add(thisrole);
					}
				}
				if(movetype!=0)	//左右移动
				{
					//检查头尾
					if(addlist[i].x<Head_x_2)
					{
						Head_x_2 = addlist[i].x;
					}

					if(addlist[i].x>Rear_x_2)
					{
						Rear_x_2=addlist[i].x;
					}
				}
				
			}
			
			for(i=0;leavelist!=null&&i<leavelist.Count;i++)
			{
				mapInfolise_2.TryGetValue(leavelist[i].x,out thislist); //前面加个 所以肯定有
				//if( thislist = mapInfolise_1.TryGetValue(leavelist[i].x)==
				if(thislist==null)
				{
					Debug.Log("MoveSetUse error");
				}
				thislist.TryGetValue(leavelist[i].z,out pointinfo);
				pointinfo.moverolelist.Remove(thisrole);
				if(pointinfo.moverolelist.Count<=0)
				{
					thislist.Remove(leavelist[i].z);
				}
				if(thislist.Count<=0)
				{
					mapInfolise_2.Remove(leavelist[i].x);
					if(movetype!=0)	//左右移动
					{
						//检查头尾
						if(leavelist[i].x==Head_x_2)
						{
							for(int k = Head_x_2+1;k<=Rear_x_2;k++)
							{
								if(mapInfolise_2.ContainsKey(k)==true)
								{
									Head_x_2 = k;
									break;
								}
							}
						}
						if(leavelist[i].x==Rear_x_2)
						{
							for(int k = Rear_x_2-1;k>=Head_x_2;k--)
							{
								if(mapInfolise_2.ContainsKey(k)==true)
								{
									Rear_x_2 = k;
									break;
								}
							}
						}
					}
				}
				
			}
		}
		return true;

	}
	//private 
	public List<testdybroleai> GetRolesInArea(int camp,int xmax,int xmin,int zmax,int zmin)
	{
		List<testdybroleai> result = new List<testdybroleai> ();
		Dictionary<int,tPointInfo_> temp;
		tPointInfo_ temppointinfo;
		if(camp==1)
		{
			for(int i =xmin;i<xmax;i++ )
			{
				if(mapInfolise_2.TryGetValue(i,out temp)==true)
				{
					for(int k =zmin;k<zmax;k++ )
					{
						if(temp.TryGetValue(k,out temppointinfo)==true)
						{
							for(int a =0;a<temppointinfo.moverolelist.Count;a++)
							{
								if(result.Contains(temppointinfo.moverolelist[a])==false)
								{
									result.Add(temppointinfo.moverolelist[a]);
								}
							}

						}
					}

				}
			}
		}
		else{
			for(int i =xmin;i<xmax;i++ )
			{
				if(mapInfolise_1.TryGetValue(i,out temp)==true)
				{
					for(int k =zmin;k<zmax;k++ )
					{
						if(temp.TryGetValue(k,out temppointinfo)==true)
						{
							for(int a =0;a<temppointinfo.moverolelist.Count;a++)
							{
								if(result.Contains(temppointinfo.moverolelist[a])==false)
								{
									result.Add(temppointinfo.moverolelist[a]);
								}
							}
							
						}
					}
					
				}
			}

		}

		return result;
	}
	//范围内最近
	public testdybroleai GetRoleInAreaNear(testdybroleai thisrole,int xmax,int xmin,int zmax,int zmin,out int disnear)
	{
		List<testdybroleai> result = new List<testdybroleai> ();
		Dictionary<int,tPointInfo_> temp;
		tPointInfo_ temppointinfo;
		testdybroleai getrole=null;
		int d = 1000;
		if(thisrole.camp==1)
		{
			for(int i =xmin;i<xmax;i++ )
			{
				if(mapInfolise_2.TryGetValue(i,out temp)==true)
				{
					for(int k =zmin;k<zmax;k++ )
					{
						if(temp.TryGetValue(k,out temppointinfo)==true)
						{
							for(int a =0;a<temppointinfo.moverolelist.Count;a++)
							{
								if(result.Contains(temppointinfo.moverolelist[a])==false)
								{
									result.Add(temppointinfo.moverolelist[a]);
									int dis = thisrole.GetRoleDis(thisrole,temppointinfo.moverolelist[a]);
									if(dis<d)
									{
										d=dis;
										getrole = temppointinfo.moverolelist[a];
									}
								}
							}
							
						}
					}
					
				}
			}
		}
		else{
			for(int i =xmin;i<xmax;i++ )
			{
				if(mapInfolise_1.TryGetValue(i,out temp)==true)
				{
					for(int k =zmin;k<zmax;k++ )
					{
						if(temp.TryGetValue(k,out temppointinfo)==true)
						{
							for(int a =0;a<temppointinfo.moverolelist.Count;a++)
							{
								if(result.Contains(temppointinfo.moverolelist[a])==false)
								{
									result.Add(temppointinfo.moverolelist[a]);
									int dis = thisrole.GetRoleDis(thisrole,temppointinfo.moverolelist[a]);
									if(dis<d)
									{
										d=dis;
										getrole = temppointinfo.moverolelist[a];
									}
								}
							}
							
						}
					}
					
				}
			}
			
		}
		result.Clear ();
		disnear = d;
		return getrole;
		
	}
	int Listfind(List<roletype_> thislist,roletype_ v1)
	{
		int result = -1;
		for(int i=0;i<thislist.Count;i++)
		{
			if(thislist[i]==v1)
			{
				result = i;
				break;
			}
		}
		return result;
	}
	//0 一样  1大于  -1 小于
	public int GetPriorityBig(testdybroleai thisrole1,testdybroleai thisrole2,List<roletype_> thislist)
	{
		if(thislist==null){

			return 0;
		}
		int d1 = 0;
		int d2 = 0;
		d1 = Listfind(thislist,thisrole1.roletype);
		d2 = Listfind(thislist,thisrole2.roletype);
		if (d1 < 0) {
			if(d2<0)
			{
				return 0;
			}
			else
			{
				return -1;
			}
		} else {
			if(d2<0)
			{
				return 1;
			}
			else
			{
				if(d1==d2)
				{
					return 0;
				}
				if(d1<d2)
				{
					return 1;
				}
				return -1;
			}
		}
		return 0;
	}

	//范围内最近 或者优先级最高
	public testdybroleai GetRoleInAreaNearAndPriority(testdybroleai thisrole,int xmax,int xmin,int zmax,int zmin,out int disnear)
	{
		List<testdybroleai> result = new List<testdybroleai> ();
		Dictionary<int,tPointInfo_> temp;
		tPointInfo_ temppointinfo;
		testdybroleai getrole=null;
		int d = 1000;
		if(thisrole.camp==1)
		{
			for(int i =xmin;i<xmax;i++ )
			{
				if(mapInfolise_2.TryGetValue(i,out temp)==true)
				{
					for(int k =zmin;k<zmax;k++ )
					{
						if(temp.TryGetValue(k,out temppointinfo)==true)
						{
							for(int a =0;a<temppointinfo.moverolelist.Count;a++)
							{
								if(result.Contains(temppointinfo.moverolelist[a])==false)
								{
									result.Add(temppointinfo.moverolelist[a]);
									if(getrole==null)
									{
										int dis = thisrole.GetRoleDis(thisrole,temppointinfo.moverolelist[a]);
										d=dis;
										getrole = temppointinfo.moverolelist[a];
									}
									else
									{
										int bigid = GetPriorityBig(getrole,temppointinfo.moverolelist[a],thisrole.MyPriorityattList);
										if(bigid==0)
										{
											int dis = thisrole.GetRoleDis(thisrole,temppointinfo.moverolelist[a]);
											if(dis<d)
											{
												d=dis;
												getrole = temppointinfo.moverolelist[a];
											}
										}
										if(bigid==-1)
										{
											int dis = thisrole.GetRoleDis(thisrole,temppointinfo.moverolelist[a]);
											d=dis;
											getrole = temppointinfo.moverolelist[a];
										}
									}

								}
							}
							
						}
					}
					
				}
			}
		}
		else{
			for(int i =xmin;i<xmax;i++ )
			{
				if(mapInfolise_1.TryGetValue(i,out temp)==true)
				{
					for(int k =zmin;k<zmax;k++ )
					{
						if(temp.TryGetValue(k,out temppointinfo)==true)
						{
							for(int a =0;a<temppointinfo.moverolelist.Count;a++)
							{
								if(result.Contains(temppointinfo.moverolelist[a])==false)
								{
									result.Add(temppointinfo.moverolelist[a]);
									if(getrole==null)
									{
										int dis = thisrole.GetRoleDis(thisrole,temppointinfo.moverolelist[a]);
										d=dis;
										getrole = temppointinfo.moverolelist[a];
									}
									else
									{
										int bigid = GetPriorityBig(getrole,temppointinfo.moverolelist[a],thisrole.MyPriorityattList);
										if(bigid==0)
										{
											int dis = thisrole.GetRoleDis(thisrole,temppointinfo.moverolelist[a]);
											if(dis<d)
											{
												d=dis;
												getrole = temppointinfo.moverolelist[a];
											}
										}
										if(bigid==-1)
										{
											int dis = thisrole.GetRoleDis(thisrole,temppointinfo.moverolelist[a]);
											d=dis;
											getrole = temppointinfo.moverolelist[a];
										}
									}
								}
							}

						}
					}
					
				}
			}
			
		}
		result.Clear ();
		disnear = d;
		return getrole;
		
	}

	public bool Exit()
	{
		mapInfolise_1.Clear ();
		mapInfolise_2.Clear ();
		return true;
	}

	//
	public void GetMapCell(out tPoint_ mapcell)
	{ 
		mapcell.x=u_xMax;
		mapcell.z=u_zMax;
	}
}
