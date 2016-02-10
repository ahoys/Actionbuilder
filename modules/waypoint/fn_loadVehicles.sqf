/*
	File: fn_loadVehicles.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported
	
	Extension for:
	fn_assignWaypoint.sqf
	
	Description:
	Performs GET IN and FORCE GET IN special actions

	Parameter(s):
	0: GROUP - target group of units
	1: BOOL - true to forced populating
	2: NUMBER - search range for empty vehicles

	Returns:
	NOTHING
*/

private["_group","_force","_range","_primaryVehicles","_outside"];
_group 				= _this select 0;
_force				= _this select 1;
_range				= _this select 2;
_primaryVehicles	= [];
_outside			= [];

diag_log "AB - fn_loadVehicles";

// Look for the group owned vehicles and units that require a seat
{
	if !(isNull objectParent _x) then {
		if !(objectParent _x in _primaryVehicles) then {
			_primaryVehicles pushBack (objectParent _x);
		};
	} else {
		_outside pushBack _x;
	};
} forEach units _group;

// Seat as many units as possible
_seated = [_outside, _primaryVehicles, _force, 0] call Actionbuilder_fnc_seatEmptyPositions;

// If units outside, search for secondary vehicles
if (_seated < count _outside) then {
	_secondaryVehicles = nearestObjects [leader _group, ["Car","Tank","Ship","Air"], _range];	
	if (count _secondaryVehicles > 0) then {
		_seated = [_outside, _secondaryVehicles, _force, _seated] call Actionbuilder_fnc_seatEmptyPositions;
	};
};

true