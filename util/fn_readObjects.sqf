/*
	File: fn_readObjects.sqf
	Author: Ari Höysniemi

	Description:
	Reads all empty object units from a list.
	Eg. empty cars, tables, boxes etc.

	Parameter(s):
	0: ARRAY - unit(s)

	Returns:
	ARRAY - a list of objects
*/
private["_units","_return","_c"];
_units = _this select 0;
_return = [0, []];
_c = 0;

if (_units isEqualTo []) exitWith {_return};

{
	// If there's not group, the object is not alive or
	// manned by an alive unit. Side makes sure we register
	// only objects, not logics.
	if (isNull group _x && side _x == CIVILIAN) then {
		// List all the interesting data about the unit.
		(_return select 1) pushBack [
			typeOf _x,
			getPosATL _x,
			getDir _x,
			damage _x,
			fuel _x,
			locked _x
		];
		_return set [0, (_return select 0) + 1];
	};
} forEach _units;

_return;