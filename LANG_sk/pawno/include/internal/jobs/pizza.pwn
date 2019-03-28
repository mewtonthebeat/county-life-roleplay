#include <a_samp>

//////////////////////////////

#define     Pizza::       			piz_
#define     PIZZA_NOT_FINISH      	200
#define     MAX_PIZZA_PICKUP       	5
#define     PIZZA_ATTACH_SLOT       9

//////////////////////////////

new Float:pizza_VehicleSpawnPoint[][] = {
    {1345.5852,239.0655,19.5721,335.7075},
	{1348.2921,245.1134,19.5716,335.6416},
	{1351.7834,252.8908,19.5704,335.5607},
	{1356.5618,263.4821,19.5706,335.5751},
	{1360.5134,272.1448,19.5712,334.9643},
	{1361.1466,257.2202,19.6599,66.4414},
	{1356.1736,246.2188,19.6593,64.5343}
};

//////////////////////////////

new bool:Pizza::DoingJob[MAX_PLAYERS];
new bool:Pizza::Holding[MAX_PLAYERS];
new Pizza::VehicleId[MAX_PLAYERS];
new Pizza::PickupID[MAX_PLAYERS][MAX_PIZZA_PICKUP];
new Pizza::MapIconID[MAX_PLAYERS][MAX_PIZZA_PICKUP];
new Pizza::CheckpointID[MAX_PLAYERS][MAX_PIZZA_PICKUP];

//////////////////////////////

Pizza::StartJob(playerid, bool:onlystop = false)
{
	if(Pizza::DoingJob[playerid] == true)
	{
        Pizza::DoingJob[playerid] 	= false;
        Pizza::Holding[playerid]    = false;
        
        RemovePlayerAttachedObject(playerid, PIZZA_ATTACH_SLOT);
 		SetPlayerSpecialAction(playerid, 0);
        
        for(new x; x < MAX_PIZZA_PICKUP; x++)
        {
            if(Pizza::PickupID[playerid][x] != 1) continue;
            
            Pizza::PickupID[playerid][x] = 0;
            DestroyDynamicMapIcon(Pizza::MapIconID[playerid][x]);
            DestroyDynamicCP(Pizza::CheckpointID[playerid][x]);
        }
        
        inter_DeleteVehicle(Pizza::VehicleId[playerid]);
        Pizza::VehicleId[playerid] 	= INVALID_VEHICLE_ID;
        
        return 0;
	}
	
	if(onlystop == true)
	{
	    return 1;
	}
	    
    Pizza::DoingJob[playerid] 	= true;
    Pizza::Holding[playerid]    = false;
    Pizza::VehicleId[playerid] 	= Pizza::SpawnVehicle(playerid);
    
    if(Pizza::VehicleId[playerid] == INVALID_VEHICLE_ID)
    {
        Pizza::DoingJob[playerid] = false;
        return 1;
    }
	
	new
		count = 0,

		Float:X, Float:Y, Float:Z
	;
	
	while(count < MAX_PIZZA_PICKUP)
	{
	    new
			i = random(Iter_End(Houses));
			
        if(houseEnum[i][ho_PosX] == 0 && houseEnum[i][ho_PosY] == 0) continue;
		if(houseEnum[i][ho_PosVirtualWorld] != 0) continue;
		if(houseEnum[i][ho_PosInterior] != 0) continue;
		if(IsPlayerInRangeOfPoint(playerid, 1.5, houseEnum[i][ho_PosX], houseEnum[i][ho_PosY], houseEnum[i][ho_PosZ])) continue;
			
		X 										= houseEnum[i][ho_PosX];
		Y 										= houseEnum[i][ho_PosY];
		Z 										= houseEnum[i][ho_PosZ];

		Pizza::PickupID[playerid][count]        = 1;
		Pizza::MapIconID[playerid][count]       = CreateDynamicMapIcon(X, Y, Z, 56, 0xFFFFFFFF, -1, -1, playerid, 4000, MAPICON_GLOBAL, -1, 0);
		Pizza::CheckpointID[playerid][count] 	= CreateDynamicCP(X, Y, Z, 1.0, -1, -1, playerid, 20.0, -1, 0);
		
		count ++;
			
	    continue;
	}

    SendSuccess(playerid, "Vezmi si vozidlo Moonbeam s tvojou menovkou a choï rozviez pizzu!");
    SendSuccess(playerid, "Kam máš pizzu rozviez zistíš pod¾a žltej bodky na minimape!");
    SendSuccess(playerid, "");
    SendSuccess(playerid, "Keï už budeš ma pizzu odovzda, vyber ju z kufra vozidla príkazom /takepizza.");
    SCSuccess(playerid,   "Za dokonèenie celej práce dostaneš odmenu %d$, ale dýška si môžeš necha!", Economy::GetPrice(ECONOMY_LIST_PIZZA_FINISH));
    SendSuccess(playerid, "Prácu môžeš kedyko¾vek zruši príkazom /stopjob za poplatok 200$!");
    
	return 1;
}

