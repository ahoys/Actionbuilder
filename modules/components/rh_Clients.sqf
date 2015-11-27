/*

	Author: Raunhofer
	Last Update: d12/m07/y15
	Build: 4
	
	Title: HEADLESS CLIENT REGISTERATION
	Description: Detect support for using a headless client
	
	Duty: If clients are found, switch actionbuilder to be ran on these clients

*/

// --- Initialize headless client threads -------------------------------------------------------------------------
RHNET_ab_clients	= [];
_threadCandidate 	= "ab_headlessclient0";
_i 					= 0;

// --- Register available clients ---------------------------------------------------------------------------------
while {!isNil _threadCandidate && isMultiplayer} do {
	RHNET_ab_clients set [_i, _threadCandidate];
	_i = _i + 1;
	_threadCandidate = format ["ab_headlessclient%1", _i];			// Register every headless client available
};
publicVariable "RHNET_ab_clients";