/*
 * Created by jiadong chen
 * https://jiadong-chen.medium.com/
 * 用来烘焙动作贴图。烘焙对象使用Animation组件，并且在导入时设置Rig为Legacy
 */
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.Linq;
using System.IO;

/// <summary>
/// 保存需要烘焙的动画的相关数据
/// </summary>
public struct AnimData
{
    #region FIELDS

    private int _vertexCount;
    private int _mapWidth;
    private readonly List<AnimationState> _animClips;
    private string _name;

    private  Animation _animation;
    private SkinnedMeshRenderer _skin;
    private SkinnedMeshRenderer _horseSkin;

    public List<MeshFilter> MeshList;    ////

    public List<AnimationState> AnimationClips => _animClips;
    public int MapWidth => _mapWidth;
    public string Name => _name;

    #endregion

    public AnimData(Animation anim, SkinnedMeshRenderer smr, SkinnedMeshRenderer horseSkin, string goName, GameObject _gob)////(Animation anim, SkinnedMeshRenderer smr, string goName, GameObject _gob) ////(Animation anim, SkinnedMeshRenderer smr, string goName)
    {
        _vertexCount = smr.sharedMesh.vertexCount;      
        _mapWidth = Mathf.NextPowerOfTwo(_vertexCount);
        _animClips = new List<AnimationState>(anim.Cast<AnimationState>());
        _animation = anim;
        _skin = smr;
        _horseSkin = horseSkin;
        _name = goName;


        MeshList = new List<MeshFilter>();    ////
        _vertexCount = 0;
        RecursivelyPrintTransformNames(_gob.transform);
        for(int i = 0; i < MeshList.Count; i++)
        {
            _vertexCount += MeshList[i].sharedMesh.vertexCount;
        }
        _vertexCount += smr.sharedMesh.vertexCount;
        if (horseSkin != null)
            _vertexCount += _horseSkin.sharedMesh.vertexCount;
        _mapWidth = Mathf.NextPowerOfTwo(_vertexCount); ////
    }

    #region METHODS

    public void AnimationPlay(string animName)
    {
        _animation.Play(animName);
    }

    public void SampleAnimAndBakeMesh(ref Mesh m)
    {
        SampleAnim();
        BakeMesh(ref m);
    }

    private void SampleAnim()
    {
        if (_animation == null)
        {
            Debug.LogError("animation is null!!");
            return;
        }

        _animation.Sample();
    }

    private void BakeMesh(ref Mesh m)
    {
        if (_skin == null)
        {
            Debug.LogError("skin is null!!");
            return;
        }

       

        List<CombineInstance> combineInstances = new List<CombineInstance>(); ////   

        Mesh _humanMesh = new Mesh();       ////
        _skin.BakeMesh(_humanMesh);         ////

        combineInstances.Add(new CombineInstance()
        {
            mesh = _humanMesh,//_skin.sharedMesh,
            transform = _skin.transform.localToWorldMatrix
        });

        if(_horseSkin != null)
        {
            Mesh _horseMesh = new Mesh();
            _horseSkin.BakeMesh(_horseMesh);

            combineInstances.Add(new CombineInstance()
            {
                mesh = _horseMesh,//_skin.sharedMesh,
                transform = _horseSkin.transform.localToWorldMatrix
            });
        }

        for (int i = 0; i < MeshList.Count;  i++)
        {
            combineInstances.Add(new CombineInstance()
            {
                mesh = MeshList[i].sharedMesh,
                transform = MeshList[i].transform.localToWorldMatrix
            });
        }
        
        m.CombineMeshes(combineInstances.ToArray(), true); ////

       //// _skin.BakeMesh(m); ////
    }

    public void RecursivelyPrintTransformNames(Transform parent) ////
    {
        if(parent.gameObject.activeInHierarchy == true && parent.GetComponent<MeshFilter>() != null)
        {
            MeshList.Add(parent.GetComponent<MeshFilter>());
            
        }    
        foreach (Transform child in parent)
        {
            RecursivelyPrintTransformNames(child);
        }
    }



    #endregion

}

