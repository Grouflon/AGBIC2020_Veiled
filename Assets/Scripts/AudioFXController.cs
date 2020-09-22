using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioFXController : MonoBehaviour
{
    public AudioSource audioSource { private set; get; }

    void Awake()
    {
        audioSource = GetComponent<AudioSource>();
    }

    void Update()
    {
        if (audioSource.clip && !audioSource.isPlaying)
        {
            Destroy(gameObject);
        }
    }
}
