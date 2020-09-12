using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PalettePostProcess : MonoBehaviour
{
    public Color lightColor = Color.white;
    public Color darkColor = Color.black;
    public Shader paletteSwitcherShader;

    private Material m_material;

    void Awake()
    {
        m_material = new Material(paletteSwitcherShader);
    }

    // Postprocess the image
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        m_material.SetColor("_lightColor", lightColor);
        m_material.SetColor("_darkColor", darkColor);
        Graphics.Blit(source, destination, m_material);
    }
}
