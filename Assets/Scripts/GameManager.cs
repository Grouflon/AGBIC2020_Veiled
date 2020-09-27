using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.Playables;
using Ink.Runtime;
using TMPro;
using UnityEngine.Audio;

using System.Text.RegularExpressions;

public struct InventoryItem
{
    public string id;
    public bool isNew;
}

public class GameManager : MonoBehaviour
{
    [Header("Gameplay")]
    public GameContent content;
    public float characterDisplayInterval = 0.2f;
    public float characterDisplayIntervalRandomDeviation = 0.01f;

    [Header("Internal")]
    public CursorController cursor;
    public TextAsset inkAsset;
    public TMPro.TextMeshProUGUI textContainer;
    public PlayableDirector backgroundMask;
    public PlayableAsset backgroundMaskReveal;
    public PlayableAsset backgroundMaskHide;
    public RectTransform backgroundContainer;
    public PalettePostProcess palettePostProcess;
    public AudioFXController audioFXPrefab;
    public AudioClip[] typewriterFX;
    public AudioMixerGroup typewriterMixerGroup;

    public RectTransform inventoryPanel;
    public TMPro.TextMeshProUGUI inventoryText;
    public RectTransform inventoryButtonRect;
    public RectTransform inventoryBagIcon;
    public RectTransform inventoryBackIcon;
    public RectTransform inventoryGlint;
    public RectTransform glintPrefab;

    private Story m_story;
    private bool m_isAnimatingText = false;
    private string m_currentLocation = "";

    public void setPalette(string _name)
    {
        foreach (Palette p in content.palettes)
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

    bool isTimelinePlaying()
    {
        return backgroundMask.state == PlayState.Playing && backgroundMask.time != backgroundMask.duration;
    }

    private void Awake()
    {
        m_inventory = new List<InventoryItem>();
        m_inventoryGlints = new List<RectTransform>();
    }

    // Start is called before the first frame update
    void Start()
    {
        setPalette("default");

        textContainer.text = "";

        cursor.setMode(CursorMode.Idle);
        cursor.choiceBox.setVisible(false);

        m_story = new Story(inkAsset.text);
        m_story.ObserveVariable("inventory", (string _varName, object _newValue) =>
        {
            List<InventoryItem> newInventory = new List<InventoryItem>();
            string[] inventory = _newValue.ToString().Split(',');
            foreach (string str in inventory)
            {
                InventoryItem newItem = new InventoryItem();
                newItem.id = str.Trim();
                newItem.isNew = true;

                if (newItem.id.Length == 0)
                    continue;

                foreach (InventoryItem item in m_inventory)
                {
                    if (item.id == newItem.id && !item.isNew)
                    {
                        newItem.isNew = false;
                        break;
                    }
                }

                newInventory.Add(newItem);
            }
            if (newInventory.Count > m_inventory.Count)
            {
                // PLAY AUDIO HINT
            }
            m_inventory = newInventory;
            updateInventoryGling();
        });

        Cursor.visible = false;

        StartCoroutine(onAdvanceStory());
    }

    // Update is called once per frame
    void Update()
    {
        bool canInteract = !isTimelinePlaying() && !m_isAnimatingText && m_story.currentChoices.Count > 0;

        // CURSOR
        if (canInteract)
        {
            cursor.setMode(CursorMode.Idle);
        }
        else
        {
            cursor.setMode(CursorMode.Clock);
        }

        // CHECK WHICH ZONE IS HOVERED
        Choice hoveredChoice = null;
        bool isHoveringInventoryButton = false;
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
                        string text = stripTextFromZoneTag(choice.text, out zone);

                        if (zone == imageZone.id)
                        {
                            hoveredChoice = choice;
                            break;
                        }
                    }

                    if (hoveredChoice != null)
                        break;
                }

