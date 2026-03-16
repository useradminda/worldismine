using UnityEngine;
using System.Collections;
using System.Collections.Generic;
//场景BUFF管理器
public class btbuffmag  {

    public List<buffbase> btbufflist=null;

    public List<buffbase> diebufflist = null;

    public void IniSome()
    {
        if (btbufflist==null)
        {
            btbufflist = new List<buffbase>();
        }
        if (diebufflist == null)
        {
            diebufflist = new List<buffbase>();
        }
        btbufflist.Clear();
    }
    private bool delbuff = false;
    private List<buffbase> tempdelbufflist = new List<buffbase>();
    public void updata(float dt)
    {
        for (int i = 0; i < btbufflist.Count;i++ )
        {
            delbuff = btbufflist[i].update(dt);
            if (delbuff==true)
            {
                tempdelbufflist.Add(btbufflist[i]);
            }
        }
        if (tempdelbufflist.Count>0)
        {
            for (int i = 0; i < tempdelbufflist.Count; i++)
            {
                btbufflist.Remove(tempdelbufflist[i]);
                diebufflist.Add(tempdelbufflist[i]);
            }
            tempdelbufflist.Clear();
        }

    }

    public buffbase CreateOnebuff()
    {
        buffbase thisbuff;
        if (diebufflist.Count > 0)
        {
            thisbuff = diebufflist[0];
            diebufflist.RemoveAt(0);
        }
        else
        {
            thisbuff = new buffbase();
        }
        thisbuff.MyBtBuffMag = this;
       // btbufflist.Add(thisbuff);
        return thisbuff;
    }
    public void CreateOnebuffCB(buffbase thisbuff)
    {
        btbufflist.Add(thisbuff);
    }
    public void BuffDie(buffbase thisbuff)
    {
        btbufflist.Remove(thisbuff);
        diebufflist.Add(thisbuff);
    }


    public void Quit()
    {
        btbufflist.Clear();
        diebufflist.Clear();
    }
}
