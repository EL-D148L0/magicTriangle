

sameSide = {
	params ["_p1", "_p2", "_a", "_b"];
	// are 2d or 3d vectors
	// does some rounding fuckery to fit my needs, do not use for unrelated stuff
	// a and b are the end points of the line
	private _v1 = [_b # 0 - _a # 0, _b # 1 - _a # 1];
	private _cp1 = (_v1) vectorCrossProduct ([_p1 # 0 - _a # 0, _p1 # 1 - _a # 1]);
	private _cp2 = (_v1) vectorCrossProduct ([_p2 # 0 - _a # 0, _p2 # 1 - _a # 1]);
	private _f = (_cp1 #2) * (_cp2 #2);
	(_f > 0.001);
};


//[position p1, position p2, position g1, position g2] call sameSide;


pointInTriangle = {
	params ["_p1", "_a", "_b", "_c"];
	//private _r1 = (_this # 0) inPolygon [_this # 1, _this # 2, _this # 3];
	//private _r2 = ([_p1, _a, _b, _c] call sameSide) && ([_p1, _b, _a, _c] call sameSide) && ([_p1, _c, _a, _b] call sameSide);
	
	//if (isNil "_r1") then {msg1 = "WEEWOO";};
	//if (isNil "_r2") then {msg1 = "AAAAAAAA";};
	//if (_r1 != _r2) then {msg1 = "OOOOOOOOOO"; k = [_p1, _a, _b, _c];};
	
	//_r1;
	
	
	([_p1, _a, _b, _c] call sameSide) && ([_p1, _b, _a, _c] call sameSide) && ([_p1, _c, _a, _b] call sameSide);
	//(_this # 0) inPolygon [_this # 1, _this # 2, _this # 3];
	
};

pointInTriangleLA = {
	//LA for less args
	params ["_p1", "_t"];
	[_p1, _t # 0, _t # 1, _t # 2] call pointInTriangle;
};



//[position p1, position g1, position g2, position g3] call pointInTriangle;

linesIntersect = {
	scopename "linesIntersect";
	params ["_x1", "_y1", "_x2", "_y2", "_x3", "_y3", "_x4", "_y4"];

	//        http://thirdpartyninjas.com/blog/2008/10/07/line-segment-intersection/
	// true if intersect, false if no intersect or coincident
	// with a bit of extra room for no collision with matching corners

	_denominator = ((_y4 - _y3) * (_x2 - _x1)) - ((_x4 - _x3) * (_y2 - _y1));


	if (_denominator < 0.0001 && _denominator > -0.0001) then {
		false breakOut "linesIntersect";
		//if (!_coincident) //exitwith {hint "BOING!!"; false};
	};
	
	
	_numerator1 = ((_x4 - _x3) * (_y1 - _y3)) - ((_y4 - _y3) * (_x1 - _x3));
	_numerator2 = ((_x2 - _x1) * (_y1 - _y3)) - ((_y2 - _y1) * (_x1 - _x3));
	
	_u1 = _numerator1 / _denominator;
	_u2 = _numerator2 / _denominator;

	if (0.0001 <= _u1 && _u1 <= 0.9999 && 0.0001 <= _u2 && _u2 <= 0.9999) exitWith {true};
	
	_ac = 100;
	_ab = 50;
	_bc = 0;
	
	
	
	
	if (_x1 == _x3 && _y1 == _y3) then {
		_ac = [_x1, _y1] distance2D [_x2, _y2]; 
		_ab = [_x1, _y1] distance2D [_x4, _y4]; 
		_bc = [_x4, _y4] distance2D [_x2, _y2]; 
	} else {
		if (_x1 == _x4 && _y1 == _y4) then {
			_ac = [_x1, _y1] distance2D [_x2, _y2]; 
			_ab = [_x1, _y1] distance2D [_x3, _y3]; 
			_bc = [_x3, _y3] distance2D [_x2, _y2]; 
		} else {
			if (_x2 == _x3 && _y2 == _y3) then {
				_ac = [_x2, _y2] distance2D [_x1, _y1]; 
				_ab = [_x2, _y2] distance2D [_x4, _y4]; 
				_bc = [_x4, _y4] distance2D [_x1, _y1]; 
			} else {
				if (_x2 == _x4 && _y2 == _y4) then {
					_ac = [_x2, _y2] distance2D [_x1, _y1]; 
					_ab = [_x2, _y2] distance2D [_x3, _y3]; 
					_bc = [_x3, _y3] distance2D [_x1, _y1]; 
				} else {
					false breakOut "linesIntersect";
				};
			};
		};
	};
	
	_diff1 = _ac + _bc - _ab;
	_diff2 = _ab + _bc - _ac;
	
	//is this shit still needed???

	if (_diff1 < 0.02 || _diff2 < 0.02) then {true breakOut "linesIntersect";};
	
	false;
};



triangleIntersect = {
	/*
	*	no longer an accurate check of trinagle intersection. triangle in triangle is not checked.
	*
	*
	*
	*/
	_deb1 = false;
	
	params ["_t1", "_t2"];
	private _t10 = (_t1 # 0);
	private _t11 = (_t1 # 1);
	private _t12 = (_t1 # 2);
	private _t20 = (_t2 # 0);
	private _t21 = (_t2 # 1);
	private _t22 = (_t2 # 2);
	
	private _t100 = (_t10 # 0);
	private _t110 = (_t11 # 0);
	private _t120 = (_t12 # 0);
	private _t200 = (_t20 # 0);
	private _t210 = (_t21 # 0);
	private _t220 = (_t22 # 0);
	
	private _t101 = (_t10 # 1);
	private _t111 = (_t11 # 1);
	private _t121 = (_t12 # 1);
	private _t201 = (_t20 # 1);
	private _t211 = (_t21 # 1);
	private _t221 = (_t22 # 1);
	
	//if
	((((((((([_t100, _t101, _t110, _t111, _t200, _t201, _t210, _t211] call linesIntersect) || 
	{([_t100, _t101, _t110, _t111, _t210, _t211, _t220, _t221] call linesIntersect)}) || 
	{([_t100, _t101, _t110, _t111, _t220, _t221, _t200, _t201] call linesIntersect)}) || 
	{([_t110, _t111, _t120, _t121, _t200, _t201, _t210, _t211] call linesIntersect)}) || 
	{([_t110, _t111, _t120, _t121, _t210, _t211, _t220, _t221] call linesIntersect)}) || 
	{([_t110, _t111, _t120, _t121, _t220, _t221, _t200, _t201] call linesIntersect)}) || 
	{([_t120, _t121, _t100, _t101, _t200, _t201, _t210, _t211] call linesIntersect)}) || 
	{([_t120, _t121, _t100, _t101, _t210, _t211, _t220, _t221] call linesIntersect)}) || 
	{([_t120, _t121, _t100, _t101, _t220, _t221, _t200, _t201] call linesIntersect)});
	
	//this part is no longer needed i believe
	/*{([_t10, _t2] call pointInTriangleLA);});|| 
	{([_t11, _t2] call pointInTriangleLA)}) || 
	{([_t12, _t2] call pointInTriangleLA)}) || 
	{([_t20, _t1] call pointInTriangleLA)}) || 
	{([_t21, _t1] call pointInTriangleLA)}) || 
	{([_t22, _t1] call pointInTriangleLA)}) //;
	then {if (_deb1) then {debTri append [_this]}; true;} else {pass = pass + 1; false;};*/
};





//[[position p1, position p2, position p3], [position g1, position g2, position g3]] call triangleIntersect;


