/*
	File: fn_spawnUnits.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported.

	Description:
	Spawns all of the portal's registered units

	Parameter(s):
	0: OBJECT - the target portal

	Returns:
	NOTHING
*/
if (!isServer && hasInterface) exitWith {};

private _portal = param [0, objNull, [objNull]]; // This portal.
private _owner = param [1, 0, [0]]; // Processing owner of the portal (eg. server or headless client).
private _ap = param [2, objNull, [objNull]]; // The master AP.
private _repeater = param [3, objNull, [objNull]];

// Portal must exist!
if (isNull _portal) exitWith {false};

// Conditions -------------------------------------------------------------------------------------

// Request global variables if not available.
// This should happen only to the headless clients.
if ((isNil "RHNET_AB_G_PORTAL_OBJECTS" || isNil "RHNET_AB_G_PORTAL_GROUPS") && !isNil "_owner") then {
	if (_owner > 0) then {
		RHNET_AB_G_REQUEST = _owner;
		publicVariableServer "RHNET_AB_G_REQUEST";
	};
};

// Do not continue until all the required variables are available
waitUntil {!isNil "RHNET_AB_G_PORTAL_OBJECTS" && !isNil "RHNET_AB_G_PORTAL_GROUPS"};

// Repeating --------------------------------------------------------------------------------------

// Find the spawning index of the master Actionpoint.
private _i = (RHNET_AB_L_AP_SPAWNED find _ap) + 1;
// Load the currently spawned units.
private _spawned = RHNET_AB_L_AP_SPAWNED select _i;

// Processing -------------------------------------------------------------------------------------

// Portal settings.
private _varPos = _portal getVariable ["p_Positioning","PORTAL"];
private _varSafeZone = _portal getVariable ["p_MinDist",400];
private _varSpecial = _portal getVariable ["p_Special","NONE"];
private _varDamage = _portal getVariable ["p_Damage",0];
private _varSkill = _portal getVariable ["p_Skill",0.5];
private _varAmmo = _portal getVariable ["p_Ammo",1];
private _varFuel = _portal getVariable ["p_Fuel",1];

// Unit pools.
private _objects = (RHNET_AB_G_PORTAL_OBJECTS select ((RHNET_AB_G_PORTAL_OBJECTS find _portal) + 1)) select 1;
private _groups = (RHNET_AB_G_PORTAL_GROUPS select ((RHNET_AB_G_PORTAL_GROUPS find _portal) + 1)) select 1;

// Other variables.
private _players = playableUnits + switchableUnits;
private _posPortal = getPosATL _portal;
private _dirPortal = getDir _portal;

// RHNET_AB_L_GROUPPROGRESS is reserved for waypoints.
if (count _groups > 0) then {
	if (isNil "RHNET_AB_L_GROUPPROGRESS") then {
		RHNET_AB_L_GROUPPROGRESS = [];
	};
};

// Spawn objects first.
{
	// 0: type,
	// 1: pos,
	// 2: dir
	scopeName "main";
	call {
		if (_varPos == "PORTAL") then {
			_x set [1, _posPortal];
			_x set [2, _dirPortal];
		};
		// Make sure that players are outside the safe zone.
		if (_varSafeZone > 0) then {
			private _p = _x select 1;
			{
				if ((_x distance _p) <= _varSafeZone) then {
					["PORTAL", _portal, "Player(s) too close for spawning."] call Actionbuilder_fnc_debug;
					breakTo "main";
				};
			} forEach _players;
		};
		// Spawn the object.
		private _v = createVehicle [_x select 0, _x select 1, [], 0, _varSpecial];
		_spawned pushBack _v;
		_v setDir (_x select 2);
		_v setDamage _varDamage;
		_v setVehicleAmmo _varAmmo;
		_v setFuel _varFuel;
		// Custom layouts.
		if (isNil "RHNET_AB_L_DISABLE_CUSTOM_LAYOUTS") then {
			clearItemCargoGlobal _v;
			clearweaponcargoglobal _v;
			clearMagazineCargoGlobal _v;
			clearBackpackCargoGlobal _v;
			[_v, _x select 3] call Actionbuilder_fnc_addGlobalCargo;
		};
	};
} forEach _objects;

