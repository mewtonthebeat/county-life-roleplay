////////////////////////////////////////////////////////////////////////////////

#define     Dealership::    dea_
#define     MAX_DEALERSHIPS 8
#define     MAX_DEALERSHIP_VEH  120

////////////////////////////////////////////////////////////////////////////////

enum dealershipen()
{
	dealsh_Name[64],
	dealsh_Multiplier,
	
	dealsh_PickupId,
	Text3D:dealsh_LabelId,
	dealsh_AreaId,
	
	Float:dealsh_pX,Float:dealsh_pY,Float:dealsh_pZ,dealsh_pVW,dealsh_pINT,
	Float:dealsh_vX,Float:dealsh_vY,Float:dealsh_vZ,Float:dealsh_vA
}

enum dealershipveh()
{
	dealveh_Model,
	dealveh_Donator,
	dealveh_Price,
	dealveh_PriceKr,
	dealveh_Recolor,
	dealveh_Fact1,
	dealveh_Fact2,
	dealveh_Fact3,
	dealveh_Fact4,
	dealveh_Fact5,
}

new dealershipenum[MAX_DEALERSHIPS][dealershipen];
new tmp_dealershipedit[MAX_PLAYERS];
new tmp_factioneditiddeal[MAX_PLAYERS];
new dealshvehicles[MAX_DEALERSHIPS][MAX_DEALERSHIP_VEH][dealershipveh];
new PlayerText:dealershipTD[MAX_PLAYERS][24];
new dealshipIndex[MAX_PLAYERS];
new dealshipCol1[MAX_PLAYERS];
new dealshipCol2[MAX_PLAYERS];
new bool:dealshnoresponse[MAX_PLAYERS];
new bool:isindealship[MAX_PLAYERS];

////////////////////////////////////////////////////////////////////////////////

