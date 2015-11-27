/*

	Author: Raunhofer
	Last Update: d12/m07/y15
	Build: 4
	
	Title: ACTION PORTAL MODULE
	Description: Main function for 'Action Portal' module.
	
	Duty: If all conditions are met, spawn a group.

*/

// --- Check for headless clients -------------------------------------------------------------------------
HC_enabled = if (isNil "ab_HeadlessClient") then {false} else {true};
if (!isServer && hasInterface) exitWith {false};
if (HC_enabled && isMultiplayer && isServer) exitWith {false};

private [
	"_portal",
	"_distance",
	"_poSide",
	"_poInf",
	"_poVeh",
	"_poEVeh",
	"_poSafe",
	"_poSpec",
	"_poDiff",
	"_poInit",
	"_poDir",
	"_unit",
	"_group",
	"_grpID",
	"_rank",
	"_vehicle",
	"_pID",
	"_cID",
	"_wID",
	"_i"
];

// INITIAL VALUES -----------------------------------------------------------------------------------------
_portal		= _this select 0;
_group 		= "";

if (isNull _portal) exitWith {
	diag_log "Actionbuilder: rh_Portal encountered an initialization error.";
	false
};

// PARSE PORTAL DATA --------------------------------------------------------------------------------------
{
	if (_portal == (_x select 0)) then {
		_poSide		= _x select 1;											// Side of the spawning units
		_poInf		= _x select 2;											// To be spawned infantry
		_poVeh		= _x select 3;											// To be spawned manned vehicles
		_poEVeh		= _x select 4;											// To be spawned empty vehicles and objects
	};
} forEach RHNET_ab_units;													// Cycle all portals

_poSafe		= _portal getVariable ["p_MinDist",400];						// Portal's safezone
_poSpec		= _portal getVariable ["p_Special","NONE"];						// Special attributes
_poInit		= _portal getVariable ["p_UnitInit",""];
_poDir		= getDir _portal;

if ((isNil "_poSide") || (isNil "_poInf") || (isNil "_poVeh") || (isNil "_poEVeh") || (isNil "_poSafe") || (isNil "_poSpec") || (isNil "_poInit") || (isNil "_poDir")) exitWith {
	diag_log format ["Actionbuilder: portal (%1) initialization failed, in mission (%2)", _portal, missionName];
	false
};

if (((count _poInf) + (count _poVeh) + (count _poEVeh)) <= 0) exitWith {
	diag_log format ["Actionbuilder: portal (%1) has no units connected, in mission (%2)", _portal, missionName];
	false
};

// SAFEZONE -----------------------------------------------------------------------------------------------
if (isMultiplayer) then {
	{
		_distance = (_x distance _portal) - _poSafe;						// Playableunit's distance to the portal
	} forEach playableUnits;
} else {
	{
		_distance = (_x distance _portal) - _poSafe;						// Playableunit's distance to the portal
	} forEach switchableUnits;
};

if (_distance < 0) exitWith {false};

// INITIALIZE GROUP ---------------------------------------------------------------------------------------
_group = createGroup _poSide;
_grpID = (count RHNET_ab_groups);
RHNET_ab_groups set [_grpID, _group];										// Keep count of spawned groups

// EMPTY VEHICLES AND OBJECTS -----------------------------------------------------------------------------
{
	_vehicle = createVehicle [_x, (position _portal), [], 0, _poSpec];
	_vehicle setDir _poDir;													// Align vehicles with the portal
	sleep .05;
} forEach _poEVeh;															// Cycle empty vehicles and objects

// SPAWN INFANTRY -----------------------------------------------------------------------------------------
{
	if (_x == (_poInf select 0)) then {
		_poDiff = [0.50,0.55,0.60,0.65,0.70,0.75,0.80] select floor random (difficulty + 1);
		_rank = "SERGEANT";
	} else {
		_poDiff = [0.30,0.35,0.40,0.45,0.50,0.55,0.60] select floor random (difficulty + 1);
		_rank = "CORPORAL";
	};
	_unit = _group createUnit [_x, getPosATL _portal, [], 0, "NONE"];
	//_unit = _x createUnit [(getPosATL _portal), _group, _poInit, _poDiff, _rank];
	{
		if (_x isKindOf ["smokeShell", configFile >> "CfgMagazines"]) then {
			_unit removeMagazine _x;
		}
	} forEach magazines _unit;
	sleep .05;
} forEach _poInf;															// Cycle infantry

// SPAWN VEHICLES -----------------------------------------------------------------------------------------
{
	_vehicle = createVehicle [_x, (position _portal), [], 0, _poSpec];		// Spawn a vehicle
	_vehicle setDir _poDir;													// Align vehicles with the portal
	createVehicleCrew _vehicle;												// Spawn a crew
	(crew _vehicle) joinSilent _group;
	sleep .05;
} forEach _poVeh;															// Cycle vehicles

// ATTACH TO A WAYPOINT -----------------------------------------------------------------------------------
if (!isNil "RHNET_ab_waypointFnc") exitWith {
	_i = 0;
	{
		if (_x == _portal) exitWith {_pID = _i, _cID = _i; _wID = _i};
		_i = _i + 1;
	} forEach RHNET_ab_locations;
	[_pID,_cID,_wID,_grpID,0] spawn RHNET_ab_waypointFnc;
};

true