// Spawn groups second.
{
	// 0: side,
	// 1: vehicles,
	// 2: infantry
	scopeName "main";
	call {
		if (_varSafeZone > 0) then {
			// Safezone is enabled.
			// Make sure none of the group members is
			// too close to the players.
			if (_varPos == "PORTAL") then {
				// Portal position.
				{
					if ((_x distance _posPortal) <= _varSafeZone) then {
						["PORTAL", _portal, "Player(s) too close for spawning."] call Actionbuilder_fnc_debug;
						breakTo "main";
					};
				} forEach _players;
			} else {
				// Various positions.
				{
					private _p = _x select 1;
					{
						if ((_x distance _p) <= _varSafeZone) then {
							// Players too close to the vehicle.
							["PORTAL", _portal, "Player(s) too close for spawning."] call Actionbuilder_fnc_debug;
							breakTo "main";
						};
					} forEach _players;
				} forEach (_x select 1);
				{
					private _p = _x select 1;
					{
						if ((_x distance _p) <= _varSafeZone) then {
							// Players too close to the unit.
							["PORTAL", _portal, "Player(s) too close for spawning."] call Actionbuilder_fnc_debug;
							breakTo "main";
						};
					} forEach _players;
				} forEach (_x select 2);
			};
		};
		private _g = createGroup (_x select 0);
		RHNET_AB_L_GROUPS pushBack _g;
		_g deleteGroupWhenEmpty true;
		// Spawn vehicles first.
		{
			// 0: type,
			// 1: pos,
			// 2: dir
			if (_varPos == "PORTAL") then {
				_x set [1, _posPortal];
				_x set [2, _dirPortal];
			};
			private _v = createVehicle [_x select 0, _x select 1, [], 0, _varSpecial];
			_spawned pushBack _v;
			createVehicleCrew _v;
			(crew _v) joinSilent _g;
			_v setDir (_x select 2);
			_v setFormDir (_x select 2);
			_v setDamage _varDamage;
			_v setVehicleAmmo _varAmmo;
			_v setFuel _varFuel;
			{
				_x setVehicleAmmo _varAmmo;
				// Automatic skill can be disabled.
				if (isNil "RHNET_AB_L_DISABLE_SET_SKILL") then {
					_x setSkill _varSkill;
				};
			} forEach crew _v;
			// Planes can't hover.
			if (_varSpecial == "FLY" && _v isKindOf "Plane") then {
				_v setVelocity [
					sin (_x select 2) * 50,
					cos (_x select 2) * 50,
					_x select 2
				];
			};
			// Custom layouts.
			if (isNil "RHNET_AB_L_DISABLE_CUSTOM_LAYOUTS") then {
				clearItemCargoGlobal _v;
				clearweaponcargoglobal _v;
				clearMagazineCargoGlobal _v;
				clearBackpackCargoGlobal _v;
				[_v, _x select 3] call Actionbuilder_fnc_addGlobalCargo;
			};
		} forEach (_x select 1);
		// Spawn infantry last.
		{
			// 0: type,
			// 1: pos,
			// 2: dir
			if (_varPos == "PORTAL") then {
				_x set [1, _posPortal];
				_x set [2, _dirPortal];
			};
			private _u = _g createUnit [_x select 0, _x select 1, [], 0, _varSpecial];
			_spawned pushBack _u;
			_u setDir (_x select 2);
			_u setFormDir (_x select 2);
			_u setDamage _varDamage;
			_u setVehicleAmmo _varAmmo;
			_u setUnitPos (_x select 3);
			_u setUnitLoadout (_x select 4);
			// Automatic skill can be disabled.
			if (isNil "RHNET_AB_L_DISABLE_SET_SKILL") then {
				_u setSkill _varSkill;
			};
		} forEach (_x select 2);
		// Register [id, portal, current location, next location, banned location].
		RHNET_AB_L_GROUPPROGRESS pushBack _g;
		RHNET_AB_L_GROUPPROGRESS pushBack [0, _portal, objNull, objNull, []];
		// Assign waypoint.
		[_g] spawn Actionbuilder_fnc_addWaypoint;
	};
} forEach _groups;

// Register the spawned units.
RHNET_AB_L_AP_SPAWNED set [_i, _spawned];

// Refresh repeating queue if necessary.
if (!isNull _repeater) then {
	private _index = (RHNET_AB_L_REPEATER_QUEUE find _repeater) + 1;
	private _queue = RHNET_AB_L_REPEATER_QUEUE select _index;
	private _portalIndex = _queue find _portal;
	if (_portalIndex != -1) then {
		_queue deleteAt _portalIndex;
		RHNET_AB_L_REPEATER_QUEUE set [_index, _queue];
	};
};

true
