using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class ChoiceBoxController : MonoBehaviour
{
    public TMPro.TextMeshProUGUI text;

    [HideInInspector]
    public RectTransform rectTransform { get; private set; }

    public void setVisible(bool _visible)
    {
        gameObject.SetActive(_visible);
    }

    public void setText(string _text)
    {
        text.SetText(_text);
        Vector2 size = text.GetPreferredValues(_text);
        rectTransform.sizeDelta = new Vector2(size.x + 20.0f, rectTransform.sizeDelta.y);
    }

    private void Awake()
    {
        rectTransform = GetComponent<RectTransform>();
        text.autoSizeTextContainer = true;
    }

    private void Update()
    {
    }
}
