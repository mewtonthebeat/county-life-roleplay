#include 	<a_samp>

//------------------------------------------------------------------------------

/*

		ZaËiatok skriptu:
		
		Meno skriptu:           Corpse System
		v1.0
		
		
		{
			// pred funkciami atd pouûijem tag
			CPS_ || CPS

		}
		
		Zoznam funkciÌ: {
		    * CPS_CreateCorpse(playerid)
		        - returnuje ID mrtvoly pri uspechu
		        - returnuje CPS_INVALID_CORPSE_ID pri neupsechu
		        
            * CPS_CreateCorpseEx(model, Float:pX, Float:pY, Float:pZ, Float:pA, name[] = "", virtualWorld = 0, interiorId = 0)
		        - returnuje ID mrtvoly pri uspechu
		        - returnuje CPS_INVALID_CORPSE_ID pri neupsechu
		        
            * CPS_DestroyCorpse(id)
		        - returnuje 1 pri uspechu
		        - returnuje CPS_INVALID_CORPSE_ID pri neupsechu
		        
			* CPS_DestroyOldestCorpse()
			    - returnuje 1 vzdy
				
			* CPS_SetCorpseName(id, name[])
				- returnuje 0 ak mrtvola neexistuje
				- returnuje 1 ak success
				
			* CPS_SetCorpseAngle(id, Float:angle)
			    - returnuje 0 ak mrtvola neexistuje
				- returnuje 1 ak success
				
			* CPS_SetCorpseSkin(id, skin)
			    - returnuje 0 ak mrtvola neexistuje
				- returnuje 1 ak success
			...
		}
*/

// definicie
#define     CPS_MAX_CORPSES     			(250)
#define     CPS_RESYNC_ANIM_TIMER           (1000 * 60 * 5)     // 5 minut
#define     CPS_MAX_KEY_YES_PER_SEC         (3 * 1000)          // 3 sekundy
#define     CPS_DRAG_CORPSE_TIMER           (750)

#define     CPS_FIRE_OBJECT                 (18688)
#define     CPS_BODY_BAG_OBJECT             (19944)

#define     CPS_DIALOG                      (8666)              	// TOTO SI UPRAV
#define     CPS_DIALOG_DAMAGE               (8667)              	// TOTO SI UPRAV
#define     CPS_MAX_DAMAGE_SLOTS            (30)                // TOTO SI UPRAV

#define     CPS_ACTOR_STREAM_DISTANCE      	(300.0)
#define     CPS_ACTOR_STREAM_PRIORITY       (3)

#define     CPS_VALID_BODYBAG               (-2)                // pre cekovanie ked je v kufri

#define     CPS_LABEL_COLOR                 (0xdd6161FF)
#define     CPS_LABEL_STREAM_DISTANCE       (15.0)
#define     CPS_LABEL_DRAW_DISTANCE       	(4.0)
#define     CPS_LABEL_STREAM_PRIORITY       (3)
#define     CPS_LABEL_STRING_SIZE           (144 + (MAX_PLAYER_NAME + 1))

#define     CPS_HEAD_LABEL_DRAGGING         "* t·hne mrtvolu *"
#define     CPS_HEAD_LABEL_COLOR            (0xc2a2daFF)

#define     CPS_CMD_SYNTAX_ADMIN            "[mrtvola]: /mrtvola [zranenia-bodybag-zapalit-otocit-tahat-kufor-(vytvorit-zmazat-zmazatvsetky-upravit-info)]"
#define     CPS_CMD_SYNTAX_ADMIN_VYTVORIT   "[mrtvola]: /mrtvola vytvorit [skin id] [meno]"
#define     CPS_CMD_SYNTAX_ADMIN_UPRAVIT   	"[mrtvola]: /mrtvola upravit [meno-rotacia-skin-stadium] [data]"
#define     CPS_CMD_SYNTAX            		"[mrtvola]: /mrtvola [zranenia-bodybag-zapalit-otocit-tahat-kufor]"
#define     CPS_CMD_NO_PERM                 "[mrtvola]: Na pouûitie tohoto prÌkazu nem·ö opr·vnenie."
#define     CPS_CMD_NO_NEARBY_CORPSE        "[mrtvola]: V tvojom okolÌ nie je ûiadna m‡tvola."
#define     CPS_CMD_NO_NEARBY_VEHICLE       "[mrtvola]: V tvojom okolÌ nie je ûiadne vozidlo."
#define     CPS_CMD_NO_EDITING_DRAGGED      "[mrtvola]: NemÙûeö manipulovaù s m‡tvolou, keÔ ju niekto ùah·."
#define     CPS_CMD_NO_EDITING_BURNING      "[mrtvola]: NemÙûeö manipulovaù s m‡tvolou, keÔ horÌ.."
#define     CPS_CMD_BAD_ANGLE               "[mrtvola]: ProsÌm zadaj rot·ciu ako d·ta vo veækosti 0.0 aû 359.9."
#define     CPS_CMD_BAD_SKIN_ID             "[mrtvola]: ProsÌm zadaj spr·vn˝ skin (0 - 311, alebo 20000 - 29999)."
#define     CPS_CMD_BAD_STADIUM             "[mrtvola]: ProsÌm zadaj spr·vnÈ ID öt·dia. (0 - 8)"
#define     CPS_CMD_CORPSE_CREATED          "[mrtvola]: M‡tvola bola ˙speöne vytvoren·."
#define     CPS_CMD_CORPSE_DELETED          "[mrtvola]: M‡tvola bola ˙speöne zmazan·."
#define     CPS_CMD_CORPSE_DELETED_ALL      "[mrtvola]: Vöetky m‡tvoly boly ˙speöne zmaz·ne."
#define     CPS_CMD_CORPSE_RENAMED          "[mrtvola]: M‡tvola bola ˙speöne premenovan·."
#define     CPS_CMD_CORPSE_REANGLED         "[mrtvola]: ⁄speöne si upravil rot·ciu m‡tvoly."
#define     CPS_CMD_CORPSE_RESKINED         "[mrtvola]: ⁄speöne si upravil skin m‡tvoly."
#define     CPS_CMD_CORPSE_RESTADIED        "[mrtvola]: ⁄speöne si upravil öt·dium rozkladu m‡tvoly."
#define     CPS_CMD_OTOCENA                 "[mrtvola]: ⁄speöne si otoËil m‡tvolu."
#define     CPS_CMD_CORPSE_TAHNES           "[mrtvola]: ZaËal si ùahaù m‡tvolu, pustÌö ju stlaËenÌm tlaËidla F {ENTER}. Kl·vesou Y ju d·ö do kufra auta."
#define     CPS_CMD_STOP_DRAG               "[mrtvola]: Prestal si ùahaù mrtvolu."
#define     CPS_CMD_NEMAS_ZAPALKY           "[mrtvola]: Aby si mohol zap·liù mrtvolu, musÌö maù zapalovaË."
#define     CPS_CMD_CORPSE_ZAPALILS         "[mrtvola]: Zap·lil si mrtvolu."
#define     CPS_STORE_SUCCESS               "[mrtvola]: Vloûil si mrtvolu do kufra vozidla %s, je tam %d z maxim·lnych %d m‡tvol. Vytiahneö ju prÌkazom /mrtvola kufor."
#define     CPS_UNSTORE_SUCCESS             "[mrtvola]: Vytiahol si mrtvolu z kufra vozidla %s, mÙûeö ju ùahaù prÌkazom /mrtvola tahat."
#define     CPS_CMD_NO_CORPSE_IN_VEHICLE    "[mrtvola]: Nem·ö vo vozidle ûiadnu mrtvolu!"
#define     CPS_CMD_NEMAS_BODYBAG           "[mrtvola]: Nem·ö vrece na mrtvoly!"
#define     CPS_CMD_BODYBAG_DOWN            "[mrtvola]: Vytiahol si telo z vreca na mrtvoly!"
#define     CPS_CMD_BODYBAG_ON              "[mrtvola]: Zabalil si telo do vreca na mrtvoly!"
#define     CPS_CMD_CANT_EXAMINE            "[mrtvola]: T˙to akciu nemÙûeö spraviù, keÔ je telo vo vreci!"
#define    	CPS_CMD_TRUNK_CLOSED            "[mrtvola]: Kufor tohoto vozidla je zatvoren˝!"
#define     CPS_CMD_NO_DAMAGE               "[mrtvola]: T·to mrtvola nem· ûiadne zaznamenanÈ poökodenie!"

#define     CPS_INVALID_CORPSE_ID           (-255)

#define		PVAR_IS_DRAGGING				"CPS_IsDragging"
#define     PVAR_IS_DRAGGING_ID             "CPS_IsDraggingID"
#define     PVAR_TIMER                      "CPS_Timer"
#define     PVAR_HEADLABEL                  "CPS_HeadLabel"
#define     PVAR_TEMP_VEHICLE               "CPS_DialogVehicle"
// koniec definicii

// callback
forward CPS_OnVehicleBootStatusUpdate(vehicleid, oldboot, boot);
// ^^^^ tento callback volame predtym, ako updatujeme status cez SetVehicleParamsEx(:::)!!!!!!!
// ^^^^ oldboot = stare stadium kufra - teda to ktore este plati, boot = nove, ktore PO tejto funkcii updatujeme
// konec

// premenne, enumy
enum CPS_E_corpseEnum()
{
	// position
	Float:CPS_E_posX,
	Float:CPS_E_posY,
	Float:CPS_E_posZ,
	Float:CPS_E_posA,
	CPS_E_virtualWorld,
	CPS_E_interiorId,
	
	// data
	CPS_E_name[ MAX_PLAYER_NAME + 1 ],
	CPS_E_skinId,
	CPS_E_actorId,
	CPS_E_otocena,
	Text3D:CPS_E_labelId,
	Timer:CPS_E_animTimerId,
	CPS_E_timestampCreated,
	CPS_E_isBeingDragged,
	CPS_E_isBurning,
	CPS_E_fireObject,
	CPS_E_bodyBag,
	Timer:CPS_E_burnTimer,
	
	Stadium:CPS_E_stadium,
	
	CPS_E_vehicleId,
}

enum Stadium {
	// »AS JE V RE¡LNYCH HODIN¡CH
	CPS_STADIUM_CERSTVA,                // (0 - 4h ) M‡tvola sa bezproblÈmov identifikuje
	CPS_STADIUM_STUDENA,                // (4 - 10h) M‡tvola sa bezproblÈmov identifikuje
	CPS_STADIUM_ROZKLAD_I,              // (10 - 16h) M‡tvola sa bezproblÈmov identifikuje, zaËÌna zap·chaù
	CPS_STADIUM_ROZKLAD_II,            	// (16 - 24h) M‡tvola sa st·le d· jakö-takö identifikovaù, straöne smrdÌ
	CPS_STADIUM_ROZKLAD_III,            // (24 - 38h) M‡tvola sa je uû takmer rozloûen·, st·le d· jakö-takö identifikovaù, smrdÌ jak hanys
	CPS_STADIUM_ROZKLAD_IV,             // (38h+) M‡tvola sa ned· identifikovaù, ned· sa s Úou h˝baù
	CPS_STADIUM_OBHORENA,               // (Iba zap·lenÌm) M‡tvola sa ned· identifikovaù, ned· sa s Úou h˝baù, msrdÌ jak kuracie m‰sko
	CPS_STADIUM_HORI,              	 	// (Iba zap·lenÌm) M‡tvola sa ned· identifikovaù, ned· sa s Úou h˝baù, horÌ
}

