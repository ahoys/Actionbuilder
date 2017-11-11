/*
	File: fn_unloadVehicles.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported
	
	Extension for:
	fn_addWaypoint.sqf
	
	Description:
	Performs GET OUT special actions

	Parameter(s):
	0: GROUP - target group of units
	1: BOOL - true to NOT unload the crew too

	Returns:
	NOTHING
*/
private _group = param [0, grpNull, [grpNull]];
private _ejectCrew = param [1, false, [false]];
private _unassigned = [];
private _waiting = false;
private _currentTime = time;

{
	private _vehicle = objectParent _x;
	if !(isNull _vehicle) then {
		if (_ejectCrew) then {
			_unassigned pushBack _x;
		} else {
			if ((assignedDriver _vehicle != _x) && (assignedGunner _vehicle != _x) && (assignedCommander _vehicle != _x) && ((assignedVehicleRole _x) select 0 != "Turret")) then {
				_unassigned pushBack _x;
			};
		};
	};
} forEach units _group;

_unassigned orderGetIn false;

{
	unassignVehicle _x;
	doGetOut _x;
} forEach _unassigned;

while {_waiting && (_currentTime + 60 > time)} do {
	_waiting = false;
	{
		if !(isNull objectParent _x) then {
			_waiting = true;
		};
	} forEach _unassigned;
	uiSleep 1;
};

true