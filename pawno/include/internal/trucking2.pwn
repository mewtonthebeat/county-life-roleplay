/*

	DEFINES

*/
#define     Trucking:: trc_
#define     MAX_DEPOTS          100
#define     MAX_DEPOT_CAPACITY  10000   // maximalny pocet jednotiek
/*

	ARRAYS, ENUMS
	
*/

enum {
	STATION_BLUEBERRY_MAIN = 1,
}

new Trucking::StationNames[][] = {
	"null",
	"HlavnÈ prekladisko Blueberry"
};

new Trucking::TrailerParkingSpots[][] = {
	{STATION_BLUEBERRY_MAIN, float:-66.5026,float:-377.3864,float:6.0358,float:359.5154},
	{STATION_BLUEBERRY_MAIN, float:-56.5563,float:-377.5258,float:6.0356,float:359.9365},
	{STATION_BLUEBERRY_MAIN, float:-36.3698,float:-377.4768,float:6.0360,float:358.6559},
	{STATION_BLUEBERRY_MAIN, float:-49.6976,float:-377.3524,float:6.0356,float:359.2776},
	{STATION_BLUEBERRY_MAIN, float:-26.4182,float:-377.4696,float:6.0353,float:359.0201},
	{STATION_BLUEBERRY_MAIN, float:-19.7652,float:-377.4569,float:6.0359,float:359.8998},
	{STATION_BLUEBERRY_MAIN, float:-39.8490, float:-375.7612, float:5.1358, float:0.1339},
	{STATION_BLUEBERRY_MAIN, float:-46.5225, float:-375.6342, float:5.1215, float:359.6612},
	{STATION_BLUEBERRY_MAIN, float:-13.0386,float:-377.1127,float:6.0362,float:359.7382}
};

new Trucking::Trailer2ParkingSpots[][] = {
	{STATION_BLUEBERRY_MAIN, float:-23.1701,float:-278.2354,float:6.0357,float:180.0612},
	{STATION_BLUEBERRY_MAIN, float:-14.4569,float:-277.9235,float:6.0365,float:181.4503},
	{STATION_BLUEBERRY_MAIN, float:-88.4218,float:-319.9919,float:2.0367,float:179.5640},
	{STATION_BLUEBERRY_MAIN, float:-116.4801,float:-327.6247,float:2.0362,float:178.9106}
};

////////////////////////////////////////////////////////////////////////////////

enum {
	TRANSPORT_TYPE_FOOD = 1,              	//potraviny
	TRANSPORT_TYPE_MEAT,                    //maso
	TRANSPORT_TYPE_CLOTHING,                //obleceni
	TRANSPORT_TYPE_WEAPONS,                 //zbrane
	TRANSPORT_TYPE_VEHICLE_PARTS,           //soucastky vozidel/tuning
	TRANSPORT_TYPE_ELECTRONICS,             //elektronika
	TRANSPORT_TYPE_FURNITURE,               //n·bytek
	TRANSPORT_TYPE_ALCOHOL,                	//alkohol
	TRANSPORT_TYPE_SUGAR_DRINK,             //sladenÈ n·poje
	TRANSPORT_TYPE_TOBACCO,                 //tabakove vyrobky
	TRANSPORT_TYPE_FUEL,                    //palivo
	
	// special deliveries
	
	TRANSPORT_TYPE_VEHICLES,                //vozidl·
	TRANSPORT_TYPE_WOOD,                    //drevo
	TRANSPORT_TYPE_MONEY,                   //peniaze
	TRANSPORT_TYPE_ROCKS,                   //kamene atd
	TRANSPORT_TYPE_CONCRETE,                //cement
}

enum depotEnum()
{
	depot_Type,
	Float:depot_X, Float:depot_Y, Float:depot_Z,
	depot_Loaded,    // kolko jednotiek je na sklade
	depot_UnloadingOnly,
	
	Text3D:depot_Label
}

enum truckWorkPlayerEnum()
{
	tworkp_Type,
	tworkp_StartUnix,
	tworkp_ToUnix,
	tworkp_VehicleId
}

enum truckWorkVehicleEnum()
{
	tworkv_Type,
	tworkv_Loaded,
	tworkv_Capacity,
	tworkv_TrailerId,
	
	tworkv_State,
	
	tworkv_StartId,
	tworkv_FinishId
}

new Trucking::Depot[MAX_DEPOTS][depotEnum];
new Trucking::gWorkType[MAX_PLAYERS];
new Trucking::gWorkEnum[MAX_PLAYERS][truckWorkPlayerEnum];
new Trucking::vWorkEnum[MAX_VEHICLES][truckWorkVehicleEnum];
new bool:gPlayerEnded[MAX_PLAYERS];