new Iterator:Corpse<CPS_MAX_CORPSES>;
new Iterator:CPS_PlayerDamage[MAX_PLAYERS]<CPS_MAX_DAMAGE_SLOTS>;
new Iterator:CPS_CorpseDamage[CPS_MAX_CORPSES]<CPS_MAX_DAMAGE_SLOTS>;
new CPS_E_corpse[CPS_MAX_CORPSES][CPS_E_corpseEnum];

new CPS_playerDamage[MAX_PLAYERS][CPS_MAX_DAMAGE_SLOTS][2];
new CPS_corpseDamage[CPS_MAX_CORPSES][CPS_MAX_DAMAGE_SLOTS][2];

new const A_CPS_vehicleCorpseSlots[][] = {
	// model auta       poËet slotov
	{400,               2},         // Landstalker
	{401,               1},         // Bravura
	{402,               1},         // Buffalo
	{404,               1},         // Perennial
	{405,               1},         // Sentinel
	{409,               1},         // Stretch
	{410,               1},         // Manana
	{412,               1},         // Voodoo
	{413,               3},         // Pony
	{414,               5},         // Mule
	{416,               2},         // Ambulance
	{417,               1},         // Leviathan
	{418,               3},         // Moonbeam
	{419,               1},         // Esperanto
	{420,               1},         // Taxi
	{421,               1},         // Washington
	{422,               2},         // Bobcat       (( PICKUP !!! ))
	{426,               1},         // Premier
	{427,               3},         // Enforcer
	{428,               3},         // Securicar
	{429,               3},         // Banshee
	{433,               10},        // Barracks
	{435,               20},        // Article Trailer
	{436,               1},         // Previon
	{438,               1},         // Cabbie
	{439,               1},         // Stallion
	{440,               3},         // Rumpo
	{442,               1},         // Romero
	{445,               1},         // Admiral
	{455,               8},        	// Flatbed
	{456,               8},         // Yankee
	{458,               1},         // Solair
	{459,               3},         // Topfun Van
	{466,               2},         // Glendale
	{467,               1},         // Sanchez
	{474,               1},         // Hermes
	{475,               1},         // Sabre
	{478,               2},         // Walton           (( PICKUP ))
	{479,               1},         // Regina
	{482,               5},         // Burrito
	{489,               1},         // Rancher
	{490,               1},         // FBI Rancher
	{491,               1},         // Virgo
	{492,               1},         // Greenwood
	{495,               1},         // Sandking
	{496,               1},         // Blista Compact
	{498,               5},         // Boxville
	{499,               8},         // Benson
	{504,               1},         // Bloodring Banger
	{505,               1},         // Rancher Lure
	{506,               1},         // Super GT
	{507,               1},         // Elegant
	{516,               1},         // Nebula
	{517,               1},         // Majestic
	{518,               2},         // Buccaneer
	{526,               1},         // Fortune
	{529,               1},         // Willard
	{533,               1},         // Feltzer
	{534,               1},         // Remington
	{535,               1},         // Slamvan      (( PICKUP ))
	{536,               1},         // Blade
	{540,               1},         // Vincent
	{542,               1},         // Clover
	{543,               2},         // Sadler
	{546,               1},         // Intruder
	{547,               1},         // Primo
	{549,               1},         // Tampa
	{550,               1},         // Sunrise
	{551,               1},         // Merit
	{554,               3},         // Yosemite     (( PICKUP))
	{558,               1},         // Ur anus
	{559,               1},         // Jester
	{560,               1},         // Sultan
	{561,               1},         // Stratum
	{562,               1},         // Elegy
	{565,               1},         // Flash
	{566,               1},         // Tahoma
	{567,               1},         // Savanna
	{575,               1},         // Broadway
	{576,               1},         // Tornado
	{579,               2},         // Huntley
	{580,               1},         // Stafford
	{582,               2},         // Newsvan
	{585,               1},         // Emperor
	{587,               1},         // Euros
	{589,               1},         // Club
	{596,               1},         // LSPD
	{597,               1},         // SFPD
	{598,               1},         // LVPD
	{599,               1},         // Ranger
	{600,               2},         // Picador      ((PICKUP))
	{602,               1},         // Alpha
	{603,               1},         // Phoenix
	{604,               2},         // Glendale Shit
	{605,               2},         // Sadler Shit
	{609,               5}          // Boxville
};

stock const CPS_gVehicleTempDataNames[][] =
{
	"Landstalker",
	"Bravura",
	"Buffalo",
	"Linerunner",
	"Perrenial",
	"Sentinel",
	"Dumper",
	"Firetruck",
	"Trashmaster",
	"Stretch",
	"Manana",
	"Infernus",
	"Voodoo",
	"Pony",
	"Mule",
	"Cheetah",
	"Ambulance",
	"Leviathan",
	"Moonbeam",
	"Esperanto",
	"Taxi",
	"Washington",
	"Bobcat",
	"Mr Whoopee",
	"BF Injection",
	"Hunter",
	"Premier",
	"Enforcer",
	"Securicar",
	"Banshee",
	"Predator",
	"Bus",
	"Rhino",
	"Barracks",
	"Hotknife",
	"Trailer 1",
	"Previon",
	"Coach",
	"Cabbie",
	"Stallion",
	"Rumpo",
	"RC Bandit",
	"Romero",
	"Packer",
	"Monster",
	"Admiral",
	"Squalo",
	"Seasparrow",
	"Pizzaboy",
	"Tram",
	"Trailer 2",
	"Turismo",
	"Speeder",
	"Reefer",
	"Tropic",
	"Flatbed",
	"Yankee",
	"Caddy",
	"Solair",
	"Berkley's RC Van",
	"Skimmer",
	"PCJ-600",
	"Faggio",
	"Freeway",
	"RC Baron",
	"RC Raider",
	"Glendale",
	"Oceanic",
	"Sanchez",
	"Sparrow",
	"Patriot",
	"Quad",
	"Coastguard",
	"Dinghy",
	"Hermes",
	"Sabre",
	"Rustler",
	"ZR-350",
	"Walton",
	"Regina",
	"Comet",
	"BMX",
	"Burrito",
	"Camper",
	"Marquis",
	"Baggage",
	"Dozer",
	"Maverick",
	"News Chopper",
	"Rancher",
	"FBI Rancher",
	"Virgo",
	"Greenwood",
	"Jetmax",
	"Hotring",
	"Sandking",
	"Blista Compact",
	"Police Maverick",
	"Boxville","Benson",
	"Mesa",
	"RC Goblin",
	"Hotring Racer A",
	"Hotring Racer B",
	"Bloodring Banger",
	"Rancher",
	"Super GT",
	"Elegant",
	"Journey",
	"Bike",
	"Mountain Bike",
	"Beagle",
	"Cropdust",
	"Stunt",
	"Tanker",
	"Roadtrain",
	"Nebula",
	"Majestic",
	"Buccaneer",
	"Shamal",
	"Hydra",
	"FCR-900",
	"NRG-500",
	"HPV1000",
	"Cement Truck",
	"Tow Truck",
	"Fortune",
	"Cadrona",
	"FBI Truck",
	"Willard",
	"Forklift",
	"Tractor",
	"Combine",
	"Feltzer",
	"Remington",
	"Slamvan",
	"Blade",
	"Freight",
	"Streak",
	"Vortex",
	"Vincent",
	"Bullet",
	"Clover",
	"Sadler",
	"Firetruck LA",
	"Hustler",
	"Intruder",
	"Primo",
	"Cargobob",
	"Tampa",
	"Sunrise",
	"Merit",
	"Utility",
	"Nevada",
	"Yosemite",
	"Windsor",
	"Monster A",
	"Monster B",
	"Uranus","Jester",
	"Sultan",
	"Stratum",
	"Elegy",
	"Raindance",
	"RC Tiger",
	"Flash",
	"Tahoma",
	"Savanna",
	"Bandito",
	"Freight Flat",
	"Streak Carriage",
	"Kart","Mower",
	"Duneride",
	"Sweeper",
	"Broadway",
	"Tornado",
	"AT-400",
	"DFT-30",
	"Huntley",
	"Stafford",
	"BF-400",
	"Newsvan",
	"Tug",
	"Trailer 3",
	"Emperor",
	"Wayfarer",
	"Euros",
	"Hotdog",
	"Club",
	"Freight Carriage",
	"Trailer 3",
	"Andromada",
	"Dodo",
	"RC Cam",
	"Launch",
	"Police Car (LSPD)",
	"Police Car (SFPD)",
	"Police Car (LVPD)",
	"Police Ranger",
	"Picador",
	"S.W.A.T. Van",
	"Alpha",
	"Phoenix",
	"Glendale",
	"Sadler",
	"Luggage Trailer A",
	"Luggage Trailer B",
	"Stair Trailer",
	"Boxville",
	"Farm Plow",
	"Utility Trailer"
};

new const CPS_A_BodypartNames[][] = {
	"TRUP",
	"OBLAST éEBER",
	"LEV¡ RUKA",
	"PRAV¡ RUKA",
	"LEV¡ NOHA",
	"PRAV¡ NOHA",
	"HLAVA"
	/*"Trup",
	"Oblast ûeber",
	"Lev· ruka",
	"Prav· ruka",
	"Lev· noha",
	"Prav· noha",
	"Hlava"*/
};

