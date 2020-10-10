using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[ExecuteInEditMode]
public class CurtainController : MonoBehaviour
{
    public float progress = 0.0f;
    public bool down = false;
    public float stepHeight = 40.0f;
    public float imageHeight = 360.0f;
    public Image image;
    public Shader curtainShader;

    // Start is called before the first frame update
    void Start()
    {
        image.material = new Material(curtainShader);
    }

    // Update is called once per frame
    void Update()
    {
        image.material.SetFloat("_Progress", progress);
        image.material.SetInt("_Down", down ? 1 : 0);
        image.material.SetFloat("_StepHeight", stepHeight);
        image.material.SetFloat("_ScreenHeight", imageHeight);
    }

    private void OnWillRenderObject()
    {
        
    }
}
