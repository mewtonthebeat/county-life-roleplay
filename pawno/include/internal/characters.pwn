////////////////////////////////////////////////////////////////////////////////

#define Character::     		chasel_
#define CharacterCreate::       chacre_
#define MAX_CHARACTER_COUNT     27
#define MAX_CHARACTER_PAGE      3
#define MULTIPLE_CHARACTER_FEE  300

////////////////////////////////////////////////////////////////////////////////

new bool:Character::isinselection[MAX_PLAYERS];
new bool:Character::isincreation[MAX_PLAYERS];
new bool:Character::noresponse[MAX_PLAYERS];
new CharacterCreate::actor[MAX_PLAYERS] = {-1, ...};
new Character::ids[MAX_PLAYERS][MAX_CHARACTER_COUNT];
new Character::count[MAX_PLAYERS];
new Character::countcurrent[MAX_PLAYERS];
new Character::currentpage[MAX_PLAYERS];
new Character::selected[MAX_PLAYERS];
new CharacterCreate::name[MAX_PLAYERS][MAX_PLAYER_NAME+1];
new CharacterCreate::gender[MAX_PLAYERS];
new bool:Character::ischarpaid[MAX_PLAYERS];
new PlayerText:character_SelectionTD[MAX_PLAYERS][19];
new PlayerText:character_CreateTD[MAX_PLAYERS][13];

new Float:Character::randomspawn[][] = {
    {-596.199218, -1077.756469, 23.610887},
	{-594.542419, -1075.340209, 23.564628},
	{-592.219970, -1072.182128, 23.509969},
	{-590.257751, -1068.182617, 23.460010},
	{-588.165466, -1065.029174, 23.438373},
	{-581.443237, -1054.877563, 23.708324},
	{-579.397094, -1051.493530, 23.788986},
	{-576.991394, -1048.118164, 23.888694},
	{-574.051574, -1043.706420, 24.008333},
	{-571.174560, -1038.868164, 24.108413},
	{-567.705017, -1034.470092, 24.152332},
	{-570.483276, -1121.299316, 22.723064}
};

////////////////////////////////////////////////////////////////////////////////

Character::ShowSelection(playerid)
{

	new tmp_char_names[MAX_CHARACTER_PAGE][MAX_PLAYER_NAME+1];
	new tmp_char_skins[MAX_CHARACTER_PAGE];
	new tmp_query[84];
	new Cache:tmp_cache;
	
	mysql_format(MYSQL, tmp_query, sizeof tmp_query, "SELECT * FROM char_main WHERE userID = '%d'", masterId[playerid]);
    tmp_cache = mysql_query(MYSQL, tmp_query);

	Character::isinselection[playerid]      = true;
	Character::isincreation[playerid]       = false;
	Character::noresponse[playerid]         = false;
	Character::currentpage[playerid]       	= 0;
	Character::count[playerid]              = 0;
	Character::countcurrent[playerid]       = 0;
	Character::selected[playerid]           = -1;
	Character::ischarpaid[playerid]         = false;
	
	format(CharacterCreate::name[playerid], MAX_PLAYER_NAME+1, "");
	
	//SetPlayerLoginCamera(playerid);
	SetPlayerVirtualWorld(playerid, 0);

	////////////////////////////////////////////////////////////////////////////

	// sem treba vytiahnut z databaze pocet charakterov a ulozit id IDcka
	
	for(new x, y = cache_num_rows(); x < y; x++)
	{
	    if(x < 3)
		{
		    cache_get_value_name(x, "Username", tmp_char_names[x]);
		    
		    for(new z, w = strlen(tmp_char_names[x]); z < w; z++)
		    {
		        tmp_char_names[x][z] = toupper(tmp_char_names[x][z]);
			}
		    
			cache_get_value_name_int(x, "skin_Civil", tmp_char_skins[x]);
		}
	    Character::count[playerid] ++;
	    Character::countcurrent[playerid] ++;
	    cache_get_value_name_int(x, "id", Character::ids[playerid][x]);
	}

	cache_delete(tmp_cache);

	if(Character::countcurrent[playerid] > 3)
		Character::countcurrent[playerid] = 3;

	////////////////////////////////////////////////////////////////////////////

	Character::CreateTextdraws(playerid);
	Character::ShowMainTextdraws(playerid);

	////////////////////////////////////////////////////////////////////////////

	if(Character::count[playerid] > 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, character_SelectionTD[playerid][4], tmp_char_skins[0]);
		PlayerTextDrawSetPreviewModel(playerid, character_SelectionTD[playerid][5], tmp_char_skins[1]);
		PlayerTextDrawSetPreviewModel(playerid, character_SelectionTD[playerid][6], tmp_char_skins[2]);

		PlayerTextDrawSetString(playerid, character_SelectionTD[playerid][9], tmp_char_names[0]);
		PlayerTextDrawSetString(playerid, character_SelectionTD[playerid][10], tmp_char_names[1]);
		PlayerTextDrawSetString(playerid, character_SelectionTD[playerid][11], tmp_char_names[2]);
		
		new pages[8];
		format(pages, sizeof pages, "%d/%d", Character::currentpage[playerid]+1, floatround(float(Character::count[playerid])/3.0, floatround_ceil));
		PlayerTextDrawSetString(playerid, character_SelectionTD[playerid][15], pages);

		Character::ShowCharacterTextdraw(playerid);
	}

	////////////////////////////////////////////////////////////////////////////

	SelectTextDraw(playerid, 0x78AD69FF);

	////////////////////////////////////////////////////////////////////////////

	return 1;
}