new const CPS_A_weaponNames[][] = {
	/*"PÃST",
	"BOXER",
	"GOLFOV¡ HŸL",
	"OBUäEK",
	"NŸé",
	"P¡LKA",
	"LOPATA",
	"BILIARDOV¡ TY»",
	"KATANA",
	"MOTOROV¡ PILA",
	"DILDO",
	"DILDO",
	"VIBR¡TOR",
	"VIBR¡TOR",
	"KVÃTINY",
	"HŸL",
	"GRAN¡T",
	"SLZN› PLYN",
	"MOLOTOVŸV KOKTEJL",
	"",
	"",
	"",
	"COLT .45",
	"COLT .45 TLUMEN›",
	"DESERT EAGLE",
	"BROKOVNICE",
	"UPIL. BROKOVNICE",
	"BOJ. BROKOVNICE",
	"MICRO SMG",
	"MP5",
	"AK-47",
	"M4",
	"TEC-9",
	"VESNICK¡ PUäKA",
	"SNIPERKA",
	"RPG",
	"RAKETOMET",
	"PLAMÃNOMET",
	"MINIGUN",
	"SATCHEL",
	"DETON¡TOR",
	"SPREJ",
	"HASÕCÕ PÿÕSTROJ",
	"KAMERA",
	"NIGHT V. GOGGLES",
	"THERMAL GOGGLES",
	"PAD¡K"*/               // nadtymto to je robene velkym, jak chces to daj
	"PÏst",
	"Boxer",
	"Golfov· h˘l",
	"Obuöek",
	"N˘û",
	"P·lka",
	"Lopata",
	"Biliardov· tyË",
	"Katana",
	"Motorov· pila",
	"Dildo",
	"Dildo",
	"Vibr·tor",
	"Vibr·tor",
	"KvÏtiny",
	"H˘l",
	"Gran·t",
	"Slzn˝ plyn",
	"Molotov˘v koktejl",
	"",
	"",
	"",
	"Colt .45",
	"Colt s tlumiËem",
	"Desert Eagle",
	"Brokovnice",
	"Upil. brokovnice",
	"Bojov. brokovnice",
	"Micro SMG",
	"MP5",
	"AK-47",
	"M4",
	"Tec-9",
	"Vesnick· puöka",
	"Sniperka",
	"RPG",
	"Raketomet",
	"Plamenomet",
	"Minigun",
	"Satchel",
	"Deton·tor",
	"Sprej",
	"HasÌcÌ p¯Ìstroj",
	"Kamera",
	"NoËnÌ vidÏnÌ",
	"TeplÈ vidÏnÌ",         // idk jak prelozit thermal googles neviem to ani len slovensky povedat
	"Pad·k"
};
// koniec premennych, enumov

// funkcie
#define CPS_GetVehicleName(%1)  		CPS_gVehicleTempDataNames[GetVehicleModel(%1) - 400]
#define CPS_GetWeaponName(%1)   		CPS_A_weaponNames[%1]
#define CPS_GetBodypartName(%1) 		CPS_A_BodypartNames[%1 - 3]
#define CPS_HasPlayerAdminRights(%1)    (GetPlayerAdminLevel(%1) > 3) // tu nahrad vlastnu podmienku, napr (GetPlayerAdminLevel(%1) > 3), len to daj do zatvoriek

stock Float:CPS_GetDistanceBetweenPoints(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2)
{
    return VectorSize(x1-x2,y1-y2,z1-z2);
}

stock CPS_GetVehicleBootOffset(vehicleid, &Float:x, &Float:y, &Float:z)
{
    new Float:fPos[4], Float:fSize[3];

    if (!IsValidVehicle(vehicleid))
    {
        x = 0.0;
        y = 0.0;
        z = -1000.0;

        return 0;
    }
    else
    {
        GetVehiclePos(vehicleid, fPos[0], fPos[1], fPos[2]);
        GetVehicleZAngle(vehicleid, fPos[3]);
        GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, fSize[0], fSize[1], fSize[2]);

       	x = fPos[0] - (floatsqroot(fSize[1] + fSize[1]) * floatsin(-fPos[3], degrees));
        y = fPos[1] - (floatsqroot(fSize[1] + fSize[1]) * floatcos(-fPos[3], degrees));
        z = fPos[2];
    }
    return 1;
}

stock CPS_GetVehicleBootOffsetEx(vehicleid, &Float:x, &Float:y, &Float:z)
{
    new Float:fSize[3];

    if (!IsValidVehicle(vehicleid))
    {
        x = 0.0;
        y = 0.0;
        z = -1000.0;

        return 0;
    }
    else
    {
        GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, fSize[0], fSize[1], fSize[2]);

       	x = 0.0;
        y = (-(fSize[1] * 0.5) + 0.15);
        z = (fSize[2] * 0.3);
    }
    return 1;
}

stock CPS_decode_boot(doors, &boot)
{
	boot = doors >> 8 & 7;
}

stock CPS_StoreCorpseInVehicle(playerid, const corpseid, const vehicleid)
{

	// tu sme

    if(GetPVarInt(playerid, PVAR_IS_DRAGGING) != 1)
	    return 0;

	new
	    lMax = CPS_GetVehicleMaxBodyCount(vehicleid),
	    lOccupied = CPS_GetVehicleBodyCount(vehicleid),
		lFree = (lMax - lOccupied)
	;
	
	if(lFree < 1)
	    return 0; // neni volny slot na teda mrtvolu
	    
	CPS_E_corpse[corpseid][CPS_E_vehicleId]         = vehicleid;
	CPS_E_corpse[corpseid][CPS_E_isBeingDragged] 	= 0;
	
	DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, PVAR_HEADLABEL));
	
	if(CPS_E_corpse[corpseid][CPS_E_fireObject] != -1)
        DestroyDynamicObject(CPS_E_corpse[corpseid][CPS_E_fireObject]);
        
	if(CPS_E_corpse[corpseid][CPS_E_bodyBag] > -1)
	{
	    DestroyDynamicObject(CPS_E_corpse[corpseid][CPS_E_bodyBag]),
	    CPS_E_corpse[corpseid][CPS_E_bodyBag] = (CPS_VALID_BODYBAG);
	}
	else
	    DestroyDynamicActor(CPS_E_corpse[corpseid][CPS_E_actorId]);
        
	// tu vycentrujem "telo" aby sa k nemu nikto nedostal
    CPS_E_corpse[corpseid][CPS_E_posX]              = 0.0;
    CPS_E_corpse[corpseid][CPS_E_posY]              = 0.0;
    CPS_E_corpse[corpseid][CPS_E_posZ]              = -500.0;
	
	stop Timer:GetPVarInt(playerid, PVAR_TIMER);
	stop CPS_E_corpse[corpseid][CPS_E_animTimerId];
	
	DeletePVar(playerid, PVAR_IS_DRAGGING);
	DeletePVar(playerid, PVAR_IS_DRAGGING_ID);
	DeletePVar(playerid, PVAR_TIMER);
	DeletePVar(playerid, PVAR_HEADLABEL);
	
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 2.0, 0, 0, 0, 0, 0);
	
	new
	    lString[144]
	;
	
	format(lString, sizeof lString, CPS_STORE_SUCCESS, CPS_GetVehicleName(vehicleid), lOccupied + 1, lMax);
	SendClientMessage(playerid, 0xD0D0D0FF, lString);
	
	CPS_Create3DTextLabelVehicle(corpseid);
	
	return 1;

}

public CPS_OnVehicleBootStatusUpdate(vehicleid, oldboot, boot)
{

    switch(GetVehicleModel(vehicleid))
	{
		case 422, 478, 535, 554, 600:
		    return 0;
	}
	
	if(oldboot == boot)
	    return 0;

	if(boot == 1)
	{
	    foreach (new x : Corpse)
		{
		    if(CPS_E_corpse[x][CPS_E_vehicleId] != vehicleid)
		        continue;

			CPS_Create3DTextLabelVehicle(x);
		}
	}
	else
	{
	    foreach (new x : Corpse)
		{
		    if(CPS_E_corpse[x][CPS_E_vehicleId] != vehicleid)
		        continue;

			DestroyDynamic3DTextLabel(CPS_E_corpse[x][CPS_E_labelId]);
		}
	}
	
	return 1;

}

stock CPS_GetVehicleBodyCount(const vehicleid)
{

	new
	    bc = 0
	;
	
	foreach (new x : Corpse)
	{
	    if(CPS_E_corpse[x][CPS_E_vehicleId] != vehicleid)
	        continue;
	        
		bc ++;
	}

	return bc;
}

stock CPS_GetVehicleMaxBodyCount(const vehicleid)
{

	new
	    bc = 0,
	    modelid = GetVehicleModel(vehicleid)
	;
	
	for( new x, y = sizeof A_CPS_vehicleCorpseSlots; x < y; x++)
	{
	    if(A_CPS_vehicleCorpseSlots[x][0] != modelid)
	        continue;
	    
	    bc = A_CPS_vehicleCorpseSlots[x][1];
	    break;
	}

	return bc;
}

stock CPS_CreateCorpse(playerid)
{

	new
	    id = Iter_Free(Corpse)
	;


	if( id == -1 )
	{
	    return (CPS_INVALID_CORPSE_ID);
	}

	Iter_Add(Corpse, id);

	// magia
    
    format(CPS_E_corpse[id][CPS_E_name], MAX_PLAYER_NAME + 1, CPS_ReturnRoleplayName(playerid));

	GetPlayerPos(playerid, CPS_E_corpse[id][CPS_E_posX], CPS_E_corpse[id][CPS_E_posY], CPS_E_corpse[id][CPS_E_posZ]);
	GetPlayerFacingAngle(playerid, CPS_E_corpse[id][CPS_E_posA]);
	CPS_E_corpse[id][CPS_E_virtualWorld]            = GetPlayerVirtualWorld(playerid);
	CPS_E_corpse[id][CPS_E_interiorId]            	= GetPlayerInterior(playerid);

	CPS_E_corpse[id][CPS_E_skinId]                  = CPS_GetPlayerSkin(playerid);
	CPS_E_corpse[id][CPS_E_timestampCreated]        = gettime();
	CPS_E_corpse[id][CPS_E_fireObject]          	= (-1);
	CPS_E_corpse[id][CPS_E_bodyBag]          		= (-1);
	
	CPS_E_corpse[id][CPS_E_stadium]                 = CPS_STADIUM_CERSTVA;

	CPS_E_corpse[id][CPS_E_actorId]                 = CreateDynamicActor(
																		CPS_E_corpse[id][CPS_E_skinId],
																		CPS_E_corpse[id][CPS_E_posX], CPS_E_corpse[id][CPS_E_posY], CPS_E_corpse[id][CPS_E_posZ],
																		CPS_E_corpse[id][CPS_E_posA],
																		1, 100.0,
																		CPS_E_corpse[id][CPS_E_virtualWorld], CPS_E_corpse[id][CPS_E_interiorId],
																		-1,
																		CPS_ACTOR_STREAM_DISTANCE, -1, CPS_ACTOR_STREAM_PRIORITY
	);
	
	CPS_E_corpse[id][CPS_E_labelId]                 = CreateDynamic3DTextLabel(
																		"_",
																		CPS_LABEL_COLOR,
																		CPS_E_corpse[id][CPS_E_posX], CPS_E_corpse[id][CPS_E_posY], CPS_E_corpse[id][CPS_E_posZ] - 0.3,
																		CPS_LABEL_DRAW_DISTANCE,
																		INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1,
																		CPS_E_corpse[id][CPS_E_virtualWorld], CPS_E_corpse[id][CPS_E_interiorId],
																		-1, CPS_LABEL_STREAM_DISTANCE, -1, CPS_LABEL_STREAM_PRIORITY
	);

	ApplyDynamicActorAnimation(CPS_E_corpse[id][CPS_E_actorId], "PED", "FLOOR_HIT_F", 4.1, false, true, true, true, 0);
	
	CPS_E_corpse[id][CPS_E_animTimerId] 			= repeat CPSapplyanim(id);

	CPS_Refresh3DTextLabelText(id);
	// koniec magie
	
	// magia damage-u
	
	new
	    cur,
	    curex
	;
	
	foreach( new x : CPS_PlayerDamage[playerid] )
	{
	    
	    cur = Iter_Alloc(CPS_CorpseDamage[id]);
	    curex = x;
	    
	    CPS_corpseDamage[id][cur][0]            = CPS_playerDamage[playerid][x][0];
	    CPS_corpseDamage[id][cur][1]            = CPS_playerDamage[playerid][x][1];
	    
	    CPS_playerDamage[playerid][x][0]        = 0;
	    CPS_playerDamage[playerid][x][1]        = 0;
	    
	    Iter_SafeRemove(CPS_PlayerDamage[playerid], curex, x);
	    
	}
	// konec damageu

	return id;
}

