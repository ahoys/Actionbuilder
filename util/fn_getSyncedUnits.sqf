/*
	File: fn_getSyncedUnits.sqf
	Author: Ari Höysniemi

	Description:
	Return an array of synchronized units in a categorized fashion

	Parameter(s):
	0: OBJECT - object with units synchronized
	1 (Optional): BOOL - true to remove synchronized unit after the registeration (default: false)
	2 (Optional): BOOL - true to remove object after the registeration (default: false)

	Returns:
	ARRAY - List of objects, groups and units. Ex. [["obj1","obj2"..."objN"],[["side","man1"..."manN"],["side","man1"..."manN"]]]
*/

private["_master","_syncedUnits","_acceptedObjects","_acceptedGroups","_notedGroups","_notedCrew","_direction","_i","_group","_vehicle","_acceptedUnits"];
_master = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

if (isNil "_master") exitWith {["The master object is null. The master object should be an actual object."] call BIS_fnc_error; []};

_syncedUnits		= _master call BIS_fnc_moduleUnits;

if (count _syncedUnits < 1) exitWith {["%1 has no units synchronized.", _master] call BIS_fnc_error; []};

_acceptedObjects	= [];
_acceptedGroups		= [];
_notedGroups		= [];
_notedCrew			= [];
_direction			= 0;
_i					= 0;

{
	if (!isNil "_x") then {
		_group = group _x;
		if (isNull _group) then {
			// Object [type, [position], direction]
			_acceptedObjects pushBack [typeOf _x, getPosATL _x, getDir _x];
		} else {
			// Unit [side, [type, [position], direction]]
			if !(_group in _notedGroups) then {
				_notedGroups pushBack _group;
				_acceptedGroups pushBack [side _x];
				{
					_vehicle = vehicle _x;
					if (_x == _vehicle) then {
						// Man
						(_acceptedGroups select _i) pushBack [typeOf _x, getPosATL _x, getDir _x];
					} else {
						// Vehicle
						if !(_x in _notedCrew) then {
							(_acceptedGroups select _i) pushBack [typeOf _vehicle, getPosATL _vehicle, getDir _vehicle];
							{
								_notedCrew pushBack _x;
							} forEach crew _vehicle;
						};
					};
				} forEach units _group;
				_i = _i + 1;
			};
		};
	};
} forEach _syncedUnits;

_acceptedUnits = [_acceptedObjects, _acceptedGroups];
_acceptedUnits