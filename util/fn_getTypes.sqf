/*
	File: fn_getTypes.sqf
	Author: Ari Höysniemi

	Description:
	Return a list of units of desired type
	
	Parameter(s):
	0: STRING/OBJECT - type of the entity, ex. "HeadlessClient_F" or object of desired type
	1 (optional): BOOL - true to allow only server executions (default: true)
	2 (optional): NUMBER - 0 to return all entities, 1 only alive, 2 only dead (default: 0)

	Returns:
	ARRAY - List of units of desired type
*/

private["_type","_master","_entities"];
_type 		= param [0, "HeadlessClient_F", ["", objNull]];
_master		= param [1, objNull, [objNull]];
_entities	= [];

if (_type isEqualType objNull) then {_type = typeOf _type};

if (isNull _master) then {
	_entities = entities _type;
} else {
	{
		if (_x isEqualType _type) then {
			_entities pushBack _x;
		};
	} forEach synchronizedObjects _master;
};

_entities