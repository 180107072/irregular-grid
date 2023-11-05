extends Node


func vec3_lerp( out:Vector3, a: Vector3, b: Vector3, t: float ): 
	var ti = 1 - t;
	out.x = a.x * ti + b.x * t;
	out.y = a.y * ti + b.y * t;
	out.z = a.z * ti + b.z * t;
	return out;
