Shader "Custom/Curtain" {
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_Progress("Animation Progress", Float) = 1.0
		_StepHeight("Curtain Step Height", Float) = 40.0
		_ScreenHeight("Screen Height", Float) = 360.0
		_Down("Should unfold down", Int) = 0
	}
	SubShader{
		Tags {"Queue" = "Transparent" "IgnoreProjector" = "True"}
		Pass {
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag

			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform float _Progress;
			uniform float _StepHeight;
			uniform float _ScreenHeight;
			uniform int _Down;

			float4 frag(v2f_img i) : COLOR {
				float y = 0.0f;
				if (_Down)
				{
					y = (1.f - i.uv.y) * _ScreenHeight;
				}
				else
				{
					y = i.uv.y * _ScreenHeight;
				}

				float4 c = tex2D(_MainTex, i.uv);
				if ((y / _StepHeight) % 1.0f < _Progress)
				{
					return float4(c.x, c.y, c.z, c.w);
				}
				else
				{
					return float4(c.x, c.y, c.z, 0.0);
				}
			}
			ENDCG
		}
	}
}