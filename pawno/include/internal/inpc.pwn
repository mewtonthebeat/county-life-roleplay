#include <a_samp>
#include <streamer>
#include <YSI\y_iterate>
#include <YSI\y_timers>

//////////////////////////////

#define     InteractiveNPC::    		inpc_

#define     MAX_INTERACTIVE_NPC     	50
#define		INVALID_INTERACTIVE_NPC_ID  25565

// internal defines
#define     LOG_INTERACTIVE_NPC_PREFIX  		"[I-NPC]"
#define     INTERACTIVE_NPC_ERROR_RETURN    	INVALID_INTERACTIVE_NPC_ID
#define     MAX_INTERACTIVE_NPC_MESSAGE_LEN     144

///////////////////////////////

/*
	* InteractiveNPC::Add(skin, x, y, z, angle, vw, interior)
	* InteractiveNPC::SetName(str[])
	* InteractiveNPC::Anim()
	* InteractiveNPC::ThrowError()
*/

//////////////////////////////

enum interactiveNpcEnum()
{
	// Streamer data
	inpc_ActorId,
	inpc_AreaId,
	Text3D:inpc_NametagId,

	// Actor character data
	inpc_Skin,
	Float:inpc_PosX, Float:inpc_PosY, Float:inpc_PosZ, Float:inpc_Angle,
	inpc_VirtualWorld, inpc_InteriorId,

	// Internal data
	inpc_NonTalking,
	inpc_OccupiedBy,
	inpc_NpcExtra,
	inpc_DefaultResponse,

	// Personality

	inpc_Name[MAX_PLAYER_NAME+1],
	inpc_Message[MAX_INTERACTIVE_NPC_MESSAGE_LEN],
	inpc_MessageNotNow[MAX_INTERACTIVE_NPC_MESSAGE_LEN]
}

enum {
    NPC_PULASKI,        // Willie Towsend
    NPC_FARMER1,        // Dayton O'Neil
    
    NPC_SPAWN_W_WHIT, 	// Catherine Wankstein
    NPC_SPAWN_M_WHIT,   // Derek Whittaker
    
    NPC_SPAWN_DRUG1,	// Matija Bailey
    NPC_SPAWN_DRUG2,    // Vlad Bohorij
    
    NPC_MOTEL_W_WHIT, 	// Catherine Wankstein
    NPC_MOTEL_M_WHIT,	// Derek Whittaker
}

enum {
    //Random
	NPC_DIALOGGROUP_DRUG_SPAWN = 1,

	//Whitetaker
	NPC_DIALOGGROUP_WHIT_SPAWN,
	NPC_DIALOGGROUP_WHIT_MOTEL,
}

enum {
	I_NPC_MESSAGE_MAIN,
	I_NPC_MESSAGE_OCCUPIED,
}

enum {
    INPC_PULASKI_R_NOT_IMPOUNDED = 10,
	INPC_PULASKI_R_NOT_ANYMORE,
	INPC_PULASKI_R_NO_MONEY,
	INPC_PULASKI_R_CANT_TAKE,
	INPC_PULASKI_R_CAR_TAKEN,
    INPC_PULASKI_R_ADD_NO_RESPONSE,
    INPC_PULASKI_R_ADD_DONE,
    
    /////////////////////////////////////////////
}

//////////////////////////////

new Iterator:InteractiveNPC<MAX_INTERACTIVE_NPC>;
new InteractiveNPC[MAX_INTERACTIVE_NPC][interactiveNpcEnum];
new InteractiveNPC::Options[MAX_INTERACTIVE_NPC][4][144];

// internal variables
new lastusedid = INVALID_INTERACTIVE_NPC_ID;
new InteractiveNPC::playernpcid[MAX_PLAYERS] = {INVALID_INTERACTIVE_NPC_ID, ...};
new InteractiveNPC::errors[][] = {
	"Undefined error",
	"Couldn't add NPC: All slots are occupied!",
	"Couldn't add option: ID must be in range from 0 to 3!"
};
new bool:InteractiveNPC::talking[MAX_PLAYERS];
new Text:inpc_popUpTD[2];
new PlayerText:inpc_talkTD[MAX_PLAYERS][9];