stock CPS_CreateCorpseEx(model, Float:pX, Float:pY, Float:pZ, Float:pA, name[] = "", virtualWorld = 0, interiorId = 0)
{

	new
	    id = Iter_Free(Corpse)
	;


	if( id == -1 )
	    return (CPS_INVALID_CORPSE_ID);

	Iter_Add(Corpse, id);

	// magia
	
	format(CPS_E_corpse[id][CPS_E_name], MAX_PLAYER_NAME + 1, name);
	
	CPS_E_corpse[id][CPS_E_posX] 					= pX;
	CPS_E_corpse[id][CPS_E_posY] 					= pY;
	CPS_E_corpse[id][CPS_E_posZ] 					= pZ;
	CPS_E_corpse[id][CPS_E_posA] 					= pA;
	CPS_E_corpse[id][CPS_E_virtualWorld]            = virtualWorld;
    CPS_E_corpse[id][CPS_E_interiorId]            	= interiorId;
	CPS_E_corpse[id][CPS_E_skinId]                  = model;
	CPS_E_corpse[id][CPS_E_timestampCreated]        = gettime();
	CPS_E_corpse[id][CPS_E_stadium]                 = CPS_STADIUM_CERSTVA;
	CPS_E_corpse[id][CPS_E_fireObject]          	= (-1);
	CPS_E_corpse[id][CPS_E_bodyBag]          		= (-1);

	CPS_E_corpse[id][CPS_E_actorId]                 = CreateDynamicActor(
																		CPS_E_corpse[id][CPS_E_skinId],
																		CPS_E_corpse[id][CPS_E_posX], CPS_E_corpse[id][CPS_E_posY], CPS_E_corpse[id][CPS_E_posZ],
																		CPS_E_corpse[id][CPS_E_posA],
																		1, 100.0,
																		CPS_E_corpse[id][CPS_E_virtualWorld], CPS_E_corpse[id][CPS_E_interiorId],
																		-1,
																		CPS_ACTOR_STREAM_DISTANCE, -1, CPS_ACTOR_STREAM_PRIORITY
	);

	CPS_E_corpse[id][CPS_E_labelId]                 = CreateDynamic3DTextLabel(
																		"_",
																		CPS_LABEL_COLOR,
																		CPS_E_corpse[id][CPS_E_posX], CPS_E_corpse[id][CPS_E_posY], CPS_E_corpse[id][CPS_E_posZ] - 0.3,
																		CPS_LABEL_DRAW_DISTANCE,
																		INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1,
																		CPS_E_corpse[id][CPS_E_virtualWorld], CPS_E_corpse[id][CPS_E_interiorId],
																		-1, CPS_LABEL_STREAM_DISTANCE, -1, CPS_LABEL_STREAM_PRIORITY
	);

	ApplyDynamicActorAnimation(CPS_E_corpse[id][CPS_E_actorId], "PED", "FLOOR_HIT_F", 4.1, false, true, true, true, 0);
	
	CPS_E_corpse[id][CPS_E_animTimerId] 			= repeat CPSapplyanim(id);

    CPS_Refresh3DTextLabelText(id);
	// koniec magie

	return id;
}

stock CPS_Create3DTextLabelVehicle(id)
{
	if(!Iter_Contains(Corpse, id))
	    return 0;
	    
 	if(CPS_E_corpse[id][CPS_E_vehicleId] < 1)
	    return 0;

    new
	    lLabelString[ CPS_LABEL_STRING_SIZE ],
	    firstName[ MAX_PLAYER_NAME + 1 ],
	    
	    Float:vX,
	    Float:vY,
	    Float:vZ
	;
	
	CPS_GetVehicleBootOffsetEx(CPS_E_corpse[id][CPS_E_vehicleId], vX, vY, vZ);

	strcat(firstName, CPS_E_corpse[id][CPS_E_name]);
	strdel(firstName, strfind(firstName," ",true), MAX_PLAYER_NAME+1);

	switch(CPS_E_corpse[id][CPS_E_stadium])
	{

	    case CPS_STADIUM_CERSTVA:
	        format(
				lLabelString, sizeof lLabelString,
				"(( Mrtvola hr·Ëe %s ))\n(( Pro interakci s tÏlem pouûij /mrtvola ))\n{eeeeee}** TÏlo je ËerstvÈ, jeöte je teplÈ. **",
				CPS_E_corpse[id][CPS_E_name]
			);

        case CPS_STADIUM_STUDENA:
	        format(
				lLabelString, sizeof lLabelString,
				"(( Mrtvola hr·Ëe %s ))\n(( Pro interakci s tÏlem pouûij /mrtvola ))\n{c7eee9}** TÏlo je ËerstvÈ, uû vychladlo. **",
				CPS_E_corpse[id][CPS_E_name]
			);

        case CPS_STADIUM_ROZKLAD_I:
	        format(
				lLabelString, sizeof lLabelString,
				"(( Mrtvola hr·Ëe %s ))\n(( Pro interakci s tÏlem pouûij /mrtvola ))\n{e1c9c9}** TÏlo je studenÈ a zaËÌn· zap·chat. **",
				CPS_E_corpse[id][CPS_E_name]
			);

        case CPS_STADIUM_ROZKLAD_II:
	        format(
				lLabelString, sizeof lLabelString,
				"(( Mrtvola hr·Ëe %s ))\n(( Pro interakci s tÏlem pouûij /mrtvola ))\n{dfb7b7}** TÏlo je v zaË·teËnÈm st·diu rozkladu, zap·ch·. **",
				CPS_E_corpse[id][CPS_E_name]
			);

        case CPS_STADIUM_ROZKLAD_III:
	        format(
				lLabelString, sizeof lLabelString,
				"(( Mrtvola hr·Ëe %s ??? ))\n(( Pro interakci s tÏlem pouûij /mrtvola ))\n{df9999}** TÏlo je ve znaËnÈm st·diu rozkladu, silnÏ zap·ch· a kolem tÏla lÌt· hmyz. **",
				firstName
			);

		case CPS_STADIUM_ROZKLAD_IV:
	        format(
				lLabelString, sizeof lLabelString,
				"(( Nezn·m· mrtvola ))\n(( Pro interakci s tÏlem pouûij /mrtvola ))\n{d26b6b}** TÏlo je rozloûeno, zap·ch· a lÌtajÌ okolo nÏj mouchy. **"
			);

        case CPS_STADIUM_OBHORENA:
	        format(
				lLabelString, sizeof lLabelString,
				"(( Oho¯el· mrtvola ))\n(( Pro interakci s tÏlem pouûij /mrtvola ))\n{8d8d8d}** TÏlo je oho¯elÈ, je ËernÈ a smrdÌ jak sp·lenÈ maso. **"
			);

        case CPS_STADIUM_HORI:
	        format(
				lLabelString, sizeof lLabelString,
				"(( Ho¯ÌcÌ mrtvola ))\n(( Pro interakci s tÏlem pouûij /mrtvola ))\n{8d8d8d}** TÏlo ho¯Ì, jde z nÏj Ëern˝ d˝m a smrdÌ jak sp·lenÈ maso. **"
			);
	}

	CPS_E_corpse[id][CPS_E_labelId]						= CreateDynamic3DTextLabel(
																		"** V kufru/na korbÏ je mrtvÈ tÏlo **",
																		CPS_LABEL_COLOR,
																		vX, vY, vZ,
																		7.0,
																		INVALID_PLAYER_ID, CPS_E_corpse[id][CPS_E_vehicleId], 1,
																		-1, -1,
																		-1, CPS_LABEL_STREAM_DISTANCE, -1, CPS_LABEL_STREAM_PRIORITY
	);

	return 1;
}

