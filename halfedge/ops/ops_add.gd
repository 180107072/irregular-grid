extends Node

var Math = preload("res://util/math.gd").new()

func add_quad_face(top, a, b, c, d):
	var ai = top.add_vertex( a );
	var bi = top.add_vertex( b );
	var ci = top.add_vertex( c );
	var di = top.add_vertex( d );

	var ha0 = top.add_edge( ai, bi );
	var ha1 = top.add_edge( bi, ci );
	var ha2 = top.add_edge( ci, ai );

	var hb0 = top.add_edge( ci, di );
	var hb1 = top.add_edge( di, ai );
	var hb2 = top.add_edge( ai, ci );

	var triA = top.add_tri_from_half_edges( [ ha0, ha1, ha2 ] );
	var triB = top.add_tri_from_half_edges( [ hb0, hb1, hb2 ] );
	
	var face = top.add_face_from_half_edges( [ ha0, ha1, hb0, hb1 ] );
	triA.face = face.idx;
	triB.face = face.idx;
	
	ha0.face = face.idx;
	ha1.face = face.idx;
	ha2.face = face.idx;
	hb2.face = face.idx;

func add_quad_subdivide( top, a: Vector3, b: Vector3, c, d ):
	var ab = lerp( a, b, 0.5 );
	var bc = lerp( b, c, 0.5 );
	var cd = lerp( c, d, 0.5 );
	var da = lerp( d, a, 0.5 );

	var cp = (a + b + c + d) / 4;

	add_quad_face( top, a, ab, cp, da );
	add_quad_face( top, ab, b, bc, cp );
	add_quad_face( top, bc, c, cd, cp );
	add_quad_face( top, cd, d, da, cp );

func add_subdivide_tri(top, a, b, c, div = 2):
	var seg_a = Vector3.ZERO
	var seg_b = Vector3.ZERO
	var seg_c = Vector3.ZERO
	
	var row0 = [top.add_vertex(a)]
	var row1

	var t
	for i in range(1, div + 1):
		t = i / div
		seg_b = lerp(a, b, t)
		seg_c = lerp(a, c, t)
		
		row1 = [top.add_vertex(seg_b)]
		
		for j in range(1, i):
			t = j / i
			seg_a = lerp(seg_b, seg_c, t)
			row1.push_back(top.add_vertex(seg_a))
		
		row1.push_back(top.add_vertex(seg_c))
		
		for j in range(0, row0.size()):
			top.add_triangle(row1[j], row1[j + 1], row0[j])
			if j + 1 < row0.size():
				top.add_triangle(row0[ j ], row1[ j+1 ], row0[ j+1 ] )

		row0 = row1



func add_tri_subdivide_face(top, a, b, c):
	var ab = lerp(a, b, 0.5)
	var bc = lerp(b, c, 0.5)
	var ca = lerp(c, a, 0.5)
	var cp = (a + b + c) / 3

	add_quad_face(top, cp, ca, a, ab)
	add_quad_face(top, cp, ab, b, bc)
	add_quad_face(top, cp, bc, c, ca)
	
