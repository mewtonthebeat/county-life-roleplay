#include <YSI\y_hooks>

/*

	.................ZACIATOK SKRIPTU.....................
	
	*
	    KUBKO
	    DOPLN ID DO FUNKCIE: ELM_CarHasModule(vehicleid)
	*
	
*/

//------------------------------------------------------------------------------

//kokotina
#define ELM_MAX_PTD             (12)
#define ELM_MAX_LISTITEM       	(7)
#define MAX_SPOTLIGHT_ROT_X     (12.0)
#define MIN_SPOTLIGHT_ROT_X     (-12.0)
#define MAX_SPOTLIGHT_ROT_Z     (45.0)
#define MIN_SPOTLIGHT_ROT_Z     (-45.0)
#define SPOTLIGHT_POWER         (0.8)
#define SPOTLIGHT_TIMER_DIFF    (30) 			// v ms
#define ELM_FLASH_TIMER_DIFF    (180)           // v ms
#define ELM_INVALID_TIMER       (Timer:-255)
#define ELM_MULTIPLE_DIRS       (2)
#define ELM_MAX_MAJAK           (4)
#define ELM_MAX_STATIC_OBJECT   (3)
#define ELM_INVALID_MAJAK       (-255)
#define ELM_INVALID_STATIC_OBJECT (-255)
#define	ELM_ALMOST_STATIC_CAM           		//toto vypnem ak to nebude podla nasich predstav haha
//koniec kokotiny (script neskoncil to az nizsie)

//aliasy
#define ELM_RefreshPlayerTextdraws( 	ELM_EnablePlayerTextdraws(
#define ELM_IsPlayerInModule(%1)        (GetPVarInt(%1, "ELM_IsUsing") != 0)
#define ELM_IsPlayerInSpotlight(%1)     \
	((GetPVarInt(%1, "ELM_IsUsing") != 0) && (GetPVarInt(%1, "ELM_CurrentItem") == 6) && (gELM_vehicleRegime[GetPlayerVehicleID(%1)][6] == 1))
#define ELM_PressedKey(%1) \
    (newkeys & %1) && !(oldkeys & %1)
#define ELM_ReleasedKey(%1) \
    (oldkeys & %1) && !(newkeys & %1)
//koniec aliasov

//custom callbacky
forward ELM_OnPlayerChangeModuleState(playerid, const vehicleid, const listitem, newstate);
//konec

//------------------------------------------------------------------------------

// klavesove skratky
#define ELM_KEY_OPEN    		KEY_YES     		//tlacidlo na otvorenie/zatvorenie modulu
#define ELM_KEY_SELECT          KEY_FIRE            // tlacidlo na zapnutie/vypnutie jednotliveho "modulu"
#define ELM_KEY_SCROLL    		KEY_ACTION     		// tlacidlo na scroll vpravo
#define ELM_KEY_MOVE_UP         KEY_ANALOG_UP       // tlacidlo na spotlight hore
#define ELM_KEY_MOVE_DOWN       KEY_ANALOG_DOWN     // tlacidlo na spotlight dole
#define ELM_KEY_MOVE_LEFT       KEY_ANALOG_LEFT     // tlacidlo na spotlight vlavo
#define ELM_KEY_MOVE_RIGHT      KEY_ANALOG_RIGHT    // tlacidlo na spotlight vpravo
// koniec klavesovych skratiek

//------------------------------------------------------------------------------

// premenne, enumy, etc
enum
{
	ELM_LISTITEM_MAJAK,
	ELM_LISTITEM_FLASH,
	ELM_LISTITEM_FRONT,
	ELM_LISTITEM_DIR_LEFT,
	ELM_LISTITEM_DIR_RIGHT,
	ELM_LISTITEM_DIR_BACK,
	ELM_LISTITEM_SPOTLIGHT,
	ELM_PTD_ARROW_RIGHT,
	ELM_PTD_ARROW_LEFT,
	ELM_PTD_ARROW_DOWN,
	ELM_PTD_ARROW_UP,
};

new PlayerText:gELM_PTD_bg[MAX_PLAYERS][3];
new PlayerText:gELM_PTD[MAX_PLAYERS][ELM_MAX_PTD];
new gELM_vehicleRegime[MAX_VEHICLES][7]; // 0 off, 1 on
new gELM_vehicleFlashLights[MAX_VEHICLES][2];
new gELM_vehicleMajakObject[MAX_VEHICLES][ELM_MAX_MAJAK];
new gELM_vehicleSpotlightObject[MAX_VEHICLES];
new gELM_vehicleFrontObject[MAX_VEHICLES];
new gELM_vehicleStaticObject[MAX_VEHICLES][ELM_MAX_STATIC_OBJECT];
new gELM_vehicleDirectionalObject[MAX_VEHICLES];
new Float:gELM_vehicleSpotlightRot[MAX_VEHICLES][5];
//new ELM_rotTimer[MAX_PLAYERS];
new Timer:ELM_spotlightMovement[MAX_PLAYERS];

new const A_ELM_spriteNames[][] = {
	"majaky",
	"flash",
	"front",
	"dirle",
	"dirri",
	"dirba",
	"spli"
};

new const Float:A_ELM_spritePointPos[][] = {
	{532.619262, 365.546612},   //majak
	{559.666564, 365.546612},   //flash
	{586.714538, 365.546612},   //front
	{533.000183, 391.999920},   //dirri
	{559.666809, 391.999920},   //dirle
	{586.714538, 391.999920},   //dirba
	{559.30981,  313.91}       	//spotlight
};

new const A_ELM_frontOffsets[][] = {
	//model auta    model objektu   x               y               z
	{407,       	-2009,			float:0.0, 		float:0.0,		float:0.0},
	{415,       	-2005,			float:0.0, 		float:0.0,		float:0.0},
	{416,       	-2010,			float:0.0, 		float:0.0,		float:0.0},
	{426,       	-2006,			float:0.0, 		float:0.0,		float:0.0},
	{490,       	-2003,			float:0.0, 		float:0.0,		float:0.0},
	{523,       	-2002,			float:0.0, 		float:0.0,		float:0.0},
	{541,       	-2001,			float:0.0, 		float:0.0,		float:0.0},
	{544,       	-2004,			float:0.0, 		float:0.0,		float:0.0},
	{560,       	-2008,			float:0.0, 		float:0.0,		float:0.0},
	{579,       	-2007,			float:0.0, 		float:-0.07,	float:0.1},
	{596,       	-2006,			float:0.0, 		float:0.0,		float:0.0},
	{597,       	-2006,			float:0.0, 		float:0.0,		float:0.0},
	{598,       	-2006,			float:0.0, 		float:0.0,		float:0.0},
    {599,       	-2007,			float:0.0, 		float:0.0,		float:0.0}
};

new const A_ELM_advisorOffsets[][] = {
	//model auta    x           	y               z                   rotacia
	{426,       	float:0.0, 		float:0.0,		float:0.0},
	{490,       	float:0.0, 		float:-1.36,	float:0.1},
	{560,           float:0.0,      float:0.29,     float:0.091},
	{579,       	float:0.0, 		float:-1.1,		float:0.4},
	{596,       	float:0.0, 		float:0.0,		float:0.0},
	{597,       	float:0.0, 		float:0.0,		float:0.0},
	{598,       	float:0.0, 		float:0.0,		float:0.0},
	{599,       	float:0.0, 		float:-0.96,	float:0.1}
};

new const A_ELM_majakOffsets[][] = {
	//modelid, 	model objektu,		oX,      			oY,         		oZ                  rY				rZ
	{402,       19797,              float:0.000, 		float:-0.049, 		float:0.629,	float:180.0},
	{402,       -2014,              float:0.000, 		float:-0.049, 		float:0.629,	float:0.0},
	
	{415,       19797,              float:0.000, 		float:0.140, 		float:0.422,	float:180.0},
	{415,       -2014,              float:0.000, 		float:0.140, 		float:0.422,	float:0.0},
	
	{426,       18646,              float:0.599, 		float:0.770, 		float:0.360,	float:0.0},
	
	{541,       19797,				float:0.0, 			float:0.350, 		float:0.499,	float:180.000},
	{541,       -2014,				float:0.0, 			float:0.320, 		float:0.499,	float:0.000},
	
	{560,       -2014,				float:-0.529, 		float:-0.200, 		float:0.860,	float:0.0},
	{560,       -2014,				float:0.529, 		float:-0.200, 		float:0.860,	float:0.0},
	
	{579,       19797,              float:0.000, 		float:0.650, 		float:0.621,	float:180.0},
	{579,       -2014,              float:0.000, 		float:0.650, 		float:0.621,	float:0.0},
	
	{596,       -2014,				float:-0.529, 		float:-0.380, 		float:0.910,	float:0.0},
	{596,       -2014,				float:0.529, 		float:-0.380, 		float:0.910,	float:0.0},
	
	{597,       -2014,				float:-0.529, 		float:-0.380, 		float:0.910,	float:0.0},
	{597,       -2014,				float:0.529, 		float:-0.380, 		float:0.910,	float:0.0},
	
	{598,       -2014,				float:0.520, 		float:-0.339, 		float:0.970,	float:0.0},
	{598,       -2014,				float:-0.520, 		float:-0.339, 		float:0.970,	float:0.0},
	
	{599,       -2014,				float:-0.629, 		float:0.029, 		float:1.150,	float:0.0},
	{599,       -2014,				float:0.629, 		float:0.029, 		float:1.150,	float:0.0}
};

