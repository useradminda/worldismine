using UnityEngine;
using System.Collections;

public class ClickEvent : MonoBehaviour {
	
	public Sprite[] sprites;
	
	void OnClick()
	{
		lgNoDelCsFun.Ins.ClickEvent(gameObject);
		
		
	}
}
