/*

	Author: Raunhofer
	Last Update: d12/m07/y15
	Build: 4
	
	Title: INFANTRY WAYPOINT MODULE
	Description: Main function for 'Infantry Waypoint' module.
	
	Duty: If all conditions are met, add a new waypoint for a group.

*/

// --- Check for headless clients -------------------------------------------------------------------------
HC_enabled = if (isNil "ab_HeadlessClient") then {false} else {true};
if (!isServer && hasInterface) exitWith {false};
if (HC_enabled && isMultiplayer && isServer) exitWith {false};

private [
	"_pID",
	"_originPortal",
	"_previous",
	"_current",
	"_next",
	"_grpID",
	"_id",
	"_grp",
	"_syncedModules",
	"_syncedUnits",
	"_waypoints",
	"_waypointsF",
	"_waypointsH",
	"_candidateWps",
	"_wp",
	"_triggers",
	"_vehGrp",
	"_vehWp",
	"_grpWp",
	"_wType",
	"_wBehaviour",
	"_wSpeed",
	"_wFormation",
	"_wMode",
	"_wPlacement",
	"_wStateText",
	"_wStatement",
	"_wLocation",
	"_pLocation",
	"_wCompletion",
	"_wSpecial",
	"_distance",
	"_target",
	"_vehicles",
	"_removeVeh",
	"_vehicle",
	"_crew",
	"_inf",
	"_cTime"
];

// INITIAL VALUES -----------------------------------------------------------------------------------------
_pID			= _this select 0;																// Origin portal id
_originPortal	= RHNET_ab_locations select (_this select 0);									// Origin portal
_previous 		= RHNET_ab_locations select (_this select 1);									// Previous WP
_current 		= RHNET_ab_locations select (_this select 2);									// Current WP
_cID			= _this select 2;																// Current id
_grpID 			= _this select 3;																// Group id
_id 			= (_this select 4) + 1;															// New id
_grp 			= RHNET_ab_groups select _grpID;												// Controlled group
_syncedModules	= _current call BIS_fnc_moduleModules;											// Synced modules
_crew			= [];
_vehicles		= [];
_inf			= [];

// CONDITIONS ---------------------------------------------------------------------------------------------
_waypoints		= [];																			// TRUE waypoints
_waypointsF		= [];																			// FALSE waypoints
_waypointsH		= [];																			// HIGH PRIORITY waypoints
{
	if ((typeOf _x == "RHNET_ab_moduleWP_F") && (_x != _previous) && !(_x in RHNET_ab_locations_used)) then {
		_wp = _x;																				// Investigated waypoint
		_syncedTriggers = _wp call BIS_fnc_moduleTriggers;										// Synced triggers
		if (count _syncedTriggers > 0) then {
			{
				if (triggerActivated _x) then {
					// TRUE waypoint
					_waypoints set [(count _waypoints), _wp];
				} else {
					// FALSE waypoint
					_waypointsF set [(count _waypointsF), _wp];
				};
			} forEach _syncedTriggers;															// Cycle synced triggers
		} else {
			_waypoints set [(count _waypoints), _wp];
		};
	};
} forEach _syncedModules;																		// Cycle synced modules

// EXIT IF NO WAYPOINTS AVAILABLE
if ((count _waypoints <= 0) && (count _waypointsF <= 0)) exitWith {false};

// WAIT FOR AT LEAST ONE WAYPOINT TO BE TRUE
if (count _waypoints <= 0) then {
	while {count _waypoints <= 0} do {															// Cycle while no TRUE waypoints available
		{
			_wp = _x;																			// Investigated waypoint
			_syncedTriggers = _wp call BIS_fnc_moduleTriggers;									// Synced triggers
			{
				if (triggerActivated _x) exitWith {_waypoints set [(count _waypoints), _wp]};	// Add TRUE waypoint and exit loop
			} forEach _syncedTriggers;
		} forEach _waypointsF;																	// Cycle FALSE waypoints
		sleep .5;
	};
};

// SELECT A WAYPOINT --------------------------------------------------------------------------------------

// FIND HIGH PRIORITIES
{
	if (_x getVariable ["WpSpecial",0] == 2) then {
		_waypointsH set [(count _waypointsH), _x];	
	};
} forEach _waypoints;

// SELECT A NEW WAYPOINT
if (count _waypointsH > 0) then {
	// High priority waypoints available
	_candidateWps = [_grp, _waypointsH, [_current, true]] call Actionbuilder_fnc_objectsAhead;
	if (count _candidateWps < 1) then {
		_wp = _waypointsH select floor random count _waypointsH;
	} else {
		_wp = _candidateWps select floor random count _candidateWps;
	};
} else {
	// Regular waypoints
	_candidateWps = [_grp, _waypoints, [_current, true]] call Actionbuilder_fnc_objectsAhead;
	if (count _candidateWps < 1) then {
		_wp = _waypoints select floor random count _waypoints;
	} else {
		_wp = _candidateWps select floor random count _candidateWps;
	};
};

