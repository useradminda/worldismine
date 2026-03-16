using UnityEngine;
using System.Collections;

public class lgRoleAnimaKu : MonoBehaviour {

	// Use this for initialization
	void Start () {
		GameObject.DontDestroyOnLoad (gameObject);
	}
	
	// Update is called once per frame
	//void Update () {
	
	//}
	//public AnimationClip[] RoleanimaList;

	public AnimationClip[] dieList; 	//死亡动作种类
	public AnimationClip[] waitList;	//待机动作种类
	public AnimationClip[] walkList;	//移动

	public AnimationClip[] attackList;	//攻击
	//public AnimationClip[] skillList;


}
