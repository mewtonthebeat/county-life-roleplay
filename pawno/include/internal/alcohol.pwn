#include <a_samp>

//////////////////////////////

#define     Alcohol::          		alc_
#define     MAX_ALCOHOL_VALUE   	600
#define     MAX_ALCOHOL_INVENTORY   15
#define     ALCOHOL_EFFECTS_FROM    15

//////////////////////////////

enum alcoholInventory()
{
	alcinv_Name[64],
	alcinv_Objem,
	alcinv_DecreaseBy,
	alcinv_Alcohol,
	alcinv_Object
}

new alcoholItems[][] = {
	"null",
	"Hennessy 40p",
	"Jack Daniels 40p",
	"Smirnoff Vodka 37.5p",
	"Budweisser 12p",
	"Captain Morgan 35p",
	"Absolut Vodka 40p",
	"Absinth Jade Edouard 72p"
};

new alcoholPercentage[] = {
	0,
	2,
	2,
	2,
	1,
	2,
	2,
	4
};

new Alcohol::inblood[ MAX_PLAYERS ];
new bool:Alcohol::holding[ MAX_PLAYERS ];
new Alcohol::alc_holding_per_drink[ MAX_PLAYERS ];
new Alcohol::obj_holding_per_drink[ MAX_PLAYERS ];
new Alcohol::objem[ MAX_PLAYERS ];
new Alcohol::invidholding[ MAX_PLAYERS ];
new Alcohol::inventory[ MAX_PLAYERS ][ MAX_ALCOHOL_INVENTORY ][alcoholInventory];

//////////////////////////////

Alcohol::AddForPlayer(playerid, value)
{
	if(Alcohol::inblood[playerid] + value > MAX_ALCOHOL_VALUE)
	{
	    Alcohol::inblood[playerid] = MAX_ALCOHOL_VALUE;
	    return 0;
	}
	
	if(value < 0 && Alcohol::inblood[playerid] + value < 0)
	{
	    Alcohol::inblood[playerid] = 0;
	    return 0;
	}

	Alcohol::inblood[playerid] += value;
	return 1;
}

Alcohol::GetFromPlayer(playerid)
{
	return Alcohol::inblood[playerid];
}

Alcohol::Holding(playerid)
{
	if(Alcohol::holding[playerid] == true)
	    return 1;
	else
		return 0;
}

Alcohol::SetHolding(playerid, bool:val, alc_per_drink = 0, obj_per_drink = -1, objem = 0, object = -1, invid = -1)
{
	if(obj_per_drink == -1) obj_per_drink = (10 + random(60));
	if(object == -1 && val == true) return 0;
	if(val == false)
	{
	    RemovePlayerAttachedObject(playerid, 8);
	}

    Alcohol::holding[playerid] 					= val;

    if(val == true)
    {
		Alcohol::alc_holding_per_drink[playerid]    = alc_per_drink;
    	Alcohol::obj_holding_per_drink[playerid]    = obj_per_drink;
    	Alcohol::objem[playerid]    				= objem;
    	Alcohol::invidholding[playerid]             = invid;
    
    	SetPlayerAttachedObject(playerid, 8, object, 6, 0.073, 0.057, 0.049);
	}
	
	return 1;
}

Alcohol::Give(playerid, name[], objem, alc, object = 1520)
{
	new x = -1;
	for(new y; y < MAX_ALCOHOL_INVENTORY; y++)
	{
	    if(Alcohol::inventory[playerid][y][alcinv_Objem] > 0)
	    {
	        continue;
	    }
	    
	    x = y;
	    break;
	}
	if(x == -1)
	    return 0;
	    
    Alcohol::inventory[playerid][x][alcinv_Objem] 		= objem;
    Alcohol::inventory[playerid][x][alcinv_Alcohol] 	= alc;
    Alcohol::inventory[playerid][x][alcinv_DecreaseBy]  = 11+random(10);
    Alcohol::inventory[playerid][x][alcinv_Object]      = object;
    format(Alcohol::inventory[playerid][x][alcinv_Name], 64, name);

	return 1;
}

