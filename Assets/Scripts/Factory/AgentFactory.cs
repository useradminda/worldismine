using Nebukam;
using Nebukam.ORCA;
using System.Diagnostics;
using Unity.Mathematics;
public static class AgentFactory
{
    // 创建一个智能体
    public static Agent CreateAgent(float3 bornPoint, float3 forward, float radius)
    {      
        Agent agent = Pool.Rent<Agent>();
        agent.pos = bornPoint;
        agent.prefVelocity = forward;
        agent.velocity = forward;
        agent.radius = radius;
        agent.radiusObst = radius;
        return agent;
    }
}
