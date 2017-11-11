/*
	File: fn_modulePortal.sqf
	Author: Ari Höysniemi

	Description:
	Makes sure everything is set up correctly and registers synchronized units

	Parameter(s):
	0: OBJECT - portal module

	Returns:
	Nothing
*/
private _portal = param [0, objNull, [objNull]];
private _synced = synchronizedObjects _portal;

// The portal should have an actionpoint as a master ----------------------------------------------
if ([_portal, false] call Actionbuilder_fnc_moduleActionpoints isEqualTo []) exitWith {
	["Portal %1 has no master. Synchronize portals to actionpoints.", _portal] call BIS_fnc_error;
	false
};

// The portal should have something to spawn ------------------------------------------------------
if (_synced isEqualTo []) exitWith {
	["Portal %1 has no synchronized objects. Synchronize units to portals.", _portal] call BIS_fnc_error;
	false
};

// Initialize master variables if required --------------------------------------------------------
if (isNil "RHNET_AB_G_PORTALS") then {RHNET_AB_G_PORTALS = []};
if (isNil "RHNET_AB_G_PORTAL_OBJECTS") then {RHNET_AB_G_PORTAL_OBJECTS = []};
if (isNil "RHNET_AB_G_PORTAL_GROUPS") then {RHNET_AB_G_PORTAL_GROUPS = []};

// Save the portal to global variables ------------------------------------------------------------
RHNET_AB_G_PORTAL_OBJECTS pushBack _portal;
RHNET_AB_G_PORTAL_OBJECTS pushBack ([_synced] call Actionbuilder_fnc_readObjects);
RHNET_AB_G_PORTAL_GROUPS pushBack _portal;
RHNET_AB_G_PORTAL_GROUPS pushBack ([_synced] call Actionbuilder_fnc_readGroups);
RHNET_AB_G_PORTALS pushBack _portal;

// Create a synchronized registration -------------------------------------------------------------
// This will enable registering same units to multiple portals.
private _siblings = [_portal, _synced] call Actionbuilder_fnc_getSiblingPortals;
waitUntil {
	private _result = true;
	{
		if !(_x in RHNET_AB_G_PORTALS) exitWith {_result = false};
	} forEach _siblings;
	_result;
};

// Clean up ---------------------------------------------------------------------------------------
[
	[_portal],
	["RHNET_ab_moduleAP_F", "RHNET_ab_modulePORTAL_F", "RHNET_ab_moduleWP_F"]
] call Actionbuilder_fnc_deleteSynchronized;

true