new InteractiveNPC::selftalking[][][] = {
	//Drug on spawn
    {{NPC_DIALOGGROUP_DRUG_SPAWN}, 	{1}, {2}, {0xFFFFFFFF}, {NPC_SPAWN_DRUG1}, 				"ey, throw me that needle."},
    {{NPC_DIALOGGROUP_DRUG_SPAWN}, 	{1}, {2}, {0xFFFFFFFF}, {NPC_SPAWN_DRUG2}, 				"aagh, motherfucker, what needle??."},
    {{NPC_DIALOGGROUP_DRUG_SPAWN}, 	{1}, {2}, {0xFFFFFFFF}, {NPC_SPAWN_DRUG1}, 				"maaan i need that brownie?"},
    {{NPC_DIALOGGROUP_DRUG_SPAWN}, 	{1}, {2}, {0xFFFFFFFF}, {NPC_SPAWN_DRUG2}, 				"**laugh** let me alone Matija."},
    
    {{NPC_DIALOGGROUP_DRUG_SPAWN}, 	{2}, {2}, {0xFFFFFFFF}, {NPC_SPAWN_DRUG2}, 				"heey, Matija, shouldn't we stop using those pills?"},
    {{NPC_DIALOGGROUP_DRUG_SPAWN}, 	{2}, {2}, {0xFFFFFFFF}, {NPC_SPAWN_DRUG1}, 				"יייייייייייייי-בבבבבבבבבבבבבב-תתתתתתתתתתתתת"},
    {{NPC_DIALOGGROUP_DRUG_SPAWN}, 	{2}, {2}, {0xFFFFFFFF}, {NPC_SPAWN_DRUG2}, 				"**laugh** holy god!"},
    
    {{NPC_DIALOGGROUP_DRUG_SPAWN}, 	{3}, {2}, {0xFFFFFFFF}, {NPC_SPAWN_DRUG2}, 				"oh fuck Matija! look at that big tree!"},
    {{NPC_DIALOGGROUP_DRUG_SPAWN}, 	{3}, {2}, {0xFFFFFFFF}, {NPC_SPAWN_DRUG1}, 				"fuck your tree, look at that UFO!"},
    {{NPC_DIALOGGROUP_DRUG_SPAWN}, 	{3}, {2}, {0xFFFFFFFF}, {NPC_SPAWN_DRUG2}, 				"shut the fuck up be quiet man"},

	//Whitetaker
	{{NPC_DIALOGGROUP_WHIT_SPAWN}, 	{1}, {1}, {0xFFFFFFFF}, {NPC_SPAWN_W_WHIT}, 			"Is this the Flint County, darling?"},
	{{NPC_DIALOGGROUP_WHIT_SPAWN}, 	{1}, {1}, {0xFFFFFFFF}, {NPC_SPAWN_M_WHIT}, 			"Yes, my love, don't you like it here?"},
	{{NPC_DIALOGGROUP_WHIT_SPAWN}, 	{1}, {1}, {0xFFFFFFFF}, {NPC_SPAWN_W_WHIT}, 			"Oh god, this looks awful, are we really going to live here?"},
	{{NPC_DIALOGGROUP_WHIT_SPAWN}, 	{1}, {1}, {0xFFFFFFFF}, {NPC_SPAWN_W_WHIT}, 			"I want to go back to Los Santos, I want to live here, why can't we, Derek?!"},
	{{NPC_DIALOGGROUP_WHIT_SPAWN}, 	{1}, {1}, {0xFFFFFFFF}, {NPC_SPAWN_M_WHIT}, 			"I am not going to talk about it AGAIN..."},
	{{NPC_DIALOGGROUP_WHIT_SPAWN}, 	{1}, {1}, {0xFFFFFFFF}, {NPC_SPAWN_W_WHIT}, 			"You are such a cunt, Derek!"},

	{{NPC_DIALOGGROUP_WHIT_SPAWN}, 	{2}, {1}, {0xFFFFFFFF}, {NPC_SPAWN_W_WHIT}, 			"Sooo, where is that motel, Derek?"},
	{{NPC_DIALOGGROUP_WHIT_SPAWN}, 	{2}, {1}, {0xFFFFFFFF}, {NPC_SPAWN_M_WHIT}, 			"Eh.. no.."},
	{{NPC_DIALOGGROUP_WHIT_SPAWN}, 	{2}, {1}, {0xFFFFFFFF}, {NPC_SPAWN_W_WHIT}, 			"What eh and no, for fucks sakes?!"},
	{{NPC_DIALOGGROUP_WHIT_SPAWN}, 	{2}, {1}, {0xFFFFFFFF}, {NPC_SPAWN_W_WHIT}, 			"You never did anything the right way, I am such dumb that I stopped dating Rob!"},
	{{NPC_DIALOGGROUP_WHIT_SPAWN}, 	{2}, {1}, {0xFFFFFFFF}, {NPC_SPAWN_M_WHIT}, 			"Don't come with that again..."},
	{{NPC_DIALOGGROUP_WHIT_SPAWN}, 	{2}, {1}, {0xFFFFFFFF}, {NPC_SPAWN_W_WHIT}, 			"I will, because I am in this hole when I could've been in Santos!"},
	
	{{NPC_DIALOGGROUP_WHIT_SPAWN}, 	{3}, {1}, {0xFFFFFFFF}, {NPC_SPAWN_W_WHIT}, 			"Why are we still standing here?"},
	{{NPC_DIALOGGROUP_WHIT_SPAWN}, 	{3}, {1}, {0xFFFFFFFF}, {NPC_SPAWN_M_WHIT}, 			"You know, we are waiting for Chris ..."},
	{{NPC_DIALOGGROUP_WHIT_SPAWN}, 	{3}, {1}, {0xFFFFFFFF}, {NPC_SPAWN_W_WHIT}, 			"But I do not want to see your Chris, he is just another scammer just like you!"},
	{{NPC_DIALOGGROUP_WHIT_SPAWN}, 	{3}, {1}, {0xFFFFFFFF}, {NPC_SPAWN_M_WHIT}, 			"Don't scream, my god, you're just gaining attention."},
	{{NPC_DIALOGGROUP_WHIT_SPAWN}, 	{3}, {1}, {0xFFFFFFFF}, {NPC_SPAWN_W_WHIT}, 			"OH MY GOD! Don't test me or I will take your keys and drive back to Los Santos!"},
	
	////////////////////////////////////////////////////////////////////////////
	{{NPC_DIALOGGROUP_WHIT_MOTEL},  {1}, {1}, {0xFFFFFFFF}, {NPC_MOTEL_W_WHIT},            	"Is that the hotel? Are you kidding me?"},
	{{NPC_DIALOGGROUP_WHIT_MOTEL},  {1}, {1}, {0xFFFFFFFF}, {NPC_MOTEL_W_WHIT},            	"That is just some kind of jail, motherfucker!"},
	{{NPC_DIALOGGROUP_WHIT_MOTEL},  {1}, {1}, {0xFFFFFFFF}, {NPC_MOTEL_M_WHIT},            	"Baby, it is not that bad, and it's cheap!"},
	{{NPC_DIALOGGROUP_WHIT_MOTEL},  {1}, {1}, {0xFFFFFFFF}, {NPC_MOTEL_M_WHIT},            	"Lets check in, come on..."},
	{{NPC_DIALOGGROUP_WHIT_MOTEL},  {1}, {1}, {0xFFFFFFFF}, {NPC_MOTEL_W_WHIT},            	"I am not going anywhere!"},
	{{NPC_DIALOGGROUP_WHIT_MOTEL},  {1}, {1}, {0xFFFFFFFF}, {NPC_MOTEL_M_WHIT},            	"Yeah, sure..."},
};

//////////////////////////////

InteractiveNPC::Add(npctype, skin, Float:x, Float:y, Float:z, Float:a = 0.0, virtualworld = 0, interiorid = 0, nontalking = 0)
{
	lastusedid = Iter_Alloc(InteractiveNPC);

	if(lastusedid == INVALID_INTERACTIVE_NPC_ID)
	{
	    InteractiveNPC::ThrowError(1001);
	    return INVALID_INTERACTIVE_NPC_ID;
	}

	/////////////////////////////////////////////////////////////////
	InteractiveNPC[lastusedid][inpc_ActorId] 		= CreateDynamicActor(skin, x, y, z, a, 1, 100.0, virtualworld, interiorid);
	/////////////////////////////////////////////////////////////////
	InteractiveNPC[lastusedid][inpc_AreaId]         = CreateDynamicSphere(x, y, z, 1.75, virtualworld, interiorid);
	/////////////////////////////////////////////////////////////////
	InteractiveNPC[lastusedid][inpc_NametagId]      = CreateDynamic3DTextLabel("undefined", 0xFFFFFFFF, x, y, z + 1.0, 12.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, virtualworld, interiorid, -1);
	/////////////////////////////////////////////////////////////////
    InteractiveNPC[lastusedid][inpc_Skin]           = skin;
	/////////////////////////////////////////////////////////////////
	InteractiveNPC[lastusedid][inpc_PosX]           = x;
	InteractiveNPC[lastusedid][inpc_PosY]           = y;
	InteractiveNPC[lastusedid][inpc_PosZ]           = z;
	InteractiveNPC[lastusedid][inpc_Angle]          = a;
	InteractiveNPC[lastusedid][inpc_NonTalking]     = nontalking;

	InteractiveNPC[lastusedid][inpc_VirtualWorld]   = virtualworld;
	InteractiveNPC[lastusedid][inpc_InteriorId]     = interiorid;
	/////////////////////////////////////////////////////////////////
	format(InteractiveNPC[lastusedid][inpc_Name], MAX_PLAYER_NAME+1, "undefined");
	/////////////////////////////////////////////////////////////////
	InteractiveNPC[lastusedid][inpc_OccupiedBy]   	= INVALID_PLAYER_ID;
	InteractiveNPC[lastusedid][inpc_NpcExtra]       = npctype;
	InteractiveNPC[lastusedid][inpc_DefaultResponse]= 0;

	return lastusedid;
}

InteractiveNPC::AddOption(id, option[])
{
	if(id < 0 || id > 3)
	    return InteractiveNPC::ThrowError(1002);

	format(InteractiveNPC::Options[lastusedid][id], 144, option);

	return 1;
}

InteractiveNPC::SetDefaultResponse(response)
{
    InteractiveNPC[lastusedid][inpc_DefaultResponse] = response;
    return 1;
}

InteractiveNPC::Anim(animlib[], animname[], Float:fdelta, loop, lockx, locky, freeze, time)
{
	ApplyDynamicActorAnimation(InteractiveNPC[lastusedid][inpc_ActorId], animlib, animname, fdelta, loop, lockx, locky, freeze, time);
	return lastusedid;
}

InteractiveNPC::SetName(name[])
{
	if(lastusedid == INVALID_INTERACTIVE_NPC_ID)
	    return INVALID_INTERACTIVE_NPC_ID;

	format(InteractiveNPC[lastusedid][inpc_Name], MAX_PLAYER_NAME+1, name);
	UpdateDynamic3DTextLabelText(InteractiveNPC[lastusedid][inpc_NametagId], 0xFFFFFFFF, InteractiveNPC[lastusedid][inpc_Name]);

	return lastusedid;
}

InteractiveNPC::SetMessage(messageid, message[])
{
    if(lastusedid == INVALID_INTERACTIVE_NPC_ID)
	    return INVALID_INTERACTIVE_NPC_ID;

	switch(messageid)
	{
		case I_NPC_MESSAGE_MAIN:
            format(InteractiveNPC[lastusedid][inpc_Message], MAX_INTERACTIVE_NPC_MESSAGE_LEN, message);

		case I_NPC_MESSAGE_OCCUPIED:
			format(InteractiveNPC[lastusedid][inpc_MessageNotNow], MAX_INTERACTIVE_NPC_MESSAGE_LEN, message);
	}

	return lastusedid;
}