stock CPS_Refresh3DTextLabelText(id)
{
	if(!Iter_Contains(Corpse, id))
	    return 0;
	    
    if(CPS_E_corpse[id][CPS_E_isBeingDragged] == 1)
	    return 0;
	    
	new
	    lLabelString[ CPS_LABEL_STRING_SIZE ]
	;

	if(CPS_E_corpse[id][CPS_E_bodyBag] == (-1))
	{
	    new
		    firstName[ MAX_PLAYER_NAME + 1 ]
		;

		strcat(firstName, CPS_E_corpse[id][CPS_E_name]);
		strdel(firstName, strfind(firstName," ",true), MAX_PLAYER_NAME+1);

		switch(CPS_E_corpse[id][CPS_E_stadium])
		{

		    case CPS_STADIUM_CERSTVA:
		        format(
					lLabelString, sizeof lLabelString,
					"(( Mrtvola hr·Ëe %s ))\n(( Pro interakci s tÏlem pouûij /mrtvola ))\n{eeeeee}** TÏlo je ËerstvÈ, jeöte je teplÈ. **",
					CPS_E_corpse[id][CPS_E_name]
				);

	        case CPS_STADIUM_STUDENA:
		        format(
					lLabelString, sizeof lLabelString,
					"(( Mrtvola hr·Ëe %s ))\n(( Pro interakci s tÏlem pouûij /mrtvola ))\n{c7eee9}** TÏlo je ËerstvÈ, uû vychladlo. **",
					CPS_E_corpse[id][CPS_E_name]
				);

	        case CPS_STADIUM_ROZKLAD_I:
		        format(
					lLabelString, sizeof lLabelString,
					"(( Mrtvola hr·Ëe %s ))\n(( Pro interakci s tÏlem pouûij /mrtvola ))\n{e1c9c9}** TÏlo je studenÈ a zaËÌn· zap·chat. **",
					CPS_E_corpse[id][CPS_E_name]
				);

	        case CPS_STADIUM_ROZKLAD_II:
		        format(
					lLabelString, sizeof lLabelString,
					"(( Mrtvola hr·Ëe %s ))\n(( Pro interakci s tÏlem pouûij /mrtvola ))\n{dfb7b7}** TÏlo je v zaË·teËnÈm st·diu rozkladu, zap·ch·. **",
					CPS_E_corpse[id][CPS_E_name]
				);

	        case CPS_STADIUM_ROZKLAD_III:
		        format(
					lLabelString, sizeof lLabelString,
					"(( Mrtvola hr·Ëe %s ??? ))\n(( Pro interakci s tÏlem pouûij /mrtvola ))\n{df9999}** TÏlo je ve znaËnÈm st·diu rozkladu, silnÏ zap·ch· a kolem tÏla lÌt· hmyz. **",
					firstName
				);

			case CPS_STADIUM_ROZKLAD_IV:
		        format(
					lLabelString, sizeof lLabelString,
					"(( Nezn·m· mrtvola ))\n(( Pro interakci s tÏlem pouûij /mrtvola ))\n{d26b6b}** TÏlo je rozloûeno, zap·ch· a lÌtajÌ okolo nÏj mouchy. **"
				);

	        case CPS_STADIUM_OBHORENA:
		        format(
					lLabelString, sizeof lLabelString,
					"(( Oho¯el· mrtvola ))\n(( Pro interakci s tÏlem pouûij /mrtvola ))\n{8d8d8d}** TÏlo je oho¯elÈ, je ËernÈ a smrdÌ jak sp·lenÈ maso. **"
				);

	        case CPS_STADIUM_HORI:
		        format(
					lLabelString, sizeof lLabelString,
					"(( Ho¯ÌcÌ mrtvola ))\n(( Pro interakci s tÏlem pouûij /mrtvola ))\n{8d8d8d}** TÏlo ho¯Ì, jde z nÏj Ëern˝ d˝m a smrdÌ jak sp·lenÈ maso. **"
				);
		}
	}
	else
	    strcat(lLabelString, "(( TÏlo v pytli na mrtvoly ))\n(( Pro interakci s tÏlem pouûij /mrtvola ))");

	UpdateDynamic3DTextLabelText(CPS_E_corpse[id][CPS_E_labelId], CPS_LABEL_COLOR, lLabelString);

	return 1;
}

stock CPS_DestroyCorpse(const id)
{

	if(!Iter_Contains(Corpse, id))
	    return CPS_INVALID_CORPSE_ID;
	    
	// position
    CPS_E_corpse[id][CPS_E_posX]                  	= (0.0);
    CPS_E_corpse[id][CPS_E_posY]                  	= (0.0);
    CPS_E_corpse[id][CPS_E_posZ]                  	= (0.0);
    CPS_E_corpse[id][CPS_E_posA]                  	= (0.0);
    CPS_E_corpse[id][CPS_E_virtualWorld]            = (0);
    CPS_E_corpse[id][CPS_E_interiorId]              = (0);
    
    // data
    CPS_E_corpse[id][CPS_E_name][0]                 = EOS;
    CPS_E_corpse[id][CPS_E_skinId]                  = (0);
    
    if(CPS_E_corpse[id][CPS_E_bodyBag] > -1)
        DestroyDynamicObject(CPS_E_corpse[id][CPS_E_bodyBag]);
    else
		DestroyDynamicActor(CPS_E_corpse[id][CPS_E_actorId]);
		
	DestroyDynamic3DTextLabel(CPS_E_corpse[id][CPS_E_labelId]);
	
	if(CPS_E_corpse[id][CPS_E_isBurning] == 1)
	{
	    DestroyDynamicObject(CPS_E_corpse[id][CPS_E_fireObject]);
	    stop CPS_E_corpse[id][CPS_E_burnTimer];
	}
	else if(CPS_E_corpse[id][CPS_E_fireObject] != -1)
        DestroyDynamicObject(CPS_E_corpse[id][CPS_E_fireObject]);
	
	CPS_E_corpse[id][CPS_E_fireObject] = (-1);
	
	// timers
	stop CPS_E_corpse[id][CPS_E_animTimerId];
	
	new tmp;
	
	Iter_SafeRemove(Corpse, id, tmp);
        
	return 1;
}

stock CPS_GetNearestCorpse(playerid, const Float:maxdist)
{

	new
	    lastId = CPS_INVALID_CORPSE_ID,
	    Float:olddist = maxdist,
	    Float:tempdist,
	    
	    Float:pX,
	    Float:pY,
	    Float:pZ
	;
	
	GetPlayerPos(playerid, pX, pY, pZ);

	foreach( new id : Corpse)
	{
	
	    if(GetPlayerInterior(playerid) != CPS_E_corpse[id][CPS_E_interiorId])
	        continue;
	        
        if(GetPlayerVirtualWorld(playerid) != CPS_E_corpse[id][CPS_E_virtualWorld])
	        continue;
	        
		tempdist = CPS_GetDistanceBetweenPoints(pX, pY, pZ, CPS_E_corpse[id][CPS_E_posX], CPS_E_corpse[id][CPS_E_posY], CPS_E_corpse[id][CPS_E_posZ]);
	        
		if(floatcmp(tempdist, olddist) >= 0)
			continue;
			
		olddist = tempdist;
		lastId = id;
	
	}
	
	return lastId;
}

stock CPS_SetCorpseName(id, name[])
{

	if(!Iter_Contains(Corpse, id))
	    return 0;

    format(CPS_E_corpse[id][CPS_E_name], MAX_PLAYER_NAME + 1, name);
	CPS_Refresh3DTextLabelText(id);

	return 1;
}

stock CPS_SetCorpseStadium(id, stadium)
{

	if(!Iter_Contains(Corpse, id))
	    return 0;

    CPS_E_corpse[id][CPS_E_stadium] = Stadium:stadium;
	CPS_Refresh3DTextLabelText(id);

	return 1;
}

stock CPS_SetCorpseAngle(id, Float:angle)
{

	if(!Iter_Contains(Corpse, id))
	    return 0;

    CPS_E_corpse[id][CPS_E_posA]        	= angle;
    SetDynamicActorFacingAngle(CPS_E_corpse[id][CPS_E_actorId], angle);

	return 1;
}

stock CPS_SetCorpseSkin(id, skin)
{

	if(!Iter_Contains(Corpse, id))
	    return 0;

    DestroyDynamicActor(CPS_E_corpse[id][CPS_E_actorId]);
    
    CPS_E_corpse[id][CPS_E_skinId]        			= skin;
    CPS_E_corpse[id][CPS_E_actorId]                 = CreateDynamicActor(
																		skin,
																		CPS_E_corpse[id][CPS_E_posX], CPS_E_corpse[id][CPS_E_posY], CPS_E_corpse[id][CPS_E_posZ],
																		CPS_E_corpse[id][CPS_E_posA],
																		1, 100.0,
																		CPS_E_corpse[id][CPS_E_virtualWorld], CPS_E_corpse[id][CPS_E_interiorId],
																		-1,
																		CPS_ACTOR_STREAM_DISTANCE, -1, CPS_ACTOR_STREAM_PRIORITY
	);

	if(CPS_E_corpse[id][CPS_E_otocena] == 0)
    	ApplyDynamicActorAnimation(CPS_E_corpse[id][CPS_E_actorId], "PED", "FLOOR_HIT_F", 4.1, false, true, true, true, 0);
	else
	    ApplyDynamicActorAnimation(CPS_E_corpse[id][CPS_E_actorId], "PED", "FLOOR_HIT", 4.1, false, true, true, true, 0);

	return 1;
}

stock CPS_GetPlayerSkin(playerid)
{

	new
	    lCskin = GetPlayerCustomSkin(playerid)
	;
	
	return (lCskin > 0) ? lCskin : GetPlayerSkin(playerid);
	
}

stock CPS_ReturnRoleplayName(playerid)
{

	new
		lName[ MAX_PLAYER_NAME + 1 ],
		fName[ MAX_PLAYER_NAME + 1 ]
	;
	
	GetPlayerName(playerid, lName, sizeof lName);
	strcat(fName, str_replace("_", " ", lName));

	return fName;
	
}

stock CPS_IsNumeric(string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
	{
		if (string[i] > '9' || string[i] < '0') return 0;
	}
	return 1;
}

stock CPS_StopPlayerDragCorpse(playerid)
{
	if(GetPVarInt(playerid, PVAR_IS_DRAGGING) != 1)
	    return 0;

    new
		id = GetPVarInt(playerid, PVAR_IS_DRAGGING_ID),
	    Float:pA
	;

	GetPlayerFacingAngle(playerid, pA);
	GetPlayerPos(playerid, CPS_E_corpse[id][CPS_E_posX], CPS_E_corpse[id][CPS_E_posY], CPS_E_corpse[id][CPS_E_posZ]);

	CPS_E_corpse[id][CPS_E_posX] -= (1.5 * floatsin(-pA, degrees));
	CPS_E_corpse[id][CPS_E_posY] -= (1.5 * floatcos(-pA, degrees));

	SetDynamicActorPos(CPS_E_corpse[id][CPS_E_actorId], CPS_E_corpse[id][CPS_E_posX], CPS_E_corpse[id][CPS_E_posY], CPS_E_corpse[id][CPS_E_posZ]);


	CPS_E_corpse[id][CPS_E_labelId]                 = CreateDynamic3DTextLabel(
																	"_",
																	CPS_LABEL_COLOR,
																	CPS_E_corpse[id][CPS_E_posX], CPS_E_corpse[id][CPS_E_posY], CPS_E_corpse[id][CPS_E_posZ] - 0.3,
																	CPS_LABEL_DRAW_DISTANCE,
																	INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1,
																	CPS_E_corpse[id][CPS_E_virtualWorld], CPS_E_corpse[id][CPS_E_interiorId],
																	-1, CPS_LABEL_STREAM_DISTANCE, -1, CPS_LABEL_STREAM_PRIORITY
	);
	
	DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, PVAR_HEADLABEL));

	stop Timer:GetPVarInt(playerid, PVAR_TIMER);

	CPS_E_corpse[id][CPS_E_isBeingDragged] = 0;

	DeletePVar(playerid, PVAR_IS_DRAGGING);
	DeletePVar(playerid, PVAR_IS_DRAGGING_ID);
	DeletePVar(playerid, PVAR_TIMER);
	DeletePVar(playerid, PVAR_HEADLABEL);

	ApplyAnimation(playerid, "CARRY", "crry_prtial", 2.0, 0, 0, 0, 0, 0);
	
	CPS_Refresh3DTextLabelText(id);
	
	return 1;
}
// koniec funkcii

// callbacky
forward corpse_OnPlayerDeath(playerid, killerid, reason);
public corpse_OnPlayerDeath(playerid, killerid, reason)
{

    CPS_StopPlayerDragCorpse(playerid);

	return 1;
}

