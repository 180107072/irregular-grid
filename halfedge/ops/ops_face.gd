extends Node


func face_vertices(top, f_idx):
	var f = top.faces[f_idx]
	
	var rtn = []
	
	for ihe in f.halfEdges:
		rtn.push_back(top.vertices[ top.halfEdges[ ihe ].vertex ])
	
	return rtn
