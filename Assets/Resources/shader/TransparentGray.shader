// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/TransparentGray" {
	Properties {
		_IsColorful ("isColor",float) =0.0
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainTex2 ("Base (RGB), Alpha (A)", 2D) = "white" {}
	}
	
	SubShader
	{
		Tags { "RenderType" = "Transparent" "Queue" = "Transparent" } //Tags { "RenderType"="Opaque" }
		Cull Off
		Lighting Off
		ZWrite Off
		Fog { Mode Off }
		Offset -1, -1
		ZTest off
		Fog { Mode Off }
		Blend SrcAlpha OneMinusSrcAlpha
		
		Pass {
			CGPROGRAM
			//#pragma surface surf Lambert
			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest 
			
			float _IsColorful;
			fixed4 _Color;
			
			sampler2D _MainTex;
			half4 _MainTex_ST;
			
			sampler2D _MainTex2;
			half4 _MainTex2_ST;
			
			struct v2f {
				half4 pos : SV_POSITION;
				half2 uv : TEXCOORD0;
				half2 uv1 : TEXCOORD1;
				fixed4 vertexColor : COLOR;
			};
			
			v2f vert(appdata_full v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);	
				o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
				o.uv1 = TRANSFORM_TEX(v.texcoord1,_MainTex2);
				o.vertexColor =v.color;
						
				return o; 
			}
			
			fixed4 frag(v2f i) : COLOR
			{
				half4 c = tex2D(_MainTex, i.uv.xy);
				half4 c2 = tex2D(_MainTex2, i.uv1.xy);
				half4 fan =(1,1,1,1);
				if(_IsColorful >0.0)
				{
					fan.rgb =c.rgb;
				} else{
					fan.rgb =(c.r +c.g +c.b) *0.33333;
				}
				fan.a =c.a *c2.a *_Color.a;
				
				return fan;
			}
			ENDCG
		}
	}
	
	Fallback Off
}