new Trucking::TransportTypeData[][] = {
	// n·zov, level, min payday, max payday
	{0, 0, 0},
	{1, 	645, 		1790},
	{1,    	670,        1820},
	{1,    	650,        1915},
	{75,	1070,		2415},
	{30,   	890,        2790},
	{30,   	975,        2450},
	{30,   	920,        2645},
	{15,   	850,        2150},
	{5,     750,        1995},
	{15,   	890,        2150},
	{1,    	0,          0},         // nem· odmeny pretoûe sa platÌ na benzÌnke za to koæko paliva doruËÌ

	// special deliveries

	{75,     1290,       3090},
	{50,     1070,       2745},
	{100,    1890,       3450},
	{75,     1290,       3090},
	{75, 	1290,       3090}
};

new Trucking::TransportDepots[][] = {
	// ZERO OR 1 MEANS IF ITS UNLOADING ONLY
	{TRANSPORT_TYPE_FOOD, 0, float:-2098.695, float:-2248.652, float:30.625},  			// Angel Pine #1
	{TRANSPORT_TYPE_MEAT, 0, float:-2095.498, float:-2244.848, float:30.625}, 			// Angel Pine #1
	{TRANSPORT_TYPE_SUGAR_DRINK, 0, float:-2092.299, float:-2240.640, float:30.856},   	// Angel Pine #1
	{TRANSPORT_TYPE_ALCOHOL, 0, float:-2093.831, float:-2262.180, float:30.625},   		// Angel Pine #1
	{TRANSPORT_TYPE_TOBACCO, 0, float:-2078.385, float:-2274.423, float:30.625},   		// Angel Pine #1
	
	////////////////////////////////////////////////////////////////////////////
	
	{TRANSPORT_TYPE_CLOTHING, 0, float:-2099.096, float:-2278.249, float:30.625},  		// Angel Pine #2
	{TRANSPORT_TYPE_ELECTRONICS, 0, float:-2095.201, float:-2281.300, float:30.625},   	// Angel Pine #2
	{TRANSPORT_TYPE_FURNITURE, 0, float:-2091.130, float:-2284.489, float:30.625}, 		// Angel Pine #2
	{TRANSPORT_TYPE_VEHICLE_PARTS, 0, float:-2089.853, float:-2296.527, float:30.625}, 	// Angel Pine #2
	{TRANSPORT_TYPE_TOBACCO, 0, float:-2111.364, float:-2279.247, float:30.631},   		// Angel Pine #2
	{TRANSPORT_TYPE_WEAPONS, 0, float:-2123.756, float:-2294.730, float:30.631},  		// Angel Pine #2
	
	////////////////////////////////////////////////////////////////////////////
	
	{TRANSPORT_TYPE_FUEL, 1, float:-2006.169, float:-2349.552, float:30.625},   // Angel Pine Air Port
	
	////////////////////////////////////////////////////////////////////////////
	
	{TRANSPORT_TYPE_VEHICLE_PARTS, 0, float:-1912.891, float:-1712.200, float:21.750},	// Angel Pine Junkyard
	{TRANSPORT_TYPE_VEHICLES, 0, float:-1897.619, float:-1704.782, float:21.756},		// Angel Pine Junkyard
	
	{TRANSPORT_TYPE_FUEL, 0, float:-2125.089, float:-261.565, float:35.320}, 	// Doherty
	
	////////////////////////////////////////////////////////////////////////////
	
	{TRANSPORT_TYPE_FOOD, 0, float:-1820.046, float:-179.5, float:9.398},   		// Doherty RS Haul
	{TRANSPORT_TYPE_MEAT, 0, float:-1820.046, float:-169.027, float:9.39},  		// Doherty RS Haul
	{TRANSPORT_TYPE_SUGAR_DRINK, 0, float:-1819.247, float:-153.792, float:9.4},    // Doherty RS Haul
	
	////////////////////////////////////////////////////////////////////////////
	
	{TRANSPORT_TYPE_ALCOHOL, 0, float:-1834.397, float:-109.698, float:5.648},  // Doherty SFB Krabice
	{TRANSPORT_TYPE_TOBACCO, 0, float:-1824.659, float:-109.458, float:5.648},  // Doherty SFB Krabice
	{TRANSPORT_TYPE_CLOTHING, 0, float:-1815.821, float:-109.330, float:5.648}, // Doherty SFB Krabice
	
	////////////////////////////////////////////////////////////////////////////
	
	{TRANSPORT_TYPE_ELECTRONICS, 0, float:-1721.170, float:-123.979, float:3.548},  	// Doherty Pristav
	{TRANSPORT_TYPE_FURNITURE, 0, float:-1725.468, float:-119.356, float:3.548},    	// Doherty Pristav
	{TRANSPORT_TYPE_VEHICLE_PARTS, 0, float:-1729.382, float:-115.491, float:3.554},    // Doherty Pristav
	{TRANSPORT_TYPE_WEAPONS, 0, float:-1698.6, float:-94.526, float:3.549},             // Doherty Pristav
	{TRANSPORT_TYPE_VEHICLES, 0, float:-1585.69, float:114.194, float:3.549},         	// Doherty Pristav Lod
	
	
	////////////////////////////////////////////////////////////////////////////
	
	{TRANSPORT_TYPE_VEHICLE_PARTS, 0, float:250.0, float:28.9, float:2.5}, 		// Blueberry Vehicle Parts
	
	////////////////////////////////////////////////////////////////////////////
	
	{TRANSPORT_TYPE_MEAT, 0, float:1586.781, float:682.806, float:10.82},   	// Las Venturas Montgomery
	{TRANSPORT_TYPE_FOOD, 0, float:1586.78, float:688.084, float:10.82},    	// Las Venturas Montgomery
	{TRANSPORT_TYPE_SUGAR_DRINK, 0, float:1586.78, float:750.8, float:10.82},   // Las Venturas Montgomery
	{TRANSPORT_TYPE_FOOD, 0, float:1586.78, float:757.85, float:10.82},         // Las Venturas Montgomery
	{TRANSPORT_TYPE_MEAT, 0, float:1600.853, float:711.427, float:10.82},       // Las Venturas Montgomery
	{TRANSPORT_TYPE_FOOD, 0, float:1609.418, float:711.427, float:10.82},       // Las Venturas Montgomery
	{TRANSPORT_TYPE_FOOD, 0, float:1610.997, float:729.437, float:10.82},       // Las Venturas Montgomery
	{TRANSPORT_TYPE_SUGAR_DRINK, 0, float:1602.399, float:729.43, float:10.82}, // Las Venturas Montgomery
	
	{TRANSPORT_TYPE_CLOTHING, 0, float:1659.711, float:711.76, float:10.82},    // Las Venturas Montgomery
	{TRANSPORT_TYPE_TOBACCO, 0, float:1668.212, float:711.76, float:10.82},     // Las Venturas Montgomery
	{TRANSPORT_TYPE_ALCOHOL, 0, float:1660.147, float:728.644, float:10.82},    // Las Venturas Montgomery
	{TRANSPORT_TYPE_ELECTRONICS, 0, float:1668.439, float:728.64, float:10.82}, // Las Venturas Montgomery
	
	{TRANSPORT_TYPE_FURNITURE, 0, float:1723.644, float:712.65, float:10.82},   // Las Venturas Montgomery
	{TRANSPORT_TYPE_VEHICLE_PARTS, 0, float:1725.651, float:729.291, float:10.82},  // Las Venturas Montgomery
	
	////////////////////////////////////////////////////////////////////////////
	
	{TRANSPORT_TYPE_FOOD, 0, float:1703.350, float:939.777, float:10.82},        // LVA Freight Depot
	{TRANSPORT_TYPE_MEAT, 0, float:1703.35, float:961.150, float:10.82},        // LVA Freight Depot

	{TRANSPORT_TYPE_CLOTHING, 0, float:1703.35, float:998.249, float:10.82},    // LVA Freight Depot
	
	{TRANSPORT_TYPE_ALCOHOL, 0, float:1642.043, float:1069.077, float:10.82},  	// LVA Freight Depot
	{TRANSPORT_TYPE_TOBACCO, 0, float:1624.954, float:1069.077, float:10.82},   // LVA Freight Depot
	{TRANSPORT_TYPE_SUGAR_DRINK,0,float:1601.032, float:1069.07, float:10.82},  // LVA Freight Depot
	
	{TRANSPORT_TYPE_ELECTRONICS,0,float:1634.676, float:982.744, float:10.82},  // LVA Freight Depot
	{TRANSPORT_TYPE_FURNITURE,0,float:1634.676, float:961.54, float:10.8},      // LVA Freight Depot
	
	{TRANSPORT_TYPE_VEHICLE_PARTS,0,float:1629.004, float:1022.374, float:10.82},   // LVA Freight Depot
	
	////////////////////////////////////////////////////////////////////////////
	
	{TRANSPORT_TYPE_FOOD, 0, float:571.717, float:1217.276, float:11.83},   // BONE COUNTY FACTORY
	{TRANSPORT_TYPE_MEAT, 0, float:578.39, float:1221.523, float:11.71}    	// BONE COUNTY FACTORY
};

