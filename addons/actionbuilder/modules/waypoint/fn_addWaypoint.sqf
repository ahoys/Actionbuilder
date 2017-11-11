/*
	File: fn_addWaypoint.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an Actionbuilder component, outside calls are not supported.

	Description:
	Assigns a new waypoint to a group.

	Parameter(s):
	0: OBJECT - The target group.

	Returns:
	BOOL - true, if a new waypoint found and set.
*/
if (!isServer && hasInterface) exitWith {};

private _group = param [0, grpNull, [grpNull]];

// Group must exist.
if (isNull _group) exitWith {
	["Can't set a waypoint to a non-existent group."] call BIS_fnc_error;
	false
};

// Initialize search parameters for the next waypoint.
private _i = (RHNET_AB_L_GROUPPROGRESS find _group) + 1;
if (_i == -1) exitWith {
	["Group missing from the progress register."] call BIS_fnc_error;
	false
};
private _query = RHNET_AB_L_GROUPPROGRESS select _i;
private _id = _query select 0;
private _portal = _query select 1;
private _currentWp = objNull;
private _previousWp = objNull;
private _bannedWps = [];
if (_id == 0) then {
	// The very first waypoint.
	_currentWp = _portal;
} else {
	_currentWp = _query select 2;
	_previousWp = _query select 3;
	_bannedWps = _query select 4;
};

// Select the next waypoint.
private _nextWp = [
	_currentWp,
	_previousWp,
	_bannedWps
] call Actionbuilder_fnc_selectWaypoint;
if (isNull _nextWp) exitWith {false};

// Process the new waypoint.
private _wpType = _nextWp getVariable ["WpType", "MOVE"];
private _wpBehaviour = _nextWp getVariable ["WpBehaviour", "UNCHANGED"];
private _wpSpeed = _nextWp getVariable ["WpSpeed", "UNCHANGED"];
private _wpFormation = _nextWp getVariable ["WpFormation", "NO CHANGE"];
private _wpMode = _nextWp getVariable ["WpMode", "NO CHANGE"];
private _wpWait = _nextWp getVariable ["WpWait", 0];
private _wpPlacement = _nextWp getVariable ["WpPlacement", 0];
private _wpSpecial = _nextWp getVariable ["WpSpecial", 0];
private _wpStatement = ["true", "[group this] spawn Actionbuilder_fnc_addWaypoint"];
private _wpSynchronized = _nextWp call Actionbuilder_fnc_getSynchronizedClosest;
private _wpPos = [];
private _skip = false;

// Sleep before anything as the environment may still change.
if (_wpWait isEqualType 0) then {
	sleep _wpWait;
};

// Calculate the waypoint position.
if (isNull _wpSynchronized) then {
	// Waypoint has no synchronizations. Use the module position.
	_wpPos = getPosATL _nextWp;
} else {
	// Synchronizations found, use the position of the synchronized unit.
	_wpPos = getPosATL _wpSynchronized;
};

// Special type: U-turn.
// Turn back to the previous waypoint.
if (_wpType == "UTURN") exitWith {
	if (typeOf _currentWp != "RHNET_ab_modulePORTAL_F") exitWith {
		// The previous waypoint is not a portal.
		(RHNET_AB_L_GROUPPROGRESS select _i) set [0, _id + 1];
		(RHNET_AB_L_GROUPPROGRESS select _i) set [2, _currentWp];
		(RHNET_AB_L_GROUPPROGRESS select _i) set [3, _nextWp];
		[_group] spawn Actionbuilder_fnc_addWaypoint;
		true
	};
	false
};

// Update the progress register
(RHNET_AB_L_GROUPPROGRESS select _i) set [0, _id + 1];
(RHNET_AB_L_GROUPPROGRESS select _i) set [2, _nextWp];
(RHNET_AB_L_GROUPPROGRESS select _i) set [3, _currentWp];

