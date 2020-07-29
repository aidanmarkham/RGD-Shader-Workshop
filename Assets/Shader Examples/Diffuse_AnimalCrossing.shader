// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Shader Workshop/Animal Crossing" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB)", 2D) = "white" {}
	_EffectOffset("Effect Offset", Vector) = (0,0,0,0)
	_Amount("Effect Amount", Float) = 0
}
SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 200

CGPROGRAM
// We add addshadow here so it happens after 
#pragma surface surf Lambert addshadow
#pragma vertex vert
sampler2D _MainTex;
fixed4 _Color;

struct Input {
    float2 uv_MainTex;
};

// Converted to CG Shader language from 
//https://www.geeks3d.com/20141201/how-to-rotate-a-vertex-by-a-quaternion-in-glsl/
float4 quat_from_axis_angle(float3 axis, float angle)
{
	float4 qr;
	float half_angle = (angle * 0.5) * 3.14159 / 180.0;
	qr.x = axis.x * sin(half_angle);
	qr.y = axis.y * sin(half_angle);
	qr.z = axis.z * sin(half_angle);
	qr.w = cos(half_angle);
	return qr;
}
float4 quat_conj(float4 q)
{
	return float4(-q.x, -q.y, -q.z, q.w);
}
float4 quat_mult(float4 q1, float4 q2)
{
	float4 qr;
	qr.x = (q1.w * q2.x) + (q1.x * q2.w) + (q1.y * q2.z) - (q1.z * q2.y);
	qr.y = (q1.w * q2.y) - (q1.x * q2.z) + (q1.y * q2.w) + (q1.z * q2.x);
	qr.z = (q1.w * q2.z) + (q1.x * q2.y) - (q1.y * q2.x) + (q1.z * q2.w);
	qr.w = (q1.w * q2.w) - (q1.x * q2.x) - (q1.y * q2.y) - (q1.z * q2.z);
	return qr;
}
float3 rotate_vertex_position(float3 position, float3 axis, float angle)
{
	float4 qr = quat_from_axis_angle(axis, angle);
	float4 qr_conj = quat_conj(qr);
	float4 q_pos = float4(position.x, position.y, position.z, 0);

	float4 q_tmp = quat_mult(qr, q_pos);
	qr = quat_mult(q_tmp, qr_conj);

	return float3(qr.x, qr.y, qr.z);
}

float4 _EffectOffset;
float _Amount;

void vert(inout appdata_full v) {
	// By default this shader operates in object space
	float4 vertexWorldPos = mul(unity_ObjectToWorld, v.vertex);
	
	// offset from camera position, as the camera position shouldn't be the center
	float3 offset = _WorldSpaceCameraPos + _EffectOffset;

	// figure out this vertex's distance from that center point
	float effectDistance = vertexWorldPos.z - offset.z;

	// We want this effect to move with the camera, so we need to offset 
	vertexWorldPos.z -= offset.z;
	
	// Do the rotation
	vertexWorldPos.xyz = rotate_vertex_position(vertexWorldPos.xyz, float3(1, 0, 0), effectDistance * _Amount);

	// and then undo the offset
	vertexWorldPos.z += offset.z;

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
