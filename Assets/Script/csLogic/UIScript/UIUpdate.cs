using UnityEngine;
using System.Collections;

public delegate void MyDelete(int i);

public class UIUpdate : MonoBehaviour {
	public MyDelete myDelete;
	public string panelName;

	public UISlider processAll;
	public UISlider processCur;
	public UILabel updateTipText;
    public UILabel curVersionText;
    public UILabel newVersionText;

	public GameObject firstTitleObj;
	public GameObject sencondTitleObj;

	public GameObject Boat;

	/*
    private static UIUpdate _ins;
    public static UIUpdate Ins
	{
		get
		{
			return _ins;
		}
	}	

	void Awake()
	{
		_ins = this;
	}
*/
	public void SetCurProcess(float curProcess)
	{
		processCur.value = curProcess;

		if(Boat!=null)
		{
			Boat.transform.localPosition = new Vector3(-367 + curProcess*750 , -129 , 0);
		}
	}

	public void SetProcess(float curProcess,float allProcess)
	{
		processCur.value = curProcess;
		processAll.value = allProcess;
		if(Boat!=null)
		{
		  Boat.transform.localPosition = new Vector3(-367 + allProcess*750 , -129 , 0);
		}
	}

    public void SetVersionText(string curV, string newV)
    {
		//firstTitleObj.SetActive (true);
		//sencondTitleObj.SetActive (true);
        curVersionText.text = curV;
        newVersionText.text = newV;
    }

    public void SetUpdateTipText(string text)
	{
		updateTipText.text = text;
	}

	public void UpdateFinish()
	{
		gameObject.SetActive (false);
	}

	/// <summary>
	/// 显示提示面板
	/// </summary>
	/// <param name="delete">Delete.</param>
	/// <param name="panelName">Panel name.</param>
	public void ShowPanel(MyDelete delete, string pn)
	{
		transform.Find (pn).gameObject.SetActive (true);
		myDelete = delete;
		panelName = pn;
	}

	public void ClickOK()
	{
		//Debug.Log (transform.FindChild (panelName).gameObject.name + " hide.");
		transform.Find (panelName).gameObject.SetActive (false);
		myDelete (1);
	}

	public void ClickCancel()
	{
		//Debug.Log (transform.FindChild (panelName).gameObject.name + " hide.");
		transform.Find (panelName).gameObject.SetActive (false);
		myDelete (0);
	}
}