new const A_ELM_spotlightBulbOffsets[][] = {
	//modelid, 	oX,      			oY,         		oZ					rY 
	{426,       float:-1.139, 		float:0.789, 		float:0.270,		float:0.0},
	{489,       float:-1.300, 		float:0.699, 		float:0.499,		float:0.0},
	{490,       float:-1.300, 		float:0.699, 		float:0.499,		float:0.0},
	{541,       float:-1.100, 		float:0.800, 		float:0.240,        float:0.0},
	{560,       float:-1.130, 		float:0.800, 		float:0.409,		float:0.0},
	{596,       float:-1.139, 		float:0.789, 		float:0.270,		float:0.0},
	{597,       float:-1.139, 		float:0.789, 		float:0.270,		float:0.0},
	{598,       float:-1.139, 		float:0.789, 		float:0.270,		float:0.0},
	{599,       float:-1.300, 		float:0.699, 		float:0.499,		float:0.0}
};

new const A_ELM_staticObjectOffsets[][] = {
	// model auta       model objektu		oX          	oY              oZ              rX              rY              rZ
	{560,               19420,              float:0.0, 		float:-0.200, 	float:0.829,   	float:0.0,   	float:0.0,   	float:0.0} // test
};
// koniec premennych, enumov a.i.

//------------------------------------------------------------------------------

// funkcie
stock ELM_decode_lights(lights, &front_left_light, &front_right_light, &back_lights)
{
    front_left_light = lights & 1;
    front_right_light = lights >> 2 & 1;
    back_lights = lights >> 6 & 1;
}

stock ELM_encode_lights(front_left_light, front_right_light, back_lights) return front_left_light | (front_right_light << 2) | (back_lights << 6);

stock ELM_CarHasModule(vehicleid)
{

	if(GetVehicleFaction(vehicleid) < 0 || GetVehicleFaction(vehicleid) > 255)
	    return 0;

	if(GetVehicleFactionType(vehicleid) == FACTION_TYPE_LAW || GetVehicleFactionType(vehicleid) == FACTION_TYPE_FIRE)
		return 1;

	return 0;

}

stock ELM_CreateVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, addsiren=0)
{

	new
		vehicleid = CreateVehicle(vehicletype, x, y, z, rotation, color1, color2, respawn_delay, addsiren)
	;
	
	for( new q; q < ELM_MAX_MAJAK; q++)
 		gELM_vehicleMajakObject[vehicleid][q] = ELM_INVALID_MAJAK;
 		
    for( new q; q < ELM_MAX_STATIC_OBJECT; q++)
 		gELM_vehicleStaticObject[vehicleid][q] = ELM_INVALID_STATIC_OBJECT;
 		
    gELM_vehicleFrontObject[vehicleid]=ELM_INVALID_MAJAK;
    gELM_vehicleDirectionalObject[vehicleid] = ELM_INVALID_MAJAK;
    gELM_vehicleSpotlightObject[vehicleid]=ELM_INVALID_MAJAK;
	
	if(ELM_CarHasModule(vehicleid))
	{
	    // vozidlo ma mat elmka
	    
	    new
	        beenfound = 0
		;
		
		for( new q; q < sizeof (A_ELM_staticObjectOffsets); q++ )
		{
		
		    if(beenfound != 0 && A_ELM_staticObjectOffsets[q][0] != vehicletype)
		        break; //mierna optimalizacia ???
			else if(A_ELM_staticObjectOffsets[q][0] != vehicletype)
			    continue;
			    
            gELM_vehicleStaticObject[vehicleid][beenfound] = CreateDynamicObject(A_ELM_staticObjectOffsets[q][1], 0.0, 0.0, -100.0, 0.0, 0.0, 0.0, -1, -1, -1, 150.0, 135.0, -1, 0);

			AttachDynamicObjectToVehicle(
	 			gELM_vehicleStaticObject[vehicleid][beenfound], vehicleid,
				 	Float:A_ELM_staticObjectOffsets[q][2], Float:A_ELM_staticObjectOffsets[q][3], Float:A_ELM_staticObjectOffsets[q][4],
				 	Float:A_ELM_staticObjectOffsets[q][5], Float:A_ELM_staticObjectOffsets[q][6], Float:A_ELM_staticObjectOffsets[q][7]
			);
		
		}
	    
	    return vehicleid;
	}

	return vehicleid;
}
#if defined _ALS_CreateVehicle
	#undef CreateVehicle
#else
	#define _ALS_CreateVehicle
#endif
#define CreateVehicle   ELM_CreateVehicle

/*
	ELMP_IsActive
	ELMP_LastType
	ELMP_Priority
	ELMP_Text1
*/

stock ELM_ShowInfoPanel(playerid, info[], time = 3000, priority = 0, bool:disappear = true)
{

	new
	    isactive = GetPVarInt(playerid, "ELMP_IsActive")
	;

	if(isactive == 1 && priority < GetPVarInt(playerid, "ELMP_Priority"))
	    return 0;
	    
	if(isactive)
	{
	    if(GetPVarInt(playerid, "ELMP_LastType") == 1)
	    {
		    PlayerTextDrawDestroy(playerid, gELM_PTD_bg[playerid][2]);
			
			gELM_PTD_bg[playerid][2] = PlayerText:INVALID_TEXT_DRAW;
	    }
	    else
	    {
	        stop Timer:GetPVarInt(playerid, "ELMP_Timer");
		    PlayerTextDrawDestroy(playerid, PlayerText:GetPVarInt(playerid, "ELMP_Text1"));
		}
	}
	    
    SetPVarInt(playerid, "ELMP_IsActive", 1);
    SetPVarInt(playerid, "ELMP_Priority", priority);

	if(disappear == false)
	{
	
	    if(gELM_PTD_bg[playerid][2] != PlayerText:INVALID_TEXT_DRAW)
	    {
	        PlayerTextDrawDestroy(playerid, gELM_PTD_bg[playerid][2]);
	    }
	
	    gELM_PTD_bg[playerid][2] = CreatePlayerTextDraw(playerid, 566.014599, 434.066528, info);
		PlayerTextDrawLetterSize(playerid, gELM_PTD_bg[playerid][2], 0.153142, 0.665600);
		PlayerTextDrawTextSize(playerid, gELM_PTD_bg[playerid][2], 0.000000, 97.000000);
		PlayerTextDrawAlignment(playerid, gELM_PTD_bg[playerid][2], 2);
		PlayerTextDrawColor(playerid, gELM_PTD_bg[playerid][2], -1);
		PlayerTextDrawUseBox(playerid, gELM_PTD_bg[playerid][2], 1);
		PlayerTextDrawBoxColor(playerid, gELM_PTD_bg[playerid][2], 1365817599);
		PlayerTextDrawSetShadow(playerid, gELM_PTD_bg[playerid][2], 1);
		PlayerTextDrawSetOutline(playerid, gELM_PTD_bg[playerid][2], 0);
		PlayerTextDrawBackgroundColor(playerid, gELM_PTD_bg[playerid][2], 255);
		PlayerTextDrawFont(playerid, gELM_PTD_bg[playerid][2], 1);
		PlayerTextDrawSetProportional(playerid, gELM_PTD_bg[playerid][2], 1);
		PlayerTextDrawSetShadow(playerid, gELM_PTD_bg[playerid][2], 1);
		
		PlayerTextDrawShow(playerid, gELM_PTD_bg[playerid][2]);
		
		SetPVarInt(playerid, "ELMP_LastType", 1);
		SetPVarInt(playerid, "ELMP_Text1", _:gELM_PTD_bg[playerid][2]);
		
		return 1;
	}
	else
	{
	
	    new
	        PlayerText:temporary
		;
		
		temporary = CreatePlayerTextDraw(playerid, 566.014599, 434.066528, info);
		PlayerTextDrawLetterSize(playerid, temporary, 0.153142, 0.665600);
		PlayerTextDrawTextSize(playerid, temporary, 0.000000, 97.000000);
		PlayerTextDrawAlignment(playerid, temporary, 2);
		PlayerTextDrawColor(playerid, temporary, -1);
		PlayerTextDrawUseBox(playerid, temporary, 1);
		PlayerTextDrawBoxColor(playerid, temporary, 1365817599);
		PlayerTextDrawSetShadow(playerid, temporary, 1);
		PlayerTextDrawSetOutline(playerid, temporary, 0);
		PlayerTextDrawBackgroundColor(playerid, temporary, 255);
		PlayerTextDrawFont(playerid, temporary, 1);
		PlayerTextDrawSetProportional(playerid, temporary, 1);
		PlayerTextDrawSetShadow(playerid, temporary, 1);
		
		PlayerTextDrawShow(playerid, temporary);
		
		SetPVarInt(playerid, "ELMP_LastType", 2);
		SetPVarInt(playerid, "ELMP_Text1", _:temporary);
		
		SetPVarInt(playerid, "ELMP_Timer", _:defer ELMhideinfopanel[time](playerid, _:temporary));
	
	}
	
	return 1;
}

