/*
	File: fn_listClients.sqf
	Author: Ari Höysniemi

	Description:
	Return a list of clients of desired type
	
	Parameter(s):
	0: STRING - classname type

	Returns:
	ARRAY - List of clients available and occupied by a client
*/

if (!isServer) exitWith {[]};

private["_type","_units","_clients"];
_type		= [_this, 0, "HeadlessClient_F", [""]] call BIS_fnc_param;
_units		= switchableUnits + playableUnits;
_clients	= [];

{
	if (_x isKindOf _type && isPlayer _x) then {
		_clients pushBack _x;
	};
} forEach _units;

_clients