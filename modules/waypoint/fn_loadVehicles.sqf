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
	BOOLEAN - true to everyone are seated
*/

if (!isServer && hasInterface) exitWith {};

private["_group","_range","_force","_units","_seated","_toBeSeated","_vehicles","_groupVehicles","_pos","_vehicle","_closest","_otherVehicles"];
_group			= _this select 0;
_range			= _this select 1;
_force			= _this select 2;
_units			= units _group;
_seated			= [];
_toBeSeated		= [];
_vehicles		= [];
_groupVehicles	= [];
_pos			= position leader _group;

// Units requiring seating
{
	_vehicle = objectParent _x;
	if (isNull _vehicle) then {
		_toBeSeated pushBack _x;
	} else {
		if (_vehicle distance _x < (_range + 100)) then {
			if !(_vehicle in _vehicles) then {
				_vehicles pushBack _vehicle;
			};
		};
	};
} forEach _units;

diag_log format ["fn_loadVehicles: _toBeSeated: %1, _vehicles: %2", _toBeSeated, _vehicles];

// Everyone are already seated!
if (_toBeSeated isEqualTo []) exitWith {true};

// How many seats are required in total
_seatsRequired = count _toBeSeated;

// Valid group vehicles
{
	_closest = _vehicles select 0;
	_c = 0;
	{
		if (_x distance _pos < _closest distance _pos) then {
			_closest = _x;
		};
	} forEach _vehicles;
	{_c = _c + (_closest emptyPositions _x)} forEach ["Driver","Cargo"];
	if (_c >= _seatsRequired && (isNull gunner _closest) && (isNull commander _closest)) then {
		_groupVehicles pushBack _closest;
	};
	_vehicles = _vehicles - [_closest];
} forEach _vehicles;

diag_log format ["fn_loadVehicles: _groupVehicles: %1", _groupVehicles];

if (_groupVehicles isEqualTo []) then {
	// Look for other vehicles
	_otherVehicles = [];
	{
		_vehicle = _x;
		if (!(_vehicle in _groupVehicles) && ({alive _x} count crew _vehicle isEqualTo 0)) then {
			_c = 0;
			{_c = _c + (_vehicle emptyPositions _x)} forEach ["Driver","Cargo"];
			if (_c >= _seatsRequired) then {
				_otherVehicles pushBack _vehicle;
			};
		};
	} forEach nearestObjects [leader _group, ["Car","Tank"], _range];
	diag_log format ["fn_loadVehicles: _otherVehicles: %1", _otherVehicles];
	if (_otherVehicles isEqualTo []) exitWith {false};
	// Assign seats for the other vehicles
	[_toBeSeated, _otherVehicles select 0, _force] call Actionbuilder_fnc_seatEmptyPositions;
	_toBeSeated orderGetIn true;
	[_toBeSeated] call Actionbuilder_fnc_waitForSeating;
} else {
	// Assign seats for the group vehicles
	[_toBeSeated, _groupVehicles select 0, _force] call Actionbuilder_fnc_seatEmptyPositions;
	_toBeSeated orderGetIn true;
	[_toBeSeated] call Actionbuilder_fnc_waitForSeating;
};

true