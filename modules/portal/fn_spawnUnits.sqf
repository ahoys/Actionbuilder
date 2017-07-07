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

private _portal = _this select 0; // This portal.
private _owner = _this select 1; // Processing owner of the portal (eg. server or headless client).

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

// Processing -------------------------------------------------------------------------------------

// Portal settings.
private _varPos = _portal getVariable ["p_Positioning","PORTAL"];
private _varSafeZone = _portal getVariable ["p_MinDist",400];
private _varSpecial = _portal getVariable ["p_Special","NONE"];

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
	diag_log format ["ABO %1", _x];
	private _spawn = true;
	private _type = _x select 0;
	private _pos = _x select 1;
	private _dir = _x select 2;
	private _damage = _x select 3;
	private _fuel = _x select 4;
	private _locked = _x select 5;
	// Set the position.
	if (_varPos == "PORTAL") then {
		_pos = _posPortal;
		_dir = _dirPortal;
	};
	// Make sure that players are outside the safe zone.
	if (_varSafeZone > 0) then {
		{
			if ((_x distance _pos) <= _varSafeZone) then {
				_spawn = false;
			};
		} forEach _players;
	};
	// Spawn the object.
	if (_spawn) then {
		private _veh = createVehicle [_type, _pos, [], 0, _varSpecial];
		_veh setDir _dir;
		_veh setDamage _damage;
		_veh setFuel _fuel;
		_veh lock _locked;
	};
} forEach _objects;

// Spawn groups second.
diag_log format ["AB GROUPS: %1", _groups];
{
	private _side = _x select 0;
	private _vehicles = _x select 1;
	private _infantry = _x select 2;
	private _safeZoneClear = true;
	// Make sure that the entire group is outside
	// the safezone.
	if (_varSafeZone > 0) then {
		if (_varPos == "PORTAL") then {
			// Everybody spawns at the portal.
			{
				if ((_x distance _posPortal) <= _varSafeZone) then {
					_safeZoneClear = false;
				};
			} forEach _players;
		} else {
			// Vehicles.
			{
				private _vehPos = _x select 1;
				{
					if ((_x distance _vehPos) <= _varSafeZone) then {
						_safeZoneClear = false;
					};
				} forEach _players;
			} forEach _vehicles;
			// Infantry.
			{
				private _unitPos = _x select 1;
				{
					if ((_x distance _unitPos) <= _varSafeZone) then {
						_safeZoneClear = false;
					};
				} forEach _players;
			} forEach _infantry;
		};
	};
	if (_safeZoneClear) then {
		// Safezone is clear. The spawning will happen.
		// Spawn the group vehicles first.
		private _grp = createGroup _side;
		{
			diag_log format ["ABV %1", _x];
			private _spawn = true;
			private _type = _x select 0;
			private _pos = _x select 1;
			private _dir = _x select 2;
			private _damage = _x select 3;
			private _fuel = _x select 4;
			private _locked = _x select 5;
			// Set the position.
			if (_varPos == "PORTAL") then {
				_pos = _posPortal;
				_dir = _dirPortal;
			};
			// Spawn the vehicle.
			private _veh = createVehicle [_type, _pos, [], 0, _varSpecial];
			// Spawn the crew.
			createVehicleCrew _veh;
			(crew _veh) joinSilent _grp;
			// Set attributes.
			_veh setDir _dir;
			_veh setDamage _damage;
			_veh setFuel _fuel;
			_veh lock _locked;
		} forEach _vehicles;
		// Spawn the group infantry second.
		{
			diag_log format ["ABU %1", _x];
			private _spawn = true;
			private _type = _x select 0;
			private _pos = _x select 1;
			private _dir = _x select 2;
			private _damage = _x select 3;
			private _skill = _x select 4;
			private _rank = _x select 5;
			// Set the position.
			if (_varPos == "PORTAL") then {
				_pos = _posPortal;
				_dir = _dirPortal;
			};
			// Spawn the unit.
			private _unit = _grp createUnit [_type, _pos, [], 0, _varSpecial];
			// Set attributes.
			_unit setDir _dir;
			_unit setDamage _damage;
			_unit setSkill _skill;
			_unit setRank _rank;
		} forEach _infantry;
		// Register [id, portal, current location, next location, banned location].
		RHNET_AB_L_GROUPPROGRESS pushBack _grp;
		RHNET_AB_L_GROUPPROGRESS pushBack [0, _portal, objNull, objNull, []];
		// Assign waypoint.
		[_grp] spawn Actionbuilder_fnc_assignWaypoint;
	};
} forEach _groups;

true