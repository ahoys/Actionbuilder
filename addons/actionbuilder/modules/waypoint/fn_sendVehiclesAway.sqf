/*
	File: fn_sendVehiclesAway.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported
	
	Extension for:
	fn_assignWaypoint.sqf

	Description:
	Sends vehicles away -waypoint

	Parameter(s):
	0: GROUP - the target group
	1: LOCATION ATL - a location where the vehicle returns to

	Returns:
	BOOL - true if success
*/

private _units = units (_this select 0);
private _wpLocation = _this select 1;
private _inVehicles = [];
private _crew = [];

{
	if (_x in assignedCargo objectParent _x) then {
		_inVehicles pushBack _x;
	} else {
		if !(isNull objectParent _x) then {
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