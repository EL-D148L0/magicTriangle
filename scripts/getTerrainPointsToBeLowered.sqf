



makeManyHole = {
	params ["_tronches", ["_loweredPoints", []]];
	private _pointsToModify = [];
	{
		_pointsToModify append ([_x] call makeSingleHole);
		//_pointsToModify = [_x, _pointsToModify, _loweredPoints] call makeSingleHoleNew;
	} foreach _tronches;
	
	private _pointsToModify2 = [];
	{
		//_pointsToModify append ([_x] call makeSingleHole);
		_pointsToModify2 pushbackunique _x;
	} foreach _pointsToModify;
	
	_pointsToModify = _pointsToModify2;
	{
		//_pointsToModify append ([_x] call makeSingleHole);
		_pointsToModify = [_x, _pointsToModify, _loweredPoints] call makeSingleHoleNew;
	} foreach _tronches;
	_pointsToModify;
};


linesIntersect2dPoint = {
	//input: [[p1, p2], [p3, 4]]
	//        http://thirdpartyninjas.com/blog/2008/10/07/line-segment-intersection/
	/* returns [result, point]
	* result: boolean
	* 	is point found?
	* point: position2D
	*	if no point found, defaults to [0,0]
	*
	*	for coincident lines it will return no intersection
	*
	*/
	scopename "linesIntersect";
	params ["_l1", "_l2"];
	_l1 params ["_p1", "_p2"];
	_l2 params ["_p3", "_p4"];
	_p1 params ["_x1", "_y1"];
	_p2 params ["_x2", "_y2"];
	_p3 params ["_x3", "_y3"];
	_p4 params ["_x4", "_y4"];
	
	

	_denominator = ((_y4 - _y3) * (_x2 - _x1)) - ((_x4 - _x3) * (_y2 - _y1));


	if (_denominator == 0) then {
		[false, [0,0]] breakOut "linesIntersect";
		//if (!_coincident) //exitwith {hint "BOING!!"; false};
	};
	
	
	_numerator1 = ((_x4 - _x3) * (_y1 - _y3)) - ((_y4 - _y3) * (_x1 - _x3));
	_numerator2 = ((_x2 - _x1) * (_y1 - _y3)) - ((_y2 - _y1) * (_x1 - _x3));
	
	_u1 = _numerator1 / _denominator;
	_u2 = _numerator2 / _denominator;

	if (!(0 <= _u1 && _u1 <= 1 && 0 <= _u2 && _u2 <= 1)) then {
		[false, [0,0]] breakOut "linesIntersect";
	};
	
	private _point = [(_x1 + _u1 * (_x2 - _x1)), (_y1 + _u1 * (_y2 - _y1))];
	
	[true, _point];
};




