class RHNET_ab_moduleAP_F: Module_F {
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

	class Attributes: AttributesBase {
		class PlayersAlive: Edit {
			property = "RHNET_ab_moduleAP_F_PlayersAlive";
			displayName = "Players alive";
			tooltip = "How many playable units there must be alive for this actionpoint to work (0 - no limit).";
			typeName = "NUMBER";
			defaultValue = 1;
			control = "EditShort";
		};

		class SafeLock: Edit {
			property = "RHNET_ab_moduleAP_F_SafeLock";
			displayName = "Total unit limit";
			tooltip = "The actionpoint will not activate if there are more units alive than allowed (-1 - 1024).";
			typeName = "NUMBER";
			defaultValue = 128;
			control = "EditShort";
		};

		class ExecutePortals: Combo {
			property = "RHNET_ab_moduleAP_F_ExecutePortals";
			displayName = "Executed Portals";
			tooltip = "How many of the synchronized portals will be activated.";
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

		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription {
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