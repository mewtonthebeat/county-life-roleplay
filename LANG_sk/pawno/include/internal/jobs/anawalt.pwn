////////////////////////////////////////////////////////////////////////////////

#define     Anawalt::           anw_
#define     MAX_TREES           850
#define     TREE_STEPS_GROWN    125
#define     CUT_DOWN_TREES_RANK 2
#define     CUT_UP_TREES_RANK   3

////////////////////////////////////////////////////////////////////////////////
enum anwTreeEnum()
{
	Float:tree_X, Float:tree_Y, Float:tree_Z,
	
	tree_PlacedBy[MAX_PLAYER_NAME+1],
	tree_Step,
	tree_Type,
	tree_IsCutDown,
	
	tree_AreaId,
	tree_ObjectId,
	Text3D:tree_LabelId
}

enum {
	TREE_TYPE_NULL = 0,
	TREE_TYPE_OAK,
	TREE_TYPE_BIRCH,
	TREE_TYPE_SPRUCE,
}

new Anawalt::treeTypeNames[][] = {
	"",
	"Dub",
	"Breza",
	"Smrek"
};

new Anawalt::treeTypeModels[] = {
	0,
	673,
	779,//727,
	660
};

/////////////////////////////////////////////////////////////

enum {
	ANAWALT_WORK_TYPE_NONE = 0,
	ANAWALT_WORK_TYPE_PLANT,
	ANAWALT_WORK_TYPE_CUT,
	ANAWALT_WORK_TYPE_CUTUP,
}

new Iterator:Tree<MAX_TREES>;
////////////////////////////////////////////////////////////////////////////////

new Anawalt::tree[MAX_TREES][anwTreeEnum];

new bool:Anawalt::isworking[MAX_PLAYERS];
new Anawalt::workid[MAX_PLAYERS];
new Anawalt::plant_clicked[MAX_PLAYERS];
new PlayerText:plant_clickerTD[MAX_PLAYERS];
new Anawalt::cutdown_type[MAX_PLAYERS];
new Anawalt::cutdown_treeid[MAX_PLAYERS];
new Anawalt::cutdown_count[MAX_PLAYERS];
new bool:Anawalt::cutdown_iscutting[MAX_PLAYERS];
new bool:Anawalt::cutdown_temporary[MAX_PLAYERS];
new Anawalt::playerhold[MAX_PLAYERS][3];

////////////////////////////////////////////////////////////////////////////////