new Trucking::TransportTypeDataN[][] = {
	// n·zov, level, min payday, max payday
	{""},
	{"Potraviny"},
	{"M‰so"},
	{"ObleËenie"},
	{"Zbrane, strelivo"},
	{"Auto-s˙Ëiastky"},
	{"Elektronika"},
	{"N·bytok"},
	{"Alkohol"},
	{"SladenÈ n·poje"},
	{"Tabak"},
	{"Palivo"},         // nem· odmeny pretoûe sa platÌ na benzÌnke za to koæko paliva doruËÌ

	// special deliveries

	{"Vozidl·"},
	{"Drevo"},
	{"Peniaze"},
	{"Kamene, suroviny"},
	{"Cement"}
};

/*

	FUNCTIONS
	
*/
new Trucking::glastveh[MAX_PLAYERS];
function trucker_OnPlayerStateChange(playerid, newstate, oldstate)
{

	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
	{
	
	    Trucking::glastveh[playerid] = GetPlayerVehicleID(playerid);

		if(Trucking::vWorkEnum[Trucking::glastveh[playerid]][tworkv_State] == 1)
		{
		    if(Trucking::gWorkEnum[playerid][tworkp_VehicleId] != Trucking::glastveh[playerid])
		        return SendError(playerid, "Toto nie je tvoj ùahaË!!!");
		
		    new
		        Float:lX, Float:lY, Float:lZ
			;

			lX = Float:Trucking::TransportDepots[ Trucking::vWorkEnum[Trucking::glastveh[playerid]][tworkv_StartId] ][2];
			lY = Float:Trucking::TransportDepots[ Trucking::vWorkEnum[Trucking::glastveh[playerid]][tworkv_StartId] ][3];
			lZ = Float:Trucking::TransportDepots[ Trucking::vWorkEnum[Trucking::glastveh[playerid]][tworkv_StartId] ][4];

			SetPlayerCheckpoint(playerid, lX, lY, lZ, 3.0);
			
			g_I_playerCheckpoint[playerid] = checkp_prepravka;
			
			SCFM(playerid, COLOR_GREEN, "[ROUTE ADVISOR v11.5.4.132]; {FFFFFF}Navigujem ùa do prvÈho skladu! Nezabudni zah·knuù n·ves!");
			
			PlayerTextDrawShow(playerid, PTD_timeleft[playerid]);
		}
		else if(Trucking::vWorkEnum[Trucking::glastveh[playerid]][tworkv_State] == 3)
		{
		    if(Trucking::gWorkEnum[playerid][tworkp_VehicleId] != Trucking::glastveh[playerid])
		        return SendError(playerid, "Toto nie je tvoj ùahaË!!!");
		
		    new
		        Float:lX, Float:lY, Float:lZ
			;

			lX = Float:Trucking::TransportDepots[ Trucking::vWorkEnum[Trucking::glastveh[playerid]][tworkv_FinishId] ][2];
			lY = Float:Trucking::TransportDepots[ Trucking::vWorkEnum[Trucking::glastveh[playerid]][tworkv_FinishId] ][3];
			lZ = Float:Trucking::TransportDepots[ Trucking::vWorkEnum[Trucking::glastveh[playerid]][tworkv_FinishId] ][4];

			SetPlayerCheckpoint(playerid, lX, lY, lZ, 3.0);
			
			g_I_playerCheckpoint[playerid] = checkp_prepravka;
			
			SCFM(playerid, COLOR_GREEN, "[ROUTE ADVISOR v11.5.4.134]; {FFFFFF}Navigujem ùa do v˝kladiska! Nepoökr·b n·klad!");
			
			PlayerTextDrawShow(playerid, PTD_timeleft[playerid]);
		}
	}
	else if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER)
	{
	    PlayerTextDrawHide(playerid, PTD_timeleft[playerid]);
		if(Trucking::vWorkEnum[Trucking::glastveh[playerid]][tworkv_State] != 0)
		{
		    DisablePlayerCheckpoint(playerid);
		    g_I_playerCheckpoint[playerid] = checkp_none;
		}
	}
	
	if(oldstate == PLAYER_STATE_DRIVER && gPlayerEnded[playerid] == true)
	{
	    gPlayerEnded[playerid] = false;
	    
	    new
	        vehicleid = Trucking::gWorkEnum[playerid][tworkp_VehicleId],
	        worktype = Trucking::gWorkEnum[playerid][tworkp_Type],
	        odmena = (Trucking::TransportTypeData[worktype][1] + random(Trucking::TransportTypeData[worktype][2] - Trucking::TransportTypeData[worktype][1]))
		;
		
		DestroyVehicle(vehicleid);
		DestroyVehicle(Trucking::vWorkEnum[vehicleid][tworkv_TrailerId]);
		
		ex_GivePlayerMoney(playerid,odmena);
		
		SetPlayerFactionRank(playerid, GetPlayerFactionRank(playerid)+1);
		
		SCFM(playerid, COLOR_GREEN, "[ ! ] {FFFFFF}DokonËil si pr·cu, za odmenu si dostal %d$. Post˙pil si o jeden level!", odmena);
		
		Trucking::gWorkEnum[playerid][tworkp_Type] = 0;
	}
	
	return 1;
	
}

