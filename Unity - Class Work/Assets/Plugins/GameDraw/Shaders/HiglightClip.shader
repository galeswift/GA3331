Shader "GameDraw/HighlightClip" {
    // a single color property
    Properties {
        _Color ("Main Color", Color) = (1,1,1,1)
        _Emission ("Emmisive Color", Color) = (1,1,1,1)
        _Ambient ("Ambient Color", Color) = (1,1,1,1)
    }
    // define one subshader
    SubShader {
	
	  Tags { "Queue" ="Background" }
	  
	  CGPROGRAM
      #pragma surface surf Lambert
      struct Input {
          float3 worldPos;
      };
      float4 _Color;
      float4 _Emission;
	  float4 _Ambient;

      void surf (Input IN, inout SurfaceOutput o) {
        
          o.Albedo =_Color.rgb;
		  o.Emission  = _Emission.rgb;
		          
      }
      ENDCG
	
    }
} 