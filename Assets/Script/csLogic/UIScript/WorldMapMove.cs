using UnityEngine;
using System.Collections;

public class WorldMapMove : MonoBehaviour {
	
	void Start()
	{
		if(gameObject.GetComponent<UIEventListener>()==null)
		{
			gameObject.AddComponent<UIEventListener>();
		}
		gameObject.GetComponent<UIEventListener>().onDrag = OnDrapItem;
	}

	void OnDrapItem(GameObject _Gob , Vector2 _detal)
	{
	   lgNoDelCsFun.Ins.GetUIDragEvent(_Gob , "UIWorldMap" , _detal);
	}
	
}
