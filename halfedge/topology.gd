extends Node

var mapVerts = {}
var mapEdges = {}

var vertices = []
var edges = []
var halfEdges = []
var triangles = []
var faces =[] 

const Vertex = preload("res://halfedge/structs/vertex.gd")
const HalfEdge = preload("res://halfedge/structs/half_edge.gd")
const Edge = preload("res://halfedge/structs/edge.gd")
const Triangle = preload("res://halfedge/structs/triangle.gd")
const Face = preload("res://halfedge/structs/face.gd")

func clear_maps():
	mapVerts.clear()
	mapEdges.clear()


func dispose():
	clear_maps()
	vertices.clear()
	edges.clear()
	halfEdges.clear()
	triangles.clear()
	faces.clear()

func add_vertex(pos: Vector3):
	var vec = Vector3(pos.x * 100000, pos.y * 100000,pos.z * 100000)
	
	var k = str(vec.x) + '_' + str(vec.y) + '_' + str(vec.z);
	
	if mapVerts.has((k)):
		return mapVerts.get(k)
	
	var vertex = Vertex.new(pos, vertices.size())
	
	vertices.push_back(vertex)
	mapVerts[k] = vertex.idx
	
	return vertex.idx
	
func add_edge(ai: int, bi: int):
	var x = [ai, bi]
	
	if bi < ai:
		x = [bi, ai]
	
	var key = str(x[0]) + '_' + str(x[1])

	var eIdx = mapEdges.get(key)
	
	var va = vertices[ai]
	var vb = vertices[bi]
	
	if eIdx != null:
		var edge = edges[eIdx]
		
		var he = halfEdges[edge.halfEdge]
		
		if he.twin != -1:
			print('Edge already has two half edges')
			return null
		
		var twin = HalfEdge.new(halfEdges.size(), he.idx)
		twin.vertex = ai
		twin.edge = eIdx
		he.twin = twin.idx
		
		halfEdges.push_back(twin)
		
		if va.halfEdge == -1:
			va.halfEdge = twin.idx
		if vb.halfEdge == -1:
			vb.halfEdge = twin.idx
		
		return twin
	
	var he = HalfEdge.new(halfEdges.size())
	var edge = Edge.new(ai, bi, edges.size(), he.idx)
	
	he.vertex = ai
	he.edge = edge.idx
	
	if va.halfEdge == -1:
		va.halfEdge = he.idx
	if vb.halfEdge == -1:
		vb.halfEdge = he.idx
	
	edges.append(edge)
	
	halfEdges.append(he)

	mapEdges[key] = edge.idx
	
	return he
	
func add_triangle(ai: int, bi: int, ci: int):
	var he0 = add_edge(ai, bi)
	if he0 == null: 
		return null
	
	var he1 = add_edge(bi, ci)
	if he1 == null:
		return null
		
	var he2 = add_edge(ci, ai)
	if he2 == null:
		return null
		
	var tri = Triangle.new(triangles.size())
	tri.halfEdges.append(he0.idx)
	tri.halfEdges.append(he1.idx)
	tri.halfEdges.append(he2.idx)
	
	triangles.append(tri)
	
	he0.tri     = tri.idx;
	he0.triPrev = he2.idx;
	he0.triNext = he1.idx;

	he1.tri     = tri.idx;
	he1.triPrev = he0.idx;
	he1.triNext = he2.idx;

	he2.tri     = tri.idx;
	he2.triPrev = he1.idx;
	he2.triNext = he0.idx;
	
	return tri
	
func add_triangle_verts(a, b, c):
	var ai = add_vertex(a)
	var bi = add_vertex(b)
	var ci = add_vertex(c)
	
	return add_triangle(ai, bi, ci)

func add_face_from_half_edges(aryHe):
	var face = Face.new(faces.size())
	
	faces.append(face)
	
	var he
	var cnt = aryHe.size()
	var prevIdx = aryHe[cnt - 1].idx
	
	for i in range(0, cnt):
		he = aryHe[i]
		he.face = face.idx
		he.facePrev = prevIdx
		he.faceNext = aryHe[(i + 1) % cnt].idx
		
		prevIdx = he.idx
		
		face.halfEdges.append(he.idx)
	
	return face

func add_tri_from_half_edges(ary_he):
	var tri = Triangle.new(triangles.size())
	
	triangles.push_back(tri)
	
	var he
	var cnt = ary_he.size()
	var prev_idx = ary_he[cnt - 1].idx
	
	for i in range(0, cnt - 1):
		he = ary_he[i]
		he.tri = tri.idx
		he.triPrev = prev_idx
		he.triNext = ary_he[ (i + 1) % cnt ].idx
		
		prev_idx = he.idx
		
		tri.halfEdges.push_back(he.idx)
	
	return tri
		

#region GETTERS
func get_vert_pos(i):
	return vertices[i].pos
func get_half_edge_vert_idx(i):
	return halfEdges[i].vertex
func get_half_edge_vertex(i):
	return vertices[halfEdges[i].vertex]
func get_half_edge_pos(i):
	return vertices[halfEdges[i].vertex].pos
#endregion

func _into_array(n):
	var a = []
	for i in range(n):
		a.append(0)

func flatten_vertices():
	var rtn = _into_array(vertices.size() * 3)
	
	var i = 0
	for o in vertices:
		i += 1
		rtn[i] = o.pos[0]
		i += 1
		rtn[i] = o.pos[1]
		i += 1
		rtn[i] = o.pos[2]
	
func flatten_indices():
	var rtn = _into_array(vertices.size() * 3)
	
	var i = 0
	for o in vertices:
		i += 1
		rtn[i] = get_half_edge_vert_idx( o.halfEdges[ 0 ] )
		i += 1
		rtn[i] = get_half_edge_vert_idx( o.halfEdges[ 1 ] )
		i += 1
		rtn[i] = get_half_edge_vert_idx( o.halfEdges[ 2 ] )
