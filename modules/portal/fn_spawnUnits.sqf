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
	// 0: type,
	// 1: pos,
	// 2: dir,
	// 3: damage,
	// 4: fuel,
	// 5: locked
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
					breakTo "main";
				};
			} forEach _players;
		};
		// Spawn the object.
		private _v = createVehicle [_x select 0, _x select 1, [], 0, _varSpecial];
		_v setDir (_x select 2);
		_v setDamage (_x select 3);
		_v setFuel (_x select 4);
		_v lock (_x select 5);
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
							breakTo "main";
						};
					} forEach _players;
				} forEach (_x select 1);
				{
					private _p = _x select 1;
					{
						if ((_x distance _p) <= _varSafeZone) then {
							// Players too close to the unit.
							breakTo "main";
						};
					} forEach _players;
				} forEach (_x select 2);
			};
		};
		private _g = createGroup (_x select 0);
		// Spawn vehicles first.
		{
			// 0: type,
			// 1: pos,
			// 2: dir,
			// 3: damage,
			// 4: fuel,
			// 5: locked
			if (_varPos == "PORTAL") then {
				_x set [1, _posPortal];
				_x set [2, _dirPortal];
			};
			private _v = createVehicle [_x select 0, _x select 1, [], 0, _varSpecial];
			createVehicleCrew _v;
			(crew _v) joinSilent _g;
			_v setDir (_x select 2);
			_v setDamage (_x select 3);
			_v setFuel (_x select 4);
			_v lock (_x select 5);
		} forEach (_x select 1);
		// Spawn infantry last.
		{
			// 0: type,
			// 1: pos,
			// 2: dir,
			// 3: damage,
			// 4: skill,
			// 5: rank
			if (_varPos == "PORTAL") then {
				_x set [1, _posPortal];
				_x set [2, _dirPortal];
			};
			private _u = _g createUnit [_x select 0, _x select 1, [], 0, _varSpecial];
			_u setDir (_x select 2);
			_u setDamage (_x select 3);
			_u setSkill (_x select 4);
			_u setRank (_x select 5);
		} forEach (_x select 2);
		// Register [id, portal, current location, next location, banned location].
		RHNET_AB_L_GROUPPROGRESS pushBack _g;
		RHNET_AB_L_GROUPPROGRESS pushBack [0, _portal, objNull, objNull, []];
		// Assign waypoint.
		[_g] spawn Actionbuilder_fnc_assignWaypoint;
	};
} forEach _groups;

true