forward corpse_OnPlayerDisconnect(playerid, reason);
public corpse_OnPlayerDisconnect(playerid, reason)
{
    CPS_StopPlayerDragCorpse(playerid);
    
    new
        cur
	;

    foreach ( new i : CPS_PlayerDamage[playerid] )
    {

        cur = i;

        CPS_playerDamage[playerid][i][0]                = 0;
        CPS_playerDamage[playerid][i][1]                = 1;
        Iter_SafeRemove(CPS_PlayerDamage[playerid], cur, i);

    }
    
	return 1;
}

forward corpse_OnPlayerStateChange(playerid, newstate, oldstate);
public corpse_OnPlayerStateChange(playerid, newstate, oldstate)
{
    CPS_StopPlayerDragCorpse(playerid);
	return 1;
}

new CPS_haspressed[MAX_PLAYERS];

forward corpse_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
public corpse_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{

	if(!IsPlayerInAnyVehicle(playerid) && (newkeys & KEY_JUMP || newkeys & KEY_FIRE || newkeys & KEY_HANDBRAKE || newkeys & KEY_SECONDARY_ATTACK || newkeys & KEY_CROUCH) && GetPVarInt(playerid, PVAR_IS_DRAGGING) == 1)
	{
	    SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_STOP_DRAG);
		CPS_StopPlayerDragCorpse(playerid);
	}
	else if(!IsPlayerInAnyVehicle(playerid) && ((newkeys & KEY_YES) && !(oldkeys & KEY_YES)) && GetPVarInt(playerid, PVAR_IS_DRAGGING) == 1)
	{
	
		if(CPS_haspressed[playerid] != 1)
		{
		
		    CPS_haspressed[playerid] = 1;
		    defer CPScanPressY(playerid);
		
		    new
				vehicleid = -1,
				Float:olddist = 2.5,
				Float:tmpdist,

				Float:pX,
				Float:pY,
				Float:pZ,

				Float:vX,
				Float:vY,
				Float:vZ
			;

			GetPlayerPos(playerid, pX, pY, pZ);

		    foreach(new x : Vehicle)
			{
			    CPS_GetVehicleBootOffset(x, vX, vY, vZ);
			    tmpdist = CPS_GetDistanceBetweenPoints(vX, vY, vZ, pX, pY, pZ);

			    if(floatcmp(tmpdist, olddist) >= 0)
			        continue;

				olddist = tmpdist;
				vehicleid = x;
			}

			if(vehicleid != -1)
			{
			    new
					lBoot,
					lUnused
				;

				GetVehicleParamsEx(vehicleid, lUnused, lUnused, lUnused, lUnused, lUnused, lBoot, lUnused);

				if(lBoot != 1)
				    SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_TRUNK_CLOSED);
    			else
					CPS_StoreCorpseInVehicle(playerid, GetPVarInt(playerid, PVAR_IS_DRAGGING_ID), vehicleid);
			}
		}
	}
	return 1;
}

forward corpse_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
public corpse_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    CPS_StopPlayerDragCorpse(playerid);
	return 1;
}

stock CPS_UnstoreCorpse(playerid, id)
{

	if(!Iter_Contains(Corpse, id))
	    return 0;
	    
	GetPlayerPos(playerid, CPS_E_corpse[id][CPS_E_posX], CPS_E_corpse[id][CPS_E_posY], CPS_E_corpse[id][CPS_E_posZ]);
	GetPlayerFacingAngle(playerid, CPS_E_corpse[id][CPS_E_posA]);
	CPS_E_corpse[id][CPS_E_virtualWorld] 	= GetPlayerVirtualWorld(playerid);
	CPS_E_corpse[id][CPS_E_interiorId] 		= GetPlayerInterior(playerid);
	
	CPS_E_corpse[id][CPS_E_posX] 			-= (1.5 * floatsin(-CPS_E_corpse[id][CPS_E_posA], degrees));
	CPS_E_corpse[id][CPS_E_posY] 			-= (1.5 * floatcos(-CPS_E_corpse[id][CPS_E_posA], degrees));
	
	if(CPS_E_corpse[id][CPS_E_bodyBag] == (CPS_VALID_BODYBAG))
	{
	    CPS_E_corpse[id][CPS_E_bodyBag]			=   CreateDynamicObject(
													CPS_BODY_BAG_OBJECT,
													CPS_E_corpse[id][CPS_E_posX], CPS_E_corpse[id][CPS_E_posY], CPS_E_corpse[id][CPS_E_posZ] - 0.95,
													0.0, 0.0, CPS_E_corpse[id][CPS_E_posA],
													CPS_E_corpse[id][CPS_E_virtualWorld], CPS_E_corpse[id][CPS_E_interiorId],
													-1, 300.0, 285.0, -1, 1
		);
	}
	else
	{
	    CPS_E_corpse[id][CPS_E_actorId]			= CreateDynamicActor(
													CPS_E_corpse[id][CPS_E_skinId],
													CPS_E_corpse[id][CPS_E_posX], CPS_E_corpse[id][CPS_E_posY], CPS_E_corpse[id][CPS_E_posZ],
													CPS_E_corpse[id][CPS_E_posA],
													1, 100.0,
													CPS_E_corpse[id][CPS_E_virtualWorld], CPS_E_corpse[id][CPS_E_interiorId],
													-1,
													CPS_ACTOR_STREAM_DISTANCE, -1, CPS_ACTOR_STREAM_PRIORITY
		);
	}
	
	DestroyDynamic3DTextLabel(CPS_E_corpse[id][CPS_E_labelId]);
	
	CPS_E_corpse[id][CPS_E_labelId]    		= CreateDynamic3DTextLabel(
												"_",
												CPS_LABEL_COLOR,
												CPS_E_corpse[id][CPS_E_posX], CPS_E_corpse[id][CPS_E_posY], CPS_E_corpse[id][CPS_E_posZ] - 0.3,
												CPS_LABEL_DRAW_DISTANCE,
												INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1,
												CPS_E_corpse[id][CPS_E_virtualWorld], CPS_E_corpse[id][CPS_E_interiorId],
												-1, CPS_LABEL_STREAM_DISTANCE, -1, CPS_LABEL_STREAM_PRIORITY
	);

	ApplyDynamicActorAnimation(CPS_E_corpse[id][CPS_E_actorId], "PED", "FLOOR_HIT_F", 4.1, false, true, true, true, 0);
	CPS_E_corpse[id][CPS_E_animTimerId] 	= repeat CPSapplyanim(id);
	
	new
	    lString[144]
	;

	format(lString, sizeof lString, CPS_UNSTORE_SUCCESS, CPS_GetVehicleName(CPS_E_corpse[id][CPS_E_vehicleId]));
	SendClientMessage(playerid, 0xD0D0D0FF, lString);
	
	CPS_E_corpse[id][CPS_E_vehicleId]      	= 0;
	
	CPS_Refresh3DTextLabelText(id);
	
	return 1;

}

forward corpse_OnDialogResponse(playerid, dialogid, response, listitem);
public corpse_OnDialogResponse(playerid, dialogid, response, listitem)
{
	switch(dialogid)
	{
	    case CPS_DIALOG:
	    {
	    
	        if( response == 0 )
	            return DeletePVar(playerid, PVAR_TEMP_VEHICLE), 0;
	            
			new
			    count = -1,
			    vehicleid = GetPVarInt(playerid, PVAR_TEMP_VEHICLE)
			;
			
			if(vehicleid == 0)
			    return 0;
			
			DeletePVar(playerid, PVAR_TEMP_VEHICLE);
			
			foreach ( new x : Corpse )
			{
			    if(vehicleid != CPS_E_corpse[x][CPS_E_vehicleId])
			        continue;
			        
				count ++;
				
				if(count != listitem)
				    continue;
				    
				CPS_UnstoreCorpse(playerid, x);
				return 1;
				
			}
	            
	        return 1;
	    }
	}
	return 0;
}

forward corpse_OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart);
public corpse_OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{

	if(weaponid >= 46)
	    return 0;

	new
	    arrayid = -1
	;
	
	arrayid = Iter_Alloc(CPS_PlayerDamage[playerid]);
	
	if(arrayid == -1)
		return 0;
	
	CPS_playerDamage[playerid][arrayid][0]      = weaponid; // wepid
    CPS_playerDamage[playerid][arrayid][1]      = bodypart; // bp

	return 0;
}

hook OnGameModeInit()
{

	Iter_Init(CPS_PlayerDamage);
	Iter_Init(CPS_CorpseDamage);

	return 1;
}
// koniec callbackov

// custom callbacky

// koniec custom callbackov

// timery
timer CPScanPressY[CPS_MAX_KEY_YES_PER_SEC](playerid)
{
	CPS_haspressed[playerid]=0;
	
	return 1;
}

timer CPSapplyanim[CPS_RESYNC_ANIM_TIMER](id)
{

	SetDynamicActorPos(CPS_E_corpse[id][CPS_E_actorId], CPS_E_corpse[id][CPS_E_posX], CPS_E_corpse[id][CPS_E_posY], CPS_E_corpse[id][CPS_E_posZ]);

    if(CPS_E_corpse[id][CPS_E_otocena] == 0)
    	ApplyDynamicActorAnimation(CPS_E_corpse[id][CPS_E_actorId], "PED", "FLOOR_HIT_F", 4.1, false, true, true, true, 0);
	else
	    ApplyDynamicActorAnimation(CPS_E_corpse[id][CPS_E_actorId], "PED", "FLOOR_HIT", 4.1, false, true, true, true, 0);
	
	switch(CPS_E_corpse[id][CPS_E_stadium])
	{
	    case CPS_STADIUM_CERSTVA:
	    {
	        if(floatround( (((gettime() - CPS_E_corpse[id][CPS_E_timestampCreated]) / 60) / 60), floatround_floor) >= 4)
	        {
	            CPS_E_corpse[id][CPS_E_stadium] = CPS_STADIUM_STUDENA;
	            CPS_Refresh3DTextLabelText(id);
	        }
	    }
	    
	    case CPS_STADIUM_STUDENA:
	    {
	        if(floatround( (((gettime() - CPS_E_corpse[id][CPS_E_timestampCreated]) / 60) / 60), floatround_floor) >= 10)
	        {
	            CPS_E_corpse[id][CPS_E_stadium] = CPS_STADIUM_ROZKLAD_I;
	            CPS_Refresh3DTextLabelText(id);
	        }
	    }
	    
	    case CPS_STADIUM_ROZKLAD_I:
	    {
	        if(floatround(( ((gettime() - CPS_E_corpse[id][CPS_E_timestampCreated]) / 60) / 60), floatround_floor) >= 16)
	        {
	            CPS_E_corpse[id][CPS_E_stadium] = CPS_STADIUM_ROZKLAD_II;
	            CPS_Refresh3DTextLabelText(id);
	        }
	    }
	    
	    case CPS_STADIUM_ROZKLAD_II:
	    {
	        if(floatround((((gettime() - CPS_E_corpse[id][CPS_E_timestampCreated]) / 60) / 60), floatround_floor) >= 24)
	        {
	            CPS_E_corpse[id][CPS_E_stadium] = CPS_STADIUM_ROZKLAD_III;
	            CPS_Refresh3DTextLabelText(id);
	        }
	    }
	    
	    case CPS_STADIUM_ROZKLAD_III:
	    {
	        if(floatround((((gettime() - CPS_E_corpse[id][CPS_E_timestampCreated]) / 60) / 60), floatround_floor) >= 38)
	        {
	            CPS_E_corpse[id][CPS_E_stadium] = CPS_STADIUM_ROZKLAD_IV;
	            CPS_Refresh3DTextLabelText(id);
	        }
	    }
	}
	    
	return 1;
}

