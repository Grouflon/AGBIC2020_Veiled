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

    // Start is called before the first frame update
    void Start()
    {
        defaultImage.gameObject.SetActive(true);
        foreach (ScreenVariant variant in variants)
        {
            variant.transform.gameObject.SetActive(false);
        }
    }

    // Update is called once per frame
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