InteractiveNPC::Select(inpc)
{
	lastusedid = inpc;
	return 1;
}

InteractiveNPC::Sleep()
{
	lastusedid = INVALID_INTERACTIVE_NPC_ID;
	return 1;
}

InteractiveNPC::ThrowError(errorid)
{

	if((errorid - 1000) < 0 || (errorid - 1000) >= sizeof(InteractiveNPC::errors))
	    errorid = 1000;

	printf("%s (Error %04d) %s", LOG_INTERACTIVE_NPC_PREFIX, errorid, InteractiveNPC::errors[errorid-1000]);

	return INTERACTIVE_NPC_ERROR_RETURN;
}

InteractiveNPC::CreateTextdraws(playerid)
{

    InteractiveNPC::talking[playerid] = true;

	new
	    tdcount = 5;

    inpc_talkTD[playerid][0] = CreatePlayerTextDraw(playerid, 324.666687, 350.853240, InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name]);
	PlayerTextDrawLetterSize(playerid, inpc_talkTD[playerid][0], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid, inpc_talkTD[playerid][0], 2);
	PlayerTextDrawColor(playerid, inpc_talkTD[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, inpc_talkTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, inpc_talkTD[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, inpc_talkTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, inpc_talkTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, inpc_talkTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, inpc_talkTD[playerid][0], 0);

	inpc_talkTD[playerid][1] = CreatePlayerTextDraw(playerid, 230.190536, 376.026641, "pb_oabg");
	PlayerTextDrawLetterSize(playerid, inpc_talkTD[playerid][1], 0.000000, 0.780948);
	PlayerTextDrawTextSize(playerid, inpc_talkTD[playerid][1], 418.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, inpc_talkTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, inpc_talkTD[playerid][1], -1);
	PlayerTextDrawUseBox(playerid, inpc_talkTD[playerid][1], 1);
	PlayerTextDrawBoxColor(playerid, inpc_talkTD[playerid][1], 255);
	PlayerTextDrawSetShadow(playerid, inpc_talkTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, inpc_talkTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, inpc_talkTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, inpc_talkTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, inpc_talkTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, inpc_talkTD[playerid][1], 0);

	inpc_talkTD[playerid][2] = CreatePlayerTextDraw(playerid, 232.095291, 378.159973, "pb_progressbg");
	PlayerTextDrawLetterSize(playerid, inpc_talkTD[playerid][2], 0.000000, 0.285710);
	PlayerTextDrawTextSize(playerid, inpc_talkTD[playerid][2], 416.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, inpc_talkTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, inpc_talkTD[playerid][2], -1);
	PlayerTextDrawUseBox(playerid, inpc_talkTD[playerid][2], 1);
	PlayerTextDrawBoxColor(playerid, inpc_talkTD[playerid][2], -1061109505);
	PlayerTextDrawSetShadow(playerid, inpc_talkTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, inpc_talkTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, inpc_talkTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, inpc_talkTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, inpc_talkTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, inpc_talkTD[playerid][2], 0);

	inpc_talkTD[playerid][3] = CreatePlayerTextDraw(playerid, 232.095291, 378.159973, "pb_progress");
	PlayerTextDrawLetterSize(playerid, inpc_talkTD[playerid][3], 0.000000, 0.285710);
	PlayerTextDrawTextSize(playerid, inpc_talkTD[playerid][3], 230.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, inpc_talkTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, inpc_talkTD[playerid][3], -1);
	PlayerTextDrawUseBox(playerid, inpc_talkTD[playerid][3], 1);
	PlayerTextDrawBoxColor(playerid, inpc_talkTD[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, inpc_talkTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, inpc_talkTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, inpc_talkTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, inpc_talkTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, inpc_talkTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, inpc_talkTD[playerid][3], 0);

	inpc_talkTD[playerid][4] = CreatePlayerTextDraw(playerid, 325.428588, 364.506561, replaceChars(InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Message]));
	PlayerTextDrawLetterSize(playerid, inpc_talkTD[playerid][4], 0.201142, 0.900266);
	PlayerTextDrawAlignment(playerid, inpc_talkTD[playerid][4], 2);
	PlayerTextDrawColor(playerid, inpc_talkTD[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, inpc_talkTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, inpc_talkTD[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, inpc_talkTD[playerid][4], 255);
	PlayerTextDrawFont(playerid, inpc_talkTD[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, inpc_talkTD[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, inpc_talkTD[playerid][4], 0);

	if(strlen(InteractiveNPC::Options[InteractiveNPC::playernpcid[playerid]][0]) > 0)
	{
		inpc_talkTD[playerid][5] = CreatePlayerTextDraw(playerid, 324.285766, 387.973327, replaceChars(InteractiveNPC::Options[InteractiveNPC::playernpcid[playerid]][0]));
		PlayerTextDrawLetterSize(playerid, inpc_talkTD[playerid][5], 0.216000, 1.036800);
		PlayerTextDrawTextSize(playerid, inpc_talkTD[playerid][5], 10.000000, 187.000000);
		PlayerTextDrawAlignment(playerid, inpc_talkTD[playerid][5], 2);
		PlayerTextDrawColor(playerid, inpc_talkTD[playerid][5], 255);
		PlayerTextDrawUseBox(playerid, inpc_talkTD[playerid][5], 1);
		PlayerTextDrawBoxColor(playerid, inpc_talkTD[playerid][5], -1);
		PlayerTextDrawSetShadow(playerid, inpc_talkTD[playerid][5], 0);
		PlayerTextDrawSetOutline(playerid, inpc_talkTD[playerid][5], 0);
		PlayerTextDrawBackgroundColor(playerid, inpc_talkTD[playerid][5], 255);
		PlayerTextDrawFont(playerid, inpc_talkTD[playerid][5], 2);
		PlayerTextDrawSetProportional(playerid, inpc_talkTD[playerid][5], 1);
		PlayerTextDrawSetShadow(playerid, inpc_talkTD[playerid][5], 0);
		PlayerTextDrawSetSelectable(playerid, inpc_talkTD[playerid][5], true);

		tdcount ++;
	}

    if(strlen(InteractiveNPC::Options[InteractiveNPC::playernpcid[playerid]][1]) > 0)
	{
		inpc_talkTD[playerid][6] = CreatePlayerTextDraw(playerid, 324.285766, 402.479980, replaceChars(InteractiveNPC::Options[InteractiveNPC::playernpcid[playerid]][1]));
		PlayerTextDrawLetterSize(playerid, inpc_talkTD[playerid][6], 0.216000, 1.036800);
		PlayerTextDrawTextSize(playerid, inpc_talkTD[playerid][6], 10.000000, 187.000000);
		PlayerTextDrawAlignment(playerid, inpc_talkTD[playerid][6], 2);
		PlayerTextDrawColor(playerid, inpc_talkTD[playerid][6], 255);
		PlayerTextDrawUseBox(playerid, inpc_talkTD[playerid][6], 1);
		PlayerTextDrawBoxColor(playerid, inpc_talkTD[playerid][6], -1);
		PlayerTextDrawSetShadow(playerid, inpc_talkTD[playerid][6], 0);
		PlayerTextDrawSetOutline(playerid, inpc_talkTD[playerid][6], 0);
		PlayerTextDrawBackgroundColor(playerid, inpc_talkTD[playerid][6], 255);
		PlayerTextDrawFont(playerid, inpc_talkTD[playerid][6], 2);
		PlayerTextDrawSetProportional(playerid, inpc_talkTD[playerid][6], 1);
		PlayerTextDrawSetShadow(playerid, inpc_talkTD[playerid][6], 0);
		PlayerTextDrawSetSelectable(playerid, inpc_talkTD[playerid][6], true);

		tdcount++;
	}

    if(strlen(InteractiveNPC::Options[InteractiveNPC::playernpcid[playerid]][2]) > 0)
	{
		inpc_talkTD[playerid][7] = CreatePlayerTextDraw(playerid, 324.285766, 416.986633, replaceChars(InteractiveNPC::Options[InteractiveNPC::playernpcid[playerid]][2]));
		PlayerTextDrawLetterSize(playerid, inpc_talkTD[playerid][7], 0.216000, 1.036800);
		PlayerTextDrawTextSize(playerid, inpc_talkTD[playerid][7], 10.000000, 187.000000);
		PlayerTextDrawAlignment(playerid, inpc_talkTD[playerid][7], 2);
		PlayerTextDrawColor(playerid, inpc_talkTD[playerid][7], 255);
		PlayerTextDrawUseBox(playerid, inpc_talkTD[playerid][7], 1);
		PlayerTextDrawBoxColor(playerid, inpc_talkTD[playerid][7], -1);
		PlayerTextDrawSetShadow(playerid, inpc_talkTD[playerid][7], 0);
		PlayerTextDrawSetOutline(playerid, inpc_talkTD[playerid][7], 0);
		PlayerTextDrawBackgroundColor(playerid, inpc_talkTD[playerid][7], 255);
		PlayerTextDrawFont(playerid, inpc_talkTD[playerid][7], 2);
		PlayerTextDrawSetProportional(playerid, inpc_talkTD[playerid][7], 1);
		PlayerTextDrawSetShadow(playerid, inpc_talkTD[playerid][7], 0);
		PlayerTextDrawSetSelectable(playerid, inpc_talkTD[playerid][7], true);

		tdcount++;
	}

    if(strlen(InteractiveNPC::Options[InteractiveNPC::playernpcid[playerid]][3]) > 0)
	{
		inpc_talkTD[playerid][8] = CreatePlayerTextDraw(playerid, 324.285766, 431.493286, replaceChars(InteractiveNPC::Options[InteractiveNPC::playernpcid[playerid]][3]));
		PlayerTextDrawLetterSize(playerid, inpc_talkTD[playerid][8], 0.216000, 1.036800);
		PlayerTextDrawTextSize(playerid, inpc_talkTD[playerid][8], 10.000000, 187.000000);
		PlayerTextDrawAlignment(playerid, inpc_talkTD[playerid][8], 2);
		PlayerTextDrawColor(playerid, inpc_talkTD[playerid][8], 255);
		PlayerTextDrawUseBox(playerid, inpc_talkTD[playerid][8], 1);
		PlayerTextDrawBoxColor(playerid, inpc_talkTD[playerid][8], -1);
		PlayerTextDrawSetShadow(playerid, inpc_talkTD[playerid][8], 0);
		PlayerTextDrawSetOutline(playerid, inpc_talkTD[playerid][8], 0);
		PlayerTextDrawBackgroundColor(playerid, inpc_talkTD[playerid][8], 255);
		PlayerTextDrawFont(playerid, inpc_talkTD[playerid][8], 2);
		PlayerTextDrawSetProportional(playerid, inpc_talkTD[playerid][8], 1);
		PlayerTextDrawSetShadow(playerid, inpc_talkTD[playerid][8], 0);
		PlayerTextDrawSetSelectable(playerid, inpc_talkTD[playerid][8], true);

		tdcount++;
	}

	for(new x; x < tdcount; x++)
	    PlayerTextDrawShow(playerid, inpc_talkTD[playerid][x]);

    TogglePlayerControllable(playerid, 0);

	return 1;
}

InteractiveNPC::StopTalking(playerid, inpc)
{
    InteractiveNPC[inpc][inpc_OccupiedBy] = INVALID_PLAYER_ID;
    InteractiveNPC::playernpcid[playerid] = false;
    InteractiveNPC::talking[playerid] = false;
	TogglePlayerControllable(playerid, 1);
	CancelSelectTextDraw(playerid);
	
	TextDrawHideForPlayer(playerid, inpc_popUpTD[0]);
	TextDrawHideForPlayer(playerid, inpc_popUpTD[1]);
	return 1;
}

InteractiveNPC::RemoveTextdraws(playerid)
{

	new y = 5;

	if(strlen(InteractiveNPC::Options[InteractiveNPC::playernpcid[playerid]][3]) > 0) y = 9;
	else if(strlen(InteractiveNPC::Options[InteractiveNPC::playernpcid[playerid]][2]) > 0) y = 8;
	else if(strlen(InteractiveNPC::Options[InteractiveNPC::playernpcid[playerid]][1]) > 0) y = 7;
	else if(strlen(InteractiveNPC::Options[InteractiveNPC::playernpcid[playerid]][0]) > 0) y = 6;

	for(new x; x < y; x++)
	    PlayerTextDrawDestroy(playerid, inpc_talkTD[playerid][x]);

	CancelSelectTextDraw(playerid);

	return 1;
}

forward InteractiveNPC_Response(playerid, inpc, response);
public InteractiveNPC_Response(playerid, inpc, response)
{

	switch(inpc)
	{
	    case NPC_PULASKI:
	    {
	        InteractiveNPC::Response_Pulaski(playerid, inpc, response);
	    }
	    
	    case NPC_FARMER1:
	    {
	        InteractiveNPC::Response_Farmer(playerid, inpc, response);
	    }
	}

	return 1;
}

//////////////////////////////

InteractiveNPC::Response_Pulaski(playerid, inpc, response)
{
	switch(response)
	{
	    case 0:
	    {
			new mql_query[128];
			mysql_format(MYSQL, mql_query, sizeof(mql_query), "SELECT * FROM char_vehicles WHERE Owner = '%e' OR SecondOwner = '%e'", ReturnName(playerid), ReturnName(playerid));

			new
			    Cache:query = mysql_query(MYSQL, mql_query),

			    SPZ[30],
			    Model,
			    Parked,
				Impounded,
				Fine,
				finalString[512] = "Model\Plate\tFine\n",
				tempString[128],

				vehcount = 0
			;

			for(new i; i < cache_num_rows(); i++) {
			    if(i == cache_num_rows()) break;
			    cache_get_value_name_int(i, "Impounded", Impounded);
			    
			    if(Impounded != 1) continue;
			    
			    vehcount ++;

		     	cache_get_value_name(i, "SPZ", SPZ);
		     	cache_get_value_name_int(i, "Model", Model);
		     	cache_get_value_name_int(i, "isUnParked", Parked);
		     	cache_get_value_name_int(i, "Impounded_Fine", Fine);

		        format(tempString, 128, "{FFFFFF}%s\t%s\t%d$\n", VehicleNames[Model-400], SPZ, Fine);
				strcat(finalString, tempString);

				vehcount ++;
			}
			
			////////////////////////////////////////////////////////////////////
			
			new
		      tstr[ 144 ]
			;

			format(tstr, sizeof tstr, "%s says: %s", GetPlayerNameEx(playerid, USE_MASK), "I need to take my impounded vehicle!");
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

			if(vehcount <= 0)
                return InteractiveNPC::Response_Pulaski(playerid, inpc, INPC_PULASKI_R_NOT_IMPOUNDED);
			
	    	format(tstr, sizeof tstr, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], "I understand, what car is it?");
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);
	    	
	    	////////////////////////////////////////////////////////////////////
	    	
	    	SendSuccess(playerid, "Choose vehicle you wan't to unimpound!");
			ShowPlayerDialog(playerid, did_impound_get, DIALOG_STYLE_TABLIST_HEADERS, "IMPOUNDED VEHICLES", finalString, "CHOOSE", "CLOSE");

			cache_delete(query);
	    }

	    case 1:
	    {
	    
	        if(GetPlayerFactionType(playerid) != FACTION_TYPE_LAW)
	        {
		        new
			      tstr[ 144 ]
				;

				format(tstr, sizeof tstr, "%s says: %s", GetPlayerNameEx(playerid, USE_MASK), "Hey, I've got a car for you.");
		    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

		    	format(tstr, sizeof tstr, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], "OH MY FUCKING GOD YOU ARE NOT A COP! GET LOST!");
		    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);
		    	InteractiveNPC::StopTalking(playerid, inpc);
		    	
		    	return 1;
			}
			
			new
		      tstr[ 144 ]
			;

			format(tstr, sizeof tstr, "%s says: %s", GetPlayerNameEx(playerid, USE_MASK), "Hey, I've got a car for you!");
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

	    	format(tstr, sizeof tstr, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], "Which one?");
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);
	    	
	    	SCFM(playerid, COLOR_LIGHTBLUE, "[ ! ] Choose car you want to impound. Job and faction vehicles cannot be impounded.");
			
			Impound_ShowNearVehicles(playerid);
	    }

	    case 2:
	    {
	        new
		      tstr[ 144 ]
			;

			format(tstr, sizeof tstr, "%s says: %s", GetPlayerNameEx(playerid, USE_MASK), "How's your day going sir?");
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

			switch(random(4))
			{
			    case 0:
			        format(tstr, sizeof tstr, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], "Quite good.");

                case 1:
			        format(tstr, sizeof tstr, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], "It's good, but I need a cigarette...");

                case 2:
			        format(tstr, sizeof tstr, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], "It's fucked up man, they're going to fire me, because I fought a nigger.");

                case 3:
			        format(tstr, sizeof tstr, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], "You know, I am standing here because my chief is retarded, what shall I say.");
			}
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

	    	InteractiveNPC::StopTalking(playerid, inpc);

	    	InteractiveNPC::Select(inpc);
	    	InteractiveNPC::Anim("PED", "IDLE_CHAT", 4.1, 1, 1, 1, 1, 1);
	    	InteractiveNPC::Sleep();

	    	defer InteractiveNPC_AnimBack[(strlen(tstr)-21) * 100](inpc);
	    }

	    case 3:
	    {
	       	new
		      tstr[ 144 ]
			;

			format(tstr, sizeof tstr, "%s says: %s", GetPlayerNameEx(playerid, USE_MASK), "Nothing sir, everything is good.");
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

	    	format(tstr, sizeof tstr, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], "Alrighty.");
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

	    	InteractiveNPC::StopTalking(playerid, inpc);
	    }
	    
	    case INPC_PULASKI_R_NOT_IMPOUNDED:
	    {
	        new
		      tstr[ 144 ]
			;
	    
	        format(tstr, sizeof tstr, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], "I will need your humble name.");
    		ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

    		format(tstr, sizeof tstr, "%s says: Sure, it is %s.", GetPlayerNameEx(playerid, USE_MASK), GetPlayerNameEx(playerid, NO_MASK));
    		ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

    		format(tstr, sizeof tstr, "* %s said something in his radio, got response and looked at person standing next to him.", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name]);
    		ProxDetector(playerid, 15.0, COLOR_VIOLET, tstr);

    		format(tstr, sizeof tstr, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], "Well, I'm sorry but the car you are looking for is not here!");
    		ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

    		InteractiveNPC::StopTalking(playerid, inpc);
	    }
	    
	    case INPC_PULASKI_R_NOT_ANYMORE:
	    {
	       	new
		      tstr[ 144 ]
			;

			format(tstr, sizeof tstr, "%s says: %s", GetPlayerNameEx(playerid, USE_MASK), "Well, fuck it.");
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

	    	format(tstr, sizeof tstr, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], "ARE YOU FUCKING MAKING FUN OF ME? GET LOST!!!1111");
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

	    	InteractiveNPC::StopTalking(playerid, inpc);
	    }
	    
	    case INPC_PULASKI_R_NO_MONEY:
	    {
	       	new
		      tstr[ 144 ]
			;

			format(tstr, sizeof tstr, "* %s says the vehicle's details.", GetPlayerNameEx(playerid, USE_MASK));
    		ProxDetector(playerid, 15.0, COLOR_VIOLET, tstr);

    		format(tstr, sizeof tstr, "* %s said something in his radio, got response and looked at person standing next to him.", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name]);
    		ProxDetector(playerid, 15.0, COLOR_VIOLET, tstr);

	    	format(tstr, sizeof tstr, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], "Yeah, pay the fine.");
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

	    	format(tstr, sizeof tstr, "%s says: %s", GetPlayerNameEx(playerid, USE_MASK), "I ain't got no money...");
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

	    	InteractiveNPC::StopTalking(playerid, inpc);
	    }
	    
	    case INPC_PULASKI_R_CANT_TAKE:
	    {
	       	new
		      tstr[ 144 ]
			;

			format(tstr, sizeof tstr, "* %s says the vehicle's details.", GetPlayerNameEx(playerid, USE_MASK));
    		ProxDetector(playerid, 15.0, COLOR_VIOLET, tstr);

    		format(tstr, sizeof tstr, "* %s said something in his radio, got response and looked at person standing next to him.", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name]);
    		ProxDetector(playerid, 15.0, COLOR_VIOLET, tstr);

	    	format(tstr, sizeof tstr, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], "This vehicle is not available yet.");
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

	    	format(tstr, sizeof tstr, "%s says: %s", GetPlayerNameEx(playerid, USE_MASK), "Hmmm, thanks...");
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

	    	InteractiveNPC::StopTalking(playerid, inpc);
	    }
	    
	    case INPC_PULASKI_R_CAR_TAKEN:
	    {
	        new
		      tstr[ 144 ]
			;

			format(tstr, sizeof tstr, "* %s says the vehicle's details.", GetPlayerNameEx(playerid, USE_MASK));
    		ProxDetector(playerid, 15.0, COLOR_VIOLET, tstr);

    		format(tstr, sizeof tstr, "* %s said something in his radio, got response and looked at person standing next to him.", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name]);
    		ProxDetector(playerid, 15.0, COLOR_VIOLET, tstr);

	    	format(tstr, sizeof tstr, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], "Alrighty.");
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

	    	format(tstr, sizeof tstr, "%s says: %s", GetPlayerNameEx(playerid, USE_MASK), "Hmmm, thanks...");
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);
	    	
	    	format(tstr, sizeof tstr, "** Car arrived from the garage. (( Server ))");
    		ProxDetector(playerid, 15.0, COLOR_VIOLET, tstr);

	    	InteractiveNPC::StopTalking(playerid, inpc);
	    }
	    
	    case INPC_PULASKI_R_ADD_NO_RESPONSE:
	    {
	        new
		      tstr[ 144 ]
			;

	    	format(tstr, sizeof tstr, "%s says: %s", GetPlayerNameEx(playerid, USE_MASK), "Fuck it");
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

	    	format(tstr, sizeof tstr, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], "Ahh shit ...");
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);
	    	InteractiveNPC::StopTalking(playerid, inpc);
	    }
	    
	    case INPC_PULASKI_R_ADD_DONE:
	    {
	        new
		      tstr[ 144 ]
			;

	    	format(tstr, sizeof tstr, "%s says: %s", GetPlayerNameEx(playerid, USE_MASK), "Yeah, that one.");
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

	    	format(tstr, sizeof tstr, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], "I will take care of it.");
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);
	    	InteractiveNPC::StopTalking(playerid, inpc);
	    }
	}
	return 1;
}