// REGISTERING
_wID = _cID;
_i = 0;
{
	if (_wp == _x) exitWith {_wID = _i};
	_i = _i + 1;
} forEach RHNET_ab_locations;

// GATHER INFORMATION ABOUT THE NEW WAYPOINT --------------------------------------------------------------
_next			= RHNET_ab_locations select _wID;												// Next waypoint
_syncedUnits	= _next call BIS_fnc_moduleUnits;												// Synced units
_wType 			= _wp getVariable ["WpType","MOVE"];											// Type of the waypoint
_wBehaviour 	= _wp getVariable ["WpBehaviour","UNCHANGED"];									// How to behave during this wp
_wSpeed 		= _wp getVariable ["WpSpeed","UNCHANGED"];										// How fast should the group move
_wFormation 	= _wp getVariable ["WpFormation","NO CHANGE"];									// In what formation should the group be
_wMode 			= _wp getVariable ["WpMode","NO CHANGE"];										// Group's fire control
_wWait 			= _wp getVariable ["WpWait",0];													// For how long should we wait before activation
_wPlacement 	= _wp getVariable ["WpPlacement",0];											// Whether to find the current position of a closest player
_wSpecial		= _wp getVariable ["WpSpecial",0];												// For special actions later on
_wStateText		= format ["[%1,%2,%3,%4,%5] spawn RHNET_ab_waypointFnc",_pID,_cID,_wID,_grpID,_id];
_wStatement		= ["true", _wStateText];
_wLocation 		= getPosATL _wp;																// Initial waypoint location
_wCompletion	= 5;																			// Initial completion distance
_target			= leader _grp;																	// Initial target for Locate Players

// DENY REUSE IF REQUESTED
if (_wSpecial == 1) then {
	RHNET_ab_locations_used set [(count RHNET_ab_locations_used), _wp];	
};

// WAIT IF REQUESTED
if (_wWait isEqualType "SCALAR") then {
	sleep _wWait;
} else { _wWait = 0; };

// ADJUST COMPLETION DISTANCE
if ((vehicle _target) isKindOf "AIR") then {
	_wCompletion	= 30;
};

if ((vehicle _target) isKindOf "SHIP") then {
	_wCompletion	= 20;
};

if ((vehicle _target) isKindOf "LandVehicle") then {
	_wCompletion	= 10;
};

// LOCATE THE PLAYER
if (_wPlacement > 0) then {
	_distance = 999999999;																		// Initial distance to beat
	if (isMultiplayer) then {
		// MULTIPLAYER
		{
			if (!(vehicle _x isKindOf "Air") && !(vehicle _x isKindOf "Ship") && ((_wp distance _x) < _distance)) then {
				// FOLLOWABLE PLAYABLE UNIT FOUND
				_wLocation = [((getPosASL _x) select 0),((getPosASL _x) select 1),((getPosASL _x) select 2)];
				_distance = _wp distance _x;													// New closest distance
				_target = _x;																	// New target is this playableUnit
			};
		} forEach playableUnits;																// Look for even closer playableUnits
	} else {
		// SINGLEPLAYER
		{
			if (!(vehicle _x isKindOf "Air") && !(vehicle _x isKindOf "Ship") && ((_wp distance _x) < _distance)) then {
				// FOLLOWABLE SWITCHABLE UNIT FOUND
				_wLocation = [((getPosASL _x) select 0),((getPosASL _x) select 1),((getPosASL _x) select 2)];
				_distance = _wp distance _x;													// New closest distance
				_target = _x;																	// New target is this switchableUnit
			};
		} forEach switchableUnits;																// Look for even closer switchableUnits
	};
};

// ADJUST COMPLETION DISTANCE
if ((vehicle leader _grp) isKindOf "AIR") then {
	_wLocation set [2, ((_wLocation select 2) + 100)];											// Move the waypoint higher for AIR vehicles
};

// WAIT IF ALREADY TOO CLOSE TO PLAYER
if ((_wPlacement == 1) && (((leader _grp) distance _target) < _wCompletion)) then {
	while {((leader _grp) distance _target) < _wCompletion} do {
		sleep .5;
	};
};

// CATEGORIZE VEHICLES, CREWS AND INFANTRY ----------------------------------------------------------------
// 1. VEHICLES
{
	if ((_x != (vehicle _x)) && !((vehicle _x) in _vehicles)) then {
		_vehicles set [(count _vehicles), vehicle _x];											// Append _vehicles array with a new vehicle
	};
} forEach units _grp;																			// Cycle all units in this group
// 2. CREW
{
	{
		if !(_x in assignedCargo vehicle _x) then {
			_crew set [(count _crew), _x];														// Append _crew array with a new crew member
		};
	} forEach (crew _x);																		// Cycle all crew members
} forEach _vehicles;																			// Cycle all found vehicles
// 4. INFANTRY
_inf = units _grp;
_inf = _inf - _vehicles;																		// Remove vehicles from infantry
_inf = _inf - _crew;																			// Remove crew from infantry

