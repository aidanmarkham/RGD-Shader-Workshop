// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Shader Workshop/Screenspace UV" {
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
void surf (Input IN, inout SurfaceOutput o) {

	// Get the screen position
	float2 textureCoordinate = IN.screenPos.xy;

	// Transform by 
	textureCoordinate = textureCoordinate / IN.screenPos.w;
	
	// Get the aspect ratio
	float aspect = _ScreenParams.x / _ScreenParams.y;

	// Transform it so the image maintains it's aspect ratio 
	textureCoordinate.x = textureCoordinate.x * aspect;
	
	// Sample the texture using the texture coordinate we've calculated, scaling by _UVScale
	fixed4 c = tex2D(_MainTex, textureCoordinate * _UVScale);

	// Apply it to the output
    o.Albedo = c.rgb;

    o.Alpha = c.a;
}
ENDCG
}

Fallback "Legacy Shaders/VertexLit"
}