InteractiveNPC::Response_Farmer(playerid, inpc, response)
{
	switch(response)
	{
	    case 0:
		{
			new
		      	tstr[ 144 ],
		      	tstr2[ 144 ]
			;

			format(tstr, sizeof tstr, "%s says: %s", GetPlayerNameEx(playerid, USE_MASK), "Howdy, how to get to city?");
			format(tstr2, sizeof tstr2, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], "There in the INFOCENTER, rent a bike.");

	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr2);

	    	InteractiveNPC::StopTalking(playerid, inpc);
	    }

	    case 1:
	    {
			new
		      tstr[ 144 ]
			;

			format(tstr, sizeof tstr, "%s says: %s", GetPlayerNameEx(playerid, USE_MASK), "Don't you need help, sir?");
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

	    	format(tstr, sizeof tstr, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], "I don't!");
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);
	    	
			InteractiveNPC::StopTalking(playerid, inpc);
	    }

	    case 2:
	    {
	        new
		      tstr[ 144 ]
			;

			format(tstr, sizeof tstr, "%s says: %s", GetPlayerNameEx(playerid, USE_MASK), "The fuck are you doing?");
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

			switch(random(4))
			{
			    case 0:
			        format(tstr, sizeof tstr, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], "I'm building world trade center, motherfucker...");

                case 1:
			        format(tstr, sizeof tstr, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], "I am fixing my Zetor, are you blind?");

                default:
			        format(tstr, sizeof tstr, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], "Things are fucked up man!!");
			}
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

	    	InteractiveNPC::StopTalking(playerid, inpc);
	    }

	    case 3:
	    {
	       	new
		      	tstr[ 144 ],
		      	tstr2[ 144 ]
			;
			
			switch(random(77))
			{
			    case 0..75:
			    {
			        format(tstr, sizeof tstr, "%s says: %s", GetPlayerNameEx(playerid, USE_MASK), "Nothing, you fucking redneck..");
			        format(tstr2, sizeof tstr2, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], "Don't push me!");
			    }
			    
			    default:
			    {
			        format(tstr, sizeof tstr, "%s says: %s", GetPlayerNameEx(playerid, USE_MASK), "Ez al zara hizketan?");
			        format(tstr2, sizeof tstr2, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], "the fuck man?!");
			    }
			}
			
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);
	    	ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr2);
	    	InteractiveNPC::StopTalking(playerid, inpc);
	    }
	}
	return 1;
}

