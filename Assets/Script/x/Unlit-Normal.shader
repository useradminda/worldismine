// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Unlit shader. Simplest possible textured shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "CheapShader/Unlit/Texture" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 100
	
	Pass {  
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.texcoord);
				UNITY_APPLY_FOG(i.fogCoord, col);
				UNITY_OPAQUE_ALPHA(col.a);
				return col;
			}
		ENDCG
	}

   Pass
   {
         Name "SHADOW"
         Blend SrcAlpha OneMinusSrcAlpha
            //Offset[_ZFactor],[_ZUnits]
         ZWrite Off
         Stencil
         {
            Ref  1
            Comp Greater
            Pass Replace
         }
         CGPROGRAM
         #pragma vertex    vertShadow
         #pragma fragment  fragShadow
         #include "UnityCG.cginc"
            struct a2vShadow
         {
            float4 vertex : POSITION;
         };

         struct v2fShadow
         {
            float4 pos : SV_POSITION;
         };

         uniform float4x4 _m4PlaneProject;

         v2fShadow vertShadow(a2vShadow a)
         {
            v2fShadow o;
            float4 p4InWorld = mul(unity_ObjectToWorld, a.vertex);
            p4InWorld = mul(_m4PlaneProject, p4InWorld);
            p4InWorld.xyz /= p4InWorld.w;
            p4InWorld.w = 1;
            o.pos = mul(UNITY_MATRIX_VP, p4InWorld);
            return o;
         }

         //uniform half _ShadowAlpha;
         //uniform half _ZFactor;
         //uniform half _ZUnits;

         half4 fragShadow(v2fShadow v) : COLOR
         {
            //return _ShadowColor;
            return half4(0,0,0,0.2);
         }
         ENDCG

   }   
}

}
