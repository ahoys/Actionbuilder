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

private["_entityType","_serverOnly","_aliveState","_entities"];
_entityType	= [_this, 0, "HeadlessClient_F", ["", objNull]] call BIS_fnc_param;
_serverOnly	= [_this, 1, true, [true]] call BIS_fnc_param;
_aliveState	= [_this, 2, 0, [0]] call BIS_fnc_param;
_entities	= [];

// Make sure only the allowed clients pass
if (!isServer && _serverOnly) exitWith {[]};

// EntityType can't be empty
if (isNil "_entityType") exitWith {
	["Required entity type missing!"] call BIS_fnc_error;
	[]
};

// If object, figure out its type
if (_entityType isEqualType objNull) then {
	_entityType = typeOf _entityType;
};

// Return all entities of given type
if (_aliveState == 0) exitWith {entities _entityType};

// Return either alive or dead entities of given type
{
	if (!isNil "_x") then {
		switch (_aliveState) do {
			case 0: {
				_entities pushBack _x;
			};
			case 1: {
				if (alive _x) then {
					_entities pushBack _x;
				};
			};
			case 2: {
				if (!alive _x) then {
					_entities pushBack _x;
				};
			};
		};
	};
} forEach (entities _entityType);

_entities