timer CPSdragcorpse[CPS_DRAG_CORPSE_TIMER](playerid, id)
{
	
	new
	    Float:pA
	;
	
	GetPlayerFacingAngle(playerid, pA);
	GetPlayerPos(playerid, CPS_E_corpse[id][CPS_E_posX], CPS_E_corpse[id][CPS_E_posY], CPS_E_corpse[id][CPS_E_posZ]);
	
	CPS_E_corpse[id][CPS_E_posX] -= (1.5 * floatsin(-pA, degrees));
	CPS_E_corpse[id][CPS_E_posY] -= (1.5 * floatcos(-pA, degrees));
	
	if(CPS_E_corpse[id][CPS_E_bodyBag] == -1)
		SetDynamicActorPos(CPS_E_corpse[id][CPS_E_actorId], CPS_E_corpse[id][CPS_E_posX], CPS_E_corpse[id][CPS_E_posY], CPS_E_corpse[id][CPS_E_posZ]);
	else
	    SetDynamicObjectPos(CPS_E_corpse[id][CPS_E_bodyBag], CPS_E_corpse[id][CPS_E_posX], CPS_E_corpse[id][CPS_E_posY], CPS_E_corpse[id][CPS_E_posZ] - 0.95);
	    
	ApplyAnimation(playerid,"PED","WALK_fatold",4.1,1,1,1,1,1,1);
	
	if(CPS_E_corpse[id][CPS_E_fireObject] != -1)
        SetDynamicObjectPos(CPS_E_corpse[id][CPS_E_fireObject], CPS_E_corpse[id][CPS_E_posX], CPS_E_corpse[id][CPS_E_posY], CPS_E_corpse[id][CPS_E_posZ]);

	return 1;
}

timer CPSburntimer[(1000 * 60 * 10) + (1000 * 60 * random(45))](id) // od 10 do 55 minut
{
	if(!Iter_Contains(Corpse, id))
	    return 0;
	    
	if(CPS_E_corpse[id][CPS_E_isBurning] == 0)
	    return 0;
	    
    CPS_E_corpse[id][CPS_E_isBurning]           = 0;
    DestroyDynamicObject(CPS_E_corpse[id][CPS_E_fireObject]);
    
    CPS_E_corpse[id][CPS_E_fireObject] 			= -1;
    CPS_E_corpse[id][CPS_E_stadium] 			= CPS_STADIUM_OBHORENA;
    
    CPS_Refresh3DTextLabelText(id);

	return 1;
}
// koniec timerov

