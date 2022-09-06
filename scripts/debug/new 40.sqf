
_trenchObject = tr3;

private _cellsize = getTerrainInfo#2;
private _bbx = boundingBoxReal _trenchObject;
private _p1 = _bbx # 0;
private _p2 = _bbx # 1;





_p2 set [2, _p1 # 2];


_xWidth = (_p2 # 0) - (_p1 # 0);
_yWidth = (_p2 # 1) - (_p1 # 1);



[1,2,3] vectorMultiply 3;

diag_codePerformance [{[1,2,3] vectorMultiply 3;}, 0, 10000];
[0.0006,10000]
diag_codePerformance [{[1,2,3] apply {_x * 3}}, 0, 10000];
[0.0018,10000]

_a = [[[2008.99,5531.68,6.51144],[2012,5528,6.24],[2012,5544,6.28]],
[[2008.99,5531.68,6.51144],[2011.43,5534.67,6.52226],[2012,5532,6.24]]];

_a = [[[2004.24,5513.73,6.60183],[2008,5508,6.69],[2008,5540,7.02]],
[[2004.24,5513.73,6.60183],[2006.71,5516.71,6.71565],[2008,5512,6.7]]];

g1 setposworld _a#0#0;// g is red
g2 setposworld _a#0#1;
g3 setposworld _a#0#2;

p1 setposworld _a#1#0;//p is blue
p2 setposworld _a#1#1;
p3 setposworld _a#1#2;


diag_codePerformance [{tr3 worldToModel [1700.53,5232.48];}, 0, 10000];

[[2008,5540,7.02],[2008,5544,7.91],[2012.38,5538.97,6.34183],[2008,5540,7.02]]


[2008,5540,7.02] inPolygon [[2008,5544,7.91],[2012.38,5538.97,6.34183],[2008,5540,7.02]];


 
diag_codePerformance [{[1000,1000,0] inPolygon [[0,0,0],[1000,1000,0],[1000,0,0]];}, 0, 1000000]; 
[0.00110476,905174]



diag_codePerformance [{[[1000,1000,0],[0,0,0],[1000,1000,0],[1000,0,0]] call pointInTriangle;}, 0, 1000000]; 
[0.0171427,58334]