class_name  IrregularHexGrid


func build(radius = 3, div = 3, iter = 50, relax_scl = 0.1):
	var shape = Topology.new()

	_build_points(shape, radius, div)

	_build_triangles(shape, div)

	_random_quad_merge(shape)

	var final = Topology.new()

	_face_subdivide(shape, final)

	_prep_edge_verts(final)

	_relax_forces(final, iter, relax_scl)

	shape.dispose()

	final.clear_maps()

	return final


func _build_points(top: Topology, radius: int, div: float):
	var rad = -30 * PI / 180
	var p_corner = Vector3(radius * cos(rad), 0, radius * sin(rad))

	var p_top = Vector3(0, 0, -radius)

	var d_min = float(div) - 1.0
	var d_max = float(div * 2.0) - 1.0

	var a_pnt; var b_pnt; var x_pnt

	for i in range(-d_min, d_min + 1.0):
		var i_abs = float(abs(i))
		var points_count = d_max + -i_abs - 1.0

		a_pnt = lerp(p_corner, p_top, 1.0 - float(i_abs / d_min))

		a_pnt[0] *= 1 if sign(i) == 0 else sign(i)

		b_pnt = Vector3(a_pnt)
		b_pnt[2] = -b_pnt[2]

		top.add_vertex(a_pnt)

		for j in range(1, points_count):
			x_pnt = lerp(a_pnt, b_pnt, j / points_count)

			top.add_vertex(x_pnt)

		top.add_vertex(b_pnt)


func _build_triangles(top: Topology, div: int):
	var d_min = div - 1
	var d_max = div * 2 - 1
	var a_abs; var b_abs; var a_cnt; var b_cnt; var min_cnt; var a_idx = 0; var b_idx = 0
	
	var a; var b; var c; var d
	for i in range(-d_min, d_min):
		a_abs = abs(i); b_abs = abs(i + 1)
		a_cnt = d_max + -a_abs
		b_cnt = d_max + -b_abs
		b_idx = a_idx + a_cnt
		min_cnt = min(a_cnt, b_cnt) - 1

		for j in range(0, min_cnt):
			a = a_idx + j
			b = a + 1
			d = b_idx + j
			c = d + 1
			if i < 0:
				top.add_triangle(a, b, c)
				top.add_triangle(c, d, a)
			else:
				top.add_triangle(a, b, d)
				top.add_triangle(b, c, d)
		if i < 0:
			a = a_idx + a_cnt - 1
			b = a + b_cnt
			c = b - 1
		else:
			b = a_idx + a_cnt - 1
			a = b - 1
			c = b + b_cnt
		top.add_triangle(a, b, c)
		a_idx += a_cnt


func _into_array(n):
	var a = []

	for i in range(0, n):
		a.append(i)

	return a


func _random_quad_merge(top: Topology):
	var edges = _into_array(top.edges.size())

	edges.shuffle()

	var idx = edges.pop_back()

	while idx != null:
		StandaloneOperationsTriangle.tri_quad_from_edge(top, idx)
		idx = edges.pop_back()

	for he in top.half_edges:
		if he.face == -1:
			StandaloneOperationsTriangle.tri_to_face(top, he.tri)


func _face_subdivide(top: Topology, out: Topology):
	for f in top.faces:
		if f.half_edges.size() == 4:
			var a = top.get_vert_pos(top.half_edges[f.half_edges[0]].vertex)
			var b = top.get_vert_pos(top.half_edges[f.half_edges[1]].vertex)
			var c = top.get_vert_pos(top.half_edges[f.half_edges[2]].vertex)
			var d = top.get_vert_pos(top.half_edges[f.half_edges[3]].vertex)
			StandaloneOperationsAdd.add_quad_subdivide(out, a, b, c, d)
		elif f.half_edges.size() == 3:
			var a = top.get_vert_pos(top.half_edges[f.half_edges[0]].vertex)
			var b = top.get_vert_pos(top.half_edges[f.half_edges[1]].vertex)
			var c = top.get_vert_pos(top.half_edges[f.half_edges[2]].vertex)
			StandaloneOperationsAdd.add_tri_subdivide_face(out, a, b, c)


func _prep_edge_verts(top: Topology):
	for he in top.half_edges:
		if he.twin != -1:
			continue
		var edg = top.edges[he.edge]
		top.vertices[edg.aIdx].userData = true
		top.vertices[edg.bIdx].userData = true


func _relax_forces(top: Topology, iter = 50, relax_scl = 0.1):
	var centroid = Vector3.ZERO
	var force = Vector3.ZERO
	var v = Vector3.ZERO

	var forces = _into_array(top.vertices.size())

	for i in range(0, forces.size()):
		forces[i] = Vector3.ZERO

	for loop in range(0, iter):
		for f in top.faces:
			var pnts = f.get_vertices(top)
			centroid = (pnts[0].pos + pnts[1].pos + pnts[2].pos + pnts[3].pos) / 4

			for p in pnts:
				if p.userData == null:
					v = p.pos - centroid
					force = force + v
					force = Vector3(-force.z, force.y, force.x)

			force = force / 4

			for p in pnts:
				if p.userData == null:
					v = centroid + force
					v = v - p.pos
					forces[p.idx] = forces[p.idx] + v
					force = Vector3(-force.z, force.y, force.x)

		for i in range(0, forces.size()):
			if top.vertices[i].userData == null:
				v = forces[i] * relax_scl
				top.vertices[i].pos = top.vertices[i].pos + v

		if loop != iter - 1:
			force = Vector3.ZERO
			for i in range(0, forces.size()):
				forces[i] = Vector3.ZERO
