_pos = position player;
getTerrainInfo params ["", "", "_cellsize", "_resolution"]; 
gridLinesStraight = []; 
gridLinesDiagonal = []; 
_pos apply {floor (_x / _cellsize)} params ["_x0", "_y0"]; 
for "_x" from ((_x0 - 10) max 0) to ((_x0 + 10) min _resolution) do { 
	for "_y" from ((_y0 - 10) max 0) to ((_y0 + 10) min _resolution) do { 
		private _p1 = [_x, _y] vectorMultiply _cellsize;   //bottom-left corner 
		private _p2 = [_x, _y + 1] vectorMultiply _cellsize;  //top-left corner 
		private _p3 = [_x + 1, _y] vectorMultiply _cellsize;  //bottom-right corner 
		// Positions are AGL, and Z value of 0 is already at the terrain surface (except on water surface). 
		// Just move them up a few centimeters so they're visible. 
		_p1 set [2, 0.0]; 
		_p2 set [2, 0.0]; 
		_p3 set [2, 0.0]; 

		gridLinesStraight pushBack [_p1, _p2]; 
		gridLinesStraight pushBack [_p1, _p3]; 
		gridLinesDiagonal pushBack [_p2, _p3]; 
	}; 

}; 