Trucking::LoadDepots()
{

    new
		lLabelString[ 512 ]
	;

	for(new x; x < sizeof(Trucking::TransportDepots); x++)
	{
	
	    Trucking::Depot[x][depot_Type]  			= Trucking::TransportDepots[x][0];
	    Trucking::Depot[x][depot_UnloadingOnly]  	= Trucking::TransportDepots[x][1];
	    Trucking::Depot[x][depot_X]  				= Float:Trucking::TransportDepots[x][2];
	    Trucking::Depot[x][depot_Y]  				= Float:Trucking::TransportDepots[x][3];
	    Trucking::Depot[x][depot_Z]  				= Float:Trucking::TransportDepots[x][4];
	    
	    Trucking::Depot[x][depot_Loaded]  			= MAX_DEPOT_CAPACITY / 2;
	    
	    format(lLabelString, sizeof lLabelString, "{d6d6d6}[ %s ]\nna sklade: %d jednotiek\n", Trucking::TransportTypeDataN[Trucking::Depot[x][depot_Type]], Trucking::Depot[x][depot_Loaded]);
	    
	    Trucking::Depot[x][depot_Label]             = CreateDynamic3DTextLabel(lLabelString, 0xFFFFFFFF, Trucking::Depot[x][depot_X], Trucking::Depot[x][depot_Y], Trucking::Depot[x][depot_Z], 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1);
	    
	    CreateDynamicPickup(1239, 1, Trucking::Depot[x][depot_X], Trucking::Depot[x][depot_Y], Trucking::Depot[x][depot_Z]);

	}
	
	return 1;
}

