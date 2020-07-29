// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Shader Workshop/Waves" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB)", 2D) = "white" {}
	_SinFrequency("Sine Frequency", Float) = 0
	_SinAmplitude("Sine Amplitune", Float) = 0
}
SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 200

CGPROGRAM
#pragma surface surf Lambert addshadow
#pragma vertex vert
sampler2D _MainTex;
fixed4 _Color;

struct Input {
    float2 uv_MainTex;
};

float _SinFrequency;
float _SinAmplitude;
void vert(inout appdata_full v) {

	// Get the vertex position in world space
	float4 vertexWorldPos = mul(unity_ObjectToWorld, v.vertex);

	// transform it using trigonometry
	vertexWorldPos.y = vertexWorldPos.y + (sin(vertexWorldPos.z * _SinFrequency) * _SinAmplitude);
	
	// transform it back to object space
	v.vertex = mul(unity_WorldToObject, vertexWorldPos);
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