Pizza::DynamicCheckpoint(playerid, checkpointid)
{

	new id = -1;
	
	for(new x; x < MAX_PIZZA_PICKUP; x++)
	{
	    if(Pizza::PickupID[playerid][x] != 1) continue;
	    if(Pizza::CheckpointID[playerid][x] != checkpointid) continue;
		id = x;
		break;
	}
	
	if(id == -1) return 0;
	
	if(Pizza::Holding[playerid] != true)
	    return SendSuccess(playerid, "Vyber pizzu z kufra pracovného vozidla príkazom /takepizza!");
	
	Pizza::PickupID[playerid][id] 	= 0;
	DestroyDynamicMapIcon(Pizza::MapIconID[playerid][id]);
 	DestroyDynamicCP(Pizza::CheckpointID[playerid][id]);
 	
 	Pizza::Holding[playerid]        = false;
 	RemovePlayerAttachedObject(playerid, PIZZA_ATTACH_SLOT);
 	SetPlayerSpecialAction(playerid, 0);
 	
 	new odmena = 0;

	if(random(5) != 1) odmena = Economy::GetPrice(ECONOMY_LIST_PIZZA_TRINGELT);
 	
 	new S_str[144];
 	if(odmena <= 0)
 	{
 	    format(S_str, 144, "* %s podáva pizzu majite¾ovi domu ... *", GetPlayerNameEx(playerid, USE_MASK));
		SendLocalMessage(playerid,ME_CHAT_RANGE,COLOR_VIOLET,S_str);
 	    SCSuccess(playerid, "Odovzdal si pizzu objednávate¾ovi, ale ten úžerník ti nedal niè navyše!");
 	}
 	else
 	{
 	    format(S_str, 144, "* %s podáva pizzu majite¾ovi domu a berie od neho dýško %d$ ... *", GetPlayerNameEx(playerid, USE_MASK), odmena);
		SendLocalMessage(playerid,ME_CHAT_RANGE,COLOR_VIOLET,S_str);
 	    SCSuccess(playerid, "Odovzdal si pizzu objednávate¾ovi a dostal si dýško %d$! Makaj makaj!", odmena);
 	    
 	    ex_GivePlayerMoney(playerid, odmena);
 	    money_work[playerid] += odmena;
 	}
 	
 	id = -1;

	for(new x; x < MAX_PIZZA_PICKUP; x++)
	{
	    if(Pizza::PickupID[playerid][x] != 1) continue;
		id = x;
		break;
	}

	if(id == -1)
	{
	    // už nemá viac èo zobra
	    DisablePlayerCheckpoint(playerid);
	    fix_SetPlayerCheckpoint(playerid, 1352.125, 254.533, 19.554, 3.0, checkp_mission_pizza_fin);
	}
	
	return 1;
}

Pizza::SpawnVehicle(playerid)
{
	if(Pizza::DoingJob[playerid] == false)
	    return INVALID_VEHICLE_ID;
	    
	new randomPosId = random(sizeof(pizza_VehicleSpawnPoint));

 	new
		vid,
		spz[24];

	vid = CreateVehicle(418, pizza_VehicleSpawnPoint[randomPosId][0], pizza_VehicleSpawnPoint[randomPosId][1], pizza_VehicleSpawnPoint[randomPosId][2], pizza_VehicleSpawnPoint[randomPosId][3], 3, 3, -1, 0);

	strcat(spz, "{000000}PIZZA");

	SetVehicleNumberPlate(vid, spz);
	SetVehicleHealth(vid, 1000.0);
	veh_IsDeath[vid]=false;
	format(vEnum[vid][v_SPZ], 24, spz);
	format(vEnum[vid][v_Owner], 30, "Pizza");
	vEnum[vid][v_Fuel] = 100;
	vEnum[vid][v_FuelType] = vehicleFuelTypes[GetVehicleModel(vid)-400];
	vEnum[vid][v_Battery] = 1000;
	vEnum[vid][v_Siren] = 0;
	vEnum[vid][v_MileAge] = float(random(518501)/100);
	vEnum[vid][v_Nitrous] = 0.0;
	vEnum[vid][v_Faction] = 52;
	vEnum[vid][v_Color_1] = 3;
	vEnum[vid][v_Color_2] = 3;
	vEnum[vid][v_def_SpawnX] = pizza_VehicleSpawnPoint[randomPosId][0];
	vEnum[vid][v_def_SpawnY] = pizza_VehicleSpawnPoint[randomPosId][1];
	vEnum[vid][v_def_SpawnZ] = pizza_VehicleSpawnPoint[randomPosId][2];
	vEnum[vid][v_def_SpawnA] = pizza_VehicleSpawnPoint[randomPosId][3];
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
	format(UnitText, sizeof UnitText, "[ PIZZA ]\n[ %s ]", str_replace("_", " ", ReturnName(playerid)));
	UpdateFactionVehicleUnit(vid, UnitText, false, false, .windshield = false);

	return vid;
}

