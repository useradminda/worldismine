using UnityEngine;
using System.Collections;
/*
public struct chatitemdata_   >>MyRoleInfoData_
{
	public string head_atlas;
	public string head_sp;
	public string country_atlas;
	public string country_sp;
	public string name;
	public int lvl;
	//public int type;	//1 文本  2语音
	//public int id;
	//public string say;
	public string uuid;
	//public int yuyingid;
}
*/
public class siliaoitem : MonoBehaviour {

	public UIChatMag MyUIChatMag;
	//public int type =-1;
	
	public UISprite head;
	public UILabel haoyou;
	public UILabel lvl;
	public UILabel name;
	public string uuid;
	public string str_name;
	//public int id;
	//public UILabel saylab;
	//public GameObject yuyingobj;
	//public GameObject txtobj;
	//public int yuyingid;
	
	public BtUIEventListener headbt;
	public BtUIEventListener saybt;


	//private GotyeMessage Mymessage;
	public void IniShow(MyRoleInfoData_ data)
	{
		str_name = data.name;
		name.text = str_name;

		lvl.text = "Lv" + data.lvl.ToString ();
		lgNoDelCsFun.Ins.SetHeadIconById (head, data.headspid);

		headbt.onClick = headBtClick;
		saybt.onClick = sayBtClick;
		uuid = data.uuid;
			

	
	}

	//显示头像菜单
	public void headBtClick(GameObject thisobj, int Order,string key)
	{
		
	}
	//开始跟这个人聊天
	public void sayBtClick(GameObject thisobj, int Order,string key)
	{
		MyUIChatMag.ShowTalkToThisRole (uuid,str_name);
	}
}