timer InteractiveNPC_AnimBack[3000](npcid)
{
	switch(InteractiveNPC[npcid][inpc_NpcExtra])
	{
		case NPC_PULASKI:
		{
		    InteractiveNPC::Select(npcid);
		    InteractiveNPC::Anim("COP_AMBIENT", "COPLOOK_LOOP", 4.1, 1, 0, 0, 0, 0);
		    InteractiveNPC::Sleep();
		}
		
		case NPC_SPAWN_W_WHIT:
		{
		    InteractiveNPC::Select(npcid);
		    InteractiveNPC::Anim("GRAVEYARD", "PRST_LOOPA", 4.1, 1, 0, 0, 0, 0);
		    InteractiveNPC::Sleep();
		}
		
		case NPC_SPAWN_M_WHIT:
		{
		    InteractiveNPC::Select(npcid);
		    InteractiveNPC::Anim("COP_AMBIENT", "COPLOOK_THINK", 4.1, 1, 0, 0, 0, 0);
		    InteractiveNPC::Sleep();
		}
		
		case NPC_SPAWN_DRUG1:
		{
		    InteractiveNPC::Select(npcid);
		    InteractiveNPC::Anim("CRACK", "CRCKIDLE1", 4.1, 1, 0, 0, 1, 0);
            InteractiveNPC::Sleep();
		}
		
		case NPC_SPAWN_DRUG2:
		{
		    InteractiveNPC::Select(npcid);
		    InteractiveNPC::Anim("CRACK", "CRCKIDLE1", 4.1, 1, 0, 0, 1, 0);
            InteractiveNPC::Sleep();
		}
		
		case NPC_MOTEL_M_WHIT:
		{
		    InteractiveNPC::Select(npcid);
		    InteractiveNPC::Anim("COP_AMBIENT", "COPLOOK_LOOP", 4.1, 1, 0, 0, 0, 0);
		    InteractiveNPC::Sleep();
		}
	}

	return 1;
}

