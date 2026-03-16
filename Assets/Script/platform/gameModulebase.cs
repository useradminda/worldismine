using UnityEngine;
using System.Collections;
using System.Collections.Generic;
public class gameModulebase
{
	public gameModulebase()
	{
		ModuleMgr.Ins.addSonModule(this);
	}
	public virtual void re_login_game()
	{
		
	}
	public virtual void init()
	{
		
	}
}


public class ModuleMgr
{
	static ModuleMgr _ins = null;
	public List<gameModulebase> list_modules = new List<gameModulebase>();
	public static ModuleMgr Ins
	{
		get{
			if(_ins == null)
			{
				_ins = new ModuleMgr();
			}
			return _ins;
		}
		
	}
	public void addSonModule(gameModulebase mod)
	{
		list_modules.Add(mod);
	}
	public void re_login_game()
	{
		int len = list_modules.Count;
		for(int i=0;i<len;i++)
		{
			gameModulebase mod = list_modules[i];
			mod.re_login_game();
		}
	}
}

