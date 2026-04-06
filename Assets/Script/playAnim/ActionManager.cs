using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ActionManager : MonoBehaviour
{
    public static ActionManager Ins;

    public List<float> actionTimeList = new List<float>() {1.6667f, 0.53333f, 2.3333f, 1.6667f};
    public List<Texture> textureList = new List<Texture>();
    public List<Material> materials = new List<Material>();

    public GameObject spawnPrefab;
    public int gridWidth;
    public int gridHeight;

    private void Awake()
    {
        Ins = this;
    }

    private void Start()
    {
        MaterialPropertyBlock mPropertyBlock = new MaterialPropertyBlock();
        for (var i = 0; i < gridWidth; i++)
        {
            for (var j = 0; j < gridHeight; j++)
            {
                GameObject gob = Instantiate<GameObject>(spawnPrefab, new Vector3(i * 2f, 0, j * 2f), Quaternion.identity);
                gob.transform.eulerAngles = new Vector3(-90, 0, 0);
                ActionFlow1 af = gob.AddComponent<ActionFlow1>();
                int randomIndex =  Random.Range(0, materials.Count);
                af.SetActionInfo(actionTimeList[randomIndex], materials[randomIndex], mPropertyBlock, 0.5f * j);
            }
        }
    }

    //public Color GetColor(int index)
    //{
    //    if(index == 0)
    //    {
    //        return new Color(1, 0, 0);
    //    }
    //    if(index == 1)
    //    {
    //        return new Color(0, 1, 0);
    //    }
    //    if(index == 2)
    //    {
    //        return new Color(0, 0, 1);
    //    }
    //    if (index == 3)
    //    {
    //        return new Color(1, 1, 1);
    //    }
    //    return new Color(1, 1, 1);
    //}
}
