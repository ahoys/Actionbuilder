/*
	File: fn_getEqualTypes.sqf
	Author: Ari Höysniemi

	Description:
	Return a list of units of desired type
	
	Parameter(s):
	0: STRING/OBJECT - type of the entity or an object of the desired type
	1: OBJECT - true to find equal types among synchronized units of the given object

	Returns:
	ARRAY of OBJECTs - A list of units of the desired type
*/
private _type = param [0, "HeadlessClient_F", ["", objNull]];
private _master = param [1, objNull, [objNull]];
private _entities = [];

if (_type isEqualType objNull) then {_type = typeOf _type};

if (isNull _master) then {
	_entities = entities _type;
} else {
	{
		if (_x isKindOf _type) then {
			_entities pushBack _x;
		};
	} forEach synchronizedObjects _master;
};

_entities