class_name StandaloneOperationsFace

static func face_vertices(top: Topology, f_idx: int):
	var f = top.faces[f_idx]
	
	var rtn = []
	
	for ihe in f.half_edges:
		rtn.push_back(top.vertices[ top.half_edges[ ihe ].vertex ])
	
	return rtn