Character::UpdatePage(playerid, mult)
{
    Character::currentpage[playerid] += mult;
    
	if(Character::currentpage[playerid] < 0)
		Character::currentpage[playerid] = floatround(float(Character::count[playerid])/3.0, floatround_ceil)-1;
    
    if(Character::currentpage[playerid] >= (MAX_CHARACTER_COUNT/MAX_CHARACTER_PAGE) || Character::currentpage[playerid] >= floatround(float(Character::count[playerid])/3.0, floatround_ceil))
    	Character::currentpage[playerid] = 0;

    
    ////////////////////////////////////////////////////////////////////////////
    
    new tmp_char_names[MAX_CHARACTER_PAGE][MAX_PLAYER_NAME+1];
	new tmp_char_skins[MAX_CHARACTER_PAGE];
	new tmp_query[95];
	new Cache:tmp_cache;
	Character::countcurrent[playerid]	= 0;
	Character::Select(playerid, 0);

	mysql_format(
		MYSQL, tmp_query, sizeof tmp_query, "SELECT * FROM char_main WHERE (id='%d' OR id='%d' OR id='%d') AND userID = '%d'",
		Character::ids[playerid][Character::currentpage[playerid]*3], Character::ids[playerid][Character::currentpage[playerid]*3+1], Character::ids[playerid][Character::currentpage[playerid]*3+2], masterId[playerid]
	);
    tmp_cache = mysql_query(MYSQL, tmp_query);
    
    ////////////////////////////////////////////////////////////////////////////
    
    for(new x, y = cache_num_rows(); x < y; x++)
	{
	    if(x < 3)
		{
		    cache_get_value_name(x, "Username", tmp_char_names[x]);
		    
		    for(new z, w = strlen(tmp_char_names[x]); z < w; z++)
		    {
		        tmp_char_names[x][z] = toupper(tmp_char_names[x][z]);
			}
			
			cache_get_value_name_int(x, "skin_Civil", tmp_char_skins[x]);
			
			PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][4], -2139062017);
			PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][5], -2139062017);
			PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][6], -2139062017);
			
			Character::countcurrent[playerid] ++;
			
			continue;
		}
		break;
	}
	
	cache_delete(tmp_cache);
	
	////////////////////////////////////////////////////////////////////////////

	if(Character::count[playerid] > 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, character_SelectionTD[playerid][4], tmp_char_skins[0]);
		PlayerTextDrawSetPreviewModel(playerid, character_SelectionTD[playerid][5], tmp_char_skins[1]);
		PlayerTextDrawSetPreviewModel(playerid, character_SelectionTD[playerid][6], tmp_char_skins[2]);

		PlayerTextDrawSetString(playerid, character_SelectionTD[playerid][9], tmp_char_names[0]);
		PlayerTextDrawSetString(playerid, character_SelectionTD[playerid][10], tmp_char_names[1]);
		PlayerTextDrawSetString(playerid, character_SelectionTD[playerid][11], tmp_char_names[2]);
		
		new pages[8];
		format(pages, sizeof pages, "%d/%d", Character::currentpage[playerid]+1, floatround(float(Character::count[playerid])/3.0, floatround_ceil));
		PlayerTextDrawSetString(playerid, character_SelectionTD[playerid][15], pages);

		Character::ShowCharacterTextdraw(playerid);
	}
    
	return 1;
}

Character::Select(playerid, charid)
{
	if(charid == 0)
	{
	    PlayerTextDrawHide(playerid, character_SelectionTD[playerid][12]);
	    PlayerTextDrawHide(playerid, character_SelectionTD[playerid][13]);
	    PlayerTextDrawHide(playerid, character_SelectionTD[playerid][14]);
	}
	
	if(Character::selected[playerid] != 0)
	{
	    PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][3+Character::selected[playerid]], -2139062017);
	    PlayerTextDrawShow(playerid, character_SelectionTD[playerid][3+Character::selected[playerid]]);
	}
	
	if(charid != 0)
	{
		PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][3+charid], 0x427c38ff);
		PlayerTextDrawShow(playerid, character_SelectionTD[playerid][3+charid]);
		PlayerTextDrawShow(playerid, character_SelectionTD[playerid][12]);
	    PlayerTextDrawShow(playerid, character_SelectionTD[playerid][13]);
	    PlayerTextDrawShow(playerid, character_SelectionTD[playerid][14]);
	}
    
    Character::selected[playerid] = charid;
	
	return 0;
}

////////////////////////////////////////////////////////////////////////////////

Character::ShowMainTextdraws(playerid)
{

	PlayerTextDrawShow(playerid, character_SelectionTD[playerid][0]);
	PlayerTextDrawShow(playerid, character_SelectionTD[playerid][1]);
	PlayerTextDrawShow(playerid, character_SelectionTD[playerid][2]);

	PlayerTextDrawShow(playerid, character_SelectionTD[playerid][3]);
    PlayerTextDrawShow(playerid, character_SelectionTD[playerid][7]);
    PlayerTextDrawShow(playerid, character_SelectionTD[playerid][8]);

    if(Character::count[playerid] > MAX_CHARACTER_PAGE)
    {
        PlayerTextDrawShow(playerid, character_SelectionTD[playerid][15]);
        PlayerTextDrawShow(playerid, character_SelectionTD[playerid][16]);
        PlayerTextDrawShow(playerid, character_SelectionTD[playerid][17]);
    }

    if(Character::count[playerid] <= 0)
        PlayerTextDrawShow(playerid, character_SelectionTD[playerid][18]);

	return 1;
}

Character::DestroyTextdraws(playerid)
{
	PlayerTextDrawDestroy(playerid, character_SelectionTD[playerid][0]);
	PlayerTextDrawDestroy(playerid, character_SelectionTD[playerid][1]);
	PlayerTextDrawDestroy(playerid, character_SelectionTD[playerid][2]);
	PlayerTextDrawDestroy(playerid, character_SelectionTD[playerid][3]);
	PlayerTextDrawDestroy(playerid, character_SelectionTD[playerid][4]);
	PlayerTextDrawDestroy(playerid, character_SelectionTD[playerid][5]);
	PlayerTextDrawDestroy(playerid, character_SelectionTD[playerid][6]);
	PlayerTextDrawDestroy(playerid, character_SelectionTD[playerid][7]);
	PlayerTextDrawDestroy(playerid, character_SelectionTD[playerid][8]);
	PlayerTextDrawDestroy(playerid, character_SelectionTD[playerid][9]);
	PlayerTextDrawDestroy(playerid, character_SelectionTD[playerid][10]);
	PlayerTextDrawDestroy(playerid, character_SelectionTD[playerid][11]);
	PlayerTextDrawDestroy(playerid, character_SelectionTD[playerid][12]);
	PlayerTextDrawDestroy(playerid, character_SelectionTD[playerid][13]);
	PlayerTextDrawDestroy(playerid, character_SelectionTD[playerid][14]);
	PlayerTextDrawDestroy(playerid, character_SelectionTD[playerid][15]);
	PlayerTextDrawDestroy(playerid, character_SelectionTD[playerid][16]);
	PlayerTextDrawDestroy(playerid, character_SelectionTD[playerid][17]);
	PlayerTextDrawDestroy(playerid, character_SelectionTD[playerid][18]);
	return 1;
}

