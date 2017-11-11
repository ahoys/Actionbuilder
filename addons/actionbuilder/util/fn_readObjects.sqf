/*
	File: fn_readObjects.sqf
	Author: Ari Höysniemi

	Description:
	Reads all empty object units from a list.
	Eg. empty cars, tables, boxes etc.

	Parameter(s):
	0: ARRAY - unit(s)

	Returns:
	ARRAY - [total count of objects, [list of objects]]
*/

private _units = _this select 0;
private _objects = [];

if (_units isEqualTo []) exitWith {[0, []]};

{
	// If there are no group, the object is not alive or
	// manned by an alive unit. Side makes sure we register
	// only objects, not logics.
	if (isNull group _x && side _x == CIVILIAN) then {
		// List all the interesting data about the unit.
		_objects pushBack [
			typeOf _x,
			getPosATL _x,
			getDir _x
		];
	};
} forEach _units;

[count _objects, _objects];