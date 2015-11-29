class RHNET_ab_moduleAP_F : Module_F
{
	author = "Raunhofer";
	_generalMacro = "RHNET_ab_moduleAP_F";
	scope = public;
	displayName = "Actionpoint";
	category = "RHNET_Actionbuilder";
	icon = "\RHNET\rhnet_actionbuilder\data\iconAP_ca.paa";
	function = "Actionbuilder_fnc_moduleActionpoint";
	isGlobal = 1;
	isTriggerActivated = 0;
	functionPriority = 2;

	class Arguments {
		class PartyType {
			displayName = "Present";
			description = "What must be present to get the actionpoint triggered";
			typeName = "STRING";
			class Values {
				class ap_any {
					name = "Anything";
					value = "Any";
				};
				class ap_ground {
					name = "Ground units";
					value = "Land";
					default = 1;
				};
				class ap_inf {
					name = "Infantry";
					value = "Man";
				};
				class ap_car {
					name = "Car";
					value = "Car";
				};
				class ap_tank {
					name = "Armored";
					value = "Tank";
				};
				class ap_air {
					name = "Aircraft";
					value = "Air";
				};
				class ap_ship {
					name = "Ship";
					value = "Ship";
				};
			};
		};
		
		class UnitsAlive {
			displayName = "Players Alive";
			description = "How many playable units there must be alive, to get the actionpoint triggered";
			typeName = "NUMBER";
			class Values {
				class playables_0 {
					name = "Doesn't matter";
					value = 0;
					default = 1;
				};
				class playables_2 {
					name = "2 must be alive";
					value = 2;
				};
				class playables_4 {
					name = "4 must be alive";
					value = 4;
				};
				class playables_8 {
					name = "8 must be alive";
					value = 8;
				};
				class playables_12 {
					name = "12 must be alive";
					value = 12;
				};
				class playables_16 {
					name = "16 must be alive";
					value = 16;
				};
				class playables_24 {
					name = "24 must be alive";
					value = 24;
				};
				class playables_32 {
					name = "32 must be alive";
					value = 32;
				};
				class playables_48 {
					name = "48 must be alive";
					value = 48;
				};
				class playables_64 {
					name = "64 must be alive";
					value = 64;
				};
			};
		};
		
		class Safelock {
			displayName = "Safelock";
			description = "If there are more units overall than allowed, the actionpoint will not activate";
			typeName = "NUMBER";
			class Values {
				class safe_32 {
					name = "32 units allowed";
					value = 32;
				};
				class safe_64 {
					name = "64 units allowed";
					value = 64;
				};
				class safe_128 {
					name = "128 units allowed";
					value = 128;
				};
				class safe_192 {
					name = "192 units allowed";
					value = 192;
					default = 1;
				};
				class safe_256 {
					name = "256 units allowed (HC-required)";
					value = 256;
				};
				class safe_384 {
					name = "384 units allowed (HC-required)";
					value = 384;
				};
				class safe_512 {
					name = "512 units allowed (HC-required)";
					value = 512;
				};
				class safe_768 {
					name = "768 units allowed (HC-required)";
					value = 768;
				};
				class safe_1024 {
					name = "1024 units allowed (HC-required)";
					value = 1024;
				};
				class safe_2048 {
					name = "2048 units allowed (HC-required)";
					value = 2048;
				};
			};
		};
		
		class ExecutePortals {
			displayName = "Executed portals";
			description = "How many randomly selected portals to execute after an actionpoint event";
			typeName = "NUMBER";
			class Values {
				class eport0 {
					name = "All";
					value = -1;
					default = 1;
				};
				class eport1 {
					name = "Some";
					value = 0;
				};
				class eport2 {
					name = "Random 1";
					value = 1;
				};
				class eport3 {
					name = "Random 2";
					value = 2;
				};
				class eport4 {
					name = "Random 3";
					value = 3;
				};
				class eport5 {
					name = "Random 4";
					value = 4;
				};
				class eport6 {
					name = "Random 5";
					value = 5;
				};
				class eport7 {
					name = "Random 6";
					value = 6;
				};
				class eport8 {
					name = "Random 7";
					value = 7;
				};
				class eport9 {
					name = "Random 8";
					value = 8;
				};
				class eport10 {
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
			description = "All connected portals will be activated.";
			position = 1;
			direction = 1;
			duplicate = 1;
		};
	};
};