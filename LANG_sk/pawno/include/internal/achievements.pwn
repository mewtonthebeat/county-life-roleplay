////////////////////////////////////////////////////////////////////////////////

#define     Achievement:: 		achv
#define     MAX_ACHIEVEMENTS    50

////////////////////////////////////////////////////////////////////////////////

new hasAchievement[MAX_PLAYERS][MAX_ACHIEVEMENTS];

enum {
	INVALID_ACHIEVEMENT = 0,
	
	ACHIEVEMENT_FIRST_CHARACTER,
	
	ACHIEVEMENT_FIRST_MESSAGE,
	ACHIEVEMENT_1000_MESSAGES,
	ACHIEVEMENT_MILL_MESSAGES,
	ACHIEVEMENT_10MIL_MESSAGES,
	
	ACHIEVEMENT_RP_5,
	ACHIEVEMENT_RP_10,
	ACHIEVEMENT_RP_20,
	ACHIEVEMENT_RP_50,
	
	ACHIEVEMENT_CHARACTER_KILL,
	ACHIEVEMENT_ADMIN_JAIL,
	ACHIEVEMENT_KICK,
	ACHIEVEMENT_BAN,
	ACHIEVEMENT_DONATOR,
	
	ACHIEVEMENT_HAVE_10000,
	ACHIEVEMENT_HAVE_50000,
	ACHIEVEMENT_HAVE_100000,
	ACHIEVEMENT_HAVE_500000,
	ACHIEVEMENT_HAVE_1000000,
	
	ACHIEVEMENT_FIRST_VEHICLE,
	ACHIEVEMENT_VEHICLE_50000,
	ACHIEVEMENT_VEHICLE_150000,
	ACHIEVEMENT_VEHICLE_KREDITY,
	
	ACHIEVEMENT_FIRST_HOUSE,
	ACHIEVEMENT_HOUSE_100000,
	
	ACHIEVEMENT_MOTEL,
	ACHIEVEMENT_MOTEL_50DAYS,
	
	ACHIEVEMENT_FIRST_BUSINESS,
	ACHIEVEMENT_EXPENSIVE_BUSINESS,
	
	ACHIEVEMENT_WEAPON_TIER_1,
	ACHIEVEMENT_WEAPON_TIER_2,
	ACHIEVEMENT_WEAPON_TIER_3,
	ACHIEVEMENT_WEAPON_TIER_4,
	
	ACHIEVEMENT_FAST_TRAVELER,
	
	ACHIEVEMENT_ALCOHOL_USAGE,
	ACHIEVEMENT_UNDER_INFLUENCE,
	
	ACHIEVEMENT_DIE,
	
	ACHIEVEMENT_MICHALOVCE_WEED,
	ACHIEVEMENT_MICHALOVCE_PSYCH,
	
	ACHIEVEMENT_COLES_CAN_RELATE,
	ACHIEVEMENT_GETALL,
	ACHIEVEMENT_KICKALL,
}

new const achievementNames[][] = {
	"NULL",
	
	"Welcome to Red County",
	
	"First Step #1",
	"First Step #2",
	"First Step #3",
	"First Step #4",
	
	"Stage V",
	"Stage X",
	"Stage XX",
	"Stage L",
	
	"Everybody Dies",
	"Imprisoned",
	"Leave us",
	"See you! Well, maybe",

	"Pay those bills",
	
	"Getting Rich #1",
	"Getting Rich #2",
	"Getting Rich #3",
	"Getting Rich #4",
	"Getting Rich #5",
	
	"First Vehicle",
	"Going Expensive #1",
	"Going Expensive #2",
	"Going Really Expensive",
	
	"First House",
	"Expensive Housing",
	
	"Rental is for Mentals #1",
	"Rental is for Mentals #2",
	
	"Making Business",
	"Making BIG Business",
	
	"Get that Eagle",
	"Luigi",
	"FBI! Open up!",
	"Manhunt",
	
	"Fast Traveler",
	"Drink all that booze",
	"Well fuck booze",
	"Do you have your angel?",
	
	"Michalovska burina",
	"Michalovske psychadelika",
	"Daniel Coles 2014",
	"Swingers Party",
	"Genocide"
};

