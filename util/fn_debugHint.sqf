/*
	File: fn_debugHint.sqf
	Author: Ari Höysniemi

	Description:
	Prints out the debug message

	Parameter(s):
	0: OBJECT - object with the message
	1: BOOL - true to show the message as a hintSilent
	2: STRING - debug message

	Returns:
	Nothing
*/

private["_obj","_show","_msg"];
_obj		= _this select 0;
_show		= _this select 1;
_msg		= _this select 2;

if (isNull _obj) then {_obj = "(MODULE DELETED)"};

if (_show) then {
	hintSilent format ["ACTIONBUILDER DEBUG\n\n- module -\n%1\n\n- message -\n%2", _obj, _msg];
};

true