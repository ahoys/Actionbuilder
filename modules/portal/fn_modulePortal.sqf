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
private _portal = _this select 0;

// The portal should have an actionpoint as a master ----------------------------------------------
if ([_portal, false] call Actionbuilder_fnc_moduleActionpoints isEqualTo []) exitWith {
	["Portal %1 has no master. Synchronize portals to actionpoints.", _portal] call BIS_fnc_error;
	false
};

// Initialize master variables if required --------------------------------------------------------
if (isNil "RHNET_AB_G_PORTALS") then {RHNET_AB_G_PORTALS = []};
if (isNil "RHNET_AB_G_PORTAL_OBJECTS") then {RHNET_AB_G_PORTAL_OBJECTS = []};
if (isNil "RHNET_AB_G_PORTAL_GROUPS") then {RHNET_AB_G_PORTAL_GROUPS = []};

// Util functions ---------------------------------------------------------------------------------

// Register objects and groups synchronized to the portal -----------------------------------------
private _objects			= []; // Empty objects & vehicles.
private _groups				= []; // Groups. ([[side, [units]], [side, units]])
private _registeredGroups 	= []; // Each group should be registered only once.
{
	if (isNull group _x) then {
		// HAS NO GROUP.
		// An object or a vehicle.
		_objects pushBack [true, [typeOf _x, getPosATL _x, getDir _x]];
	} else {
		if (_x isKindOf "Man") then {
			// HAS A GROUP.
			// A man or a manned vehicle.
			if !(group _x in _registeredGroups) then {
				_registeredGroups pushBack group _x;
				private _grp = [side _x, []];
				private _registeredVehicles = [];
				{
					private _unit = _x;
					private _veh = objectParent _unit;
					if (isNull _veh) then {
						// Belongs to infantry.
						// [not a vehicle, [unit data]].
						(_grp select 1) pushBack [false, [typeOf _unit, getPosATL _unit, getDir _unit]];
					} else {
						// Has a ride.
						if !(_veh in _registeredVehicles) then {
							_registeredVehicles pushBack _veh;
							// [is a vehicle, [vehicle data]].
							(_grp select 1) pushBack [true, [typeOf _veh, getPosATL _veh, getDir _veh]];
						};
					};
				} forEach units group _x;
				diag_log format ["AB _grp: %1", _grp];
				_groups pushBack _grp;
			};
		};
		diag_log format ["AB _groups: %1", _groups];
	};
} forEach synchronizedObjects _portal;

// Save the results to global variables -----------------------------------------------------------
diag_log format ["Actionbuilder Portal %1, OBJECTS: %2", _portal, _objects];
diag_log format ["Actionbuilder Portal %1, GROUPS: %2", _portal, _groups];
// RHNET_AB_G_PORTALS pushBack _portal;
// RHNET_AB_G_PORTAL_OBJECTS pushBack _portal;
// RHNET_AB_G_PORTAL_OBJECTS pushBack _objects;
// RHNET_AB_G_PORTAL_GROUPS pushBack _portal;
// RHNET_AB_G_PORTAL_GROUPS pushBack _groups;

true