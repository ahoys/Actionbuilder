/*
	File: fn_getSynchronizedOfType.sqf
	Author: Ari Höysniemi

	Description:
	Returns synchronized objects of the given type.

	Parameter(s):
	0: OBJECT - master object
	1: STRING - type of the object to look for

	Returns:
	ARRAY - a list of objects
*/
private _type = _this select 1;
private _result = [];
{
	if (_x isKindOf _type) then {
		_result pushBack _x;
	};
} forEach synchronizedObjects (_this select 0);

_result