using UnityEngine;
using System.Collections;

public class testdybroleanim : MonoBehaviour {

	public float movespeedmax = 5f;		//移动速度最大
	public float movespeedmin = 2f;		//移动速度最小
	public float atttime = 1.5f;   //攻击时间
	public float useatttime = 0f;   //攻击时间
	private Animation myani;
	
	private float oncemovetime = 0f;
	private float usemovetime = 0f;
	private float mspeed = 0f;
	
	private float randx = 0f;
	private float randy = 0f;
	private float randz = 0f;
	private int nowstate = 0;


	private float walkanimtime = 0f;
	private float attackanimtime = 0f;

	private float usewalkanimtime = 0f;
	private float useattackanimtime = 0f;

	void Start () {
		mspeed = Random.Range(movespeedmin,movespeedmax);
		myani=gameObject.GetComponent<Animation>();
		myani["walk"].wrapMode = WrapMode.ClampForever;
		myani ["walk"].layer = 1;
		myani ["walk"].weight = 1;
		myani["attack"].wrapMode = WrapMode.ClampForever;
		myani["idle"].wrapMode = WrapMode.ClampForever;
		walkanimtime = myani ["walk"].length;
		Debug.LogError ("walkanimtime="+walkanimtime);
		attackanimtime = myani ["attack"].length;

		myani.Stop ();
		/*
		 local animastate = self.m_Animo:getItem(animaE)
			animastate.blendMode = AnimationBlendMode.Additive
				animastate.weight = 1
				animastate.wrapMode = WrapMode.ClampForever
				animastate.enabled = true
				animastate.normalizedTime = 0
				self.HurtList.Clip1 = self.m_Animo:getItem(animaE)
				self.HurtList.usetime1 = self.m_Animo:GetClip(animaE).length
				self.HurtList.nowtime1 = 0




				*/
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
			//domove();
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
		usewalkanimtime = 0f;
		useupdateaninum = 0;
		myani ["walk"].enabled = true;
		myani["walk"].normalizedTime = 0;
		//myani.CrossFadeQueued("walk",0.3f, QueueMode.PlayNow);
		gameObject.transform.LookAt (tar);
		nowstate = 1;
	}
	private int updateaninum = 2;
	private int useupdateaninum = 0;
	void updatemove(float dt)
	{
		usemovetime += dt;

		if (usemovetime <= oncemovetime)
		{
			gameObject.transform.position = Vector3.Lerp(inipos,tar,usemovetime/oncemovetime);
			useupdateaninum --;
			if(useupdateaninum<0)
			{
				useupdateaninum = updateaninum;
				usewalkanimtime += dt;
				if(usewalkanimtime>=walkanimtime)
				{
					usewalkanimtime =  0;
				}
				//myani ["walk"].enabled = true;
				myani["walk"].normalizedTime = usewalkanimtime;
			}
			//Debug.LogError("myani[walk].normalizedTime="+myani["walk"].normalizedTime);
		} 
		else 
		{
			nowstate = 0;
			myani["walk"].normalizedTime = 0;
			myani ["walk"].enabled = false;
			myani.Stop ();
		}
		
	}
	void doatt()
	{
		//myani.CrossFadeQueued("attack",0.3f, QueueMode.PlayNow);
		useattackanimtime = 0f;
		myani ["attack"].enabled = true;
		myani["attack"].normalizedTime = 0;
		useupdateaninum = 0;
		useatttime = 0f;  
		nowstate = 2;
	}
	void updateatt(float dt)
	{
		useatttime += dt;
		if (useatttime > atttime) {
			nowstate = 0;
			myani["attack"].normalizedTime = 0;
			myani ["attack"].enabled = false;
			//myani.Stop ();
		} else {
			useupdateaninum --;
			if(useupdateaninum<0)
			{
				useupdateaninum = updateaninum;
				useattackanimtime += dt;
				if(useattackanimtime>=attackanimtime)
				{
					useattackanimtime =  0;
				}
			}
			myani["attack"].normalizedTime = useattackanimtime;

		}
		
	}
}
