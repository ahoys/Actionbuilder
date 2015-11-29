#define private		0
#define protected	1
#define public		2

class CfgPatches {
	class RHNET_Actionbuilder {
		units[] = {"RHNET_ab_moduleAP_F","RHNET_ab_modulePORTAL_F","RHNET_ab_moduleWP_F"};
		requiredVersion = 1.50;
		requiredAddons[] = {"A3_Modules_F"};
	};
};

class CfgFactionClasses {
	class NO_CATEGORY;
	class RHNET_Actionbuilder : NO_CATEGORY {
		displayName = "Actionbuilder EE1.29.1";
	};
};

class CfgFunctions {
	class Actionbuilder {
		class Modules {

			file = "\RHNET\rhnet_actionbuilder\modules";

			class moduleActionpoint {};

			class modulePortal {};

			class moduleWaypoint {};

		};
		class Components {
			
			file = "\RHNET\rhnet_actionbuilder\components";
			
			class spawnUnits {};
			
			class transmit {};
			
			class assignWp {};
			
		}
		class Utility {
			
			file = "\RHNET\rhnet_actionbuilder\util";
			
			class debugHint {};
			
			class listClients {};
			
			class objectsAhead {};
			
			class getSynchronized {};
			
			class removeSynchronized {};
			
		};
	};
};

class CfgVehicles {
	class Logic;
	class Module_F: Logic {
		class ArgumentsBaseUnits {
			class Units;
		};
		class ModuleDescription {
			class EmptyDetector;
		};
	};

	#include "module_AP.hpp"

	#include "module_PORTAL.hpp"

	#include "module_WP.hpp"

};