Trucking::StartWork(playerid)
{
	if(Trucking::gWorkType[playerid] < 1)
	    return SendError(playerid, "Vyskytla sa chyba, t·to zak·zka nebola moûn·!");
	    
	Trucking::gWorkEnum[playerid][tworkp_Type]            = Trucking::gWorkType[playerid];
	Trucking::gWorkEnum[playerid][tworkp_StartUnix]       = 0;
	Trucking::gWorkEnum[playerid][tworkp_ToUnix]       	= 0;
	    
	switch(Trucking::gWorkType[playerid])
	{
	    case
			TRANSPORT_TYPE_FOOD, TRANSPORT_TYPE_MEAT,
			TRANSPORT_TYPE_SUGAR_DRINK, TRANSPORT_TYPE_CLOTHING
		:
		{
		    Trucking::SpawnVehicle(playerid, 403, 1750, true, 435);
		}
		
		case
			TRANSPORT_TYPE_ALCOHOL, TRANSPORT_TYPE_TOBACCO,
			TRANSPORT_TYPE_ELECTRONICS, TRANSPORT_TYPE_FURNITURE,
			TRANSPORT_TYPE_VEHICLE_PARTS
		:
		{
		    Trucking::SpawnVehicle(playerid, 403, 1460, true, 591);
		}
		
		default:
		{
		    Trucking::SpawnVehicle(playerid, 403, 1750, true, 435);
		}
	}
	    
	return 1;
}