makeSingleHoleNew = {
	
	/*
	 * Author: EL_D148L0
	 * calculates terrain points to be lowered for a individual trench object while taking  objects that have already been lowered into account.
	 *
	 * Arguments:
	 * 0: Trench Object <OBJECT>
	 * 1: list of unlowered positions that will be lowered later <ARRAY>
	 * 		contains Position2d of said positions
	 * 2: list of positions that have already been lowered and shall not be lowered again <ARRAY>
	 * 		contains Position2d of said positions
	 *
	 * Return Value:
	 * new list of unlowered positions that will be lowered later, including the passed positions
	 *
	 * Example:
	 * [_trench, _pointsToModify2, _loweredPoints] call makeSingleHoleNew;
	 *
	 * Public: IDK
	 */
	
	
	
	//TODO probably add the lines intersection thing depending on how this turns out
	
	params ["_trenchObject", "_pointsToModify", "_loweredPoints"];



	private _cellsize = getTerrainInfo#2;
	private _bbx = boundingBoxReal _trenchObject; //ex. [[-2.97321,-1.49712,-1.12321],[2.97321,1.49712,1.12321],3.40112]
	private _p1 = _bbx # 0;
	private _p2 = _bbx # 1;
	private _bbsr = _bbx # 2;




	//_p2 set [2, _p1 # 2];


	private _xWidth = (_p2 # 0) - (_p1 # 0);
	private _yWidth = (_p2 # 1) - (_p1 # 1);

	private _padding = 0;
	

	private _p1r = _trenchObject modelToWorldWorld _p1;
	private _p2r = _trenchObject modelToWorldWorld _p2;
	
	private _bbxCenter  = ((_p1) vectoradd (_p2)) vectorMultiply 0.5;
	private _bbxCenterWorld = _trenchObject modelToWorldWorld _bbxCenter;


	private _area = [_bbxCenterWorld, abs (_p1 # 0 - _bbxCenter # 0), abs (_p1 # 1 - _bbxCenter # 1), getdir _trenchObject, true, -1];



	(_bbxCenterWorld apply {round (_x / _cellsize)}) params ["_x0", "_y0"];
	
	private _step = ceil(_bbsr / _cellsize);


	//private _pointsToModify = []; // change this to take up stuff from arguments for being able to add to holes over time 
	private _interestingTerrainLines = [];
	//hint "BOING!!";

	for "_x" from (_x0 - _step) to (_x0 + _step) do {
		for "_y" from (_y0 - _step) to (_y0 + _step) do {
			private _pos1 = [_x, _y] vectorMultiply _cellsize;	
			if (_pos1 inArea _area) then {
				if (!(_pos1 in (_loweredPoints))) then {
					_pointsToModify pushbackunique ( + _pos1);
				};
			};
		};
	};
	
	for "_x" from ((_x0 - _step) - 1) to (_x0 + _step) do {
		for "_y" from ((_y0 - _step) - 1) to (_y0 + _step) do {
			private _pos1 = [_x, _y] vectorMultiply _cellsize;	
			private _pos2 = [_x + 1, _y] vectorMultiply _cellsize;	
			private _pos3 = [_x, _y + 1] vectorMultiply _cellsize;	
			_interestingTerrainLines append [[_pos1, _pos2], [_pos1, _pos3], [_pos2, _pos3]];
		};
	};

	private _horizontalLinesModel = [[_p1, [_p1 # 0, _p2 # 1]], [_p1, [_p2 # 0, _p1 # 1]], [_p2, [_p1 # 0, _p2 # 1]], [_p2, [_p2 # 0, _p1 # 1]]];
	
	private _collidingLines = [];// format [[[tlp1, tlp2], [hl1, hl2], ip]]
	
	
	private _horizontalLinesWorld = [];
	
	private _bottomPointsModel = [_p1, [_p1 # 0, _p2 # 1, _p1 # 2], [_p2 # 0, _p2 # 1, _p1 # 2], [_p2 # 0, _p1 # 1, _p1 # 2]];
	private _bottomPointsWorld = _bottomPointsModel apply {_trenchObject modelToWorldWorld _x;};
	
	//private _loweringAmount = _cellsize;
	private _loweringAmount = 20;
	
	
	deb_loopcount2 = 0;
	{
		deb_loopcount2 = deb_loopcount2 + 1;
		private _thisBPW = _x;
		private _tp1 = (_thisBPW apply {floor (_x / _cellsize);}) vectorMultiply _cellsize;
		private _tp2 = _tp1 vectoradd [_cellsize, 0, 0];
		private _tp3 = _tp1 vectoradd [0, _cellsize, 0];
		if (!(_thisBPW inPolygon [_tp1, _tp2, _tp3])) then {
			_tp1 = _tp1 vectoradd [_cellsize, _cellsize, 0];
		};
		
		
		private _tp1flag = false;
		_tp1 set [2, getTerrainHeight _tp1];
		if ((_tp1 select [0,2]) in _pointsToModify) then {
			_tp1 = _tp1 vectoradd [0,0, - _loweringAmount];
			_tp1flag = true;
		} else {
			if ((_tp1 select [0,2]) in _loweredPoints) then {
				_tp1flag = true;
			};
		};
		
		private _tp2flag = false;
		_tp2 set [2, getTerrainHeight _tp2];
		if ((_tp2 select [0,2]) in _pointsToModify) then {
			_tp2 = _tp2 vectoradd [0,0, - _loweringAmount];
			_tp2flag = true;
		} else {
			if ((_tp2 select [0,2]) in _loweredPoints) then {
				_tp2flag = true;
			};
		};
		
		private _tp3flag = false;
		_tp3 set [2, getTerrainHeight _tp3];
		if ((_tp3 select [0,2]) in _pointsToModify) then {
			_tp3 = _tp3 vectoradd [0,0, - _loweringAmount];
			_tp3flag = true;
		} else {
			if ((_tp3 select [0,2]) in _loweredPoints) then {
				_tp3flag = true;
			};
		};
		
		
		
		private _dist1 = _tp1 distance2d _thisBPW;
		private _dist2 = _tp2 distance2d _thisBPW;
		private _dist3 = _tp3 distance2d _thisBPW;
		
		deb_loopcount = 0;
		
		if (deb_loopcount2 == 2) then {deb_msg3 = [_tp1flag, _tp2flag, _tp3flag, _dist1, _dist2, _dist3, _tp1, _tp2, _tp3, _thisBPW, _pointsToModify];};
		
		
		private _done = _tp1flag && _tp2flag && _tp3flag;
		
		while {!_done} do {
		
			
			//if (deb_loopcount == 100) then {deb_msg = [_tp1flag, _tp2flag, _tp3flag, _dist1, _dist2, _dist3];};
			
			private _l0 = _thisBPW;
			private _p0 = _tp1;
			private _l = [0,0,1];
			private _n = vectorNormalized ((_tp3 vectorDiff _tp1) vectorCrossProduct (_tp2 vectorDiff _tp1));
			
		
			private _d = ((_p0 vectorDiff _l0) vectorDotProduct _n) / (_l vectorDotProduct _n);
			// if d is negative l0 should be above the triangle
			
			
			//if (true) then {_tp1 = _tp1 vectoradd [0,0,-200];};
			//private _p0 = _tp1;
			deb_msg = [_l0, _p0, _l, _n, _d];
			
			if (_d <= 0) then {
				_done = true;
				deb_loopcount = deb_loopcount + 1;
				break;
			};
			
			if ((!_tp1flag) && (_tp2flag || _dist2 >= _dist1) && (_tp3flag || _dist3 >= _dist1)) then {
				_tp1 = _tp1 vectoradd [0,0, - _loweringAmount];
				_pointsToModify pushbackunique (_tp1 select [0,2]);
				_tp1flag = true;
			};
			
			if ((!_tp2flag) && (_tp1flag || _dist1 >= _dist2) && (_tp3flag || _dist3 >= _dist2)) then {
				_tp2 = _tp2 vectoradd [0,0, - _loweringAmount];
				_pointsToModify pushbackunique (_tp2 select [0,2]);
				_tp2flag = true;
			};
			
			if ((!_tp3flag) && (_tp2flag || _dist2 >= _dist1) && (_tp1flag || _dist1 >= _dist3)) then {
				deb_msg2 = [];
				deb_msg2 append [ + _tp3];
				_tp3 = _tp3 vectoradd [0,0, - _loweringAmount];
				deb_msg2 append [ + _tp3];
				_pointsToModify pushbackunique (_tp3 select [0,2]);
				_tp3flag = true;
			};
			
			_done = _tp1flag && _tp2flag && _tp3flag;
			
		};
		
		
	} foreach _bottomPointsWorld;
	
	
	
	
	
	
	_pointsToModify;
};