function dealership_LoadData()
{
	new
        id,
        multiplier,
		Float:Pos[7],
		Worlds[2],
		name[64];

	for(new i = 0; i < cache_num_rows(); i++) {
	    if(i == cache_num_rows()) break;
	    cache_get_value_name_int(i, "id", id);
	    cache_get_value_name_float(i, "x", Pos[0]);
	    cache_get_value_name_float(i, "y", Pos[1]);
	    cache_get_value_name_float(i, "z", Pos[2]);
	    cache_get_value_name_float(i, "vx", Pos[3]);
	    cache_get_value_name_float(i, "vy", Pos[4]);
	    cache_get_value_name_float(i, "vz", Pos[5]);
	    cache_get_value_name_float(i, "va", Pos[6]);
	    cache_get_value_name_int(i, "vw", Worlds[0]);
	    cache_get_value_name_int(i, "interior", Worlds[1]);
	    cache_get_value_name_int(i, "multiplier", multiplier);
	    cache_get_value_name(i, "name", name);
	    
	    dealershipenum[id][dealsh_pX] = Pos[0];
	    dealershipenum[id][dealsh_pY] = Pos[1];
	    dealershipenum[id][dealsh_pZ] = Pos[2];
	    dealershipenum[id][dealsh_pVW] = Worlds[0];
	    dealershipenum[id][dealsh_pINT] = Worlds[1];
	    
	    dealershipenum[id][dealsh_vX] = Pos[3];
	    dealershipenum[id][dealsh_vY] = Pos[4];
	    dealershipenum[id][dealsh_vZ] = Pos[5];
	    dealershipenum[id][dealsh_vA] = Pos[6];
	    
	    dealershipenum[id][dealsh_Multiplier] = multiplier;
	    
	    format(dealershipenum[id][dealsh_Name], 64, name);
	    
	    dealershipenum[id][dealsh_AreaId] 	= CreateDynamicSphere(Pos[0],Pos[1],Pos[2], 2.5, dealershipenum[id][dealsh_pVW],dealershipenum[id][dealsh_pINT]);
		dealershipenum[id][dealsh_LabelId] 	= CreateDynamic3DTextLabel("/buyvehicle", 0xFFFFFFFF, Pos[0],Pos[1],Pos[2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, dealershipenum[id][dealsh_pVW], dealershipenum[id][dealsh_pINT], -1, 10.0);
		dealershipenum[id][dealsh_PickupId] = CreateDynamicPickup(1239, 1, Pos[0],Pos[1],Pos[2], dealershipenum[id][dealsh_pVW], dealershipenum[id][dealsh_pINT], -1, 80.0, -1, 0);

	}
	return 1;
}

Dealership::ShowAllDealerships(playerid)
{

	new
	    fstr[512] = "> Vytvoriù nov˝ dealership",
	    tname[ 64 ],
		tquery[ 128 ],
		Cache:cache
	;
	
	mysql_format(MYSQL, tquery, sizeof tquery, "SELECT * FROM dealership_places");
	cache = mysql_query(MYSQL, tquery);
	
	for(new x, y = cache_num_rows(); x < y; x++)
	{
	    cache_get_value_name(x, "name", tname);
	    
	    format(tquery, sizeof tquery, "\n%s", tname);
	    strcat(fstr, tquery);
	}
	
	cache_delete(cache);
	
	ShowPlayerDialog(playerid, did_dealership, DIALOG_STYLE_LIST, "VäETCI OBCHODNÕCI", fstr, "VYBRAç", "ZRUäIç");

	return 1;
}

Dealership::CreateNew(playerid)
{
	new
        S_query[256],
        S_codeName[64],
		day,
		month,
		year,
		hour,
		minute,

		tmp_id = -1
	;
	
	for(new x; x < MAX_DEALERSHIPS; x++)
	{
	    if(dealershipenum[x][dealsh_Multiplier] > 0)
	        continue;
	        
		tmp_id = x;
		break;
	}
	
	if(tmp_id == -1) return SendError(playerid, "Nie je voæn˝ slot na nov˝ dealership!"), Dealership::ShowAllDealerships(playerid);

	getdate(year, month, day);
	gettime(hour, minute);

	format(S_codeName, 64, "CREATED_DEALER_%d_%d_%d_%d-%d__%d", day, month, year, hour, minute, 1000+random(9000));
	
	mysql_format(MYSQL, S_query, sizeof S_query, "INSERT INTO dealership_places (id,name,multiplier) VALUES ('%d','%e','1000')", tmp_id, S_codeName);
	mysql_query(MYSQL, S_query,false);
	
	////////////////////////////////////////////////////////////////////////////
	
	format(dealershipenum[tmp_id][dealsh_Name], 64, S_codeName);
	dealershipenum[tmp_id][dealsh_Multiplier]   = 1000;
	dealershipenum[tmp_id][dealsh_AreaId]       = -255;
	
	////////////////////////////////////////////////////////////////////////////
	
	Dealership::ShowAllDealerships(playerid);
	return 1;
}

Dealership::Select(playerid, id)
{
    tmp_dealershipedit[playerid] = (id - 1);
    
    if(tmp_dealershipedit[playerid] < 0 || tmp_dealershipedit[playerid] >= MAX_DEALERSHIPS)
    {
        return 0;
    }
    
	Dealership::ShowDetail(playerid);

	return 1;
}

Dealership::ShowDetail(playerid)
{

	new
	    finalString[ 2048 ],
	    tempString[ 128 ],
	    
	    id = tmp_dealershipedit[playerid]
	;
	
	format(tempString, sizeof tempString, "{FFFFFF}N·zov\t{6793db}%s\n", dealershipenum[id][dealsh_Name]);
	strcat(finalString, tempString);
	
	format(tempString, sizeof tempString, "{FFFFFF}Multiplier\t{6793db}%.3f\n \n", float(dealershipenum[id][dealsh_Multiplier])/1000.0);
	strcat(finalString, tempString);
	
    //*//*//*//
	
	format(tempString, sizeof tempString, "{FFFFFF}Majiteæ\t{6793db}N/A\n");
	strcat(finalString, tempString);
	
	format(tempString, sizeof tempString, "{FFFFFF}Cena obchodu\t{6793db}N/A \n \n");
	strcat(finalString, tempString);
	
	//*//*//*//
	
	new item = 1;
	
	if(dealershipenum[id][dealsh_pX] == 0.0 && dealershipenum[id][dealsh_pY] == 0.0) item = 0;
	
	format(tempString, sizeof tempString, "{FFFFFF}PozÌcia pickupu\t{6793db}%s\n", ReturnBoolString(item));
	strcat(finalString, tempString);
	
	item = 1;
    if(dealershipenum[id][dealsh_vX] == 0.0 && dealershipenum[id][dealsh_vY] == 0.0) item = 0;

	format(tempString, sizeof tempString, "{FFFFFF}PozÌcia vozidla\t{6793db}%s\n \n", ReturnBoolString(item));
	strcat(finalString, tempString);
	
	//*//*//*//
	
	format(tempString, sizeof tempString, "{FFFFFF}V˝ber vozidiel ...\n \n");
	strcat(finalString, tempString);

	//*//*//*//

	format(tempString, sizeof tempString, "{d33232}Odstr·niù dealership ...");
	strcat(finalString, tempString);
	
	ShowPlayerDialog(playerid, did_dealership_detail, DIALOG_STYLE_TABLIST, "DETAIL DEALERSHIPU", finalString, "UPRAVIç", "SPAç");

	return 1;
}

new dealshcount[MAX_PLAYERS];
Dealership::VehicleDetail(playerid, count)
{
    dealshcount[playerid]=count;
    new
		query[128],Cache:cache,
		
		tmodel = 0,
		tprice,
		tkredity,
		tdonator,
		trecolor,
		tfactiontype[5],
		
		fstr[1024],
		tstr[128]
	;

	mysql_format(MYSQL, query, sizeof query, "SELECT * FROM dealership_vehicles WHERE dealid='%d' ORDER BY model", tmp_dealershipedit[playerid]);
	cache = mysql_query(MYSQL, query);

	for(new x, y = cache_num_rows(); x < y; x++)
	{
	    if(x != count) continue;
	    
	    cache_get_value_name_int(x, "model", tmodel);
	    cache_get_value_name_int(x, "price", tprice);
	    cache_get_value_name_int(x, "kredity", tkredity);
	    cache_get_value_name_int(x, "donatorlevel", tdonator);
	    cache_get_value_name_int(x, "recolourable", trecolor);
	    
	    cache_get_value_name_int(x, "factiontype1", tfactiontype[0]);
	    cache_get_value_name_int(x, "factiontype2", tfactiontype[1]);
	    cache_get_value_name_int(x, "factiontype3", tfactiontype[2]);
	    cache_get_value_name_int(x, "factiontype4", tfactiontype[3]);
	    cache_get_value_name_int(x, "factiontype5", tfactiontype[4]);
	}

	cache_delete(cache);
	
	if(tmodel == 0) return Dealership::ShowVehicles(playerid);
	
	format(tstr, sizeof tstr, "{FFFFFF}Model\t{6793db}%s\n", VehicleNames[tmodel-400]);
	strcat(fstr, tstr);
	
	format(tstr, sizeof tstr, "{FFFFFF}Potrebn˝ Donator\t{6793db}Level %d\n \n", tdonator);
	strcat(fstr, tstr);
	
	//*//*//*//
	
	format(tstr, sizeof tstr, "{FFFFFF}Cena\t{6793db}%d$\n", tprice);
	strcat(fstr, tstr);
	format(tstr, sizeof tstr, "{FFFFFF}Cena v kreditoch\t{6793db}%d kreditov\n \n", tkredity);
	strcat(fstr, tstr);
	
	//*//*//*//
	
	format(tstr, sizeof tstr, "{FFFFFF}PrefarbiteænÈ\t{6793db}%s\n \n", ReturnBoolString(!trecolor));
	strcat(fstr, tstr);
	
	//*//*//*//
	
	new tfactname[64];
	
	if(tfactiontype[0]==0) format(tfactname,sizeof tfactname,"Pre vöetky");
	else format(tfactname,sizeof tfactname,factionTypes[tfactiontype[0]]);
	format(tstr, sizeof tstr, "{FFFFFF}Typ frakcie\t{6793db}%s\n", tfactname);
	strcat(fstr, tstr);
	
	if(tfactiontype[1]==0) format(tfactname,sizeof tfactname,"N/A");
	else format(tfactname,sizeof tfactname,factionTypes[tfactiontype[1]]);
	format(tstr, sizeof tstr, "{FFFFFF}Typ frakcie\t{6793db}%s\n", tfactname);
	strcat(fstr, tstr);
	
	if(tfactiontype[2]==0) format(tfactname,sizeof tfactname,"N/A");
	else format(tfactname,sizeof tfactname,factionTypes[tfactiontype[2]]);
	format(tstr, sizeof tstr, "{FFFFFF}Typ frakcie\t{6793db}%s\n", tfactname);
	strcat(fstr, tstr);
	
	if(tfactiontype[3]==0) format(tfactname,sizeof tfactname,"N/A");
	else format(tfactname,sizeof tfactname,factionTypes[tfactiontype[3]]);
	format(tstr, sizeof tstr, "{FFFFFF}Typ frakcie\t{6793db}%s\n", tfactname);
	strcat(fstr, tstr);
	
	if(tfactiontype[4]==0) format(tfactname,sizeof tfactname,"N/A");
	else format(tfactname,sizeof tfactname,factionTypes[tfactiontype[4]]);
	format(tstr, sizeof tstr, "{FFFFFF}Typ frakcie\t{6793db}%s\n \n", tfactname);
	strcat(fstr, tstr);
	
	//*//*//*//
	
	format(tstr, sizeof tstr, "{d33232}Odstr·niù vozidlo ...");
	strcat(fstr, tstr);
	
	ShowPlayerDialog(playerid, did_dealership_vehicle, DIALOG_STYLE_TABLIST, "⁄PRAVA VOZIDLA", fstr, "UPRAVIç", "ZRUäIç");
	return 1;
}

enum {
    D_EDIT_TYPE_DONATOR = 0,
    D_EDIT_TYPE_PRICE,
    D_EDIT_TYPE_CREDITS,
    D_EDIT_TYPE_RECOLOUR,
    D_EDIT_TYPE_FACTION,
}
Dealership::ShowEdit(playerid,edittype,exid=-1)
{
    if(exid != -1) tmp_factioneditiddeal[playerid]=exid;
	switch(edittype)
	{
		case D_EDIT_TYPE_DONATOR:
		    ShowPlayerDialog(playerid, did_dealership_vehicle_donator, DIALOG_STYLE_INPUT, "⁄PRAVA VOZIDLA", "{FFFFFF}> Zadaj potrebn˝ donator level pre k˙pu tohoto vozidla:", "OK", "SPAç");
		    
        case D_EDIT_TYPE_PRICE:
		    ShowPlayerDialog(playerid, did_dealership_vehicle_price, DIALOG_STYLE_INPUT, "⁄PRAVA VOZIDLA", "{FFFFFF}> Zadaj cenu v $ pre k˙pu tohoto vozidla:", "OK", "SPAç");
		    
  		case D_EDIT_TYPE_CREDITS:
		    ShowPlayerDialog(playerid, did_dealership_vehicle_credits, DIALOG_STYLE_INPUT, "⁄PRAVA VOZIDLA", "{FFFFFF}> Zadaj cenu v kreditoch pre k˙pu tohoto vozidla (pre vypnutie 0):", "OK", "SPAç");
		    
        case D_EDIT_TYPE_RECOLOUR:
		    ShowPlayerDialog(playerid, did_dealership_vehicle_recolour, DIALOG_STYLE_MSGBOX, "⁄PRAVA VOZIDLA", "{FFFFFF}> M· byù toto vozidlo prefarbiteænÈ v dealershipe?", "¡NO", "NIE");

		case D_EDIT_TYPE_FACTION:
		{
		    new
			    S_string[512],
				S_tempString[64];
			format(S_string, 512, "{FFFFFF}> Zadaj prosÌm ID typu frakcie alebo 0 pre vypnutie:\n\n");
			for(new i; i < sizeof(factionTypes); i++)
			{
			    format(S_tempString, 64, "[ID: %d] %s\n", i, factionTypes[i]);
			    strcat(S_string,S_tempString);
			}
		    ShowPlayerDialog(playerid, did_dealership_vehicle_faction, DIALOG_STYLE_INPUT, "⁄PRAVA VOZIDLA", S_string, "OK", "SPAç");
		}
	}
	return 1;
}

Dealership::Remove(playerid)
{
    new
		query[256]
	;

	mysql_format(MYSQL, query, sizeof query, "DELETE FROM dealership_places WHERE id='%d'", tmp_dealershipedit[playerid]);
	mysql_query(MYSQL, query,false);

    mysql_format(MYSQL, query, sizeof query, "DELETE FROM dealership_vehicles WHERE dealid='%d'", tmp_dealershipedit[playerid]);
	mysql_query(MYSQL, query,false);

	SendSuccess(playerid, "Dealership zmazan˝!");

	Dealership::ShowAllDealerships(playerid);
	return 1;
}

Dealership::RemoveVehicle(playerid)
{
    new
		query[256],Cache:cache,

		tmodel,tprice,tkredity
	;

	mysql_format(MYSQL, query, sizeof query, "SELECT * FROM dealership_vehicles WHERE dealid='%d' ORDER BY model", tmp_dealershipedit[playerid]);
	cache = mysql_query(MYSQL, query);

	cache_get_value_name_int(dealshcount[playerid],"model",tmodel);
	cache_get_value_name_int(dealshcount[playerid],"price",tprice);
	cache_get_value_name_int(dealshcount[playerid],"kredity",tkredity);

	cache_delete(cache);

	mysql_format(MYSQL, query, sizeof query, "DELETE FROM dealership_vehicles WHERE dealid='%d' AND model='%d' AND price='%d' AND kredity='%d' ORDER BY model",tmp_dealershipedit[playerid],tmodel,tprice,tkredity);
	mysql_query(MYSQL, query,false);

	SendSuccess(playerid, "Vozidlo zmazanÈ!");

	Dealership::ShowVehicles(playerid);
	return 1;
}

Dealership::SetRecolorable(playerid, val)
{
    new
		query[256],Cache:cache,

		tmodel,tprice,tkredity
	;

	mysql_format(MYSQL, query, sizeof query, "SELECT * FROM dealership_vehicles WHERE dealid='%d' ORDER BY model", tmp_dealershipedit[playerid]);
	cache = mysql_query(MYSQL, query);

	cache_get_value_name_int(dealshcount[playerid],"model",tmodel);
	cache_get_value_name_int(dealshcount[playerid],"price",tprice);
	cache_get_value_name_int(dealshcount[playerid],"kredity",tkredity);

	cache_delete(cache);

	mysql_format(MYSQL, query, sizeof query, "UPDATE dealership_vehicles SET recolourable='%d' WHERE dealid='%d' AND model='%d' AND price='%d' AND kredity='%d' ORDER BY model",val,tmp_dealershipedit[playerid],tmodel,tprice,tkredity);
	mysql_query(MYSQL, query,false);

	SendSuccess(playerid, "Hodnota upraven·!");

	Dealership::VehicleDetail(playerid, dealshcount[playerid]);
	return 1;
}

Dealership::SetFaction(playerid, val)
{
    new
		query[256],Cache:cache,

		tmodel,tprice,tkredity
	;

	mysql_format(MYSQL, query, sizeof query, "SELECT * FROM dealership_vehicles WHERE dealid='%d' ORDER BY model", tmp_dealershipedit[playerid]);
	cache = mysql_query(MYSQL, query);

	cache_get_value_name_int(dealshcount[playerid],"model",tmodel);
	cache_get_value_name_int(dealshcount[playerid],"price",tprice);
	cache_get_value_name_int(dealshcount[playerid],"kredity",tkredity);

	cache_delete(cache);

	mysql_format(MYSQL, query, sizeof query, "UPDATE dealership_vehicles SET factiontype%d='%d' WHERE dealid='%d' AND model='%d' AND price='%d' AND kredity='%d' ORDER BY model",tmp_factioneditiddeal[playerid]+1,val,tmp_dealershipedit[playerid],tmodel,tprice,tkredity);
	mysql_query(MYSQL, query,false);

	SendSuccess(playerid, "Hodnota upraven·!");

	Dealership::VehicleDetail(playerid, dealshcount[playerid]);
	return 1;
}

Dealership::SetPrice(playerid, val)
{
    new
		query[256],Cache:cache,

		tmodel,tprice,tkredity
	;

	mysql_format(MYSQL, query, sizeof query, "SELECT * FROM dealership_vehicles WHERE dealid='%d' ORDER BY model", tmp_dealershipedit[playerid]);
	cache = mysql_query(MYSQL, query);

	cache_get_value_name_int(dealshcount[playerid],"model",tmodel);
	cache_get_value_name_int(dealshcount[playerid],"price",tprice);
	cache_get_value_name_int(dealshcount[playerid],"kredity",tkredity);

	cache_delete(cache);

	mysql_format(MYSQL, query, sizeof query, "UPDATE dealership_vehicles SET price='%d' WHERE dealid='%d' AND model='%d' AND price='%d' AND kredity='%d' ORDER BY model",val,tmp_dealershipedit[playerid],tmodel,tprice,tkredity);
	mysql_query(MYSQL, query,false);

	SendSuccess(playerid, "Hodnota upraven·!");

	Dealership::VehicleDetail(playerid, dealshcount[playerid]);
	return 1;
}


Dealership::SetKredity(playerid, val)
{
    new
		query[256],Cache:cache,

		tmodel,tprice,tkredity
	;

	mysql_format(MYSQL, query, sizeof query, "SELECT * FROM dealership_vehicles WHERE dealid='%d' ORDER BY model", tmp_dealershipedit[playerid]);
	cache = mysql_query(MYSQL, query);

	cache_get_value_name_int(dealshcount[playerid],"model",tmodel);
	cache_get_value_name_int(dealshcount[playerid],"price",tprice);
	cache_get_value_name_int(dealshcount[playerid],"kredity",tkredity);

	cache_delete(cache);

	mysql_format(MYSQL, query, sizeof query, "UPDATE dealership_vehicles SET kredity='%d' WHERE dealid='%d' AND model='%d' AND price='%d' AND kredity='%d' ORDER BY model",val,tmp_dealershipedit[playerid],tmodel,tprice,tkredity);
	mysql_query(MYSQL, query,false);

	SendSuccess(playerid, "Hodnota upraven·!");

	Dealership::VehicleDetail(playerid, dealshcount[playerid]);
	return 1;
}

Dealership::SetDonator(playerid, val)
{
    new
		query[256],Cache:cache,

		tmodel,tprice,tkredity
	;

	mysql_format(MYSQL, query, sizeof query, "SELECT * FROM dealership_vehicles WHERE dealid='%d' ORDER BY model", tmp_dealershipedit[playerid]);
	cache = mysql_query(MYSQL, query);

	cache_get_value_name_int(dealshcount[playerid],"model",tmodel);
	cache_get_value_name_int(dealshcount[playerid],"price",tprice);
	cache_get_value_name_int(dealshcount[playerid],"kredity",tkredity);

	cache_delete(cache);

	mysql_format(MYSQL, query, sizeof query, "UPDATE dealership_vehicles SET donatorlevel='%d' WHERE dealid='%d' AND model='%d' AND price='%d' AND kredity='%d' ORDER BY model",val,tmp_dealershipedit[playerid],tmodel,tprice,tkredity);
	mysql_query(MYSQL, query,false);

	SendSuccess(playerid, "Hodnota upraven·!");

	Dealership::VehicleDetail(playerid, dealshcount[playerid]);
	return 1;
}

Dealership::AddNewVeh_internal(playerid,model)
{
	new query[256];
	mysql_format(MYSQL,query,sizeof query,"INSERT INTO dealership_vehicles (dealid,model) VALUES ('%d','%d')",tmp_dealershipedit[playerid],model);
	mysql_query(MYSQL,query,false);
	
	SCSuccess(playerid, "Pridal si vozidlo %s do %s. Ned· sa k˙più, k˝m ho nenastavÌö!!!", VehicleNames[model-400],dealershipenum[tmp_dealershipedit[playerid]][dealsh_Name]);
	
	Dealership::ShowVehicles(playerid);
	return 1;
}

Dealership::AddNewVeh(playerid)
{
    ShowPlayerDialog(playerid, did_dealership_detail_veh_new, DIALOG_STYLE_INPUT, "PRIDAç VOZIDLO", "{FFFFFF}> Zadaj n·zov alebo ID vozidla, ktorÈ chceö pridaù:", "OK", "SPAç");
	return 1;
}

Dealership::ShowVehicles(playerid)
{

	new query[128],Cache:cache,fstr[2048]="Model\tCena\nPridaù novÈ ...",tstr[128],tmodel,tprice;
	
	mysql_format(MYSQL, query, sizeof query, "SELECT * FROM dealership_vehicles WHERE dealid='%d' ORDER BY model", tmp_dealershipedit[playerid]);
	cache = mysql_query(MYSQL, query);
	
	for(new x, y = cache_num_rows(); x < y; x++)
	{
		cache_get_value_name_int(x, "model", tmodel);
		cache_get_value_name_int(x, "price", tprice);
		
		if(tmodel < 400)
		{
		    printf("[ERROR]: V databazi je nezname vozidlo v DEALERSHIPe id %d (model: %d).", tmp_dealershipedit[playerid], tmodel);
		    continue;
		}
		
		format(tstr, sizeof tstr,"\n%s\t%d$",VehicleNames[tmodel-400],tprice);
		strcat(fstr,tstr);
	}
	
	cache_delete(cache);
	
	ShowPlayerDialog(
	    playerid,
	    did_dealership_detail_vehs,
	    DIALOG_STYLE_TABLIST_HEADERS,
	    "ZOZNAM VOZIDIEL",
		fstr,
		"UPRAVIç",
		"SPAç"
	);

	return 1;
}

Dealership::Rename(playerid, inputtext[])
{

    format(dealershipenum[tmp_dealershipedit[playerid]][dealsh_Name], 64, inputtext);

    new query[256];
    mysql_format(MYSQL, query, sizeof query, "UPDATE dealership_places SET name = '%e' WHERE id='%d'", inputtext,tmp_dealershipedit[playerid]);
    mysql_query(MYSQL, query,false);

    SendSuccess(playerid, "Dealership premenovan˝!");

    Dealership::ShowDetail(playerid);
	return 1;
}

Dealership::ShowRename(playerid)
{
	ShowPlayerDialog(playerid, did_dealership_detail_rename, DIALOG_STYLE_INPUT, "PREMENOVAç DEALERSHIP", "{FFFFFF}> Zadaj nov˝ n·zov dealershipu:", "OK", "SPAç");
	return 1;
}

Dealership::EditMultiplier(playerid, inputtext)
{

    dealershipenum[tmp_dealershipedit[playerid]][dealsh_Multiplier]=inputtext;

    new query[256];
    mysql_format(MYSQL, query, sizeof query, "UPDATE dealership_places SET multiplier = '%d' WHERE id='%d'", inputtext,tmp_dealershipedit[playerid]);
    mysql_query(MYSQL, query,false);

    SendSuccess(playerid, "Dealership m· nov˝ multiplier!");

    Dealership::ShowDetail(playerid);
	return 1;
}

Dealership::ShowEditMultiplier(playerid)
{
	ShowPlayerDialog(playerid, did_dealership_detail_multiplie, DIALOG_STYLE_INPUT, "MULTIPLIER DEALERSHIPU", "{FFFFFF}> Zadaj nov˝ multiplier dealershipu:", "OK", "SPAç");
	return 1;
}

Dealership::SaveOnfoot(playerid)
{
	new
	    Float:X, Float:Y, Float:Z,
	    id = tmp_dealershipedit[playerid]
	;
	
	GetPlayerPos(playerid, X, Y, Z);
	
	if(dealershipenum[id][dealsh_pX]!=0.0&&dealershipenum[id][dealsh_pY]!=0.0)
	{
	    DestroyDynamicArea(dealershipenum[id][dealsh_AreaId]);
	    DestroyDynamicPickup(dealershipenum[id][dealsh_PickupId]);
	    DestroyDynamic3DTextLabel(dealershipenum[id][dealsh_LabelId]);
	}
	
	dealershipenum[id][dealsh_pX] = X;
	dealershipenum[id][dealsh_pY] = Y;
	dealershipenum[id][dealsh_pZ] = Z;
	dealershipenum[id][dealsh_pVW] = GetPlayerVirtualWorld(playerid);
	dealershipenum[id][dealsh_pINT] = GetPlayerInterior(playerid);
	
	dealershipenum[id][dealsh_AreaId] 	= CreateDynamicSphere(X,Y,Z, 2.5, dealershipenum[id][dealsh_pVW],dealershipenum[id][dealsh_pINT]);
	dealershipenum[id][dealsh_LabelId] 	= CreateDynamic3DTextLabel("/buyvehicle", 0xFFFFFFFF, X, Y, Z, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, dealershipenum[id][dealsh_pVW], dealershipenum[id][dealsh_pINT], -1, 10.0);
	dealershipenum[id][dealsh_PickupId] = CreateDynamicPickup(1239, 1, X, Y, Z, dealershipenum[id][dealsh_pVW], dealershipenum[id][dealsh_pINT], -1, 80.0, -1, 0);

	new query[256+64];
    mysql_format(MYSQL, query, sizeof query, "UPDATE dealership_places SET x='%f',y='%f',z='%f',vw='%d',interior='%d' WHERE id='%d'", X,Y,Z,dealershipenum[id][dealsh_pVW],dealershipenum[id][dealsh_pINT],tmp_dealershipedit[playerid]);
    mysql_tquery(MYSQL, query);
    
    SendSuccess(playerid, "Nov· pozÌcia obchodu bola nastaven·!");
	return 1;
}

Dealership::SaveIncar(playerid)
{
    new
	    Float:X, Float:Y, Float:Z, Float:A,
	    id = tmp_dealershipedit[playerid]
	;

	GetVehiclePos(GetPlayerVehicleID(playerid), X, Y, Z);
	GetVehicleZAngle(GetPlayerVehicleID(playerid), A);

	dealershipenum[id][dealsh_vX] = X;
	dealershipenum[id][dealsh_vY] = Y;
	dealershipenum[id][dealsh_vZ] = Z;
	dealershipenum[id][dealsh_vA] = A;
	dealershipenum[id][dealsh_pINT] = GetPlayerInterior(playerid);

	new query[256+64];
    mysql_format(MYSQL, query, sizeof query, "UPDATE dealership_places SET vx='%f',vy='%f',vz='%f',va='%f' WHERE id='%d'", X,Y,Z,A,tmp_dealershipedit[playerid]);
    mysql_tquery(MYSQL, query);
    
    SendSuccess(playerid, "Nov· pozÌcia k˙penÈho auta bola nastaven·!");
    return 1;
}

Dealership::Shop(playerid)
{

	new id = tmp_dealershipedit[playerid];
	for(new x; x < MAX_DEALERSHIP_VEH; x++)
	{
	    dealshvehicles[id][x][dealveh_Model] = 0;
	}
    
	new query[128],Cache:cache;
	mysql_format(MYSQL, query, sizeof query, "SELECT * FROM dealership_vehicles WHERE dealid='%d' ORDER BY model",tmp_dealershipedit[playerid]);
	cache = mysql_query(MYSQL, query);
	
	for(new x, y=cache_num_rows(); x<y;x++)
	{
	    cache_get_value_name_int(x,"model",dealshvehicles[id][x][dealveh_Model]);
	    cache_get_value_name_int(x,"price",dealshvehicles[id][x][dealveh_Price]);
	    cache_get_value_name_int(x,"kredity",dealshvehicles[id][x][dealveh_PriceKr]);
	    cache_get_value_name_int(x,"donatorlevel",dealshvehicles[id][x][dealveh_Donator]);
	    cache_get_value_name_int(x,"recolourable",dealshvehicles[id][x][dealveh_Recolor]);
	    cache_get_value_name_int(x,"factiontype1",dealshvehicles[id][x][dealveh_Fact1]);
	    cache_get_value_name_int(x,"factiontype2",dealshvehicles[id][x][dealveh_Fact2]);
	    cache_get_value_name_int(x,"factiontype3",dealshvehicles[id][x][dealveh_Fact3]);
	    cache_get_value_name_int(x,"factiontype4",dealshvehicles[id][x][dealveh_Fact4]);
	    cache_get_value_name_int(x,"factiontype5",dealshvehicles[id][x][dealveh_Fact5]);
	    
	    dealshvehicles[id][x][dealveh_Price] = floatround(dealshvehicles[id][x][dealveh_Price] * (float(dealershipenum[id][dealsh_Multiplier])/1000.0), floatround_round);
	}
	
	cache_delete(cache);
	
	////////////////////////////////////////////////////////////////////////////
	
	isindealship[playerid]  = true;
	dealshnoresponse[playerid]= false;
	dealshipIndex[playerid] = 0;
	dealshipCol1[playerid]  = 1;
	dealshipCol2[playerid]  = 1;
	
	new count = 0, maxindex = -1;

	for(new x; x < MAX_DEALERSHIP_VEH; x++)
	{
	    if(dealshvehicles[id][x][dealveh_Model] == 0) continue;
	    maxindex = x;
	}
	
	printf("[DEALERSHIP DEBUG]: Maximalny index: %d", maxindex);
	
	while((dealshvehicles[id][dealshipIndex[playerid]][dealveh_Donator] > GetPlayerDonatorLevel(playerid)) ||
		(dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact1] != 0 && dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact1] != GetPlayerFactionType(playerid)) ||
		(dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact2] != 0 && dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact2] != GetPlayerFactionType(playerid)) ||
		(dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact3] != 0 && dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact3] != GetPlayerFactionType(playerid)) ||
		(dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact4] != 0 && dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact4] != GetPlayerFactionType(playerid)) ||
		(dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact5] != 0 && dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact5] != GetPlayerFactionType(playerid))
	)
	{
	    count ++;
	    if(count >= 500) return 1;
	    dealshipIndex[playerid] ++;
		if(dealshipIndex[playerid] > maxindex)
		    dealshipIndex[playerid] = 0;
		    
        printf("[DEALERSHIP DEBUG]: Nenasiel som, prechadzam na index: %d", dealshipIndex[playerid]);
	}
	
	////////////////////////////////////////////////////////////////////////////
	
	Dealership::CreateTextdraws(playerid);
	
	new
	    tstr[128]
	;
	
	format(tstr,sizeof tstr,"%s",dealershipenum[id][dealsh_Name]);
	for(new x; x < strlen(tstr); x++) tstr[x] = toupper(tstr[x]);
	PlayerTextDrawSetString(playerid, dealershipTD[playerid][2], tstr);
	
	PlayerTextDrawSetPreviewModel(playerid, dealershipTD[playerid][4], dealshvehicles[id][dealshipIndex[playerid]][dealveh_Model]);
	PlayerTextDrawSetPreviewModel(playerid, dealershipTD[playerid][5], dealshvehicles[id][dealshipIndex[playerid]][dealveh_Model]);
	PlayerTextDrawSetPreviewModel(playerid, dealershipTD[playerid][6], dealshvehicles[id][dealshipIndex[playerid]][dealveh_Model]);
	
	format(tstr,sizeof tstr,"%s",VehicleNames[dealshvehicles[id][dealshipIndex[playerid]][dealveh_Model]-400]);
	for(new x; x < strlen(tstr); x++) tstr[x] = toupper(tstr[x]);
	PlayerTextDrawSetString(playerid, dealershipTD[playerid][7], tstr);
	
	format(tstr, sizeof tstr, "$%d", dealshvehicles[id][dealshipIndex[playerid]][dealveh_Price]);
	PlayerTextDrawSetString(playerid, dealershipTD[playerid][11], tstr);
	
	if(dealshvehicles[id][dealshipIndex[playerid]][dealveh_PriceKr] == 0) format(tstr, sizeof tstr, "nedostupne");
	else format(tstr, sizeof tstr, "%d kr", dealshvehicles[id][dealshipIndex[playerid]][dealveh_PriceKr]);
	PlayerTextDrawSetString(playerid, dealershipTD[playerid][13], tstr);
	
	////////////////////////////////////////////////////////////////////////////
	
	PlayerTextDrawShow(playerid, dealershipTD[playerid][0]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][1]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][2]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][3]);
	
	//preview models
	PlayerTextDrawShow(playerid, dealershipTD[playerid][4]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][5]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][6]);
	
	PlayerTextDrawShow(playerid, dealershipTD[playerid][7]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][8]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][9]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][10]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][11]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][12]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][13]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][14]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][15]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][16]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][17]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][18]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][19]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][20]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][21]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][23]);
	
	SelectTextDraw(playerid, 0x78AD69FF);
	
	return 1;
}

