using System.Collections;
using System.Collections.Generic;
using UnityEngine.Audio;
using UnityEngine;

[System.Serializable]
public struct Music
{
    public string name;
    public AudioClip clip;
}

public class AudioManager : MonoBehaviour
{
    public Music[] musics;

    public AudioFXController audioFXPrefab;
    public AudioSource musicPrefab;

    public void fadeMusicIn(string _name, float _duration = 0.0f)
    {
        bool alreadyHere = false;
        for (int i = 0; i < m_musics.Count; ++i)
        {
            BGM music = m_musics[i];
            float ratio = music.source.volume;
            if (music.name == _name)
            {
                music.state = BGMState.FadingIn;
                music.fadeTime = _duration;
                music.timer = ratio * _duration;
                alreadyHere = true;
            }
            else
            {
                music.state = BGMState.FadingOut;
                music.fadeTime = _duration;
                music.timer = (1.0f - ratio) * _duration;
            }
            m_musics[i] = music;
        }

        if (!alreadyHere)
        {
            BGM music = new BGM();
            music.name = _name;

            AudioClip clip = null;
            foreach (Music m in musics)
            {
                if (m.name == _name)
                {
                    clip = m.clip;
                    break;
                }
            }
            if (!clip)
                return;

            music.source = Instantiate<AudioSource>(musicPrefab, Vector3.zero, Quaternion.identity);
            music.source.clip = clip;
            music.source.volume = 0.0f;
            music.source.Play();
            music.timer = 0.0f;
            music.fadeTime = _duration;
            m_musics.Add(music);
        }
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

    private void Awake()
    {
        m_musics = new List<BGM>();
    }

    void Update()
    {
        for (int i = 0; i < m_musics.Count; ++i)
        {
            BGM music = m_musics[i];

            if (m_musics[i].timer < m_musics[i].fadeTime)
            {
                music.timer = Mathf.Clamp(music.timer + Time.deltaTime, 0.0f, music.fadeTime);
            }

            if (music.state == BGMState.FadingIn)
            {
                music.source.volume = Mathf.Lerp(0.0f, 1.0f, music.fadeTime > 0.0f ? music.timer / music.fadeTime : 1.0f);
            }
            else if (music.state == BGMState.FadingOut)
            {
                music.source.volume = Mathf.Lerp(1.0f, 0.0f, music.fadeTime > 0.0f ? music.timer / music.fadeTime : 1.0f);
            }
            m_musics[i] = music;
        }
    }

    enum BGMState
    {
        FadingIn,
        FadingOut,
    }

    struct BGM
    {
        public string name;
        public BGMState state;
        public AudioSource source;
        public float timer;
        public float fadeTime;
    }

    List<BGM> m_musics;
}
