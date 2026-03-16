using UnityEngine;
using System.Collections;

public class lgBtCameMag : MonoBehaviour {
	//public bool DebugTest =false;

	public Vector3 IniPos = Vector3.zero;
	Vector3 NowPos;
	public float MoveXmin = 0f;			//左右拖拽 摄像机移动值
	public float MoveXmax = 50f;

	public float MoveYmin = 0f;			//缩放时 摄像机高度值
	public float MoveYmax = 50f;


	public float fgmovechange = 0.1f;			//手势移动一个单位 摄像机移动位置比例

	public float fgpinchchange = 0.1f;			//手势缩放一个单位 摄像机移动位置比例

	DragGestureRecognizer MyDrag;
	PinchGestureRecognizer MyPinch;
	//Camera MyCame;    //看看FOV 要不要改

	float yadd = 0f;
	float zadd = 0f;
	float MoveZmin = 0f;			//缩放时 摄像机高度值
	float MoveZmax = 0f;
	// Use this for initialization
	void Start () {
		MyDrag = GetComponent<DragGestureRecognizer> () as DragGestureRecognizer;
		MyPinch = GetComponent<PinchGestureRecognizer> () as PinchGestureRecognizer;
		NowPos = IniPos;
		gameObject.transform.position = NowPos;
		MyDrag.OnDragMove += MyDragMoveEventHandler;
		MyPinch.OnPinchMove += MyPinchMoveEventHandler;
		pausefg = false;
		//MoveYmax = 80f;
		//MoveYmin = 20f;
		yadd = gameObject.transform.forward.y;
		zadd = gameObject.transform.forward.z;
		MoveZmin = IniPos.z + zadd*(MoveYmin-IniPos.y) / yadd ;
		MoveZmax = IniPos.z + zadd*(MoveYmax-IniPos.y) / yadd ;
	}
	void OnDestroy()
	{
		//Debug.Log ("lgBtCameMag OnDestroy");
		MyDrag.OnDragMove -= MyDragMoveEventHandler;
		MyPinch.OnPinchMove -= MyPinchMoveEventHandler;
	}
	bool pausefg = false;
	public void PauseFg(bool pause)
	{
		pausefg = pause;
	}


	public void MyDragMoveEventHandler( DragGestureRecognizer gesture )
	{
		if(pausefg==true)
		{
			return;
		}
		float movex = -gesture.MoveDelta.x;
		if(NowPos.x>=MoveXmax&&movex>0||NowPos.x<=MoveXmin&&movex<0)
		{
			return;
		}
		NowPos.x = NowPos.x + movex * fgmovechange;
		if(NowPos.x>MoveXmax)
		{
			NowPos.x = MoveXmax;
		}
		if(NowPos.x<MoveXmin)
		{
			NowPos.x = MoveXmin;
		}

		gameObject.transform.position = NowPos;

		//要通知UI 更新界面显示  比如血条
		lgbtmag.Ins.Call_UI_CameChangePos ();

		//gesture.MoveDelta.x
		//Debug.Log( "gesture.MoveDelta x = " + gesture.MoveDelta.x.ToString() );
	}
	public void MyPinchMoveEventHandler( PinchGestureRecognizer gesture )
	{
		//Debug.LogError ("gesture.Delta = "+gesture.Delta.ToString()+" NowPos.y="+NowPos.y.ToString()+" gameObject.transform.forward="+gameObject.transform.forward.ToString());
		if(pausefg==true)
		{
			return;
		}
		if(NowPos.y>=MoveYmax&&gesture.Delta<0||NowPos.y<=MoveYmin&&gesture.Delta>0)
		{
			return;
		}
		//int fangxiang = 1;
		//if(gesture.Delta<0)
		//{
		//	fangxiang = -1;
		//}
		//NowPos.y = NowPos.y + gesture.Delta * fgpinchchange;
		//NowPos = NowPos + gameObject.transform.forward * gesture.Delta* fgpinchchange;
		NowPos = NowPos + gameObject.transform.forward * gesture.Delta* fgpinchchange;
		if(NowPos.y>MoveYmax)
		{
			NowPos.y = MoveYmax;
			NowPos.z = MoveZmax;
		}
		if(NowPos.y<MoveYmin)
		{
			NowPos.y = MoveYmin;
			NowPos.z = MoveZmin;
		}

		//gameObject.transform.forward
		gameObject.transform.position = NowPos ;

		//要通知UI 更新界面显示  比如血条
		lgbtmag.Ins.Call_UI_CameChangePos ();

		//Debug.Log( "gesture.Delta = " + gesture.Delta.ToString() );
	}


}