Dealership::CreateTextdraws(playerid)
{
    dealershipTD[playerid][0] = CreatePlayerTextDraw(playerid, 317.047607, 121.733352, "box");
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][0], 0.000000, 22.609535);
	PlayerTextDrawTextSize(playerid, dealershipTD[playerid][0], 0.000000, 310.000000);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][0], 2);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][0], -1);
	PlayerTextDrawUseBox(playerid, dealershipTD[playerid][0], 1);
	PlayerTextDrawBoxColor(playerid, dealershipTD[playerid][0], 255);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][0], 0);

	dealershipTD[playerid][1] = CreatePlayerTextDraw(playerid, 317.047607, 124.293350, "box");
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][1], 0.000000, 22.038103);
	PlayerTextDrawTextSize(playerid, dealershipTD[playerid][1], 0.000000, 305.000000);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][1], 2);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][1], -1);
	PlayerTextDrawUseBox(playerid, dealershipTD[playerid][1], 1);
	PlayerTextDrawBoxColor(playerid, dealershipTD[playerid][1], -1061109505);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][1], 0);

	dealershipTD[playerid][2] = CreatePlayerTextDraw(playerid, 169.999908, 126.853378, "_"); //n·zov
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][2], 0.327618, 1.339733);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][2], -2139062017);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][2], 0);

	dealershipTD[playerid][3] = CreatePlayerTextDraw(playerid, 457.619201, 124.293334, "_");
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][3], 0.420951, 1.203199);
	PlayerTextDrawTextSize(playerid, dealershipTD[playerid][3], 15.000000, 15.000000);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][3], 255);
	PlayerTextDrawUseBox(playerid, dealershipTD[playerid][3], 1);
	PlayerTextDrawBoxColor(playerid, dealershipTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][3], 0);
	PlayerTextDrawSetSelectable(playerid, dealershipTD[playerid][3], true);

	dealershipTD[playerid][4] = CreatePlayerTextDraw(playerid, 163.666839, 96.546714, "");
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][4], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, dealershipTD[playerid][4], 150.000000, 150.000000);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][4], 0);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][4], 5);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][4], 0);
	PlayerTextDrawSetPreviewModel(playerid, dealershipTD[playerid][4], 400);
	PlayerTextDrawSetPreviewRot(playerid, dealershipTD[playerid][4], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, dealershipTD[playerid][4], 1, 1);

	dealershipTD[playerid][5] = CreatePlayerTextDraw(playerid, 162.523986, 153.293334, "");
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][5], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, dealershipTD[playerid][5], 150.000000, 150.000000);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][5], 0);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][5], 5);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][5], 0);
	PlayerTextDrawSetPreviewModel(playerid, dealershipTD[playerid][5], 400);
	PlayerTextDrawSetPreviewRot(playerid, dealershipTD[playerid][5], 0.000000, 0.000000, -30.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, dealershipTD[playerid][5], 1, 1);

	dealershipTD[playerid][6] = CreatePlayerTextDraw(playerid, 163.666824, 211.746612, "");
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][6], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, dealershipTD[playerid][6], 150.000000, 150.000000);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][6], 0);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][6], 5);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][6], 0);
	PlayerTextDrawSetPreviewModel(playerid, dealershipTD[playerid][6], 400);
	PlayerTextDrawSetPreviewRot(playerid, dealershipTD[playerid][6], 0.000000, 0.000000, 180.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, dealershipTD[playerid][6], 1, 1);

	dealershipTD[playerid][7] = CreatePlayerTextDraw(playerid, 381.428405, 155.440032, "_"); //n·zov auta
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][7], 0.376379, 1.497599);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][7], 2);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][7], 255);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][7], 255);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][7], 0);

	dealershipTD[playerid][8] = CreatePlayerTextDraw(playerid, 309.190582, 155.426666, "ld_beat:left");
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][8], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, dealershipTD[playerid][8], 15.000000, 15.000000);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][8], 1);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][8], -1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][8], 255);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][8], 4);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][8], 0);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][8], 0);
	PlayerTextDrawSetSelectable(playerid, dealershipTD[playerid][8], true);

	dealershipTD[playerid][9] = CreatePlayerTextDraw(playerid, 439.095184, 155.000000, "ld_beat:right");
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][9], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, dealershipTD[playerid][9], 15.000000, 15.000000);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][9], 1);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][9], -1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][9], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][9], 255);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][9], 4);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][9], 0);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][9], 0);
	PlayerTextDrawSetSelectable(playerid, dealershipTD[playerid][9], true);

	dealershipTD[playerid][10] = CreatePlayerTextDraw(playerid, 381.047454, 185.306671, "CENA VOZIDLA");
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][10], 0.221713, 1.002666);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][10], 2);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][10], -2139062017);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][10], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][10], 255);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][10], 0);

	dealershipTD[playerid][11] = CreatePlayerTextDraw(playerid, 381.047454, 195.119995, "$0");
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][11], 0.317332, 1.420798);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][11], 2);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][11], 8388863);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][11], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][11], 255);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][11], 0);

	dealershipTD[playerid][12] = CreatePlayerTextDraw(playerid, 381.047454, 215.173309, "CENA VOZIDLA (KREDITY)");
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][12], 0.221713, 1.002666);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][12], 2);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][12], -2139062017);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][12], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][12], 255);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][12], 1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][12], 0);

	dealershipTD[playerid][13] = CreatePlayerTextDraw(playerid, 381.047454, 223.706634, "nedostupne");
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][13], 0.317332, 1.420798);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][13], 2);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][13], -2147450625);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][13], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][13], 255);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][13], 1);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][13], 1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][13], 0);

	dealershipTD[playerid][14] = CreatePlayerTextDraw(playerid, 381.047454, 241.626617, "PRIMARNA FARBA");
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][14], 0.221713, 1.002666);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][14], 2);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][14], -2139062017);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][14], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][14], 255);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][14], 1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][14], 0);

	dealershipTD[playerid][15] = CreatePlayerTextDraw(playerid, 381.047454, 249.306610, "1");
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][15], 0.317332, 1.420798);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][15], 2);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][15], 255);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][15], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][15], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][15], 255);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][15], 1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][15], 0);

	dealershipTD[playerid][16] = CreatePlayerTextDraw(playerid, 358.714294, 251.426574, "ld_beat:left");
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][16], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, dealershipTD[playerid][16], 10.000000, 10.000000);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][16], 1);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][16], -1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][16], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][16], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][16], 255);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][16], 4);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][16], 0);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][16], 0);
	PlayerTextDrawSetSelectable(playerid, dealershipTD[playerid][16], true);

	dealershipTD[playerid][17] = CreatePlayerTextDraw(playerid, 394.523681, 251.426574, "ld_beat:right");
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][17], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, dealershipTD[playerid][17], 10.000000, 10.000000);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][17], 1);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][17], -1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][17], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][17], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][17], 255);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][17], 4);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][17], 0);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][17], 0);
	PlayerTextDrawSetSelectable(playerid, dealershipTD[playerid][17], true);

	dealershipTD[playerid][18] = CreatePlayerTextDraw(playerid, 381.047454, 263.813262, "SEKUNDARNA FARBA");
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][18], 0.221713, 1.002666);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][18], 2);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][18], -2139062017);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][18], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][18], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][18], 255);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][18], 1);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][18], 1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][18], 0);

	dealershipTD[playerid][19] = CreatePlayerTextDraw(playerid, 381.047454, 271.919921, "1");
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][19], 0.317332, 1.420798);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][19], 2);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][19], 255);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][19], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][19], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][19], 255);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][19], 1);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][19], 1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][19], 0);

	dealershipTD[playerid][20] = CreatePlayerTextDraw(playerid, 358.333343, 274.039886, "ld_beat:left");
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][20], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, dealershipTD[playerid][20], 10.000000, 10.000000);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][20], 1);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][20], -1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][20], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][20], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][20], 255);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][20], 4);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][20], 0);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][20], 0);
	PlayerTextDrawSetSelectable(playerid, dealershipTD[playerid][20], true);

	dealershipTD[playerid][21] = CreatePlayerTextDraw(playerid, 395.285583, 274.039886, "ld_beat:right");
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][21], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, dealershipTD[playerid][21], 10.000000, 10.000000);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][21], 1);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][21], -1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][21], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][21], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][21], 255);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][21], 4);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][21], 0);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][21], 0);
	PlayerTextDrawSetSelectable(playerid, dealershipTD[playerid][21], true);

	dealershipTD[playerid][22] = CreatePlayerTextDraw(playerid, 381.809539, 166.533355, "TOTO VOZIDLO JE IBA PRE FRAKCIE");
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][22], 0.175238, 0.785066);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][22], 2);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][22], -2139062017);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][22], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][22], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][22], 255);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][22], 1);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][22], 1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][22], 0);

	dealershipTD[playerid][23] = CreatePlayerTextDraw(playerid, 382.571441, 296.666595, "KUPIT VOZIDLO");
	PlayerTextDrawLetterSize(playerid, dealershipTD[playerid][23], 0.266666, 1.143468);
	PlayerTextDrawTextSize(playerid, dealershipTD[playerid][23], 10.000000, 97.000000);
	PlayerTextDrawAlignment(playerid, dealershipTD[playerid][23], 2);
	PlayerTextDrawColor(playerid, dealershipTD[playerid][23], -1061109505);
	PlayerTextDrawUseBox(playerid, dealershipTD[playerid][23], 1);
	PlayerTextDrawBoxColor(playerid, dealershipTD[playerid][23], 673720575);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][23], 0);
	PlayerTextDrawSetOutline(playerid, dealershipTD[playerid][23], 0);
	PlayerTextDrawBackgroundColor(playerid, dealershipTD[playerid][23], 255);
	PlayerTextDrawFont(playerid, dealershipTD[playerid][23], 1);
	PlayerTextDrawSetProportional(playerid, dealershipTD[playerid][23], 1);
	PlayerTextDrawSetShadow(playerid, dealershipTD[playerid][23], 0);
	PlayerTextDrawSetSelectable(playerid, dealershipTD[playerid][23], true);
	return 1;
}

