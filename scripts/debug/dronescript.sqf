
[] call compile preprocessFileLineNumbers "MagicTriangle\scripts\fullyInitTrenchesWithIntersect.sqf";

testloop = [] spawn {
	while {true} do {
		waituntil {
			sleep 0.5;
			!(isnull (laserTarget desi));
		};
		_pos1 = position laserTarget desi;
		_tronch1 = "GRAD_envelope_fightinghole" createVehicle _pos1;
		_tronch1 setdir (random 360);
		//_tronch1 attachto [laserTarget desi, [0, 0, 0]];
		_lastpos = [0,0,0];
		_newpos = (getposWorld laserTarget desi);
		waituntil {
			//sleep 0.02;
			_lastpos = _newpos;
			_intList = lineIntersectsSurfaces [getposWorld desi, _lastpos vectoradd [0,0,-1], desi, _tronch1, true];
			if ((count _intList) != 0) then {
			_int = _intList # 0;
			_tronch1 setposWorld (_int # 0);
			_tronch1 setVectorUp (_int # 1);
			};
			
			_newpos = (getposWorld laserTarget desi);
			isnull (laserTarget desi);
		};
		[[_tronch1]] call initTrench;
	};
};





