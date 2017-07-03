class RHNET_ab_moduleAP_F : Module_F
{
	author = "Raunhofer";
	_generalMacro = "RHNET_ab_moduleAP_F";
	scope = public;
	displayName = "Actionpoint";
	category = "RHNET_Actionbuilder";
	icon = "\RHNET\rhnet_actionbuilder\data\iconAP_ca.paa";
	function = "Actionbuilder_fnc_moduleActionpoint";
	isGlobal = 0;
	isTriggerActivated = 0;
	functionPriority = 2;
	isDisposable = 0;

	class Arguments {
		class PartyType {
			displayName = "Present";
			description = "Type of unit that must be present for this actionpoint to activate.";
			typeName = "STRING";
			class Values {
				class AP_ANY {
					name = "Anything";
					value = "Any";
				};
				class AP_LAND {
					name = "Ground units";
					value = "Land";
					default = 1;
				};
				class AP_MAN {
					name = "Infantry";
					value = "Man";
				};
				class AP_CAR {
					name = "Car";
					value = "Car";
				};
				class AP_TANK {
					name = "Armored";
					value = "Tank";
				};
				class AP_AIR {
					name = "Aircraft";
					value = "Air";
				};
				class AP_SHIP {
					name = "Ship";
					value = "Ship";
				};
			};
		};
		
		class PlayersAlive {
			displayName = "Players alive";
			description = "How many playable units there must be alive for this actionpoint to work.";
			typeName = "NUMBER";
			defaultValue = 0;
		};
		
		class Safelock {
			displayName = "Maximum unit count";
			description = "The actionpoint will not activate if there are more units alive than allowed.";
			typeName = "NUMBER";
			class Values {
				class AP_SAFELOCK8 {
					name = "8";
					value = 8;
				};
				class AP_SAFELOCK16 {
					name = "16";
					value = 16;
				};
				class AP_SAFELOCK32 {
					name = "32";
					value = 32;
				};
				class AP_SAFELOCK48 {
					name = "48";
					value = 48;
				};
				class AP_SAFELOCK64 {
					name = "64";
					value = 64;
				};
				class AP_SAFELOCK96 {
					name = "96";
					value = 96;
				};
				class AP_SAFELOCK128 {
					name = "128";
					value = 128;
					default = 1;
				};
				class AP_SAFELOCK160 {
					name = "160";
					value = 160;
				};
				class AP_SAFELOCK192 {
					name = "192";
					value = 192;
				};
				class AP_SAFELOCK256HC {
					name = "256 (HC-required)";
					value = 256;
				};
				class AP_SAFELOCK384HC {
					name = "384 (HC-required)";
					value = 384;
				};
				class AP_SAFELOCK512HC {
					name = "512 (HC-required)";
					value = 512;
				};
				class AP_SAFELOCK768HC {
					name = "768 (HC-required)";
					value = 768;
				};
				class AP_SAFELOCK1024HC {
					name = "1024 units allowed (HC-required)";
					value = 1024;
				};
			};
		};
		
		class ExecutePortals {
			displayName = "Executed portals";
			description = "How many of the synchronized portals will be activated.";
			typeName = "NUMBER";
			class Values {
				class AP_EXECUTEALL {
					name = "All";
					value = -1;
					default = 1;
				};
				class AP_EXECUTESOME {
					name = "Some";
					value = 0;
				};
				class AP_EXECUTE1 {
					name = "Random 1";
					value = 1;
				};
				class AP_EXECUTE2 {
					name = "Random 2";
					value = 2;
				};
				class AP_EXECUTE3 {
					name = "Random 3";
					value = 3;
				};
				class AP_EXECUTE4 {
					name = "Random 4";
					value = 4;
				};
				class AP_EXECUTE5 {
					name = "Random 5";
					value = 5;
				};
				class AP_EXECUTE6 {
					name = "Random 6";
					value = 6;
				};
				class AP_EXECUTE7 {
					name = "Random 7";
					value = 7;
				};
				class AP_EXECUTE8 {
					name = "Random 8";
					value = 8;
				};
				class AP_EXECUTE9 {
					name = "Random 9";
					value = 9;
				};
			};
		};
	};

	class ModuleDescription : ModuleDescription {
		description = "Actionpoint controls the synchronized portals.";
		sync[] = {"EmptyDetector","RHNET_ab_modulePORTAL_F"};

		class RHNET_ab_modulePORTAL_F {
			description = "There can be multiple portals synchronized.";
			position = 1;
			direction = 1;
			duplicate = 1;
		};
	};
};