params ["_trenches"];

private _blFromConfig = [];
private _tftFromConfig = [];
private _ocFromConfig = [];
{
	private _thisTrench = _x;
	private _blNames = getArray ((configOf _thisTrench) >> "trench_borderLines");
	private _blPositions = [];
	{
		private _thisblCoords = [_thisTrench modelToWorldWorld (_thisTrench selectionPosition [_x # 0, "Memory"]), _thisTrench modelToWorldWorld (_thisTrench selectionPosition [_x # 1, "Memory"])];
		_blPositions append [_thisblCoords];
	} foreach _blNames;
	
	private _tftNames = getArray ((configOf _thisTrench) >> "trench_fillingTriangles");
	_tftPositions = [];
	{
		private _thistftCoords = [_thisTrench modelToWorldWorld (_thisTrench selectionPosition [_x # 0, "Memory"]), _thisTrench modelToWorldWorld (_thisTrench selectionPosition [_x # 1, "Memory"]), _thisTrench modelToWorldWorld (_thisTrench selectionPosition [_x # 2, "Memory"])];
		_tftPositions append [_thistftCoords];
	} foreach _tftNames;
	
	private _ocNames = getArray ((configOf _thisTrench) >> "trench_openCorners");
	_ocPositions = [];
	{
		private _thisocCoords = (_thisTrench modelToWorldWorld (_thisTrench selectionPosition [_x, "Memory"]));
		_ocPositions append [_thisocCoords];
	} foreach _ocNames;
	
	_blFromConfig append _blPositions;
	_tftFromConfig append _tftPositions;
	_ocFromConfig append _ocPositions;
	
} foreach _trenches;

[_blFromConfig, _tftFromConfig, _ocFromConfig];