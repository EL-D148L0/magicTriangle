

//_this = [position p1 # 0, position p1 # 1, position p2 # 0, position p2 # 1, position p3 # 0, position p3 # 1, position p4 # 0, position p4 # 1];







// test setup end ------------------------------------------------

params ["_x1", "_y1", "_x2", "_y2", "_x3", "_y3", "_x4", "_y4"];

//        http://thirdpartyninjas.com/blog/2008/10/07/line-segment-intersection/
// true if intersect, false if no intersect or coincident
// with a bit of extra room for no collision with matching corners

_denominator = ((_y4 - _y3) * (_x2 - _x1)) - ((_x4 - _x3) * (_y2 - _y1));

if (_denominator == 0) exitWith {false};


_numerator1 = ((_x4 - _x3) * (_y1 - _y3)) - ((_y4 - _y3) * (_x1 - _x3));
_numerator2 = ((_x2 - _x1) * (_y1 - _y3)) - ((_y2 - _y1) * (_x1 - _x3));

_u1 = _numerator1 / _denominator;
_u2 = _numerator2 / _denominator;

if (0.0001 <= _u1 && _u1 <= 0.9999 && 0.0001 <= _u2 && _u2 <= 0.9999) exitWith {true};
false;
