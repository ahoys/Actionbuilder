/*
	File: fn_waitForSeating.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported
	
	Extension for:
	fn_loadVehicles.sqf
	
	Description:
	Returns true when everyone is seated.

	Parameter(s):
	0: GROUP - target group of units

	Returns:
	BOOL - true when ready
*/

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