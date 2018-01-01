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
		class ActionpointDescription: Edit {
			property = "RHNET_ab_moduleAP_F_ActionpointDescription";
			description = "Actionpoints activate synchronized Portals when the given conditions are met. You can restrict Actionpoints with triggers.";
			displayName = "";
			tooltip = "";
			control = "SubCategoryNoHeader2";
			data = "AttributeSystemSubcategory"
		};

		class PlayersAlive: Edit {
			property = "RHNET_ab_moduleAP_F_PlayersAlive";
			displayName = "Minimum players alive";
			tooltip = "How many playable units there must be alive for this actionpoint to activate (0: no limit).";
			typeName = "NUMBER";
			defaultValue = "1";
			control = "EditShort";
		};

		class SafeLock: Edit {
			property = "RHNET_ab_moduleAP_F_SafeLock";
			displayName = "Maximum units alive";
			tooltip = "This actionpoint will not activate if there are more units alive than allowed (-1: no limit).";
			typeName = "NUMBER";
			defaultValue = "128";
			control = "EditShort";
		};

		class ExecutePortals: Combo {
			property = "RHNET_ab_moduleAP_F_ExecutePortals";
			displayName = "Executed Portals";
			tooltip = "How many of the synchronized portals will be activated.";
			typeName = "NUMBER";
			defaultValue = "-1";
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
};
