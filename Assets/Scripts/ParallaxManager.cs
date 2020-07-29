using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParallaxManager : MonoBehaviour
{
	public List<Transform> Objects;
	public Camera Cam;
	public float ScreenEdgeThreshold = 100;
	public float LoopDistance = 200;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
		for (int i = 0; i < Objects.Count; i++)
		{

			Vector3 screenPoint = Cam.WorldToScreenPoint(Objects[i].transform.position);

			Vector3 cameraForward = Cam.transform.forward;

			Vector3 toObject = (Objects[i].transform.position - Cam.transform.position).normalized;

			float angle = Vector3.SignedAngle(cameraForward, toObject, Cam.transform.up);


			if (angle > (Cam.fieldOfView / 2) + ScreenEdgeThreshold) 
			{
				Vector3 position = Objects[i].transform.position;
				position.z = position.z + 200;
				Objects[i].transform.position = position;
			}
			
		}
    }
}