/// <summary>
/// 烘焙后的数据
/// </summary>
public struct BakedData
{
    #region FIELDS

    private readonly string _name;
    private readonly float _animLen;
    private readonly byte[] _rawAnimMap;
    private readonly int _animMapWidth;
    private readonly int _animMapHeight;

    private Mesh _mesh;    ////

    #endregion

    public BakedData(string name, float animLen, Texture2D animMap, Mesh mesh) //// (string name, float animLen, Texture2D animMap)
    {
        _name = name;
        _animLen = animLen;
        _animMapHeight = animMap.height;
        _animMapWidth = animMap.width;
        _rawAnimMap = animMap.GetRawTextureData();
        _mesh = mesh;
    }

    public int AnimMapWidth => _animMapWidth;

    public string Name => _name;

    public float AnimLen => _animLen;

    public byte[] RawAnimMap => _rawAnimMap;

    public int AnimMapHeight => _animMapHeight;

    public Mesh MeshData => _mesh; ////
}

/// <summary>
/// 烘焙器
/// </summary>
public class AnimMapBaker{

    #region FIELDS

    private AnimData? _animData = null;
    private Mesh _bakedMesh;
    private readonly List<Vector3> _vertices = new List<Vector3>();
    private readonly List<BakedData> _bakedDataList = new List<BakedData>();

    #endregion

    #region METHODS

    public void SetAnimData(GameObject go)
    {
        if(go == null)
        {
            Debug.LogError("go is null!!");
            return;
        }

        var anim = go.GetComponent<Animation>();
        var smr = go.GetComponentInChildren<SkinnedMeshRenderer>();

        SkinnedMeshRenderer horseSkin = null;           /////
        for(int i = 0; i < go.transform.childCount; i++)
        {
            if(go.transform.GetChild(i).name.Contains("Horse"))
            {
                if (go.transform.GetChild(i).gameObject.activeInHierarchy == false)
                    continue;
                horseSkin = go.transform.GetChild(i).GetComponentInChildren<SkinnedMeshRenderer>(false);
                if (horseSkin == null)
                    continue;
                break;
            }
        }

        if(anim == null || smr == null)
        {
            Debug.LogError("anim or smr is null!!");
            return;
        }
        _bakedMesh = new Mesh();
        _animData = new AnimData(anim, smr, horseSkin, go.name, go);  ////(anim, smr, go.name)
    }

    public List<BakedData> Bake()
    {
        if(_animData == null)
        {
            Debug.LogError("bake data is null!!");
            return _bakedDataList;
        }

        //每一个动作都生成一个动作图
        foreach (var t in _animData.Value.AnimationClips)
        {
            if(!t.clip.legacy)
            {
                Debug.LogError(string.Format($"{t.clip.name} is not legacy!!"));
                continue;
            }
            BakePerAnimClip(t);
        }

        return _bakedDataList;
    }

    private void BakePerAnimClip(AnimationState curAnim)
    {
        var curClipFrame = 0;
        float sampleTime = 0;
        float perFrameTime = 0;

        curClipFrame = Mathf.ClosestPowerOfTwo((int)(curAnim.clip.frameRate * curAnim.length));
        perFrameTime = curAnim.length / curClipFrame; ;

        var animMap = new Texture2D(_animData.Value.MapWidth, curClipFrame, TextureFormat.RGBAHalf, true);
        animMap.name = string.Format($"{_animData.Value.Name}_{curAnim.name}.animMap");
        _animData.Value.AnimationPlay(curAnim.name);

        for (var i = 0; i < curClipFrame; i++)
        {
            curAnim.time = sampleTime;

            _animData.Value.SampleAnimAndBakeMesh(ref _bakedMesh);

            for(var j = 0; j < _bakedMesh.vertexCount; j++)
            {
                var vertex = _bakedMesh.vertices[j];
                animMap.SetPixel(j, i, new Color(vertex.x, vertex.y, vertex.z));
            }

            sampleTime += perFrameTime;
        }
        animMap.Apply();

        _bakedDataList.Add(new BakedData(animMap.name, curAnim.clip.length, animMap, _bakedMesh));  ////
    }

    #endregion

}
