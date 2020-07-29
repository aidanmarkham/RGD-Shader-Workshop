// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Shader Workshop/Clip Circle" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB)", 2D) = "white" {}
	_CircleClip("Circle Center", Vector) = (0,0,0,0)
	_Radius("Circle Radius",  Float) = 1
}
SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 200

CGPROGRAM
#pragma surface surf Lambert addshadow
sampler2D _MainTex;
fixed4 _Color;

struct Input {
    float2 uv_MainTex;
	float3 worldPos;
};

float4 _CircleClip;
float _Radius;

void surf (Input IN, inout SurfaceOutput o) {

	// Get our distance from the clipping center
	float distFromCam = distance(IN.worldPos.xz, (_WorldSpaceCameraPos + _CircleClip).xz);
	
	// If we're more that _Radius units from the center, clip the pixel
	clip(-distFromCam - _Radius);

    fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
    o.Albedo = c.rgb;
    o.Alpha = c.a;
}
ENDCG
}

Fallback "Legacy Shaders/VertexLit"
}