Dealership::DestroyTextdraws(playerid)
{
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][0]);
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][1]);
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][2]);
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][3]);
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][4]);
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][5]);
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][6]);
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][7]);
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][8]);
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][9]);
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][10]);
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][11]);
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][12]);
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][13]);
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][14]);
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][15]);
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][16]);
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][17]);
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][18]);
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][19]);
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][20]);
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][21]);
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][22]);
	PlayerTextDrawDestroy(playerid, dealershipTD[playerid][23]);
}

Dealership::Close(playerid)
{
    isindealship[playerid]  = false;
	dealshipIndex[playerid] = 0;
	dealshipCol1[playerid]  = 1;
	dealshipCol2[playerid]  = 1;
	Dealership::DestroyTextdraws(playerid);
	CancelSelectTextDraw(playerid);
	return 1;
}

Dealership::NextVehicle(playerid)
{
	new
		id = tmp_dealershipedit[playerid],
		maxindex = -1
	;

	for(new x; x < MAX_DEALERSHIP_VEH; x++)
	{
	    if(dealshvehicles[id][x][dealveh_Model] == 0) continue;
	    maxindex = x;
	}

	dealshipIndex[playerid] ++;

	if(dealshipIndex[playerid] >= maxindex)
	    dealshipIndex[playerid] = 0;

	new count = 0;
	while((dealshvehicles[id][dealshipIndex[playerid]][dealveh_Donator] > GetPlayerDonatorLevel(playerid)) ||
		(dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact1] != 0 && dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact1] != GetPlayerFactionType(playerid)) ||
		(dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact2] != 0 && dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact2] != GetPlayerFactionType(playerid)) ||
		(dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact3] != 0 && dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact3] != GetPlayerFactionType(playerid)) ||
		(dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact4] != 0 && dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact4] != GetPlayerFactionType(playerid)) ||
		(dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact5] != 0 && dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact5] != GetPlayerFactionType(playerid))
	)
	{
	    count ++;
	    if(count >= 350) return 1;
	    dealshipIndex[playerid] ++;
		if(dealshipIndex[playerid] >= maxindex)
		    dealshipIndex[playerid] = 0;
	}

	////////////////////////////////////////////////////////////////////////////

	new
	    tstr[64]
	;

	PlayerTextDrawSetPreviewModel(playerid, dealershipTD[playerid][4], dealshvehicles[id][dealshipIndex[playerid]][dealveh_Model]);
	PlayerTextDrawSetPreviewModel(playerid, dealershipTD[playerid][5], dealshvehicles[id][dealshipIndex[playerid]][dealveh_Model]);
	PlayerTextDrawSetPreviewModel(playerid, dealershipTD[playerid][6], dealshvehicles[id][dealshipIndex[playerid]][dealveh_Model]);

	format(tstr,sizeof tstr,"%s",VehicleNames[dealshvehicles[id][dealshipIndex[playerid]][dealveh_Model]-400]);
	for(new x; x < strlen(tstr); x++) tstr[x] = toupper(tstr[x]);
	PlayerTextDrawSetString(playerid, dealershipTD[playerid][7], tstr);

	format(tstr, sizeof tstr, "$%d", dealshvehicles[id][dealshipIndex[playerid]][dealveh_Price]);
	PlayerTextDrawSetString(playerid, dealershipTD[playerid][11], tstr);

	if(dealshvehicles[id][dealshipIndex[playerid]][dealveh_PriceKr] == 0) format(tstr, sizeof tstr, "nedostupne");
	else format(tstr, sizeof tstr, "%d kr", dealshvehicles[id][dealshipIndex[playerid]][dealveh_PriceKr]);
	PlayerTextDrawSetString(playerid, dealershipTD[playerid][13], tstr);


	PlayerTextDrawShow(playerid, dealershipTD[playerid][4]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][5]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][6]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][7]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][11]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][13]);

	if(dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact1] != 0)
	    PlayerTextDrawShow(playerid, dealershipTD[playerid][22]);
	else
	    PlayerTextDrawHide(playerid, dealershipTD[playerid][22]);

	return 1;
}

