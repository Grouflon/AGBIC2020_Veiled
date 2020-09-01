using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.Playables;
using Ink.Runtime;
using TMPro;

using System.Text.RegularExpressions;

[System.Serializable]
public struct Zone
{
    public string id;
    public GameObject prefab;
}

public class GameManager : MonoBehaviour
{
    public RectTransform cursorTransform;
    public TextAsset inkAsset;
    public TMPro.TextMeshProUGUI textContainer;
    public ChoiceBoxController choiceBox;
    public PlayableDirector backgroundMask;
    public PlayableAsset backgroundMaskReveal;
    public PlayableAsset backgroundMaskHide;
    public RectTransform backgroundContainer;
    public List<Zone> zones;

    private Story m_story;
    private bool m_isAnimatingText = false;
    private string m_currentLocation = "";

    bool IsTimelinePlaying()
    {
        return backgroundMask.state == PlayState.Playing && backgroundMask.time != backgroundMask.duration;
    }

    // Start is called before the first frame update
    void Start()
    {
        textContainer.text = "";

        m_story = new Story(inkAsset.text);
        Cursor.visible = false;

        StartCoroutine(OnAdvanceStory());
    }

    // Update is called once per frame
    void Update()
    {
        float xMouseRatio = Input.mousePosition.x / Screen.width;
        float yMouseRatio = (Input.mousePosition.y - Screen.height) / Screen.height;
        Vector3 cursorPosition = new Vector3((xMouseRatio - 0.5f) * 640.0f, (yMouseRatio + 0.5f) * 360.0f, cursorTransform.localPosition.z);
        cursorTransform.localPosition = cursorPosition;
        choiceBox.rectTransform.localPosition = cursorPosition + new Vector3(4.0f, -1.0f, 0.0f);

        choiceBox.gameObject.SetActive(false);
        cursorTransform.gameObject.SetActive(false);

        bool canInteract = !IsTimelinePlaying() && !m_isAnimatingText && m_story.currentChoices.Count > 0;
        if (canInteract)
        {
            cursorTransform.gameObject.SetActive(true);

            PointerEventData pointerEventData = new PointerEventData(EventSystem.current);
            pointerEventData.position = Input.mousePosition;

            List<RaycastResult> raycastResults = new List<RaycastResult>();
            EventSystem.current.RaycastAll(pointerEventData, raycastResults);
            foreach (RaycastResult result in raycastResults)
            {
                ImageZoneController imageZone = result.gameObject.GetComponent<ImageZoneController>();
                if (imageZone)
                {
                    foreach (Choice choice in m_story.currentChoices)
                    {
                        string zone;
                        string text = StripTextFromZoneTag(choice.text, out zone);

                        if (zone == imageZone.id)
                        {
                            choiceBox.gameObject.SetActive(true);
                            choiceBox.setText(text);

                            if (Input.GetMouseButtonDown(0))
                            {
                                textContainer.text = "";
                                m_story.ChooseChoiceIndex(choice.index);
                                StartCoroutine(OnAdvanceStory());
                            }
                            break;
                        }
                    }
                }
            }
        }
    }

    string StripTextFromZoneTag(string _text, out string _zone)
    {
        _zone = "";

        Regex r = new Regex(@"(\<.*?\>)");
        Match match = r.Match(_text);
        if (match.Success)
        {
            _zone = match.Groups[0].Value.Substring(1, match.Groups[0].Value.Length - 2);
        }
        return r.Replace(_text, "").Trim();
    }

    IEnumerator OnAdvanceStory()
    {
        m_isAnimatingText = true;

        while (m_story.canContinue)
        {
            yield return new WaitForSeconds(1.0f);
            string line = m_story.Continue();

            foreach (string tag in m_story.currentTags)
            {
                string[] split = tag.Split(':');
                if (split.Length >= 2)
                {
                    if (split[0].Trim() == "location")
                    {
                        yield return StartCoroutine(GoToLocation(split[1].Trim()));
                        yield return new WaitForSeconds(1.0f);
                    }
                }
            }

            textContainer.text = textContainer.text + line + "\n\n";
            yield return new WaitForSeconds(1.0f);
        }
        m_isAnimatingText = false;
        yield return null;
    }

    IEnumerator GoToLocation(string _location)
    {
        textContainer.text = "";
        if (_location == m_currentLocation)
        {
            yield return new WaitForSeconds(1.0f);
        }
        else
        {
            if (m_currentLocation != "")
            {
                backgroundMask.Play(backgroundMaskHide, DirectorWrapMode.Hold);
                yield return new WaitUntil(() => !IsTimelinePlaying());
            }
            
            m_currentLocation = _location;
            yield return new WaitForSeconds(1.0f);

            if (m_currentLocation != "")
            {
                for (int i = 0; i < backgroundContainer.childCount; ++i)
                {
                    Destroy(backgroundContainer.GetChild(i).gameObject);
                }
                foreach (Zone zone in zones)
                {
                    if (zone.id == m_currentLocation)
                    {
                        Instantiate(zone.prefab, backgroundContainer);
                        break;
                    }
                }

                // Play animation
                backgroundMask.Play(backgroundMaskReveal, DirectorWrapMode.Hold);
                yield return new WaitUntil(() => !IsTimelinePlaying());
            }
        }
        yield return null;
    }
}
