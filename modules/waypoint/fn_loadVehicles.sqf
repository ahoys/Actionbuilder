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
	0: ARRAY - target units
	1: BOOL - true to forced populating
	2: NUMBER - search range for empty vehicles

	Returns:
	NOTHING
*/

private["_units","_force","_range","_primaryVehicles","_outside"];
_units 				= _this select 0;
_force				= _this select 1;
_range				= _this select 2;
_primaryVehicles	= [];
_outside			= [];

// Look for the group owned vehicles and units that require a seat
{
	if !(isNull objectParent _x) then {
		if !(objectParent _x in _primaryVehicles) then {
			_primaryVehicles pushBack (objectParent _x);
		};
	} else {
		_outside pushBack _x;
	};
} forEach _units;

// Seat as many units as possible
_seated = [_outside, _primaryVehicles, _force, 0] call Actionbuilder_fnc_seatEmptyPositions;

// If units outside, search for secondary vehicles
if (_seated < count _outside) then {
	// Look for secondary vehicles
	_secondaryVehicles = nearestObjects [_units select 0, ["Car","Tank","Ship","Air"], _range];
	
	if (count _secondaryVehicles > 0) then {
		// Populate secondary vehicles
		_seated = [_outside, _secondaryVehicles, _force, _seated] call Actionbuilder_fnc_seatEmptyPositions;
	};
};

true