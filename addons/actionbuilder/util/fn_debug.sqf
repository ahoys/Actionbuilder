/*
	File: fn_debug.sqf
	Author: Ari Höysniemi

	Description:
	Prints out debugging information if the debugging is enabled.

	Parameter(s):
	0: STRING - type
	1: OBJECT - parent
	2: STRING - debug message

	Returns:
	BOOL - true, if success
*/

private _type = param [0, "", [""]];
private _parent = param [1, objNull, [objNull]];
private _msg = param [2, "", [""]];
private _result = false;

if (RHNET_AB_L_DEBUG) then {
	diag_log format [
		"Actionbuilder, %1, %2: %3",
		_type,
		_parent,
		_msg
	];
	hintSilent format [
		"ACTIONBUILDER\nDEBUG\n\n%1:\n%2\n\nMessage:\n%3",
		_type,
		_parent,
		_msg
	];
	_result = true;
};

_result