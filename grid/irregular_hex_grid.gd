extends Node3D

const Topology = preload("res://halfedge/topology.gd")
const IrregularGrid = preload("res://grid/irregular_grid_main.gd")
var OPS_Tri = preload("res://halfedge/ops/op_tri.gd").new()
var OPS_Add = preload("res://halfedge/ops/ops_add.gd").new()


func _debug_faces(grid):
	for f in grid.faces:
		var edg = grid.halfEdges[f.halfEdges[0]]
		var len = f.halfEdges.size()
		var box_pos = Vector3(0, 0, 0)
		DebugDraw3D.draw_box(box_pos, Vector3(1, 2, 1), Color(0, 1, 0))
		for i in range(0, len):
			var ii = i % len
			var nex = grid.halfEdges[f.halfEdges[ii]]
			DebugDraw3D.draw_line(grid.get_vert_pos( edg.vertex ), grid.get_vert_pos( nex.vertex ) , Color(255, 255, 255))
			edg = nex
			

func create():
	var grid = build( 52, 32, 50, 0.4, 110, 0 )
	var ir_grid = IrregularGrid.new().from_topology(grid, 1, 3)
#	_debug_faces(grid)
	
	return grid

func build(radius = 3, div = 3, iter = 50, relaxScl = 0.1, _seed = 100, relax = 0):
	var shape = Topology.new()
	
	_build_points(shape, radius, div)
	_build_triangles(shape, radius, div)
	_random_quad_merge(shape, _seed)
	
	var final = Topology.new()
	
	_face_subdivide(shape, final)
	
	return final

func _build_points( top, radius, div ):
	var rad     = -30 * PI / 180;
	var pCorner = Vector3( radius * cos( rad ), 0, radius * sin( rad ) );
	
	var pTop    = Vector3( 0, 0, -radius );

	var d_min  = float(div) - 1.0
	var d_max  = float(div * 2.0) - 1.0
	
	var iAbs
	var pntCnt
	var aPnt
	var bPnt
	var xPnt
	
	for i in range(-d_min, d_min + 1.0):
		iAbs   = float(abs(i));
		pntCnt = d_max + -iAbs - 1.0;

		aPnt     = lerp(pCorner, pTop,  1.0 - float( iAbs / d_min ) );
		
		var sI = sign(i)
		if sI == 0:
			aPnt[0] *= 1;	
		else:
			aPnt[0] *= sI;
		bPnt     = Vector3(aPnt)
		bPnt[2]  = -bPnt[2];
		
		top.add_vertex( aPnt );
		for j in range(1, pntCnt):
			xPnt = lerp(aPnt, bPnt, j/pntCnt );
			top.add_vertex( xPnt );
		top.add_vertex( bPnt );

func _build_triangles( top, radius, div ):
	var d_min  = div - 1.0
	var d_max  = div * 2 - 1
	var aAbs
	var bAbs
	var aCnt
	var bCnt
	var minCnt
	var aIdx = 0
	var bIdx = 0
	var a
	var b
	var c
	var d
	for i in range(-d_min, d_min):
		aAbs   = abs( i );
		bAbs   = abs( i+1 )
		aCnt   = d_max + -aAbs
		bCnt   = d_max + -bAbs;
		bIdx   = aIdx + aCnt
		minCnt = min( aCnt, bCnt ) - 1;
		for j in range(0, minCnt):
			a = aIdx + j
			b = a + 1;
			d = bIdx + j;
			c = d + 1;
			if i < 0:
				top.add_triangle( a, b, c );
				top.add_triangle( c, d, a );
			else:
				top.add_triangle( a, b, d );
				top.add_triangle( b, c, d );
		if i < 0:
			a = aIdx + aCnt - 1;
			b = a + bCnt;
			c = b - 1;
		else:
			b = aIdx + aCnt - 1;
			a = b - 1;
			c = b + bCnt
		top.add_triangle( a, b, c );
		aIdx += aCnt;
		

func _into_array(n):
	var a = []
	
	for i in range(0, n):
		a.append(i)
		
	return a

func _random_quad_merge(top, seed = 100):
	var edges = _into_array(top.edges.size())
		
	edges.shuffle()
	var idx = edges.pop_back()
		
	while idx != null:
		OPS_Tri.tri_quad_from_edge(top, idx)
		idx = edges.pop_back()
#
	for he in top.halfEdges:
		if he.face == -1:
			OPS_Tri.tri_to_face(top, he.tri)

func _face_subdivide(top, out):
	var a
	var b
	var c 
	var d
	for f in top.faces:
		match f.halfEdges.size():
			4:
				a = top.get_vert_pos( top.halfEdges[ f.halfEdges[0] ].vertex )
				b = top.get_vert_pos( top.halfEdges[ f.halfEdges[1] ].vertex )
				c = top.get_vert_pos( top.halfEdges[ f.halfEdges[2] ].vertex )
				d = top.get_vert_pos( top.halfEdges[ f.halfEdges[3] ].vertex )
				OPS_Add.add_quad_subdivide(out, a, b, c, d)
