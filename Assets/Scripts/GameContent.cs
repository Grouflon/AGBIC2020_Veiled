using System.Collections;
using System.Collections.Generic;
using UnityEngine;


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

[System.Serializable]
public struct Item
{
    public string id;
    public string displayText;
}

public class GameContent : MonoBehaviour
{
    public List<Zone> zones;
    public List<Item> items;
    public List<Palette> palettes;

    public string getItemDisplayName(string _id)
    {
        foreach (Item item in items)
        {
            if (item.id == _id)
            {
                return item.displayText;
            }
        }
        return _id;
    }
}
