using UnityEngine;
using System.Collections;

public class CameraSize : MonoBehaviour {

	int sheight = 0;
	int swidth = 0;
	UIRoot uiRoot;
	void Awake()
	{
		 uiRoot = gameObject.GetComponent<UIRoot>();
	}
	 void AdaptiveUI()
	{
		int ManualWidth = 960;
		int ManualHeight = 640;

		if (uiRoot != null)
		{
			int h = Screen.height;
			int w = Screen.width;
			if(sheight != h||swidth != w)
			{
				sheight = h;
				swidth = w;
			}
			if (System.Convert.ToSingle(sheight) / Screen.width > System.Convert.ToSingle(ManualHeight) / ManualWidth)
				uiRoot.manualHeight = Mathf.RoundToInt(System.Convert.ToSingle(ManualWidth) / swidth * Screen.height);
			else
				uiRoot.manualHeight = ManualHeight;


		}

	}
	void Update () {
		AdaptiveUI ();
	}
}
