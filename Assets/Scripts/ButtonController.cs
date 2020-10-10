using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ButtonController : MonoBehaviour
{
    public TMPro.TextMeshProUGUI text;
    public Image border;
    public Sprite darkBorder;
    public Sprite lightBorder;

    public bool invert = false;

    void Awake()
    {
        setHovered(false);    
    }

    public void setHovered(bool _hovered)
    {
        if ((_hovered && !invert) || (!_hovered && invert))
        {
            text.color = Color.black;
            border.sprite = lightBorder;
        }
        else
        {
            text.color = Color.white;
            border.sprite = darkBorder;
        }
    }
}