Dealership::PrevVehicle(playerid)
{
	new
		id = tmp_dealershipedit[playerid],
		maxindex = -1
	;
	
	for(new x; x < MAX_DEALERSHIP_VEH; x++)
	{
	    if(dealshvehicles[id][x][dealveh_Model] == 0) continue;
	    maxindex = x;
	}
	
	dealshipIndex[playerid] --;
	
	if(dealshipIndex[playerid] < 0)
	    dealshipIndex[playerid] = maxindex;
	    
	new count = 0;
	while((dealshvehicles[id][dealshipIndex[playerid]][dealveh_Donator] > GetPlayerDonatorLevel(playerid)) ||
		(dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact1] != 0 && dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact1] != GetPlayerFactionType(playerid)) ||
		(dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact2] != 0 && dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact2] != GetPlayerFactionType(playerid)) ||
		(dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact3] != 0 && dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact3] != GetPlayerFactionType(playerid)) ||
		(dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact4] != 0 && dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact4] != GetPlayerFactionType(playerid)) ||
		(dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact5] != 0 && dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact5] != GetPlayerFactionType(playerid))
	)
	{
	    count ++;
	    if(count >= 500) return 1;
	    dealshipIndex[playerid] --;
		if(dealshipIndex[playerid] < 0)
		    dealshipIndex[playerid] = maxindex;
	}
	
	////////////////////////////////////////////////////////////////////////////
	
	new
	    tstr[64]
	;

	PlayerTextDrawSetPreviewModel(playerid, dealershipTD[playerid][4], dealshvehicles[id][dealshipIndex[playerid]][dealveh_Model]);
	PlayerTextDrawSetPreviewModel(playerid, dealershipTD[playerid][5], dealshvehicles[id][dealshipIndex[playerid]][dealveh_Model]);
	PlayerTextDrawSetPreviewModel(playerid, dealershipTD[playerid][6], dealshvehicles[id][dealshipIndex[playerid]][dealveh_Model]);

	format(tstr,sizeof tstr,"%s",VehicleNames[dealshvehicles[id][dealshipIndex[playerid]][dealveh_Model]-400]);
	for(new x; x < strlen(tstr); x++) tstr[x] = toupper(tstr[x]);
	PlayerTextDrawSetString(playerid, dealershipTD[playerid][7], tstr);

	format(tstr, sizeof tstr, "$%d", dealshvehicles[id][dealshipIndex[playerid]][dealveh_Price]);
	PlayerTextDrawSetString(playerid, dealershipTD[playerid][11], tstr);

	if(dealshvehicles[id][dealshipIndex[playerid]][dealveh_PriceKr] == 0) format(tstr, sizeof tstr, "nedostupne");
	else format(tstr, sizeof tstr, "%d kr", dealshvehicles[id][dealshipIndex[playerid]][dealveh_PriceKr]);
	PlayerTextDrawSetString(playerid, dealershipTD[playerid][13], tstr);
	
	
	PlayerTextDrawShow(playerid, dealershipTD[playerid][4]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][5]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][6]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][7]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][11]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][13]);
	
	if(dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact1] != 0)
	    PlayerTextDrawShow(playerid, dealershipTD[playerid][22]);
	else
	    PlayerTextDrawHide(playerid, dealershipTD[playerid][22]);
	
	return 1;
}

