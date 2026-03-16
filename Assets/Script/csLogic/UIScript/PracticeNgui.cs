using UnityEngine;
using System.Collections;

public class PracticeNgui : MonoBehaviour {
   
	public int t;
	private int lastQ;

    [Header("是否播放一次")]
    public bool isPlayOnece;
    private float allTime = 0;
    void Start()
	{
		if(t==0)
		{
			return;
		}
		if(transform.GetComponent<Renderer>()!=null)
		{ 
			transform.GetComponent<Renderer>().material.renderQueue = t;
			lastQ = t;
		}
		
	    Transform[] transforms = transform.GetComponentsInChildren<Transform>(true);
		for(int i = 0 ; i < transforms.Length ; i++)
		{
			
            var particleItem = transforms[i].GetComponent<ParticleSystem>();

            if (particleItem != null&&transform!=transforms[i])
			{
				if(isPlayOnece)
				{
					particleItem.loop = false;
				}
                //SetBiggerTime(particleItem.duration);
                if (transforms[i].gameObject.GetComponent<Renderer>()!=null)
				{
					transforms[i].gameObject.GetComponent<Renderer>().material.renderQueue = t;
				}
			}
			if(particleItem==null&&transform!=transforms[i]&&transforms[i].gameObject.GetComponent<Renderer>()!=null)
			{
				transforms[i].gameObject.GetComponent<Renderer>().material.renderQueue = t;
			}
		}
        
           // Invoke("CloseObj", allTime);
	}

    private void SetBiggerTime(float time)
    {
        if(allTime <time)
        {
            allTime = time;
        }
    }

    private void CloseObj()
    {
        gameObject.SetActive(false);
    }
	
	void Update()
	{
		
	}
	
	public void Play()
	{
		//transform.GetComponent<ParticleSystem>().Stop();
		//transform.GetComponent<ParticleSystem>().Play();
		//SetBiggerTime(2f);
		//if(isPlayOnece)
          //  Invoke("CloseObj", allTime);
	}
	
	void SetQ(int q)
	{ 	
		if(transform.GetComponent<Renderer>()!=null)
		{ 
			transform.GetComponent<Renderer>().material.renderQueue = q;
			lastQ = q;
		}
		
	    Transform[] transforms = transform.GetComponentsInChildren<Transform>(true);
		for(int i = 0 ; i < transforms.Length ; i++)
		{
			if(transforms[i].GetComponent<ParticleSystem>()!=null)
			{		
				if(transforms[i].gameObject.GetComponent<Renderer>()!=null)
				{
					transforms[i].gameObject.GetComponent<Renderer>().material.renderQueue = q;
				}
			}
		}
		
	}
	
	public void SetQueue(int _Queue)
	{
		SetQ(_Queue);
	}
}
