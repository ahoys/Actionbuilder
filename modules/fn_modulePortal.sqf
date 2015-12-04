/*
	File: fn_modulePortal.sqf
	Author: Ari Höysniemi

	Description:
	Makes sure everything is set up correctly

	Parameter(s):
	0: OBJECT - portal module

	Returns:
	BOOL - true if registered
*/

// No clients allowed -----------------------------------------------------------------------------
if (!isServer) exitWith {false};

private ["_portal","_varPositioning","_APs","_type"];
_portal 		= [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_varPositioning	= _portal getVariable ["p_Positioning","PORTAL"];
_APs			= [];

// Waypoint should not be grouped to other units --------------------------------------------------
if (((formationLeader _portal) != _portal) && (_varPositioning == "PORTAL")) then {
	_portal setVariable ["p_Positioning","NONE"];
	["Portal %1 is grouped to %2. Portals should NEVER be grouped to anything as their positions may change!", _portal, formationLeader _portal] call BIS_fnc_error;
};

// Make sure there are actionpoints available
{
	_type = typeOf _x;
	if (_type == "RHNET_ab_moduleAP_F") then {
		_APs pushBack _x;
	};
	if (!(_type == "RHNET_ab_moduleAP_F") && !(_type == "RHNET_ab_moduleWP_F")) then {
		["Not supported module %1 synchronized to portal %2.", _type, _portal] call BIS_fnc_error;
	};
} forEach (_portal call BIS_fnc_moduleModules);

if (count _APs < 1) exitWith {
	["Portal %1 has no master. Synchronize portals to actionpoints.", _portal] call BIS_fnc_error;
};

true