Character::CreateTextdraws(playerid)
{

    character_SelectionTD[playerid][0] = CreatePlayerTextDraw(playerid, 320.476287, 143.493316, "box");
	PlayerTextDrawLetterSize(playerid, character_SelectionTD[playerid][0], 0.000000, 16.933326);
	PlayerTextDrawTextSize(playerid, character_SelectionTD[playerid][0], 0.000000, 415.000000);
	PlayerTextDrawAlignment(playerid, character_SelectionTD[playerid][0], 2);
	PlayerTextDrawColor(playerid, character_SelectionTD[playerid][0], -1);
	PlayerTextDrawUseBox(playerid, character_SelectionTD[playerid][0], 1);
	PlayerTextDrawBoxColor(playerid, character_SelectionTD[playerid][0], 255);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, character_SelectionTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, character_SelectionTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, character_SelectionTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][0], 0);

	character_SelectionTD[playerid][1] = CreatePlayerTextDraw(playerid, 320.476257, 145.626647, "box");
	PlayerTextDrawLetterSize(playerid, character_SelectionTD[playerid][1], 0.000000, 16.399991);
	PlayerTextDrawTextSize(playerid, character_SelectionTD[playerid][1], 0.000000, 411.000000);
	PlayerTextDrawAlignment(playerid, character_SelectionTD[playerid][1], 2);
	PlayerTextDrawColor(playerid, character_SelectionTD[playerid][1], -1);
	PlayerTextDrawUseBox(playerid, character_SelectionTD[playerid][1], 1);
	PlayerTextDrawBoxColor(playerid, character_SelectionTD[playerid][1], -1061109505);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, character_SelectionTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, character_SelectionTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, character_SelectionTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][1], 0);

	character_SelectionTD[playerid][2] = CreatePlayerTextDraw(playerid, 326.190521, 146.053375, "CHOOSE YOUR CHARACTER");
	PlayerTextDrawLetterSize(playerid, character_SelectionTD[playerid][2], 0.197142, 0.833866);
	PlayerTextDrawAlignment(playerid, character_SelectionTD[playerid][2], 2);
	PlayerTextDrawColor(playerid, character_SelectionTD[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, character_SelectionTD[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, character_SelectionTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, character_SelectionTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][2], 0);

	character_SelectionTD[playerid][3] = CreatePlayerTextDraw(playerid, 119.476188, 158.413314, "");
	PlayerTextDrawLetterSize(playerid, character_SelectionTD[playerid][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, character_SelectionTD[playerid][3], 96.000000, 120.000000);
	PlayerTextDrawAlignment(playerid, character_SelectionTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, character_SelectionTD[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, character_SelectionTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][3], -2139062017);
	PlayerTextDrawFont(playerid, character_SelectionTD[playerid][3], 5);
	PlayerTextDrawSetProportional(playerid, character_SelectionTD[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][3], 0);
	PlayerTextDrawSetSelectable(playerid, character_SelectionTD[playerid][3], true);
	PlayerTextDrawSetPreviewModel(playerid, character_SelectionTD[playerid][3], 2000);
	PlayerTextDrawSetPreviewRot(playerid, character_SelectionTD[playerid][3], 0.000000, 0.000000, 0.000000, -1.000000);

	character_SelectionTD[playerid][4] = CreatePlayerTextDraw(playerid, 219.666687, 158.413314, "");
	PlayerTextDrawLetterSize(playerid, character_SelectionTD[playerid][4], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, character_SelectionTD[playerid][4], 96.000000, 120.000000);
	PlayerTextDrawAlignment(playerid, character_SelectionTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, character_SelectionTD[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, character_SelectionTD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][4], -2139062017);
	PlayerTextDrawFont(playerid, character_SelectionTD[playerid][4], 5);
	PlayerTextDrawSetProportional(playerid, character_SelectionTD[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][4], 0);
	PlayerTextDrawSetSelectable(playerid, character_SelectionTD[playerid][4], true);
	PlayerTextDrawSetPreviewModel(playerid, character_SelectionTD[playerid][4], 61);
	PlayerTextDrawSetPreviewRot(playerid, character_SelectionTD[playerid][4], 0.000000, 0.000000, 0.000000, 1.000000);

	character_SelectionTD[playerid][5] = CreatePlayerTextDraw(playerid, 321.761749, 158.413314, "");
	PlayerTextDrawLetterSize(playerid, character_SelectionTD[playerid][5], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, character_SelectionTD[playerid][5], 96.000000, 120.000000);
	PlayerTextDrawAlignment(playerid, character_SelectionTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, character_SelectionTD[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, character_SelectionTD[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][5], -2139062017);
	PlayerTextDrawFont(playerid, character_SelectionTD[playerid][5], 5);
	PlayerTextDrawSetProportional(playerid, character_SelectionTD[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][5], 0);
	PlayerTextDrawSetSelectable(playerid, character_SelectionTD[playerid][5], true);
	PlayerTextDrawSetPreviewModel(playerid, character_SelectionTD[playerid][5], 62);
	PlayerTextDrawSetPreviewRot(playerid, character_SelectionTD[playerid][5], 0.000000, 0.000000, 0.000000, 1.000000);

	character_SelectionTD[playerid][6] = CreatePlayerTextDraw(playerid, 422.714202, 157.986648, "");
	PlayerTextDrawLetterSize(playerid, character_SelectionTD[playerid][6], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, character_SelectionTD[playerid][6], 96.000000, 120.000000);
	PlayerTextDrawAlignment(playerid, character_SelectionTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, character_SelectionTD[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, character_SelectionTD[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][6], -2139062017);
	PlayerTextDrawFont(playerid, character_SelectionTD[playerid][6], 5);
	PlayerTextDrawSetProportional(playerid, character_SelectionTD[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][6], 0);
	PlayerTextDrawSetSelectable(playerid, character_SelectionTD[playerid][6], true);
	PlayerTextDrawSetPreviewModel(playerid, character_SelectionTD[playerid][6], 65);
	PlayerTextDrawSetPreviewRot(playerid, character_SelectionTD[playerid][6], 0.000000, 0.000000, 0.000000, 1.000000);

	character_SelectionTD[playerid][7] = CreatePlayerTextDraw(playerid, 165.428604, 198.533325, "+");
	PlayerTextDrawLetterSize(playerid, character_SelectionTD[playerid][7], 0.848380, 3.468798);
	PlayerTextDrawAlignment(playerid, character_SelectionTD[playerid][7], 2);
	PlayerTextDrawColor(playerid, character_SelectionTD[playerid][7], -1061109505);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, character_SelectionTD[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][7], 255);
	PlayerTextDrawFont(playerid, character_SelectionTD[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, character_SelectionTD[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][7], 0);

	character_SelectionTD[playerid][8] = CreatePlayerTextDraw(playerid, 168.857208, 224.560058, "CREATE NEW");
	PlayerTextDrawLetterSize(playerid, character_SelectionTD[playerid][8], 0.165904, 0.671733);
	PlayerTextDrawAlignment(playerid, character_SelectionTD[playerid][8], 2);
	PlayerTextDrawColor(playerid, character_SelectionTD[playerid][8], -1061109505);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, character_SelectionTD[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][8], 255);
	PlayerTextDrawFont(playerid, character_SelectionTD[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, character_SelectionTD[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][8], 0);

	character_SelectionTD[playerid][9] = CreatePlayerTextDraw(playerid, 270.190521, 271.493347, "SONNY LAVERY");
	PlayerTextDrawLetterSize(playerid, character_SelectionTD[playerid][9], 0.165904, 0.671733);
	PlayerTextDrawAlignment(playerid, character_SelectionTD[playerid][9], 2);
	PlayerTextDrawColor(playerid, character_SelectionTD[playerid][9], -1061109505);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, character_SelectionTD[playerid][9], 0);
	PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][9], 255);
	PlayerTextDrawFont(playerid, character_SelectionTD[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, character_SelectionTD[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][9], 0);

	character_SelectionTD[playerid][10] = CreatePlayerTextDraw(playerid, 371.904785, 271.920013, "ROBERT COOKSON");
	PlayerTextDrawLetterSize(playerid, character_SelectionTD[playerid][10], 0.165904, 0.671733);
	PlayerTextDrawAlignment(playerid, character_SelectionTD[playerid][10], 2);
	PlayerTextDrawColor(playerid, character_SelectionTD[playerid][10], -1061109505);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, character_SelectionTD[playerid][10], 0);
	PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][10], 255);
	PlayerTextDrawFont(playerid, character_SelectionTD[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, character_SelectionTD[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][10], 0);

	character_SelectionTD[playerid][11] = CreatePlayerTextDraw(playerid, 472.857147, 271.493347, "SHANE HARDEN");
	PlayerTextDrawLetterSize(playerid, character_SelectionTD[playerid][11], 0.165904, 0.671733);
	PlayerTextDrawAlignment(playerid, character_SelectionTD[playerid][11], 2);
	PlayerTextDrawColor(playerid, character_SelectionTD[playerid][11], -1061109505);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, character_SelectionTD[playerid][11], 0);
	PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][11], 255);
	PlayerTextDrawFont(playerid, character_SelectionTD[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, character_SelectionTD[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][11], 0);

	character_SelectionTD[playerid][12] = CreatePlayerTextDraw(playerid, 240.857131, 282.159973, "ENTER GAME");
	PlayerTextDrawLetterSize(playerid, character_SelectionTD[playerid][12], 0.147428, 0.870400);
	PlayerTextDrawTextSize(playerid, character_SelectionTD[playerid][12], 8.000000, 65.000000);
	PlayerTextDrawAlignment(playerid, character_SelectionTD[playerid][12], 2);
	PlayerTextDrawColor(playerid, character_SelectionTD[playerid][12], -1);
	PlayerTextDrawUseBox(playerid, character_SelectionTD[playerid][12], 1);
	PlayerTextDrawBoxColor(playerid, character_SelectionTD[playerid][12], 673720575);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, character_SelectionTD[playerid][12], 1);
	PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][12], 255);
	PlayerTextDrawFont(playerid, character_SelectionTD[playerid][12], 2);
	PlayerTextDrawSetProportional(playerid, character_SelectionTD[playerid][12], 1);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][12], 0);
	PlayerTextDrawSetSelectable(playerid, character_SelectionTD[playerid][12], true);

	character_SelectionTD[playerid][13] = CreatePlayerTextDraw(playerid, 322.761810, 282.159973, "RENAME CHARACTER");
	PlayerTextDrawLetterSize(playerid, character_SelectionTD[playerid][13], 0.147428, 0.870400);
	PlayerTextDrawTextSize(playerid, character_SelectionTD[playerid][13], 8.000000, 90.000000);
	PlayerTextDrawAlignment(playerid, character_SelectionTD[playerid][13], 2);
	PlayerTextDrawColor(playerid, character_SelectionTD[playerid][13], -1);
	PlayerTextDrawUseBox(playerid, character_SelectionTD[playerid][13], 1);
	PlayerTextDrawBoxColor(playerid, character_SelectionTD[playerid][13], 673720575);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, character_SelectionTD[playerid][13], 1);
	PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][13], 255);
	PlayerTextDrawFont(playerid, character_SelectionTD[playerid][13], 2);
	PlayerTextDrawSetProportional(playerid, character_SelectionTD[playerid][13], 1);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][13], 0);
	PlayerTextDrawSetSelectable(playerid, character_SelectionTD[playerid][13], true);

	character_SelectionTD[playerid][14] = CreatePlayerTextDraw(playerid, 405.047668, 282.159973, "DELETE CHARACTER");
	PlayerTextDrawLetterSize(playerid, character_SelectionTD[playerid][14], 0.147428, 0.870400);
	PlayerTextDrawTextSize(playerid, character_SelectionTD[playerid][14], 8.000000, 65.000000);
	PlayerTextDrawAlignment(playerid, character_SelectionTD[playerid][14], 2);
	PlayerTextDrawColor(playerid, character_SelectionTD[playerid][14], -1);
	PlayerTextDrawUseBox(playerid, character_SelectionTD[playerid][14], 1);
	PlayerTextDrawBoxColor(playerid, character_SelectionTD[playerid][14], 673720575);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid, character_SelectionTD[playerid][14], 1);
	PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][14], 255);
	PlayerTextDrawFont(playerid, character_SelectionTD[playerid][14], 2);
	PlayerTextDrawSetProportional(playerid, character_SelectionTD[playerid][14], 1);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][14], 0);
	PlayerTextDrawSetSelectable(playerid, character_SelectionTD[playerid][14], true);

	character_SelectionTD[playerid][15] = CreatePlayerTextDraw(playerid, 524.285766, 147.333358, "_");
	PlayerTextDrawLetterSize(playerid, character_SelectionTD[playerid][15], 0.154666, 0.644266);
	PlayerTextDrawAlignment(playerid, character_SelectionTD[playerid][15], 3);
	PlayerTextDrawColor(playerid, character_SelectionTD[playerid][15], 673720575);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][15], 0);
	PlayerTextDrawSetOutline(playerid, character_SelectionTD[playerid][15], 0);
	PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][15], 255);
	PlayerTextDrawFont(playerid, character_SelectionTD[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid, character_SelectionTD[playerid][15], 1);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][15], 0);

	character_SelectionTD[playerid][16] = CreatePlayerTextDraw(playerid, 489.000091, 145.613296, "ld_beat:left");
	PlayerTextDrawLetterSize(playerid, character_SelectionTD[playerid][16], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, character_SelectionTD[playerid][16], 10.000000, 10.000000);
	PlayerTextDrawAlignment(playerid, character_SelectionTD[playerid][16], 1);
	PlayerTextDrawColor(playerid, character_SelectionTD[playerid][16], -1);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][16], 0);
	PlayerTextDrawSetOutline(playerid, character_SelectionTD[playerid][16], 0);
	PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][16], 255);
	PlayerTextDrawFont(playerid, character_SelectionTD[playerid][16], 4);
	PlayerTextDrawSetProportional(playerid, character_SelectionTD[playerid][16], 0);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][16], 0);
	PlayerTextDrawSetSelectable(playerid, character_SelectionTD[playerid][16], true);

	character_SelectionTD[playerid][17] = CreatePlayerTextDraw(playerid, 501.190521, 145.613296, "ld_beat:right");
	PlayerTextDrawLetterSize(playerid, character_SelectionTD[playerid][17], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, character_SelectionTD[playerid][17], 10.000000, 10.000000);
	PlayerTextDrawAlignment(playerid, character_SelectionTD[playerid][17], 1);
	PlayerTextDrawColor(playerid, character_SelectionTD[playerid][17], -1);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][17], 0);
	PlayerTextDrawSetOutline(playerid, character_SelectionTD[playerid][17], 0);
	PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][17], 255);
	PlayerTextDrawFont(playerid, character_SelectionTD[playerid][17], 4);
	PlayerTextDrawSetProportional(playerid, character_SelectionTD[playerid][17], 0);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][17], 0);
	PlayerTextDrawSetSelectable(playerid, character_SelectionTD[playerid][17], true);

	character_SelectionTD[playerid][18] = CreatePlayerTextDraw(playerid, 321.238098, 283.013336, "You do not have any available character. To enter game, press the plus icon to create one!");
	PlayerTextDrawLetterSize(playerid, character_SelectionTD[playerid][18], 0.209142, 0.827733);
	PlayerTextDrawAlignment(playerid, character_SelectionTD[playerid][18], 2);
	PlayerTextDrawColor(playerid, character_SelectionTD[playerid][18], 673720575);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][18], 0);
	PlayerTextDrawSetOutline(playerid, character_SelectionTD[playerid][18], 0);
	PlayerTextDrawBackgroundColor(playerid, character_SelectionTD[playerid][18], 255);
	PlayerTextDrawFont(playerid, character_SelectionTD[playerid][18], 1);
	PlayerTextDrawSetProportional(playerid, character_SelectionTD[playerid][18], 1);
	PlayerTextDrawSetShadow(playerid, character_SelectionTD[playerid][18], 0);

	return 1;
}