stock ELM_RefreshTextdrawsForAll(fromplayerid, const vehicleid)
{

	foreach( new playerid : Player )
	{
	    if(fromplayerid == playerid)
	        continue;
	
		if(vehicleid != GetPlayerVehicleID(playerid))
		    continue;
		    
		if(!ELM_IsPlayerInModule(playerid))
		    continue;
		    
		ELM_RefreshPlayerTextdraws(playerid);
	}

	return 1;
}

stock ELM_RefreshPlayerTextdraw(playerid, const listitem)
{

	new
		tstr[ 16 + 1 + 2],
		pvid = GetPlayerVehicleID(playerid)
	;

    switch(gELM_vehicleRegime[pvid][listitem])
	{
		case 1: format(tstr, sizeof tstr, "mdl-3000:%sB", A_ELM_spriteNames[listitem]);
		default: format(tstr, sizeof tstr, "mdl-3000:%s", A_ELM_spriteNames[listitem]);
	}

    PlayerTextDrawSetString(playerid, gELM_PTD[playerid][listitem], tstr);
    PlayerTextDrawShow(playerid, gELM_PTD[playerid][listitem]);
    
    PlayerTextDrawDestroy(playerid, gELM_PTD[playerid][11]);
    gELM_PTD[playerid][11] = CreatePlayerTextDraw(playerid, A_ELM_spritePointPos[listitem][0], A_ELM_spritePointPos[listitem][1], "mdl-3000:point");
	PlayerTextDrawLetterSize(playerid, gELM_PTD[playerid][11], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, gELM_PTD[playerid][11], 14.000000, 14.000000);
	PlayerTextDrawAlignment(playerid, gELM_PTD[playerid][11], 1);
	PlayerTextDrawColor(playerid, gELM_PTD[playerid][11], -1);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, gELM_PTD[playerid][11], 0);
	PlayerTextDrawBackgroundColor(playerid, gELM_PTD[playerid][11], 255);
	PlayerTextDrawFont(playerid, gELM_PTD[playerid][11], 4);
	PlayerTextDrawSetProportional(playerid, gELM_PTD[playerid][11], 0);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][11], 0);
	PlayerTextDrawShow(playerid, gELM_PTD[playerid][11]);
	
	ELM_RefreshTextdrawsForAll(playerid, pvid);
    
	return 1;
}

stock ELM_EnablePlayerTextdraws(playerid)
{
	/*
	    "majaky",
		"flash",
		"front",
		"dirle",
		"dirri",
		"dirba",
		"spli"
	*/
	
	new
		tstr[ 16 + 1 + 2 ], //16 je max. pocet znakov, 1 na eos, 2 zaloha
		pvid = GetPlayerVehicleID(playerid),
		pos = GetPVarInt(playerid, "ELM_CurrentItem")
	;
	
	for( new x; x < ELM_MAX_LISTITEM; x ++ )
	{
	    switch(gELM_vehicleRegime[pvid][x])
		{
			case 1: format(tstr, sizeof tstr, "mdl-3000:%sB", A_ELM_spriteNames[x]);
			default: format(tstr, sizeof tstr, "mdl-3000:%s", A_ELM_spriteNames[x]);
		}
	
	    PlayerTextDrawSetString(playerid, gELM_PTD[playerid][x], tstr);
	    PlayerTextDrawShow(playerid, gELM_PTD[playerid][x]);
	}
	
	PlayerTextDrawShow(playerid, gELM_PTD_bg[playerid][0]);
	PlayerTextDrawShow(playerid, gELM_PTD_bg[playerid][1]);
	    
    PlayerTextDrawShow(playerid, gELM_PTD[playerid][7]);
    PlayerTextDrawShow(playerid, gELM_PTD[playerid][8]);
    PlayerTextDrawShow(playerid, gELM_PTD[playerid][9]);
    PlayerTextDrawShow(playerid, gELM_PTD[playerid][10]);
	    
	PlayerTextDrawDestroy(playerid, gELM_PTD[playerid][11]);
    gELM_PTD[playerid][11] = CreatePlayerTextDraw(playerid, A_ELM_spritePointPos[pos][0], A_ELM_spritePointPos[pos][1], "mdl-3000:point");
	PlayerTextDrawLetterSize(playerid, gELM_PTD[playerid][11], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, gELM_PTD[playerid][11], 14.000000, 14.000000);
	PlayerTextDrawAlignment(playerid, gELM_PTD[playerid][11], 1);
	PlayerTextDrawColor(playerid, gELM_PTD[playerid][11], -1);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, gELM_PTD[playerid][11], 0);
	PlayerTextDrawBackgroundColor(playerid, gELM_PTD[playerid][11], 255);
	PlayerTextDrawFont(playerid, gELM_PTD[playerid][11], 4);
	PlayerTextDrawSetProportional(playerid, gELM_PTD[playerid][11], 0);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][11], 0);
	PlayerTextDrawShow(playerid, gELM_PTD[playerid][11]);

	return;
}

stock ELM_DisablePlayerTextdraws(playerid)
{
	for( new x; x < ELM_MAX_PTD; x ++ )
		PlayerTextDrawDestroy(playerid, gELM_PTD[playerid][x]);
		
	PlayerTextDrawDestroy(playerid, gELM_PTD_bg[playerid][0]);
    PlayerTextDrawDestroy(playerid, gELM_PTD_bg[playerid][1]);
    
    if(GetPVarInt(playerid, "ELMP_IsActive") == 1)
    	ELM_ShowInfoPanel(playerid, "_", 1, 5000);
		
	return;
}

