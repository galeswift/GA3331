Shader "Painter/Diffuse" {
    // a single color property
    Properties {
        _Color ("Main Color", Color) = (1,1,1,1)
        
    }
    // define one subshader
    SubShader {
        Pass {
        Tags { "Queue" = "Overlay" }
           Blend SrcAlpha OneMinusSrcAlpha
            Material {
                Diffuse [_Color]
                Ambient [_Color]
                 Emission [_Color]
            }
            Lighting On
            ZWrite Off
			Cull Off
            ZTest Always
            
        }
    }
} 