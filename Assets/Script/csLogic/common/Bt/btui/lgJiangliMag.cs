using UnityEngine;
using System.Collections;

public class lgJiangliMag : MonoBehaviour {
	public GameObject Winobj;		//胜利
	public GameObject Loseobj;		//失败
	public GameObject Jinyanobj;	//经验
	public UILabel Jinyan_lb;
	public GameObject Jinbiobj;		//金币
	public UILabel Jinbi_lb;
	public GameObject Shengwangobj;	//声望
	public UILabel Shengwang_lb;
	public GameObject Rongyao;
	public GameObject Jianglidaojuobjroot; //奖励道具
	public GameObject[] Jianglidaojuobj;	

	public GameObject LoseFunobjroot; //失败4种提示
	public BtUIEventListener[] LoseFunLis;	
	public BtUIEventListener JieshuLis;	
	public GameObject huodedaju_lb;	
	public GameObject shenlimiaozhao_lb;	

	lgBtUiMag Mymag;
	bool fanhui = false;
	bool isfuben = false;
	public GameObject[] xingxing;

	public void IniSome(lgBtUiMag thismag,bool fuben)
	{
		Mymag = thismag;
		JieshuLis.GexingP_i=-1;
		JieshuLis.GexingP_s="jieshu";
		JieshuLis.onClick = JieshuOnClick;
		for(int i=0;i<LoseFunLis.Length;i++)
		{
			LoseFunLis[i].GexingP_i=i;
			LoseFunLis[i].GexingP_s="backui";
			LoseFunLis[i].onClick = FanhuiUI;
		}
		fanhui = false;
		isfuben = fuben;
		gameObject.SetActive (false);
	}


	public void SetWin(bool win)
	{
		if (win == true) 
		{
			Winobj.SetActive (true);
			Loseobj.SetActive (false);
			xingxing[2].SetActive (true);
			Jianglidaojuobjroot.SetActive(true);
			LoseFunobjroot.SetActive (false);
			huodedaju_lb.SetActive (true);
			shenlimiaozhao_lb.SetActive (false);
		} 
		else 
		{
			Winobj.SetActive (false);
			Loseobj.SetActive (true);
			Jianglidaojuobjroot.SetActive(false);
			LoseFunobjroot.SetActive (true);
			huodedaju_lb.SetActive (false);
			shenlimiaozhao_lb.SetActive (true);
		}
		if(isfuben==true)	//副本
		{
			Jinyanobj.SetActive (true);	//经验
			Jinbiobj.SetActive (true);		//金币
			Shengwangobj.SetActive (false);
		}
		else  //pvp
		{
			Jinyanobj.SetActive (false);	//经验
			Jinbiobj.SetActive (false);		//金币
			Shengwangobj.SetActive (true);
		}
		fanhui = false;
	}
	public void JieshuOnClick(GameObject obj,int GexingP_i,string GexingP_s)
	{
		if(fanhui == false)
		{
			fanhui = true;
			Mymag.JIeshuShowResult ();
		}
	}
	public void FanhuiUI(GameObject obj,int GexingP_i,string GexingP_s)
	{
		if(GexingP_s=="backui")
		{
			lgNoDelCsFun.Ins.JumpToPanel(GexingP_i);
			Mymag.JIeshuShowResult ();
		}
	}

	//显示胜利失败  和星星动画  iswin==1 胜利  其他 失败  showstar>0&&showstar<4  显示的几星
	public void ShowWinOrLoseAnim(int iswin,int showstar)  
	{
		if(iswin==1)
		{
			if(showstar>0&&showstar<4)
			{
				xingxing[showstar-1].SetActive (true);
			}
			Winobj.SetActive (true);
			Loseobj.SetActive (false);
		}
		else
		{
			Winobj.SetActive (false);
			Loseobj.SetActive (true);
		}
	}
}
