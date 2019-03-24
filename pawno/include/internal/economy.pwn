#define     Economy::   			econ_

#define     MAX_ECONOMY_LIST        40
#define     MAX_LIST_NAME           64

////////////////////////////////////////////////////////////////////////////////

enum economyEnum()
{
	economy_Category,
	economy_Name[MAX_LIST_NAME],
	economy_LastUpdate,
	
	economy_Value,
	economy_ValueEx // if not 0 will be randomized value+valueex
}

enum {
	ECONOMY_CATEGORY_NULL = 0,
	ECONOMY_CATEGORY_JOBS,
	ECONOMY_CATEGORY_PAYDAYS,
	ECONOMY_CATEGORY_LICENSE,
	ECONOMY_CATEGORY_OTHER,
}

new Economy::catnames[][] = {
	"null",
	"Pr·ce",
	"V˝platy",
	"VodiË·ky",
	"Majetok",
	"Vöetko moûnÈ",
	"Ammu Nation"
};

enum {
	ECONOMY_LIST_NULL = 0,
	
	ECONOMY_LIST_JOB_TRUCKING,
	ECONOMY_LIST_JOB_HROBAR,
	
	ECONOMY_LIST_BRIGADA_KRABICE_PC,
	ECONOMY_LIST_BRIGADA_KRABICE_MG,
	
	ECONOMY_LIST_VODICAK_A,
	ECONOMY_LIST_VODICAK_B,
	ECONOMY_LIST_VODICAK_BL,
	ECONOMY_LIST_VODICAK_C,
	ECONOMY_LIST_VODICAK_T,
	
	ECONOMY_LIST_PAYDAY_UNEMPLOY,
	ECONOMY_LIST_PAYDAY_BONUS_NEW,
	ECONOMY_LIST_PAYDAY_BONUS_BIZ,
	
	ECONOMY_LIST_BAZAR_SERVER,
	
	ECONOMY_LIST_LOTTERY,
	ECONOMY_LIST_GOLDS,
	
	ECONOMY_LIST_AMMO_COLT,
	ECONOMY_LIST_AMMO_DESERT,
	ECONOMY_LIST_AMMO_SHOTG,
	ECONOMY_LIST_AMMO_PUSKA,
	ECONOMY_LIST_AMMO_VESTA,
	
	ECONOMY_LIST_ANAWALT_PLANT,
	ECONOMY_LIST_ANAWALT_CUTDOWN,
	
	ECONOMY_LIST_ANAWALT_WOODB_1,
	ECONOMY_LIST_ANAWALT_WOODB_2,
	ECONOMY_LIST_ANAWALT_WOODB_3,
	
	ECONOMY_LIST_ALC_KONTRAKT_1,
	ECONOMY_LIST_ALC_KONTRAKT_2,
	ECONOMY_LIST_ALC_KONTRAKT_3,
	
	ECONOMY_LIST_AN_KONT_MIN,
	ECONOMY_LIST_AN_KONT_MAXMP,
	
	ECONOMY_LIST_ANAWALT_CUTUP,
	
	ECONOMY_LIST_SWEEPER,
	
	ECONOMY_LIST_DONATOR1_PD,
	ECONOMY_LIST_DONATOR2_PD,
	ECONOMY_LIST_DONATOR3_PD,
	
	ECONOMY_LIST_PIZZA_FINISH,
	ECONOMY_LIST_PIZZA_TRINGELT,
}

new Economy::enum[MAX_ECONOMY_LIST][economyEnum];
new Economy::currentcat[MAX_PLAYERS];
new Economy::currentlist[MAX_PLAYERS];

////////////////////////////////////////////////////////////////////////////////

Economy::Load()
{
    new mql_query[46];

	mysql_format(MYSQL, mql_query, sizeof(mql_query), "SELECT * FROM economy_overall");

	mysql_tquery(MYSQL, mql_query, "econ_OnLoad");
	return 1;
}

function econ_OnLoad() {

	new id = -1,tstrx[63];
	for(new i; i < cache_num_rows(); i++) {
	    cache_get_value_name_int(i, "id", id);
	    
	    cache_get_value_name_int(i, "categoryid", Economy::enum[id][economy_Category]);
	    cache_get_value_name(i,"name",tstrx);
	    
	    cache_get_value_name_int(i,"value",Economy::enum[id][economy_Value]);
	    cache_get_value_name_int(i,"value2",Economy::enum[id][economy_ValueEx]);
	    cache_get_value_name_int(i,"lastupdate",Economy::enum[id][economy_LastUpdate]);
	    
	    strcat(Economy::enum[id][economy_Name], tstrx);
	    format(Economy::enum[id][economy_Name], MAX_LIST_NAME, "%s", tstrx);
	}
	
	return 1;
}

////////////////////////////////////////////////////////////////////////////////

Economy::GetCategory(listid)
{
	return Economy::enum[listid][economy_Category];
}

Economy::GetLastUpdate(listid)
{
	return Economy::enum[listid][economy_LastUpdate];
}

