/*
	File: fn_modulePortal.sqf
	Author: Ari Höysniemi

	Description:
	Makes sure everything is set up correctly in the mission editor

	Parameter(s):
	0: OBJECT - portal module

	Returns:
	BOOL - true if valid check
*/

// No clients allowed -----------------------------------------------------------------------------
if (!isServer) exitWith {false};

private ["_portal","_valid","_type"];
_portal 		= _this select 0;
_valid			= false;

// Portal should not be grouped to other units ----------------------------------------------------
if (((formationLeader _portal) != _portal) && ((_portal getVariable ["p_Positioning","PORTAL"]) == "PORTAL")) then {
	_portal setVariable ["p_Positioning","NONE"];
	["Portal %1 is grouped to %2. Portals should NEVER be grouped to anything as their positions may change!", _portal, formationLeader _portal] call BIS_fnc_error;
};

// Make sure there are actionpoints available -----------------------------------------------------
{
	_type = typeOf _x;
	if (_type == "RHNET_ab_moduleAP_F") then {
		_valid = true;
	};
	if ((_type != "RHNET_ab_moduleWP_F") && (_type != "RHNET_ab_modulePORTAL_F")) then {
		["Not supported module %1 synchronized to portal %2.", _type, _portal] call BIS_fnc_error;
	};
} forEach (_portal call BIS_fnc_moduleModules);

if !(_valid) then {
	["Portal %1 has no master. Synchronize portals to actionpoints.", _portal] call BIS_fnc_error;
};

true