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

if (!isServer && hasInterface) exitWith {};

private["_group","_force","_range","_primaryVeh","_seated","_toBeSeated","_secondaryVeh"];
_group		= _this select 0;
_force		= _this select 1;
_range		= _this select 2;
_primaryVeh	= [];
_seated		= [];
_toBeSeated	= [];

// Search for the group owned vehicles and units that are outside of those vehicles
{
	if (isNull objectParent _x) then {
		_toBeSeated pushBack _x;
	} else {
		if !(objectParent _x in _primaryVeh) then {
			_primaryVeh pushBack (objectParent _x);
			_seated pushBack _x;
		};
	};
} forEach units _group;

if (count _toBeSeated > 0) then {
	_seated = [_primaryVeh, _seated, _toBeSeated, _force] call Actionbuilder_fnc_seatEmptyPositions;
};

if (count _seated < count units _group) then {
	_secondaryVeh = [];
	{
		if !(_x in _primaryVeh) then {
			_secondaryVeh pushBack _x;
		};
	} forEach nearestObjects [leader _group, ["Car","Tank","Ship","Air"], _range];
	if (count _secondaryVeh > 0) then {
		_toBeSeated = _toBeSeated - _seated;
		[_secondaryVeh, _seated, _toBeSeated, _force] call Actionbuilder_fnc_seatEmptyPositions;
	};
};

true