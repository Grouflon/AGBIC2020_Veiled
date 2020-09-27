using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public struct ScreenVariant
{
    public string name;
    public RectTransform transform;
}

public class ScreenController : MonoBehaviour
{
    public RectTransform defaultImage;
    public ScreenVariant[] variants;

    private void Awake()
    {
        defaultImage.gameObject.SetActive(true);
        foreach (ScreenVariant variant in variants)
        {
            variant.transform.gameObject.SetActive(false);
        }
    }

    void Start()
    {
        
    }

    void Update()
    {
        
    }

    public void setVariant(string _id)
    {
        defaultImage.gameObject.SetActive(false);
        foreach (ScreenVariant variant in variants)
        {
            variant.transform.gameObject.SetActive(false);
        }

        if (_id.Length == 0)
        {
            defaultImage.gameObject.SetActive(true);
        }
        else
        {
            foreach (ScreenVariant variant in variants)
            {
                if (variant.name == _id)
                {
                    variant.transform.gameObject.SetActive(true);
                    return;
                }
            }
        }
    }
}
