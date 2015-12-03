/*
	File: fn_modulePortal.sqf
	Author: Ari Höysniemi

	Description:
	Validates a new portal.

	Parameter(s):
	0: OBJECT - portal module

	Returns:
	BOOL - true if registered
*/

// No clients allowed -----------------------------------------------------------------------------
if (!isServer) exitWith {false};

private ["_portal","_APs","_type"];
_portal 		= [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_varPositioning	= _portal getVariable ["p_Positioning","PORTAL"];
_APs			= [];

waitUntil {!isNil "ACTIONBUILDER_locations" && !isNil "ACTIONBUILDER_portal_objects" && !isNil "ACTIONBUILDER_portal_groups"};

// Waypoint should not be grouped to other units --------------------------------------------------
if (((formationLeader _portal) != _portal) && (_varPositioning == "PORTAL")) exitWith {
	_portal setVariable ["p_Positioning","NONE"];
	["Portal %1 is grouped to %2. Portals should NEVER be grouped to anything as their positions may change!", _portal, formationLeader _portal] call BIS_fnc_error;
	false
};

// Make sure there are actionpoints available -----------------------------------------------------
{
	_type = typeOf _x;
	if (_type == "RHNET_ab_moduleAP_F") then {
		_APs pushBack _x;
	};
	if (!(_type == "RHNET_ab_moduleAP_F") && !(_type == "RHNET_ab_moduleWP_F")) then {
		["Not supported module %1 synchronized to portal %2.", _type, _portal] call BIS_fnc_error;
	};
} forEach (_portal call BIS_fnc_moduleModules);

if ((count _APs) < 1) exitWith {
	["Portal %1 has no master. Synchronize portals to actionpoints.", _portal] call BIS_fnc_error;
	false
};

// Register units ---------------------------------------------------------------------------------
waitUntil {!isNil "ACTIONBUILDER_portal_objects" && !isNil "ACTIONBUILDER_portal_groups"};
_objects	= [_portal] call Actionbuilder_fnc_getSyncedObjects;
_groups		= [_portal] call Actionbuilder_fnc_getSyncedGroups;

ACTIONBUILDER_portal_objects pushBack _portal;
ACTIONBUILDER_portal_objects pushBack [_objects];

ACTIONBUILDER_portal_groups pushBack _portal;
ACTIONBUILDER_portal_groups pushBack [_groups];
//diag_log format ["PORTAL: %1 >>>> %2 - %3", _portal, _objects, _groups];
// Delete units -----------------------------------------------------------------------------------
[_portal, false] spawn Actionbuilder_fnc_deleteSyncedUnits;

// Register portal --------------------------------------------------------------------------------
waitUntil {!isNil "ACTIONBUILDER_locations"};
ACTIONBUILDER_locations pushBack _portal;

true