Anawalt::CreateTree(Float:x, Float:y, Float:z, type, step = 0, playerid = -1, placedby[] = "", bool:save = false, len = sizeof placedby)
{
	new id = Iter_Alloc(Tree);
	if(id == -1) return 0;
	
	new
	    model,
	    
	    texture_id[2],
		texture_name[2][64],
	    texture_txd[2][64],
	    
	    labeltext[256],
	    treetypename[24]
	;
	    
	if(step < TREE_STEPS_GROWN/2)
	{
	    switch(type)
	    {
	        case TREE_TYPE_NULL: return 0;
	        case TREE_TYPE_OAK:
	        {
	            model = 760;
				texture_id[0] = 729;
				strcat(texture_txd[0], "gtatreeshi7");
				strcat(texture_name[0], "cedar1");

				texture_id[1] = 16644;
				strcat(texture_txd[1], "a51_detailstuff");
				strcat(texture_name[1], "roucghstonebrtb");
	        }

	        case TREE_TYPE_BIRCH:
	        {
	            model = 760;
				texture_id[0] = 763;
				strcat(texture_txd[0], "tree3");
				strcat(texture_name[0], "ashbrnch");

				texture_id[1] = 16644;
				strcat(texture_txd[1], "a51_detailstuff");
				strcat(texture_name[1], "roucghstonebrtb");
	        }

	        case TREE_TYPE_SPRUCE:
	        {
	            model = 760;
				texture_id[0] = 654;
				strcat(texture_txd[0], "gta_tree_oldpine");
				strcat(texture_name[0], "pinelo128");

				texture_id[1] = 16644;
				strcat(texture_txd[1], "a51_detailstuff");
				strcat(texture_name[1], "roucghstonebrtb");
	        }
	    }
	}
	else if(step < TREE_STEPS_GROWN)
	{
	    switch(type)
	    {
	        case TREE_TYPE_NULL: return 0;
	        case TREE_TYPE_OAK:
	        {
	            model = 676;
	            texture_id[0] = 726;
				strcat(texture_txd[0], "gtatreesh");
				strcat(texture_name[0], "oakbark64");
	            
				texture_id[1] = 729;
				strcat(texture_txd[1], "gtatreeshi7");
				strcat(texture_name[1], "cedar1");
	        }

	        case TREE_TYPE_BIRCH:
	        {
	            model = 904;
	            texture_id[0] = 654;
				strcat(texture_txd[0], "tree3");
				strcat(texture_name[0], "bpinud2");
	            
				texture_id[1] = 763;
				strcat(texture_txd[1], "tree3");
				strcat(texture_name[1], "ashbrnch");
	        }

	        case TREE_TYPE_SPRUCE:
	        {
	            model = 676;
				texture_id[0] = 4810;
				strcat(texture_txd[0], "griffobs_las");
				strcat(texture_name[0], "Gen_Log");
				
				texture_id[1] = 654;
				strcat(texture_txd[1], "gta_tree_oldpine");
				strcat(texture_name[1], "pinelo128");
	        }
	    }
	}
	else
	{
	    model = Anawalt::treeTypeModels[type];
	}
	
	strcat(treetypename, Anawalt::treeTypeNames[type]);
	
	////////////////////////////////////////////////////////////////////////////
	
	Anawalt::tree[id][tree_X] = x;
	Anawalt::tree[id][tree_Y] = y;
	Anawalt::tree[id][tree_Z] = z;
	Anawalt::tree[id][tree_Type] = type;
	Anawalt::tree[id][tree_Step] = step;
	Anawalt::tree[id][tree_IsCutDown] = 0;
	
	if(playerid > -1)
	    format(Anawalt::tree[id][tree_PlacedBy], MAX_PLAYER_NAME+1, ReturnName(playerid));
	else if(len > 0)
	    format(Anawalt::tree[id][tree_PlacedBy], MAX_PLAYER_NAME+1, placedby);
	    
    Anawalt::tree[id][tree_ObjectId] = CreateDynamicObject(model, x, y, z - 1.5, 0.0, 0.0, float(random(360)), 0, 0, -1, 300, 300, -1, -1);
	if(texture_id[0] != 0) SetDynamicObjectMaterial(Anawalt::tree[id][tree_ObjectId], 0, texture_id[0], texture_txd[0], texture_name[0], 0x00000000);
	if(texture_id[1] != 0) SetDynamicObjectMaterial(Anawalt::tree[id][tree_ObjectId], 1, texture_id[1], texture_txd[1], texture_name[1], 0x00000000);
	
	Anawalt::tree[id][tree_AreaId]   = CreateDynamicSphere(x, y, z, 1.5, 0, 0, -1);
	
	if(Anawalt::tree[id][tree_IsCutDown] != 0)
		format(labeltext, sizeof labeltext, "[ %s ]\n[ Zasadil %s ]\n/rozrezatstrom", treetypename, str_replace("_", " ", Anawalt::tree[id][tree_PlacedBy]));
    else if(step >= TREE_STEPS_GROWN)
		format(labeltext, sizeof labeltext, "[ %s ]\n[ Zasadil %s ]\n/rezatstrom", treetypename, str_replace("_", " ", Anawalt::tree[id][tree_PlacedBy]));
	else
	    format(labeltext, sizeof labeltext, "[ %s ]\n[ Zasadil %s ]", treetypename, str_replace("_", " ", Anawalt::tree[id][tree_PlacedBy]));
	    
    Anawalt::tree[id][tree_LabelId]  = CreateDynamic3DTextLabel(labeltext, 0xeaeaeaff, x, y, z, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 15.0, -1, 1);
	
	if(save)
	{
	    new tquery[1024];
	    mysql_format(MYSQL, tquery, sizeof tquery, "INSERT INTO anawalt_trees (x,y,z,placedby,treetype,steps) VALUES ('%f','%f','%f','%e','%d','%d')",
	        x, y, z, Anawalt::tree[id][tree_PlacedBy], Anawalt::tree[id][tree_Type], Anawalt::tree[id][tree_Step]
		);
		mysql_tquery(MYSQL, tquery);
	}
	
	return 1;
}