Character::ShowCharacterTextdraw(playerid)
{

	for(new x; x < MAX_CHARACTER_PAGE; x++)
	{
	    PlayerTextDrawHide(playerid, character_SelectionTD[playerid][4+x]);
	    PlayerTextDrawHide(playerid, character_SelectionTD[playerid][9+x]);
	}

	for(new x; x < Character::countcurrent[playerid]; x++)
	{
	    PlayerTextDrawShow(playerid, character_SelectionTD[playerid][4+x]);
	    PlayerTextDrawShow(playerid, character_SelectionTD[playerid][9+x]);
	}

	return 1;
}

Character::CreateNew(playerid)
{

	if(Character::count[playerid] >= 2)
	{
	    if(g_I_mince[playerid] < 300)
	    {
	        SendError(playerid, "You need to have at least 300 coins to create new character!");
	        return 1;
		}
	
	    new
	        string[144];

        Character::noresponse[playerid] = true;
		format(string, 144, "{ffffff}> If you want to create new character, you have to pay %d coins.\n> Are you sure about that?", MULTIPLE_CHARACTER_FEE);
		return ShowPlayerDialog(playerid, did_char_multiple, DIALOG_STYLE_MSGBOX, "CHARACTER FEE", string, "YES", "NO");
	}
	
	Character::ischarpaid[playerid] = false;
	CharacterCreate::StartCreation(playerid);

	return 1;
}

