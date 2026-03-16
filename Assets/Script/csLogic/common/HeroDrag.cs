using UnityEngine;
using System.Collections;
using System;

public class HeroDrag : MonoBehaviour {

    private Vector3 beginPos;
    private Vector3 beginMousePos;
    private bool isDrag = false;

    public float Sensitivity = 800f;

    private UIEventListener listener
    {
        get
        {
            var m_listener = transform.GetComponent<UIEventListener>();
            if (m_listener == null)
                m_listener = gameObject.AddComponent<UIEventListener>();
            return m_listener;
        }
    }

    void Start()
    {
        ResigterEvent();
    }

    void OnEnable()
    {
        ResigterEvent();
    }
    private void ResigterEvent()
    {
        listener.onDragStart = OnStartDrag;
        listener.onDragEnd = OnEndDrag;
        listener.onDrag = OnDragIng;
    }

    public void  OnStartDrag(GameObject obj)
    {
        //beginPos = Input.mousePosition;
        beginMousePos = Input.mousePosition;
        beginPos = transform.localEulerAngles;
        isDrag = true;
    }

    public void OnEndDrag(GameObject obj)
    {
        var curEulerAngles = transform.localEulerAngles;
        var deY = curEulerAngles.y - beginPos.y;
        if(deY == 0)
        {
            var endMousePos = Input.mousePosition;
            var del = endMousePos - beginMousePos;
            transform.Rotate(Vector3.up, -(del.x) / Sensitivity * 360);
        }
        isDrag = false;
    }

    public void OnDragIng(GameObject obj ,Vector2 del)
    {
        transform.Rotate(Vector3.up, -(del.x) / Sensitivity * 360);
    }
}
