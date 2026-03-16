using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using SLua;
using System.IO;

/// <summary>
/// Filename: AudioManager.cs
/// Description: Manager of ground music
/// Author: Jayce
/// Date: [15/10/19] 创建
/// Data: [15/10/29] 修改：添加背景音乐开关ToggleBG/添加音效开关ToggleClip/audioObjCacheList缓存音效对象完善/开启背景音乐播放当前所在场景的背景音乐
/// </summary>

[CustomLuaClass]
public class AudioManager : MonoBehaviour {
	private string TOGGLE_BG_KEY = "ToggleBG";
	private string TOGGLE_CLIP_KEY = "ToggleClip";
	private string AudioFilePath = "Audio/Source/BGMusic/";

	private bool isBGOpen = true;
	private bool isClipOpen = true;

    private static AudioManager instance = null;

	public AudioSource m_AudioMgr;	
	private AudioClip m_PlayClip;
	private string m_CurMusicName = "";

	//Cache of audio clip
	private Dictionary<string, AudioClip> audioList = new Dictionary<string, AudioClip> ();
	//Cache of audio object
	private Dictionary<string, List<GameObject>> audioObjCacheList = new Dictionary<string, List<GameObject>> ();
	public static AudioManager Instance
	{
		get
		{ 
			return instance;
		}
	}
	
	void Awake()
	{
		if (instance != null && instance != this)
		{
			Destroy(this.gameObject);
		}
		else
		{
			instance = this;
		}
		
		DontDestroyOnLoad(this.gameObject);
	}

	void Start()
	{
		if(PlayerPrefs.HasKey (TOGGLE_BG_KEY) && PlayerPrefs.GetInt (TOGGLE_BG_KEY) == 0)
		{
			isBGOpen = false;
		}

		if(PlayerPrefs.HasKey (TOGGLE_CLIP_KEY) && PlayerPrefs.GetInt (TOGGLE_CLIP_KEY) == 0)
		{
			isClipOpen = false;
		}
	}

    /// <summary>
    /// 当前背景音乐是否开启
    /// </summary>
    /// <returns></returns>
    public bool IsBGMusicOpen()
    {
        return isBGOpen;
    }

    /// <summary>
    /// 返回当前的背景音乐名称
    /// </summary>
    /// <returns></returns>
    public string GetCurMusicName()
    {
        return m_CurMusicName;
    }
	
	public bool IsClipOpen()		
	{
		return isClipOpen;
	}
	
	public AudioClip LoadAudioClip(string clipName)
	{
		if (!audioList.ContainsKey (clipName)) {
            AudioClip ac = Resources.Load(AudioFilePath+clipName) as AudioClip;
			audioList.Add(clipName, ac);
		}

        return audioList[clipName];
	}

	public GameObject LoadAudioObject(string clipName)
	{
		GameObject obj;
		if (!audioObjCacheList.ContainsKey (clipName)) {
			obj = new GameObject("Audio:" + clipName);
			AudioSource source = obj.AddComponent<AudioSource>();
			source.clip = LoadAudioClip(clipName);
			source.spatialBlend = 1;
		}
		else
		{
			obj = audioObjCacheList[clipName][0];
			obj.SetActive(true);
			audioObjCacheList[clipName].RemoveAt(0);
			if(audioObjCacheList[clipName].Count == 0)
			{
				audioObjCacheList.Remove(clipName);
			}
		}

		return obj;
	}
	
	/// <summary>
	/// Play the background music which will go through the scene.
	/// </summary>
	/// <param name='fileName'>
	/// File name.
	/// </param>
	public void PlayBG(string fileName)
	{
		if (fileName == "") 
		{
			return;
		}

		if (!isBGOpen) 
		{
			m_CurMusicName = fileName;
			return;
		}

		if (!fileName.Equals(m_CurMusicName) || !m_AudioMgr.isPlaying)
		{
			m_PlayClip = LoadAudioClip(fileName);
			m_AudioMgr.clip = m_PlayClip;
			m_AudioMgr.Play();
            m_AudioMgr.loop = true;
			m_CurMusicName = fileName;
		}
	}

	/// <summary>
	/// Stops the background music.
	/// </summary>
	public void StopBG()
	{
		m_AudioMgr.Stop();
		//Debug.Log("Stop bm_PlayClipkground music");
	}

	/// <summary>
	/// Play the specified clipName, emitter, loop and spatialBlend.
	/// </summary>
	/// <param name="clipName">Clip name.</param>
	/// <param name="emitter">Emitter.</param>
	/// <param name="loop">If set to <c>true</c> loop.</param>
	/// <param name="spatialBlend">Spatial blend.</param>
	public AudioSource Play(string clipName , bool loop,float spatialBlend = 1)
	{
		if(clipName=="")
		{
			return null;
		}
	    //Transform emitter = lgNoDelCsFun.Ins.gameObject.transform;
	    return Play(clipName, 1f, 1f, loop, spatialBlend);
	}

	public AudioSource Play(string clipName , float volume, bool loop,float spatialBlend = 1)
	{
		if(clipName=="")
		{
			return null;
		}
		//Transform emitter = lgNoDelCsFun.Ins.gameObject.transform;
	    return Play(clipName, volume, 1f, loop, spatialBlend);
	}

	public AudioSource Play(string clipName, Vector3 point, bool loop,float spatialBlend = 1)
	{
		return Play(clipName, point, 1f, 1f, loop, spatialBlend);
	}

