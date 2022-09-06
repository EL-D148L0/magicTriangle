
//TODO remove z coordinate from point comparisons when it's not needed
createTrianglesToHole = {
	params ["_borderLines", "_terrainLines", "_trenchFillingTriangles"];

	[] call compile preprocessFileLineNumbers "MagicTriangle\scripts\2dTriangleIntersect.sqf";

	{_x sort true} foreach _terrainLines;

	private _terrainPoints = [];

	{
		_terrainPoints pushBackUnique (_x # 0);
		_terrainPoints pushBackUnique (_x # 1);
	} foreach _terrainLines;



	private _triangles = [];
	private _usedSides = [];
	_usedSides append _terrainLines;
	// isEqualTo will deep compare arrays
	// + array will deep copy arrays


	_usedSides append _borderLines;



	//_triangles append _trenchFillingTriangles;






	//_triangles = [];
	private _running = true;
	private _count = 0;



	g = 0;
	l = 0;
	h = 0;
	
	
	
	
	// _possibleStartSides now in format [[[pos1, pos2], posOtherside], [[pos1b, pos2b], posOthersideb]]
	private _possibleStartSides = [];
	
	{_x sort true} foreach _borderLines;
	{
		private _thisBL = _x;
		private _extraPoint = [];
		_found = false;
		{
			private _thisTFT = _x;
			private _sides = [[_thisTFT # 0, _thisTFT # 1], [_thisTFT # 1, _thisTFT # 2], [_thisTFT # 2, _thisTFT # 0]];
			{_x sort true} foreach _sides;
			if ((_sides # 0) isEqualTo _thisBL) then {
				_extraPoint = _thisTFT # 2;
				_found = true;
				break;
			};
			if ((_sides # 1) isEqualTo _thisBL) then {
				_extraPoint = _thisTFT # 0;
				_found = true;
				break;
			};
			if ((_sides # 2) isEqualTo _thisBL) then {
				_extraPoint = _thisTFT # 1;
				_found = true;
				break;
			};
		} foreach _trenchFillingTriangles;
		if (!_found) throw "check trench configs, tft or bl not set up correctly";
		
		private _thisPSS = [_thisBL, _extraPoint];
		
		_possibleStartSides append [_thisPSS];
		
	} foreach _borderLines;
	
	
	
	//part of experimental ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	private _trenchPoints = [];

	{
		_trenchPoints pushBackUnique (_x # 0);
		_trenchPoints pushBackUnique (_x # 1);
	} foreach _borderLines;
	
	
	
	
	
	TestTriangle = [];
	startTime = diag_tickTime;

	while {_running} do {
		
		/*
		{_x sort true} foreach _usedSides;
		_possibleStartSides = [];
		{
			_i = _x;
			_cnt = {_i isEqualTo _x} count _usedSides;
			if (_cnt == 1) then {
				_possibleStartSides append [_i];
			};
		} foreach _usedSides;
		_possibleStartSides = _possibleStartSides - _terrainLines;
		*/

		//f = _possibleStartSides;

		// repeatable block start
		private _newPossibleStartSides = [];
		{
			private _possibleTriangles = [];
			private _thisPSS = + _x;
			private _line = _thisPSS # 0;
			private _extraPoint = _thisPSS # 1;
			{
				//timing thing
				g = g + 1;
				if (g == 10) then {
					TestTriangle = [_x, _extraPoint, _line #0, _line #1];
				};
				
				//first check, does it go backwards into what it came from?
				if ([_x, _extraPoint, _line #0, _line #1] call sameSide) then { 
					continue;
				};
				
				
				
				private _thisPT = [_line #0, _line #1, _x];  // _thisPossibleTriangle
				private _sides = [[_thisPT # 0, _thisPT # 1], [_thisPT # 1, _thisPT # 2], [_thisPT # 2, _thisPT # 0]];
				{_x sort true} foreach _sides;
				private _allowed = true;
				
				
				
				
				
				
				
				
				{ // compare with other used sides and sides consisting of two times the same point
					private _i = _x;
					_cnt = {_i isEqualTo _x} count _usedSides;
					if (_cnt > 1 || (_i # 0) isEqualTo (_i # 1)) then {
						_allowed = false;
						break;
					};
				} foreach _sides;
				
				if (!_allowed) then {
					continue;
				};
				
				
				// check if triangle is extremely flat
				_sa = (_thisPT # 0) distance2D (_thisPT # 1); 
				_sb = (_thisPT # 1) distance2D (_thisPT # 2); 
				_sc = (_thisPT # 2) distance2D (_thisPT # 0);
				if ((_sb == 0) || (_sc == 0)) then { //checking this because once i got an error zero divisor on the angle calculation
					_allowed = false;
					continue;
				};
				_angle1 = acos (((_sb ^ 2) + (_sc ^ 2) - (_sa ^ 2)) / (2 * _sb * _sc));
				if (_angle1 < 3 || _angle1 > 177) then {
					_allowed = false;
					continue;
				};
				
				
				//part of experimental ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				/*
				{	//check if any terrain points are in the triangle
					if ([_x, _thisPT] call pointInTriangleLA) then {
						_allowed = false;
						break;
					};
				} foreach _terrainPoints;
				
				
				if (!_allowed) then {
					continue;
				};*/
				{	//check if any terrain or trench points are in the triangle
					/*if ([_x, _thisPT] call pointInTriangleLA) then {
						_allowed = false;
						break;
					};*/
					if ((!(_x in _thisPT)) && (_x inPolygon _thisPT)) then {
						_allowed = false;
						break;
					};
				} foreach (_terrainPoints + _trenchPoints);
				
				
				if (!_allowed) then {
					continue;
				};
				
				
				{ // check if triangle intersects terrain lines
					if (([_x # 0, _extraPoint, _line #0, _line #1] call sameSide) && {[_x # 1, _extraPoint, _line #0, _line #1] call sameSide}) then { 
						continue;
					};
					private _x1 = (_x # 0) # 0;
					private _y1 = (_x # 0) # 1;
					private _x2 = (_x # 1) # 0;
					private _y2 = (_x # 1) # 1;
					private _t2 = _thisPT;
					private _int1 = ([_x1, _y1, _x2, _y2, (_t2 # 0) # 0, (_t2 # 0) # 1, (_t2 # 1) # 0, (_t2 # 1) # 1] call linesIntersect) || ([_x1, _y1, _x2, _y2, (_t2 # 1) # 0, (_t2 # 1) # 1, (_t2 # 2) # 0, (_t2 # 2) # 1] call linesIntersect) || ([_x1, _y1, _x2, _y2, (_t2 # 2) # 0, (_t2 # 2) # 1, (_t2 # 0) # 0, (_t2 # 0) # 1] call linesIntersect);
					if (_int1) then {
						_allowed = false;
						
						break;
					};
				} foreach _terrainLines;
				
				
				if (!_allowed) then {
					continue;
				};
				
				
				// check if one side of the triangle covers 2 terrainlines at once.   added to fix a very specific bug.
				
				private _p1 = [(_thisPT # 1 # 0 + _thisPT # 2 # 0)/2, (_thisPT # 1 # 1 + _thisPT # 2 # 1)/2];
				private _p2 = [(_thisPT # 0 # 0 + _thisPT # 2 # 0)/2, (_thisPT # 0 # 1 + _thisPT # 2 # 1)/2];
				private _p3 = [(_thisPT # 0 # 0 + _thisPT # 1 # 0)/2, (_thisPT # 0 # 1 + _thisPT # 1 # 1)/2];
				{
					_x2d = [_x # 0, _x # 1];
					if ((_p1 isEqualTo _x2d) || (_p2 isEqualTo _x2d) || (_p3 isEqualTo _x2d)) then {
						_allowed = false;
						
						break;
					};
				} foreach _terrainPoints;
				
				
				if (!_allowed) then {
					continue;
				};
				
				{ //check if triangle intersects any other triangle (overused and probably expensive)
					l = l + 1;
						
					if ((([_x # 0, _extraPoint, _line #0, _line #1] call sameSide) && {[_x # 1, _extraPoint, _line #0, _line #1] call sameSide}) && {[_x # 2, _extraPoint, _line #0, _line #1] call sameSide}) then { 
						continue;
					};
					h = h + 1;
					
					if ([_thisPT, _x] call triangleIntersect) then {
						_allowed = false;
						break;
					};
				} foreach _triangles;// + _trenchFillingTriangles;// no longer necessary
				
				
				if (!_allowed) then {
					continue;
				};
				
				
				
				
				if (_allowed) then {
					_possibleTriangles append [_thisPT];
				};
				
			} foreach (_terrainPoints + _trenchPoints); //experimental thing here --------------------------------------------------------------------------------------------------------------------------------------------------
			
			if ((count _possibleTriangles) == 0) then {
				continue;
			};
			
			//s = _possibleTriangles;
			//_possibleTrianglesSorted = [_possibleTriangles, [], {selectMax [abs ((_x # 0) distance2D (_x # 1)), abs ((_x # 1) distance2D (_x # 2)), abs ((_x # 2) distance2D (_x # 0))]}, "ASCEND"] call BIS_fnc_sortBy;
			
			
			private _possibleTrianglesSorted = [_possibleTriangles, [], {_sa = (_x # 0) distance2D (_x # 1); _sb = (_x # 1) distance2D (_x # 2); _sc = (_x # 2) distance2D (_x # 0);selectMin [acos (((_sb ^ 2) + (_sc ^ 2) - (_sa ^ 2)) / (2 * _sb * _sc)), acos (((_sa ^ 2) + (_sc ^ 2) - (_sb ^ 2)) / (2 * _sa * _sc)), acos (((_sa ^ 2) + (_sb ^ 2) - (_sc ^ 2)) / (2 * _sa * _sb))]}, "DESCEND"] call BIS_fnc_sortBy;
			
			
			//_possibleTrianglesSorted = [_possibleTriangles, [], {selectMax [abs vectormagnitude ((vectorNormalized (_x # 0 vectordiff _x # 1)) vectorcrossproduct (vectorNormalized (_x # 2 vectordiff _x # 1))), abs vectormagnitude ((vectorNormalized (_x # 1 vectordiff _x # 0)) vectorcrossproduct (vectorNormalized (_x # 2 vectordiff _x # 0))), abs vectormagnitude ((vectorNormalized (_x # 0 vectordiff _x # 2)) vectorcrossproduct (vectorNormalized (_x # 1 vectordiff _x # 2)))]}, "ASCEND"] call BIS_fnc_sortBy;
			
			_finaltriangle = _possibleTrianglesSorted # 0;
			//_finaltrianglestill in format [_line #0, _line #1, thirdpoint];
			
			_sides = [[_finalTriangle # 0, _finalTriangle # 1], [_finalTriangle # 1, _finalTriangle # 2], [_finalTriangle # 2, _finalTriangle # 0]];
			{_x sort true} foreach _sides;
			_sn0 = [_finalTriangle # 1, _finalTriangle # 2];
			_sn0 sort true;
			_sn1 = [_finalTriangle # 0, _finalTriangle # 2];
			_sn1 sort true;
			_sn2 = [_finalTriangle # 1, _finalTriangle # 0];
			_sn2 sort true;
			
			if (!(_sn0 in _usedSides)) then {
				_newPossibleStartSides append [[_sn0, _finalTriangle # 0]];
			};
			if (!(_sn1 in _usedSides)) then {
				_newPossibleStartSides append [[_sn1, _finalTriangle # 1]];
			};
			if (!(_sn2 in _usedSides)) then {
				//this should never happen, i have it here just to be sure
				_newPossibleStartSides append [[_sn2, _finalTriangle # 2]];
			};
			
			
			
			/*
			
			if (_finaltriangle isEqualTo [[1992,5536,9.34],[1997.15,5534.67,8.75883],[1996,5540,9.7]]) then {l = [(_sn0 in _usedSides), (_sn1 in _usedSides), (_sn2 in _usedSides)];};
			*/
			
			
			
			_usedSides append _sides;
			_triangles append [_finaltriangle];
			
			
			// make used triangle sides list and blacklist sides from being used more than 2 times, put _borderLines into it as well as the sides of the hole in the ground.
		} foreach _possibleStartSides;


		/*
		{_x sort true} foreach _usedSides;
		_possibleStartSides = [];
		{
			_i = _x;
			_cnt = {_i isEqualTo _x} count _usedSides;
			if (_cnt == 1) then {
				_possibleStartSides append [_i];
			};
		} foreach _usedSides;
		_possibleStartSides = _possibleStartSides - _terrainLines;
		*/
		
		_possibleStartSides = + _newPossibleStartSides;
		
		if ((count _possibleStartSides) == 0) then {
			_running = false;
		};
		_count = _count + 1;
		if (_count == 6) exitwith {msg = "triangle creation ended with possible sides left"};
	};
	
	endTime = diag_tickTime;


	//f = _possibleStartSides;

	// [position p1 # 0, position p1 # 1, position p2 # 0, position p2 # 1, position p3 # 0, position p3 # 1, position p4 # 0, position p4 # 1] call compile preprocessFileLineNumbers "MagicTriangle\scripts\2dLineIntersect.sqf";





	triangles = _triangles;
	d = [];
	
	private _trianglesPositionsAndObjects = [];

	{
		_obj = _x call compile preprocessFileLineNumbers "MagicTriangle\scripts\createTriangle.sqf";
		_obj setObjectTextureGlobal [0, surfaceTexture getpos _obj];
		d append [_obj];
		_trianglesPositionsAndObjects append [[_x, _obj]]
	} foreach _triangles;
	
	_trianglesPositionsAndObjects;
};