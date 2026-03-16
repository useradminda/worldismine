using UnityEngine;

public class CheapShadow
{
    //InitLight(new Vector3(-1, -3, -1), transform.position.y);        	

    const float c_SunDistance = 500;
    public static void InitLight(Vector3 vLightDir,float fGroundHeight)
    {
        Vector3 v3LightDir = vLightDir.normalized;
        Vector3 p3ShadowPlanePoint = new Vector3(0, fGroundHeight, 0);
        Vector3 p3LightPos = p3ShadowPlanePoint-v3LightDir*c_SunDistance;

        Vector3 v3ShadowPlaneNormal = new Vector3(0, 1, 0);
        Vector3 v3SunToPlanePoint = p3ShadowPlanePoint - p3LightPos;
        Matrix4x4 m4Project = Matrix4x4.identity;

        m4Project[0, 0] = v3ShadowPlaneNormal.x * p3LightPos.x + Vector3.Dot(v3SunToPlanePoint, v3ShadowPlaneNormal);
        m4Project[1, 0] = v3ShadowPlaneNormal.x * p3LightPos.y;
        m4Project[2, 0] = v3ShadowPlaneNormal.x * p3LightPos.z;
        m4Project[3, 0] = v3ShadowPlaneNormal.x;

        m4Project[0, 1] = v3ShadowPlaneNormal.y * p3LightPos.x;
        m4Project[1, 1] = v3ShadowPlaneNormal.y * p3LightPos.y + Vector3.Dot(v3SunToPlanePoint, v3ShadowPlaneNormal);
        m4Project[2, 1] = v3ShadowPlaneNormal.y * p3LightPos.z;
        m4Project[3, 1] = v3ShadowPlaneNormal.y;

        m4Project[0, 2] = v3ShadowPlaneNormal.z * p3LightPos.x;
        m4Project[1, 2] = v3ShadowPlaneNormal.z * p3LightPos.y;
        m4Project[2, 2] = v3ShadowPlaneNormal.z * p3LightPos.z + Vector3.Dot(v3SunToPlanePoint, v3ShadowPlaneNormal);
        m4Project[3, 2] = v3ShadowPlaneNormal.z;

        m4Project[0, 3] = -Vector3.Dot(p3ShadowPlanePoint, v3ShadowPlaneNormal) * p3LightPos.x;
        m4Project[1, 3] = -Vector3.Dot(p3ShadowPlanePoint, v3ShadowPlaneNormal) * p3LightPos.y;
        m4Project[2, 3] = -Vector3.Dot(p3ShadowPlanePoint, v3ShadowPlaneNormal) * p3LightPos.z;
        m4Project[3, 3] = -Vector3.Dot(p3ShadowPlanePoint, v3ShadowPlaneNormal) + Vector3.Dot(v3SunToPlanePoint, v3ShadowPlaneNormal);

        Shader.SetGlobalMatrix("_m4PlaneProject", m4Project);
    }
}