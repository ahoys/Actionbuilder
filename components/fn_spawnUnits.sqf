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
	"_players",
	"_varInit",
	"_varPositioning",
	"_varSafezone",
	"_varSpecial",
	"_group",
	"_i",
	"_skill",
	"_u",
	"_unit"
];
_portal 	= [_this, 0, objNull, [objNull]] call BIS_fnc_param;

if (isNull _portal) exitWith {false};

// Required variables
_varInit		= _portal getVariable ["p_UnitInit",""];
_varPositioning	= _portal getVariable ["p_Positioning","PORTAL"];
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
	_u = _x select 0;
	if (_varPositioning == "NONE") then {
		_position = _x select 1;
		_direction = _x select 2;
	};
	_vehicle = createVehicle [_u, _position, [], 0, _varSpecial];
	_vehicle setDir _direction;
} forEach _objects;

// 2/2 Spawn groups
{
	_group = createGroup (_x select 0);
	ACTIONBUILDER_portal_spawned pushBack _group;
	_i = 0;
	{
		if (_i > 0) then {
			_u = _x select 0;
			if (_varPositioning == "NONE") then {
				_position = _x select 1;
				_direction = _x select 2;
			};
			if (_u isKindOf "MAN") then {
				// INFANTRY
				_skill	= [0.40,0.45,0.50,0.55,0.60,0.65,0.70,0.75,0.80] select floor random (difficulty + 1);
				_unit = _group createUnit [_u, _position, [], 0, "NONE"];
				_unit setDir _direction;
				{
					if (_u isKindOf ["smokeShell", configFile >> "CfgMagazines"]) then {
						_unit removeMagazine _u;
					}
				} forEach magazines _unit;
			} else {
				// VEHICLES
				_vehicle = createVehicle [_u, _position, [], 0, _varSpecial];
				_vehicle setDir _direction;
				createVehicleCrew _vehicle;
				(crew _vehicle) joinSilent _group;
			};
		};
		_i = _i + 1;
	} forEach _x;
} forEach _groups;

true