YCMD:takepizza(playerid, params[], help)
{
    if(!Pizza::DoingJob[playerid])
	    return SendError(playerid, "Tento príkaz nemôžeš použi!");

	if(Pizza::Holding[playerid])
	    return SendError(playerid, "Už máš pizzu!");

	if(IsPlayerInAnyVehicle(playerid))
	    return SendError(playerid, "Nesmieš sedie v aute!");

	new
	    vehicleid = -1,
	    Float:distance = 3.5,
	    Float:newdist = 0.0,

		Float:Pos[3],
		Float:vPos[3];

	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);

	foreach ( new i : Vehicle )
	{
		GetVehicleBoot(i, vPos[0], vPos[1], vPos[2]);

		newdist = GetDistanceFromPoint(vPos[0], vPos[1], vPos[2], Pos[0], Pos[1], Pos[2]);

		if(newdist < distance)
		{
		    vehicleid = i;
		    distance = newdist;
		}

		continue;
	}

	if(vehicleid == -1 || IsPlayerInAnyVehicle(playerid))
	    return SendError(playerid, "Nestojíš pri kufri vozidla ktoré má pizzu!");

	if(GetVehicleParams(vehicleid, VEHICLE_TYPE_BOOT) != 1)
	    return SendError(playerid, "Toto vozidlo nemá otvorený kufor!");

    if(GetVehicleFactionType(vehicleid) != FACTION_TYPE_PIZZADELIVERY)
	    return SendError(playerid, "V tomto vozidle nie je pizza!");

	Pizza::Holding[playerid] = true;
    SetPlayerAttachedObject(playerid, PIZZA_ATTACH_SLOT, 19571, 6, -0.166999, -0.010000, -0.190999, -15.900000, 90.200042, -7.200002);
    SetPlayerSpecialAction(playerid, 25);

    new S_str[144];
	format(S_str, 144, "* %s vyberá z kufra vozidla %s jednu pizzu. *", GetPlayerNameEx(playerid, USE_MASK), VehicleNames[GetVehicleModel(vehicleid)-400]);
	SendLocalMessage(playerid,ME_CHAT_RANGE,COLOR_VIOLET,S_str);

	return 1;
}

YCMD:throwpizza(playerid, params[], help)
{

    if(!Pizza::DoingJob[playerid])
	    return SendError(playerid, "Tento príkaz nemôžeš použi!");

	if(!Pizza::Holding[playerid])
	    return SendError(playerid, "Nemáš v ruke pizzu!");

    Pizza::Holding[playerid] = false;
    RemovePlayerAttachedObject(playerid, PIZZA_ATTACH_SLOT);
    SetPlayerSpecialAction(playerid, 0);

    new S_str[144];
	format(S_str, 144, "* %s zahadzuje pizzu. *", GetPlayerNameEx(playerid, USE_MASK));
	SendLocalMessage(playerid,ME_CHAT_RANGE,COLOR_VIOLET,S_str);

	ex_GivePlayerMoney(playerid, -25);
	money_spent[playerid]+=floatround(25,floatround_round);
	SendError(playerid, "Prišiel si o 25$ za zahodenie pizze!");

	return 1;
}

YCMD:givepizza(playerid, params[], help)
{
    if(!Pizza::DoingJob[playerid])
	    return SendError(playerid, "Tento príkaz nemôžeš použi!");

	if(!Pizza::Holding[playerid])
	    return SendError(playerid, "Nemáš v ruke pizzu!");

	new
		I_var;

	if(sscanf(params,"d",I_var))
		return SendClientSyntax(playerid, "/datpizzu [id]");

	if(!IsPlayerLogged(I_var))
		return SendClientPlayerOffline(playerid);

	if(!IsPlayerNearPlayer(playerid, I_var, 3.0))
	    return SendError(playerid, "Tento hráè je moc ïaleko!");

	SetPlayerInventoryItem(I_var, inv_pizza, GetPlayerInventoryItem(I_var, inv_pizza)+1);

    Pizza::Holding[playerid] = false;
	RemovePlayerAttachedObject(playerid, PIZZA_ATTACH_SLOT);
    SetPlayerSpecialAction(playerid, 0);

	new S_str[144];
	format(S_str, 144, "* %s podáva pizzu %s. *", GetPlayerNameEx(playerid, USE_MASK), GetPlayerNameEx(I_var, USE_MASK));
	SendLocalMessage(playerid,ME_CHAT_RANGE,COLOR_VIOLET,S_str);

	ex_GivePlayerMoney(playerid, -25);
	money_spent[playerid]+=floatround(25,floatround_round);
	SendError(playerid, "Prišiel si o 25$ za danie pizze!");

	return 1;
}
