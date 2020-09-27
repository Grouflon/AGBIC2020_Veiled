using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public enum CursorMode
{
    None,
    Idle,
    Highlight,
    Clock
}

public class CursorController : MonoBehaviour
{
    public RectTransform crossIdle;
    public RectTransform crossHighlight;
    public RectTransform clock;
    public ChoiceBoxController choiceBox;

    [HideInInspector]
    public RectTransform rectTransform { get; private set; }

    private void Awake()
    {
        rectTransform = GetComponent<RectTransform>();
    }

    private void Update()
    {
        float xMouseRatio = Input.mousePosition.x / Screen.width;
        float yMouseRatio = (Input.mousePosition.y - Screen.height) / Screen.height;
        Vector3 cursorPosition = new Vector3(Mathf.Round((xMouseRatio - 0.5f) * 640.0f), Mathf.Round((yMouseRatio + 0.5f) * 360.0f), rectTransform.localPosition.z);
        rectTransform.localPosition = cursorPosition;

        // OFFSET CHOICE BOX
        float xOffset = 4.0f;
        float yOffset = 4.0f;
        float x = 0.0f;
        float y = xOffset;
        float dx = cursorPosition.x + 320.0f + xOffset + choiceBox.rectTransform.sizeDelta.x;
        if (dx > 460.0f)
        {
            x = -xOffset - choiceBox.rectTransform.sizeDelta.x;
        }
        else
        {
            x = xOffset;
        }

        float dy = cursorPosition.y + 180.0f - yOffset - choiceBox.rectTransform.sizeDelta.y;
        if (dy <= 22.0f)
        {
            y = yOffset + choiceBox.rectTransform.sizeDelta.y;
        }
        else
        {
            y = -yOffset + 3.0f;
        }
        choiceBox.rectTransform.localPosition = new Vector3(x, y, choiceBox.rectTransform.localPosition.z);
    }

    public void setChoiceBoxEnabled(bool _enabled)
    {
        choiceBox.gameObject.SetActive(_enabled);
    }

    public void setChoiceBoxText(string _text)
    {
        choiceBox.setText(_text);
    }

    public void setMode(CursorMode _mode)
    {
        if (_mode == m_mode)
            return;

        switch(m_mode)
        {
            case CursorMode.Idle:
                {
                    crossIdle.gameObject.SetActive(false);
                }
                break;
            case CursorMode.Highlight:
                {
                    crossHighlight.gameObject.SetActive(false);
                }
                break;
            case CursorMode.Clock:
                {
                    clock.gameObject.SetActive(false);
                }
                break;
            default:
                break;
        }

        m_mode = _mode;

        switch (m_mode)
        {
            case CursorMode.Idle:
                {
                    crossIdle.gameObject.SetActive(true);
                }
                break;
            case CursorMode.Highlight:
                {
                    crossHighlight.gameObject.SetActive(true);
                }
                break;
            case CursorMode.Clock:
                {
                    clock.gameObject.SetActive(true);
                }
                break;
            default:
                break;
        }
    }

    private CursorMode m_mode = CursorMode.None;
}
