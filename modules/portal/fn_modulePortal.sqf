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

private["_portal","_objects","_groups","_parents","_i","_vehicle"];
_portal		= _this select 0;

// The portal should have an actionpoint as a master ----------------------------------------------
if ([_portal, false] call Actionbuilder_fnc_moduleActionpoints isEqualTo []) exitWith {
	["Portal %1 has no master. Synchronize portals to actionpoints.", _portal] call BIS_fnc_error;
	false
};

// Initialize master variables if required --------------------------------------------------------
if (isNil "RHNET_AB_G_PORTALS") then {
	RHNET_AB_G_PORTALS			= [];
	RHNET_AB_G_PORTAL_OBJECTS	= [];
	RHNET_AB_G_PORTAL_GROUPS	= [];
};

// The portal should not be grouped to other units ------------------------------------------------
if (((formationLeader _portal) != _portal) && ((_portal getVariable ["p_Positioning","PORTAL"]) == "PORTAL")) then {
	_portal setVariable ["p_Positioning","NONE"];
	["Portal %1 is grouped to %2. Portals should NEVER be grouped to anything as their positions may change!", _portal, formationLeader _portal] call BIS_fnc_error;
};

// Register objects and groups synchronized to the portal -----------------------------------------
_objects	= [];
_groups		= [];
_parents	= [];
_i			= 0;

{
	if (_x isKindOf "Man") then {
		_groups pushBack [side _x, [], []];
		{
			if (isNull objectParent _x) then {
				// Infantry
				((_groups select _i) select 1) pushBack [typeOf _x, getPosATL _x, getDir _x];
			} else {
				// Crewmen
				_vehicle = objectParent _x;
				if !(_vehicle in _parents) then {
					_parents pushBack _vehicle;
					((_groups select _i) select 2) pushBack [typeOf _vehicle, getPosATL _vehicle, getDir _vehicle];
				};
			};
		} forEach units group _x;
		_i = _i + 1;
	} else {
		if (side _x == CIVILIAN) then {
			_objects pushBack [typeOf _x, getPosATL _x, getDir _x];
		};
	};
} forEach synchronizedObjects _portal;

RHNET_AB_G_PORTALS pushBack _portal;

RHNET_AB_G_PORTAL_OBJECTS pushBack _portal;
RHNET_AB_G_PORTAL_OBJECTS pushBack _objects;

RHNET_AB_G_PORTAL_GROUPS pushBack _portal;
RHNET_AB_G_PORTAL_GROUPS pushBack _groups;

true