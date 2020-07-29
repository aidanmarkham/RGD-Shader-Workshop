// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Shader Workshop/Shader Magic Diffuse" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB)", 2D) = "white" {}
	_SinFrequency("Sine Frequency", Float) = 0
	_SinAmplitude("Sine Amplitune", Float) = 0
	_Amount("Effect Amount", Float) = 0
	_EffectOffset("Effect Offset", Vector) = (0,0,0,0)
	_WorldOffset("World Offset", Vector) = (0,0,0,0)
	_CircleClip("World Offset", Vector) = (0,0,0,0)
	_Radius("Radius",  Float) = 1
}
SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 200

CGPROGRAM
#pragma surface surf Lambert vertex:vert addshadow finalcolor:mycolor

sampler2D _MainTex;
fixed4 _Color;

struct Input {
    float2 uv_MainTex;
	float3 worldPos;
};

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


float _SinFrequency;
float _SinAmplitude;
float _Amount;
float4 _EffectOffset;
float4 _WorldOffset;
float3 _CircleClip;
float _Radius;
void vert(inout appdata_full v) {

	float4 vertexWorldPos = mul(unity_ObjectToWorld, v.vertex);

	// Slopey World (sf: 0.1, sa: 5)
    vertexWorldPos.y = vertexWorldPos.y + (sin(vertexWorldPos.z * _SinFrequency) * _SinAmplitude);
	
	// Smol World All Axis (sf: 6, sa: 0.1, wa: y = 20)
	//vertexWorldPos.y = vertexWorldPos.y - ((distance(vertexWorldPos, _WorldSpaceCameraPos) * _SinFrequency) * _SinAmplitude);

	// Smol world (animal crossing)(sf: 0.02, sa: -40, eo: z-35, wo: y-40)
	//float3 trueOffset = _EffectOffset + _WorldSpaceCameraPos;
	//float effectDist = (vertexWorldPos - trueOffset).z;
	//vertexWorldPos.y = vertexWorldPos.y - (sqrt(1 - pow(clamp(effectDist  * _SinFrequency, -1, 1), 2)) * _SinAmplitude);
	

	// Smol world (animal crossing better) (ea: .5, eo: -20)
	//float3 trueOffset = _EffectOffset + _WorldSpaceCameraPos;
	//float effectDist = (vertexWorldPos - trueOffset).z;
	//vertexWorldPos.z -= trueOffset.z;
	//vertexWorldPos.xyz = rotate_vertex_position(vertexWorldPos.xyz, float3(1, 0, 0), effectDist * _Amount);
	//vertexWorldPos.z += trueOffset.z;


	vertexWorldPos += _WorldOffset;
	v.vertex = mul(unity_WorldToObject, vertexWorldPos);
}

void mycolor(Input IN, SurfaceOutput o, inout fixed4 color) {
	//float dist = distance(IN.worldPos, _WorldSpaceCameraPos);

	//color = lerp(color, (1, 1, 1), dist * _Amount);

	//color = 1 + -color;


}

void surf (Input IN, inout SurfaceOutput o) {
    fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
	//o.Albedo = 1 + -c.rgb;

	// Clipping 
	//float distFromCam = distance(IN.worldPos.xz, (_WorldSpaceCameraPos + _CircleClip).xz);
	//clip(-distFromCam - _Radius);

	o.Albedo = c.rgb;
    o.Alpha = c.a;
}
ENDCG
}

Fallback "Legacy Shaders/VertexLit"
}
