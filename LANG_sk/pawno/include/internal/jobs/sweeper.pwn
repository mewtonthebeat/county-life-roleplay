#include <a_samp>

//////////////////////////////

#define     Sweeper::       		sw_
#define     SWEEPER_NOT_FINISH      200
#define     MAX_SWEEPER_PICKUP      25
#define     SWEEPER_INDEX_FINISH    -255

//////////////////////////////

new Float:sweeper_VehicleSpawnPoint[][] = {
    {850.2742,-579.3345,17.9839,180.0322},
	{853.7516,-579.4498,17.9807,181.2649},
	{857.2373,-579.4063,17.9819,175.8916},
	{860.9004,-579.4695,17.9801,182.1174},
	{839.7172,-602.1429,18.1470,269.5377},
	{839.7400,-599.2418,18.1470,269.6571}
};

new Float:sweeper_PickupPoint[MAX_SWEEPER_PICKUP][] = {
    {834.5232,-553.8633,15.9127},
	{817.1956,-527.9240,15.9125},
	{782.3557,-526.2333,15.9126},
	{753.4612,-528.1280,15.9125},
	{732.1708,-526.6463,15.9103},
	{724.6739,-510.8269,15.9126},
	{711.1091,-482.6597,15.9124},
	{679.1678,-482.0249,15.9125},
	{652.7356,-482.7053,15.9125},
	{615.2307,-482.8076,15.9125},
	{599.6783,-505.6239,15.9126},
	{616.2556,-532.1347,15.9125},
	{638.8846,-551.1865,15.9126},
	{639.2634,-586.2511,15.9126},
	{664.9858,-602.0508,15.9125},
	{679.2374,-630.0034,15.9125},
	{684.5438,-639.4432,15.9126},
	{690.8660,-602.5571,15.9058},
	{723.7808,-574.9280,15.9125},
	{726.0496,-535.4615,15.9024},
	{760.4290,-532.7785,15.9125},
	{788.4352,-536.8595,15.9076},
	{789.3202,-579.9695,15.9125},
	{814.0148,-597.0313,15.9125},
	{833.5460,-576.6952,15.9125}
};

new sweeper_TrashModels[] = {
	2059, 2670, 2671, 2673, 2674, 2840
};

new sweeper_PickupObject[MAX_PLAYERS][MAX_SWEEPER_PICKUP];

//////////////////////////////

new bool:Sweeper::DoingJob[MAX_PLAYERS];
new Sweeper::VehicleId[MAX_PLAYERS];
new Sweeper::CurrentIndex[MAX_PLAYERS];

//////////////////////////////

Sweeper::StartJob(playerid, bool:onlystop = false)
{
	if(Sweeper::DoingJob[playerid] == true)
	{
        Sweeper::DoingJob[playerid] = false;
        
        if(Sweeper::CurrentIndex[playerid] >= 0)
        {
	        for(new x = Sweeper::CurrentIndex[playerid]; x < MAX_SWEEPER_PICKUP; x++)
	        {
	            DestroyDynamicObject(sweeper_PickupObject[playerid][x]);
	        }
	        
	        DisablePlayerCheckpoint(playerid);
	        g_I_playerCheckpoint[playerid] = checkp_none;

	        SendError(playerid, "SkonËil si pr·cu za poplatok 200$!");
	        ex_GivePlayerMoney(playerid, -200);
			money_spent[playerid] += floatround(200,floatround_round);
 		}
        
        Sweeper::CurrentIndex[playerid] = 0;
        
        inter_DeleteVehicle(Sweeper::VehicleId[playerid]);
        Sweeper::VehicleId[playerid] = INVALID_VEHICLE_ID;
        
        return 0;
	}
	
	if(onlystop == true)
	{
	    return 1;
	}
	    
    Sweeper::DoingJob[playerid] 	= true;
    Sweeper::VehicleId[playerid] 	= Sweeper::SpawnVehicle(playerid);
    
    if(Sweeper::VehicleId[playerid] == INVALID_VEHICLE_ID)
    {
        Sweeper::DoingJob[playerid] = false;
        return 1;
    }
    
    Sweeper::CurrentIndex[playerid] = 0;
    
    for(new x = Sweeper::CurrentIndex[playerid]; x < MAX_SWEEPER_PICKUP; x++)
    {
        sweeper_PickupObject[playerid][x] = CreateDynamicObject(
			sweeper_TrashModels[random(sizeof(sweeper_TrashModels))],
			sweeper_PickupPoint[x][0], sweeper_PickupPoint[x][1], sweeper_PickupPoint[x][2] - 1.9,
			0.0, 0.0, 0.0,
			-1, -1,
			playerid, .priority = 1)
		;
    }
    
    g_I_playerCheckpoint[playerid] = checkp_mission_sweeper;
    fix_SetPlayerCheckpoint(playerid, sweeper_PickupPoint[Sweeper::CurrentIndex[playerid]][0], sweeper_PickupPoint[Sweeper::CurrentIndex[playerid]][1], sweeper_PickupPoint[Sweeper::CurrentIndex[playerid]][2], 3.0);
    
    SendSuccess(playerid, "Vezmi si vozidlo Sweeper s tvojou menovkou a choÔ vyËistiù ulice Dillimore!");
    SendSuccess(playerid, "Pr·cu mÙûeö kedykoævek zruöiù prÌkazom /stopjob za poplatok 200$!");
    
	return 1;
}