// SPECIAL ACTIONS ----------------------------------------------------------------------------------------

// KILL ALL UNITS : KILL
if (_wType == "KILL") then {
	if (count _syncedUnits > 0) then {
		{
			if (vehicle _x != _x) then {
				_veh = vehicle _x;
				{
					_x setDamage 1;
				} forEach crew _veh;															// Kill synced crew members
				_veh setDamage 1;																// Destroy synced vehicles
			} else {
				_x setDamage 1;																	// Kill a synced unit
			};
		} forEach _syncedUnits;
	} else {
		{
			_x setDamage 1;
		} forEach _inf;
		{
			_x setDamage 1;
		} forEach _crew;
		{
			_x setDamage 1;
		} forEach _vehicles;
	};
};

// REMOVE ALL UNITS : REMOVE
if (_wType == "REMOVE") then {
	if (count _syncedUnits > 0) then {
		{
			if (vehicle _x != _x) then {
				_veh = vehicle _x;
				{
					deleteVehicle _x;
				} forEach crew _veh;															// Kill synced crew members
				deleteVehicle _veh;																// Destroy synced vehicles
			} else {
				deleteVehicle _x;																// Kill a synced unit
			};
		} forEach _syncedUnits;
	} else {
		{
			deleteVehicle _x;
		} forEach _inf;
		{
			deleteVehicle _x;
		} forEach _crew;
		{
			deleteVehicle _x;
		} forEach _vehicles;
	};
};

// TARGET SYNCHRONIZED UNIT : TARGET
if (_wType == "TARGET") then {
	if (count _syncedUnits > 0) then {
		_target = _syncedUnits select floor random count _syncedUnits;
		{
			_x commandTarget _target;
		} forEach units _grp;
	};
};

// FIRE SYNCHRONIZED UNIT : FIRE
if (_wType == "FIRE") then {
	if (count _syncedUnits > 0) then {
		_target = _syncedUnits select floor random count _syncedUnits;
		{
			_x commandFire _target;
		} forEach units _grp;
	};
};

// SEND VEHICLES AWAY : SVA
if ((_wType == "SVA") && (count _vehicles > 0) && (count units _grp > 0)) then {
	{
		waitUntil { {_x != vehicle _x} count _inf <= 0 };										// Let the units get out
	} forEach _vehicles;
	_pLocation = getPosASL _originPortal;														// Location of the origin (home) portal
	_vehGrp = createGroup (side (units _grp select 0));											// New group for leaving vehicles
	_crew joinSilent _vehGrp;																	// Crewmen join the group
	_vehWp = _vehGrp addWaypoint [_pLocation,1];												// New destination is the home portal
	_vehWp setWaypointType "MOVE";
	_vehWp setWaypointSpeed "FULL";
	_vehWP setWaypointCompletionRadius 0;
	_vehWP setWaypointStatements ["true", "{ deleteVehicle (vehicle _x); deleteVehicle _x; } forEach thisList;"];
};

// CANCEL FUTHER WAYPOINTS FOR THIS GROUP
if (((_wType == "REMOVE") || (_wType == "KILL")) && (count _syncedUnits <= 0)) exitWith {
	true
};

// SKIP TO THE NEXT WAYPOINT
if ((_wType == "TARGET") || (_wType == "FIRE") || (_wType == "SVA")) exitWith {
	[_pID,_cID,_wID,_grpID,_id] spawn RHNET_ab_waypointFnc;
	true
};

// FINALLY, CREATE THE WAYPOINT ---------------------------------------------------------------------------
_grpWp = _grp addWaypoint [_wLocation,_id];
_grpWp setWaypointType _wType;
_grpWp setWaypointBehaviour _wBehaviour;
_grpWp setWaypointSpeed _wSpeed;
_grpWp setWaypointFormation _wFormation;
_grpWp setWaypointCompletionRadius _wCompletion;
_grpWp setWaypointCombatMode _wMode;
_grpWp setWaypointStatements _wStatement;

// GET IN TO THE GROUP VEHICLE : GETIN
if (_wType == "GETIN") then {
	{
		_x engineOn true;
		if (_x isKindOf "LandVehicle") then {
			doStop _x;
		};
	} forEach _vehicles;
	{
		_x assignAsCargo (_vehicles select 0);
	} forEach _inf;
	_cTime = time;
	waitUntil { (_inf in assignedCargo (_vehicles select 0)) || ((_cTime + 30) < time) };
	{
		if (_x isKindOf "LandVehicle") then {
			_x doMove _wLocation;
		};
	} forEach _vehicles;
};

// FORCE GET IN TO THE GROUP VEHICLE : FORCE
if ((_wType == "FORCE") && (count _vehicles > 0)) then {
	{
		_x assignAsCargo (_vehicles select 0);
		_x moveInCargo (_vehicles select 0);
	} forEach _inf;
};

true