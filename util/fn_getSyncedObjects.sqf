/*
	File: fn_getSyncedObjects.sqf
	Author: Ari Höysniemi

	Description:
	Return an array of synchronized objects

	Parameter(s):
	0: OBJECT - object with units synchronized
	1 (Optional): BOOL - true to remove object after the registeration (default: false)

	Returns:
	ARRAY - List of objects [obj1,obj2, ... objN]
*/

private["_master","_syncedUnits","_objects"];
_master = param [0, objNull, [objNull]];
_remove = param [1, false, [false]];

// Master can't be empty
if (isNil "_master") exitWith {
	["The master object is null. The master object should be an actual object."] call BIS_fnc_error;
	[]
};

// All synchronized units
_syncedUnits 	= _master call BIS_fnc_moduleUnits;
_objects		= [];

// Collect all objects and return
{
	if (!isNil "_x") then {
		if ((isNull group _x) && (side _x == CIVILIAN)) then {
			_objects pushBack [typeOf _x, getPosATL _x, getDir _x];
			if (_remove) then {
				deleteVehicle _x;
			};
		};
	};
} forEach _syncedUnits;

_objects