Economy::GetPrice(listid)
{
	if(Economy::enum[listid][economy_ValueEx] > 0)
	    return Economy::enum[listid][economy_Value] + random(Economy::enum[listid][economy_ValueEx]);
	else
		return Economy::enum[listid][economy_Value];
}

////////////////////////////////////////////////////////////////////////////////

Economy::ShowCategories(playerid)
{

    Economy::currentcat[playerid] 	= 0;
    Economy::currentlist[playerid]  = 0;

	new finalstr[ 256 ];
	
	for(new x = ECONOMY_CATEGORY_NULL+1; x < sizeof(Economy::catnames); x++)
	{
	    if(strlen(Economy::catnames[x]) < 1) break;
	        
		strcat(finalstr, Economy::catnames[x]);
		strcat(finalstr, "\n");
	}
	
	ShowPlayerDialog(playerid, did_econ_categories, DIALOG_STYLE_LIST, "ZVOL KATEG”RIU", finalstr, "VYBRAç", "SPAç");
	
	return 1;
}

Economy::ShowList(playerid)
{
    Economy::currentlist[playerid]  = 0;

	new finalstr[2048] = "N·zov\tHodnota (od)\tHodnota (do)\tPosledn· ˙prava\n", tstr[256];
	
	for(new x = ECONOMY_LIST_NULL+1; x < MAX_ECONOMY_LIST; x++)
	{
	    if(x == 0) continue;
	    if(strlen(Economy::enum[x][economy_Name]) < 1) break;
	    if(Economy::enum[x][economy_Category] != Economy::currentcat[playerid]) continue;
	    
	    format(
			tstr, sizeof tstr,
			"{ffffff}%s\t{4a9940}%d$\t{4a9940}%d$\t{ffffff}%s\n",
			
	        Economy::enum[x][economy_Name],
	        Economy::enum[x][economy_Value],
	        Economy::enum[x][economy_ValueEx],
	        getdateunix(Economy::enum[x][economy_LastUpdate])
		);
		
		strcat(finalstr, tstr);
	}
	
	ShowPlayerDialog(playerid, did_econ_lists, DIALOG_STYLE_TABLIST_HEADERS, Economy::catnames[Economy::currentcat[playerid]], finalstr, "UPRAVIç", "SPAç");
	
	return 1;
}

Economy::EditList(playerid, bool:isactual = false)
{

	if(isactual==true)
	{
	    new tid = 0;
	    for(new x = ECONOMY_LIST_NULL+1; x < MAX_ECONOMY_LIST; x++)
		{
		    if(x == 0) continue;
		    if(strlen(Economy::enum[x][economy_Name]) < 1) break;
		    if(Economy::enum[x][economy_Category] != Economy::currentcat[playerid]) continue;

			tid ++;
		    if(tid == Economy::currentlist[playerid])
		    {
                Economy::currentlist[playerid] = x;
                break;
		    }
		}
	}

	new finalstr[1024] = "Premenn·\tHodnota\n", tstr[128];
	
	format(
		tstr, sizeof tstr,
		"{ffffff}Identifik·tor\t{ad5353}%02d\n",
		Economy::currentlist[playerid]
	);
	strcat(finalstr, tstr);
	
	format(
		tstr, sizeof tstr,
		"{ffffff}N·zov\t{6fad53}%s\n",
		Economy::enum[Economy::currentlist[playerid]][economy_Name]
	);
	strcat(finalstr, tstr);
	
	format(
		tstr, sizeof tstr,
		"{ffffff}KategÛria\t{6fad53}%s\n",
		Economy::catnames[Economy::GetCategory(Economy::currentlist[playerid])]
	);
	strcat(finalstr, tstr);
	
	format(
		tstr, sizeof tstr,
		"{ffffff}Posledn· ˙prava\t{ad5353}%s\n \n",
		getdateunix(Economy::GetLastUpdate(Economy::currentlist[playerid]))
	);
	strcat(finalstr, tstr);
	
	format(
		tstr, sizeof tstr,
		"{ffffff}Hodnota (*od)\t{6fad53}%d\n",
		Economy::enum[Economy::currentlist[playerid]][economy_Value]
	);
	strcat(finalstr, tstr);
	
	format(
		tstr, sizeof tstr,
		"{ffffff}Hodnota (**do)\t{6fad53}%d",
		Economy::enum[Economy::currentlist[playerid]][economy_ValueEx]
	);
	strcat(finalstr, tstr);
	
	ShowPlayerDialog(playerid, did_econ_list, DIALOG_STYLE_TABLIST_HEADERS, "UPRAVA PREMENNYCH", finalstr, "UPRAVIç", "SPAç");

	return 1;
}

////////////////////////////////////////////////////////////////////////////////

Economy::EditName(playerid)
{
	new finalstr[256];

	format(
		finalstr, sizeof finalstr,
		"{FFFFFF}> Upravujeö n·zov ekonomickej premennej {6fad53}%s{ffffff}! Zadaj prosÌm nov˝ n·zov.",
		Economy::enum[Economy::currentlist[playerid]][economy_Name]
	);

	ShowPlayerDialog(playerid, did_econ_edit_name, DIALOG_STYLE_INPUT, "MENO EKONOMICKEJ PREMENNEJ", finalstr, "UPRAVIç", "ZRUäIç");

	return 1;
}

