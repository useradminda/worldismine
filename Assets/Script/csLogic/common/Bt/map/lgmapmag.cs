using UnityEngine;
using System.Collections;
using System.Collections.Generic;
//地图配置解析

public struct CreateWaveInfo_
{
	public int Waveid;
	public int WaveCreateTime;	//创建时间
	public int[] Dbid;			//4种兵id  英雄  小兵1 小兵2 小兵3
	public int[] Num;			//4种兵数量 英雄  小兵1 小兵2 小兵3	
	public int[] lvl;			//4种兵等级  英雄  小兵1 小兵2 小兵3
	public int[] qulitylvl;			//4种兵品阶 英雄  小兵1 小兵2 小兵3
}
public struct mapInfo_
{
	public int mapid;
	public string BtSceneName;		//使用场景名字
	public int Length; //长  策划格子数
	public int Wide;	//宽  策划格子数

	public int Camp1CreateX;  //阵营1 生成位置 X 格子
	public int Camp2CreateX;  //阵营2 生成位置 X 格子

	//还要加城堡信息
	public int Camp1ChengbaoDbid;	//阵营1 城堡
	public int Camp1ChengbaoPosX;	//阵营1 城堡位置格子
	public int Camp1ChengbaoPosZ;	//阵营1 城堡位置格子
	public int Camp1ChengbaoHp;		//阵营1 城堡血量

	public int Camp2ChengbaoDbid;	//阵营2 城堡
	public int Camp2ChengbaoPosX;	//阵营2 城堡位置格子
	public int Camp2ChengbaoPosZ;	//阵营2 城堡位置格子
	public int Camp2ChengbaoHp;		//阵营2 城堡血量
	//波怪物信息
	public List<CreateWaveInfo_> Wave_Info;	
	public List<pvpzhanzhenginfo> BossPvp_Info;	
	public int TipOpenRoleDbid;
	public float HpAdd;		//副本血量加成
	public float AttAdd;	//副本攻击加成
}

public class lgmapmag  {



}
