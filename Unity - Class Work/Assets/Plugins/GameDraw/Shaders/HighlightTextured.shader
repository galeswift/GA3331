Shader "GameDraw/HighlightTextured" {
    // a single color property
    Properties {
    	_MainTex ("Main Texture",2D) = "white" {}
        _Color ("Main Color", Color) = (1,1,1,1)
        _Emission ("Emmisive Color", Color) = (1,1,1,1)
        _Ambient ("Ambient Color", Color) = (1,1,1,1)
    }
    // define one subshader
    SubShader {
        Pass {
        Tags { "Queue" = "Transparent" }
           Blend SrcAlpha OneMinusSrcAlpha
            Material {
                Diffuse [_Color]
                Ambient [_Ambient]
                 Emission [_Emission]
            }
            Lighting On
            ZWrite Off
            ZTest Always
            Cull Back
            
                  SetTexture [_MainTex] {
                Combine texture * primary DOUBLE, texture * primary
            }
          
            
            
        }
    }
} 