forward charselec_ShowSelection(playerid);
public charselec_ShowSelection(playerid)
{
    Character::ShowSelection(playerid);
    return 1;
}

CharacterCreate::Create(playerid)
{

	new string[ 512 ], postmp = random(sizeof(Character::randomspawn));

	mysql_format(MYSQL, string, sizeof string,
	    "INSERT INTO char_main (Username, Gender, Money, Health, Hunger, RoleplayLevel, LastOn, SkinID, skin_Civil, skinStorage1, PosX, PosY, PosZ, userID, active) VALUES ('%e', '%d', '%d.0', '100', '100', '1', NOW(), '%d', '%d', '%d', '%f', '%f', '%f', '%d', 1)",
	    CharacterCreate::name[playerid],
	    CharacterCreate::gender[playerid],
	    Register_Money,
	    
	    currSkinModel[playerid],
	    currSkinModel[playerid],
	    currSkinModel[playerid],
	    
        Character::randomspawn[postmp][0], Character::randomspawn[postmp][1], Character::randomspawn[postmp][2],

	    masterId[playerid]
	);

	mysql_tquery(MYSQL, string, "charselec_ShowSelection", "d", playerid);
	
	if(Character::ischarpaid[playerid]==true)
	{
	    g_I_mince[playerid] -= MULTIPLE_CHARACTER_FEE;
	    mysql_format(MYSQL, string, sizeof string, "UPDATE master_accounts SET Mince = '%d' WHERE id = '%d'", g_I_mince[playerid], masterId[playerid]);
	    mysql_tquery(MYSQL, string);
	}
	
	
	if(CharacterCreate::actor[playerid] != -1)
    {
        DestroyDynamicActor(CharacterCreate::actor[playerid]);
        CharacterCreate::actor[playerid] = -1;
    }

    CharacterCreate::DestroyTextdraws(playerid);
    Character::isincreation[playerid] = false;
    
    SendSuccess(playerid, "Character created succesfully, you can use it now!");

	return 1;
}

CharacterCreate::StartCreation(playerid)
{
    Character::isinselection[playerid] 	= false;
    Character::isincreation[playerid]   = true;
	Character::noresponse[playerid]     = false;
	CharacterCreate::gender[playerid]         = 1;
	format(CharacterCreate::name[playerid], MAX_PLAYER_NAME+1, "");
	
	currSkinModel[playerid] = buyableMaleSkins[0];
	currSkinIndex[playerid] = 0;
	
	SetPlayerVirtualWorld(playerid, 11 + playerid);
	
	SetPlayerCamera(playerid, -1647.33, -2239.33, 31.47, -1643.029, -2239.33, 31.47);
	
	Streamer_Update(playerid);
	
	CharacterCreate::ActorMake(playerid);
	
	Character::DestroyTextdraws(playerid);
	CharacterCreate::CreateTextdraws(playerid);
	return 1;
}

CharacterCreate::ActorMake(playerid)
{

	if(CharacterCreate::actor[playerid] != -1)
	{
	    DestroyDynamicActor(CharacterCreate::actor[playerid]);
	    CharacterCreate::actor[playerid] = -1;
	}

	CharacterCreate::actor[playerid] = CreateDynamicActor(currSkinModel[playerid], -1641.029, -2239.33, 31.47, 90.0, 1, 100.0, 11 + playerid, -1, playerid);
	
	Streamer_Update(playerid);
	return 1;
}

