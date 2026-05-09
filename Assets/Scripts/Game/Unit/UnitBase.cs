using UnityEngine;
using Unity.Mathematics;
using static Unity.Mathematics.math;

public class UnitBase
{
    private Nebukam.ORCA.Agent agenter;
    public Nebukam.ORCA.Agent Agenter => agenter;

    private UnitProp prop;
    public UnitProp Prop => prop;

    private float3 tarPos;

    public UnitBase(Nebukam.ORCA.Agent agenter, UnitProp prop, Vector3 forward)
    {
        this.prop = prop;
        this.agenter = agenter;
        agenter.saveMaxSpeed = prop.MaxSpeed;
        agenter.maxNeighbors = 20;
        agenter.timeHorizon = 0.1f;   // 距离其他代理检查
        agenter.timeHorizonObst = 4f; // 速度越小，这个值越大，才不会穿透不可行走区域，距离障碍
    }

    public UnitBase()
    {
    }

    public void UpdateMove()
    {
        float agentSpeed = Agenter.saveMaxSpeed;    ////
        Agenter.maxSpeed = agentSpeed;      ////

        Agenter.prefVelocity = normalize(tarPos - Agenter.pos) * agentSpeed;
    }
}
