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

[System.Serializable]
public struct Palette
{
    public string name;
    public Color lightColor;
    public Color darkColor;
}

public class GameManager : MonoBehaviour
{
    [Header("Gameplay")]
    public List<Zone> zones;
    public List<Palette> palettes;

    [Header("Internal")]
    public CursorController cursor;
    public TextAsset inkAsset;
    public TMPro.TextMeshProUGUI textContainer;
    public PlayableDirector backgroundMask;
    public PlayableAsset backgroundMaskReveal;
    public PlayableAsset backgroundMaskHide;
    public RectTransform backgroundContainer;
    public PalettePostProcess palettePostProcess;

    private Story m_story;
    private bool m_isAnimatingText = false;
    private string m_currentLocation = "";

    public void setPalette(string _name)
    {
        foreach (Palette p in palettes)
        {
            if (p.name == _name)
            {
                palettePostProcess.lightColor = p.lightColor;
                palettePostProcess.darkColor = p.darkColor;
                return;
            }
        }
        palettePostProcess.lightColor = Color.white;
        palettePostProcess.darkColor = Color.black;
    }

    bool IsTimelinePlaying()
    {
        return backgroundMask.state == PlayState.Playing && backgroundMask.time != backgroundMask.duration;
    }

    // Start is called before the first frame update
    void Start()
    {
        setPalette("default");

        textContainer.text = "";

        cursor.SetMode(CursorMode.Cross);
        cursor.choiceBox.setVisible(false);

        m_story = new Story(inkAsset.text);
        Cursor.visible = false;

        StartCoroutine(OnAdvanceStory());
    }

    // Update is called once per frame
    void Update()
    {
        bool canInteract = !IsTimelinePlaying() && !m_isAnimatingText && m_story.currentChoices.Count > 0;

        // CURSOR
        if (canInteract)
        {
            cursor.SetMode(CursorMode.Cross);
        }
        else
        {
            cursor.SetMode(CursorMode.Clock);
        }

        // CHECK WHICH ZONE IS HOVERED
        Choice hoveredChoice = null;
        if (canInteract)
        {
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
                            hoveredChoice = choice;
                            break;
                        }
                    }

                    if (hoveredChoice != null)
                        break;
                }
            }
        }

        // MANAGE CHOICE INPUT & CHOICE BOX
        if (hoveredChoice)
        {
            string zone;
            string text = StripTextFromZoneTag(hoveredChoice.text, out zone);

            cursor.choiceBox.setVisible(true);
            cursor.choiceBox.setText(text);

            if (Input.GetMouseButtonDown(0))
            {
                textContainer.text = "";
                m_story.ChooseChoiceIndex(hoveredChoice.index);
                StartCoroutine(OnAdvanceStory());
            }
        }
        else
        {
            cursor.choiceBox.setVisible(false);
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
                    if (split[0].Trim() == "palette")
                    {
                        setPalette(split[1].Trim());
                    }
                    else if (split[0].Trim() == "location")
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
