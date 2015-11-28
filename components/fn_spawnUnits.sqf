/*
	File: fn_spawnUnits.sqf
	Author: Ari Höysniemi

	Description:
	Spawns all of the units from the portal

	Parameter(s):
	0: OBJECT - object that can be found from the ACTIONBUILDER_portals

	Returns:
	BOOL - true, if success
*/

private[
	"_portal",
	"_objectId",
	"_groupId",
	"_objects",
	"_groups",
	"_direction",
	"_position",
	"_varInit",
	"_varSafezone",
	"_varSpecial",
	"_group",
	"_i",
	"_skill",
	"_unit"
];
_portal 	= [_this, 0, objNull, [objNull]] call BIS_fnc_param;

if (isNull _portal) exitWith {false};

// Required variables
_varInit		= _portal getVariable ["p_UnitInit",""];
_varSafezone	= _portal getVariable ["p_MinDist",400];
_varSpecial		= _portal getVariable ["p_Special","NONE"];
_objectId 		= ACTIONBUILDER_portal_objects find _portal;
_groupId 		= ACTIONBUILDER_portal_groups find _portal;
_objects		= [];
_groups			= [];
_direction		= getDir _portal;
_position		= getPosATL _portal;
_players		= switchableUnits + playableUnits;

// Build categories
if (_objectId >= 0) then {_objects = ACTIONBUILDER_portal_objects select (_objectId + 1)};
if (_groupId >= 0) then {_groups = ACTIONBUILDER_portal_groups select (_groupId + 1)};

if (_varSafezone > 0) then {
	{
		if ((_x distance _portal) < _varSafezone) exitWith {false};
	} forEach _players;
};

// 1/2 Spawn objects
{
	_vehicle = createVehicle [_x, _position, [], 0, _varSpecial];
	_vehicle setDir _direction;
} forEach _objects;

// 2/2 Spawn groups
{
	diag_log format ["GRP: %1",_x];
	_group = createGroup (_x select 0);
	ACTIONBUILDER_portal_spawned pushBack _group;
	_i = 0;
	{
		diag_log format ["UNIT: %1",_x];
		if (_i > 0) then {
			if (_x isKindOf "MAN") then {
				// INFANTRY
				_skill	= [0.40,0.45,0.50,0.55,0.60,0.65,0.70,0.75,0.80] select floor random (difficulty + 1);
				_unit = _group createUnit [_x, _position, [], 0, "NONE"];
				{
					if (_x isKindOf ["smokeShell", configFile >> "CfgMagazines"]) then {
						_unit removeMagazine _x;
					}
				} forEach magazines _unit;
			} else {
				// VEHICLES
				_vehicle = createVehicle [_x, _position, [], 0, _varSpecial];
				_vehicle setDir _direction;
				createVehicleCrew _vehicle;
				(crew _vehicle) joinSilent _group;
			};
		};
		_i = _i + 1;
	} forEach _x;
} forEach _groups;

true