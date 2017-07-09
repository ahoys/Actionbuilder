#define private		0
#define protected	1
#define public		2

class CfgPatches {
	class RHNET_Actionbuilder {
		units[] = {"RHNET_ab_moduleAP_F","RHNET_ab_modulePORTAL_F","RHNET_ab_moduleWP_F"};
		requiredVersion = 1.72;
		requiredAddons[] = {"A3_Modules_F"};
	};
};

class CfgFactionClasses {
	class NO_CATEGORY;
	class RHNET_Actionbuilder : NO_CATEGORY {
		displayName = "Actionbuilder 1.0.0";
	};
};

class CfgRemoteExec
{
	class Functions {
		mode = 2;
		jip = 0;
		class Actionbuilder_fnc_moduleActionpoint {allowedTargets = 2};
		class Actionbuilder_fnc_modulePortal {allowedTargets = 2};
		class Actionbuilder_fnc_moduleWaypoint {allowedTargets = 2};
	};
};

class CfgFunctions {
	class Actionbuilder {
		class Actionpoint {

			file = "\RHNET\rhnet_actionbuilder\modules\actionpoint";

			class moduleActionpoint {};

		};
		class Portal {

			file = "\RHNET\rhnet_actionbuilder\modules\portal";
			
			class modulePortal {};

			class spawnUnits {};

		};
		class Waypoint {

			file = "\RHNET\rhnet_actionbuilder\modules\waypoint";
			
			class moduleWaypoint {};

			class assignWaypoint {};

			class selectWaypoint {};
			
			class sendVehiclesAway {};

			class loadTransport {};
			
			class unloadVehicles {};

		};
		class Utility {
			
			file = "\RHNET\rhnet_actionbuilder\util";

			class readObjects {};

			class readGroups {};
			
			class getEqualTypes {};
			
			class objectsAhead {};
			
			class deleteSynchronized {};
			
			class getSynchronizedClosest {};
			
			class punish {};
			
			class command {};
			
			class moduleActionpoints {};
			
			class modulePortals {};
			
			class selectRandom {};

			class getSynchronizedOfType {};
			
		};
	};
};

class CfgVehicles {
	class Logic;
	class Module_F: Logic {
		class AttributesBase {
			class Default;
			class Edit;
			class Combo;
			class Checkbox;
			class CheckboxNumber;
			class ModuleDescription;
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