CharacterCreate::UpdateSkin(playerid, bool:next = false, skinid = -1)
{
	if(skinid != -1)
	{
	    // custom skin id
	    
	    new forgender = -1;
	    
	    for(new x; x < sizeof buyableMaleSkins; x++)
	    {
	        if(skinid == buyableMaleSkins[x])
	        {
	            currSkinIndex[playerid] = x;
	            currSkinModel[playerid] = buyableMaleSkins[currSkinIndex[playerid]];
	            forgender = 1;
	            break;
	        }
		}
		
		if(forgender == -1)
		{
		    for(new x; x < sizeof buyableFemaleSkins; x++)
		    {
		        if(skinid == buyableFemaleSkins[x])
		        {
		            currSkinIndex[playerid] = x;
		            currSkinModel[playerid] = buyableFemaleSkins[currSkinIndex[playerid]];
		            forgender = 2;
		            break;
		        }
			}
		}
		
		Character::noresponse[playerid] = false;
		
		if(forgender == -1)
		{
		    SendError(playerid, "This skin isnt available!");
		    return 1;
		}
		
		if(forgender != CharacterCreate::gender[playerid])
		{
		    SendError(playerid, "This skin isnt available for your gender!");
		    return 1;
		}
		
		CharacterCreate::Refresh(playerid);
	    CharacterCreate::ActorMake(playerid);
	}
	else
	{
	    if(next)
	    {
	        if(CharacterCreate::gender[playerid] == 1)
	        {
	            if(currSkinIndex[playerid] + 1 >= sizeof(buyableMaleSkins))
					currSkinIndex[playerid] = 0;
				else
					currSkinIndex[playerid] ++;

                currSkinModel[playerid] = buyableMaleSkins[currSkinIndex[playerid]];
	        }
	        else
	        {
	            if(currSkinIndex[playerid] + 1 >= sizeof(buyableFemaleSkins))
					currSkinIndex[playerid] = 0;
				else
					currSkinIndex[playerid] ++;

				currSkinModel[playerid] = buyableFemaleSkins[currSkinIndex[playerid]];
	        }

	        CharacterCreate::Refresh(playerid);
	        CharacterCreate::ActorMake(playerid);
	    }
	    else
	    {
	        if(CharacterCreate::gender[playerid] == 1)
	        {
	            if(currSkinIndex[playerid] - 1 < 0)
					currSkinIndex[playerid] = sizeof(buyableMaleSkins)-1;
				else
					currSkinIndex[playerid] --;

                currSkinModel[playerid] = buyableMaleSkins[currSkinIndex[playerid]];
	        }
	        else
	        {
	            if(currSkinIndex[playerid] - 1 < 0)
					currSkinIndex[playerid] = sizeof(buyableFemaleSkins)-1;
				else
					currSkinIndex[playerid] --;

				currSkinModel[playerid] = buyableFemaleSkins[currSkinIndex[playerid]];
	        }

	        CharacterCreate::Refresh(playerid);
	        CharacterCreate::ActorMake(playerid);
	    }
	}
	return 1;
}

CharacterCreate::Refresh(playerid)
{

	if(strlen(CharacterCreate::name[playerid]) > 5)
	{
	    PlayerTextDrawSetString(playerid, character_CreateTD[playerid][4], str_replace("_", " ", CharacterCreate::name[playerid]));
	    PlayerTextDrawSetSelectable(playerid, character_CreateTD[playerid][8], true);
	    PlayerTextDrawShow(playerid, character_CreateTD[playerid][8]);
	}
	
	switch(CharacterCreate::gender[playerid])
	{
	    case 1:
	    {
	        PlayerTextDrawBoxColor(playerid, character_CreateTD[playerid][6], 5243135);
	        PlayerTextDrawBoxColor(playerid, character_CreateTD[playerid][7], 673720575);
	        
	        PlayerTextDrawShow(playerid, character_CreateTD[playerid][6]);
	        PlayerTextDrawShow(playerid, character_CreateTD[playerid][7]);
	    }
	    
	    default:
	    {
	        PlayerTextDrawBoxColor(playerid, character_CreateTD[playerid][6], 673720575);
	        PlayerTextDrawBoxColor(playerid, character_CreateTD[playerid][7], 5243135);
	        
	        PlayerTextDrawShow(playerid, character_CreateTD[playerid][6]);
	        PlayerTextDrawShow(playerid, character_CreateTD[playerid][7]);
	    }
	}
	
	new tstrskin[10];
	format(tstrskin, sizeof tstrskin, "%d", currSkinModel[playerid]);
	
	PlayerTextDrawSetString(playerid, character_CreateTD[playerid][10], tstrskin);
	PlayerTextDrawShow(playerid, character_CreateTD[playerid][10]);
	    
	return 1;
}

CharacterCreate::ChooseName(playerid)
{
    ShowPlayerDialog(playerid, did_char_cre_name, DIALOG_STYLE_INPUT, "CHARACTER NAME", "{FFFFFF}> Please specify your character's name in format {e34f4f}Firstname_Surname{FFFFFF}.", "OK", "BACK");
    Character::noresponse[playerid] = true;
	return 1;
}