stock ELM_CreatePlayerTextdraws(playerid)
{

    gELM_PTD_bg[playerid][0] = CreatePlayerTextDraw(playerid, 520.857177, 300.079956, "box");
	PlayerTextDrawLetterSize(playerid, gELM_PTD_bg[playerid][0], 0.000000, 14.380947);
	PlayerTextDrawTextSize(playerid, gELM_PTD_bg[playerid][0], 612.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, gELM_PTD_bg[playerid][0], 1);
	PlayerTextDrawColor(playerid, gELM_PTD_bg[playerid][0], -1);
	PlayerTextDrawUseBox(playerid, gELM_PTD_bg[playerid][0], 1);
	PlayerTextDrawBoxColor(playerid, gELM_PTD_bg[playerid][0], 100);
	PlayerTextDrawSetShadow(playerid, gELM_PTD_bg[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, gELM_PTD_bg[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, gELM_PTD_bg[playerid][0], 255);
	PlayerTextDrawFont(playerid, gELM_PTD_bg[playerid][0], 2);
	PlayerTextDrawSetProportional(playerid, gELM_PTD_bg[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, gELM_PTD_bg[playerid][0], 0);

	gELM_PTD_bg[playerid][1] = CreatePlayerTextDraw(playerid, 566.571105, 289.413391, "EMERGENCY LIGHTNING MODULE");
	PlayerTextDrawLetterSize(playerid, gELM_PTD_bg[playerid][1], 0.175613, 0.806397);
	PlayerTextDrawTextSize(playerid, gELM_PTD_bg[playerid][1], 0.000000, 91.000000);
	PlayerTextDrawAlignment(playerid, gELM_PTD_bg[playerid][1], 2);
	PlayerTextDrawColor(playerid, gELM_PTD_bg[playerid][1], -1);
	PlayerTextDrawUseBox(playerid, gELM_PTD_bg[playerid][1], 1);
	PlayerTextDrawBoxColor(playerid, gELM_PTD_bg[playerid][1], 1652216319);
	PlayerTextDrawSetShadow(playerid, gELM_PTD_bg[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, gELM_PTD_bg[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, gELM_PTD_bg[playerid][1], 255);
	PlayerTextDrawFont(playerid, gELM_PTD_bg[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, gELM_PTD_bg[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, gELM_PTD_bg[playerid][1], 0);

    gELM_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 528.619262, 371.746612, "mdl-3000:majaky");
	PlayerTextDrawLetterSize(playerid, gELM_PTD[playerid][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, gELM_PTD[playerid][0], 22.000000, 22.000000);
	PlayerTextDrawAlignment(playerid, gELM_PTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, gELM_PTD[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, gELM_PTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, gELM_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, gELM_PTD[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, gELM_PTD[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][0], 0);

	gELM_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 555.666564, 371.746612, "mdl-3000:flash");
	PlayerTextDrawLetterSize(playerid, gELM_PTD[playerid][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, gELM_PTD[playerid][1], 22.000000, 22.000000);
	PlayerTextDrawAlignment(playerid, gELM_PTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, gELM_PTD[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, gELM_PTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, gELM_PTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, gELM_PTD[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, gELM_PTD[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][1], 0);

	gELM_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 582.714538, 371.746612, "mdl-3000:front");
	PlayerTextDrawLetterSize(playerid, gELM_PTD[playerid][2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, gELM_PTD[playerid][2], 22.000000, 22.000000);
	PlayerTextDrawAlignment(playerid, gELM_PTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, gELM_PTD[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, gELM_PTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, gELM_PTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, gELM_PTD[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, gELM_PTD[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][2], 0);

	gELM_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 529.000183, 398.199920, "mdl-3000:dirle");
	PlayerTextDrawLetterSize(playerid, gELM_PTD[playerid][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, gELM_PTD[playerid][3], 22.000000, 22.000000);
	PlayerTextDrawAlignment(playerid, gELM_PTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, gELM_PTD[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, gELM_PTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, gELM_PTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, gELM_PTD[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, gELM_PTD[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][3], 0);

	gELM_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 555.666809, 398.199920, "mdl-3000:dirri");
	PlayerTextDrawLetterSize(playerid, gELM_PTD[playerid][4], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, gELM_PTD[playerid][4], 22.000000, 22.000000);
	PlayerTextDrawAlignment(playerid, gELM_PTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, gELM_PTD[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, gELM_PTD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, gELM_PTD[playerid][4], 255);
	PlayerTextDrawFont(playerid, gELM_PTD[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, gELM_PTD[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][4], 0);

	gELM_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 582.714538, 398.199920, "mdl-3000:dirba");
	PlayerTextDrawLetterSize(playerid, gELM_PTD[playerid][5], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, gELM_PTD[playerid][5], 22.000000, 22.000000);
	PlayerTextDrawAlignment(playerid, gELM_PTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, gELM_PTD[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, gELM_PTD[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, gELM_PTD[playerid][5], 255);
	PlayerTextDrawFont(playerid, gELM_PTD[playerid][5], 4);
	PlayerTextDrawSetProportional(playerid, gELM_PTD[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][5], 0);

	gELM_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 553.380981, 320.119995, "mdl-3000:spli");
	PlayerTextDrawLetterSize(playerid, gELM_PTD[playerid][6], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, gELM_PTD[playerid][6], 25.000000, 25.000000);
	PlayerTextDrawAlignment(playerid, gELM_PTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, gELM_PTD[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, gELM_PTD[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, gELM_PTD[playerid][6], 255);
	PlayerTextDrawFont(playerid, gELM_PTD[playerid][6], 4);
	PlayerTextDrawSetProportional(playerid, gELM_PTD[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][6], 0);

	gELM_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 585.380737, 326.946655, "mdl-3000:sipka");
	PlayerTextDrawLetterSize(playerid, gELM_PTD[playerid][7], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, gELM_PTD[playerid][7], 10.000000, 10.000000);
	PlayerTextDrawAlignment(playerid, gELM_PTD[playerid][7], 1);
	PlayerTextDrawColor(playerid, gELM_PTD[playerid][7], -1);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, gELM_PTD[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, gELM_PTD[playerid][7], 255);
	PlayerTextDrawFont(playerid, gELM_PTD[playerid][7], 4);
	PlayerTextDrawSetProportional(playerid, gELM_PTD[playerid][7], 0);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][7], 0);

	gELM_PTD[playerid][8] = CreatePlayerTextDraw(playerid, 546.142639, 326.093322, "mdl-3000:sipka");
	PlayerTextDrawLetterSize(playerid, gELM_PTD[playerid][8], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, gELM_PTD[playerid][8], -10.000000, 10.000000);
	PlayerTextDrawAlignment(playerid, gELM_PTD[playerid][8], 1);
	PlayerTextDrawColor(playerid, gELM_PTD[playerid][8], -1);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, gELM_PTD[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, gELM_PTD[playerid][8], 255);
	PlayerTextDrawFont(playerid, gELM_PTD[playerid][8], 4);
	PlayerTextDrawSetProportional(playerid, gELM_PTD[playerid][8], 0);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][8], 0);

	gELM_PTD[playerid][9] = CreatePlayerTextDraw(playerid, 559.475952, 349.559967, "mdl-3000:sipkad");
	PlayerTextDrawLetterSize(playerid, gELM_PTD[playerid][9], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, gELM_PTD[playerid][9], 12.500000, 12.500000);
	PlayerTextDrawAlignment(playerid, gELM_PTD[playerid][9], 1);
	PlayerTextDrawColor(playerid, gELM_PTD[playerid][9], -1);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, gELM_PTD[playerid][9], 0);
	PlayerTextDrawBackgroundColor(playerid, gELM_PTD[playerid][9], 255);
	PlayerTextDrawFont(playerid, gELM_PTD[playerid][9], 4);
	PlayerTextDrawSetProportional(playerid, gELM_PTD[playerid][9], 0);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][9], 0);

	gELM_PTD[playerid][10] = CreatePlayerTextDraw(playerid, 560.238220, 315.426666, "mdl-3000:sipkad");
	PlayerTextDrawLetterSize(playerid, gELM_PTD[playerid][10], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, gELM_PTD[playerid][10], 12.500000, -12.500000);
	PlayerTextDrawAlignment(playerid, gELM_PTD[playerid][10], 1);
	PlayerTextDrawColor(playerid, gELM_PTD[playerid][10], -1);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, gELM_PTD[playerid][10], 0);
	PlayerTextDrawBackgroundColor(playerid, gELM_PTD[playerid][10], 255);
	PlayerTextDrawFont(playerid, gELM_PTD[playerid][10], 4);
	PlayerTextDrawSetProportional(playerid, gELM_PTD[playerid][10], 0);
	PlayerTextDrawSetShadow(playerid, gELM_PTD[playerid][10], 0);
	
	gELM_PTD[playerid][11] = CreatePlayerTextDraw(playerid, 0.0, 0.0, "mdl-3000:point");
	
	return (true);
}

stock ELM_PlayerSelectListitem(playerid, const listitem)
{
    new
	    veh = GetPlayerVehicleID(playerid),
	    retval = ELM_OnPlayerChangeModuleState(playerid, veh, listitem, !gELM_vehicleRegime[veh][listitem])
	;
	
	switch(retval)
	{
	    case 1:
	    {
			
			gELM_vehicleRegime[veh][listitem] = !gELM_vehicleRegime[veh][listitem];
			ELM_RefreshPlayerTextdraw(playerid, listitem);
		}
		
		case ELM_MULTIPLE_DIRS:
		 	ELM_ShowInfoPanel(playerid, "NEMUZES MIT ZAPNUTYCH VIC JAK JEDEN TRAFFIC ADVISOR!", 3500, 1);
		 	
		default:
            ELM_ShowInfoPanel(playerid, "TOHLE VOZIDLO NEDISPONUJE TOUTO FUNKCI!", 3500, 2);
	}
	
	return 1;
}

ELM_PlayerScrollListitem(playerid, const listitem)
{
    SetPVarInt(playerid, "ELM_CurrentItem", listitem);
    ELM_RefreshPlayerTextdraw(playerid, listitem);
    
    ELM_ShowInfoPanel(playerid, "_", 1, 5000);
    
    return 1;
}
// koniec funkcii

// callbacky
hook OnGameModeInit()
{
	ManualVehicleEngineAndLights();
	return 1;
}

stock ELM_PreprocessSpotlightMove(playerid, movtype)
{

	new
	    tdid = -255,
	    tstr[ 17 + 1 ]
	;
	
	switch(movtype)
	{
	    case 0:
	    {
			strcat(tstr, "mdl-3000:sipkadB");
			tdid = ELM_PTD_ARROW_UP;
		}
		
		case 1:
	    {
			strcat(tstr, "mdl-3000:sipkadB");
			tdid = ELM_PTD_ARROW_DOWN;
		}
		
		case 3:
	    {
			strcat(tstr, "mdl-3000:sipkaB");
			tdid = ELM_PTD_ARROW_LEFT;
		}
			
	    default:
	    {
			strcat(tstr, "mdl-3000:sipkaB");
			tdid = ELM_PTD_ARROW_RIGHT;
		}
	}
	
	ELM_spotlightMovement[playerid] = repeat ELMspotlightMovementTimer(playerid, GetPlayerVehicleID(playerid), movtype);
	PlayerTextDrawSetString(playerid, gELM_PTD[playerid][tdid], tstr);
	PlayerTextDrawShow(playerid, gELM_PTD[playerid][tdid]);

	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{


	if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleSeat(playerid) <= 1)
	{
	    if( ELM_CarHasModule( GetPlayerVehicleID(playerid) ) )
	    {
			if( (newkeys & ELM_KEY_OPEN) && !(oldkeys & ELM_KEY_OPEN) )
			{
			    // otvoril / zatvoril

			    if(!ELM_IsPlayerInModule(playerid))
			    {
				  	// otvoril
				  	ELM_CreatePlayerTextdraws(playerid);
				  	ELM_EnablePlayerTextdraws(playerid);
				  	SetPVarInt(playerid, "ELM_IsUsing", 1);
				  	SetPVarInt(playerid, "ELM_CurrentItem", GetPVarInt(playerid, "ELM_CurrentItem"));

				  	ELM_ShowInfoPanel(playerid, "~w~SCROLLUJES TLACIDLEM ~r~~k~~VEHICLE_FIREWEAPON_ALT~~w~, VYBERES ~r~~k~~VEHICLE_FIREWEAPON~~w~!", 3000, 0);
			    }
			    else
			    {
					// zatvara
					ELM_DisablePlayerTextdraws(playerid);
					DeletePVar(playerid, "ELM_IsUsing");
			    }
			}

			if( (newkeys & ELM_KEY_SCROLL) && !(oldkeys & ELM_KEY_SCROLL) )
			{
			    // scroll

			    if(!ELM_IsPlayerInModule(playerid))
			        return 0; // (???)

			    new
					tmp = GetPVarInt(playerid, "ELM_CurrentItem"),
					pos = (tmp + 1 >= 7) ? 0 : tmp + 1
				;

		        ELM_PlayerScrollListitem(playerid, pos);
			}

			if( (newkeys & ELM_KEY_SELECT) && !(oldkeys & ELM_KEY_SELECT) )
			{
				// select
				if(!ELM_IsPlayerInModule(playerid))
			        return 0; // (???)

				ELM_PlayerSelectListitem(playerid, GetPVarInt(playerid, "ELM_CurrentItem"));
			}

			//------------------------------------------------------------------------------------------------------
			// Spotlight pohybovanie

			if(ELM_spotlightMovement[playerid] == ELM_INVALID_TIMER && ELM_IsPlayerInSpotlight(playerid))
			{
			    //doteraz nedrzal tlacidlo
				if( ELM_PressedKey(ELM_KEY_MOVE_UP) )
	                ELM_PreprocessSpotlightMove(playerid, 0);
				else if( ELM_PressedKey(ELM_KEY_MOVE_DOWN) )
				    ELM_PreprocessSpotlightMove(playerid, 1);
				else if( ELM_PressedKey(ELM_KEY_MOVE_LEFT) )
				    ELM_PreprocessSpotlightMove(playerid, 3);
				else if( ELM_PressedKey(ELM_KEY_MOVE_RIGHT) )
				    ELM_PreprocessSpotlightMove(playerid, 2);
			}
			else if(ELM_IsPlayerInSpotlight(playerid))
			{
			    //doteraz drzal tlacidlo

			    if( ELM_ReleasedKey(ELM_KEY_MOVE_UP) || ELM_ReleasedKey(ELM_KEY_MOVE_DOWN) || ELM_ReleasedKey(ELM_KEY_MOVE_LEFT) || ELM_ReleasedKey(ELM_KEY_MOVE_RIGHT))
			    {
			        //pustil tlacidlo dohora

			        // vypneme ten timer ktory sme hore spustili
			        stop ELM_spotlightMovement[playerid];
			        ELM_spotlightMovement[playerid] = ELM_INVALID_TIMER;

			        PlayerTextDrawSetString(playerid, PlayerText:gELM_PTD[playerid][ELM_PTD_ARROW_UP], "mdl-3000:sipkad");
			        PlayerTextDrawSetString(playerid, PlayerText:gELM_PTD[playerid][ELM_PTD_ARROW_DOWN], "mdl-3000:sipkad");
			        PlayerTextDrawSetString(playerid, PlayerText:gELM_PTD[playerid][ELM_PTD_ARROW_LEFT], "mdl-3000:sipka");
			        PlayerTextDrawSetString(playerid, PlayerText:gELM_PTD[playerid][ELM_PTD_ARROW_RIGHT], "mdl-3000:sipka");

	    			PlayerTextDrawShow(playerid, PlayerText:gELM_PTD[playerid][ELM_PTD_ARROW_UP]);
	    			PlayerTextDrawShow(playerid, PlayerText:gELM_PTD[playerid][ELM_PTD_ARROW_DOWN]);
	    			PlayerTextDrawShow(playerid, PlayerText:gELM_PTD[playerid][ELM_PTD_ARROW_LEFT]);
	    			PlayerTextDrawShow(playerid, PlayerText:gELM_PTD[playerid][ELM_PTD_ARROW_RIGHT]);

			    }
			}
		}
	}

	return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(((oldstate == PLAYER_STATE_DRIVER) || (oldstate == PLAYER_STATE_PASSENGER)) && (ELM_IsPlayerInModule(playerid) || GetPVarInt(playerid, "ELM_IsUsingNow") == 1))
	{
	    // zatvara
		ELM_DisablePlayerTextdraws(playerid);
		DeletePVar(playerid, "ELM_IsUsing");
		DeletePVar(playerid, "ELM_IsUsingNow");
		
		if(ELM_spotlightMovement[playerid] != ELM_INVALID_TIMER)
		{
			stop ELM_spotlightMovement[playerid];
			ELM_spotlightMovement[playerid] = ELM_INVALID_TIMER;
		}
	}
	
	if(ELM_CarHasModule(GetPlayerVehicleID(playerid)) && ((newstate == PLAYER_STATE_DRIVER) || (newstate == PLAYER_STATE_PASSENGER)))
	{
		SetPVarInt(playerid, "ELM_IsUsingNow", 1);
		ELM_ShowInfoPanel(playerid, "~w~ELM PANEL OTEVRES TLACIDLEM ~r~~k~~CONVERSATION_YES~~w~!", .disappear = false);
	}

	return 1;
}

hook OnVehicleSpawn(vehicleid)
{

	for( new x; x < 7; x ++)
		gELM_vehicleRegime[vehicleid][x] = 0;

    for( new q; q < ELM_MAX_STATIC_OBJECT; q++)
 		gELM_vehicleStaticObject[vehicleid][q] = ELM_INVALID_STATIC_OBJECT;

	if(ELM_CarHasModule(vehicleid))
	{
	    // vozidlo ma mat elmka

	    new
	        beenfound = 0,
			vehicletype = GetVehicleModel(vehicleid)
		;

		for( new q; q < sizeof (A_ELM_staticObjectOffsets); q++ )
		{

		    if(beenfound != 0 && A_ELM_staticObjectOffsets[q][0] != vehicletype)
		        break; //mierna optimalizacia ???
			else if(A_ELM_staticObjectOffsets[q][0] != vehicletype)
			    continue;

            gELM_vehicleStaticObject[vehicleid][beenfound] = CreateDynamicObject(A_ELM_staticObjectOffsets[q][1], 0.0, 0.0, -100.0, 0.0, 0.0, 0.0, -1, -1, -1, 150.0, 135.0, -1, 0);

			AttachDynamicObjectToVehicle(
	 			gELM_vehicleStaticObject[vehicleid][beenfound], vehicleid,
				 	Float:A_ELM_staticObjectOffsets[q][2], Float:A_ELM_staticObjectOffsets[q][3], Float:A_ELM_staticObjectOffsets[q][4],
				 	Float:A_ELM_staticObjectOffsets[q][5], Float:A_ELM_staticObjectOffsets[q][6], Float:A_ELM_staticObjectOffsets[q][7]
			);

		}

	    return vehicleid;
	}
	
	return 1;
}

hook OnVehicleDeath(vehicleid)
{
	if(ELM_CarHasModule(vehicleid))
	{
		if(gELM_vehicleRegime[vehicleid][ELM_LISTITEM_MAJAK] == 1)
		{
		    DestroyDynamicObject(gELM_vehicleMajakObject[vehicleid][0]);
	     	DestroyDynamicObject(gELM_vehicleMajakObject[vehicleid][1]);
		}
		gELM_vehicleRegime[vehicleid][ELM_LISTITEM_MAJAK] = 0;

		if(gELM_vehicleRegime[vehicleid][ELM_LISTITEM_FRONT] == 1)
		    DestroyDynamicObject(gELM_vehicleFrontObject[vehicleid]);
        gELM_vehicleRegime[vehicleid][ELM_LISTITEM_FRONT] = 0;

	    if(gELM_vehicleRegime[vehicleid][ELM_LISTITEM_DIR_LEFT] == 1 || gELM_vehicleRegime[vehicleid][ELM_LISTITEM_DIR_RIGHT] == 1 || gELM_vehicleRegime[vehicleid][ELM_LISTITEM_DIR_BACK] == 1)
		    DestroyDynamicObject(gELM_vehicleDirectionalObject[vehicleid]);
		    
        gELM_vehicleRegime[vehicleid][ELM_LISTITEM_DIR_LEFT] 	= 0;
        gELM_vehicleRegime[vehicleid][ELM_LISTITEM_DIR_RIGHT] 	= 0;
        gELM_vehicleRegime[vehicleid][ELM_LISTITEM_DIR_BACK]    = 0;

		if(gELM_vehicleRegime[vehicleid][ELM_LISTITEM_SPOTLIGHT] == 1)
			DestroyDynamicObject(gELM_vehicleSpotlightObject[vehicleid]);
			
        gELM_vehicleRegime[vehicleid][ELM_LISTITEM_SPOTLIGHT]   = 0;

		for( new x; x < ELM_MAX_STATIC_OBJECT; x++)
		{
		    if( gELM_vehicleStaticObject[vehicleid][x] != ELM_INVALID_STATIC_OBJECT )
		    {
		        DestroyDynamicObject(gELM_vehicleStaticObject[vehicleid][x]);
		        gELM_vehicleStaticObject[vehicleid][x] = ELM_INVALID_STATIC_OBJECT;
			}
		}
	}
	
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
    if(ELM_spotlightMovement[playerid] != ELM_INVALID_TIMER)
	{
		stop ELM_spotlightMovement[playerid];
		ELM_spotlightMovement[playerid] = ELM_INVALID_TIMER;
	}
	return 1;
}

hook OnPlayerConnect(playerid)
{

    if(ELM_spotlightMovement[playerid] != ELM_INVALID_TIMER)
	{
		stop ELM_spotlightMovement[playerid];
		ELM_spotlightMovement[playerid] = ELM_INVALID_TIMER;
	}
	
	gELM_PTD_bg[playerid][2] = PlayerText:INVALID_TEXT_DRAW;
    
	return 1;
}
// koniec callbackov

// custom callbacky
/*
	VVV | Tento callback returnuje hodnoty!!!
	VVV | 1: bol vyvolany uspesne, zmeni sa farba, tzn. zapne sa kontrolka
	VVV | 0: nebol vyvolany uspesne, nezmeni sa farba, tzn. nezapne sa nic
*/
public ELM_OnPlayerChangeModuleState(playerid, const vehicleid, const listitem, newstate)
{

	switch(listitem)
	{
	    case ELM_LISTITEM_MAJAK:
	    {
	        switch(newstate)
	        {
		        case 0:
		        {
		            // vypol
		            for( new x; x < ELM_MAX_MAJAK; x++ )
		            {
		                if(gELM_vehicleMajakObject[vehicleid][x] != ELM_INVALID_MAJAK)
		                    DestroyDynamicObject(gELM_vehicleMajakObject[vehicleid][x]);

                        gELM_vehicleMajakObject[vehicleid][x] = ELM_INVALID_MAJAK;
		            }
		        }

		        case 1:
		        {
		            // zapol
		            new
		                Float:vX,
		                Float:vY,
		                Float:vZ,
		                Float:vRZ,

		                arrayid[ELM_MAX_MAJAK],
		                added = 0,
		                model = GetVehicleModel(vehicleid)
					;

					for( new x; x < sizeof(A_ELM_majakOffsets); x ++ )
					{
						if(A_ELM_majakOffsets[x][0] != model)
						    continue;

                        arrayid[added] = x;
						added ++;
					}

					if(added == -0)
					    return 0;

					for(new x; x < added; x++)
					{
			            vX = Float:A_ELM_majakOffsets[arrayid[x]][2];
			            vY = Float:A_ELM_majakOffsets[arrayid[x]][3];
			            vZ = Float:A_ELM_majakOffsets[arrayid[x]][4];
			            vRZ = Float:A_ELM_majakOffsets[arrayid[x]][5];

		    			gELM_vehicleMajakObject[vehicleid][x] = CreateDynamicObject(A_ELM_majakOffsets[arrayid[x]][1], 0.0, 0.0, -100.0, 0.0, 0.0, 0.0, -1, -1, -1, 150.0, 135.0, -1, 0);
						//gELM_vehicleMajakObject[vehicleid][x] = CreateDynamicObject(-2014, 0.0, 0.0, -100.0, 0.0, 0.0, 0.0, -1, -1, -1, 150.0, 135.0, -1, 0);

		     			/*AttachDynamicObjectToVehicle(
						 	gELM_vehicleMajakObject[vehicleid][x], vehicleid, vX, vY, vZ, 0.0, 0.0, 0.0
						);*/

						AttachDynamicObjectToVehicle(
						 	gELM_vehicleMajakObject[vehicleid][x], vehicleid, vX, vY, vZ, 0.0, 0.0, vRZ
						);
					}
		        }
			}
	    }

	    case ELM_LISTITEM_FLASH:
	    {

	        // klasicke elmko na baze larpu (xd)

	        switch( newstate )
	        {
	            case 0:
	            {
	                // elm vypol
	                new
					    lPanels,
					    lDoors,
					    lLights,
						lTires,
						lBack
					;

					GetVehicleDamageStatus(vehicleid, lPanels, lDoors, lLights, lTires);

					ELM_decode_lights(lLights, lBack, lBack, lBack); //do vsetkych hodnot sa ulozi svetlo,ale aktualna bude len nasa potrebna
					lLights = ELM_encode_lights(gELM_vehicleFlashLights[vehicleid][0], gELM_vehicleFlashLights[vehicleid][1], lBack);

					UpdateVehicleDamageStatus(vehicleid, lPanels, lDoors, lLights, lTires);
	            }

				case 1:
				{

					// elm zapol

					if(GetVehicleModel(vehicleid) == 523)
        				return 0; //HPV nemá ma hentu kekecinu

					new
					    lTemp,
					    lLights
					;

					GetVehicleDamageStatus(vehicleid, lTemp, lTemp, lLights, lTemp);
					ELM_decode_lights(lLights, gELM_vehicleFlashLights[vehicleid][0], gELM_vehicleFlashLights[vehicleid][1], lTemp);

					defer ELM_FlashRegimeUpdate(vehicleid, 0);
				}
	        }

	    }

	    case ELM_LISTITEM_FRONT:
	    {

	        switch(newstate)
	        {
	            case 0:
	            {
	                //vypol
	                DestroyDynamicObject(gELM_vehicleFrontObject[vehicleid]);
	                gELM_vehicleFrontObject[vehicleid]=ELM_INVALID_MAJAK;
	            }

	            case 1:
	            {
	                //zapol

	                new
	                    Float:vX,
	                    Float:vY,
	                    Float:vZ,

						arrayid = -1,
					    model = GetVehicleModel(vehicleid)
					;

					for( new x; x < sizeof(A_ELM_frontOffsets); x ++ )
					{
						if(A_ELM_frontOffsets[x][0] != model)
			   				continue;

						arrayid = x;
						break;
					}

					if(arrayid == -1)
					    return 0;

					vX = Float:A_ELM_frontOffsets[arrayid][2];
					vY = Float:A_ELM_frontOffsets[arrayid][3];
					vZ = Float:A_ELM_frontOffsets[arrayid][4];

					gELM_vehicleFrontObject[vehicleid] = CreateDynamicObject(A_ELM_frontOffsets[arrayid][1], 0.0, 0.0, -100.0, 0.0, 0.0, 0.0, -1, -1, -1, 150.0, 135.0, -1, 0);

					AttachDynamicObjectToVehicle(
						gELM_vehicleFrontObject[vehicleid], vehicleid, vX, vY, vZ, 0.0, 0.0, 0.0
					);
	            }
	        }

	    }

	    case ELM_LISTITEM_DIR_LEFT:
	    {
	        if(gELM_vehicleRegime[vehicleid][ELM_LISTITEM_DIR_BACK] == 1 || gELM_vehicleRegime[vehicleid][ELM_LISTITEM_DIR_RIGHT] == 1)
	            return ELM_MULTIPLE_DIRS; // nemoze mat zapnute viacere naraz, makes no sense

			switch(newstate)
			{
			    case 0:
			    {
			        //vypol
			        DestroyDynamicObject(gELM_vehicleDirectionalObject[vehicleid]);
			        gELM_vehicleDirectionalObject[vehicleid]=ELM_INVALID_MAJAK;
			    }

			    case 1:
			    {
			        //zapol

     				new
			            Float:vX,
			            Float:vY,
			            Float:vZ,

						arrayid = -1,
					    model = GetVehicleModel(vehicleid),
					    object = -2011
					;

					for( new x; x < sizeof(A_ELM_advisorOffsets); x ++ )
					{
						if(A_ELM_advisorOffsets[x][0] != model)
			   				continue;

						arrayid = x;
						break;
					}

					if(arrayid == -1)
					    return 0;

					vX = Float:A_ELM_advisorOffsets[arrayid][1];
					vY = Float:A_ELM_advisorOffsets[arrayid][2];
					vZ = Float:A_ELM_advisorOffsets[arrayid][3];

			        gELM_vehicleDirectionalObject[vehicleid] = CreateDynamicObject(object, 0.0, 0.0, -100.0, 0.0, 0.0, 0.0, -1, -1, -1, 150.0, 135.0, -1, 0);

					AttachDynamicObjectToVehicle(
						gELM_vehicleDirectionalObject[vehicleid], vehicleid, vX, vY, vZ, 0.0, 0.0, 0.0
					);
			    }
			}
	    }

	    case ELM_LISTITEM_DIR_RIGHT:
	    {
	        if(gELM_vehicleRegime[vehicleid][ELM_LISTITEM_DIR_LEFT] == 1 || gELM_vehicleRegime[vehicleid][ELM_LISTITEM_DIR_BACK] == 1)
	            return ELM_MULTIPLE_DIRS; // nemoze mat zapnute viacere naraz, makes no sense

			switch(newstate)
			{
			    case 0:
			    {
			        //vypol
			        DestroyDynamicObject(gELM_vehicleDirectionalObject[vehicleid]);
			        gELM_vehicleDirectionalObject[vehicleid]=ELM_INVALID_MAJAK;
			    }

			    case 1:
			    {
			        //zapol
			        new
			            Float:vX,
			            Float:vY,
			            Float:vZ,

						arrayid = -1,
					    model = GetVehicleModel(vehicleid),
					    object = -2013
					;

					for( new x; x < sizeof(A_ELM_advisorOffsets); x ++ )
					{
						if(A_ELM_advisorOffsets[x][0] != model)
			   				continue;

						arrayid = x;
						break;
					}

					if(arrayid == -1)
					    return 0;

					vX = Float:A_ELM_advisorOffsets[arrayid][1];
					vY = Float:A_ELM_advisorOffsets[arrayid][2];
					vZ = Float:A_ELM_advisorOffsets[arrayid][3];

			        gELM_vehicleDirectionalObject[vehicleid] = CreateDynamicObject(object, 0.0, 0.0, -100.0, 0.0, 0.0, 0.0, -1, -1, -1, 150.0, 135.0, -1, 0);

					AttachDynamicObjectToVehicle(
						gELM_vehicleDirectionalObject[vehicleid], vehicleid, vX, vY, vZ, 0.0, 0.0, 0.0
					);
			    }
			}
	    }

	    case ELM_LISTITEM_DIR_BACK:
	    {
	        if(gELM_vehicleRegime[vehicleid][ELM_LISTITEM_DIR_LEFT] == 1 || gELM_vehicleRegime[vehicleid][ELM_LISTITEM_DIR_RIGHT] == 1)
	            return ELM_MULTIPLE_DIRS; // nemoze mat zapnute viacere naraz, makes no sense

			switch(newstate)
			{
			    case 0:
			    {
			        //vypol
			        DestroyDynamicObject(gELM_vehicleDirectionalObject[vehicleid]);
			        gELM_vehicleDirectionalObject[vehicleid]=ELM_INVALID_MAJAK;
			    }

			    case 1:
			    {
			        //zapol
			        new
			            Float:vX,
			            Float:vY,
			            Float:vZ,

						arrayid = -1,
					    model = GetVehicleModel(vehicleid),
					    object = -2012
					;

					for( new x; x < sizeof(A_ELM_advisorOffsets); x ++ )
					{
						if(A_ELM_advisorOffsets[x][0] != model)
			   				continue;

						arrayid = x;
						break;
					}

					if(arrayid == -1)
					    return 0;

					vX = Float:A_ELM_advisorOffsets[arrayid][1];
					vY = Float:A_ELM_advisorOffsets[arrayid][2];
					vZ = Float:A_ELM_advisorOffsets[arrayid][3];

					switch(model)
					{
					    case 599, 490:
					        object = -2015;

						case 579:
						    object = -2017;
					}

			        gELM_vehicleDirectionalObject[vehicleid] = CreateDynamicObject(object, 0.0, 0.0, -100.0, 0.0, 0.0, 0.0, -1, -1, -1, 150.0, 135.0, -1, 0);

					AttachDynamicObjectToVehicle(
						gELM_vehicleDirectionalObject[vehicleid], vehicleid, vX, vY, vZ, 0.0, 0.0, 0.0
					);
			    }
			}
	    }

		case ELM_LISTITEM_SPOTLIGHT:
		{
		    switch(newstate)
		    {
		        case 0:
		        {
		            DestroyDynamicObject(gELM_vehicleSpotlightObject[vehicleid]);
		            gELM_vehicleSpotlightObject[vehicleid]=ELM_INVALID_MAJAK;
		        }

		        case 1:
		        {

		            new
			 			Float:vX,
					    Float:vY,
					    Float:vZ,
					    Float:vRY,

						arrayid = -1,
					    model = GetVehicleModel(vehicleid)
					;

					for( new x; x < sizeof(A_ELM_spotlightBulbOffsets); x ++ )
					{
						if(A_ELM_spotlightBulbOffsets[x][0] != model)
			   				continue;

						arrayid = x;
						break;
					}

					if(arrayid == -1)
					    return 0;

					gELM_vehicleSpotlightRot[vehicleid][0] = vX = Float:A_ELM_spotlightBulbOffsets[arrayid][1];
					gELM_vehicleSpotlightRot[vehicleid][1] = vY = Float:A_ELM_spotlightBulbOffsets[arrayid][2];
					gELM_vehicleSpotlightRot[vehicleid][2] = vZ = Float:A_ELM_spotlightBulbOffsets[arrayid][3];
					vRY = Float:A_ELM_spotlightBulbOffsets[arrayid][4];

		            gELM_vehicleSpotlightObject[vehicleid] = CreateDynamicObject(-2016, 0.0, 0.0, -100.0, 0.0, 0.0, 0.0, -1, -1, -1, 150.0, 135.0, -1, 0);

					AttachDynamicObjectToVehicle(
						gELM_vehicleSpotlightObject[vehicleid], vehicleid, vX, vY, vZ, 0.0, vRY, 0.0
					);
		        }
		    }
		}
	}

	return 1;
}
// koniec custom callbackov

// timery
timer ELMhideinfopanel[3000](playerid, td_1)
{

	if(!IsPlayerConnected(playerid))
	    return 0;

	if(!GetPVarInt(playerid, "ELMP_IsActive"))
	    return 0;

    SetPVarInt(playerid, "ELMP_IsActive", 0);
    SetPVarInt(playerid, "ELMP_Priority", 0);

	PlayerTextDrawDestroy(playerid, PlayerText:td_1);

	return 1;
}

timer ELMspotlightMovementTimer[SPOTLIGHT_TIMER_DIFF](playerid, vehicleid, movtype)
{

	/*
	    movtype: {
	        0: UP
	        1: DOWN
	        2: LEFT
	        3: RIGHT
	    }
	*/
	switch(movtype)
	{
	    case 0:
	    {
	        // UP

	        new
	            Float:oX,
	            Float:oY,
	            Float:oZ,

	            Float:oRX,
	            Float:oRZ
			;

			// nacitam si vsetky predpripravene pozicie ktore som robil mimo streamu do lokalnych premennych
			oX = gELM_vehicleSpotlightRot[vehicleid][0];
			oY = gELM_vehicleSpotlightRot[vehicleid][1];
			oZ = gELM_vehicleSpotlightRot[vehicleid][2];
			// s tymito dvoma VVV budeme pracovat
			oRX = gELM_vehicleSpotlightRot[vehicleid][3]; // v pripade UP,DOWN s oRX
			oRZ = gELM_vehicleSpotlightRot[vehicleid][4]; // v pripade LEFT,RIGHT s oRZ

			//start mega skriptu jako
			oRX += SPOTLIGHT_POWER;

			if(floatcmp(oRX, MAX_SPOTLIGHT_ROT_X) >= 0) // ak je oRX viac alebo sa rovna 10.0
				oRX = (MAX_SPOTLIGHT_ROT_X - 0.1);

			// aktualizujeme hodnoty
            gELM_vehicleSpotlightRot[vehicleid][3] = oRX;

			// nahodime to na objekt na aute
			AttachDynamicObjectToVehicle(
				gELM_vehicleSpotlightObject[vehicleid], vehicleid, oX, oY, oZ, oRX, 0.0, oRZ
			);

	    }

	    case 1:
	    {
	        // DOWN

	        new
	            Float:oX,
	            Float:oY,
	            Float:oZ,

	            Float:oRX,
	            Float:oRZ
			;

			// nacitam si vsetky predpripravene pozicie ktore som robil mimo streamu do lokalnych premennych
			oX = gELM_vehicleSpotlightRot[vehicleid][0];
			oY = gELM_vehicleSpotlightRot[vehicleid][1];
			oZ = gELM_vehicleSpotlightRot[vehicleid][2];
			// s tymito dvoma VVV budeme pracovat
			oRX = gELM_vehicleSpotlightRot[vehicleid][3]; // v pripade UP,DOWN s oRX
			oRZ = gELM_vehicleSpotlightRot[vehicleid][4]; // v pripade LEFT,RIGHT s oRZ

			//start mega skriptu jako
			oRX -= SPOTLIGHT_POWER;

			if(floatcmp(oRX, MIN_SPOTLIGHT_ROT_X) <= 0) // ak je oRX viac alebo sa rovna -10.0
				oRX = (MIN_SPOTLIGHT_ROT_X + 0.1);

			// aktualizujeme hodnoty
            gELM_vehicleSpotlightRot[vehicleid][3] = oRX;

			// nahodime to na objekt na aute
			AttachDynamicObjectToVehicle(
				gELM_vehicleSpotlightObject[vehicleid], vehicleid, oX, oY, oZ, oRX, 0.0, oRZ
			);

	    }

	    case 3:
	    {
	        // LEFT

	        #if defined ELM_ALMOST_STATIC_CAM
	            SetCameraBehindPlayer(playerid);
	        #endif

	        new
	            Float:oX,
	            Float:oY,
	            Float:oZ,

	            Float:oRX,
	            Float:oRZ
			;

			// nacitam si vsetky predpripravene pozicie ktore som robil mimo streamu do lokalnych premennych
			oX = gELM_vehicleSpotlightRot[vehicleid][0];
			oY = gELM_vehicleSpotlightRot[vehicleid][1];
			oZ = gELM_vehicleSpotlightRot[vehicleid][2];
			// s tymito dvoma VVV budeme pracovat
			oRX = gELM_vehicleSpotlightRot[vehicleid][3]; // v pripade UP,DOWN s oRX
			oRZ = gELM_vehicleSpotlightRot[vehicleid][4]; // v pripade LEFT,RIGHT s oRZ

			//start mega skriptu jako
			oRZ += SPOTLIGHT_POWER;

			if(floatcmp(oRZ, MAX_SPOTLIGHT_ROT_Z) >= 0) // ak je oRX viac alebo sa rovna -10.0
				oRZ = (MAX_SPOTLIGHT_ROT_Z + 0.1);

			// aktualizujeme hodnoty
            gELM_vehicleSpotlightRot[vehicleid][4] = oRZ;

			// nahodime to na objekt na aute
			AttachDynamicObjectToVehicle(
				gELM_vehicleSpotlightObject[vehicleid], vehicleid, oX, oY, oZ, oRX, 0.0, oRZ
			);

	    }

	    case 2:
	    {
	        // RIGHT

	        #if defined ELM_ALMOST_STATIC_CAM
	            SetCameraBehindPlayer(playerid);
	        #endif

	        new
	            Float:oX,
	            Float:oY,
	            Float:oZ,

	            Float:oRX,
	            Float:oRZ
			;

			// nacitam si vsetky predpripravene pozicie ktore som robil mimo streamu do lokalnych premennych
			oX = gELM_vehicleSpotlightRot[vehicleid][0];
			oY = gELM_vehicleSpotlightRot[vehicleid][1];
			oZ = gELM_vehicleSpotlightRot[vehicleid][2];
			// s tymito dvoma VVV budeme pracovat
			oRX = gELM_vehicleSpotlightRot[vehicleid][3]; // v pripade UP,DOWN s oRX
			oRZ = gELM_vehicleSpotlightRot[vehicleid][4]; // v pripade LEFT,RIGHT s oRZ

			//start mega skriptu jako
			oRZ -= SPOTLIGHT_POWER;

			if(floatcmp(oRZ, MIN_SPOTLIGHT_ROT_Z) <= 0) // ak je oRX viac alebo sa rovna -10.0
				oRZ = (MIN_SPOTLIGHT_ROT_Z - 0.1);

			// aktualizujeme hodnoty
            gELM_vehicleSpotlightRot[vehicleid][4] = oRZ;

			// nahodime to na objekt na aute
			AttachDynamicObjectToVehicle(
				gELM_vehicleSpotlightObject[vehicleid], vehicleid, oX, oY, oZ, oRX, 0.0, oRZ
			);

	    }
	}

	return 1;
}

timer ELM_FlashRegimeUpdate[ELM_FLASH_TIMER_DIFF](xvehicleid, xstate)
{

	if(gELM_vehicleRegime[xvehicleid][ELM_LISTITEM_FLASH] == 0)
	    return 0;

	new
	    lPanels,
	    lDoors,
	    lLights,
		lTires
	;

	if(GetVehicleDamageStatus(xvehicleid, lPanels, lDoors, lLights, lTires) == 1)
	{

	    new
	        lFront,
			lBack
		;

		ELM_decode_lights(lLights, lFront, lFront, lBack);

		switch(xstate)
		{
		    case 0:
		    {
		        // blikne lava
		        if(gELM_vehicleFlashLights[xvehicleid][0] == 1)
		        	lLights = ELM_encode_lights(1, 1, lBack);
				else
				    lLights = ELM_encode_lights(0, 1, lBack);
		    }

		    case 1:
		    {
		        // blinke prava
		        if(gELM_vehicleFlashLights[xvehicleid][1] == 1)
		        	lLights = ELM_encode_lights(1, 1, lBack);
				else
				    lLights = ELM_encode_lights(1, 0, lBack);
		    }
		}

		UpdateVehicleDamageStatus(xvehicleid, lPanels, lDoors, lLights, lTires);

		defer ELM_FlashRegimeUpdate(xvehicleid, !xstate);

	    return 1;
	}

	return 0;
}
// koniec timerov