Dealership::NextColor(playerid, primorsec)
{
	if(primorsec == 1) dealshipCol1[playerid] ++;
	else dealshipCol2[playerid] ++;

	if(dealshipCol1[playerid] < 0) dealshipCol1[playerid] = 255;
	if(dealshipCol2[playerid] < 0) dealshipCol2[playerid] = 255;
	if(dealshipCol1[playerid] > 255) dealshipCol1[playerid] = 0;
	if(dealshipCol2[playerid] > 255) dealshipCol2[playerid] = 0;

	new
	    tstr[5]
	;

	format(tstr, sizeof tstr, "%d", dealshipCol1[playerid]);
	PlayerTextDrawSetString(playerid, dealershipTD[playerid][15], tstr);

	format(tstr, sizeof tstr, "%d", dealshipCol2[playerid]);
	PlayerTextDrawSetString(playerid, dealershipTD[playerid][19], tstr);

    PlayerTextDrawSetPreviewVehCol(playerid, dealershipTD[playerid][4], dealshipCol1[playerid], dealshipCol2[playerid]);
    PlayerTextDrawSetPreviewVehCol(playerid, dealershipTD[playerid][5], dealshipCol1[playerid], dealshipCol2[playerid]);
    PlayerTextDrawSetPreviewVehCol(playerid, dealershipTD[playerid][6], dealshipCol1[playerid], dealshipCol2[playerid]);

    PlayerTextDrawShow(playerid, dealershipTD[playerid][4]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][5]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][6]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][15]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][19]);

	return 1;
}