Trucking::SpawnVehicle(playerid, modelid, maxcapacity = 1500, bool:trailer = false, trailermodel = 0)
{

	new
	    Float:lX, Float:lY, Float:lZ,
		Float:lA,
		
		lRandomStart = -1,
		lRandomFinish = -1,
		
		x = random(sizeof(Trucking::TrailerParkingSpots)),
		vehicleid,
		
		licplate[ 12 ]
	;
	
	////////////////////////////////////////////////////////////////////////////
	
	lX = Float:Trucking::TrailerParkingSpots[x][1];
	lY = Float:Trucking::TrailerParkingSpots[x][2];
	lZ = Float:Trucking::TrailerParkingSpots[x][3];
	lA = Float:Trucking::TrailerParkingSpots[x][4];
	
	while( lRandomStart == -1 )
	{
	
		lRandomStart = random(sizeof(Trucking::TransportDepots));
		
		if(Trucking::TransportDepots[lRandomStart][0] != Trucking::gWorkEnum[playerid][tworkp_Type] || Trucking::TransportDepots[lRandomStart][1] == 1)
		{
		    lRandomStart = -1;
		    continue;
		}
	}
	

	
	while( lRandomFinish == -1 )
	{
	
	    lRandomFinish = random(sizeof(Trucking::TransportDepots));

		if(Trucking::TransportDepots[lRandomFinish][0] != Trucking::gWorkEnum[playerid][tworkp_Type] || lRandomStart == lRandomFinish)
		{
		    lRandomFinish = -1;
		    continue;
		}
	}
	
	////////////////////////////////////////////////////////////////////////////
	
    vehicleid = Trucking::gWorkEnum[playerid][tworkp_VehicleId]   = CreateVehicle(modelid, lX, lY, lZ, lA, -1, -1, -1, 0);
    
    SetVehicleParamsEx(vehicleid, 0, 0, 0, 0, 0, 0, 0);
    
    Trucking::vWorkEnum[vehicleid][tworkv_Type]         = Trucking::gWorkEnum[playerid][tworkp_Type];
    Trucking::vWorkEnum[vehicleid][tworkv_Loaded]       = 0;
    Trucking::vWorkEnum[vehicleid][tworkv_State]        = 1;
    Trucking::vWorkEnum[vehicleid][tworkv_StartId]      = lRandomStart;
    Trucking::vWorkEnum[vehicleid][tworkv_FinishId]     = lRandomFinish;
    Trucking::vWorkEnum[vehicleid][tworkv_Capacity]     = maxcapacity;
    
    format(licplate, sizeof licplate, "BMPS-T-%03d", vehicleid + 300);
    
	SetVehicleNumberPlate(vehicleid, licplate);
	SetVehicleHealth(vehicleid, 1000.0);
	veh_IsDeath[vehicleid]=false;

	format(vEnum[vehicleid][v_SPZ], 24, licplate);
	format(vEnum[vehicleid][v_Owner], 30, "-");
	vEnum[vehicleid][v_Fuel] = 100;
	vEnum[vehicleid][v_FuelType] = vehicleFuelTypes[GetVehicleModel(vehicleid)-400];
	vEnum[vehicleid][v_Battery] = 1000;
	vEnum[vehicleid][v_Siren] = 0;
	vEnum[vehicleid][v_MileAge] = random(518501)/100;
	vEnum[vehicleid][v_Nitrous] = 0.0;
	vEnum[vehicleid][v_Faction] = 53;

	vEnum[vehicleid][v_Color_1] = -1;
	vEnum[vehicleid][v_Color_2] = -1;

	vEnum[vehicleid][v_def_SpawnX] = 0.0;
	vEnum[vehicleid][v_def_SpawnY] = 0.0;
	vEnum[vehicleid][v_def_SpawnZ] = 3.0;
	vEnum[vehicleid][v_def_SpawnA] = 90.0;
	vEnum[vehicleid][v_def_SpawnVW] = 0;
	vEnum[vehicleid][v_def_SpawnINT] = 0;
	vEnum[vehicleid][v_def_Health] = 1000.0;
	vEnum[vehicleid][v_Oil] = 100.0;
	
	////////////////////////////////////////////////////////////////////////////
	
	g_I_playerCheckpoint[playerid] = checkp_prepravca_truck;
	SetPlayerCheckpoint(playerid, lX, lY, lZ, 5.0);
    
    ////////////////////////////////////////////////////////////////////////////
    
    if(trailer)
    {
        new
            trailerid
		;
		
		x = random(sizeof(Trucking::Trailer2ParkingSpots));

		lX = Float:Trucking::Trailer2ParkingSpots[x][1];
		lY = Float:Trucking::Trailer2ParkingSpots[x][2];
		lZ = Float:Trucking::Trailer2ParkingSpots[x][3];
		lA = Float:Trucking::Trailer2ParkingSpots[x][4];

		trailerid = Trucking::vWorkEnum[vehicleid][tworkv_TrailerId] = CreateVehicle(trailermodel, lX, lY, lZ, lA, -1, -1, -1, 0);
		
		format(licplate, sizeof licplate, "BMPS-N-%03d", vehicleid + 300);
		
		SetVehicleNumberPlate(trailerid, licplate);
		SetVehicleHealth(trailerid, 1000.0);
		veh_IsDeath[trailerid]=false;

		format(vEnum[trailerid][v_SPZ], 24, licplate);
		format(vEnum[trailerid][v_Owner], 30, "-");
		vEnum[trailerid][v_Fuel] = 100;
		vEnum[trailerid][v_FuelType] = vehicleFuelTypes[GetVehicleModel(trailerid)-400];
		vEnum[trailerid][v_Battery] = 1000;
		vEnum[trailerid][v_Siren] = 0;
		vEnum[trailerid][v_MileAge] = random(518501)/100;
		vEnum[trailerid][v_Nitrous] = 0.0;
		vEnum[trailerid][v_Faction] = 53;

		vEnum[trailerid][v_Color_1] = -1;
		vEnum[trailerid][v_Color_2] = -1;

		vEnum[trailerid][v_def_SpawnX] = 0.0;
		vEnum[trailerid][v_def_SpawnY] = 0.0;
		vEnum[trailerid][v_def_SpawnZ] = 3.0;
		vEnum[trailerid][v_def_SpawnA] = 90.0;
		vEnum[trailerid][v_def_SpawnVW] = 0;
		vEnum[trailerid][v_def_SpawnINT] = 0;
		vEnum[trailerid][v_def_Health] = 1000.0;
		vEnum[trailerid][v_Oil] = 100.0;
    }
    
    ////////////////////////////////////////////////////////////////////////////
    
    SCFM(playerid, COLOR_DARKRED, "[ ! ] {FFFFFF}Zobral si z·sielku! Budeö viezù %s. Vozidlo m·ö zaparkovanÈ na parkovisku, jeho SPZ je %s.", Trucking::TransportTypeDataN[Trucking::gWorkEnum[playerid][tworkp_Type]], licplate);
    SCFM(playerid, COLOR_DARKRED, "[ ! ] {FFFFFF}Nasadni do vozidla a nezabudni zah·knuù prÌves id %d ktor˝ je tu pri gar·ûi, alebo dole, ak m·ö kamiÛn!", Trucking::vWorkEnum[vehicleid][tworkv_TrailerId]);
    SCFM(playerid, COLOR_DARKRED, "[ ! ] {FFFFFF}Na vyzdvihnutie n·kladu m·ö 15 min˙t!");
    
    ////////////////////////////////////////////////////////////////////////////
    
    Trucking::gWorkEnum[playerid][tworkp_StartUnix]     = gettime();
    Trucking::gWorkEnum[playerid][tworkp_ToUnix]     	= gettime() + (15 * 60);

	return 1;
	
}

