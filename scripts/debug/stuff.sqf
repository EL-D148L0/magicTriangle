[[[3203.98,11923.7,32.9928],[3203.65,11925.6,33.0993]],
[[3203.65,11925.6,33.0993],[3205.96,11928,33.6531]],
[[3205.96,11928,33.6531],[3207.99,11928,33.9547]],
[[3207.99,11928,33.9547],[3208.23,11926,33.8243]],
[[3208.23,11926,33.8243],[3206,11923.5,33.2759]],
[[3206,11923.5,33.2759],[3203.98,11923.7,32.9928]]]


[[[3203.98,11923.7,32.9928],[3203.65,11925.6,33.0993],[3205.96,11928,33.6531]],
[[3203.98,11923.7,32.9928],[3205.96,11928,33.6531],[3207.99,11928,33.9547]],
[[3203.98,11923.7,32.9928],[3207.99,11928,33.9547],[3208.23,11926,33.8243]],
[[3203.98,11923.7,32.9928],[3208.23,11926,33.8243],[3206,11923.5,33.2759]]]



[[[3202.5,11932.5,33.4801],[3202.5,11928.8,33.2001]],
[[3198.75,11928.8,32.7101],[3202.5,11928.8,33.2001]],
[[3198.75,11925,32.4401],[3202.5,11921.3,32.6299]],
[[3198.75,11928.8,32.7101],[3198.75,11925,32.4401]],
[[3210,11932.5,34.6901],[3206.25,11932.5,34.0701]],	
[[3202.5,11932.5,33.4801],[3206.25,11932.5,34.0701]],
[[3207.76,11920.9,33.3363],[3210.96,11921.9,33.9387]],
[[3202.5,11921.3,32.6301],[3207.76,11920.9,33.3363]], //this
[[3210.96,11921.9,33.9387],[3211.6,11925,34.3011]],
[[3211.6,11925,34.3011],[3211.82,11928.4,34.6542]],
[[3210,11932.5,34.6901],[3211.82,11928.4,34.6542]],
[[3206.25,11932.5,34.0701],[3210,11932.5,34.6901]]]


[] spawn {
deb_msg9 = [deb_msg7, deb_msg6, deb_msg8] call createTrianglesToHole;
};


{
	// Current result is saved in variable _x
	(_x # 1) setPosWorld ((getPosWorld (_x # 1)) vectorAdd [0,0,0.2]);
} forEach deb_msg9;


//missing triangle
_missing = [[3202.5,11921.3,32.6301],[3207.76,11920.9,33.3363],[3206,11923.5,33.2759]];
_missing sort true;
_missing;
[[3202.5,11921.3,32.6301],[3206,11923.5,33.2759],[3207.76,11920.9,33.3363]]

[3202.5,11921.3,32.6299] //inside??


[[[[3203.65,11925.6,33.0993],[3203.98,11923.7,32.9928],[3198.75,11925,32.4401]],15a536d2080# 1675159: triangl.p3d],
[[[3203.65,11925.6,33.0993],[3205.96,11928,33.6531],[3202.5,11928.8,33.2001]],15a30a46b00# 1675160: triangl.p3d],
[[[3205.96,11928,33.6531],[3207.99,11928,33.9547],[3206.25,11932.5,34.0701]],15a30a45600# 1675161: triangl.p3d],
[[[3207.99,11928,33.9547],[3208.23,11926,33.8243],[3211.82,11928.4,34.6542]],15a56adeb00# 1675162: triangl.p3d],
[[[3206,11923.5,33.2759],[3208.23,11926,33.8243],[3210.96,11921.9,33.9387]],15a56adf580# 1675163: triangl.p3d],
[[[3203.98,11923.7,32.9928],[3206,11923.5,33.2759],[3202.5,11921.3,32.6301]],15a56ade080# 1675164: triangl.p3d],
[[[3198.75,11925,32.4401],[3203.98,11923.7,32.9928],[3202.5,11921.3,32.6301]],15a56add600# 1675165: triangl.p3d],
[[[3198.75,11925,32.4401],[3203.65,11925.6,33.0993],[3198.75,11928.8,32.7101]],159fe2d6b00# 1675166: triangl.p3d],
[[[3202.5,11928.8,33.2001],[3205.96,11928,33.6531],[3206.25,11932.5,34.0701]],159fe2d7580# 1675167: triangl.p3d],
[[[3202.5,11928.8,33.2001],[3203.65,11925.6,33.0993],[3198.75,11928.8,32.7101]],15a53f8f580# 1675168: triangl.p3d],
[[[3206.25,11932.5,34.0701],[3207.99,11928,33.9547],[3211.82,11928.4,34.6542]],15a53f8cb80# 1675169: triangl.p3d],
[[[3208.23,11926,33.8243],[3211.82,11928.4,34.6542],[3211.6,11925,34.3011]],15a604d0b80# 1675170: triangl.p3d],
[[[3208.23,11926,33.8243],[3210.96,11921.9,33.9387],[3211.6,11925,34.3011]],15a604d0100# 1675171: triangl.p3d],
[[[3206,11923.5,33.2759],[3210.96,11921.9,33.9387],[3207.76,11920.9,33.3363]],15a42122b00# 1675172: triangl.p3d],
[[[3202.5,11928.8,33.2001],[3206.25,11932.5,34.0701],[3202.5,11932.5,33.4801]],15a42123580# 1675173: triangl.p3d]]








private _a = getTerrainHeight [3202.5,11921.25]; 
setTerrainHeight [[[3202.5,11921.25 + 3.75, 28]]]; 
private _b = getTerrainHeight [3202.5,11921.25]; 
_a - _b; 

//0.00120163