ProxDetectorNPC(npcid, Float:max_range, color, string[])
{
	new
		Float:pos_x = InteractiveNPC[npcid][inpc_PosX],
		Float:pos_y = InteractiveNPC[npcid][inpc_PosY],
		Float:pos_z = InteractiveNPC[npcid][inpc_PosZ],
		Float:range,
		Float:range_ratio,
		Float:range_with_ratio,
		clr_r, clr_g, clr_b,
		Float:color_r, Float:color_g, Float:color_b;

	color_r = float(color >> 24 & 0xFF);
	color_g = float(color >> 16 & 0xFF);
	color_b = float(color >> 8 & 0xFF);
	range_with_ratio = max_range * 1.6;

	foreach( new i : Player ) {
		range = GetPlayerDistanceFromPoint(i, pos_x, pos_y, pos_z);
		if (range > max_range) {
			continue;
		}

		range_ratio = (range_with_ratio - range) / range_with_ratio;
		clr_r = floatround(range_ratio * color_r);
		clr_g = floatround(range_ratio * color_g);
		clr_b = floatround(range_ratio * color_b);

		SendClientMessage(i, (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24), string);
	}
	
	return 1;
}

InteractiveNPC::Returnarrayid(messageid, sequenceid, dialogid)
{
	new seq = -1, count = -1;
	for(new x; x < sizeof InteractiveNPC::selftalking; x++)
	{
	    if(dialogid != InteractiveNPC::selftalking[x][0][0]) continue;
	    if(sequenceid != InteractiveNPC::selftalking[x][1][0]) continue;
		count ++;
		if(count != messageid) continue;
		seq = x;
		break;
	}
	return seq;
}

InteractiveNPC::Returnnpcid(extraid)
{
	new npcid = INVALID_INTERACTIVE_NPC_ID;
	foreach( new inpc : InteractiveNPC )
	{
	    if(InteractiveNPC[inpc][inpc_NpcExtra] != extraid) continue;
	    npcid = extraid;
	    break;
	}
	return npcid;
}

