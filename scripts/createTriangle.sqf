//create a triangle from array of 3 points in format PositionASL

//_this = [getPosASL a, getPosASL b, getPosASL c];


//pos1 should be highest y (if multiple highest x)






//pos1 should be the closest to 90 degrees
_posAVG = ((_this # 0) vectorAdd ((_this # 1) vectorAdd (_this # 2))) vectorMultiply (1/3);



_this = [_this, [_posAVG], {
	_diff = _x vectorDiff _input0;
	_diff # 1 atan2 _diff # 0
}, "DESCEND"] call BIS_fnc_sortBy;



params ["_pos1", "_pos2", "_pos3"];


_triangleClass = "Triangle";

private _cellsize = getTerrainInfo#2;
if (_cellsize > 5) then {
	_triangleClass = "TriangleLarge";
};


_triangleObject = createVehicle [_triangleClass, ASLtoAGL _pos1,  [], 0, "CAN_COLLIDE"];
_triangleObject setvectordirandup [[0,1,0], [0,0,1]];

_pos2Diff = _pos2 vectorDiff (_triangleObject modelToWorldWorld (_triangleObject selectionPosition ["Corner_2_Pos", "Memory"]));
_triangleObject animate ["Corner_2_LR", _pos2Diff # 0, true];
_triangleObject animate ["Corner_2_FB", _pos2Diff # 1, true];
_triangleObject animate ["Corner_2_UD", _pos2Diff # 2, true];


_pos3Diff = _pos3 vectorDiff (_triangleObject modelToWorldWorld (_triangleObject selectionPosition ["Corner_3_Pos", "Memory"]));
_triangleObject animate ["Corner_3_LR", _pos3Diff # 0, true];
_triangleObject animate ["Corner_3_FB", _pos3Diff # 1, true];
_triangleObject animate ["Corner_3_UD", _pos3Diff # 2, true];


_triangleObject;


//c setpos (_triangleObject modelToWorld (_triangleObject selectionPosition ["Corner_3_Pos", "Memory"]));


//_triangleObject animate [Corner_3_LR, 1]