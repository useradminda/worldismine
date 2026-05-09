using Nebukam.ORCA;
using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;
using ZTools;

// Rvo
public class RvoManager : Singleton<RvoManager>, IManager
{
    private AgentGroup<Agent> agents;
    public AgentGroup<Agent> Agents => agents;

    private ORCA simulation;

    // 等待添加的列表
    private List<Agent> waitingAddList = new List<Agent>();
    // 等待退出的列表
    private List<Agent> waitingRemoveList = new List<Agent>();

    public void ManagerInit()
    {
        agents = new AgentGroup<Agent>();
        simulation = new ORCA();
        simulation.plane = Nebukam.Common.AxisPair.XY;
        simulation.agents = Agents;
    }
    public void ManagerUpdate()
    {
        if (simulation != null)
        {
            simulation.Schedule(Time.deltaTime);
        }
    }

    public void ManagerLateUpdate()
    { 
        if(simulation != null && simulation.TryComplete())
        {

        }
    }

    public void ManagerRefuse()
    {
        agents.Clear();
        agents.Release();
        simulation.staticObstacles = null;
        simulation.agents = null;
        simulation.DisposeAll();
        simulation = null;
    }

    public void ManagerDestroy()
    {
        simulation.DisposeAll();
        simulation = null;
    }

    public Agent AddAgent(float3 bornPoint, float3 forward, float radius)
    {
        Agent agent = AgentFactory.CreateAgent(bornPoint, forward, radius);
        waitingAddList.Add(agent);
        return agent;
    }


    public Agent AddAgent(Agent agent)
    {
        waitingAddList.Add(agent);
        return agent;
    }


    public void AfterUpdate()
    {
        for (int i = 0; i < waitingAddList.Count; i++)
        {
            Nebukam.Common.IVertex a =(Nebukam.Common.IVertex)waitingAddList[i];
            Agents.Add(a);
        }
        waitingAddList.Clear();
    }
}    
     