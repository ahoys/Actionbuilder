/*
	File: fn_sendVehiclesAway.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported
	
	Extension for:
	fn_addWaypoint.sqf

	Description:
	Sends vehicles away -waypoint

	Parameter(s):
	0: GROUP - the target group
	1: LOCATION ATL - a location where the vehicle returns to

	Returns:
	BOOL - true if success
*/
private _units = units param [0, grpNull, [grpNull]];
private _wpLocation = param [1, [], [[]]];
private _inVehicles = [];
private _crew = [];

{
	private _vehicle = objectParent _x;
	if (_x in assignedCargo _vehicle) then {
		_inVehicles pushBack _x;
	} else {
		if (!isNull _vehicle && _vehicle getCargoIndex _x == -1) then {
			_crew pushBack _x;
		};
	};
} forEach _units;

private _time = time;
waitUntil {(count _inVehicles < 1) || ((_time + 16) < time)};

private _vehicleGroup = createGroup (side (_units select 0));
_crew joinSilent _vehicleGroup;
private _vehWp = _vehicleGroup addWaypoint [_wpLocation, 0];
_vehWp setWaypointType "MOVE";
_vehWp setWaypointSpeed "NORMAL";
_vehWP setWaypointCompletionRadius 0;
private _script = "{private _veh = objectParent _x; if (!isNull _veh) then {{deleteVehicle _x} forEach crew _veh; deleteVehicle _veh}} forEach thisList";
_vehWp setWaypointStatements ["true", _script];

true