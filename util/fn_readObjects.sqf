/*
	File: fn_readObjects.sqf
	Author: Ari Höysniemi

	Description:
	Reads all empty object units from a list.
	Eg. empty cars, tables, boxes etc.

	Parameter(s):
	0: ARRAY - units

	Returns:
	ARRAY - a list of objects
*/
private _return = [];

{
	if (isNull group _x) then {
		// List all the interesting data about the unit.
		_return pushBack [
			typeOf _x,
			getPosATL _x,
			getDir _x
		];
	};
} forEach _this select 0;

_return;