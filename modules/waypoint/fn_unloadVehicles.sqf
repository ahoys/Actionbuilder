/*
	File: fn_unloadVehicle.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported
	
	Extension for:
	fn_assignWaypoint.sqf
	
	Description:
	Performs GET OUT special action

	Parameter(s):
	0: ARRAY - target units
	1: BOOL - true to NOT unload the crew too

	Returns:
	NOTHING
*/

private["_group","_all","_notCrew","_vehicle","_out"];

_group = _this select 0;
_notCrew = _this select 1;
_crew = [];

{
	_vehicle = objectParent _x;
	if !(isNull _vehicle) then {
		call {
			if (_notCrew) then {
				if (assignedDriver _vehicle == _x) exitWith {_crew pushBack _x};
				if (assignedGunner _vehicle == _x) exitWith {_crew pushBack _x};
				if (assignedCommander _vehicle == _x) exitWith {_crew pushBack _x};
			};
			unassignVehicle _x;
		};
	};
} forEach units _group;

(units _group - _crew) allowGetIn false;

true