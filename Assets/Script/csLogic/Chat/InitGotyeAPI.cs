using UnityEngine;
using System.Collections;
using gotye;

public class InitGotyeAPI : GotyeMonoBehaviour {
	public GotyeAPI api;
	void Awake()
	{
#if UNITY_EDITOR
    //    GameObject.Destroy(gameObject);

        api = GotyeAPI.GetInstance ();
		if (Application.platform != RuntimePlatform.Android)
		{
			api.Init("381bf4f2-46bc-4628-b3ff-94d33b06b186", "com.f8.txswd");//9c236035-2bf4-40b0-bfbf-e8b6dec54928
		}
		//语音识别有关，可选
		api.InitIflySpeechRecognition();	
		InvokeRepeating ("mainLoop", 0.0f, 0.050f);
		GameObject.DontDestroyOnLoad (gameObject);
#endif
	}
	
	void mainLoop()
	{
		api.MainLoop();
	}
}