Anawalt::TreeDestroy(id)
{
	DestroyDynamicObject(Anawalt::tree[id][tree_ObjectId]);
	DestroyDynamic3DTextLabel(Anawalt::tree[id][tree_LabelId]);
	DestroyDynamicArea(Anawalt::tree[id][tree_AreaId]);
	
	new tquery[1024];
    mysql_format(MYSQL, tquery, sizeof tquery, "DELETE FROM anawalt_trees WHERE x > '%f' AND x < '%f' AND y > '%f' AND y < '%f' AND z > '%f' AND z < '%f'",
        Anawalt::tree[id][tree_X]-0.2,Anawalt::tree[id][tree_X]+0.2,
		Anawalt::tree[id][tree_Y]-0.2,Anawalt::tree[id][tree_Y]+0.2,
		Anawalt::tree[id][tree_Z]-0.2,Anawalt::tree[id][tree_Z]+0.2
	);
	mysql_tquery(MYSQL, tquery);

	Iter_Remove(Tree, id);
	
	return 1;
}

forward AnawaltTrees();
public AnawaltTrees()
{
	new laststep, tquery[1024];
    mysql_format(MYSQL, tquery, sizeof tquery, "DELETE FROM anawalt_trees WHERE steps < '%d'", TREE_STEPS_GROWN);
	mysql_query(MYSQL, tquery, false);
	foreach( new id : Tree )
	{
	    laststep = Anawalt::tree[id][tree_Step];
	    if(laststep >= TREE_STEPS_GROWN) continue;
	    #if defined CLOSED_BETA
	    	Anawalt::tree[id][tree_Step] += 5;
		#else
		    Anawalt::tree[id][tree_Step] ++;
		#endif
	    if(Anawalt::tree[id][tree_Step] > TREE_STEPS_GROWN) Anawalt::tree[id][tree_Step] = TREE_STEPS_GROWN;

		if(laststep < TREE_STEPS_GROWN/2 && Anawalt::tree[id][tree_Step] >= TREE_STEPS_GROWN/2 && Anawalt::tree[id][tree_Step] < TREE_STEPS_GROWN)
		{
		    new
			    model,

			    texture_id[2],
				texture_name[2][64],
			    texture_txd[2][64],

			    labeltext[256],
			    treetypename[24]
			;
		
		    switch(Anawalt::tree[id][tree_Type])
		    {
		        case TREE_TYPE_NULL: continue;
		        case TREE_TYPE_OAK:
		        {
		            model = 676;
		            texture_id[0] = 726;
					strcat(texture_txd[0], "gtatreesh");
					strcat(texture_name[0], "oakbark64");

					texture_id[1] = 729;
					strcat(texture_txd[1], "gtatreeshi7");
					strcat(texture_name[1], "cedar1");
		        }

		        case TREE_TYPE_BIRCH:
		        {
		            model = 904;
		            texture_id[0] = 654;
					strcat(texture_txd[0], "tree3");
					strcat(texture_name[0], "bpinud2");

					texture_id[1] = 763;
					strcat(texture_txd[1], "tree3");
					strcat(texture_name[1], "ashbrnch");
		        }

		        case TREE_TYPE_SPRUCE:
		        {
		            model = 676;
					texture_id[0] = 4810;
					strcat(texture_txd[0], "griffobs_las");
					strcat(texture_name[0], "Gen_Log");

					texture_id[1] = 654;
					strcat(texture_txd[1], "gta_tree_oldpine");
					strcat(texture_name[1], "pinelo128");
		        }
		    }
		    
		    strcat(treetypename, Anawalt::treeTypeNames[Anawalt::tree[id][tree_Type]]);

			////////////////////////////////////////////////////////////////////////////

			DestroyDynamicObject(Anawalt::tree[id][tree_ObjectId]);
			DestroyDynamic3DTextLabel(Anawalt::tree[id][tree_LabelId]);
		    Anawalt::tree[id][tree_ObjectId] = CreateDynamicObject(model, Anawalt::tree[id][tree_X], Anawalt::tree[id][tree_Y], Anawalt::tree[id][tree_Z] - 1.5, 0.0, 0.0, float(random(360)), 0, 0, -1, 300, 300, -1, -1);
			if(texture_id[0] != 0) SetDynamicObjectMaterial(Anawalt::tree[id][tree_ObjectId], 0, texture_id[0], texture_txd[0], texture_name[0], 0x00000000);
			if(texture_id[1] != 0) SetDynamicObjectMaterial(Anawalt::tree[id][tree_ObjectId], 1, texture_id[1], texture_txd[1], texture_name[1], 0x00000000);

			format(labeltext, sizeof labeltext, "[ %s ]\n[ Zasadil %s ]", treetypename, str_replace("_", " ", Anawalt::tree[id][tree_PlacedBy]));
		    Anawalt::tree[id][tree_LabelId]  = CreateDynamic3DTextLabel(labeltext, 0xeaeaeaff, Anawalt::tree[id][tree_X], Anawalt::tree[id][tree_Y], Anawalt::tree[id][tree_Z], 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 15.0, -1, 1);
		}
		else if(Anawalt::tree[id][tree_Step] >= TREE_STEPS_GROWN && laststep < TREE_STEPS_GROWN)
		{
		    new
			    labeltext[256],
			    treetypename[24]
			;
		
		    model = Anawalt::treeTypeModels[Anawalt::tree[id][tree_Type]];
		    
		    strcat(treetypename, Anawalt::treeTypeNames[Anawalt::tree[id][tree_Type]]);

			////////////////////////////////////////////////////////////////////////////

			DestroyDynamicObject(Anawalt::tree[id][tree_ObjectId]);
			DestroyDynamic3DTextLabel(Anawalt::tree[id][tree_LabelId]);
		    Anawalt::tree[id][tree_ObjectId] = CreateDynamicObject(model, Anawalt::tree[id][tree_X], Anawalt::tree[id][tree_Y], Anawalt::tree[id][tree_Z] - 1.5, 0.0, 0.0, float(random(360)), 0, 0, -1, 300, 300, -1, -1);
			
			format(labeltext, sizeof labeltext, "[ %s ]\n[ Zasadil %s ]\n/rezatstrom", treetypename, str_replace("_", " ", Anawalt::tree[id][tree_PlacedBy]));
		    Anawalt::tree[id][tree_LabelId]  = CreateDynamic3DTextLabel(labeltext, 0xeaeaeaff, Anawalt::tree[id][tree_X], Anawalt::tree[id][tree_Y], Anawalt::tree[id][tree_Z], 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 15.0, -1, 1);
		}
		
		mysql_format(MYSQL, tquery, sizeof tquery, "INSERT INTO anawalt_trees (x,y,z,placedby,treetype,steps) VALUES ('%f','%f','%f','%e','%d','%d')",
	        Anawalt::tree[id][tree_X],Anawalt::tree[id][tree_Y],Anawalt::tree[id][tree_Z], Anawalt::tree[id][tree_PlacedBy], Anawalt::tree[id][tree_Type], Anawalt::tree[id][tree_Step]
		);
		mysql_tquery(MYSQL, tquery);
	}
	return 1;
}

