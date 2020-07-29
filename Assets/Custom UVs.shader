// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Shader Workshop/Custom UV" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB)", 2D) = "white" {}
	_UVScale ("UV Scale", Vector) = (1,1,1)
}
SubShader{
	Tags { "RenderType" = "Opaque" }
	LOD 200

CGPROGRAM
#pragma surface surf Lambert

sampler2D _MainTex;
fixed4 _Color;
float4 _MainTex_ST;

struct Input {
	float2 uv_MainTex;
	float3 worldPos;
	float4 screenPos;
};

float3 _UVScale;

struct TriplanarUV {
	float2 x, y, z;
};

TriplanarUV GetTriplanarUV(float3 position) {
	TriplanarUV triUV;
	triUV.x = position.zy;
	triUV.y = position.xz;
	triUV.z = position.xy;
	return triUV;
}

float3 GetWeights(float3 normal) {
	float3 triW = abs(normal);
	return triW / (triW.x + triW.y + triW.z);
}

void surf (Input IN, inout SurfaceOutput o) {

	/*
	TriplanarUV triUV = GetTriplanarUV(IN.worldPos * _UVScale);

	float3 albedoX = tex2D(_MainTex, triUV.x).rgb;
	float3 albedoY = tex2D(_MainTex, triUV.y).rgb;
	float3 albedoZ = tex2D(_MainTex, triUV.z).rgb;

	float3 triW = GetWeights(o.Normal);
	float3 c = albedoX * triW.x + albedoY * triW.y + albedoZ * triW.z;
	*/

	float2 textureCoordinate = IN.screenPos.xy / IN.screenPos.w;
	float aspect = _ScreenParams.x / _ScreenParams.y;
	textureCoordinate.x = textureCoordinate.x * aspect;
	textureCoordinate = TRANSFORM_TEX(textureCoordinate, _MainTex);


	fixed4 c = tex2D(_MainTex, textureCoordinate * _UVScale);
    o.Albedo = c.rgb;
    o.Alpha = 1;
}
ENDCG
}

Fallback "Legacy Shaders/VertexLit"
}
