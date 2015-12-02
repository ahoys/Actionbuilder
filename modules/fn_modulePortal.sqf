/*
	File: fn_modulePortal.sqf
	Author: Ari Höysniemi

	Description:
	Validates a new portal.

	Parameter(s):
	0: OBJECT - portal module

	Returns:
	BOOL - true if valid placement
*/

// No clients allowed -----------------------------------------------------------------------------
if (!isServer) exitWith {false};

private ["_portal","_modules","_linked","_return","_type"];
_portal 		= [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_modules 		= _portal call BIS_fnc_moduleModules;
_varPositioning	= _portal getVariable ["p_Positioning","PORTAL"];
_linked			= [];
_return			= true;

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
		_linked pushBack _x;
	};
	if (!(_type == "RHNET_ab_moduleAP_F") && !(_type == "RHNET_ab_moduleWP_F")) exitWith {
		["Not supported module %1 synchronized into portal %2.", typeOf _x, _portal] call BIS_fnc_error;
		_return = false;
	};
} forEach _modules;

if (((count _linked) < 1) && (_return)) exitWith {
	["Portal %1 has no master. Synchronize the portal to a actionpoint.", _portal] call BIS_fnc_error;
	false
};

_return