forward anawalt_LoadTrees();
public anawalt_LoadTrees()
{
    new
		Float:Pos[3],
		treetype,
		steps,
		placedby[30]
	;

	for(new i = 0; i < cache_num_rows(); i++) {
	    if(i == cache_num_rows()) break;
	    cache_get_value_name_float(i, "x", Pos[0]);
	    cache_get_value_name_float(i, "y", Pos[1]);
	    cache_get_value_name_float(i, "z", Pos[2]);
	    cache_get_value_name_int(i, "treetype", treetype);
	    cache_get_value_name_int(i, "steps", steps);
		cache_get_value_name(i, "placedby", placedby);
	    
	    Anawalt::CreateTree(Pos[0],Pos[1],Pos[2], treetype, steps, -1, placedby);
	}
	return 1;
}

Anawalt::Plant_CreateClicker(playerid)
{
    plant_clickerTD[playerid] = CreatePlayerTextDraw(playerid, 80.0 + float(random(480)), 80.0 + float(random(308)), "LD_BEAT:circle");
	PlayerTextDrawLetterSize(playerid, plant_clickerTD[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, plant_clickerTD[playerid], 30.0, 30.0);
	PlayerTextDrawAlignment(playerid, plant_clickerTD[playerid], 1);
	PlayerTextDrawColor(playerid, plant_clickerTD[playerid], -1);
	PlayerTextDrawSetShadow(playerid, plant_clickerTD[playerid], 0);
	PlayerTextDrawSetOutline(playerid, plant_clickerTD[playerid], 0);
	PlayerTextDrawFont(playerid, plant_clickerTD[playerid], 4);
	PlayerTextDrawSetSelectable(playerid, plant_clickerTD[playerid], true);
	PlayerTextDrawShow(playerid, plant_clickerTD[playerid]);
	return 1;
}

Anawalt::Plant_OnClick(playerid)
{
    Anawalt::plant_clicked[playerid] ++;
    PlayerTextDrawDestroy(playerid, plant_clickerTD[playerid]);
    if(Anawalt::plant_clicked[playerid] >= 10)
    {
        new sanca = random(101), typstromu = 0, Float:X, Float:Y, Float:Z;
        switch(sanca)
        {
            case 0..50: typstromu = TREE_TYPE_SPRUCE;
            case 51..80: typstromu = TREE_TYPE_BIRCH;
            default: typstromu = TREE_TYPE_OAK;
        }
        
        GetPlayerPos(playerid, X, Y, Z);
        
        Anawalt::CreateTree(X, Y, Z, typstromu, 0, playerid, .save = true);
        Anawalt::isworking[playerid] = true;
		Anawalt::workid[playerid] = ANAWALT_WORK_TYPE_PLANT;
		Anawalt::plant_clicked[playerid] = 0;
		ClearAnimations(playerid, 1);
		ApplyAnimation(playerid, "BOMBER", "BOM_PLANT", 4.1, false, true, true, false, 0, true);
		TogglePlayerControllable(playerid, 1);
		CancelSelectTextDraw(playerid);
		new odmena = Economy::GetPrice(ECONOMY_LIST_ANAWALT_PLANT);
		g_I_Vyplata[playerid] += odmena;
		SCSuccess(playerid, "Za zasedenie stromu ti bude k výplate pripoèítaných %d$", odmena);
    }
    else
    {
        Anawalt::Plant_CreateClicker(playerid);
    }
	return 1;
}

Anawalt::Plant_StopPlanting(playerid)
{
	PlayerTextDrawDestroy(playerid, plant_clickerTD[playerid]);
	Anawalt::isworking[playerid] = false;
	Anawalt::workid[playerid] = ANAWALT_WORK_TYPE_NONE;
	Anawalt::plant_clicked[playerid] = 0;
	ClearAnimations(playerid, 1);
	ApplyAnimation(playerid, "BOMBER", "BOM_PLANT", 4.1, false, true, true, false, 0, true);
	TogglePlayerControllable(playerid, 1);
	
	SendError(playerid, "Ukonèil si sadenie stromu!");
	return 1;
}

Anawalt::TreeCutDown(playerid)
{
	new id = Anawalt::cutdown_treeid[playerid];
	Anawalt::tree[id][tree_IsCutDown] = 1;
	
	if(Anawalt::tree[id][tree_Type] == 1)
		MoveDynamicObject(Anawalt::tree[id][tree_ObjectId], Anawalt::tree[id][tree_X], Anawalt::tree[id][tree_Y], Anawalt::tree[id][tree_Z]-0.6, 2.5, 90.0, 0.0, float(random(360)));
	else
        MoveDynamicObject(Anawalt::tree[id][tree_ObjectId], Anawalt::tree[id][tree_X], Anawalt::tree[id][tree_Y], Anawalt::tree[id][tree_Z]-0.6, 2.5, 0.0, 90.0, float(random(360)));

	new
	    labeltext[256],
	    treetypename[24]
	;

    strcat(treetypename, Anawalt::treeTypeNames[Anawalt::tree[id][tree_Type]]);

	////////////////////////////////////////////////////////////////////////////

	DestroyDynamic3DTextLabel(Anawalt::tree[id][tree_LabelId]);
	format(labeltext, sizeof labeltext, "[ %s ]\n[ Zasadil %s ]\n/rozrezatstrom", treetypename, str_replace("_", " ", Anawalt::tree[id][tree_PlacedBy]));
    Anawalt::tree[id][tree_LabelId]  = CreateDynamic3DTextLabel(labeltext, 0xeaeaeaff, Anawalt::tree[id][tree_X], Anawalt::tree[id][tree_Y], Anawalt::tree[id][tree_Z], 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 15.0, -1, 1);

	return 1;
}

Anawalt::TreeCutUp(playerid)
{
	new id = Anawalt::cutdown_treeid[playerid];
	Anawalt::playerhold[playerid][0] = 1;
	Anawalt::playerhold[playerid][1] = Anawalt::tree[id][tree_Type];
	Anawalt::playerhold[playerid][2] = 7+random(9);
	Anawalt::TreeDestroy(id);
	
	SetPlayerSpecialAction(playerid, 25);
	SetPlayerAttachedObject(playerid, 9, 1463, 6, 0.021, 0.104, -0.226, 66.6999, -171.2, -109.6, 0.28, 0.31, 0.457);

	return 1;
}

Anawalt::Cutdown_StartWork(playerid)
{

	new treetype = 1+random(3), bool:found=false;

	foreach(new id : Tree)
	{
	    if(Anawalt::tree[id][tree_Type] != treetype) continue;
	    if(Anawalt::tree[id][tree_Step] < TREE_STEPS_GROWN) continue;
	    found = true;
		break;
	}

	if(!found)
	    return SCError(playerid, "Táto práca nie je k dispozícii, strom %s nie je k dispozícii na zrub!", Anawalt::treeTypeNames[treetype]), Anawalt::ShowWorkDialog(playerid);

    Anawalt::isworking[playerid] = true;
	Anawalt::workid[playerid] = ANAWALT_WORK_TYPE_CUT;
	Anawalt::cutdown_type[playerid] = treetype;

	SCSuccess(playerid, "Ak ešte nemáš, kúp si motorovú pílu a choï zrúba akýko¾vek %s!", Anawalt::treeTypeNames[treetype]);
	SCSuccess(playerid, "Ak prácu predèasne ukonèíš, zaplatíš poplatok 200$!");
	return 1;
}

Anawalt::Cutup_StartWork(playerid)
{

	new treetype = 1+random(3), bool:found=false;

	foreach(new id : Tree)
	{
	    if(Anawalt::tree[id][tree_Type] != treetype) continue;
	    if(Anawalt::tree[id][tree_IsCutDown] == 0) continue;
	    found = true;
		break;
	}

	if(!found)
	    return SCError(playerid, "Táto práca nie je k dispozícii, nie sú žiadne pokácané stromy typu %s!", Anawalt::treeTypeNames[treetype]), Anawalt::ShowWorkDialog(playerid);

    Anawalt::isworking[playerid] = true;
	Anawalt::workid[playerid] = ANAWALT_WORK_TYPE_CUTUP;

	SCSuccess(playerid, "Ak ešte nemáš, kúp si motorovú pílu a choï rozreza akýko¾vek pokácaný strom %s!", Anawalt::treeTypeNames[treetype]);
	SCSuccess(playerid, "Ak prácu predèasne ukonèíš, zaplatíš poplatok 200$!");
	return 1;
}

Anawalt::ShowWorkDialog(playerid)
{
	new
	    finstr[1024]="Práca\tPotrebný rank\tOdmena",
	    tstr[128]
	;
	
	format(tstr, sizeof tstr, "\n{ffffff}Sadenie stromov\tRank %d+\tnáhodná", 1);
	strcat(finstr, tstr);
	
	format(tstr, sizeof tstr, "\n{ffffff}Zrezávanie stromov\tRank %d+\t%d$/strom", CUT_DOWN_TREES_RANK, Economy::GetPrice(ECONOMY_LIST_ANAWALT_CUTDOWN));
	strcat(finstr, tstr);
	
	format(tstr, sizeof tstr, "\n{ffffff}Rozrezávanie stromov\tRank %d+\t%d$/strom", CUT_UP_TREES_RANK, Economy::GetPrice(ECONOMY_LIST_ANAWALT_CUTUP));
	strcat(finstr, tstr);
	
	ShowPlayerDialog(
	    playerid, did_anawalt_work, DIALOG_STYLE_TABLIST_HEADERS,
		"VÝBER PRÁCE",
		finstr,
		"VYBRA", "ZRUŠI"
	);
	
	return 1;
}
////////////////////////////////////////////////////////////////////////////////

YCMD:zasaditstrom(playerid, params[], help)
{
	if(GetPlayerFaction(playerid) != FACTION_TYPE_WOODCUTTER && GetPlayerAdminLevel(playerid) < 5)
	    return SendError(playerid, "Tento príkaz nemôžeš použi!");
	    
	if(Anawalt::isworking[playerid] == true)
	    return SendError(playerid, "Už máš inú prácu!");
	    
    if(!IsPlayerInDynamicArea(playerid, AnawaltArea) && GetPlayerAdminLevel(playerid) < 5 && GetPlayerFactionRank(playerid) < 7)
	    return SendError(playerid, "Tento príkaz môžeš použi iba na pozemku Anawalt Lumberu!");
	    
	if(GetPlayerWeapon(playerid) != 6 && GetPlayerAdminLevel(playerid) < 5)
        return SendError(playerid, "Musíš ma v ruke lopatu!");
        
	new count = 0;
	foreach( new id : Tree )
	{
	    count ++;
		if(!IsPlayerInDynamicArea(playerid, Anawalt::tree[id][tree_AreaId])) continue;
		return SendError(playerid, "Už tu je nejaký strom, zasaï ho ïalej!");
	}
	
	if(count > MAX_TREES-5) SendError(playerid, "Už je zasadený maximálny poèet stromov!");

	if(GetPlayerInventoryItem(playerid, inv_tree_sadenica) < 1)
	    return SendError(playerid, "Nemáš sadenice!");
	    
	SetPlayerInventoryItem(playerid, inv_tree_sadenica, GetPlayerInventoryItem(playerid, inv_tree_sadenica)-1);
	
	Anawalt::isworking[playerid] = true;
	Anawalt::workid[playerid] = ANAWALT_WORK_TYPE_PLANT;
	Anawalt::plant_clicked[playerid] = 0;
	
	TogglePlayerControllable(playerid, 0);

	SendSuccess(playerid, "Zaèal si sadi sadenicu, klikaj na krúžky!");
	
	SelectTextDraw(playerid, 0xffffffff);
	SetCameraBehindPlayer(playerid);
	ApplyAnimation(playerid, "BOMBER", "BOM_PLANT", 4.1, true, true, true, false, 0, true);
	Anawalt::Plant_CreateClicker(playerid);
        
	return 1;
}

YCMD:rezatstrom(playerid, params[], help)
{
    if(GetPlayerFaction(playerid) != FACTION_TYPE_WOODCUTTER && GetPlayerAdminLevel(playerid) < 5)
	    return SendError(playerid, "Tento príkaz nemôžeš použi!");

	if(Anawalt::isworking[playerid] == false && GetPlayerAdminLevel(playerid) < 5)
	    return SendError(playerid, "Teraz nepracuješ, nemôžeš reza strom!");
	    
	if(Anawalt::workid[playerid] != ANAWALT_WORK_TYPE_CUT && GetPlayerAdminLevel(playerid) < 5)
	    return SendError(playerid, "Teraz nepracuješ, nemôžeš reza strom!");

    if(!IsPlayerInDynamicArea(playerid, AnawaltArea) && GetPlayerAdminLevel(playerid) < 5 && GetPlayerFactionRank(playerid) < 7)
	    return SendError(playerid, "Tento príkaz môžeš použi iba na pozemku Anawalt Lumberu!");

	if(GetPlayerWeapon(playerid) != 9 && GetPlayerAdminLevel(playerid) < 5)
        return SendError(playerid, "Musíš ma v ruke motorovú pílu!");

	new id = -1;
	foreach(new x : Tree)
	{
	    if(!IsPlayerInDynamicArea(playerid,Anawalt::tree[x][tree_AreaId])) continue;
	    id = x;
	    break;
	}

	if(id == -1) return SendError(playerid, "Nestojíš pri žiadnom strome!");
	if(Anawalt::tree[id][tree_Step] < TREE_STEPS_GROWN) return SendError(playerid, "Tento strom nie je plne vyrastený!");
	if(Anawalt::tree[id][tree_Type] != Anawalt::cutdown_type[playerid] && GetPlayerAdminLevel(playerid) < 5 && GetPlayerFactionRank(playerid) < 7) return SendError(playerid, "Tento typ stromu nemáš pokáca!");
    if(Anawalt::tree[id][tree_IsCutDown] != 0) return SendError(playerid, "Tento strom už je pokácaný!");

	Anawalt::cutdown_treeid[playerid] 		= id;
	Anawalt::cutdown_count[playerid]    	= 0;
	Anawalt::cutdown_iscutting[playerid] 	= true;

	ApplyAnimation(playerid, "BASEBALL", "BAT_IDLE", 4.1, true, false, false, false, 0, true); // /baseball
	TogglePlayerControllable(playerid, 0);

	SendSuccess(playerid, "Pre zrezanie stromu klikaj na lavé tlaèidlo myši (LMB) kým nebude status plný!");

	PlayerTextDrawTextSize(playerid, breakin_td[playerid][2], 37.000000 + (breakin_playerProgress[playerid] * 0.64), 0.000000);
	PlayerTextDrawShow(playerid, breakin_td[playerid][0]);
	PlayerTextDrawShow(playerid, breakin_td[playerid][1]);
	PlayerTextDrawShow(playerid, breakin_td[playerid][2]);
	return 1;
}

YCMD:rozrezatstrom(playerid, params[], help)
{
    if(GetPlayerFaction(playerid) != FACTION_TYPE_WOODCUTTER && GetPlayerAdminLevel(playerid) < 5)
	    return SendError(playerid, "Tento príkaz nemôžeš použi!");

	if(Anawalt::isworking[playerid] == false && GetPlayerAdminLevel(playerid) < 5)
	    return SendError(playerid, "Teraz nepracuješ, nemôžeš reza strom!");
	    
    if(Anawalt::workid[playerid] != ANAWALT_WORK_TYPE_CUTUP && GetPlayerAdminLevel(playerid) < 5)
	    return SendError(playerid, "Teraz nepracuješ, nemôžeš reza strom!");

    if(!IsPlayerInDynamicArea(playerid, AnawaltArea) && GetPlayerAdminLevel(playerid) < 5 && GetPlayerFactionRank(playerid) < 7)
	    return SendError(playerid, "Tento príkaz môžeš použi iba na pozemku Anawalt Lumberu!");

	if(GetPlayerWeapon(playerid) != 9 && GetPlayerAdminLevel(playerid) < 5)
        return SendError(playerid, "Musíš ma v ruke motorovú pílu!");

	new id = -1;
	foreach(new x : Tree)
	{
	    if(!IsPlayerInDynamicArea(playerid,Anawalt::tree[x][tree_AreaId])) continue;
	    id = x;
	    break;
	}

	if(id == -1) return SendError(playerid, "Nestojíš pri žiadnom strome!");
	if(Anawalt::tree[id][tree_IsCutDown] == 0) return SendError(playerid, "Tento strom nie je pokácaný!");

	Anawalt::cutdown_treeid[playerid] 		= id;
	Anawalt::cutdown_count[playerid]    	= 0;
	Anawalt::cutdown_iscutting[playerid] 	= true;

	ApplyAnimation(playerid, "BASEBALL", "BAT_IDLE", 4.1, true, false, false, false, 0, true); // /baseball
	TogglePlayerControllable(playerid, 0);

	SendSuccess(playerid, "Pre rozrezanie stromu klikaj na lavé tlaèidlo myši (LMB) kým nebude status plný!");

	PlayerTextDrawTextSize(playerid, breakin_td[playerid][2], 37.000000 + (breakin_playerProgress[playerid] * 0.64), 0.000000);
	PlayerTextDrawShow(playerid, breakin_td[playerid][0]);
	PlayerTextDrawShow(playerid, breakin_td[playerid][1]);
	PlayerTextDrawShow(playerid, breakin_td[playerid][2]);
	return 1;
}

YCMD:zmazatstrom(playerid, params[], help)
{
    if(GetPlayerAdminLevel(playerid) < 5)
	    return SendError(playerid, "Tento príkaz nemôžeš použi!");

	new id = -1;
	foreach(new x : Tree)
	{
	    if(!IsPlayerInDynamicArea(playerid,Anawalt::tree[x][tree_AreaId])) continue;
	    id = x;
	    break;
	}

	if(id == -1) return SendError(playerid, "Nestojíš pri žiadnom strome!");

	Anawalt::TreeDestroy(id);

	SendSuccess(playerid, "Strom zmazaný!");
	return 1;
}

YCMD:anawaltinfo(playerid, params[], help)
{

    if(GetPlayerAdminLevel(playerid) < 2 && GetPlayerFaction(playerid) != FACTION_TYPE_WOODCUTTER)
	    return SendError(playerid, "Tento príkaz nemôžeš použi!");
	    
	new
	    fstr[256],
	    trees[3]
	;
	
	foreach(new x : Tree)
	{
	    trees[Anawalt::tree[x][tree_Type]-1] ++;
	}
	
	format(fstr, sizeof fstr, "{ffffff}Informace o stavu stromù:\n\n• %s - %d kusù\n• %s - %d kusù\n• %s - %d kusù",
	    Anawalt::treeTypeNames[1], trees[0],
	    Anawalt::treeTypeNames[2], trees[1],
	    Anawalt::treeTypeNames[3], trees[2]
	);
	
	ShowPlayerDialog(playerid, did_Null, DIALOG_STYLE_MSGBOX, "INFORMÁCIE", fstr, "OK", "");

	return 1;
}
