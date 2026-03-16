using UnityEngine;
using System.Collections;

public class lgAnimationCurveList : MonoBehaviour
{
    public AnimationCurve[] MyAnimationCurveList;
	public AnimationCurve[] MyVastCurveList;  //求面积用的 

	//下面4个测试用  非-1的时候 弹药用设定的曲线编号
	public int Debug_Y_useCurve =-1;
	public int Debug_X_useCurve =-1;
	public int Debug_Speed_useCurve =-1;
	public float Debug_Fly_Speed =-1f;
}