	public AudioSource Play(string clipName, Vector3 point, float volume, bool loop,float spatialBlend = 1)
	{
		return Play(clipName, point, volume, 1f, loop, spatialBlend);
	}
	
	/// <summary>
	/// Plays a sound by creating an empty game object with an AudioSource
	/// and attaching it to the given transform (so it moves with the transform). 
	/// Destroys it after it finished playing if it dosen't loop.
	/// </summary>
	/// <param name='clipName'>
	/// clipName.
	/// </param>
	/// <param name='emitter'>
	/// Emitter.
	/// </param>
	/// <param name='volume'>
	/// Volume.
	/// </param>
	/// <param name='pitch'>
	/// Pitch.
	/// </param>
	/// <param name='loop'>
	/// Loop.
	/// </param>
	public AudioSource Play(string clipName , float volume, float pitch, bool loop, float spatialBlend)
	{
		if(clipName==""||clipName=="0")
		{
			return null;
		}
        if (!audioList.ContainsKey(clipName))
        {
            Object clipObj = Resources.Load(AudioFilePath + clipName);
            if (clipObj == null)
            {
                Debug.LogWarning("audio is not exists:" + clipName);
                return null;
            }
            else
            {
                audioList.Add(clipName, clipObj as AudioClip);
            }            
        }

        Transform emitter = lgNoDelCsFun.Ins.gameObject.transform;
		if (!isClipOpen)
			return null;

		GameObject go = LoadAudioObject (clipName);	
		if(go==null)
		{
			return null;
		}
		go.transform.position = emitter.position;
		go.transform.parent = emitter;
		
		// create the source
		AudioSource source = go.GetComponent<AudioSource> ();
		source.volume = volume;
		source.pitch = pitch;
		source.loop = loop;
		source.spatialBlend = spatialBlend;
		source.Play ();
		
		if (!loop) {
			StartCoroutine (DelayToInvoke.DelayToInvokeDo (() =>
			{
				Stop (source);
			}, source.clip.length));
		}
		return source;
	}
	
	/// <summary>
	/// Plays a sound at the given point in space by creating an empty game object with an AudioSource
	/// in that place and destroys it after it finished playing if it dosen't loop.
	/// </summary>
	/// <param name='clipName'>
	/// clipName.
	/// </param>
	/// <param name='point'>
	/// Point.
	/// </param>
	/// <param name='volume'>
	/// Volume.
	/// </param>
	/// <param name='pitch'>
	/// Pitch.
	/// </param>
	/// <param name='loop'>
	/// Loop.
	/// </param>
	public AudioSource Play(string clipName, Vector3 point, float volume, float pitch, bool loop, float spatialBlend)
	{
		if (!isClipOpen)
			return null;

		GameObject go = LoadAudioObject (clipName);	
		go.transform.position = point;		
		AudioSource source = go.GetComponent<AudioSource> ();
		source.volume = volume;
		source.pitch = pitch;
		source.loop = loop;
		source.spatialBlend = spatialBlend;
		source.Play ();
		
		if (!loop) {
			StartCoroutine (DelayToInvoke.DelayToInvokeDo (() =>
			{
				Stop (source);
			}, source.clip.length));
		}

		return source;
	}

	/// <summary>
	/// Stop the specified audioSource.
	/// </summary>
	/// <param name="audioSource">Audio source.</param>
	public void Stop(AudioSource audioSource)
	{
		if (audioSource == null) 
		{
			return;
		}

		audioSource.Stop ();
		audioSource.gameObject.SetActive (false);
		if(!audioObjCacheList.ContainsKey(audioSource.clip.name))
		{
			audioObjCacheList.Add(audioSource.clip.name , new List<GameObject>());
		}
		audioObjCacheList[audioSource.clip.name].Add(audioSource.gameObject);
	}

	/// <summary>
	/// Toggles the BG Music open or close.
	/// </summary>
	/// <param name="isOpen">If set to <c>true</c> is open.</param>
	public void ToggleBG(bool isOpen)
	{
		PlayerPrefs.SetInt (TOGGLE_BG_KEY, isOpen ? 1 : 0);
		isBGOpen = isOpen;

		if (isOpen) {
			PlayBG (m_CurMusicName);
		} else {
			StopBG ();
		}
	}

	/// <summary>
	/// Toggles the clip audio open or close.
	/// </summary>
	/// <param name="isOpen">If set to <c>true</c> is open.</param>
	public void ToggleClip(bool isOpen)
	{
		PlayerPrefs.SetInt (TOGGLE_CLIP_KEY, isOpen ? 1 : 0);
		isClipOpen = isOpen;
	}

    /// <summary>
    /// 得到背景音乐的开关状态
    /// </summary>
    public bool GetBgToggleState()
    {
        if (PlayerPrefs.HasKey(TOGGLE_BG_KEY) && PlayerPrefs.GetInt(TOGGLE_BG_KEY) == 0)
        {
            return false;
        }
        return true;
    }
    /// <summary>
    /// 得到音效的开关状态
    /// </summary>
    public bool GetClipToggleState()
    {
        if (PlayerPrefs.HasKey(TOGGLE_CLIP_KEY) && PlayerPrefs.GetInt(TOGGLE_CLIP_KEY) == 0)
        {
            return false;
        }
        return true;
    }
}