new const achievementDesc[][] = {
	"NULL",
	
	"Vytvor si prvy charakter.",
	
	"Napis prvu spravu do chatu.",
	"Napis tisic sprav do chatu.",
	"Napis milion sprav do chatu.",
	"Napis 10 milionov sprav do chatu.",
	
	"Dosiahni roleplay level 5.",
	"Dosiahni roleplay level 10.",
	"Dosiahni roleplay level 20.",
	"Dosiahni roleplay level 50.",
	
	"Dostan Character Kill.",
	"Dostan sa do Admin-Jailu.",
	"Dostan kick zo serveru.",
	"Dostan ban.",
	
	"Ziskaj Donator Level podporenim serveru.",
	
	"Maj pri sebe aspon 10.000$ v hotovosti.",
	"Maj pri sebe aspon 50.000$ v hotovosti.",
	"Maj pri sebe aspon 100.000$ v hotovosti.",
	"Maj pri sebe aspon 500.000$ v hotovosti.",
	"Maj pri sebe aspon 1.000.000$ v hotovosti.",
	
	"Kup si prve vozidlo.",
	"Kup si vozidlo najmenej za 50.000$.",
	"Kup si vozidlo najmenej za 150.000$.",
	"Kup si vozidlo za kredity.",
	
	"Kup si prvy dom.",
	"Kup si dom najmenej za 100.000$.",
	
	"Prenajmi si hotelovu izbu.",
	"Prenajmi si hotelovu izbu aspon na 50 dni.",
	
	"Kup si prvy biznis.",
	"Kup si biznis ktory stoji viac ako 100.000$.",
	
	"Ziskaj zbran Desert Eagle.",
	"Ziskaj zbran Shotgun.",
	"Ziskaj zbran M4.",
	"Ziskaj zbran Vesnicka Puska",
	
	"Chod nejakym vozidlom aspon 120 MPH.",
	
	"Maj aspon 2 promile alkoholu.",
	"Nafukaj aspon 2 promile alkoholu.",
	"Zomri.",
	
	"Pod bracho, dame finske!",
	"Nie si z Michaloviec?",
	"Bud ako Daniel Coles v 2014tom!",
	"Prezi hromadnu teleportaciu adminom",
	"Zhyn, ked admin vsetkych vyhodi"

};

enum {
	ACHIEVEMENT_REWARD_UNSET = 0,
	ACHIEVEMENT_REWARD_NONE,
	ACHIEVEMENT_REWARD_MONEY,
	ACHIEVEMENT_REWARD_GOLDS,
	ACHIEVEMENT_REWARD_EXPERIENCE,
	ACHIEVEMENT_HIDDEN,
}

new const achievementReward[][] = {
	{ACHIEVEMENT_FIRST_CHARACTER, 	ACHIEVEMENT_REWARD_EXPERIENCE,  1},
	
	{ACHIEVEMENT_FIRST_MESSAGE,     ACHIEVEMENT_REWARD_GOLDS,       1},
	{ACHIEVEMENT_1000_MESSAGES,     ACHIEVEMENT_REWARD_EXPERIENCE, 	1},
	{ACHIEVEMENT_MILL_MESSAGES,     ACHIEVEMENT_REWARD_EXPERIENCE,  5},
	{ACHIEVEMENT_10MIL_MESSAGES,    ACHIEVEMENT_REWARD_EXPERIENCE,  10},
	
	{ACHIEVEMENT_RP_5,     			ACHIEVEMENT_REWARD_GOLDS,  		10},
	{ACHIEVEMENT_RP_10,     		ACHIEVEMENT_REWARD_GOLDS,  		10},
	{ACHIEVEMENT_RP_20,     		ACHIEVEMENT_REWARD_GOLDS,  		10},
	{ACHIEVEMENT_RP_50,     		ACHIEVEMENT_REWARD_GOLDS,  		10},
	
	{ACHIEVEMENT_HAVE_10000,        ACHIEVEMENT_REWARD_GOLDS,       10},
	{ACHIEVEMENT_HAVE_50000,        ACHIEVEMENT_REWARD_GOLDS,       20},
	{ACHIEVEMENT_HAVE_100000,      	ACHIEVEMENT_REWARD_GOLDS,       10},
	{ACHIEVEMENT_HAVE_500000,       ACHIEVEMENT_REWARD_GOLDS,      	10},
	{ACHIEVEMENT_HAVE_1000000,     	ACHIEVEMENT_REWARD_GOLDS,       10},
	
	{ACHIEVEMENT_DONATOR,           ACHIEVEMENT_REWARD_EXPERIENCE,  3},
	
	{ACHIEVEMENT_FIRST_VEHICLE,     ACHIEVEMENT_REWARD_EXPERIENCE,  1},
	{ACHIEVEMENT_VEHICLE_50000,     ACHIEVEMENT_REWARD_EXPERIENCE,  1},
	{ACHIEVEMENT_VEHICLE_150000,    ACHIEVEMENT_REWARD_EXPERIENCE,  2},

	{ACHIEVEMENT_FIRST_HOUSE,       ACHIEVEMENT_REWARD_EXPERIENCE,  1},
	{ACHIEVEMENT_HOUSE_100000,      ACHIEVEMENT_REWARD_EXPERIENCE,  2},
	
	{ACHIEVEMENT_MOTEL,             ACHIEVEMENT_REWARD_EXPERIENCE,  1},
	{ACHIEVEMENT_MOTEL_50DAYS,      ACHIEVEMENT_REWARD_GOLDS,       10},
	
	{ACHIEVEMENT_FIRST_BUSINESS,    ACHIEVEMENT_REWARD_EXPERIENCE,  1},
	{ACHIEVEMENT_EXPENSIVE_BUSINESS,ACHIEVEMENT_REWARD_EXPERIENCE,  2},
	
	{ACHIEVEMENT_FAST_TRAVELER,     ACHIEVEMENT_REWARD_EXPERIENCE,  1},
	{ACHIEVEMENT_ALCOHOL_USAGE,     ACHIEVEMENT_REWARD_EXPERIENCE,  1},
	
	{ACHIEVEMENT_MICHALOVCE_WEED,	ACHIEVEMENT_HIDDEN,             0},
	{ACHIEVEMENT_MICHALOVCE_PSYCH,  ACHIEVEMENT_HIDDEN,             0},
	{ACHIEVEMENT_COLES_CAN_RELATE,  ACHIEVEMENT_HIDDEN,             0},
	{ACHIEVEMENT_GETALL,  			ACHIEVEMENT_HIDDEN,             0},
	{ACHIEVEMENT_KICKALL,  			ACHIEVEMENT_HIDDEN,             0}
};