timer InteractiveNPC_Talk[10000](npcid, messageid, sequenceid, dialogid)
{
    new arrid = InteractiveNPC::Returnarrayid(messageid, sequenceid, dialogid);
    if(arrid == -1) return printf("[NPC-ERROR]: %d, %d, %d, %d (not found array)", npcid, messageid, sequenceid, dialogid);
    new target = InteractiveNPC::Returnnpcid(InteractiveNPC::selftalking[arrid][4][0]);

    if(target != INVALID_INTERACTIVE_NPC_ID)
    {
	    new tstr[144];
	    switch(InteractiveNPC::selftalking[arrid][2][0])
	    {
	        case 2:
	        {
	            if(InteractiveNPC[target][inpc_NonTalking] != 2)
	            {
		            InteractiveNPC::Select(target);
			    	InteractiveNPC::Anim("PED", "IDLE_CHAT", 4.1, 1, 1, 1, 1, 1);
				    InteractiveNPC::Sleep();
				}
				
	            new color = InteractiveNPC::selftalking[arrid][3][0];
	            format(tstr, sizeof tstr, "%s says quietly: %s", InteractiveNPC[target][inpc_Name], InteractiveNPC::selftalking[arrid][5]);
			 	ProxDetectorNPC(target, 7, color, tstr);
			 	defer InteractiveNPC_AnimBack[(strlen(InteractiveNPC::selftalking[arrid][5])) * 100](target);
	        }

	        case 3:
	        {
	            if(InteractiveNPC[target][inpc_NonTalking] != 2)
	            {
	                InteractiveNPC::Select(target);
			    	InteractiveNPC::Anim("PED", "IDLE_CHAT", 4.1, 1, 1, 1, 1, 1);
				    InteractiveNPC::Sleep();
				}

	            new color = InteractiveNPC::selftalking[arrid][3][0];
	            if(color == 0xFFFFFFFF) color = 0xe2aa2fFF;
	            format(tstr, sizeof tstr, "%s shouts: %s", InteractiveNPC[target][inpc_Name], InteractiveNPC::selftalking[arrid][5]);
			 	ProxDetectorNPC(target, 20, color, tstr);
			 	defer InteractiveNPC_AnimBack[(strlen(InteractiveNPC::selftalking[arrid][5])) * 100](target);
	        }

	        case 4:
	        {
	            new color = InteractiveNPC::selftalking[arrid][3][0];
	            if(color == 0xFFFFFFFF) color = 0xc2a2daFF;
	            format(tstr, sizeof tstr, "* %s %s", InteractiveNPC[target][inpc_Name], InteractiveNPC::selftalking[arrid][5]);
			 	ProxDetectorNPC(target, 12, color, tstr);

			 	new nextid = InteractiveNPC::Returnarrayid(messageid+1, sequenceid, dialogid);
    			if(nextid == -1) defer InteractiveNPC_NewSequence(npcid);
				else defer InteractiveNPC_Talk[10](npcid, messageid+1, sequenceid, dialogid);
				return 1;
	        }

	        case 5:
	        {
	            new color = InteractiveNPC::selftalking[arrid][3][0];
	            if(color == 0xFFFFFFFF) color = 0xc2a2daFF;
	            format(tstr, sizeof tstr, "* %s (( %s ))", InteractiveNPC::selftalking[arrid][5], InteractiveNPC[target][inpc_Name]);
			 	ProxDetectorNPC(target, 12, color, tstr);

			 	new nextid = InteractiveNPC::Returnarrayid(messageid+1, sequenceid, dialogid);
    			if(nextid == -1) defer InteractiveNPC_NewSequence(npcid);
				else defer InteractiveNPC_Talk[10](npcid, messageid+1, sequenceid, dialogid);
				return 1;
	        }

			default:
	        {
	            if(InteractiveNPC[target][inpc_NonTalking] != 2)
	            {
		            InteractiveNPC::Select(target);
			    	InteractiveNPC::Anim("PED", "IDLE_CHAT", 4.1, 1, 1, 1, 1, 1);
				    InteractiveNPC::Sleep();
				}
				
	            new color = InteractiveNPC::selftalking[arrid][3][0];
	            format(tstr, sizeof tstr, "%s says: %s", InteractiveNPC[target][inpc_Name], InteractiveNPC::selftalking[arrid][5]);
			 	ProxDetectorNPC(target, 15, color, tstr);
			 	defer InteractiveNPC_AnimBack[(strlen(InteractiveNPC::selftalking[arrid][5])) * 100](target);
	        }
	    }
	}

    new nextid = InteractiveNPC::Returnarrayid(messageid+1, sequenceid, dialogid);
    if(nextid == -1)
    {
        defer InteractiveNPC_NewSequence(npcid);
    }
    else
    {
        defer InteractiveNPC_Talk[floatround(float((strlen(InteractiveNPC::selftalking[arrid][5])) * 100)/1.5,floatround_round)](npcid, messageid+1, sequenceid, dialogid);
    }

	return 1;
}

timer InteractiveNPC_NewSequence[30000](npcid)
{
    InteractiveNPC::Select(npcid);
    InteractiveNPC::StartRandomTalkSequence();
    InteractiveNPC::Sleep();
	return 1;
}

InteractiveNPC::StartRandomTalkSequence()
{
	switch(InteractiveNPC[lastusedid][inpc_NpcExtra])
	{
	    case NPC_SPAWN_W_WHIT:
	    {
	        new sequenceid = 1+random(3);
	        defer InteractiveNPC_Talk(lastusedid, 0, sequenceid, NPC_DIALOGGROUP_WHIT_SPAWN);
	    }
	    
	    case NPC_MOTEL_W_WHIT:
	    {
	        new sequenceid = 1+random(3);
	        defer InteractiveNPC_Talk(lastusedid, 0, sequenceid, NPC_DIALOGGROUP_WHIT_MOTEL);
	    }
	    
	    case NPC_SPAWN_DRUG1:
	    {
	        new sequenceid = 1+random(3);
	        defer InteractiveNPC_Talk(lastusedid, 0, sequenceid, NPC_DIALOGGROUP_DRUG_SPAWN);
	    }
	}
	
	return 1;
}

//////////////////////////////

InteractiveNPC::Init()
{

	InteractiveNPC::Add(NPC_PULASKI, 20092, 632.248, -587.191, 16.3359, 275.976);
	InteractiveNPC::Anim("COP_AMBIENT", "COPLOOK_LOOP", 4.1, 1, 0, 0, 0, 0);
	InteractiveNPC::SetName("Willie Towsend");
	InteractiveNPC::SetMessage(I_NPC_MESSAGE_MAIN, "Hello, what do you need?");
	InteractiveNPC::SetMessage(I_NPC_MESSAGE_OCCUPIED, "Wait please, I am dealing with something else!");
	InteractiveNPC::AddOption(0, "I want my car back");
	InteractiveNPC::AddOption(1, "I've got a car for you");
	InteractiveNPC::AddOption(2, "How's your duty going");
	InteractiveNPC::AddOption(3, "Nothing but a G thang");
	InteractiveNPC::SetDefaultResponse(3);

    InteractiveNPC::Add(NPC_FARMER1, 159, -572.643, -1031.752, 23.98, 250.0);
	//InteractiveNPC::Anim("BD_FIRE", "WASH_UP", 4.1, 1, 1, 1, 0, 0);
	InteractiveNPC::SetName("Dayton O'Neil");
	InteractiveNPC::SetMessage(I_NPC_MESSAGE_MAIN, "What is up?");
	InteractiveNPC::SetMessage(I_NPC_MESSAGE_OCCUPIED, "Don't you fucking dare...");
	InteractiveNPC::AddOption(0, "How to get to the city?");
	InteractiveNPC::AddOption(1, "Don't you need help");
	InteractiveNPC::AddOption(2, "What are you doing");
	InteractiveNPC::AddOption(3, "Nothing,sorry");
	InteractiveNPC::SetDefaultResponse(3);
	
	////////////////////////////////////////////////////////////////////////////
	
	InteractiveNPC::Add(NPC_SPAWN_W_WHIT, 41, -595.896, -1086.526, 23.616, 241.934, .nontalking = 1);
	InteractiveNPC::Anim("GRAVEYARD", "PRST_LOOPA", 4.1, 1, 0, 0, 0, 0);
	InteractiveNPC::SetName("Catherine Whittaker");
	InteractiveNPC::StartRandomTalkSequence();
	InteractiveNPC::SetDefaultResponse(3);
	
	InteractiveNPC::Add(NPC_SPAWN_M_WHIT, 15, -594.540, -1087.190, 23.642, 58.2, .nontalking = 1);
	InteractiveNPC::Anim("COP_AMBIENT", "COPLOOK_THINK", 4.1, 1, 0, 0, 0, 0);
	InteractiveNPC::SetName("Derek Whittaker");
	InteractiveNPC::SetDefaultResponse(3);
	
	//*//*//*//
	
	InteractiveNPC::Add(NPC_SPAWN_DRUG1, 78, -582.004, -1030.942, 23.695, 326.039, .nontalking = 2);
	InteractiveNPC::Anim("CRACK", "CRCKIDLE1", 4.1, 1, 0, 0, 1, 0);
	InteractiveNPC::SetName("Matija Bailey");
	InteractiveNPC::StartRandomTalkSequence();
	InteractiveNPC::SetDefaultResponse(3);
	
	InteractiveNPC::Add(NPC_SPAWN_DRUG2, 79, -580.451, -1030.156, 23.778, 56.8, .nontalking = 2);
	InteractiveNPC::Anim("CRACK", "CRCKIDLE1", 4.1, 1, 0, 0, 1, 0);
	InteractiveNPC::SetName("Vlad Bohorij");
	InteractiveNPC::SetDefaultResponse(3);
	
	//*//*//*//
	
	InteractiveNPC::Add(NPC_MOTEL_W_WHIT, 41, 1272.731, 233.911, 19.554, 243.694 , .nontalking = 2);
	InteractiveNPC::Anim("PED", "SEAT_IDLE", 4.1, 1, 0, 0, 0, 0);
	InteractiveNPC::SetName("Catherine Whittaker");
	InteractiveNPC::StartRandomTalkSequence();
	InteractiveNPC::SetDefaultResponse(3);

	InteractiveNPC::Add(NPC_MOTEL_M_WHIT, 15, 1273.643, 233.582, 19.554, 70.0, .nontalking = 1);
	InteractiveNPC::Anim("COP_AMBIENT", "COPLOOK_LOOP", 4.1, 1, 0, 0, 0, 0);
	InteractiveNPC::SetName("Derek Whittaker");
	InteractiveNPC::SetDefaultResponse(3);
	
	InteractiveNPC::Sleep();

	////////////////////////////////////////////////////////////////////////////
    inpc_popUpTD[0] = TextDrawCreate(86.952339, 302.639923, "To talk with NPC press Y.");
	TextDrawLetterSize(inpc_popUpTD[0], 0.181712, 0.870400);
	TextDrawTextSize(inpc_popUpTD[0], 0.000000, 150.000000);
	TextDrawAlignment(inpc_popUpTD[0], 2);
	TextDrawColor(inpc_popUpTD[0], -1);
	TextDrawUseBox(inpc_popUpTD[0], 1);
	TextDrawBoxColor(inpc_popUpTD[0], 336860415);
	TextDrawSetShadow(inpc_popUpTD[0], 1);
	TextDrawSetOutline(inpc_popUpTD[0], 0);
	TextDrawBackgroundColor(inpc_popUpTD[0], 255);
	TextDrawFont(inpc_popUpTD[0], 1);
	TextDrawSetProportional(inpc_popUpTD[0], 1);
	TextDrawSetShadow(inpc_popUpTD[0], 1);

	inpc_popUpTD[1] = TextDrawCreate(161.380966, 293.239959, "LD_CHAT:badchat");
	TextDrawLetterSize(inpc_popUpTD[1], 0.000000, 0.000000);
	TextDrawTextSize(inpc_popUpTD[1], 10.000000, 10.000000);
	TextDrawAlignment(inpc_popUpTD[1], 1);
	TextDrawColor(inpc_popUpTD[1], -1);
	TextDrawSetShadow(inpc_popUpTD[1], 0);
	TextDrawSetOutline(inpc_popUpTD[1], 0);
	TextDrawBackgroundColor(inpc_popUpTD[1], 255);
	TextDrawFont(inpc_popUpTD[1], 4);
	TextDrawSetProportional(inpc_popUpTD[1], 0);
	TextDrawSetShadow(inpc_popUpTD[1], 0);
	////////////////////////////////////////////////////////////////////////////

	return 1;
}

