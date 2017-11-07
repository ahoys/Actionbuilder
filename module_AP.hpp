class RHNET_ab_moduleAP_F: Module_F {
	author = "Raunhofer";
	_generalMacro = "RHNET_ab_moduleAP_F";
	scope = public;
	displayName = "Actionpoint";
	category = "RHNET_Actionbuilder";
	icon = "\RHNET\rhnet_actionbuilder\data\iconAP_ca.paa";
	function = "Actionbuilder_fnc_moduleActionpoint";
	isGlobal = 0;
	isTriggerActivated = 1;
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

		class ExecutePortals: Edit {
			property = "RHNET_ab_moduleAP_F_ExecutePortals";
			displayName = "Executed Portals";
			tooltip = "How many of the synchronized portals will be activated.";
			typeName = "NUMBER";
			defaultValue = -1;
			control = "EditShort";
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