CharacterCreate::CreateTextdraws(playerid)
{

	character_CreateTD[playerid][0] = CreatePlayerTextDraw(playerid, 128.476165, 155.013351, "box");
	PlayerTextDrawLetterSize(playerid, character_CreateTD[playerid][0], 0.000000, 11.257130);
	PlayerTextDrawTextSize(playerid, character_CreateTD[playerid][0], 0.000000, 143.000000);
	PlayerTextDrawAlignment(playerid, character_CreateTD[playerid][0], 2);
	PlayerTextDrawColor(playerid, character_CreateTD[playerid][0], -1);
	PlayerTextDrawUseBox(playerid, character_CreateTD[playerid][0], 1);
	PlayerTextDrawBoxColor(playerid, character_CreateTD[playerid][0], 255);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, character_CreateTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, character_CreateTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, character_CreateTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, character_CreateTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][0], 0);

	character_CreateTD[playerid][1] = CreatePlayerTextDraw(playerid, 128.476165, 157.573348, "box");
	PlayerTextDrawLetterSize(playerid, character_CreateTD[playerid][1], 0.000000, 10.609502);
	PlayerTextDrawTextSize(playerid, character_CreateTD[playerid][1], 0.000000, 138.000000);
	PlayerTextDrawAlignment(playerid, character_CreateTD[playerid][1], 2);
	PlayerTextDrawColor(playerid, character_CreateTD[playerid][1], -1);
	PlayerTextDrawUseBox(playerid, character_CreateTD[playerid][1], 1);
	PlayerTextDrawBoxColor(playerid, character_CreateTD[playerid][1], -1061109505);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, character_CreateTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, character_CreateTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, character_CreateTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, character_CreateTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][1], 0);

	character_CreateTD[playerid][2] = CreatePlayerTextDraw(playerid, 128.095245, 159.706665, "CHARACTER CREATION");
	PlayerTextDrawLetterSize(playerid, character_CreateTD[playerid][2], 0.256379, 0.955733);
	PlayerTextDrawAlignment(playerid, character_CreateTD[playerid][2], 2);
	PlayerTextDrawColor(playerid, character_CreateTD[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, character_CreateTD[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, character_CreateTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, character_CreateTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, character_CreateTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][2], 0);

	character_CreateTD[playerid][3] = CreatePlayerTextDraw(playerid, 104.095260, 178.053314, "CHARACTER NAME");
	PlayerTextDrawLetterSize(playerid, character_CreateTD[playerid][3], 0.159619, 0.797867);
	PlayerTextDrawAlignment(playerid, character_CreateTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, character_CreateTD[playerid][3], 673720575);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, character_CreateTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, character_CreateTD[playerid][3], -2139062017);
	PlayerTextDrawFont(playerid, character_CreateTD[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, character_CreateTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][3], 0);

	character_CreateTD[playerid][4] = CreatePlayerTextDraw(playerid, 69.047622, 187.013305, "click here to edit ...");
	PlayerTextDrawLetterSize(playerid, character_CreateTD[playerid][4], 0.198856, 0.806400);
	PlayerTextDrawTextSize(playerid, character_CreateTD[playerid][4], 186.000000, 10.000000);
	PlayerTextDrawAlignment(playerid, character_CreateTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, character_CreateTD[playerid][4], -1);
	PlayerTextDrawUseBox(playerid, character_CreateTD[playerid][4], 1);
	PlayerTextDrawBoxColor(playerid, character_CreateTD[playerid][4], 673720575);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, character_CreateTD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, character_CreateTD[playerid][4], -2139062017);
	PlayerTextDrawFont(playerid, character_CreateTD[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, character_CreateTD[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][4], 0);
	PlayerTextDrawSetSelectable(playerid, character_CreateTD[playerid][4], true);

	character_CreateTD[playerid][5] = CreatePlayerTextDraw(playerid, 97.619056, 197.679962, "CHARACTER GENDER");
	PlayerTextDrawLetterSize(playerid, character_CreateTD[playerid][5], 0.159619, 0.797867);
	PlayerTextDrawAlignment(playerid, character_CreateTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, character_CreateTD[playerid][5], 673720575);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, character_CreateTD[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, character_CreateTD[playerid][5], -2139062017);
	PlayerTextDrawFont(playerid, character_CreateTD[playerid][5], 2);
	PlayerTextDrawSetProportional(playerid, character_CreateTD[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][5], 0);

	character_CreateTD[playerid][6] = CreatePlayerTextDraw(playerid, 95.714286, 206.213287, "MAN");
	PlayerTextDrawLetterSize(playerid, character_CreateTD[playerid][6], 0.198856, 0.806400);
	PlayerTextDrawTextSize(playerid, character_CreateTD[playerid][6], 10.000000, 53.000000);
	PlayerTextDrawAlignment(playerid, character_CreateTD[playerid][6], 2);
	PlayerTextDrawColor(playerid, character_CreateTD[playerid][6], -1);
	PlayerTextDrawUseBox(playerid, character_CreateTD[playerid][6], 1);
	PlayerTextDrawBoxColor(playerid, character_CreateTD[playerid][6], 5243135);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, character_CreateTD[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, character_CreateTD[playerid][6], -2139062017);
	PlayerTextDrawFont(playerid, character_CreateTD[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, character_CreateTD[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][6], 0);
	PlayerTextDrawSetSelectable(playerid, character_CreateTD[playerid][6], true);

	character_CreateTD[playerid][7] = CreatePlayerTextDraw(playerid, 159.333374, 206.213287, "WOMAN");
	PlayerTextDrawLetterSize(playerid, character_CreateTD[playerid][7], 0.198856, 0.806400);
	PlayerTextDrawTextSize(playerid, character_CreateTD[playerid][7], 10.000000, 53.000000);
	PlayerTextDrawAlignment(playerid, character_CreateTD[playerid][7], 2);
	PlayerTextDrawColor(playerid, character_CreateTD[playerid][7], -1);
	PlayerTextDrawUseBox(playerid, character_CreateTD[playerid][7], 1);
	PlayerTextDrawBoxColor(playerid, character_CreateTD[playerid][7], 673720575);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, character_CreateTD[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, character_CreateTD[playerid][7], -2139062017);
	PlayerTextDrawFont(playerid, character_CreateTD[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, character_CreateTD[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][7], 0);
	PlayerTextDrawSetSelectable(playerid, character_CreateTD[playerid][7], true);

	character_CreateTD[playerid][8] = CreatePlayerTextDraw(playerid, 127.333328, 240.346588, "CONTINUE");
	PlayerTextDrawLetterSize(playerid, character_CreateTD[playerid][8], 0.166475, 0.785067);
	PlayerTextDrawTextSize(playerid, character_CreateTD[playerid][8], 10.000000, 116.000000);
	PlayerTextDrawAlignment(playerid, character_CreateTD[playerid][8], 2);
	PlayerTextDrawColor(playerid, character_CreateTD[playerid][8], -1061109505);
	PlayerTextDrawUseBox(playerid, character_CreateTD[playerid][8], 1);
	PlayerTextDrawBoxColor(playerid, character_CreateTD[playerid][8], 673720575);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, character_CreateTD[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, character_CreateTD[playerid][8], -2139062017);
	PlayerTextDrawFont(playerid, character_CreateTD[playerid][8], 2);
	PlayerTextDrawSetProportional(playerid, character_CreateTD[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][8], 0);
	PlayerTextDrawSetSelectable(playerid, character_CreateTD[playerid][8], true);

	character_CreateTD[playerid][9] = CreatePlayerTextDraw(playerid, 104.476188, 217.306610, "CHARACTER SKIN");
	PlayerTextDrawLetterSize(playerid, character_CreateTD[playerid][9], 0.159619, 0.797867);
	PlayerTextDrawAlignment(playerid, character_CreateTD[playerid][9], 1);
	PlayerTextDrawColor(playerid, character_CreateTD[playerid][9], 673720575);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, character_CreateTD[playerid][9], 0);
	PlayerTextDrawBackgroundColor(playerid, character_CreateTD[playerid][9], -2139062017);
	PlayerTextDrawFont(playerid, character_CreateTD[playerid][9], 2);
	PlayerTextDrawSetProportional(playerid, character_CreateTD[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][9], 0);
	
	new tstrskin[10];
	format(tstrskin, sizeof tstrskin, "%d", currSkinModel[playerid]);

	character_CreateTD[playerid][10] = CreatePlayerTextDraw(playerid, 127.333328, 225.839935, tstrskin);
	PlayerTextDrawLetterSize(playerid, character_CreateTD[playerid][10], 0.159619, 0.797867);
	PlayerTextDrawAlignment(playerid, character_CreateTD[playerid][10], 2);
	PlayerTextDrawTextSize(playerid, character_CreateTD[playerid][10], 10.000000, 23.000000);
	PlayerTextDrawColor(playerid, character_CreateTD[playerid][10], 673720575);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, character_CreateTD[playerid][10], 0);
	PlayerTextDrawBackgroundColor(playerid, character_CreateTD[playerid][10], -2139062017);
	PlayerTextDrawFont(playerid, character_CreateTD[playerid][10], 3);
	PlayerTextDrawSetProportional(playerid, character_CreateTD[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][10], 0);
	PlayerTextDrawSetSelectable(playerid, character_CreateTD[playerid][10], true);

	character_CreateTD[playerid][11] = CreatePlayerTextDraw(playerid, 105.380966, 224.973312, "ld_beat:left");
	PlayerTextDrawLetterSize(playerid, character_CreateTD[playerid][11], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, character_CreateTD[playerid][11], 10.000000, 10.000000);
	PlayerTextDrawAlignment(playerid, character_CreateTD[playerid][11], 1);
	PlayerTextDrawColor(playerid, character_CreateTD[playerid][11], -1);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, character_CreateTD[playerid][11], 0);
	PlayerTextDrawBackgroundColor(playerid, character_CreateTD[playerid][11], 255);
	PlayerTextDrawFont(playerid, character_CreateTD[playerid][11], 4);
	PlayerTextDrawSetProportional(playerid, character_CreateTD[playerid][11], 0);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][11], 0);
	PlayerTextDrawSetSelectable(playerid, character_CreateTD[playerid][11], true);

	character_CreateTD[playerid][12] = CreatePlayerTextDraw(playerid, 138.142852, 225.399978, "ld_beat:right");
	PlayerTextDrawLetterSize(playerid, character_CreateTD[playerid][12], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, character_CreateTD[playerid][12], 10.000000, 10.000000);
	PlayerTextDrawAlignment(playerid, character_CreateTD[playerid][12], 1);
	PlayerTextDrawColor(playerid, character_CreateTD[playerid][12], -1);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, character_CreateTD[playerid][12], 0);
	PlayerTextDrawBackgroundColor(playerid, character_CreateTD[playerid][12], 255);
	PlayerTextDrawFont(playerid, character_CreateTD[playerid][12], 4);
	PlayerTextDrawSetProportional(playerid, character_CreateTD[playerid][12], 0);
	PlayerTextDrawSetShadow(playerid, character_CreateTD[playerid][12], 0);
	PlayerTextDrawSetSelectable(playerid, character_CreateTD[playerid][12], true);
	
	for(new x; x < 13; x++)
	    PlayerTextDrawShow(playerid, character_CreateTD[playerid][x]);

	return 1;
}