Alcohol::ShowInventory(playerid, forplayerid)
{

	new
	    finstr[2048],
	    tempstr[128]
	;

	format(finstr, sizeof finstr, "{7bb875}> Alcohol bottles of player %s:\n\n{eaeaea}", GetPlayerNameEx(playerid, USE_MASK));

	for(new y; y < MAX_ALCOHOL_INVENTORY; y++)
	{
	    if(Alcohol::inventory[playerid][y][alcinv_Objem] <= 0)
	    {
	        continue;
	    }

		format(tempstr, sizeof tempstr, "\r\t- %s (%d ml)\n", Alcohol::inventory[playerid][y][alcinv_Name], Alcohol::inventory[playerid][y][alcinv_Objem]);
		strcat(finstr, tempstr);

	}

	if(invfor[playerid]==forplayerid)
	{
		ShowPlayerDialog(
		    forplayerid,
		    did_inv_alcohol,
		    DIALOG_STYLE_MSGBOX,
		    "ALCOHOL BOTTLES",
		    finstr,
		    "MENU",
		    "CLOSE"
		);
	}
	else
	{
	    ShowPlayerDialog(
		    forplayerid,
		    did_inv_alcohol,
		    DIALOG_STYLE_MSGBOX,
		    "ALCOHOL BOTTLES",
		    finstr,
		    "CLOSE",
		    ""
		);
	}

	return (true);
}

Alcohol::ShowInventoryMenu(playerid)
{

    new
	    finstr[2048],
	    tempstr[128],
	    pocet = 0
	;

	for(new y; y < MAX_ALCOHOL_INVENTORY; y++)
	{
	    if(Alcohol::inventory[playerid][y][alcinv_Objem] <= 0)
	    {
	        continue;
	    }

		format(tempstr, sizeof tempstr, "%s (%d ml)\n", Alcohol::inventory[playerid][y][alcinv_Name], Alcohol::inventory[playerid][y][alcinv_Objem]);
		strcat(finstr, tempstr);

		invItem[playerid][pocet] = y;
		pocet ++;

	}

	ShowPlayerDialog(
	    playerid,
	    did_inv_alcohol_menu,
	    DIALOG_STYLE_LIST,
	    "CHOOSE BOTTLE YOU WANT TO OPERATE WITH",
		finstr,
		"CHOOSE",
		"BACK"
	);


	return (true);
}

//////////////////////////////

Alcohol::OnDrink(playerid)
{

	new
	    alcohol = Alcohol::alc_holding_per_drink[playerid],
	    decrby  = Alcohol::obj_holding_per_drink[playerid]
	;
	
	ClearAnimations(playerid, 1);
	ApplyAnimation(playerid, "BAR", "DNK_STNDM_LOOP", 4.1, false, false, false, false, 0, true);
	
	Alcohol::objem[playerid] 	-= decrby;
	Alcohol::inblood[playerid]  += floatround(float(alcohol) * (2.0 + (random(20)/10.0)), floatround_round);
	if(Alcohol::inblood[playerid] > MAX_ALCOHOL_VALUE)
	    Alcohol::inblood[playerid] = MAX_ALCOHOL_VALUE;
	
	if(Alcohol::objem[playerid] < 0)
	{
	    Alcohol::SetHolding(playerid, false);
	    Alcohol::objem[playerid] = 0;
	    Alcohol::inventory[playerid][Alcohol::invidholding[playerid]][alcinv_Objem] 		= 0;
	    Alcohol::inventory[playerid][Alcohol::invidholding[playerid]][alcinv_DecreaseBy] 	= 0;
	    Alcohol::inventory[playerid][Alcohol::invidholding[playerid]][alcinv_Alcohol]       = 0;
	    Alcohol::inventory[playerid][Alcohol::invidholding[playerid]][alcinv_Object]        = 0;
	    
	    SendError(playerid, "Bottle was deleted because it was empty!");
	}
	else
	{
		Alcohol::inventory[playerid][Alcohol::invidholding[playerid]][alcinv_Objem] = Alcohol::objem[playerid];
	}
	
	return 1;
}

Alcohol::EffectCheck()
{
	foreach( new x : Player )
	{
	    if(Alcohol::inblood[x] <= 0)
	        continue;

		Alcohol::DoEffectsForPlayer(x);
	}
	
	return 1;
}

