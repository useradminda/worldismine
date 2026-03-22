using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ActionFlow : MonoBehaviour
{
    MaterialPropertyBlock mPropertyBlock;
    Renderer render;
    public float currentTime;
    private float totalTime;

    private float changeTime = 5;

    public float randomT;

    public Material mat;
    // Start is called before the first frame update
    void Awake()
    {
        if(mat != null)
        {
            SetActionInfo(1.5f, mat, null, 0);
        }
    }

    public void SetActionInfo(float totalTime, Material material, MaterialPropertyBlock mpb, float t)
    {
        currentTime = Random.Range(0, 100);
        randomT = currentTime;
        mPropertyBlock = new MaterialPropertyBlock();
        render = GetComponent<Renderer>();
        render.sharedMaterial = material;
        //render.GetPropertyBlock(mPropertyBlock);

        mPropertyBlock.SetFloat("_AnimLen", totalTime);
        mPropertyBlock.SetFloat("_CurrentTime", currentTime);
        //mPropertyBlock.SetColor("_Color", _color);
        // mPropertyBlock.SetTexture("_AnimMap", tex);
        render.SetPropertyBlock(mPropertyBlock);

        //mpb.SetFloat("_AnimLen", totalTime);
        //render.SetPropertyBlock(mpb);
    }

    // Update is called once per frame
    void Update()
    {
        //return;
        currentTime += Time.deltaTime;
        mPropertyBlock.SetFloat("_CurrentTime", currentTime);
        render.SetPropertyBlock(mPropertyBlock);

        //changeTime -= Time.deltaTime;
        //if(changeTime <= 0)
        //{
        //    changeTime = 5f;
        //    int index = Random.Range(0, 4);
        //    render.sharedMaterial = ActionManager.Ins.materials[index];
        //    currentTime = Random.Range(0, 100);
        //    Color _color = ActionManager.Ins.GetColor(index);
        //    mPropertyBlock.SetColor("_Color", _color);
        //    mPropertyBlock.SetFloat("_CurrentTime", currentTime);
        //    render.SetPropertyBlock(mPropertyBlock);
        //}
    }
}
