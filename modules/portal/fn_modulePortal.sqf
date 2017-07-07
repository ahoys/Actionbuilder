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
private["_portal","_synced"];
_portal = _this select 0;
_synced = synchronizedObjects _portal;

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
RHNET_AB_G_PORTALS pushBack _portal;
RHNET_AB_G_PORTAL_OBJECTS pushBack _portal;
RHNET_AB_G_PORTAL_OBJECTS pushBack ([_synced] call Actionbuilder_fnc_readObjects);
RHNET_AB_G_PORTAL_GROUPS pushBack _portal;
RHNET_AB_G_PORTAL_GROUPS pushBack ([_synced] call Actionbuilder_fnc_readGroups);

true