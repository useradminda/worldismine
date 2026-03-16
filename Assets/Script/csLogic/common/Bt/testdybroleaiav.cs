using UnityEngine;
using System.Collections;

public class testdybroleaiav : MonoBehaviour {

	public float movespeedmax = 5f;		//移动速度最大
	public float movespeedmin = 2f;		//移动速度最小
	public float atttime = 1.5f;   //攻击时间
	public float useatttime = 0f;   //攻击时间
	private Animator myani;
	
	private float oncemovetime = 0f;
	private float usemovetime = 0f;
	private float mspeed = 0f;
	
	private float randx = 0f;
	private float randy = 0f;
	private float randz = 0f;
	private int nowstate = 0;
	void Start () {
		mspeed = Random.Range(movespeedmin,movespeedmax);
		myani=gameObject.GetComponent<Animator>();
	}
	
	// Update is called once per frame
	void Update () {
		if(nowstate==0)
		{
			chooseaction();
		}
		else if(nowstate==1)
		{
			updatemove(Time.deltaTime);
		}
		else if(nowstate==2)
		{
			updateatt(Time.deltaTime);
		}
	}
	void chooseaction()
	{
		int choose = Random.Range(1,3);
		if(choose==1)
		{
			domove();
		}
		else
		{
			
			doatt();
		}
		
	}
	private Vector3 tar;
	private Vector3 inipos;
	void domove()
	{
		randx = Random.Range(-30f,30f);
		randy = 0;//Random.Range(-30,30);
		randz = Random.Range(-50f,0f);
		tar = new Vector3 (randx,randy,randz);
		inipos = gameObject.transform.position;
		float dis = Vector3.Distance (inipos,tar);
		
		oncemovetime = dis / mspeed;
		usemovetime = 0f;
		//myani.CrossFadeQueued("walk",0.3f, QueueMode.PlayNow);
		myani.SetBool ("changewalk",true);
		gameObject.transform.LookAt (tar);
		nowstate = 1;
	}
	void updatemove(float dt)
	{
		usemovetime += dt;
		if (usemovetime <= oncemovetime)
		{
			gameObject.transform.position = Vector3.Lerp(inipos,tar,usemovetime/oncemovetime);
		} 
		else 
		{
			nowstate = 0;
			myani.SetBool ("changewalk",false);

		}
		
	}
	void doatt()
	{
		//myani.CrossFadeQueued("attack",0.3f, QueueMode.PlayNow);
		
		useatttime = 0f;  
		nowstate = 2;
		myani.SetBool ("changeatt",true);
	}
	void updateatt(float dt)
	{
		useatttime += dt;
		if (useatttime > atttime) 
		{
			nowstate = 0;
			myani.SetBool ("changeatt",false);
		} 
		
	}
}