Trucking::ShowWorkOffering(playerid, rank = 1)
{
	new
	    tStr[912] = "Tovar, potrebn˝ level\tOdmena v rozmedzÌ od-do\nInform·cie o preprav·ch\n",
		tStr_2[52];
	    
	for( new x = 1; x < sizeof Trucking::TransportTypeData; x++ )
	{
	
	    if(x >= TRANSPORT_TYPE_FUEL)
			continue;
	
	    if(rank >= Trucking::TransportTypeData[x][0]) //ma dostatocny rank
	    	format(tStr_2, sizeof tStr_2, "{8cce6f}%s (%d)\t%d$ aû %d$\n", Trucking::TransportTypeDataN[x], Trucking::TransportTypeData[x][0], Trucking::TransportTypeData[x][1], Trucking::TransportTypeData[x][2]);
		else //nema
		    format(tStr_2, sizeof tStr_2, "{ce5656}%s (%d)\t%d$ aû %d$\n", Trucking::TransportTypeDataN[x], Trucking::TransportTypeData[x][0], Trucking::TransportTypeData[x][1], Trucking::TransportTypeData[x][2]);
		    
		strcat(tStr, tStr_2);
	}
	
	ShowPlayerDialog(playerid, did_prepravca_offer, DIALOG_STYLE_TABLIST_HEADERS, "PONUKA PR¡CE", tStr, "DETAIL", "ZRUäIç");

	return 1;
}

Trucking::ShowWorkOfferDetail(playerid, transport_type)
{

	new
		finStr[ 512 ],
		jobDesc[ 128 ]
	;
	
	switch(transport_type)
	{
	    case TRANSPORT_TYPE_FOOD:
	        format(jobDesc, sizeof jobDesc, "Budeö viezù dod·vku s potravinami.");
	        
        case TRANSPORT_TYPE_MEAT:
	        format(jobDesc, sizeof jobDesc, "Budeö viezù dod·vku s m‰som.");
	        
        case TRANSPORT_TYPE_CLOTHING:
	        format(jobDesc, sizeof jobDesc, "Budeö viezù dod·vku s obleËenÌm.");
	        
        case TRANSPORT_TYPE_WEAPONS:
	        format(jobDesc, sizeof jobDesc, "Budeö viezù obrnenÈ vozidlo so zbraÚami a strelivom.");
	        
        case TRANSPORT_TYPE_VEHICLE_PARTS:
	        format(jobDesc, sizeof jobDesc, "Budeö viezù n·ves s auto-s˙Ëiastkami.");
	        
        case TRANSPORT_TYPE_ELECTRONICS:
	        format(jobDesc, sizeof jobDesc, "Budeö viezù n·ves s elektronikou.");
	        
        case TRANSPORT_TYPE_FURNITURE:
	        format(jobDesc, sizeof jobDesc, "Budeö viezù n·ves s elektronikou.");
	        
        case TRANSPORT_TYPE_ALCOHOL:
	        format(jobDesc, sizeof jobDesc, "Budeö viezù dod·vku s alkoholom.");
	        
        case TRANSPORT_TYPE_SUGAR_DRINK:
	        format(jobDesc, sizeof jobDesc, "Budeö viezù dod·vku so sladen˝mi n·pojmi.");
	        
        case TRANSPORT_TYPE_TOBACCO:
	        format(jobDesc, sizeof jobDesc, "Budeö viezù dod·vku s tabakov˝mi v˝robkami.");
	        
        case TRANSPORT_TYPE_FUEL:
	        format(jobDesc, sizeof jobDesc, "Budeö viezù cisternu s pohonn˝mi hmotami.");
	        
        case TRANSPORT_TYPE_VEHICLES:
	        format(jobDesc, sizeof jobDesc, "Budeö viezù n·ves s vozidlami.");
	        
        case TRANSPORT_TYPE_WOOD:
	        format(jobDesc, sizeof jobDesc, "Budeö viezù n·ves s drevom.");
	        
        case TRANSPORT_TYPE_MONEY:
	        format(jobDesc, sizeof jobDesc, "Budeö viezù obrnenÈ vozidlo s peniazmi.");
	        
        case TRANSPORT_TYPE_ROCKS:
	        format(jobDesc, sizeof jobDesc, "Budeö viezù n·kladiak so surovinami.");
	        
        case TRANSPORT_TYPE_CONCRETE:
	        format(jobDesc, sizeof jobDesc, "Budeö viezù mieöaËku.");
	        
		default:
		    return Trucking::ShowWorkOffering(playerid, GetPlayerFactionRank(playerid));
	}
	
	format(finStr, sizeof finStr, "{FFFFFF}MÙûeö si vybraù zak·zku typu {7de876}%s{ffffff}, za ktor˙ je odmena v rozmedzÌ {7de876}%d$ {FFFFFF}aû {7de876}%d${FFFFFF}.\nPotrebn˝ level na zak·zku je {7de876}%d{ffffff}, takûe ju mÙûeö vziaù.\n%s",
		Trucking::TransportTypeDataN[transport_type][0], Trucking::TransportTypeData[transport_type][1], Trucking::TransportTypeData[transport_type][2], Trucking::TransportTypeData[transport_type][0], jobDesc);
	
	ShowPlayerDialog(playerid, did_preprevca_offer_detail, DIALOG_STYLE_MSGBOX, "PONUKA PR¡CE - DETAIL", finStr, "VZIAç", "SPAç");
	
	Trucking::gWorkType[playerid] = transport_type;

	return 1;
}