Dealership::PrevColor(playerid, primorsec)
{
	if(primorsec == 1) dealshipCol1[playerid] --;
	else dealshipCol2[playerid] --;

	if(dealshipCol1[playerid] < 0) dealshipCol1[playerid] = 255;
	if(dealshipCol2[playerid] < 0) dealshipCol2[playerid] = 255;
	if(dealshipCol1[playerid] > 255) dealshipCol1[playerid] = 0;
	if(dealshipCol2[playerid] > 255) dealshipCol2[playerid] = 0;

	new
	    tstr[5]
	;

	format(tstr, sizeof tstr, "%d", dealshipCol1[playerid]);
	PlayerTextDrawSetString(playerid, dealershipTD[playerid][15], tstr);

	format(tstr, sizeof tstr, "%d", dealshipCol2[playerid]);
	PlayerTextDrawSetString(playerid, dealershipTD[playerid][19], tstr);

    PlayerTextDrawSetPreviewVehCol(playerid, dealershipTD[playerid][4], dealshipCol1[playerid], dealshipCol2[playerid]);
    PlayerTextDrawSetPreviewVehCol(playerid, dealershipTD[playerid][5], dealshipCol1[playerid], dealshipCol2[playerid]);
    PlayerTextDrawSetPreviewVehCol(playerid, dealershipTD[playerid][6], dealshipCol1[playerid], dealshipCol2[playerid]);

    PlayerTextDrawShow(playerid, dealershipTD[playerid][4]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][5]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][6]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][15]);
	PlayerTextDrawShow(playerid, dealershipTD[playerid][19]);

	return 1;
}