Function:: Achievement::Reward(playerid, achievementid = INVALID_ACHIEVEMENT)
{

	if(hasAchievement[playerid][achievementid] != 0)
	    return 1;

	new
	    queryx[ 256 ],
	    Cache:result
	;
	
	mysql_format(MYSQL, queryx, sizeof queryx, "SELECT * FROM master_achievements WHERE user = '%e' AND achievementid = '%d'", ReturnMaster(playerid), achievementid);
	result = mysql_query(MYSQL, queryx);
	
	if(cache_num_rows() > 0)
	{
	    cache_delete(result);
	    return 0;
	}
	
	cache_delete(result);
	
	////////////////////////////////////////////////////////////////////////////
	
	mysql_format(MYSQL, queryx, sizeof queryx, "INSERT INTO master_achievements (user,achievementid,date) VALUES ('%e','%d','%d')", ReturnMaster(playerid),achievementid,gettime());
	mysql_tquery(MYSQL, queryx);
	
	hasAchievement[playerid][achievementid] = 1;

    ////////////////////////////////////////////////////////////////////////////

	new
	    array_pos = -1
	;
	
	for( new x; x < sizeof achievementReward; x++)
	{
	    if(achievementReward[x][0] == achievementid)
	    {
	        array_pos = x;
	        break;
	    }
	}
	
	new
	    reward_type = ACHIEVEMENT_REWARD_UNSET,
	    reward_quantity = 0
	;
	
	if(array_pos != -1)
	{
	    reward_type = achievementReward[array_pos][1];
	    reward_quantity = achievementReward[array_pos][2];
	}
	
	////////////////////////////////////////////////////////////////////////////
	
	if(reward_type == ACHIEVEMENT_REWARD_UNSET)
	{
	
	}
	
	////////////////////////////////////////////////////////////////////////////
	
	if(reward_type != ACHIEVEMENT_REWARD_UNSET)
	{

		new attachstr[16];
		
		switch(reward_type)
		{
		    case ACHIEVEMENT_REWARD_MONEY:
		    {
		        strcat(attachstr, "$");
		        ex_GivePlayerMoney(playerid, reward_quantity);
			}
		        
            case ACHIEVEMENT_REWARD_GOLDS:
            {
		        strcat(attachstr, " kreditov");
		        g_I_mince[playerid] += reward_quantity;
			}
		        
            case ACHIEVEMENT_REWARD_EXPERIENCE:
            {
		        strcat(attachstr, " XP");
		        g_I_XP[playerid] += reward_quantity;
		        if(g_I_XP[playerid] > (6 + (2 * GetPlayerRoleplayLevel(playerid))))
				{
				    SCFM(playerid, 0xD0D0D0FF, "[ ! ] M·ö dosù XP bodov, aby si si mohol k˙più upgrade na roleplay level %d! Pouûi /levelup, bude ùa to st·ù %d XP.", GetPlayerRoleplayLevel(playerid) + 1, (6 + 2*GetPlayerRoleplayLevel(playerid)));
				}
			}
		}
	
	    SCFM(playerid, 0x78d852ff, "[ ACHIEVEMENT ] {FFFFFF}Za dokonËenie achievementu %s si dostal odmenu %d%s!", achievementNames[achievementid], reward_quantity, attachstr);
	}
	
	////////////////////////////////////////////////////////////////////////////
	
	PlayerTextDrawSetString(playerid, PTD_achievement[playerid][0], _:replaceChars(achievementNames[achievementid]));
	PlayerTextDrawSetString(playerid, PTD_achievement[playerid][1], _:replaceChars(achievementDesc[achievementid]));
	
	TextDrawShowForPlayer(playerid, TD_achievement[0]);
	TextDrawShowForPlayer(playerid, TD_achievement[1]);
	TextDrawShowForPlayer(playerid, TD_achievement[2]);
	TextDrawShowForPlayer(playerid, TD_achievement[3]);
	TextDrawShowForPlayer(playerid, TD_achievement[4]);
	
	PlayerTextDrawShow(playerid, PTD_achievement[playerid][0]);
	PlayerTextDrawShow(playerid, PTD_achievement[playerid][1]);
	
	defer HideAchievement(playerid);

	return 1;
}

