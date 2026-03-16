using UnityEngine;
using System.Collections;

//战斗内时间管理器
public class lgbtTimemag  {


    public float InbtTime;      //副本事件事件 从事件初始化开始
    public float btFightTime;  //战斗事件 从开始战斗开始

    public bool pauseInbtTime;      //副本事件事件 从事件初始化开始
    public bool pausebtFightTime;  //战斗事件 从开始战斗开始

   
    public void IniSome()
    {
        InbtTime = 0f;
        btFightTime = 0f;
        pauseInbtTime = true;
        pausebtFightTime = true;
    }

    public void StartEve()
    {
        pauseInbtTime = false;
    }

    public void StartFight()
    {
        pausebtFightTime = false;
    }

    //暂停一次
    public void PauseFight()
    {
        pausebtFightTime = !pausebtFightTime;
    }

    public void PauseEve()
    {
        pauseInbtTime = !pauseInbtTime;
    }

    //所有的暂停
    public void PauseAll()
    {
        pauseInbtTime = !pauseInbtTime;
        pausebtFightTime = !pausebtFightTime;
    }
    public void update(float dt)
    {
        if (pauseInbtTime == false)
        {
            InbtTime += dt;
        }
        if (pausebtFightTime == false)
        {
            btFightTime += dt;
        }
    }
    //退出战斗
    public void Quit()
    {

        pauseInbtTime = true;
        pausebtFightTime = true;
    }
}