Dealership::Buy(playerid)
{
	new
		id = tmp_dealershipedit[playerid];
		
	////////////////////////////////////////////////////////////////////////////
	
	new
		model = dealshvehicles[id][dealshipIndex[playerid]][dealveh_Model],
		vehicleid,
		SPZ[24];

	vehicleid = CreateVehicle(model,dealershipenum[id][dealsh_vX],dealershipenum[id][dealsh_vY],dealershipenum[id][dealsh_vZ],dealershipenum[id][dealsh_vA], dealshipCol1[playerid], dealshipCol2[playerid], -1, 0);

	strcat(SPZ, SPZ_PATTERN);

	for(new i; i < sizeof(SPZ); i++)
	{
		if(SPZ[i] == '1')
		{
		    SPZ[i] = getRandomLetter();
		}
		else if(SPZ[i] == '2')
		{
		    SPZ[i] = (48 + random(10));
		}

		continue;
	}

	SetVehicleNumberPlate(vehicleid, SPZ);
	SetVehicleHealth(vehicleid, 1000.0);
	veh_IsDeath[vehicleid] = false;

	vEnum[vehicleid][v_Color_1] = dealshipCol1[playerid];
	vEnum[vehicleid][v_Color_2] = dealshipCol2[playerid];

	vEnum[vehicleid][v_bazar_Price]   = 0;
	vEnum[vehicleid][v_bazar_Buyout]   = 0;
	vEnum[vehicleid][v_bazar_DateAdded]   = 0;
	vEnum[vehicleid][v_bazar_BoughtFor]   = 0;
	format(vEnum[vehicleid][v_bazar_Desc], 256, "");
	format(vEnum[vehicleid][v_bazar_AddedBy], MAX_PLAYER_NAME+1, "");

	vEnum[vehicleid][v_Temporary] = false;
	vEnum[vehicleid][v_ELM] = false;
	vEnum[vehicleid][v_Radar] = false;
	vEnum[vehicleid][v_Taxameter] = false;
	vEnum[vehicleid][v_TaxameterItem] = 0;
	vEnum[vehicleid][v_Alarm] = false;
	vEnum[vehicleid][v_NoBreakin] = 0;
	vEnum[vehicleid][v_TitWindows] = 0;

	format(vEnum[vehicleid][v_SPZ], 24, SPZ);
	format(vEnum[vehicleid][v_Owner], 30, ReturnName(playerid));
	vEnum[vehicleid][v_Fuel] = 100;
	vEnum[vehicleid][v_FuelType] = vehicleFuelTypes[model-400];
	vEnum[vehicleid][v_Battery] = 1000;
	vEnum[vehicleid][v_Siren] = 0;
	vEnum[vehicleid][v_MileAge] = 0.0;
	vEnum[vehicleid][v_Nitrous] = 0.0;
	vEnum[vehicleid][v_Faction] = 0;
	vEnum[vehicleid][v_CarRadio] = 0;
	vEnum[vehicleid][v_AlarmItem] = 0;

	vEnum[vehicleid][v_Oil] = 100.0;

	vEnum[vehicleid][v_def_SpawnX] = dealershipenum[id][dealsh_vX];
	vEnum[vehicleid][v_def_SpawnY] = dealershipenum[id][dealsh_vY];
	vEnum[vehicleid][v_def_SpawnZ] = dealershipenum[id][dealsh_vZ];
	vEnum[vehicleid][v_def_SpawnA] = dealershipenum[id][dealsh_vA];
	vEnum[vehicleid][v_def_SpawnVW] = 0;
	vEnum[vehicleid][v_def_SpawnINT] = 0;
	vEnum[vehicleid][v_def_Health] = 1000.0;

	vEnum[vehicleid][v_Sun_LDoor] = 0;
	vEnum[vehicleid][v_Sun_RDoor] = 0;
	vEnum[vehicleid][v_Sun_Hood] = 0;
	vEnum[vehicleid][v_Sun_Boot] = 0;
	vEnum[vehicleid][v_Sun_FBumper] = 0;
	vEnum[vehicleid][v_Sun_RBumper] = 0;


	new
		S_query[1024];

	mysql_format(MYSQL, S_query, 1024, "INSERT INTO char_vehicles (SPZ, Model, Park_X, Park_Y, Park_Z, Park_A, Park_VW, Park_INT, Color_1, Color_2, Paintjob, Fuel, Battery, Health, Owner, SecondOwner, isUnParked) VALUES ('%e', '%d', '%f', '%f', '%f', '%f', '0', '0', '%d', '%d', '3', '100', '1000', '1000.0', '%e', '', '1')",

		SPZ, model,
		dealershipenum[id][dealsh_vX],dealershipenum[id][dealsh_vY],dealershipenum[id][dealsh_vZ],dealershipenum[id][dealsh_vA],
		dealshipCol1[playerid], dealshipCol2[playerid],
		ReturnName(playerid));

	mysql_tquery(MYSQL, S_query);

	PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
	
	return 1;
}

Dealership::Proceed(playerid)
{
    new
		id = tmp_dealershipedit[playerid]
	;
	
	if(dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact1] != 0 ||
	    dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact2] != 0 ||
	    dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact3] != 0 ||
	    dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact4] != 0 ||
	    dealshvehicles[id][dealshipIndex[playerid]][dealveh_Fact5] != 0)
	{
	    if(GetPlayerFactionRank(playerid) < 9)
	    {
	        SendError(playerid, "Na k˙pu tohoto vozidla potrebujeö frakËn˝ rank 9 alebo 10!");
	        return 1;
	    }
	}
	
	dealshnoresponse[playerid] = true;
	if(dealshvehicles[id][dealshipIndex[playerid]][dealveh_PriceKr] > 0)
	{
	    // d· sa aj za kredity
	    new fstr[ 256 ];
	    format(fstr, sizeof fstr, "{ffffff}> {6cad4e}K˙più za %d$\n{ffffff}> {c775d6}K˙più za kredity (%d kreditov)\n{ffffff}< Sp‰ù do v˝beru", dealshvehicles[id][dealshipIndex[playerid]][dealveh_Price], dealshvehicles[id][dealshipIndex[playerid]][dealveh_PriceKr]);
	    ShowPlayerDialog(playerid, did_dealership_confirm, DIALOG_STYLE_LIST, "V›BER", fstr, "VYBRAç", "SPAç");
	}
	else
	{
	    new fstr[ 256 ];
	    format(fstr, sizeof fstr, "{FFFFFF}> SkutoËne chceö k˙più vozidlo {6793db}%s {ffffff}za {6793db}%d${ffffff}?\n> Bude napÌsanÈ na tvoje meno.", VehicleNames[dealshvehicles[id][dealshipIndex[playerid]][dealveh_Model]-400], dealshvehicles[id][dealshipIndex[playerid]][dealveh_Price]);
	    ShowPlayerDialog(playerid, did_dealership_confirm_money_ex, DIALOG_STYLE_MSGBOX, "POTVRDENIE", fstr, "¡NO", "NIE");
	}
	return 1;
}

Dealership::ShowCreditConfirm(playerid)
{
    new
		id = tmp_dealershipedit[playerid]
	;
    new fstr[ 256 ];
    format(fstr, sizeof fstr, "{FFFFFF}> SkutoËne chceö k˙più vozidlo {6793db}%s {ffffff}za {c775d6}%d kreditov{ffffff}?\n> Bude napÌsanÈ na tvoje meno.", VehicleNames[dealshvehicles[id][dealshipIndex[playerid]][dealveh_Model]-400], dealshvehicles[id][dealshipIndex[playerid]][dealveh_PriceKr]);
    ShowPlayerDialog(playerid, did_dealership_confirm_credits, DIALOG_STYLE_MSGBOX, "POTVRDENIE", fstr, "¡NO", "NIE");
    return 1;
}

Dealership::ShowMoneyConfirm(playerid)
{
    new
		id = tmp_dealershipedit[playerid]
	;
    new fstr[ 256 ];
    format(fstr, sizeof fstr, "{FFFFFF}> SkutoËne chceö k˙più vozidlo {6793db}%s {ffffff}za {6793db}%d${ffffff}?\n> Bude napÌsanÈ na tvoje meno.", VehicleNames[dealshvehicles[id][dealshipIndex[playerid]][dealveh_Model]-400], dealshvehicles[id][dealshipIndex[playerid]][dealveh_Price]);
    ShowPlayerDialog(playerid, did_dealership_confirm_money, DIALOG_STYLE_MSGBOX, "POTVRDENIE", fstr, "¡NO", "NIE");
}

////////////////////////////////////////////////////////////////////////////////

YCMD:dealerships(playerid, params[], help)
{
	if(GetPlayerAdminLevel(playerid) < 6)
	    return SendError(playerid, "Na tento prikaz nemas opravnenie!");
	    
	Dealership::ShowAllDealerships(playerid);

	return 1;
}