// Special type: punish.
// Affects entire group and objects linked to the waypoint.
if (
	_wpType == "NEUTRALIZE" ||
	_wpType == "KILL" ||
	_wpType == "REMOVE"
) then {
	private _units = _nextWp call BIS_fnc_moduleUnits;
	{
		[_x, _wpType] spawn Actionbuilder_fnc_punish;
	} forEach _units;
	[_group, _wpType] call Actionbuilder_fnc_punish;
	if (!alive leader _group) exitWith {false};
	_skip = true;
};

// Special property: placement.
// 1: Portal position, 0: player position.
// Changing these values to strings would break backwards compatibility.
if (_wpPlacement == 1) then {
	private _closestDistance = -1;
	{
		if !(objectParent _x isKindOf "Air" || objectParent _x isKindOf "Ship") then {
			private _distance = _x distance _nextWp;
			if (_distance < _closestDistance || _closestDistance == -1) then {
				_closestDistance = _distance;
				_wpPos = getPosATL _x;
			};
		};
	} forEach (switchableUnits + playableUnits);
};

// Special type: command.
// Affects the entire group and objects linked to the waypoint.
if (_wpType == "TARGET" || _wpType == "FIRE") then {
	private _target = _nextWp;
	private _plausibleTargets = _nextWp call BIS_fnc_moduleUnits;
	if (count _plausibleTargets > 0) then {
		_target = _plausibleTargets;
	};
	if ([_group, _target, _wpType] call Actionbuilder_fnc_command) then {
		_skip = true;
		sleep 5;
	};
};

// Special property: reusability.
// 1: Waypoint can be used only once / group.
if (_wpSpecial == 1) then {
	((RHNET_AB_L_GROUPPROGRESS select _i) select 4) pushBack _nextWp;
};

// Set completion distance.
private _vehicle = objectParent (leader _group);
private _wpRadius = 0;
call {
	if (isNull _vehicle) exitWith {_wpRadius = 2};
	if (_vehicle isKindOf "AIR") exitWith {_wpRadius = 40; _wpPos set [2, (_wpPos select 2) + 100]};
	if (_vehicle isKindOf "CAR") exitWith {_wpRadius = 10};
	if (_vehicle isKindOf "TANK") exitWith {_wpRadius = 20};
	if (_vehicle isKindOf "SHIP") exitWith {_wpRadius = 30};
};

// No need to do anything if following the player and
// already next to the player.
if (_wpPlacement == 1 && !isNull _previousWp) then {
	if (
		_wpType == _previousWp getVariable ["wpType", "MOVE"] &&
		(leader _group) distance _wpPos < _wpRadius + 4
	) then {
		_skip = true;
		sleep 1;
	};
};

// Special property: send vehicles away.
if (_wpType == "SVA" && !_skip) then {
	[_group, _wpPos] call Actionbuilder_fnc_sendVehiclesAway;
	_skip = true;
};

// Skip to the next waypoint if further processing is not required.
if (_skip) exitWith {
	[_group] spawn Actionbuilder_fnc_addWaypoint;
	true
};

// Actionbuilder specific special types.
call {
	if (_wpType == "GETIN") exitWith {[_group, false] call Actionbuilder_fnc_loadTransport; _wpPos = position leader _group};
	if (_wpType == "UNLOAD") exitWith {[_group, false] call Actionbuilder_fnc_unloadVehicles; _wpPos = position leader _group};
	if (_wpType == "FORCE") exitWith {[_group, true] call Actionbuilder_fnc_loadTransport; _wpPos = position leader _group};
	if (_wpType == "GETOUT") exitWith {[_group, true] call Actionbuilder_fnc_unloadVehicles; _wpPos = position leader _group};
};

// Translate the special types.
if (
	_wpType != "MOVE" &&
	_wpType != "SAD" &&
	_wpType != "GUARD" &&
	_wpType != "DISMISSED"
) then {
	_wpType = "MOVE";
};

// Execute the new waypoint.
private _wp = _group addWaypoint [_wpPos, _wpRadius];
_wp setWaypointType _wpType;
_wp setWaypointBehaviour _wpBehaviour;
_wp setWaypointSpeed _wpSpeed;
_wp setWaypointFormation _wpFormation;
_wp setWaypointCombatMode _wpMode;
_wp setWaypointStatements _wpStatement;

true