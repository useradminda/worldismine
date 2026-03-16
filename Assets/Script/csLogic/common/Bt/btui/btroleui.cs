using UnityEngine;
using System.Collections;

public struct btroleinfo_
{
	public string uuid;
	public int lvl;
	public string name;
	public int vip;
	public int country;
	public int headid;	//头像Id 传输用

	//public string headatlas;
	//public string headsp;
	public void SetNull()
	{
		this.uuid = "0";			
		this.lvl= 0;		
		this.name= "";		
		this.vip= 0;		
		
		this.country= 0;       
		this.headid= 0;		

	}
}

public class btroleui : MonoBehaviour {
	public GameObject showroot;
	public UISprite head;
	public UILabel lvl;
	public UILabel name;
	public UISprite vip;
	public UISprite vip2;
	public UILabel country;
	btroleinfo_ nowinfo;
	public bool nowshow;
	public void SetInfo(btroleinfo_ thisinfo)
	{
		nowinfo = thisinfo;
		//lgNoDelCsFun.Ins.SetIcon (head,thisinfo.headatlas,thisinfo.headsp);
		lgNoDelCsFun.Ins.SetHeadIconById (head,thisinfo.headid);
		lvl.text ="Lv:"+ thisinfo.lvl.ToString ();
		name.text = thisinfo.name;
		//vip.text = "Vip:"+thisinfo.vip.ToString();
		if (thisinfo.vip > 9) {
			vip.gameObject.SetActive(true);
			vip2.gameObject.SetActive(true);
			int num = thisinfo.vip/10;
			int num2 = thisinfo.vip-num*10;
			lgNoDelCsFun.Ins.SetIcon(vip,"BtUi","vip_"+num.ToString());
			lgNoDelCsFun.Ins.SetIcon(vip2,"BtUi","vip_"+num2.ToString());
		} else {
			lgNoDelCsFun.Ins.SetIcon(vip,"BtUi","vip_"+thisinfo.vip.ToString());
			vip.gameObject.SetActive(true);
			vip2.gameObject.SetActive(false);
		}


		country.text = thisinfo.country.ToString();
	}
	public void show(bool isshow)
	{
		nowshow = isshow;
		showroot.SetActive (nowshow);
	}
}
