extends Node
const Face = preload("res://halfedge/structs/face.gd")

func tri_quad_from_edge(top, eIdx):
	var cross_edge = top.edges[eIdx]
	var tris = cross_edge.get_triangles(top)
	if tris == null or tris.size() != 2:
		return -1
	
	var aTri = top.triangles[tris[0]]
	var bTri = top.triangles[tris[1]]
	
	if aTri.face != -1 or bTri.face != -1:
		return -1
	
	var aHE0 = aTri.find_half_edge( top, cross_edge.idx )
	var aHE1 = top.halfEdges[ aTri.next_half_edge( aHE0.idx ) ]
	var aHE2 = top.halfEdges[ aTri.next_half_edge( aHE1.idx ) ]
	var bHE0 = bTri.find_half_edge( top, cross_edge.idx )
	var bHE1 = top.halfEdges[ bTri.next_half_edge( bHE0.idx ) ]
	var bHE2 = top.halfEdges[ bTri.next_half_edge( bHE1.idx ) ]
	
	var face = top.add_face_from_half_edges( [ aHE1, aHE2, bHE1, bHE2 ] )
	aTri.face = face.idx;
	bTri.face = face.idx;
	aHE0.face = face.idx
	
	bHE0.face = face.idx;
	return face.idx;

func tri_to_face(top, t_idx):
	var tri = top.triangles[t_idx]
	
	if tri.face != -1:
		return -1
	
	var face = Face.new(top.faces.size())
	
	top.faces.push_back(face)
	
	tri.face = face.idx
	
	var he
	
	for i in tri.halfEdges:
		he = top.halfEdges[i]
		he.face = face.idx
		
		face.halfEdges.push_back(i)
		
		he.facePrev = he.triPrev
		he.faceNext = he.triNext
	
	return face.idx
		
