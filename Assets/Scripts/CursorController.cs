using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public enum CursorMode
{
    None,
    Idle,
    Highlight,
    Clock,
    Skip,
}

public class CursorController : MonoBehaviour
{
    public RectTransform crossIdle;
    public RectTransform crossHighlight;
    public RectTransform crossSkip;
    public RectTransform clock;
    public ChoiceBoxController choiceBox;
    public RectTransform gameCanvas;

    [HideInInspector]
    public RectTransform rectTransform { get; private set; }

    private void Awake()
    {
        rectTransform = GetComponent<RectTransform>();
    }

    private void Update()
    {
        float xMouseRatio = (Input.mousePosition.x - (Screen.width * 0.5f)) / gameCanvas.sizeDelta.x;
        float yMouseRatio = (Input.mousePosition.y - (Screen.height * 0.5f)) / gameCanvas.sizeDelta.y;
        Vector3 cursorPosition = new Vector3(Mathf.Round((xMouseRatio) * 1280.0f), Mathf.Round((yMouseRatio) * 720.0f), rectTransform.localPosition.z);
        /*Vector3 cursorPosition = new Vector3(
            Mathf.Round(Input.mousePosition.x * 0.5f) * 2.0f,
            Mathf.Round(Input.mousePosition.y * 0.5f) * 2.0f,
            rectTransform.localPosition.z
        );*/
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
            case CursorMode.Skip:
                {
                    crossSkip.gameObject.SetActive(false);
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
            case CursorMode.Skip:
                {
                    crossSkip.gameObject.SetActive(true);
                }
                break;
            default:
                break;
        }
    }

    private CursorMode m_mode = CursorMode.None;
}
