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
