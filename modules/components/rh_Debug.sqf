/*

	Author: Raunhofer
	Last Update: d23/m11/y15
	Build: 1
	
	Title: DEBUG TOOL
	Description: Print out hints of actionpoints' inner workings
	
	Duty: If debug is enabled, print out what happens inside the actionpoint

*/

// --- Initialize debug ----------------------------------------------------------------------------------
_mod	= _this select 0;
_state	= _this select 1;
_msg	= _this select 2;

// --- Print message -------------------------------------------------------------------------------------

if (isNil "_mod") then {_mod = "(MODULE DELETED)"};

if (_state == 1) then {
	hintSilent format ["ACTIONBUILDER DEBUG\n\n- module -\n%1\n\n- message -\n%2", _mod, _msg];
};