                if (result.gameObject == inventoryButtonRect.gameObject)
                {
                    isHoveringInventoryButton = true;
                }
            }
        }

        // MANAGE CHOICE INPUT & CHOICE BOX
        cursor.choiceBox.setVisible(false);
        if (hoveredChoice)
        {
            cursor.setMode(CursorMode.Highlight);

            string zone;
            string text = stripTextFromZoneTag(hoveredChoice.text, out zone);

            cursor.choiceBox.setVisible(true);
            cursor.choiceBox.setText(text);

            if (Input.GetMouseButtonDown(0))
            {
                setIventoryOpen(false);
                textContainer.text = "";
                m_story.ChooseChoiceIndex(hoveredChoice.index);
                StartCoroutine(onAdvanceStory());
                return;
            }
        }
        else if (isHoveringInventoryButton)
        {
            cursor.setMode(CursorMode.Highlight);
            if (Input.GetMouseButtonDown(0))
            {
                toggleInventory();
            }
        }

        // SKIP
        if (m_isAnimatingText && !isTimelinePlaying())
        {
            if (Input.GetMouseButtonDown(0))
            {
                m_skipRequested = true;
                return;
            }
        }
    }

    string stripTextFromZoneTag(string _text, out string _zone)
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

    IEnumerator onAdvanceStory()
    {
        m_isAnimatingText = true;

        while (m_story.canContinue)
        {
            yield return StartCoroutine(skippablePause(0.5f));

            string line = m_story.Continue();

            foreach (string tag in m_story.currentTags)
            {
                string[] split = tag.Split(':');
                if (split.Length >= 2)
                {
                    string key = split[0].Trim();
                    string value = split[1].Trim();
                    if (key == "palette")
                    {
                        setPalette(value);
                    }
                    else if (key == "location")
                    {
                        yield return StartCoroutine(goToLocation(value));
                        yield return new WaitForSeconds(1.0f);
                    }
                    else if (key == "variant")
                    {
                        m_currentScreen.setVariant(value);
                    }
                }
            }

            m_characterTimer = 0.0f;
            m_displayedCharacterCount = 0;

            if (characterDisplayInterval <= 0.0f || m_skipRequested)
            {
                textContainer.text = textContainer.text + line;
            }
            else
            {
                float nextCharacterDisplayInterval = characterDisplayInterval + (Random.value * 2.0f - 1.0f) * characterDisplayIntervalRandomDeviation;
                while (m_displayedCharacterCount < line.Length)
                {
                    m_characterTimer += Time.deltaTime;
                    while (m_characterTimer >= nextCharacterDisplayInterval)
                    {
                        textContainer.text = textContainer.text + line.Substring(m_displayedCharacterCount, 1);

                        if (m_displayedCharacterCount % 4 == 0)
                        {
                            int soundId = Random.Range(0, typewriterFX.Length);
                            spawnAudioFX(typewriterFX[soundId], typewriterMixerGroup);
                        }

                        ++m_displayedCharacterCount;
                        m_characterTimer -= nextCharacterDisplayInterval;

                        nextCharacterDisplayInterval = characterDisplayInterval + (Random.value * 2.0f - 1.0f) * characterDisplayIntervalRandomDeviation;
                    }

                    yield return new WaitForEndOfFrame();

                    if (m_skipRequested)
                    {
                        textContainer.text = textContainer.text + line.Substring(m_displayedCharacterCount, line.Length - m_displayedCharacterCount);
                        m_skipRequested = false;
                        break;
                    }
                }
            }

            textContainer.text = textContainer.text + "\n\n";

            yield return StartCoroutine(skippablePause(0.5f));
            m_skipRequested = false;
        }

        m_isAnimatingText = false;
        m_skipRequested = false;
        yield return null;
    }

    IEnumerator goToLocation(string _location)
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
                yield return new WaitUntil(() => !isTimelinePlaying());
            }
            
            m_currentLocation = _location;
            yield return new WaitForSeconds(1.0f);

            if (m_currentLocation != "")
            {
                for (int i = 0; i < backgroundContainer.childCount; ++i)
                {
                    Destroy(backgroundContainer.GetChild(i).gameObject);
                }
                foreach (Zone zone in content.zones)
                {
                    if (zone.id == m_currentLocation)
                    {
                        m_currentScreen = Instantiate(zone.screenPrefab, backgroundContainer);
                        break;
                    }
                }

                // Play animation
                backgroundMask.Play(backgroundMaskReveal, DirectorWrapMode.Hold);
                yield return new WaitUntil(() => !isTimelinePlaying());
            }
        }
        yield return null;
    }

    IEnumerator skippablePause(float _duration)
    {
        float pauseTimer = 0.0f;
        while (pauseTimer < _duration && !m_skipRequested)
        {
            pauseTimer += Time.deltaTime;
            yield return new WaitForEndOfFrame();
        }
        yield return null;
    }

    public AudioFXController spawnAudioFX(AudioClip _clip, AudioMixerGroup _mixerGroup = null)
    {
        AudioFXController controller = Instantiate<AudioFXController>(audioFXPrefab, Vector3.zero, Quaternion.identity);
        controller.audioSource.clip = _clip;
        if (_mixerGroup)
        {
            controller.audioSource.outputAudioMixerGroup = _mixerGroup;
        }
        controller.audioSource.Play();
        return controller;
    }

    void setIventoryOpen(bool _open)
    {
        if (_open == m_isInventoryOpen)
            return;

        if (_open)
        {
            inventoryBagIcon.gameObject.SetActive(false);
            inventoryGlint.gameObject.SetActive(false);
            inventoryBackIcon.gameObject.SetActive(true);
            inventoryPanel.gameObject.SetActive(true);

            if (m_inventory.Count == 0)
            {
                inventoryText.text = "Your bag is empty.";
            }
            else
            {
                string str = "";
                for (int i = 0; i < m_inventory.Count; ++i)
                {
                    InventoryItem item = m_inventory[i];
                    str += "- " + content.getItemDisplayName(item.id) + "\n";
                    if (item.isNew)
                    {
                        RectTransform glint = Instantiate<RectTransform>(glintPrefab, inventoryText.rectTransform);
                        glint.localPosition = new Vector3(5.0f, -6.0f + i * -18.0f, 0.0f);
                        m_inventoryGlints.Add(glint);
                    }
                }
                inventoryText.text = str;
            }
        }
        else
        {
            inventoryBagIcon.gameObject.SetActive(true);
            inventoryBackIcon.gameObject.SetActive(false);
            inventoryPanel.gameObject.SetActive(false);
            inventoryGlint.gameObject.SetActive(false);

            for (int i = 0; i < m_inventory.Count; ++i)
            {
                InventoryItem item = m_inventory[i];
                item.isNew = false;
                m_inventory[i] = item;
            }

            foreach (RectTransform glint in m_inventoryGlints)
            {
                Destroy(glint.gameObject);
            }
            m_inventoryGlints.Clear();

            updateInventoryGling();
        }
        m_isInventoryOpen = _open;
    }
    void toggleInventory()
    {
        setIventoryOpen(!m_isInventoryOpen);
    }
    void updateInventoryGling()
    {
        bool hasNew = false;
        foreach (InventoryItem item in m_inventory)
        {
            if (item.isNew)
            {
                hasNew = true;
                break;
            }
        }

        inventoryGlint.gameObject.SetActive(hasNew);
    }

    private int m_displayedCharacterCount = -1;
    private float m_characterTimer = 0.0f;
    private bool m_skipRequested = false;
    private List<InventoryItem> m_inventory;
    private List<RectTransform> m_inventoryGlints;
    private ScreenController m_currentScreen;
    private bool m_isInventoryOpen = false;
}