InteractiveNPC::OnEnterArea(playerid, areaid)
{
	foreach( new inpc : InteractiveNPC )
	{
	    if(InteractiveNPC[inpc][inpc_NonTalking] != 0) continue;
	    if(areaid == InteractiveNPC[inpc][inpc_AreaId])
	    {
	        InteractiveNPC::playernpcid[playerid]   = inpc;
	        InteractiveNPC::talking[playerid]       = false;

	        TextDrawShowForPlayer(playerid, inpc_popUpTD[0]);
	        TextDrawShowForPlayer(playerid, inpc_popUpTD[1]);
	        return 1;
	    }
	}
	return 1;
}

InteractiveNPC::OnLeaveArea(playerid, areaid)
{
	foreach( new inpc : InteractiveNPC )
	{
	    if(areaid == InteractiveNPC[inpc][inpc_AreaId])
	    {
	        InteractiveNPC::playernpcid[playerid]   = INVALID_INTERACTIVE_NPC_ID;
	        InteractiveNPC::talking[playerid]       = false;

	        if(InteractiveNPC[inpc][inpc_OccupiedBy] == playerid)
	            InteractiveNPC[inpc][inpc_OccupiedBy] = INVALID_PLAYER_ID;

	        TextDrawHideForPlayer(playerid, inpc_popUpTD[0]);
	        TextDrawHideForPlayer(playerid, inpc_popUpTD[1]);
	        return 1;
	    }
	}
	return 1;
}

InteractiveNPC::OnKeyStateChange(playerid, newkeys, oldkeys)
{
	if((newkeys & KEY_YES) && !(oldkeys & KEY_SECONDARY_ATTACK) && InteractiveNPC::playernpcid[playerid] != INVALID_INTERACTIVE_NPC_ID && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
	    if(!IsPlayerInRangeOfPoint(playerid, 5.0, InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_PosX], InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_PosY], InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_PosZ]))
		{
	        if(InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_OccupiedBy] == playerid)
	        {
	            InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_OccupiedBy] = INVALID_PLAYER_ID;
				TogglePlayerControllable(playerid, 1);
				InteractiveNPC::RemoveTextdraws(playerid);
				CancelSelectTextDraw(playerid);
			}
	            
            InteractiveNPC::playernpcid[playerid]   = INVALID_INTERACTIVE_NPC_ID;
	        InteractiveNPC::talking[playerid]       = false;
		
		    return 1;
		}
	
		if(InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_OccupiedBy] != INVALID_PLAYER_ID)
		{
		    new
		        tstr[ 144 ]
			;

			format(tstr, sizeof tstr, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_MessageNotNow]);
		    ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

		    return 1;
		}
		
		TogglePlayerControllable(playerid, 0);

	    new
	        tstr[ 144 ]
		;

		format(tstr, sizeof tstr, "%s says: %s", InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Name], InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_Message]);
	    ProxDetector(playerid, 15.0, 0xFFFFFFFF, tstr);

	    InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_OccupiedBy] = playerid;
	    InteractiveNPC::CreateTextdraws(playerid);
	    SelectTextDraw(playerid, 0x3d3837AA);
	}
	return 1;
}

InteractiveNPC::ClickPlayerText(playerid, PlayerText:playertextid)
{
    if(InteractiveNPC::playernpcid[playerid] != INVALID_INTERACTIVE_NPC_ID)
    {
    
        if(!IsPlayerInRangeOfPoint(playerid, 5.0, InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_PosX], InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_PosY], InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_PosZ]))
		{
	        if(InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_OccupiedBy] == playerid)
	        {
	            InteractiveNPC[InteractiveNPC::playernpcid[playerid]][inpc_OccupiedBy] = INVALID_PLAYER_ID;
				TogglePlayerControllable(playerid, 1);
				InteractiveNPC::RemoveTextdraws(playerid);
				CancelSelectTextDraw(playerid);
			}

            InteractiveNPC::playernpcid[playerid]   = INVALID_INTERACTIVE_NPC_ID;
	        InteractiveNPC::talking[playerid]       = false;
	        
	        CancelSelectTextDraw(playerid);

		    return 1;
		}

        if(playertextid == inpc_talkTD[playerid][5])
        {
            CallLocalFunction("InteractiveNPC_Response", "ddd", playerid, InteractiveNPC::playernpcid[playerid], 0);
        }
		else if(playertextid == inpc_talkTD[playerid][6])
        {
            CallLocalFunction("InteractiveNPC_Response", "ddd", playerid, InteractiveNPC::playernpcid[playerid], 1);
        }
        else if(playertextid == inpc_talkTD[playerid][7])
        {
            CallLocalFunction("InteractiveNPC_Response", "ddd", playerid, InteractiveNPC::playernpcid[playerid], 2);
        }
        else if(playertextid == inpc_talkTD[playerid][8])
        {
            CallLocalFunction("InteractiveNPC_Response", "ddd", playerid, InteractiveNPC::playernpcid[playerid], 3);
        }
        else
        {
            return 1;
        }

        InteractiveNPC::RemoveTextdraws(playerid);
    }
    return 1;
}

InteractiveNPC::ClickTextDraw(playerid, Text:clickedid)
{
	if(InteractiveNPC::playernpcid[playerid] != INVALID_INTERACTIVE_NPC_ID && clickedid == Text:INVALID_TEXT_DRAW && InteractiveNPC::talking[playerid] == true)
	{
	    SelectTextDraw(playerid, 0x3d3837AA);
	}

	return 1;
}
