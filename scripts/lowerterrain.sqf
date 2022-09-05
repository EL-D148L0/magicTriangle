//lower terrain points



_point = ((position player) apply { cellWidth * round (_x / cellWidth) });
_point set [2, 0.0];
loweredPoints pushBackUnique _point;

_borderPointsNew = [[_point # 0 + cellWidth, _point # 1, _point # 2], [_point # 0 - cellWidth, _point # 1, _point # 2], [_point # 0, _point # 1 + cellWidth, _point # 2], [_point # 0, _point # 1 - cellWidth, _point # 2]];

if _borderPointsNew in 
{} foreach _borderPointsNew;

affectedBorderPoints pushBackUnique ();
