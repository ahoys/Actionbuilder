private["_assignedUnits","_waiting","_currentTime"];
_assignedUnits	= _this select 0;
_waiting		= true;
_currentTime	= time;

while {_waiting && (_currentTime + 60 > time)} do {
	_waiting = false;
	{
		if (isNull objectParent _x) then {
			_waiting = true;
		};
	} forEach _assignedUnits;
	uiSleep 1;
};

true