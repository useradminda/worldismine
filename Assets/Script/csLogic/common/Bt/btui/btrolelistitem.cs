using UnityEngine;
using System.Collections;

public class btrolelistitem : MonoBehaviour {

	public UILabel Name;
	public UILabel Id;
	public UILabel Country;

	public void Set(Pvp_RoleList_ data,int id)
	{
		Name.text =data.name;
		Id.text = id.ToString ();
		Country.text = data.countryid.ToString ();
		gameObject.name = id.ToString();
	}
}
