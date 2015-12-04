/*
	File: fn_sva.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported
	
	Extension for:
	fn_assignWp.sqf

	Description:
	Sends vehicles away -waypoint

	Parameter(s):
	0: GROUP - the target group
	1: PORTAL - the origin portal

	Returns:
	BOOL - true if success
*/

private["_units","_portal","_inVehicles","_crew","_units"];

_units		= units (_this select 0);
_portal		= _this select 1;
_inVehicles	= [];
_crew		= [];

{
	if (_x in assignedCargo vehicle _x) then {
		_inVehicles pushBack _x;
	} else {
		if (vehicle _x != _x) then {
			_crew pushBack _x;
		};
	};
} forEach _units;

_time = time;
waitUntil {(count _inVehicles < 1) || ((_time + 16) < time)};

_vehicleDestination = getPosATL _portal;
_vehicleGroup = createGroup (side (_units select 0));
_crew joinSilent _vehicleGroup;
_vehWp = _vehicleGroup addWaypoint [_vehicleDestination, 0];
_vehWp setWaypointType "MOVE";
_vehWp setWaypointSpeed "NORMAL";
_vehWP setWaypointCompletionRadius 0;
_vehWp setWaypointStatements ["true","{deleteVehicle (vehicle _x); deleteVehicle _x} forEach thisList"];

true