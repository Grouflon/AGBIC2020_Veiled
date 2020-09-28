using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public struct ScreenVariant
{
    public string name;
    public RectTransform transform;
}

[System.Serializable]
public struct ScreenSequenceItem
{
    public string path;
    public float delay;
}

[System.Serializable]
public struct ScreenSequence
{
    public string name;
    public ScreenSequenceItem[] sequence;
}

public class ScreenController : MonoBehaviour
{
    public RectTransform defaultImage;
    public ScreenVariant[] variants;
    public ScreenSequence[] sequences;

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

    public ScreenSequence getSequence(string _id)
    {
        foreach (ScreenSequence sequence in sequences)
        {
            if (_id == sequence.name)
            {
                return sequence;
            }
        }
        return new ScreenSequence();
    }
}
