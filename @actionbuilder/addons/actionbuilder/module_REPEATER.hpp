class RHNET_ab_moduleREPEATER_F: Module_F {
	author = "Raunhofer";
	_generalMacro = "RHNET_ab_moduleREPEATER_F";
	scope = public;
	displayName = "Repeater";
	category = "RHNET_Actionbuilder";
	icon = "\RHNET\rhnet_actionbuilder\data\iconAP_ca.paa";
	function = "Actionbuilder_fnc_moduleRepeater";
	isGlobal = 0;
	isTriggerActivated = 1;
	functionPriority = 4;
	isDisposable = 0;

	class Attributes: AttributesBase {
		class ActivationType: Combo {
			property = "RHNET_ab_moduleREPEATER_F_ActivationType";
			displayName = "Activated by";
			tooltip = "How is the repeating triggered.";
			typeName = "STRING";
			defaultValue = """VARIABLE""";
			class Values {
				class RP_AT_BOOLEAN {
					name = "Boolean Variable";
					value = "BOOLEAN"
					default = 1;
				};
				class RP_AT_MIN_UNITCOUNT {
					name = "Total unit count less than Value";
					value = "MINUNITCOUNT";
				};
				class RP_AT_MAX_PLAYERCOUNT {
					name = "Total player count more than Value";
					value = "MAXPLAYERCOUNT";
				};
			};
		};

        class CustomVariable: Edit {
			property = "RHNET_ab_moduleREPEATER_F_CustomVariable";
			displayName = "Variable";
			tooltip = "Variable to be monitored.";
			typeName = "STRING";
			control = "EditShort";
		};

        class CustomValue: Edit {
			property = "RHNET_ab_moduleREPEATER_F_CustomValue";
			displayName = "Value";
			tooltip = "Value to be monitored.";
			typeName = "NUMBER";
			control = "EditShort";
		};

		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription {
		description = "Repeater controls Actionpoint repeating.";
		sync[] = {"EmptyDetector","RHNET_ab_moduleAP_F"};

		class RHNET_ab_moduleAP_F {
			description = "There can be multiple Actionpoints synchronized.";
			position = 0;
			direction = 0;
			duplicate = 1;
		};
	};
};