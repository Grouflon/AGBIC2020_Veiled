using System.Collections;
using System.Collections.Generic;
using UnityEngine;
//using UnityEngine.UIElements;
using UnityEngine.UI;

public class ImageZoneController : MonoBehaviour
{
    public string id;

    // Start is called before the first frame update
    void Start()
    {
        Image image = GetComponent<Image>();
        image.color = new Color(0.0f, 0.0f, 0.0f, 0.0f);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
