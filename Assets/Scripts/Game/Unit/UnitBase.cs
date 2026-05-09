using UnityEngine;
public class UnitBase
{
    private Nebukam.ORCA.Agent agenter;
    public Nebukam.ORCA.Agent Agenter => agenter;

    private UnitProp prop;
    public UnitProp Prop => prop;

    public UnitBase(Nebukam.ORCA.Agent agenter, UnitProp prop, Vector3 forward)
    {
        this.prop = prop;
        this.agenter = agenter;

        agenter.saveMaxSpeed = prop.MaxSpeed;
        
    }

    public UnitBase()
    {
    }
}