Sweeper::NextCheckpoint(playerid)
{

	if(Sweeper::CurrentIndex[playerid] == (SWEEPER_INDEX_FINISH))
	{
	    // job finished
	    Sweeper::StartJob(playerid);
	    SCSuccess(playerid, "DokonËil si misiu upratovania ulÌc Dillimore, v Ôalöej v˝plate budeö maù o %d$ viac!", Economy::GetPrice(ECONOMY_LIST_SWEEPER));
	    g_I_Vyplata[playerid] += Economy::GetPrice(ECONOMY_LIST_SWEEPER);
	    g_I_playerCheckpoint[playerid] = checkp_none;
	    DisablePlayerCheckpoint(playerid);
	    return 0;
	}

	new index = Sweeper::CurrentIndex[playerid];
	Sweeper::CurrentIndex[playerid] ++;
	
	DisablePlayerCheckpoint(playerid);
	DestroyDynamicObject(sweeper_PickupObject[playerid][index]);
	
	if(Sweeper::CurrentIndex[playerid] >= MAX_SWEEPER_PICKUP)
	{
	    Sweeper::CurrentIndex[playerid] = (SWEEPER_INDEX_FINISH);
	    g_I_playerCheckpoint[playerid] = checkp_mission_sweeper;
    	fix_SetPlayerCheckpoint(playerid, 844.850, -599.424, 18.421, 3.0);
    	
    	SendError(playerid, "Upratal si celÈ Dillimore, vr·ù sa prosÌm do gar·ûe!");
	}
	else
	{
	    g_I_playerCheckpoint[playerid] = checkp_mission_sweeper;
    	SetPlayerCheckpoint(playerid, sweeper_PickupPoint[Sweeper::CurrentIndex[playerid]][0], sweeper_PickupPoint[Sweeper::CurrentIndex[playerid]][1], sweeper_PickupPoint[Sweeper::CurrentIndex[playerid]][2], 3.0);
	}
	
	return 1;
}

Sweeper::SpawnVehicle(playerid)
{
	if(Sweeper::DoingJob[playerid] == false)
	    return INVALID_VEHICLE_ID;
	    
	new randomPosId = random(sizeof(sweeper_VehicleSpawnPoint));

 	new
		vid,
		spz[24];

	vid = CreateVehicle(574, sweeper_VehicleSpawnPoint[randomPosId][0], sweeper_VehicleSpawnPoint[randomPosId][1], sweeper_VehicleSpawnPoint[randomPosId][2], sweeper_VehicleSpawnPoint[randomPosId][3], 8, 8, -1, 0);

	strcat(spz, "{000000}SWEEPER");

	SetVehicleNumberPlate(vid, spz);
	SetVehicleHealth(vid, 1000.0);
	veh_IsDeath[vid]=false;
	format(vEnum[vid][v_SPZ], 24, spz);
	format(vEnum[vid][v_Owner], 30, "Sweeper");
	vEnum[vid][v_Fuel] = 100;
	vEnum[vid][v_FuelType] = vehicleFuelTypes[GetVehicleModel(vid)-400];
	vEnum[vid][v_Battery] = 1000;
	vEnum[vid][v_Siren] = 0;
	vEnum[vid][v_MileAge] = float(random(518501)/100);
	vEnum[vid][v_Nitrous] = 0.0;
	vEnum[vid][v_Faction] = 51;
	vEnum[vid][v_Color_1] = 8;
	vEnum[vid][v_Color_2] = 8;
	vEnum[vid][v_def_SpawnX] = sweeper_VehicleSpawnPoint[randomPosId][0];
	vEnum[vid][v_def_SpawnY] = sweeper_VehicleSpawnPoint[randomPosId][1];
	vEnum[vid][v_def_SpawnZ] = sweeper_VehicleSpawnPoint[randomPosId][2];
	vEnum[vid][v_def_SpawnA] = sweeper_VehicleSpawnPoint[randomPosId][3];
	vEnum[vid][v_def_SpawnVW] = 0;
	vEnum[vid][v_def_SpawnINT] = 0;
	vEnum[vid][v_def_Health] = 1000.0;
	vEnum[vid][v_Oil] = 100.0;
	vEnum[vid][v_bazar_Price]   = 0;
	vEnum[vid][v_bazar_Buyout]   = 0;
	vEnum[vid][v_bazar_DateAdded]   = 0;
	vEnum[vid][v_bazar_BoughtFor]   = 0;
	format(vEnum[vid][v_bazar_Desc], 256, "");
	format(vEnum[vid][v_bazar_AddedBy], MAX_PLAYER_NAME+1, "");
	
	new UnitText[64];
	format(UnitText, sizeof UnitText, "[ SWEEPER ]\n[ %s ]", str_replace("_", " ", ReturnName(playerid)));
	UpdateFactionVehicleUnit(vid, UnitText, false, false, .windshield = false);

	return vid;
}