Trucking::EnteredCheckpoint(playerid)
{

	new
	    vehicleid = GetPlayerVehicleID(playerid)
	;

	if(vehicleid != Trucking::gWorkEnum[playerid][tworkp_VehicleId])
	{
	    SendError(playerid, "MusÌö byù v kamiÛne, ktor˝ si dostal!");
	    return 0;
	}
	
	if(GetVehicleTrailer(vehicleid) != Trucking::vWorkEnum[vehicleid][tworkv_TrailerId])
	{
	    SendError(playerid, "MusÌö maù pripojen˝ prÌves ktor˝ si dostal!");
	    return 0;
	}
	
	switch(Trucking::vWorkEnum[vehicleid][tworkv_State])
	{
	    case 1:
	    {
	        // nakladanie
	        
	        g_I_playerCheckpoint[playerid] = checkp_none;
	        DisablePlayerCheckpoint(playerid);
	        
	        new
	            minx = 90,
	            maxx = Trucking::vWorkEnum[vehicleid][tworkv_Capacity],
				units,
				depotid = Trucking::vWorkEnum[vehicleid][tworkv_StartId]
			;
			
			if(Trucking::Depot[depotid][depot_Loaded] < maxx)
			    maxx = Trucking::Depot[depotid][depot_Loaded];
			    
			if(Trucking::Depot[depotid][depot_Loaded] < minx)
			    minx = Trucking::Depot[depotid][depot_Loaded];
			    
			units = (minx + random(maxx-minx));
			
			Trucking::Depot[depotid][depot_Loaded] 			-= units;
			
			Trucking::vWorkEnum[vehicleid][tworkv_Loaded] 	= units;
			Trucking::vWorkEnum[vehicleid][tworkv_State]    = 2;
			
			Trucking::gWorkEnum[playerid][tworkp_StartUnix] = gettime();
			Trucking::gWorkEnum[playerid][tworkp_ToUnix]    = gettime() + floatround(units / 8, floatround_round);
			
			TogglePlayerControllable(playerid, 0);
			
			new
			    lLabelString[512]
			;
			
			format(lLabelString, sizeof lLabelString, "{d6d6d6}[ %s ]\nna sklade: %d jednotiek\n", Trucking::TransportTypeDataN[Trucking::Depot[depotid][depot_Type]], Trucking::Depot[depotid][depot_Loaded]);
			
			UpdateDynamic3DTextLabelText(Trucking::Depot[depotid][depot_Label], 0xFFFFFFFF, lLabelString);
	        
	    }
	    
	    case 3:
	    {
	        // vykladanie

	        g_I_playerCheckpoint[playerid] = checkp_none;
	        DisablePlayerCheckpoint(playerid);

	        new
				depotid = Trucking::vWorkEnum[vehicleid][tworkv_FinishId]
			;

			Trucking::Depot[depotid][depot_Loaded] 			+= Trucking::vWorkEnum[vehicleid][tworkv_Loaded];
			Trucking::vWorkEnum[vehicleid][tworkv_State]    = 4;

			Trucking::gWorkEnum[playerid][tworkp_StartUnix] = gettime();
			Trucking::gWorkEnum[playerid][tworkp_ToUnix]    = gettime() + floatround(Trucking::vWorkEnum[vehicleid][tworkv_Loaded] / 8, floatround_round);
			Trucking::vWorkEnum[vehicleid][tworkv_Loaded]   = 0;

			TogglePlayerControllable(playerid, 0);

			new
			    lLabelString[512]
			;

			format(lLabelString, sizeof lLabelString, "{d6d6d6}[ %s ]\nna sklade: %d jednotiek\n", Trucking::TransportTypeDataN[Trucking::Depot[depotid][depot_Type]], Trucking::Depot[depotid][depot_Loaded]);

			UpdateDynamic3DTextLabelText(Trucking::Depot[depotid][depot_Label], 0xFFFFFFFF, lLabelString);
	    }
	    
	    case 5:
	    {
	        // zaparkovanie navesu, kamionu

	        g_I_playerCheckpoint[playerid] = checkp_none;
	        DisablePlayerCheckpoint(playerid);
	        
	        //DestroyVehicle(Trucking::vWorkEnum[vehicleid][tworkv_TrailerId]);
	        
	        SetVehicleFaction(vehicleid, 255);
	        SetVehicleParamsEx(vehicleid, 0, 0, 0, 1, 0, 0, 0);
	        
	        gPlayerEnded[playerid] = true;
	        
	        SCFM(playerid, COLOR_DARKRED, "[ ! ] {FFFFFF}DokonËil si prevoz z·sielky! Vyst˙p prosÌm.");
	    }
	}
	
	return 1;
}

stock Trucking::GetStationName(stationid)
	return Trucking::StationNames[stationid];

////////////////////////////////////////////////////////////////////////////////
