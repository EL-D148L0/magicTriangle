


//testing setup start



[] spawn {
	 
	//_this = [[tre0, tre1, tre2, tre3, tre4, tre5, tre6, tre7, tre8, tre9, tre10, tre11]]; 
	_this = [[oblist # 0]]

	// testing setup end

	params ["_trenches"];


	[] call compile preprocessFileLineNumbers "MagicTriangle\scripts\createHoleInGround.sqf";
	//[] call compile preprocessFileLineNumbers "MagicTriangle\scripts\getTerrainPointsToBeLowered.sqf"; // this new thing does not work yet

	_blFromConfig = [];
	_tftFromConfig = [];
	_ocFromConfig = [];
	{
		_thisTrench = _x;
		_blNames = getArray ((configOf _thisTrench) >> "trench_borderLines");
		_blPositions = [];
		{
			_thisblCoords = [_thisTrench modelToWorldWorld (_thisTrench selectionPosition [_x # 0, "Memory"]), _thisTrench modelToWorldWorld (_thisTrench selectionPosition [_x # 1, "Memory"])];
			_blPositions append [_thisblCoords];
		} foreach _blNames;
		
		_tftNames = getArray ((configOf _thisTrench) >> "trench_fillingTriangles");
		_tftPositions = [];
		{
			_thistftCoords = [_thisTrench modelToWorldWorld (_thisTrench selectionPosition [_x # 0, "Memory"]), _thisTrench modelToWorldWorld (_thisTrench selectionPosition [_x # 1, "Memory"]), _thisTrench modelToWorldWorld (_thisTrench selectionPosition [_x # 2, "Memory"])];
			_tftPositions append [_thistftCoords];
		} foreach _tftNames;
		
		_ocNames = getArray ((configOf _thisTrench) >> "trench_openCorners");
		_ocPositions = [];
		{
			_thisocCoords = (_thisTrench modelToWorldWorld (_thisTrench selectionPosition [_x, "Memory"]));
			_ocPositions append [_thisocCoords];
		} foreach _ocNames;
		
		_blFromConfig append _blPositions;
		_tftFromConfig append _tftPositions;
		_ocFromConfig append _ocPositions;
		
	} foreach _trenches;

	//oc stands for open corner
	_analysingOC = ((count _ocFromConfig) > 0);
	_maxOCdistance = 0.4; //maximum distance at which corners will be merged
	_maxOCdistanceSquared = _maxOCdistance ^ 2;
	_errorEndScript = false;
	while {_analysingOC} do {
		_thisOC = _ocFromConfig # 0;
		_ocListCompare = + _ocFromConfig;
		_ocListCompare deleteAt 0;
		_found = false;
		_matchingOC = [];
		for "_i" from 0 to ((count _ocListCompare) - 1) do {
			_compOC = _ocListCompare # _i;
			if ((_thisOC vectorDistance _compOC) < _maxOCdistance) then { //i assume using distanceSqr is cheaper
				_found = true;
				_matchingOC = _compOC;
				_ocListCompare deleteAt _i;
				break;
			};
		};
		
		if (!_found) then {
			errorOC = _thisOC;
			hint "Open corner detected" + str _thisOC;
			_errorEndScript = true;
			break;
		} else {
			_newPos = ((_thisOC vectorAdd _matchingOC) vectormultiply 0.5);
			
			for "_i" from 0 to ((count _blFromConfig) - 1) do {
				_thisElement = _blFromConfig # _i;
				for "_k" from 0 to ((count _thisElement) - 1) do {
					if (((_thisElement # _k) isEqualTo _thisOC) || ((_thisElement # _k) isEqualTo _matchingOC)) then {
						_thisElement set [_k, _newPos];
						_blFromConfig set [_i, _thisElement];
					}; 
				};
			};
			
			for "_i" from 0 to ((count _tftFromConfig) - 1) do {
				_thisElement = _tftFromConfig # _i;
				for "_k" from 0 to ((count _thisElement) - 1) do {
					if (((_thisElement # _k) isEqualTo _thisOC) || ((_thisElement # _k) isEqualTo _matchingOC)) then {
						_thisElement set [_k, _newPos];
						_tftFromConfig set [_i, _thisElement];
					}; 
				};
			};
			
			_ocFromConfig = + _ocListCompare;
		};
		_analysingOC = ((count _ocFromConfig) > 0); 
	};
	if (_errorEndScript) exitwith {"open corner"}; // stop if open corner 




	_pointsToModify = [_trenches] call makeManyHole;
	_terrainLines = [_pointsToModify] call getTerrainlines;
	//d = _terrainLines;
	



	
	_terrainPoints = [];

	{
		_terrainPoints pushBackUnique ((_x # 0) select [0,2]);
		_terrainPoints pushBackUnique ((_x # 1) select [0,2]);
	} foreach _terrainLines;
	
	_PTMForList = [];
	{
		_PTMForList pushBackUnique (_x select [0,2]);
	} foreach _pointsToModify;

	_allAffectedTP = (_terrainPoints + _PTMForList);//bad var name
	
	
	_clashingCoveredTrenches = [];
	
	_len = count coveredTrenchList;
	
	for "_i" from 0 to ((_len) - 1) do {
		if ((count (_PTMForList arrayIntersect ((coveredTrenchList # _i # 5) + (coveredTrenchList # _i # 1)))) > 0) then {
			_clashingCoveredTrenches append [_i];
		};
	};
	
	
	//setup for data storage 
	private _trenchesAdd = [];
	private _PTMForListAdd = [];
	private _trianglesPositionsAndObjectsAdd = [];
	private _tftFromConfigAdd = [];
	private _blFromConfigAdd = [];
	private _trenchPointsAdd = [];
	private _terrainPointsAdd = [];
	private _terrainPointsForList = + _terrainPoints;
	
	
	private _PTMForListToNotLower = [];
	
	// this is all done assuming that the trench objects do not intersect or get too close to each other or anything
	_trianglesToDelete = [];
	{
		private _thisCTLEntry = (coveredTrenchList # _x);
		
		_trenchesAdd append (_thisCTLEntry # 0);
		_PTMForListAdd append (_thisCTLEntry # 1);
		_tftFromConfigAdd append (_thisCTLEntry # 3);
		_blFromConfigAdd append (_thisCTLEntry # 6);
		_trenchPointsAdd append (_thisCTLEntry # 7);
		
		_terrainPointsAdd append ((_thisCTLEntry # 5) - _PTMForList);
		
		_terrainPointsForList = _terrainPointsForList - ((_thisCTLEntry # 5) + (_thisCTLEntry # 1));
		
		_PTMForListToNotLower append (_PTMForList arrayIntersect (_thisCTLEntry # 1));
		
		_clashTP = _PTMForList arrayIntersect ((_thisCTLEntry # 5) + (_thisCTLEntry # 1));
		private _deletedTriangles = [];
		{
			private _thisTrianglePos = _x # 0;
			private _thisTrianglePos2d = _thisTrianglePos apply {_x select [0, 2];};
			if ((count (_clashTP arrayIntersect _thisTrianglePos2d)) > 0) then {
				_deletedTriangles append [_thisTrianglePos];
				_trianglesToDelete append [_x # 1];
			} else {
				_trianglesPositionsAndObjectsAdd append [_x];
			};
		} foreach (_thisCTLEntry # 2);
		
		_openLines = [];
		_openPoints = [];
		_deletedTrianglesLines = [];
		{
			private _lines = [[_x # 0, _x # 1], [_x # 1, _x # 2], [_x # 2, _x # 0]];
			{_x sort true} foreach _lines;
			_deletedTrianglesLines append _lines;
		} foreach _deletedTriangles;
		
		{
			_thisDTL = _x;
			private _cnt = {_thisDTL isEqualTo _x} count _deletedTrianglesLines;
			if (_cnt == 1) then {
				// if the line in question does not connect to any clash points
				if (!((((_x # 0) select [0,2]) in _clashTP) || (((_x # 1) select [0,2]) in _clashTP))) then {
					_openLines append [_thisDTL];
				};
			};
		} foreach _deletedTrianglesLines;
		
		
		
		// this part removes all terrain lines that lie in the affected area
		_TPForTLRemoval = _allAffectedTP arrayIntersect ((_thisCTLEntry # 1));
		_terrainLinesNew = [];
		{
			if (!((((_x # 0) select [0,2]) in _TPForTLRemoval) || (((_x # 1) select [0,2]) in _TPForTLRemoval))) then {
				_terrainLinesNew append [_x];
			};
		} foreach _terrainLines;
		_terrainLines = _terrainLinesNew;
		
		
		deb_msg5 = + _terrainLines;
		//unsure about this part
		_terrainLines = _terrainLines + _openLines;
	} foreach _clashingCoveredTrenches;



	



	//remember to redo below this point EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
		
	//deb_msg4 = _positionsAndHeights;
	
	
	_positionsAndHeights = [];
	
	private _cellsize = getTerrainInfo#2;

	{
		_height = getTerrainHeight _x;
		_newPosAndHeight = + _x;
		_newPosAndHeight set [2, _height - _cellsize];
		_positionsAndHeights append [_newPosAndHeight];
	} foreach (_PTMForList - _PTMForListToNotLower);
	
	//modification was here
	
	deb_msg6 = + _terrainLines;
	deb_msg4 = _trianglesToDelete;
	
	_trenchPoints = [];
	{
		_trenchPoints pushBackUnique (_x # 0);
		_trenchPoints pushBackUnique (_x # 1);
	} foreach _blFromConfig;

	// recalculate terrainlines by finding all triangle lines that connect to two terrain points
	_terrainLines = [];
	_terrainPointsForListFinal = _terrainPointsForList + _terrainPointsAdd;
	//_allLines = [];
	
	
	
	
	//_thisTrenchListEntry = [_trenches + _trenchesAdd, (_PTMForList - _PTMForListToNotLower) + _PTMForListAdd, _trianglesPositionsAndObjects + _trianglesPositionsAndObjectsAdd, _tftFromConfig + _tftFromConfigAdd, _terrainLines, _terrainPointsForListFinal, _blFromConfig + _blFromConfigAdd, _trenchPoints + _trenchPointsAdd];
	
	

	"done"

};
