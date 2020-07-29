// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Shader Workshop/Inflate" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB)", 2D) = "white" {}
	_InflateAmount("Inflate Amount", Range (-0.01, 0.01)) = 0
}
SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 200

CGPROGRAM
#pragma surface surf Lambert
#pragma vertex vert
sampler2D _MainTex;
fixed4 _Color;
float _InflateAmount;

struct Input {
    float2 uv_MainTex;
};

void vert(inout appdata_full v) {
	// add the normal to the vertex
	v.vertex.xyz += v.normal * _InflateAmount;
}

void surf (Input IN, inout SurfaceOutput o) {
    fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
    o.Albedo = c.rgb;
    o.Alpha = c.a;
}
ENDCG
}

Fallback "Legacy Shaders/VertexLit"
}
