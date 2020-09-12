Shader "Hidden/PaletteSwitcher" {
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_lightColor("Palette Light Color", Color) = (1,1,1,1)
		_darkColor("Palette Dark Color", Color) = (0,0,0,1)
	}
	SubShader{
		Pass {
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag

			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform fixed4 _lightColor;
			uniform fixed4 _darkColor;

			float4 frag(v2f_img i) : COLOR {
				float4 c = tex2D(_MainTex, i.uv);
				float4 inv_c = float4(1,1,1,1) - c;
				return float4(
					c.x * _lightColor.x + inv_c.x * _darkColor.x,
					c.y * _lightColor.y + inv_c.y * _darkColor.y,
					c.z * _lightColor.z + inv_c.z * _darkColor.z,
					1.0
				);
			}
			ENDCG
		}
	}
}