using UnityEngine;
using System.Collections;
using System.Collections.Generic;
//using MiniJSON;
using LitJson;
//测试数据
public class testdata  {

	

    //双方对战 测试数据 


    //模型使用数据  角色 弹药等


    Roledata_ mos1;
    Roledata_ mos2;
    Roledata_ mos3;
    Roledata_ mos4;
	Roledata_ mos5;
	Roledata_ mos6;
    skilldata_ skill1;
    skilldata_ skill2;
    skilldata_ skill3;
    skilldata_ skill4;
    skilldata_ skill5;

    ammodata_ ammo1;
    ammodata_ ammo2;

    buffdata_ buff1;
    buffdata_ buff2;
    buffdata_ buff3;
    buffdata_ buff4;
    buffdata_ buff5;

	TxData_ tx1;
	TxData_ tx2;
	TxData_ tx3;
	mapInfo_ map1;


	List<pvproleinfo_> tempcamp1roles;
	List<pvproleinfo_> tempcamp2roles;

	//Dictionary<roletype_,float> renkouzhanyongbiao =  new Dictionary<roletype_, float>();
    public void IniSome()
    {
		/*
        mos1.DBid=1001;
        mos1.name="锤1";
		mos1.prefabname="chuibing_01";
		mos1.skillNormalDBid = 3001;         //普攻技能
        mos1.skillDBid=0;               //特殊技能
       // mos1.hp=200;                      //血量
       // mos1.att=20;                     //攻击力
       // mos1.normalattspeed=10;          //攻击速度
       // mos1.movespeed=6;             //移动速度
        mos1.attrange=2;	//角色攻击距离 策划用 配置
        mos1.alertrange=4; 	//角色警戒距离 策划用 配置
        mos1.roletype = roletype_.typechui;	//角色类型  根据这个判定攻击优先级
		//mos1.nowsitzuoqipname="0";

        mos2.DBid = 1002;
        mos2.name = "弓1";
        mos2.prefabname = "gongbing";
        mos2.skillNormalDBid = 3002;         //普攻技能
        mos2.skillDBid = 0;               //特殊技能
       // mos2.hp = 100;                      //血量
        //mos2.att = 40;                     //攻击力
       // mos2.normalattspeed = 40;          //攻击速度
       // mos2.movespeed = 6;             //移动速度
        mos2.attrange = 5;	//角色攻击距离 策划用 配置
        mos2.alertrange = 7; 	//角色警戒距离 策划用 配置
        mos2.roletype = roletype_.typegong;	//角色类型  根据这个判定攻击优先级
		//mos2.nowsitzuoqipname="0";

        mos3.DBid = 1003;
        mos3.name = "英雄";
		mos3.prefabname = "zhangfei_01";
		mos3.skillNormalDBid = 3003;         //普攻技能
        mos3.skillDBid = 3100;               //特殊技能
//mos3.hp = 1500;                      //血量
       /// mos3.att = 50;                     //攻击力
       // mos3.normalattspeed = 15;          //攻击速度
        //mos3.movespeed = 6;             //移动速度
        mos3.attrange = 3;	//角色攻击距离 策划用 配置
        mos3.alertrange = 5; 	//角色警戒距离 策划用 配置
        mos3.roletype = roletype_.typeyinxiong;	//角色类型  根据这个判定攻击优先级
		//mos3.nowsitzuoqipname="ma_01";

        mos4.DBid = 1004;
        mos4.name = "投石车";
        mos4.prefabname = "toushiche";
        mos4.skillNormalDBid = 3004;         //普攻技能
        mos4.skillDBid = 0;               //特殊技能
        //mos4.hp = 100;                      //血量
       // mos4.att = 80;                     //攻击力
       // mos4.normalattspeed = 3;          //攻击速度
        //mos4.movespeed = 3;             //移动速度
        mos4.attrange = 8;	//角色攻击距离 策划用 配置
        mos4.alertrange = 10; 	//角色警戒距离 策划用 配置
        mos4.roletype = roletype_.typetoushiche;	//角色类型  根据这个判定攻击优先级
		//mos4.nowsitzuoqipname="0";


		mos5.DBid = 1005;
		mos5.name = "城堡1";
		mos5.prefabname = "chengbao";
		mos5.skillNormalDBid = 0;         //普攻技能
		mos5.skillDBid = 0;               //特殊技能
		//mos5.hp = 3000;                      //血量
		//mos5.att = 0;                     //攻击力
		//mos5.normalattspeed = 0;          //攻击速度
		//mos5.movespeed = 0;             //移动速度
		mos5.attrange = 0;	//角色攻击距离 策划用 配置
		mos5.alertrange = 0; 	//角色警戒距离 策划用 配置
		mos5.roletype = roletype_.typechengbao;	//角色类型  根据这个判定攻击优先级
		//mos5.nowsitzuoqipname="0";

		mos6.DBid = 1006;
		mos6.name = "城堡2";
		mos6.prefabname = "chengbao";
		mos6.skillNormalDBid = 0;         //普攻技能
		mos6.skillDBid = 0;               //特殊技能
		//mos6.hp = 3000;                      //血量
		//mos6.att = 0;                     //攻击力
		//mos6.normalattspeed = 0;          //攻击速度
		//mos6.movespeed = 0;             //移动速度
		mos6.attrange = 0;	//角色攻击距离 策划用 配置
		mos6.alertrange = 0; 	//角色警戒距离 策划用 配置
		mos6.roletype = roletype_.typechengbao;	//角色类型  根据这个判定攻击优先级
		//mos6.nowsitzuoqipname="0";

        lgCfgMag.Ins.Set_RoleData(mos1.DBid, mos1);
        lgCfgMag.Ins.Set_RoleData(mos2.DBid, mos2);
        lgCfgMag.Ins.Set_RoleData(mos3.DBid, mos3);
        lgCfgMag.Ins.Set_RoleData(mos4.DBid, mos4);
		lgCfgMag.Ins.Set_RoleData(mos5.DBid, mos5);
		lgCfgMag.Ins.Set_RoleData(mos6.DBid, mos6);
        
        skill1.DBid = 3001;         //锤兵普攻
        skill1.SkillCD=2f;
        skill1.SkillTime=1f;
        skill1.Baofa1Time=0.5f;
        skill1.Baofa2Time =0f;
        skill1.NeedPlayerChoosePos =false;
	    skill1.skillCsName  ="tnormalskill";
        skill1.GeXingP ="";

	    skill1.Baofa1Emo ="";
        skill1.Baofa2Emo ="";

        skill1.Baofa1Buff ="4001";
        skill1.Baofa2Buff ="";

        
		skill1.StartTx = 0;
		skill1.GexinTx = 0;


        skill2.DBid = 3002;     //弓兵普攻
        skill2.SkillCD = 2f;
        skill2.SkillTime = 1f;
        skill2.Baofa1Time = 0.5f;
        skill2.Baofa2Time = 0f;
        skill2.NeedPlayerChoosePos = false;
        skill2.skillCsName = "farNormalSkill";
        skill2.GeXingP = "";

        skill2.Baofa1Emo = "10001,1";
        skill2.Baofa2Emo = "";

        skill2.Baofa1Buff = "4002";
        skill2.Baofa2Buff = "";

        
		skill2.StartTx = 0;
		skill2.GexinTx = 0;

        skill3.DBid = 3003;      //英雄普攻
        skill3.SkillCD = 2f;
        skill3.SkillTime = 1f;
        skill3.Baofa1Time = 0.5f;
        skill3.Baofa2Time = 0f;
        skill3.NeedPlayerChoosePos = false;
        skill3.skillCsName = "tnormalskill";
        skill3.GeXingP = "";

        skill3.Baofa1Emo = "";
        skill3.Baofa2Emo = "";

        skill3.Baofa1Buff = "4003";
        skill3.Baofa2Buff = "";

       
		skill3.StartTx = 30001;
		skill3.GexinTx = 0;

        skill4.DBid = 3004;     //投石车普攻
        skill4.SkillCD = 5f;
        skill4.SkillTime = 1f;
        skill4.Baofa1Time = 0.5f;
        skill4.Baofa2Time = 0f;
        skill4.NeedPlayerChoosePos = false;
        skill4.skillCsName = "farBaozhaSkill";
        skill4.GeXingP = "4,4";

        skill4.Baofa1Emo = "10002,1";
        skill4.Baofa2Emo = "";

        skill4.Baofa1Buff = "4004";
        skill4.Baofa2Buff = "";

        
		skill4.StartTx = 0;
		skill4.GexinTx = 30002;

        skill5.DBid = 3100;  //英雄技能
        skill5.SkillCD = 5f;
        skill5.SkillTime = 1f;
        skill5.Baofa1Time = 0f;
        skill5.Baofa2Time = 0f;
        skill5.NeedPlayerChoosePos = false;
        skill5.skillCsName = "heroskill1";
        skill5.GeXingP = "6,6";

        skill5.Baofa1Emo = "";
        skill5.Baofa2Emo = "";

        skill5.Baofa1Buff = "4005";
        skill5.Baofa2Buff = "";

        
		skill5.StartTx = 0;
		skill5.GexinTx = 30003;

        lgCfgMag.Ins.Set_SkillData(skill1.DBid, skill1);
        lgCfgMag.Ins.Set_SkillData(skill2.DBid, skill2);
        lgCfgMag.Ins.Set_SkillData(skill3.DBid, skill3);
        lgCfgMag.Ins.Set_SkillData(skill4.DBid, skill4);
        lgCfgMag.Ins.Set_SkillData(skill5.DBid, skill5);


       
        //弓兵普攻弹药
        ammo1.ammoCsName = "ammo1";
        ammo1.DBid=10001;
		ammo1.pname = "Arrow";
		ammo1.gexingp = "10,0";


        //投石车普攻弹药
        ammo2.ammoCsName = "ammo1";
        ammo2.DBid = 10002;
		ammo2.pname = "shell";
		ammo2.gexingp = "10,1";

        lgCfgMag.Ins.Set_AmmoData(ammo1.DBid, ammo1);
		lgCfgMag.Ins.Set_AmmoData(ammo2.DBid, ammo2);

       
        buff1.DBid = 4001;
        buff1.type = bufftype_.bfDamage;
        buff1.useDam = 10;

        buff2.DBid = 4002;
        buff2.type = bufftype_.bfDamage;
        buff2.useDam = 50;

        buff3.DBid = 4003;
        buff3.type = bufftype_.bfDamage;
        buff3.useDam = 100;


        buff4.DBid = 4004;
        buff4.type = bufftype_.bfDamage;
        buff4.useDam = 300;

        buff5.DBid = 4005;
        buff5.type = bufftype_.bfDamage;
        buff5.useDam = 1500;

        lgCfgMag.Ins.Set_BuffData(buff1.DBid, buff1);
        lgCfgMag.Ins.Set_BuffData(buff2.DBid, buff2);
        lgCfgMag.Ins.Set_BuffData(buff3.DBid, buff3);
        lgCfgMag.Ins.Set_BuffData(buff4.DBid, buff4);
        lgCfgMag.Ins.Set_BuffData(buff5.DBid, buff5);


		tx1.DBid=30001;
		tx1.lifetime = 1f;
		tx1.type = 0;
		tx1.pname = "FX_hudun";
		tx1.mounttype = 1;
		tx1.mountid = 0;

		tx2.DBid=30002;
		tx2.lifetime = 2f;
		tx2.type = 1;
		tx2.pname = "FX_tiangangquan";
		tx2.mounttype = -1;
		tx2.mountid = -1;


		tx3.DBid=30003;
		tx3.lifetime = 2f;
		tx3.type = 1;			//1 场景特效  0角色身上
		tx3.pname = "FX_shuangren";
		tx3.mounttype = -1;
		tx3.mountid = -1;


		lgCfgMag.Ins.Set_TxData(tx1.DBid, tx1);
		lgCfgMag.Ins.Set_TxData(tx2.DBid, tx2);
		lgCfgMag.Ins.Set_TxData(tx3.DBid, tx3);
*/
		lgCfgMag.Ins.Set_renkouzhanyong (roletype_.typedun, 5); //盾兵
		lgCfgMag.Ins.Set_renkouzhanyong (roletype_.typechui, 10); //锤兵
		lgCfgMag.Ins.Set_renkouzhanyong (roletype_.typetengjia, 10); //藤甲兵
		lgCfgMag.Ins.Set_renkouzhanyong (roletype_.typexueren, 20); //雪人
		lgCfgMag.Ins.Set_renkouzhanyong (roletype_.typelianche, 20); //碾车
		lgCfgMag.Ins.Set_renkouzhanyong (roletype_.typegong, 5); //弓兵
		lgCfgMag.Ins.Set_renkouzhanyong (roletype_.typepao, 10); //炮兵
		lgCfgMag.Ins.Set_renkouzhanyong (roletype_.typelu, 10); //弩兵
		lgCfgMag.Ins.Set_renkouzhanyong (roletype_.typeluche, 20); //弩车
		lgCfgMag.Ins.Set_renkouzhanyong (roletype_.typetoushiche, 20); //投石车
		lgCfgMag.Ins.Set_renkouzhanyong (roletype_.typeqiangchui, 5); //锤兵
		lgCfgMag.Ins.Set_renkouzhanyong (roletype_.typejiugui, 10); //酒鬼
		lgCfgMag.Ins.Set_renkouzhanyong (roletype_.typeqiang, 10); //枪兵
		lgCfgMag.Ins.Set_renkouzhanyong (roletype_.typeqi, 20); //骑兵
		
		lgCfgMag.Ins.Set_renkouzhanyong (roletype_.typeyeren, 20); //野人
		lgCfgMag.Ins.Set_renkouzhanyong (roletype_.typeshengshou, 0); //神兽
		lgCfgMag.Ins.Set_renkouzhanyong (roletype_.typeyinxiong, 10); //英雄
		lgCfgMag.Ins.Set_renkouzhanyong (roletype_.typechengbao, 0); //城堡

		 
		/*
		map1.mapid=1;
		map1.BtSceneName="CDCJ_01";		//使用场景名字
		map1.Length=54; //长  策划格子数
		map1.Wide=25;	//宽  策划格子数
			
		map1.Camp1CreateX=1;  //阵营1 生成位置 X 格子
		map1.Camp2CreateX=51;  //阵营2 生成位置 X 格子

		map1.Camp1ChengbaoDbid=101;	//阵营1 城堡
		map1.Camp1ChengbaoPosX=1;	//阵营1 城堡位置格子
		map1.Camp1ChengbaoPosZ=1;	//阵营1 城堡位置格子
		
		
		map1.Camp2ChengbaoDbid=201;	//阵营2 城堡
		map1.Camp2ChengbaoPosX=53;	//阵营1 城堡位置格子
		map1.Camp2ChengbaoPosZ=1;	//阵营1 城堡位置格子

		//波怪物信息
		map1.Wave_Info = new List<CreateWaveInfo_> ();
		//IList <CreateWaveInfo_>  tedddl11 = new List <CreateWaveInfo_>();
		for(int i=0;i<5;i++)
		{
			CreateWaveInfo_ temp = new CreateWaveInfo_();

			temp.Waveid=i;
			temp.WaveCreateTime=i*10;	//创建时间
			temp.Dbid =new int[4];
			temp.Num =new int[4];
			temp.lvl = new int[4];
			temp.qulitylvl = new int[4];
			for(int k=0;k<4;k++)
			{
				temp.Dbid[k] = 50000+Random.Range(1,5)*10+1;
				temp.Num[k] = Random.Range(3,7);
				//temp.Dbid[k] = 1003;
				//temp.Num[k] =1;
				temp.lvl[k] = 1;
				temp.qulitylvl[k] = 0;
			}


			map1.Wave_Info.Add(	temp);
			//tedddl11.Add(temp);
		 }
*/

		//string strdddd = JsonMapper.ToJson (map1.Wave_Info);
		// lgCfgMag.Ins.Set_MapInfo (map1.mapid,map1);

		//List<CreateWaveInfo_> Wave_Info22 = JsonMapper.ToObject<List<CreateWaveInfo_>>(strdddd);	
		/*
		tempcamp1roles = new List<pvproleinfo_> ();
		{	
			//tempcamp1roles.Add(createpvpinfo(50031, 20, 5));
			//tempcamp1roles.Add(createpvpinfo(50131, 20, 10));

			tempcamp1roles.Add (createpvpinfo (50131, 8, 3));
			tempcamp1roles.Add (createpvpinfo (50131, 8, 5));
			tempcamp1roles.Add (createpvpinfo (10011, 12, 3));
			
			tempcamp1roles.Add (createpvpinfo (50131, 8, 10));
			tempcamp1roles.Add (createpvpinfo (50131, 8, 12));
			tempcamp1roles.Add (createpvpinfo (10011, 12, 10));
			
			tempcamp1roles.Add (createpvpinfo (50131, 8, 17));
			tempcamp1roles.Add (createpvpinfo (50131, 8, 19));
			tempcamp1roles.Add (createpvpinfo (10011, 12, 17));
			
			tempcamp1roles.Add (createpvpinfo (50031, 17, 13));
			tempcamp1roles.Add (createpvpinfo (50031, 18, 13));
			tempcamp1roles.Add (createpvpinfo (50031, 19, 13));
			tempcamp1roles.Add (createpvpinfo (50031, 20, 13));
			tempcamp1roles.Add (createpvpinfo (50031, 17, 15));
			tempcamp1roles.Add (createpvpinfo (50031, 18, 15));
			tempcamp1roles.Add (createpvpinfo (50031, 19, 15));
			tempcamp1roles.Add (createpvpinfo (50031, 20, 15));
			tempcamp1roles.Add (createpvpinfo (10011, 21, 12));
			
			tempcamp1roles.Add (createpvpinfo (50031, 17, 22));
			tempcamp1roles.Add (createpvpinfo (50031, 18, 22));
			tempcamp1roles.Add (createpvpinfo (50031, 19, 22));
			tempcamp1roles.Add (createpvpinfo (50031, 20, 22));
			tempcamp1roles.Add (createpvpinfo (50031, 17, 24));
			tempcamp1roles.Add (createpvpinfo (50031, 18, 24));
			tempcamp1roles.Add (createpvpinfo (50031, 19, 24));
			tempcamp1roles.Add (createpvpinfo (50031, 20, 24));
			tempcamp1roles.Add (createpvpinfo (10011, 21, 21));

			
			
		}
		
		tempcamp2roles = new List<pvproleinfo_> ();
		{
			//tempcamp2roles.Add(createpvpinfo(50031, 36, 5));
			tempcamp2roles.Add (createpvpinfo (50131, 36, 10));

			tempcamp2roles.Add (createpvpinfo (50131, 45, 7));
			tempcamp2roles.Add (createpvpinfo (50131, 45, 9));
			tempcamp2roles.Add (createpvpinfo (10011, 42, 7));
			
			tempcamp2roles.Add (createpvpinfo (50131, 45, 19));
			tempcamp2roles.Add (createpvpinfo (50131, 45, 17));
			tempcamp2roles.Add (createpvpinfo (10011, 42, 17));
			
			
			
			tempcamp2roles.Add (createpvpinfo (50021, 36, 13));
			tempcamp2roles.Add (createpvpinfo (50021, 37, 13));
			tempcamp2roles.Add (createpvpinfo (50021, 38, 13));
			tempcamp2roles.Add (createpvpinfo (50021, 39, 13));
			tempcamp2roles.Add (createpvpinfo (50021, 36, 15));
			tempcamp2roles.Add (createpvpinfo (50021, 37, 15));
			tempcamp2roles.Add (createpvpinfo (50021, 38, 15));
			tempcamp2roles.Add (createpvpinfo (50021, 39, 15));
			tempcamp2roles.Add (createpvpinfo (10011, 33, 12));
			
			tempcamp2roles.Add (createpvpinfo (50021, 36, 22));
			tempcamp2roles.Add (createpvpinfo (50021, 37, 22));
			tempcamp2roles.Add (createpvpinfo (50021, 38, 22));
			tempcamp2roles.Add (createpvpinfo (50021, 39, 22));
			tempcamp2roles.Add (createpvpinfo (50021, 36, 24));
			tempcamp2roles.Add (createpvpinfo (50021, 37, 24));
			tempcamp2roles.Add (createpvpinfo (50021, 38, 24));
			tempcamp2roles.Add (createpvpinfo (50021, 39, 24));
			tempcamp2roles.Add (createpvpinfo (10011, 33, 21));
			

			
		}*/
		//result.BossPvp_Info = JsonMapper.ToObject<List<pvproleinfo_>>(Config);	
		//string str =JsonMapper.ToJson (tempcamp2roles);
		//List<pvproleinfo_> ssjjdj = JsonMapper.ToObject<List<pvproleinfo_>>(str);	
		//lgCfgMag.Ins.camp1roles = tempcamp1roles;
		//lgCfgMag.Ins.camp2roles = tempcamp2roles;
		//lgCfgMag.Ins.pvpresult = "";
	}
	public pvproleinfo_ createpvpinfo(int dbid,int posx,int posz)
	{
		
		pvproleinfo_ temprole = new pvproleinfo_();
		temprole.uuid = "";
		temprole.RoleDbid = dbid;
		temprole.CreatePos = new tPoint_();
		temprole.CreatePos.x = posx;
		temprole.CreatePos.z = posz;
		temprole.lvl = 1;
		temprole.qulitylvl = 0;
		temprole.nowsitzuoqipname = "";
		return temprole;
	}
}