Function:: Achievement::List(playerid, forplayerid = -1)
{
	if(forplayerid == -1)
	    forplayerid = playerid;

	new
		sQuery[128]
	;
	
	mysql_format(MYSQL, sQuery, sizeof sQuery, "SELECT * FROM master_achievements WHERE user = '%e'", ReturnMaster(playerid));
	mysql_tquery(MYSQL, sQuery, "OnAchievementListLoad", "dd", playerid, forplayerid);

	return 1;
}

Function:: Achievement::Save()
{
	mysql_tquery(MYSQL, "DELETE FROM achievements_list", "OnAchievementsDelete", "");
	return 1;
}

function OnAchievementsDelete()
{
	new sQuery[512], hidden = 0;
    for(new x = 1, y = sizeof achievementNames; x < y; x++)
    {
        hidden = 0;
    
        new
		    array_pos = -1
		;

		for( new e; e < sizeof achievementReward; e++)
		{
		    if(achievementReward[e][0] == x)
		    {
		        array_pos = e;
		        break;
		    }
		}

		if(array_pos != -1)
		{
		    if(achievementReward[array_pos][1] == ACHIEVEMENT_HIDDEN)
		        hidden = 1;
		}
    
        mysql_format(MYSQL, sQuery, sizeof sQuery, "INSERT INTO achievements_list (id,name,descr,hidden) VALUES ('%d','%e','%e','%d')", x, achievementNames[x], achievementDesc[x], hidden);
        mysql_tquery(MYSQL, sQuery);
    }
	return 1;
}

function OnAchievementListLoad(playerid, forplayerid)
{
    new
	    achievement_IsCompleted[MAX_ACHIEVEMENTS],
	    achievement_IdTmp
	;
	
	for(new x, y = cache_num_rows(); x < y; x++)
	{
	    cache_get_value_name_int(x, "achievementid", achievement_IdTmp);
	    achievement_IsCompleted[achievement_IdTmp] = 1;
	}
	
	////////////////////////////////////////////////////////////////////////////
	
	new
	    sContent[ 4096 ] = "N·zov\t⁄loha\n",
	    sTemporary [ 128 ],
	    hidden = 0
	;
	
	for(new x = 1, y = sizeof achievementNames; x < y; x++)
	{
	    hidden = 0;
	
	    new
		    array_pos = -1
		;

		for( new e; e < sizeof achievementReward; e++)
		{
		    if(achievementReward[e][0] == x)
		    {
		        array_pos = e;
		        break;
		    }
		}
		
		if(array_pos != -1)
		{
		    if(achievementReward[array_pos][1] == ACHIEVEMENT_HIDDEN)
		        hidden = 1;
		}
		
		if(hidden == 1 && achievement_IsCompleted[x] != 1)
	    {
	        format(sTemporary, sizeof sTemporary, "{969696}Zamknut˝ achievement\t{FFFFFF}Tento achievement musÌö splniù, aby sa zobrazil!\n");
	    }
		else if(achievement_IsCompleted[x] == 1)
		{
			format(sTemporary, sizeof sTemporary, "{95ef83}%s\t{FFFFFF}%s\n", achievementNames[x], achievementDesc[x]);
		}
		else
		{
		    format(sTemporary, sizeof sTemporary, "{e0716d}%s\t{FFFFFF}%s\n", achievementNames[x], achievementDesc[x]);
		}
		
		strcat(sContent, sTemporary);
	}
	
	ShowPlayerDialog(playerid, did_achievements, DIALOG_STYLE_TABLIST_HEADERS, "TV… ACHIEVEMENTY", sContent, "OK", "");
	
	return 1;
}

timer HideAchievement[10000](playerid)
{
    TextDrawHideForPlayer(playerid, TD_achievement[0]);
	TextDrawHideForPlayer(playerid, TD_achievement[1]);
	TextDrawHideForPlayer(playerid, TD_achievement[2]);
	TextDrawHideForPlayer(playerid, TD_achievement[3]);
	TextDrawHideForPlayer(playerid, TD_achievement[4]);

	PlayerTextDrawHide(playerid, PTD_achievement[playerid][0]);
	PlayerTextDrawHide(playerid, PTD_achievement[playerid][1]);

	return 1;
}
