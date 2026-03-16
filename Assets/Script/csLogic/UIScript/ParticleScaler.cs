//This script will only work in editor mode. You cannot adjust the scale dynamically in-game!
using UnityEngine;
using System.Collections;


public class ParticleScaler : MonoBehaviour 
{
	public float particleScale = 1.0f;
	public bool alsoScaleGameobject = true;
	bool par = false;
	float prevScale;
	bool SetLayer = false;
	float LayerNowTime = 0f;
	int Layer = 0;
    Vector3 intiPos = Vector3.zero;
	void Awake()
	{
		//prevScale = particleScale;
		
	//this.gameObject.SetActive(false);
		    float scaleFactor = 0.2f / 1f;

			//scale legacy particle systems
			ScaleLegacySystems(scaleFactor);

			//scale shuriken particle systems
			ScaleShurikenSystems(scaleFactor);

			//scale trail renders
			ScaleTrailRenderers(scaleFactor);
		
	}

   
	
	public void Set(int _layer)
	{
        intiPos = this.transform.localPosition;
       // this.transform.localPosition = new Vector3(100000f, 0, 0);
        
        SetLayer = true;
		LayerNowTime = 0f;
		Layer = _layer;
		//particleScale = _PS;
		//prevScale = _PS;
		
		//par = false;
		
		
		//this.gameObject.SetActive(true);
	}

	void Update () 
	{
		if(SetLayer==true)
		{
            LayerNowTime = LayerNowTime + Time.deltaTime;
			if(LayerNowTime >= 0.5f)
			{
                //this.transform.localPosition = intiPos;
                this.gameObject.SetActive(false);
                this.gameObject.SetActive(true);
                this.gameObject.layer = Layer;
                SetLayer = false;
            }
		}
		
		
	}
	
	public void CancelPar()
	{
		SetLayer = false;
		this.gameObject.layer = 0;
	}
	
	public void OpenPar()
	{
		this.gameObject.SetActive(false);
        this.gameObject.SetActive(true);
		this.gameObject.layer = 5;		
	}
	
	void ScaleShurikenSystems(float scaleFactor)
	{

		//get all shuriken systems we need to do scaling on
		ParticleSystem[] systems = GetComponentsInChildren<ParticleSystem>();

		foreach (ParticleSystem system in systems)
		{
            if (system.startSpeed > 0.01f)
            {
                system.startSpeed *= scaleFactor; 
            }
			
            
			system.startSize *= scaleFactor;
			/*if(system.startSize==0.8f)
			{
				system.startSize = 0.4f;
			}
			else if(system.startSize==0.4f)
			{
				system.startSize = 0.2f;
			}*/
			if(system.startSize <= 0.2f)
			{
				system.startSize = 0.2f;
			}
			system.gravityModifier *= scaleFactor;

			//some variables cannot be accessed through regular script, we will acces them through a serialized object
			/*SerializedObject so = new SerializedObject(system);
			
			//unity 4.0 and onwards will already do this one for us
#if UNITY_3_5 
			so.FindProperty("ShapeModule.radius").floatValue *= scaleFactor;
			so.FindProperty("ShapeModule.boxX").floatValue *= scaleFactor;
			so.FindProperty("ShapeModule.boxY").floatValue *= scaleFactor;
			so.FindProperty("ShapeModule.boxZ").floatValue *= scaleFactor;
#endif
			
			so.FindProperty("VelocityModule.x.scalar").floatValue *= scaleFactor;
			so.FindProperty("VelocityModule.y.scalar").floatValue *= scaleFactor;
			so.FindProperty("VelocityModule.z.scalar").floatValue *= scaleFactor;
			so.FindProperty("ClampVelocityModule.magnitude.scalar").floatValue *= scaleFactor;
			so.FindProperty("ClampVelocityModule.x.scalar").floatValue *= scaleFactor;
			so.FindProperty("ClampVelocityModule.y.scalar").floatValue *= scaleFactor;
			so.FindProperty("ClampVelocityModule.z.scalar").floatValue *= scaleFactor;
			so.FindProperty("ForceModule.x.scalar").floatValue *= scaleFactor;
			so.FindProperty("ForceModule.y.scalar").floatValue *= scaleFactor;
			so.FindProperty("ForceModule.z.scalar").floatValue *= scaleFactor;
			so.FindProperty("ColorBySpeedModule.range").vector2Value *= scaleFactor;
			so.FindProperty("SizeBySpeedModule.range").vector2Value *= scaleFactor;
			so.FindProperty("RotationBySpeedModule.range").vector2Value *= scaleFactor;

			so.ApplyModifiedProperties();
		}*/
		}
	}

	void ScaleLegacySystems(float scaleFactor)
	{

		//get all emitters we need to do scaling on
		//ParticleEmitter[] emitters = GetComponentsInChildren<ParticleEmitter>();

		////get all animators we need to do scaling on
		//ParticleAnimator[] animators = GetComponentsInChildren<ParticleAnimator>();

		////apply scaling to emitters
		//foreach (ParticleEmitter emitter in emitters)
		//{
		//	emitter.minSize *= scaleFactor;
		//	emitter.maxSize *= scaleFactor;
		//	emitter.worldVelocity *= scaleFactor;
		//	emitter.localVelocity *= scaleFactor;
		//	emitter.rndVelocity *= scaleFactor;

		//	//some variables cannot be accessed through regular script, we will acces them through a serialized object
		//	/*SerializedObject so = new SerializedObject(emitter);

		//	so.FindProperty("m_Ellipsoid").vector3Value *= scaleFactor;
		//	so.FindProperty("tangentVelocity").vector3Value *= scaleFactor;
		//	so.ApplyModifiedProperties();*/
		//}

		////apply scaling to animators
		//foreach (ParticleAnimator animator in animators)
		//{
		//	animator.force *= scaleFactor;
		//	animator.rndForce *= scaleFactor;
		//}

	}

	void ScaleTrailRenderers(float scaleFactor)
	{
		//get all animators we need to do scaling on
		TrailRenderer[] trails = GetComponentsInChildren<TrailRenderer>();

		//apply scaling to animators
		foreach (TrailRenderer trail in trails)
		{
			trail.startWidth *= scaleFactor;
			trail.endWidth *= scaleFactor;
		}
	}
}
