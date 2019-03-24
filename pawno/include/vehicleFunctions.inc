enum e_ParamTypes {
	VEHICLE_TYPE_ENGINE,
	VEHICLE_TYPE_LIGHTS,
 	VEHICLE_TYPE_ALARM,
	VEHICLE_TYPE_DOORS,
	VEHICLE_TYPE_BONNET,
	VEHICLE_TYPE_BOOT,
	VEHICLE_TYPE_OBJECTIVE
};

stock GetVehicleParams(vehicleid, type)
{
	static
	    params[7];

	GetVehicleParamsEx(vehicleid, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
	return (!(params[type] <= 0));
}

stock SetVehicleParams(vehicleid, type, status)
{
	static
	    params[7];

    GetVehicleParamsEx(vehicleid, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
	params[type] = status;
    return SetVehicleParamsEx(vehicleid, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
}

stock GetVehicleBoot(vehicleid, &Float:x, &Float:y, &Float:z)
{
	if (!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
	    return (x = 0.0, y = 0.0, z = 0.0), 0;

	static
	    Float:pos[7]
	;
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
	GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
	GetVehicleZAngle(vehicleid, pos[6]);

	x = pos[3] - (floatsqroot(pos[1] + pos[1]) * floatsin(-pos[6], degrees));
	y = pos[4] - (floatsqroot(pos[1] + pos[1]) * floatcos(-pos[6], degrees));
 	z = pos[5];

	return 1;
}

stock GetVehicleHood(vehicleid, &Float:x, &Float:y, &Float:z)
{
    if (!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
	    return (x = 0.0, y = 0.0, z = 0.0), 0;

	static
	    Float:pos[7]
	;
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
	GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
	GetVehicleZAngle(vehicleid, pos[6]);

	x = pos[3] + (floatsqroot(pos[1] + pos[1]) * floatsin(-pos[6], degrees));
	y = pos[4] + (floatsqroot(pos[1] + pos[1]) * floatcos(-pos[6], degrees));
 	z = pos[5];

	return 1;
}

stock GetVehicleRoof(vehicleid, &Float:x, &Float:y, &Float:z)
{
    if (!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
	    return (x = 0.0, y = 0.0, z = 0.0), 0;

	static
	    Float:pos[6]
	;
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
	GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);

	x = pos[3];
	y = pos[4];
	z = pos[5] + floatsqroot(pos[2]);

	return 1;
}

enum VFUNC_VDATA_ENUM
{
	gVeh_Interior,
	gVeh_Color1,
	gVeh_Color2,
	gVeh_SpawnColor1,
	gVeh_SpawnColor2,
	gVeh_Paintjob
}

new vehicleData[MAX_VEHICLES+1][VFUNC_VDATA_ENUM];

stock CountTotalVehicles()
{
    new count;

    for(new i = 0; i < MAX_VEHICLES; i++)
    {
        if(GetVehicleModel(i) > 0)
        {
            count++;
        }
    }

    return count;
}

/*
        SA-MP "GetVehicleColor 0.3.7" Include by Ryder
        Update version by DarkLouis`
*/
 
#if defined _Included_GetVehicleColor
        #endinput
#endif
 
#define _Included_GetVehicleColor
 
#define PROPERTY_OFFSET(%0) \
        ((((%0) * ((%0) << 1)) << 2) + 65536)
 
stock n_AddStaticVehicle(modelID, Float: spawn_X, Float: spawn_Y, Float: spawn_Z, Float: z_Angle, color1, color2)
{
        if(color1 < -1 || color2 < -1)
        {
                color1 = random(255);
                color2 = random(255);
        }
        modelID = AddStaticVehicle(modelID, spawn_X, spawn_Y, spawn_Z, z_Angle, color1, color2);
       
        new
                colorStr[24]
        ;      
        format(colorStr, sizeof(colorStr), "%d-%d", color1, color2);
        setproperty(_, "", PROPERTY_OFFSET(modelID), colorStr);
		
		vehicleData[modelID][gVeh_Paintjob] = 3;
		vehicleData[modelID][gVeh_Interior] = 0;
       
        return modelID;
}
 
stock n_AddStaticVehicleEx(modelID, Float: spawn_X, Float: spawn_Y, Float: spawn_Z, Float: z_Angle, color1, color2, respawn_Delay, sirena = 0)
{
        if(color1 < -1 || color2 < -1)
        {
                color1 = random(255);
                color2 = random(255);
        }
        modelID = AddStaticVehicleEx(modelID, spawn_X, spawn_Y, spawn_Z, z_Angle, color1, color2, respawn_Delay, sirena);
       
        new
                colorStr[24]
        ;      
        format(colorStr, sizeof(colorStr), "%d-%d", color1, color2);
        setproperty(_, "", PROPERTY_OFFSET(modelID), colorStr);
		
		vehicleData[modelID][gVeh_Paintjob] = 3;
		vehicleData[modelID][gVeh_Interior] = 0;
       
        return modelID;
}
 
stock n_CreateVehicle(modelID, Float: spawn_X, Float: spawn_Y, Float: spawn_Z, Float: z_Angle, color1, color2, respawn_Delay, sirena = 0)
{
        if(color1 < -1 || color2 < -1)
        {
                color1 = random(255);
                color2 = random(255);
        }
        modelID = CreateVehicle(modelID, spawn_X, spawn_Y, spawn_Z, z_Angle, color1, color2, respawn_Delay, sirena);
       
        new
                colorStr[24]
        ;      
        format(colorStr, sizeof(colorStr), "%d-%d", color1, color2);
        setproperty(_, "", PROPERTY_OFFSET(modelID), colorStr);
		
		vehicleData[modelID][gVeh_Paintjob] = 3;
		vehicleData[modelID][gVeh_Interior] = 0;
       
        return modelID;
}
 
stock n_DestroyVehicle(vehicleID)
{
        deleteproperty(_, "", PROPERTY_OFFSET(vehicleID));
       
        return DestroyVehicle(vehicleID);
}
 
stock n_ChangeVehicleColor(vehicleID, color1, color2)
{
        new
                colorStr[24]
        ;      
        format(colorStr, sizeof(colorStr), "%d-%d", color1, color2);
        setproperty(_, "", PROPERTY_OFFSET(vehicleID), colorStr);
       
        return ChangeVehicleColor(vehicleID, color1, color2);
}

stock n_ChangeVehiclePaintjob(vehicleID, color1)
{
        
		vehicleData[vehicleID][gVeh_Paintjob] = color1;
       
        return ChangeVehiclePaintjob(vehicleID, color1);
}

stock n_LinkVehicleToInterior(vehicleID, color1)
{
        
		vehicleData[vehicleID][gVeh_Interior] = color1;
       
        return LinkVehicleToInterior(vehicleID, color1);
}
 
#if defined _ALS_CreateVehicle
    #undef CreateVehicle
#else
    #define _ALS_CreateVehicle
#endif
 
#if defined _ALS_AddStaticVehicle
    #undef AddStaticVehicle
#else
    #define _ALS_AddStaticVehicle
#endif
 
#if defined _ALS_AddStaticVehicleEx
    #undef AddStaticVehicleEx
#else
    #define _ALS_AddStaticVehicleEx
#endif
 
#if defined _ALS_DestroyVehicle
    #undef DestroyVehicle
#else
    #define _ALS_DestroyVehicle
#endif

#if defined _ALS_ChangeVehicleColor
    #undef ChangeVehicleColor
#else
    #define _ALS_ChangeVehicleColor
#endif

#if defined _ALS_ChangeVehiclePaintjob
    #undef ChangeVehiclePaintjob
#else
    #define _ALS_ChangeVehiclePaintjob
#endif

#if defined _ALS_LinkVehicleToInterior
    #undef LinkVehicleToInterior
#else
    #define _ALS_LinkVehicleToInterior
#endif
 
#define AddStaticVehicle n_AddStaticVehicle
#define AddStaticVehicleEx n_AddStaticVehicleEx
#define CreateVehicle n_CreateVehicle
#define DestroyVehicle n_DestroyVehicle
#define ChangeVehicleColor n_ChangeVehicleColor
#define ChangeVehiclePaintjob n_ChangeVehiclePaintjob
#define LinkVehicleToInterior n_LinkVehicleToInterior
 
#define OnVehicleRespray n_OnVehicleRespray
 
forward n_OnVehicleRespray(playerid, vehicleid, color1, color2);

#if !defined GetVehiclePaintjob
stock GetVehiclePaintjob(vehicleid)
{
	if(vehicleid < 1 || vehicleid > MAX_VEHICLES) return 0; // Invalid vehicleid
	return vehicleData[vehicleid][gVeh_Paintjob];
}
#endif

stock GetComponentName(component)
{
	new modname[50];
	switch(component)
	{
	   case 1000: format(modname, sizeof(modname), "Pro Spoiler");
	   case 1001: format(modname, sizeof(modname), "Win Spoiler");
	   case 1002: format(modname, sizeof(modname), "Drag Spoiler");
	   case 1003: format(modname, sizeof(modname), "Alpha Spoiler");
	   case 1004: format(modname, sizeof(modname), "Champ Scoop");
	   case 1005: format(modname, sizeof(modname), "Fury Scoop");
	   case 1006: format(modname, sizeof(modname), "Roof Scoop");
	   case 1007: format(modname, sizeof(modname), "Right Sideskirt");
	   case 1008: format(modname, sizeof(modname), "Nitrous x5");
	   case 1009: format(modname, sizeof(modname), "Nitrous x2");
	   case 1010: format(modname, sizeof(modname), "Nitrous x10");
	   case 1011: format(modname, sizeof(modname), "Race Scoop");
	   case 1012: format(modname, sizeof(modname), "Worx Scoop");
	   case 1013: format(modname, sizeof(modname), "Round Fog Lights");
	   case 1014: format(modname, sizeof(modname), "Champ Spoiler");
	   case 1015: format(modname, sizeof(modname), "Race Spoiler");
	   case 1016: format(modname, sizeof(modname), "Worx Spoiler");
	   case 1017: format(modname, sizeof(modname), "Left Sideskirt");
	   case 1018: format(modname, sizeof(modname), "Upswept Exhaust");
	   case 1019: format(modname, sizeof(modname), "Twin Exhaust");
	   case 1020: format(modname, sizeof(modname), "Large Exhaust");
	   case 1021: format(modname, sizeof(modname), "Medium Exhaust");
	   case 1022: format(modname, sizeof(modname), "Small Exhaust");
	   case 1023: format(modname, sizeof(modname), "Fury Spoiler");
	   case 1024: format(modname, sizeof(modname), "Square Fog Lights");
	   case 1025: format(modname, sizeof(modname), "Offroad Wheels");
	   case 1026, 1036, 1047, 1056, 1069, 1090: format(modname, sizeof(modname), "Right Alien Sideskirt");
	   case 1027, 1040, 1051, 1062, 1071, 1094: format(modname, sizeof(modname), "Left Alien Sideskirt");
	   case 1028, 1034, 1046, 1064, 1065, 1092: format(modname, sizeof(modname), "Alien Exhaust");
	   case 1029, 1037, 1045, 1059, 1066, 1089: format(modname, sizeof(modname), "X-Flow Exhaust");
	   case 1030, 1039, 1048, 1057, 1070, 1095: format(modname, sizeof(modname), "Right X-Flow Sideskirt");
	   case 1031, 1041, 1052, 1063, 1072, 1093: format(modname, sizeof(modname), "Left X-Flow Sideskirt");
	   case 1032, 1038, 1054, 1055, 1067, 1088: format(modname, sizeof(modname), "Alien Roof Vent");
	   case 1033, 1035, 1053, 1061, 1068, 1091: format(modname, sizeof(modname), "X-Flow Roof Vent");
	   case 1042: format(modname, sizeof(modname), "Right Chrome Sideskirt");
	   case 1099: format(modname, sizeof(modname), "Left Chrome Sideskirt");
	   case 1043, 1105, 1114, 1127, 1132, 1135: format(modname, sizeof(modname), "Slamin Exhaust");
	   case 1044, 1104, 1113, 1126, 1129, 1136: format(modname, sizeof(modname), "Chrome Exhaust");
	   case 1050, 1058, 1139, 1146, 1158, 1163: format(modname, sizeof(modname), "X-Flow Spoiler");
	   case 1049, 1060, 1138, 1147, 1162, 1164: format(modname, sizeof(modname), "Alien Spoiler");
	   case 1073: format(modname, sizeof(modname), "Shadow Wheels");
	   case 1074: format(modname, sizeof(modname), "Mega Wheels");
	   case 1075: format(modname, sizeof(modname), "Rimshine Wheels");
	   case 1076: format(modname, sizeof(modname), "Wires Wheels");
	   case 1077: format(modname, sizeof(modname), "Classic Wheels");
	   case 1078: format(modname, sizeof(modname), "Twist Wheels");
	   case 1079: format(modname, sizeof(modname), "Cutter Wheels");
	   case 1080: format(modname, sizeof(modname), "Stitch Wheels");
	   case 1081: format(modname, sizeof(modname), "Grove Wheels");
	   case 1082: format(modname, sizeof(modname), "Import Wheels");
	   case 1083: format(modname, sizeof(modname), "Dollar Wheels");
	   case 1084: format(modname, sizeof(modname), "Trance Wheels");
	   case 1085: format(modname, sizeof(modname), "Atomic Wheels");
	   case 1086: format(modname, sizeof(modname), "Stereo");
	   case 1087: format(modname, sizeof(modname), "Hydraulics");
	   case 1096: format(modname, sizeof(modname), "Ahab Wheels");
	   case 1097: format(modname, sizeof(modname), "Virtual Wheels");
	   case 1098: format(modname, sizeof(modname), "Access Wheels");
	   case 1100: format(modname, sizeof(modname), "Chrome Grill");
	   case 1101: format(modname, sizeof(modname), "Left Chrome Flames Sideskirt");
	   case 1102, 1107: format(modname, sizeof(modname), "Left Chrome Strip Sideskirt");
	   case 1103: format(modname, sizeof(modname), "Convertible Roof");
	   case 1106, 1124: format(modname, sizeof(modname), "Left Chrome Arches Sideskirt");
	   case 1108, 1133, 1134: format(modname, sizeof(modname), "Right Chrome Strip Sideskirt");
	   case 1109: format(modname, sizeof(modname), "Chrome Rear Bullbars");
	   case 1110: format(modname, sizeof(modname), "Slamin Rear Bullbars");
	   case 1111, 1112: format(modname, sizeof(modname), "Front Sign");
	   case 1115: format(modname, sizeof(modname), "Chrome Front Bullbars");
	   case 1116: format(modname, sizeof(modname), "Slamin Front Bullbars");
	   case 1117, 1174, 1179, 1182, 1189, 1191: format(modname, sizeof(modname), "Chrome Front Bumper");
	   case 1175, 1181, 1185, 1188, 1190: format(modname, sizeof(modname), "Slamin Front Bumper");
	   case 1176, 1180, 1184, 1187, 1192: format(modname, sizeof(modname), "Chrome Rear Bumper");
	   case 1177, 1178, 1183, 1186, 1193: format(modname, sizeof(modname), "Slamin Rear Bumper");
	   case 1118: format(modname, sizeof(modname), "Right Chrome Trim Sideskirt");
	   case 1119: format(modname, sizeof(modname), "Right Wheelcovers Sideskirt");
	   case 1120: format(modname, sizeof(modname), "Left Chrome Trim Sideskirt");
	   case 1121: format(modname, sizeof(modname), "Left Wheelcovers Sideskirt");
	   case 1122: format(modname, sizeof(modname), "Right Chrome Flames Sideskirt");
	   case 1123: format(modname, sizeof(modname), "Bullbar Chrome Bars");
	   case 1125: format(modname, sizeof(modname), "Bullbar Chrome Lights");
	   case 1128: format(modname, sizeof(modname), "Vinyl Hardtop Roof");
	   case 1130: format(modname, sizeof(modname), "Hardtop Roof");
	   case 1131: format(modname, sizeof(modname), "Softtop Roof");
	   case 1140, 1148, 1151, 1156, 1161, 1167: format(modname, sizeof(modname), "X-Flow Rear Bumper");
	   case 1141, 1149, 1150, 1154, 1159, 1168: format(modname, sizeof(modname), "Alien Rear Bumper");
	   case 1142: format(modname, sizeof(modname), "Left Oval Vents");
	   case 1143: format(modname, sizeof(modname), "Right Oval Vents");
	   case 1144: format(modname, sizeof(modname), "Left Square Vents");
	   case 1145: format(modname, sizeof(modname), "Right Square Vents");
	   case 1152, 1157, 1165, 1170, 1172, 1173: format(modname, sizeof(modname), "X-Flow Front Bumper");
	   case 1153, 1155, 1160, 1166, 1169, 1171: format(modname, sizeof(modname), "Alien Front Bumper");
	   
	}
	return modname;
}