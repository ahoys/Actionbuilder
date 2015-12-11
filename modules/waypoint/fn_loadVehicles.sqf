/*
	File: fn_loadVehicle.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported
	
	Extension for:
	fn_assignWaypoint.sqf
	
	Description:
	Performs GET IN and FORCE GET IN special actions

	Parameter(s):
	0: ARRAY - target crew
	1: BOOL - true to forced populating
	2: NUMBER - range of valid vehicles to be populated

	Returns:
	OBJECT - the selected portal if any
*/

private["_units","_force","_range","_primaryVehicles","_seats"];

_units 				= _this select 0;
_force				= _this select 1;
_range				= _this select 2;
_primaryVehicles	= [];
_seats				= [];

// Look for primary vehicles and already seated units
{
	if !(isNull objectParent _x) then {
		if !(objectParent _x in _primaryVehicles) then {
			_primaryVehicles pushBack (objectParent _x);
		};
	};
} forEach _units;

// Prioritise seats
_seats = [_primaryVehicles] call Actionbuilder_fnc_prioritizeSeats;

// Populate primary vehicles
_outside = [_units, _seats, _force] call Actionbuilder_fnc_populateSeats;

// If units outside, search for secondary vehicles
if (count _outside > 0) then {
	// Look for secondary vehicles
	_secondaryVehicles = nearestObjects [_units select 0, ["Car","Tank","Ship","Air"], _range];
	
	if (count _secondaryVehicles > 0) then {
		// Prioritise seats
		_seats = [_secondaryVehicles] call Actionbuilder_fnc_prioritizeSeats;
		
		// Populate secondary vehicles
		_outside = [_outside, _seats, _force] call Actionbuilder_fnc_populateSeats;
	};
};

// If still units outside, return false
if (count _outside > 0) exitWith {false};

true