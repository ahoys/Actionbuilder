/*
	File: fn_spawnUnits.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported

	Description:
	Spawns all of the portal's registered units

	Parameter(s):
	0: OBJECT - the target portal

	Returns:
	NOTHING
*/

private[];

_portal = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

// Portal must exist
if (isNil "_portal") exitWith {
	["Requested portal does not exist."] call BIS_fnc_error;
	false
};

// Portal settings
_varInit	= _portal getVariable ["p_UnitInit",""];
_varPos		= _portal getVariable ["p_Positioning","PORTAL"];
_varSafe	= _portal getVariable ["p_MinDist",400];
_varSpecial	= _portal getVariable ["p_Special","NONE"];
_poolObj	= [];
_poolGrp	= [];
_pos		= getPosATL _portal;
_dir		= getDir _portal;

// Category keys
_keyObj = RHNET_AB_G_PORTAL_OBJECTS find _portal;
_keyGrp = RHNET_AB_G_PORTAL_GROUPS find _portal;

// Build categories
if !(_keyObj < 0) then {_poolObj = RHNET_AB_G_PORTAL_OBJECTS select (_keyObj + 1)};
if !(_keyGrp < 0) then {_poolGrp = RHNET_AB_G_PORTAL_GROUPS select (_keyGrp + 1)};

diag_log format ["OBJ: %1", _poolObj];
diag_log format ["GRP: %1", _poolGrp];

// Objects [typeOf, getPosATL, getDir]
{
	if (count _x > 0) then {
		_spawn = true;
		_obj = _x select 0;
		if (_varPos == "NONE") then {
			_pos = _x select 1;
			_dir = _x select 2;
		};
		if (_varSafe > 0) then {
			{
				if ((_x distance _pos) < _varSafe) exitWith {
					_spawn = false;
				};
			} forEach (switchableUnits + playableUnits);
		};
		if (_spawn) then {
			_unit = createVehicle [_obj, _pos, [], 0, _varSpecial];
			_unit setDir _dir;
		};
	};
} forEach _poolObj;

if (count _poolGrp > 0) then {
	_id = RHNET_AB_G_PORTALS find _portal;
	if (isNil "RHNET_AB_L_GROUPPROGRESS") then {
			RHNET_AB_L_GROUPPROGRESS = [];
	};
};

// Groups [side, [[typeOf, getPosATL, getDir]],[[typeOf, getPosATL, getDir]]]
{
	if (count _x > 0) then {
		_spawn = true;
		// Get clearance for the spawning
		{
			if (_varPos == "NONE") then {
				_pos = _x select 1;
				_dir = _x select 2;
			};
			if (_varSafe > 0) then {
				{
					if ((_x distance _pos) < _varSafe) exitWith {
						_spawn = false;
					};
				} forEach (switchableUnits + playableUnits);
			};
		} forEach ((_x select 1) + (_x select 2)); 
		if (_spawn) then {
			_grp = createGroup (_x select 0);
			// Infantry
			{
				if (_varPos == "NONE") then {
					_pos = _x select 1;
					_dir = _x select 2;
				};
				_unit = _grp createUnit [_x select 0, _pos, [], 0, "NONE"];
				_unit setDir _dir;
				{
					if (_x isKindOf ["smokeShell", configFile >> "CfgMagazines"]) then {
						_unit removeMagazine _x;
					};
				} forEach magazines _unit;
			} forEach (_x select 1);
			// Vehicles
			{
				if (_varPos == "NONE") then {
					_pos = _x select 1;
					_dir = _x select 2;
				};
				_veh = createVehicle [_x select 0, _pos, [], 0, _varSpecial];
				_veh setDir _dir;
				createVehicleCrew _veh;
				(crew _veh) joinSilent _grp;
			} forEach (_x select 2);
			// Register
			RHNET_AB_L_GROUPPROGRESS pushBack _grp;
			RHNET_AB_L_GROUPPROGRESS pushBack [0, _portal, _id, _id, []];
			// Assign waypoint
			[_grp] spawn Actionbuilder_fnc_assignWaypoint;
		};
	};
} forEach _poolGrp;

true