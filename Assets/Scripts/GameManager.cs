using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.Playables;
using Ink.Runtime;
using TMPro;
using UnityEngine.Audio;
using UnityEngine.SceneManagement;

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

    public RectTransform endPanel;
    public TMPro.TextMeshProUGUI endText;
    public ButtonController endTryAgainButton;
    public ButtonController endBackToMenuButton;

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

        StartCoroutine(startSequence());
    }

    // Update is called once per frame
    void Update()
    {
        Cursor.visible = false;
        m_canInteract = !m_isInStartSequence && !m_isTransitioning && !m_isAnimatingText && m_story.currentChoices.Count > 0;

        // CURSOR
        if (m_canInteract)
        {
            cursor.setMode(CursorMode.Idle);
        }
        else
        {
            if (!m_canSkip)
            {
                cursor.setMode(CursorMode.Clock);
            }
            else
            {
                cursor.setMode(CursorMode.Skip);
            }
        }

        // CHECK WHICH ZONE IS HOVERED
        Choice hoveredChoice = null;
        bool isHoveringInventoryButton = false;
        bool tryAgainHovered = false;
        bool backToMenuHovered = false;
        if (m_canInteract)
        {
            PointerEventData pointerEventData = new PointerEventData(EventSystem.current);
            pointerEventData.position = Input.mousePosition;

            List<RaycastResult> raycastResults = new List<RaycastResult>();
            EventSystem.current.RaycastAll(pointerEventData, raycastResults);
            foreach (RaycastResult result in raycastResults)
            {
                if (!m_isEnd)
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
                else
                {
                    if (result.gameObject == endTryAgainButton.gameObject)
                    {
                        tryAgainHovered = true;
                    }

                    if (result.gameObject == endBackToMenuButton.gameObject)
                    {
                        backToMenuHovered = true;
                    }
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
        if (m_canSkip)
        {
            if (Input.GetMouseButtonDown(0))
            {
                m_skipRequested = true;
                return;
            }
        }

        // END
        if (m_isEnd && m_canInteract)
        {
            endTryAgainButton.setHovered(tryAgainHovered);
            endBackToMenuButton.setHovered(backToMenuHovered);

            if (m_isDead)
            {
                endTryAgainButton.gameObject.SetActive(true);
            }
            endBackToMenuButton.gameObject.SetActive(true);

            if (tryAgainHovered && Input.GetMouseButtonDown(0))
            {
                StartCoroutine(tryAgainSequence());
            }

            if (backToMenuHovered && Input.GetMouseButtonDown(0))
            {
                SceneManager.LoadScene(SceneManager.GetActiveScene().name);
            }
        }
        else
        {
            endTryAgainButton.setHovered(false);
            endBackToMenuButton.setHovered(false);
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
        bool isFirstLine = true;
        bool comeFromTransition = false;
        setIventoryOpen(false);
        TMPro.TextMeshProUGUI currentTextContainer = textContainer;

        while (m_story.canContinue)
        {
            string line = m_story.Continue();

            // RESOLVE TAGS
            string nextPalette = "";
            string nextVariant = "";
            string nextLocation = "";
            string nextSequence = "";
            bool clear = false;
            bool isDead = false;
            bool isEnd = false;
            foreach (string tag in m_story.currentTags)
            {
                string[] split = tag.Split(':');
                if (split.Length >= 2)
                {
                    string key = split[0].Trim();
                    string value = split[1].Trim();
                    if (key == "palette")
                    {
                        nextPalette = value;
                    }
                    else if (key == "variant")
                    {
                        nextVariant = value;
                    }
                    else if (key == "location")
                    {
                        nextLocation = value;
                    }
                    else if (key == "sequence")
                    {
                        nextSequence = value;
                    }
                    else if (key == "clear")
                    {
                        clear = true;
                    }
                    else if (key == "break_sequence")
                    {
                        m_breakSequence = true;
                    }
                    else if (key == "dead")
                    {
                        isDead = true;
                    }
                    else if (key == "end")
                    {
                        isEnd = true;
                    }
                }
            }

            if (nextPalette.Length > 0)
            {
                setPalette(nextPalette);
            }

            if (nextLocation.Length > 0)
            {
                if (currentTextContainer.text.Length >= 3)
                {
                    currentTextContainer.text = currentTextContainer.text.Substring(0, currentTextContainer.text.Length - 3);
                }
                yield return StartCoroutine(goToLocation(nextLocation, nextVariant));
                isFirstLine = true;
                comeFromTransition = true;
            }

            if (isDead || isEnd)
            {
                if (currentTextContainer.text.Length >= 3)
                {
                    currentTextContainer.text = currentTextContainer.text.Substring(0, currentTextContainer.text.Length - 3);
                }
                yield return StartCoroutine(endSequence(isDead));
                currentTextContainer = endText;
                isFirstLine = true;
                comeFromTransition = true;
            }

            if (nextSequence.Length > 0)
            {
                StartCoroutine(playSequence(m_currentScreen.getSequence(nextSequence)));
                isFirstLine = true;
                comeFromTransition = true;
            }

            // DISPLAY TEXT
            m_canSkip = true;

            if (!isFirstLine)
            {
                while (!m_skipRequested)
                {
                    yield return new WaitForEndOfFrame();
                }
                currentTextContainer.text = currentTextContainer.text.Substring(0, currentTextContainer.text.Length - 3);
                currentTextContainer.text = currentTextContainer.text + "\n";
                m_skipRequested = false;
            }

            if (clear)
            {
                currentTextContainer.text = "";
            }

            if (nextVariant.Length > 0)
            {
                m_currentScreen.setVariant(nextVariant);
            }

            if (!comeFromTransition && isFirstLine)
            {
                yield return StartCoroutine(skippablePause(0.5f));
            }

            isFirstLine = false;
            comeFromTransition = false;

            m_characterTimer = 0.0f;
            m_displayedCharacterCount = 0;

            if (characterDisplayInterval <= 0.0f || m_skipRequested)
            {
                currentTextContainer.text = currentTextContainer.text + line;
            }
            else
            {
                float nextCharacterDisplayInterval = characterDisplayInterval + (Random.value * 2.0f - 1.0f) * characterDisplayIntervalRandomDeviation;
                while (m_displayedCharacterCount < line.Length)
                {
                    m_characterTimer += Time.deltaTime;
                    while (m_characterTimer >= nextCharacterDisplayInterval)
                    {
                        currentTextContainer.text = currentTextContainer.text + line.Substring(m_displayedCharacterCount, 1);

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
                        currentTextContainer.text = currentTextContainer.text + line.Substring(m_displayedCharacterCount, line.Length - m_displayedCharacterCount);
                        m_skipRequested = false;
                        break;
                    }
                }
            }
            currentTextContainer.text = currentTextContainer.text + "\n...";

            m_canSkip = false;

            //yield return StartCoroutine(skippablePause(0.5f));
        }

        currentTextContainer.text = currentTextContainer.text.Substring(0, currentTextContainer.text.Length - 3);


        m_isAnimatingText = false;
        m_skipRequested = false;
        yield return null;
    }

    IEnumerator goToLocation(string _location, string _variant)
    {
        m_isTransitioning = true;
        if (_location == m_currentLocation)
        {
            m_currentScreen.setVariant(_variant);
        }
        else
        {
            yield return new WaitForSeconds(0.8f);

            if (m_currentLocation != "")
            {
                backgroundMask.Play(backgroundMaskHide, DirectorWrapMode.Hold);
                yield return new WaitUntil(() => !isTimelinePlaying());
            }
            
            m_currentLocation = _location;
            yield return new WaitForSeconds(1.0f);
            textContainer.text = "";

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
                m_currentScreen.setVariant(_variant);
                yield return new WaitUntil(() => !isTimelinePlaying());
            }
            yield return new WaitForSeconds(1.0f);
        }
        m_isTransitioning = false;
        yield return null;
    }

    IEnumerator endSequence(bool _isDead)
    {
        m_isTransitioning = true;
        yield return new WaitForSeconds(0.8f);

        if (m_currentLocation != "")
        {
            backgroundMask.Play(backgroundMaskHide, DirectorWrapMode.Hold);
            yield return new WaitUntil(() => !isTimelinePlaying());
        }

        m_isEnd = true;
        m_isDead = _isDead;
        yield return new WaitForSeconds(1.0f);
        textContainer.text = "";
        endText.text = "";
        m_currentLocation = "";
        endPanel.gameObject.SetActive(true);
        endTryAgainButton.gameObject.SetActive(false);
        endBackToMenuButton.gameObject.SetActive(false);

        for (int i = 0; i < backgroundContainer.childCount; ++i)
        {
            Destroy(backgroundContainer.GetChild(i).gameObject);
        }
        m_currentScreen = null;
        yield return new WaitForSeconds(1.0f);

        m_isTransitioning = false;
        yield return null;
    }

    IEnumerator tryAgainSequence()
    {
        m_isEnd = false;
        m_isDead = false;
        m_story.ChooseChoiceIndex(0);
        endPanel.gameObject.SetActive(false);
        yield return StartCoroutine(startSequence());
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

    IEnumerator playSequence(ScreenSequence _sequence)
    {
        ScreenController currentScreen = m_currentScreen;
        m_breakSequence = false;

        for (int i = 0; i < _sequence.sequence.Length; ++i)
        {
            float timer = 0.0f;
            while((timer < _sequence.sequence[i].delay && m_currentScreen == currentScreen) || !m_canInteract)
            {
                if (m_breakSequence)
                {
                    break;
                }

                if (m_canInteract)
                {
                    timer += Time.deltaTime;
                }
                yield return new WaitForEndOfFrame();
            }

            if (m_breakSequence)
                break;

            if (m_currentScreen != currentScreen)
                break;

            m_story.ChoosePathString(_sequence.sequence[i].path);
            textContainer.text = "";
            yield return StartCoroutine(onAdvanceStory());
        }
        m_breakSequence = false;
        yield return null;
    }

    IEnumerator startSequence()
    {
        m_isInStartSequence = true;
        yield return new WaitForSeconds(1.0f);
        m_isInStartSequence = false;

        StartCoroutine(onAdvanceStory());

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
    private bool m_canInteract = false;
    private bool m_isTransitioning = false;
    private bool m_isInStartSequence = false;
    private bool m_canSkip = false;
    private bool m_breakSequence = false;
    private bool m_isEnd = false;
    private bool m_isDead = false;
}