Economy::EditCategory(playerid)
{
	new finalstr[1024];
	
	for(new x = ECONOMY_CATEGORY_NULL+1; x < sizeof(Economy::catnames); x++)
	{
	    if(strlen(Economy::catnames[x]) < 1) break;

		strcat(finalstr, Economy::catnames[x]);
		strcat(finalstr, "\n");
	}
	
	ShowPlayerDialog(playerid, did_econ_edit_category, DIALOG_STYLE_LIST, "ZVOL KATEGORIU", finalstr, "VYBRAç", "ZRUäIç");
	
	return 1;
}

Economy::EditValueFrom(playerid)
{
	new finalstr[512];

	format(
		finalstr, sizeof finalstr,
		"{FFFFFF}> Upravujeö hodnotu (od) ekonomickej premennej {6fad53}%s{ffffff} (teraz je {6fad53}%d{ffffff})! Zadaj prosÌm nov˙ hodnotu.\n\n* T·to hodnota je povinn·!!!",
		Economy::enum[Economy::currentlist[playerid]][economy_Name]
	);

	ShowPlayerDialog(playerid, did_econ_edit_value_from, DIALOG_STYLE_INPUT, "HODNOTA EKONOMICKEJ PREMENNEJ", finalstr, "UPRAVIç", "ZRUäIç");

	return 1;
}

Economy::EditValueTo(playerid)
{
	new finalstr[512];

	format(
		finalstr, sizeof finalstr,
		"{FFFFFF}> Upravujeö hodnotu (do) ekonomickej premennej {6fad53}%s{ffffff} (teraz je {6fad53}%d{ffffff})! Zadaj prosÌm nov˙ hodnotu.\n\n** T·to hodnota nie je povinn·, ak ju zad·ö v˝sledn· hodnota bude n·hodn· vo vzorci hodnota_od+random(hodnota_do)!!!",
		Economy::enum[Economy::currentlist[playerid]][economy_Name]
	);

	ShowPlayerDialog(playerid, did_econ_edit_value_to, DIALOG_STYLE_INPUT, "HODNOTA EKONOMICKEJ PREMENNEJ", finalstr, "UPRAVIç", "ZRUäIç");

	return 1;
}

////////////////////////////////////////////////////////////////////////////////

Economy::UpdateName(playerid, name[])
{

	format(Economy::enum[Economy::currentlist[playerid]][economy_Name], MAX_LIST_NAME, "%s", name);
	Economy::enum[Economy::currentlist[playerid]][economy_LastUpdate]   = gettime();

	new tquery[ 128 ];

	mysql_format(
		MYSQL,
		tquery, sizeof tquery,
		"UPDATE economy_overall SET name = '%e', lastupdate='%d' WHERE id = '%d'",
		name,
		gettime(),
		Economy::currentlist[playerid]
	);

	mysql_tquery(MYSQL, tquery);

	return 1;
}

Economy::UpdateCategory(playerid, cat)
{

	Economy::enum[Economy::currentlist[playerid]][economy_Category]    	= cat;
	Economy::enum[Economy::currentlist[playerid]][economy_LastUpdate]   = gettime();
	
	Economy::currentcat[playerid]   = cat;

	new tquery[ 128 ];

	mysql_format(
		MYSQL,
		tquery, sizeof tquery,
		"UPDATE economy_overall SET categoryid = '%d', lastupdate='%d' WHERE id = '%d'",
		cat,
		gettime(),
		Economy::currentlist[playerid]
	);

	mysql_tquery(MYSQL, tquery);

	return 1;
}

Economy::UpdateValueFrom(playerid, value, dbid = -1)
{
	if(dbid == -1) dbid = Economy::currentlist[playerid];
    Economy::enum[dbid][economy_Value]    	= value;
    Economy::enum[dbid][economy_LastUpdate]   = gettime();

	new tquery[ 128 ];

	mysql_format(
		MYSQL,
		tquery, sizeof tquery,
		"UPDATE economy_overall SET value = '%d', lastupdate='%d' WHERE id = '%d'",
		value,
		gettime(),
		dbid
	);

	mysql_tquery(MYSQL, tquery);

	return 1;
}

Economy::UpdateValueTo(playerid, value)
{

    Economy::enum[Economy::currentlist[playerid]][economy_ValueEx]    	= value;
    Economy::enum[Economy::currentlist[playerid]][economy_LastUpdate]   = gettime();

	new tquery[ 128 ];

	mysql_format(
		MYSQL,
		tquery, sizeof tquery,
		"UPDATE economy_overall SET value2 = '%d', lastupdate='%d' WHERE id = '%d'",
		value,
		gettime(),
		Economy::currentlist[playerid]
	);

	mysql_tquery(MYSQL, tquery);

	return 1;
}