CMD:mrtvola(playerid, params[])
{
    new
        lPar1[ 12 ],
        lPar2[ 12 ],
        lPar3[ MAX_PLAYER_NAME + 1 ]
	;
	
	if(sscanf(params, "s[12] S()[12] S()[24]", lPar1, lPar2, lPar3))
	{
	    if( CPS_HasPlayerAdminRights(playerid) )
            return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_SYNTAX_ADMIN);
		else
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_SYNTAX);
	}
	
	if(!strcmp( lPar1, "vytvorit", true ))
	{
	    // chce to vytvorit
		if( !CPS_HasPlayerAdminRights(playerid) )
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_PERM);
		    
		if(sscanf(params, "s[12] s[12] s[24]", lPar1, lPar2, lPar3))
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_SYNTAX_ADMIN_VYTVORIT);
		    
		new
		    lSkin = strval(lPar2)
		;
		    
		if(!CPS_IsNumeric(lPar2) || (lSkin < 0) || (lSkin > 311 && lSkin < 20000) || (lSkin > 29999))
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_BAD_SKIN_ID);
		    
		new
		    Float:pX,
		    Float:pY,
		    Float:pZ,
			Float:pA
		;
		
		GetPlayerPos(playerid, pX, pY, pZ);
		GetPlayerFacingAngle(playerid, pA);
		
		CPS_CreateCorpseEx(lSkin, pX, pY, pZ, pA, lPar3, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
		
		SetPlayerPos(playerid, pX + (1.0 * floatsin(-pA, degrees)), pY + (1.0 * floatcos(-pA, degrees)), pZ);
		
		SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_CORPSE_CREATED);
		
	}
	else if(!strcmp( lPar1, "zmazat", true ))
	{
	    // chce to smazat
		if( !CPS_HasPlayerAdminRights(playerid) && GetPlayerFaction(playerid) != FACTION_TYPE_FIRE )
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_PERM);
		    
		if( !CPS_HasPlayerAdminRights(playerid) && !IsPlayerWorking(playerid))
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_PERM);

		new
		    id = CPS_GetNearestCorpse(playerid, 5.0)
		;

		if( id == CPS_INVALID_CORPSE_ID )
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_NEARBY_CORPSE);
		    
        if( CPS_E_corpse[id][CPS_E_isBeingDragged] == 1 )
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_EDITING_DRAGGED);

		CPS_DestroyCorpse(id);

		SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_CORPSE_DELETED);
	}
	if(!strcmp( lPar1, "zmazatvsetky", true ))
	{
	    // chce to smazat
		if( !CPS_HasPlayerAdminRights(playerid) )
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_PERM);

		foreach (new id : Corpse)
		{
		    if(CPS_E_corpse[id][CPS_E_isBeingDragged] == 1)
		        continue;
		        
			CPS_DestroyCorpse(id);
		}

		SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_CORPSE_DELETED_ALL);
	}
	else if(!strcmp( lPar1, "upravit", true ))
	{
	    // chce to vytvorit
		if( !CPS_HasPlayerAdminRights(playerid) )
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_PERM);

		if(sscanf(params, "s[12] s[12] s[25]", lPar1, lPar2, lPar3))
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_SYNTAX_ADMIN_UPRAVIT);

		if(!strcmp(lPar2, "jmeno", true))
		{
		    new
			    id = CPS_GetNearestCorpse(playerid, 5.0)
			;

			if( id == CPS_INVALID_CORPSE_ID )
			    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_NEARBY_CORPSE);
			    
            if( CPS_E_corpse[id][CPS_E_isBeingDragged] == 1 )
		    	return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_EDITING_DRAGGED);

			CPS_SetCorpseName(id, lPar3);

			SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_CORPSE_RENAMED);
		}
		else if(!strcmp(lPar2, "rotacia", true))
		{
		    new
			    id = CPS_GetNearestCorpse(playerid, 5.0),
			    Float:lAngle = floatstr(lPar3)
			;

			if( id == CPS_INVALID_CORPSE_ID )
			    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_NEARBY_CORPSE);
			    
            if( CPS_E_corpse[id][CPS_E_isBeingDragged] == 1 )
		    	return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_EDITING_DRAGGED);

			if((lAngle < 0.0) || (lAngle > 359.9))
			    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_BAD_ANGLE);

			CPS_SetCorpseAngle(id, lAngle);

			SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_CORPSE_REANGLED);
		}
		else if(!strcmp(lPar2, "skin", true))
		{
		    new
			    id = CPS_GetNearestCorpse(playerid, 5.0),
			    lSkin = strval(lPar3)
			;

			if( id == CPS_INVALID_CORPSE_ID )
			    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_NEARBY_CORPSE);

            if( CPS_E_corpse[id][CPS_E_isBeingDragged] == 1 )
		    	return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_EDITING_DRAGGED);

			if(!CPS_IsNumeric(lPar3) || (lSkin < 0) || (lSkin > 311 && lSkin < 20000) || (lSkin > 29999))
			    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_BAD_SKIN_ID);

			CPS_SetCorpseSkin(id, lSkin);

			SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_CORPSE_RESKINED);
		}
		else if(!strcmp(lPar2, "stadium", true))
		{
		    new
			    id = CPS_GetNearestCorpse(playerid, 5.0),
			    lStadium = strval(lPar3)
			;

			if( id == CPS_INVALID_CORPSE_ID )
			    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_NEARBY_CORPSE);

            if( CPS_E_corpse[id][CPS_E_isBeingDragged] == 1 )
		    	return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_EDITING_DRAGGED);

			if(!CPS_IsNumeric(lPar3) || (lStadium < 1) || (lStadium > 8))
			    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_BAD_STADIUM);

			CPS_SetCorpseStadium(id, lStadium-1);

			SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_CORPSE_RESTADIED);
		}
		else
            return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_SYNTAX_ADMIN_UPRAVIT);
            
	}
	else if(!strcmp( lPar1, "info", true ))
	{
	    // chce to smazat
		if( !CPS_HasPlayerAdminRights(playerid) )
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_PERM);

		new
		    id = CPS_GetNearestCorpse(playerid, 5.0)
		;

		if( id == CPS_INVALID_CORPSE_ID )
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_NEARBY_CORPSE);
		    
		new
		    lString[ 128 ]
		;
		
		format(lString, sizeof lString, "|---------------- M‡tvola hr·Ëa %s (id m‡tvoly: %d) ----------------|", CPS_E_corpse[id][CPS_E_name], id);
		SendClientMessage(playerid, 0xD0D0D0, lString);
		
		format(lString, sizeof lString, "| Skin: %d", CPS_E_corpse[id][CPS_E_skinId]);
		SendClientMessage(playerid, 0xD0D0D0, lString);
		
		format(lString, sizeof lString, "| Vytvoren· pred: %d min˙tami", floatround((gettime() - CPS_E_corpse[id][CPS_E_timestampCreated]) / 60, floatround_ceil));
		SendClientMessage(playerid, 0xD0D0D0, lString);
	}
	/* PRIKAZY PRE HRACOV */
	else if(!strcmp ( lPar1, "otocit", true ))
	{
	
	    new
		    id = CPS_GetNearestCorpse(playerid, 5.0)
		;

		if( id == CPS_INVALID_CORPSE_ID )
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_NEARBY_CORPSE);
		    
		if( CPS_E_corpse[id][CPS_E_isBeingDragged] == 1 )
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_EDITING_DRAGGED);
		    
        if( CPS_E_corpse[id][CPS_E_isBurning] == 1 )
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_EDITING_BURNING);

		CPS_E_corpse[id][CPS_E_otocena] = !CPS_E_corpse[id][CPS_E_otocena];
		CPS_SetCorpseAngle(id, CPS_E_corpse[id][CPS_E_posA] + 180.0);
		CPSapplyanim(id);

		SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_OTOCENA);
	}
	else if(!strcmp ( lPar1, "tahat", true ))
	{
	    new
		    id = CPS_GetNearestCorpse(playerid, 3.0)
		;

		if( id == CPS_INVALID_CORPSE_ID )
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_NEARBY_CORPSE);

        if( CPS_E_corpse[id][CPS_E_isBeingDragged] == 1 )
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_EDITING_DRAGGED);
		    
        if( CPS_E_corpse[id][CPS_E_isBurning] == 1 )
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_EDITING_BURNING);

		CPS_E_corpse[id][CPS_E_isBeingDragged] = 1;
		ApplyAnimation(playerid,"PED","WALK_fatold",4.1,1,1,1,1,1,1);

		SetPVarInt(playerid, PVAR_IS_DRAGGING, 1);
		SetPVarInt(playerid, PVAR_IS_DRAGGING_ID, id);
		SetPVarInt(playerid, PVAR_TIMER, _:repeat CPSdragcorpse(playerid, id));

		DestroyDynamic3DTextLabel(CPS_E_corpse[id][CPS_E_labelId]);

		SetPVarInt(playerid, PVAR_HEADLABEL, _:CreateDynamic3DTextLabel(CPS_HEAD_LABEL_DRAGGING, CPS_HEAD_LABEL_COLOR, 0.0, 0.0, 0.5, 10.0, playerid, INVALID_VEHICLE_ID, 1, -1, -1, -1, 25.0));

		SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_CORPSE_TAHNES);
	}
	else if(!strcmp ( lPar1, "zapalit", true ))
	{
	    new
		    id = CPS_GetNearestCorpse(playerid, 3.0)
		;

		if( id == CPS_INVALID_CORPSE_ID )
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_NEARBY_CORPSE);

        if( CPS_E_corpse[id][CPS_E_isBeingDragged] == 1 )
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_EDITING_DRAGGED);
		    
        if( CPS_E_corpse[id][CPS_E_isBurning] == 1 )
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_EDITING_BURNING);
		    
		/*if( HRACNEMAZAPALKY )
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NEMAS_ZAPALKY);
		*/
		
		// ZAPALKY --

		CPS_E_corpse[id][CPS_E_isBurning] 	= 1;
		
		if(CPS_E_corpse[id][CPS_E_fireObject] != -1)
		    DestroyDynamicObject(CPS_E_corpse[id][CPS_E_fireObject]);
		
		CPS_E_corpse[id][CPS_E_fireObject] 	= CreateDynamicObject(
															CPS_FIRE_OBJECT,
															CPS_E_corpse[id][CPS_E_posX], CPS_E_corpse[id][CPS_E_posY], CPS_E_corpse[id][CPS_E_posZ] - 1.6,
															0.0, 0.0, 0.0,
															CPS_E_corpse[id][CPS_E_virtualWorld], CPS_E_corpse[id][CPS_E_interiorId],
															-1, 100.0, 70.0,
															-1, 1
		);
		
		CPS_E_corpse[id][CPS_E_burnTimer]   = defer CPSburntimer(id);
		
		CPS_E_corpse[id][CPS_E_stadium]     = CPS_STADIUM_HORI;
		CPS_Refresh3DTextLabelText(id);
		
		SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_CORPSE_ZAPALILS);
	}
	else if(!strcmp ( lPar1, "kufor", true ))
	{
	    new
			vehicleid = -1,
			Float:olddist = 2.5,
			Float:tmpdist,

			Float:pX,
			Float:pY,
			Float:pZ,

			Float:vX,
			Float:vY,
			Float:vZ
		;

		GetPlayerPos(playerid, pX, pY, pZ);

	    foreach(new x : Vehicle)
		{
		    CPS_GetVehicleBootOffset(x, vX, vY, vZ);
		    tmpdist = CPS_GetDistanceBetweenPoints(vX, vY, vZ, pX, pY, pZ);

		    if(floatcmp(tmpdist, olddist) >= 0)
		        continue;

			olddist = tmpdist;
			vehicleid = x;
		}

		if(vehicleid == -1)
			return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_NEARBY_VEHICLE);
		    
		new
			lBoot,
			lUnused
		;
		
		GetVehicleParamsEx(vehicleid, lUnused, lUnused, lUnused, lUnused, lUnused, lBoot, lUnused);
		
		if(lBoot != 1)
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_TRUNK_CLOSED);
		    
		new
		    lDialogStr[ 861 ] = "Typ\t(( Meno ))\n",
		    lTempStr[ 43 ],
		    firstName[ MAX_PLAYER_NAME + 1 ],
		    pocet
		;
		
		foreach( new corpse : Corpse )
		{
		
		    if(CPS_E_corpse[corpse][CPS_E_vehicleId] != vehicleid)
		        continue;

			if(CPS_E_corpse[corpse][CPS_E_bodyBag] == (CPS_VALID_BODYBAG))
			    strcat(lDialogStr, "TÏlo v pytli na mrtvoly\tNezn·mÈ\n");
			else
			{
				switch(CPS_E_corpse[corpse][CPS_E_stadium])
				{
				    case CPS_STADIUM_CERSTVA..CPS_STADIUM_ROZKLAD_II:
				    {
				        format(lTempStr, sizeof lTempStr, "MrtvÈ tÏlo\t%s\n", CPS_E_corpse[corpse][CPS_E_name]);
				        strcat(lDialogStr, lTempStr);
					}

	                case CPS_STADIUM_ROZKLAD_III:
	                {

	                    firstName[0] = EOS;
						strcat(firstName, CPS_E_corpse[corpse][CPS_E_name]);
						strdel(firstName, strfind(firstName," ",true), MAX_PLAYER_NAME+1);

				        format(lTempStr, sizeof lTempStr, "M‡tve telo\t%s\n", firstName);
				        strcat(lDialogStr, lTempStr);

					}

					case CPS_STADIUM_ROZKLAD_IV:
	                	strcat(lDialogStr, "M‡tve telo\tNezn·me\n");

	                case CPS_STADIUM_OBHORENA, CPS_STADIUM_HORI:
	                	strcat(lDialogStr, "ObhoretÈ telo\tNezn·me\n");
				}
			}

			pocet ++;
		}
		
		if(pocet <= 0)
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_CORPSE_IN_VEHICLE);
		
		SetPVarInt(playerid, PVAR_TEMP_VEHICLE, vehicleid);
		ShowPlayerDialog(playerid, CPS_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "KUFR ï TEL¡", lDialogStr, "VYBRAT", "ZAVRIEç");

	}
	else if(!strcmp ( lPar1, "bodybag", true ))
	{
	    new
		    id = CPS_GetNearestCorpse(playerid, 3.0)
		;

		if( id == CPS_INVALID_CORPSE_ID )
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_NEARBY_CORPSE);

        if( CPS_E_corpse[id][CPS_E_isBeingDragged] == 1 )
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_EDITING_DRAGGED);

        if( CPS_E_corpse[id][CPS_E_isBurning] == 1 )
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_EDITING_BURNING);

		/*if( HRACNENIEMS (ALEBO) NEMAITEMBODYBAG)
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NEMAS_BODYBAG);
		*/

		// BODYBAG --

		if(CPS_E_corpse[id][CPS_E_bodyBag] > -1)
		{
		    DestroyDynamicObject(CPS_E_corpse[id][CPS_E_bodyBag]);
			CPS_E_corpse[id][CPS_E_bodyBag] 		= (-1);

			CPS_E_corpse[id][CPS_E_actorId]			= CreateDynamicActor(
														CPS_E_corpse[id][CPS_E_skinId],
														CPS_E_corpse[id][CPS_E_posX], CPS_E_corpse[id][CPS_E_posY], CPS_E_corpse[id][CPS_E_posZ],
														CPS_E_corpse[id][CPS_E_posA],
														1, 100.0,
														CPS_E_corpse[id][CPS_E_virtualWorld], CPS_E_corpse[id][CPS_E_interiorId],
														-1,
														CPS_ACTOR_STREAM_DISTANCE, -1, CPS_ACTOR_STREAM_PRIORITY
			);

			CPSapplyanim(id);

			Streamer_Update(playerid, STREAMER_TYPE_ACTOR);

			SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_BODYBAG_DOWN);
		}
		else
		{
		    DestroyDynamicActor(CPS_E_corpse[id][CPS_E_actorId]);

		    CPS_E_corpse[id][CPS_E_bodyBag]			= CreateDynamicObject(
														CPS_BODY_BAG_OBJECT,
														CPS_E_corpse[id][CPS_E_posX], CPS_E_corpse[id][CPS_E_posY], CPS_E_corpse[id][CPS_E_posZ] - 0.95,
														0.0, 0.0, CPS_E_corpse[id][CPS_E_posA],
														CPS_E_corpse[id][CPS_E_virtualWorld], CPS_E_corpse[id][CPS_E_interiorId],
														-1, 300.0, 285.0, -1, 1
			);

			Streamer_Update(playerid, STREAMER_TYPE_OBJECT);

			SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_BODYBAG_ON);
		}

		CPS_Refresh3DTextLabelText(id);
	}
	else if(!strcmp ( lPar1, "zranenia", true ))
	{
	    new
		    id = CPS_GetNearestCorpse(playerid, 3.0)
		;

		if( id == CPS_INVALID_CORPSE_ID )
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_NEARBY_CORPSE);

        if( CPS_E_corpse[id][CPS_E_isBurning] == 1 )
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_EDITING_BURNING);

		if(CPS_E_corpse[id][CPS_E_bodyBag] > -1)
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_CANT_EXAMINE);
		    
		new
			lDialogStr[ CPS_MAX_DAMAGE_SLOTS * 41 + 3 ],
			lTempStr[ 45 ]
		;
		    
		foreach( new x : CPS_CorpseDamage[id] )
		{
		    if(x < 0)
		        break;
		
		    format(lTempStr, sizeof lTempStr, "Rana od %s (%s)\n", CPS_GetWeaponName(CPS_corpseDamage[id][x][0]), CPS_GetBodypartName(CPS_corpseDamage[id][x][1]));
		    strcat(lDialogStr, lTempStr);
		}
		
		if(strlen(lDialogStr) < 10)
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_NO_DAMAGE);
		
		ShowPlayerDialog(
			playerid,
			CPS_DIALOG_DAMAGE,
			DIALOG_STYLE_LIST,
			"MRTVOLA ï ZRANENIA",
			lDialogStr,
			"OK",
			""
		);

	}
	else
	{
	    if( CPS_HasPlayerAdminRights(playerid) )
            return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_SYNTAX_ADMIN);
		else
		    return SendClientMessage(playerid, 0xD0D0D0, CPS_CMD_SYNTAX);
	}

    return 1;
}
