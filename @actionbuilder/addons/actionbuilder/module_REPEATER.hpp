class RHNET_ab_moduleREPEATER_F: Module_F {
	author = "Raunhofer";
	_generalMacro = "RHNET_ab_moduleREPEATER_F";
	scope = public;
	displayName = "Repeater";
	category = "RHNET_Actionbuilder";
	icon = "\RHNET\rhnet_actionbuilder\data\iconREPEATER_ca.paa";
	function = "Actionbuilder_fnc_moduleRepeater";
	isGlobal = 0;
	isTriggerActivated = 1;
	functionPriority = 4;
	isDisposable = 0;

	class Attributes: AttributesBase {
		class RepeaterDescription: Edit {
			property = "RHNET_ab_moduleREPEATER_F_RepeaterDescription";
			description = "Repeaters repeat synchronized Actionpoints. You can restrict Repeaters with triggers.";
			displayName = "";
			tooltip = "";
			control = "SubCategoryNoHeader1";
			data = "AttributeSystemSubcategory"
		};

		class ActivationMethod: Combo {
			property = "RHNET_ab_moduleREPEATER_F_ActivationMethod";
			displayName = "Activated by";
			tooltip = "How is the repeating triggered.";
			typeName = "STRING";
			defaultValue = """VARIABLE""";
			class Values {
				class RP_AT_VARIABLE {
					name = "Boolean variable";
					value = "VARIABLE"
					default = 1;
				};
				class RP_AT_VALUE {
					name = "Value";
					value = "VALUE"
				};
			};
		};

		class BooleanDescription: Edit {
			property = "RHNET_ab_moduleREPEATER_F_BooleanDescription";
			description = "Boolean variable activator activates the repeater when the variable's value is TRUE. If the variable is toggled, the variable will switch to FALSE after a successful repeat.";
			displayName = "";
			tooltip = "";
			control = "SubCategoryNoHeader2";
			data = "AttributeSystemSubcategory"
		};

		class BooleanVariable: Edit {
			property = "RHNET_ab_moduleREPEATER_F_BooleanVariable";
			displayName = "Boolean variable";
			tooltip = "Custom boolean variable to be monitored.";
			typeName = "STRING";
			control = "EditShort";
		};

    class ToggleVariable: Checkbox {
			property = "RHNET_ab_moduleREPEATER_F_ToggleVariable";
			displayName = "Toggle variable";
			tooltip = "If enabled, the boolean variable will be switched to FALSE after a successful execution.";
			typeName = "BOOL";
			defaultValue = "true";
		};

    class ValueDescription: Edit {
			property = "RHNET_ab_moduleREPEATER_F_ValueDescription";
			description = "Value activator activates the repeater when the given condition is TRUE.";
			displayName = "";
			tooltip = "";
			control = "SubCategoryNoHeader1";
			data = "AttributeSystemSubcategory"
		};

    class ValueCondition: Combo {
			property = "RHNET_ab_moduleREPEATER_F_ValueCondition";
			displayName = "Value condition";
			tooltip = "Defines meaning for the Value setting.";
			typeName = "STRING";
			defaultValue = """VARIABLE""";
			class Values {
				class RP_VT_LESSSPAWNEDUNITS {
					name = "Actionpoint unit count is less than Value";
					value = "SPAWNEDUNITS";
					default = 1;
				};
				class RP_VT_LESSUNITS {
					name = "Total unit count is less than Value";
					value = "UNITS"
				};
				class RP_VT_LESSTHANWEST {
					name = "BLUFOR unit count is less than Value";
					value = "WEST"
				};
				class RP_VT_LESSTHANEAST {
					name = "OPFOR unit count is less than Value";
					value = "EAST"
				};
				class RP_VT_LESSTHANINDEPENDENT {
					name = "INDEPENDENT unit count is less than Value";
					value = "INDEPENDENT"
				};
				class RP_VT_LESSTHANCIVILIAN {
					name = "CIVILIAN unit count is less than Value";
					value = "CIVILIAN"
				};
				class RP_VT_MOREPLAYERS {
					name = "Total player count is higher than Value";
					value = "PLAYERS"
				};
			};
		};

		class Value: Edit {
			property = "RHNET_ab_moduleREPEATER_F_Value";
			displayName = "Value";
			tooltip = "Custom value to be monitored.";
			typeName = "NUMBER";
			defaultValue = "1";
			control = "EditShort";
		};

		class IncludeVehicles: Checkbox {
			property = "RHNET_ab_moduleREPEATER_F_IncludeVehicles";
			displayName = "Include vehicles";
			tooltip = "If enabled, vehicles are included to Value.";
			typeName = "BOOL";
			defaultValue = "false";
		};

		class OptionsDescription: Edit {
			property = "RHNET_ab_moduleREPEATER_F_OptionsDescription";
			description = "With the options below you can further adjust this Repeater, no matter which activator is selected.";
			displayName = "";
			tooltip = "";
			control = "SubCategoryNoHeader2";
			data = "AttributeSystemSubcategory"
		};

		class RepeatInterval: Edit {
			property = "RHNET_ab_moduleREPEATER_F_DelayBetweenRepeats";
			displayName = "Repeat interval";
			tooltip = "Delay between repeats in seconds (1: minimum allowed).";
			typeName = "NUMBER";
			defaultValue = "1";
			control = "EditShort";
		};

		class MaximumRepeats: Edit {
			property = "RHNET_ab_moduleREPEATER_F_MaximumRepeats";
			displayName = "Maximum repeats";
			tooltip = "How many times can this repeater trigger (-1: no limit).";
			typeName = "NUMBER";
			defaultValue = "-1";
			control = "EditShort";
		};

		class HighFPS: Checkbox {
			property = "RHNET_ab_moduleREPEATER_F_HighFPS";
			displayName = "Sustain performance";
			tooltip = "If enabled, the execution will halt until the server FPS is higher than 25, otherwise the limit is 15.";
			typeName = "BOOL";
			defaultValue = "true";
		};
	};
};
