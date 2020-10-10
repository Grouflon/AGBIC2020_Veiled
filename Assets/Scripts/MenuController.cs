using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;

public class MenuController : MonoBehaviour
{
    public GameContent content;
    public CursorController cursor;
    public PalettePostProcess palettePostProcess;
    public PlayableDirector director;
    public PlayableAsset menuFadeIn;
    public PlayableAsset menuFadeOut;
    public PlayableDirector lightDirector;
    public CurtainController titleCurtain;
    public ButtonController startButton;
    public ButtonController exitButton;
    public RectTransform gameCanvas;

    // Start is called before the first frame update
    void Start()
    {
        m_am = FindObjectOfType<AudioManager>();

        foreach (Palette p in content.palettes)
        {
            if (p.name == "default")
            {
                palettePostProcess.lightColor = p.lightColor;
                palettePostProcess.darkColor = p.darkColor;
                break;
            }
        }

        cursor.setMode(CursorMode.None);
        cursor.setChoiceBoxEnabled(false);

        StartCoroutine(StartSequence());
    }

    // Update is called once per frame
    void Update()
    {
        Cursor.visible = false;

        bool startHovered = false;
        bool exitHovered = false;
        if (m_canInteract)
        {
            PointerEventData pointerEventData = new PointerEventData(EventSystem.current);
            pointerEventData.position = new Vector3(Input.mousePosition.x, Input.mousePosition.y, 0.0f);

            List<RaycastResult> raycastResults = new List<RaycastResult>();
            EventSystem.current.RaycastAll(pointerEventData, raycastResults);
            foreach (RaycastResult result in raycastResults)
            {
                if (result.gameObject == startButton.gameObject)
                {
                    startHovered = true;
                }

                if (result.gameObject == exitButton.gameObject)
                {
                    exitHovered = true;
                }
            }

            cursor.setMode((startHovered || exitHovered) ? CursorMode.Highlight : CursorMode.Idle);
        }

        startButton.setHovered(startHovered);
        exitButton.setHovered(exitHovered);

        if (Input.GetMouseButtonDown(0))
        {
            if (startHovered)
            {
                StartCoroutine(EndSequence());
            }
            else if (exitHovered)
            {
                StartCoroutine(EndSequence(true));
            }
        }
    }

    bool isTimelinePlaying()
    {
        return director.state == PlayState.Playing && director.time != director.duration;
    }

    IEnumerator StartSequence()
    {
        m_canInteract = false;
        cursor.setMode(CursorMode.Clock);
        m_am.fadeMusicIn("end0", 8.0f);

        yield return new WaitForSeconds(1.0f);

        director.Play(menuFadeIn, DirectorWrapMode.Hold);
        yield return new WaitUntil(() => !isTimelinePlaying());

        yield return new WaitForSeconds(0.5f);
        lightDirector.Play();
        yield return new WaitForSeconds(2.0f);

        {
            titleCurtain.gameObject.SetActive(true);
            float timer = 0.0f;
            float time = 2.2f;
            while (timer < time)
            {
                timer += Time.deltaTime;
                titleCurtain.progress = Mathf.Clamp01(timer / time);
                yield return new WaitForEndOfFrame();
            }
        }

        yield return new WaitForSeconds(1.5f);
        startButton.gameObject.SetActive(true);
        exitButton.gameObject.SetActive(true);

        cursor.setMode(CursorMode.Idle);
        m_canInteract = true;

        yield return null;
    }

    IEnumerator EndSequence(bool _mustExit = false)
    {
        m_canInteract = false;
        cursor.setMode(CursorMode.Clock);
        m_am.fadeMusicIn("", 4.0f);

        startButton.gameObject.SetActive(false);
        exitButton.gameObject.SetActive(false);

        yield return new WaitForSeconds(1.0f);
        titleCurtain.gameObject.SetActive(false);
        yield return new WaitForSeconds(1.0f);

        director.Play(menuFadeOut, DirectorWrapMode.Hold);
        yield return new WaitUntil(() => !isTimelinePlaying());
        yield return new WaitForSeconds(1.5f);

        if (_mustExit)
        {
#if UNITY_STANDALONE
            //Quit the application
            Application.Quit();
#endif

            //If we are running in the editor
#if UNITY_EDITOR
            //Stop playing the scene
            UnityEditor.EditorApplication.isPlaying = false;
#endif
        }
        else
        {
            SceneManager.LoadScene("Main");
        }

        m_canInteract = true;
        yield return null;
    }

    AudioManager m_am;
    bool m_canInteract = true;
}