Alcohol::DoEffectsForPlayer(playerid)
{

	switch(Alcohol::inblood[playerid])
	{
	    case 0 .. 70:
	    {
	        // DOBR� N�LADA

			if(random(180) == 32)
			{
				new finalstring[128 + 25];

				switch(random(4))
				{
					case 0: format(finalstring, sizeof(finalstring), "** %s has worse concentration.", GetPlayerNameEx(playerid, USE_MASK));
					case 1: format(finalstring, sizeof(finalstring), "** %s is in light euphory, his mood is getting better.", GetPlayerNameEx(playerid, USE_MASK));
					case 2: format(finalstring, sizeof(finalstring), "** %s is feeling relaxed.", GetPlayerNameEx(playerid, USE_MASK));
					default: format(finalstring, sizeof(finalstring), "** %s is talky.", GetPlayerNameEx(playerid, USE_MASK));
				}
				SendLocalMessage(playerid, ME_CHAT_RANGE, COLOR_VIOLET, finalstring);
			}
			if(random(5) == 1) Alcohol::AddForPlayer(playerid, -1);
	    }
	    
	    case 71 .. 95:
	    {
	        // �AHK� OPITOS�
	        
	        if(random(180) == 32)
			{
				new finalstring[128 + 25];

				switch(random(3))
				{
					case 0: format(finalstring, sizeof(finalstring), "** %s is very talky.", GetPlayerNameEx(playerid, USE_MASK));
					case 1: format(finalstring, sizeof(finalstring), "** %s's reactions are slow.", GetPlayerNameEx(playerid, USE_MASK));
					default: format(finalstring, sizeof(finalstring), "** %s's thinking is slow.", GetPlayerNameEx(playerid, USE_MASK));
				}
				SendLocalMessage(playerid, ME_CHAT_RANGE, COLOR_VIOLET, finalstring);
			}

            if(random(5) == 1) Alcohol::AddForPlayer(playerid, -1);
			SetPlayerDrunkLevel(playerid, 1500);
	    }
	    
	    case 96 .. 190:
	    {
	        // OPITOS�
	        
	        if(random(180) == 32)
			{
				new finalstring[128 + 25];

				switch(random(5))
				{
					case 0: format(finalstring, sizeof(finalstring), "** %s's mood is changing frequently.", GetPlayerNameEx(playerid, USE_MASK));
					case 1: format(finalstring, sizeof(finalstring), "** %s's reflexes are worsened.", GetPlayerNameEx(playerid, USE_MASK));
					case 2: format(finalstring, sizeof(finalstring), "** %s's reaction time is really long.", GetPlayerNameEx(playerid, USE_MASK));
					case 3: format(finalstring, sizeof(finalstring), "** %s's motorics is really bad.", GetPlayerNameEx(playerid, USE_MASK));
					default: format(finalstring, sizeof(finalstring), "** %s's tongue is struggling to speak.", GetPlayerNameEx(playerid, USE_MASK));
				}
				SendLocalMessage(playerid, ME_CHAT_RANGE, COLOR_VIOLET, finalstring);
			}
			
			if(random(5) == 1) Alcohol::AddForPlayer(playerid, -1);
			SetPlayerDrunkLevel(playerid, 4500);
	    }
	    
     	default:
	    {
	        Achievement::Reward(playerid, ACHIEVEMENT_ALCOHOL_USAGE);
	    
	        // �A�K� OPTIOS�
	        
	        // effects: DRUNK WALK ANIM
	        if(random(180) == 32)
			{
				new finalstring[128 + 25];

				switch(random(5))
				{
					case 0: format(finalstring, sizeof(finalstring), "** %s's thinking is very bad.", GetPlayerNameEx(playerid, USE_MASK));
					case 1: format(finalstring, sizeof(finalstring), "** %s's is moving really badly and hardly.", GetPlayerNameEx(playerid, USE_MASK));
					case 2: format(finalstring, sizeof(finalstring), "** %s's has extremely long reaction time", GetPlayerNameEx(playerid, USE_MASK));
					case 3: format(finalstring, sizeof(finalstring), "** %s's loses consciousness for a couple of seconds.", GetPlayerNameEx(playerid, USE_MASK));
					default: format(finalstring, sizeof(finalstring), "** %s's has feeling like throwing up.", GetPlayerNameEx(playerid, USE_MASK));
				}
				SendLocalMessage(playerid, ME_CHAT_RANGE, COLOR_VIOLET, finalstring);
			}
			
			if(random(5) == 1) Alcohol::AddForPlayer(playerid, -1);
			
			SetPlayerDrunkLevel(playerid, 10000);
	    }
	}

	return 1;
}
