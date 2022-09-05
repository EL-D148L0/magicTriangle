
//testing setup start



[] spawn {
	 
	//_this = [[tre0, tre1, tre2, tre3, tre4, tre5, tre6, tre7, tre8, tre9, tre10, tre11]]; 
	_this = [synchronizedObjects trenchlist_4];

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
			if ((_thisOC distance _compOC) < _maxOCdistance) then { //i assume using distanceSqr is cheaper
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
	_positionsAndHeights = [];
	
	private _cellsize = getTerrainInfo#2;

	{
		_height = getTerrainHeight _x;
		_newPosAndHeight = + _x;
		_newPosAndHeight set [2, _height - _cellsize];
		_positionsAndHeights append [_newPosAndHeight];
	} foreach _pointsToModify;

	//deb_msg4 = _positionsAndHeights;
	[] call compile preprocessFileLineNumbers "MagicTriangle\scripts\createTrianglestoHole.sqf"; //uncomment this!!!!!!!!
	
	inter3 = 0;

	_trianglesPositionsAndObjects = [_blFromConfig, _terrainLines, _tftFromConfig] call createTrianglesToHole;
	setTerrainHeight [_positionsAndHeights, false];
	
	_trenchPoints = [];

	{
		_trenchPoints pushBackUnique (_x # 0);
		_trenchPoints pushBackUnique (_x # 1);
	} foreach _blFromConfig;
	
	_terrainPoints = [];

	{
		_terrainPoints pushBackUnique ((_x # 0) select [0,2]);
		_terrainPoints pushBackUnique ((_x # 1) select [0,2]);
	} foreach _terrainLines;
	
	_PTMForList = [];
	
	{
		_PTMForList pushBackUnique (_x select [0,2]);
	} foreach _pointsToModify;
	
	_thisTrenchListEntry = [_trenches, _PTMForList, _trianglesPositionsAndObjects, _tftFromConfig, _terrainLines, _terrainPoints, _blFromConfig, _trenchPoints];
	
	coveredTrenchList append [_thisTrenchListEntry];

	"done"

};
