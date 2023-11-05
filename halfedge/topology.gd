class_name Topology

var mapVerts = {}
var mapEdges = {}

var vertices   = []
var edges      = []
var half_edges = []
var triangles  = []
var faces      = []


func clear_maps():
	mapVerts.clear()
	mapEdges.clear()


func dispose():
	clear_maps()
	vertices.clear()
	edges.clear()
	half_edges.clear()
	triangles.clear()
	faces.clear()


func add_vertex(pos: Vector3):
	var vec = Vector3(floor(pos.x * 100000), floor(pos.y * 100000), floor(pos.z * 100000))

	var k = str(vec.x) + "_" + str(vec.y) + "_" + str(vec.z)

	if mapVerts.has(k):
		return mapVerts.get(k)

	var vertex = Vertex.new(pos, vertices.size())

	vertices.push_back(vertex)
	mapVerts[k] = vertex.idx

	return vertex.idx


func add_edge(ai: int, bi: int):
	var x = [ai, bi]

	if bi < ai:
		x = [bi, ai]

	var key = str(x[0]) + "_" + str(x[1])

	var eIdx = mapEdges.get(key)

	var va = vertices[ai]
	var vb = vertices[bi]

	if eIdx != null:
		var _edge = edges[eIdx]

		var _he = half_edges[_edge.half_edge]

		if _he.twin != -1:
			print("Edge already has two half edges")
			return null

		var twin = HalfEdge.new(half_edges.size(), _he.idx)
		twin.vertex = ai
		twin.edge = eIdx

		_he.twin = twin.idx

		half_edges.push_back(twin)

		if va.half_edge == -1:
			va.half_edge = twin.idx
		if vb.half_edge == -1:
			vb.half_edge = twin.idx

		return twin

	var he = HalfEdge.new(half_edges.size())
	he.twin = -1

	var edge = Edge.new(ai, bi, edges.size(), he.idx)

	he.vertex = ai
	he.edge = edge.idx

	if va.half_edge == -1:
		va.half_edge = he.idx
	if vb.half_edge == -1:
		vb.half_edge = he.idx

	edges.push_back(edge)

	half_edges.push_back(he)

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
	tri.half_edges.append(he0.idx)
	tri.half_edges.append(he1.idx)
	tri.half_edges.append(he2.idx)

	triangles.append(tri)

	he0.tri = tri.idx
	he0.triPrev = he2.idx
	he0.triNext = he1.idx

	he1.tri = tri.idx
	he1.triPrev = he0.idx
	he1.triNext = he2.idx

	he2.tri = tri.idx
	he2.triPrev = he1.idx
	he2.triNext = he0.idx

	return tri


func add_triangle_verts(a: Vector3, b: Vector3, c: Vector3):
	var ai = add_vertex(a)
	var bi = add_vertex(b)
	var ci = add_vertex(c)

	return add_triangle(ai, bi, ci)


func add_face_from_half_edges(ary_he: Array):
	var face = Face.new(faces.size())

	faces.push_back(face)

	var cnt = ary_he.size()
	var prev_idx = ary_he[cnt - 1].idx

	for i in range(0, cnt):
		var he: HalfEdge = ary_he[i]

		he.face     = face.idx
		he.facePrev = prev_idx
		he.faceNext = ary_he[(i + 1) % cnt].idx

		prev_idx = he.idx

		face.half_edges.append(he.idx)

	return face


func add_tri_from_half_edges(ary_he: Array):
	var tri = Triangle.new(triangles.size())

	triangles.push_back(tri)

	var cnt = ary_he.size()
	var prev_idx = ary_he[cnt - 1].idx

	for i in range(0, cnt):
		var he: HalfEdge = ary_he[i]

		he.tri     = tri.idx
		he.triPrev = prev_idx
		he.triNext = ary_he[(i + 1) % cnt].idx

		prev_idx = he.idx

		tri.half_edges.push_back(he.idx)

	return tri


#region GETTERS
func get_vert_pos(i: int):
	return vertices[i].pos


func get_half_edge_vert_idx(i: int):
	return half_edges[i].vertex


func get_half_edge_vertex(i: int):
	return vertices[half_edges[i].vertex]


func get_half_edge_pos(i: int):
	return vertices[half_edges[i].vertex].pos


#endregion


func _into_array(n):
	var a = []
	for i in range(n):
		a.append(0)
	return a


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
		rtn[i] = get_half_edge_vert_idx(o.half_edges[0])
		i += 1
		rtn[i] = get_half_edge_vert_idx(o.half_edges[1])
		i += 1
		rtn[i] = get_half_edge_vert_idx(o.half_edges[2])