CharacterCreate::DestroyTextdraws(playerid)
{
    for(new x; x < 13; x++)
	    PlayerTextDrawDestroy(playerid, character_CreateTD[playerid][x]);
	    
	return 1;
}

Character::OnPlayerClickPTD(playerid, PlayerText:playertextid)
{
	if(Character::isincreation[playerid] && Character::noresponse[playerid] == false)
	{
	    if(playertextid == character_CreateTD[playerid][4])
	    {
	        CharacterCreate::ChooseName(playerid);
	    }
	    
	    else if(playertextid == character_CreateTD[playerid][6])
	    {
	        if(CharacterCreate::gender[playerid] != 1)
	        {
	            currSkinModel[playerid] = buyableMaleSkins[0];
				currSkinIndex[playerid] = 0;

				CharacterCreate::ActorMake(playerid);
			}
	        CharacterCreate::gender[playerid] = 1;
	        CharacterCreate::Refresh(playerid);
	    }
	    
	    else if(playertextid == character_CreateTD[playerid][7])
	    {
	        if(CharacterCreate::gender[playerid] != 2)
	        {
	            currSkinModel[playerid] = buyableFemaleSkins[0];
				currSkinIndex[playerid] = 0;
				
				CharacterCreate::ActorMake(playerid);
			}
	        CharacterCreate::gender[playerid] = 2;
	        CharacterCreate::Refresh(playerid);
	    }
	    
	    else if(playertextid == character_CreateTD[playerid][10])
	    {
	        // manualne ID skinu
	        ShowPlayerDialog(playerid, did_char_create_skin, DIALOG_STYLE_INPUT, "MANUAL SKIN SELECTION", "{FFFFFF}> Specify skin ID!", "UPDATE", "BACK");
	        Character::noresponse[playerid] = true;
	    }
	    
	    else if(playertextid == character_CreateTD[playerid][11])
	    {
	        CharacterCreate::UpdateSkin(playerid, false);
	    }
	    
	    else if(playertextid == character_CreateTD[playerid][12])
	    {
	        CharacterCreate::UpdateSkin(playerid, true);
	    }
	    
	    else if(playertextid == character_CreateTD[playerid][8])
	    {
	        // vytvorit
	        if(strlen(CharacterCreate::name[playerid]) > 5)
	        	CharacterCreate::Create(playerid);
			else
			    SendError(playerid, "Choose your character name first!");
	    }
	}

	if(Character::isinselection[playerid] && Character::noresponse[playerid] == false)
	{
	    if(playertextid == character_SelectionTD[playerid][3])
	    {
			// tvorba charakteru
			Character::CreateNew(playerid);
	    }
	    
	    else if(playertextid == character_SelectionTD[playerid][4])
	    {
	        // character slot 1
			Character::Select(playerid, 1);
	    }
	    
	    else if(playertextid == character_SelectionTD[playerid][5])
	    {
	        // character slot 2
	        Character::Select(playerid, 2);
	    }
	    
	    else if(playertextid == character_SelectionTD[playerid][6])
	    {
	        // character slot 3
	        Character::Select(playerid, 3);
	    }
	    
	    else if(playertextid == character_SelectionTD[playerid][12])
	    {
	        // enter game
	        
	        Character_Spawn(playerid);
	    }
	    
	    else if(playertextid == character_SelectionTD[playerid][13])
	    {
	        // rename
	        Character_Rename(playerid);
	    }
	    
	    else if(playertextid == character_SelectionTD[playerid][14])
	    {
	        // zmazat
	        Character_Remove(playerid);
	    }

	    else if(playertextid == character_SelectionTD[playerid][16])
	    {
			// page back
			Character::UpdatePage(playerid, -1);
	    }

	    else if(playertextid == character_SelectionTD[playerid][17])
	    {
			// page next
			Character::UpdatePage(playerid, 1);
	    }
	}
	return 1;
}
