/*
	harmonogram:
	    - 21:20 aû 23:25
	    - 8:00 aû 12:10
	    - 8:00 aû
*/

#include <a_samp>
#include <sscanf2>
#include <streamer>

#if !defined MAX_PHONE_BOOTHS
	#define MAX_PHONE_BOOTHS    50
#endif

////////////////////////////////////////////////////////////////////////////////

enum phonebo_Enum()
{

	Float:phonebo_posX, Float:phonebo_posY, Float:phonebo_posZ, Float:phonebo_posRX, Float:phonebo_posRY, Float:phonebo_posRZ,
	phonebo_posVW, phonebo_posINT,
	phonebo_Object,
	phonebo_AreaID,
	Text3D:phonebo_Label,
	
	Float:phonebo_Price,
	phonebo_Code[24]
	
}

new phoneboEnum[MAX_PHONE_BOOTHS][phonebo_Enum];
new Float:phonebotmp_price[MAX_PLAYERS];
new phonebotmp_name[MAX_PLAYERS][10];
new phonebotmp_id[MAX_PLAYERS];
new phoneboinput[MAX_PLAYERS][166];
new bool:IsEditingPB[MAX_PLAYERS];

////////////////////////////////////////////////////////////////////////////////

function phoneb_timer_Message_NoCredit(toid)
{

	if(ex_GetPlayerMoney(toid) < phoneboEnum[ phonebotmp_id[toid]-1 ][phonebo_Price])
	{
	    // close call
	    
	    new
	        playerid = toid,
			fromid = ph_CallWith[playerid];

		if(fromid >= MAX_PLAYERS || fromid < 0)
		    fromid = playerid;

		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
		RemovePlayerAttachedObject(playerid, 8);

		TogglePlayerControllable(playerid, 1);
		TogglePlayerControllable(fromid, 1);

		if(ph_IsTalking[fromid] == true || ph_IsWaiting[fromid] == true || ph_IsDialing[fromid] == true)
		{
			SetPlayerSpecialAction(fromid, SPECIAL_ACTION_STOPUSECELLPHONE);
			RemovePlayerAttachedObject(fromid, 8);

			if(phonebotmp_id[fromid] == 0)
			{
				for(new x; x < 3; x++)
					PlayerTextDrawHide(fromid, PTD_phone_EXTRA[fromid][x]);
				phone_refreshTextdraw(fromid);
			}
		}

		if(phonebotmp_id[playerid] == 0)
		{
			for(new x; x < 3; x++)
				PlayerTextDrawHide(playerid, PTD_phone_EXTRA[playerid][x]);

			phone_refreshTextdraw(playerid);
		}

		ph_IsTalking[playerid] = false;
		ph_IsTalking[fromid] = false;
		ph_IsDialing[playerid] = false;
		ph_IsDialing[fromid] = false;
		ph_IsWaiting[playerid] = false;
		ph_IsWaiting[fromid] = false;
		ph_CanAccept[playerid] = false;
		ph_CanAccept[fromid] = false;

		if(ph_IsCaller[playerid])
			KillTimer(ph_timer[playerid]);
		else if(fromid != playerid)
		    KillTimer(ph_timer[fromid]);

		ph_IsCaller[fromid] = false;
		ph_IsCaller[playerid] = false;
		ph_CallWith[playerid] = -1;
		ph_CallWith[fromid] = -1;
		
		phonebotmp_id[playerid] = 0;
		phonebotmp_id[fromid]   = 0;

		if(fromid != playerid) SCFM(fromid, COLOR_PHONE_MESSAGE, "[ PHONE ] **Zvuk poloûenia**");
		SCFM(playerid, COLOR_PHONE_MESSAGE, "[ PHONE ] **Zvuk poloûenia**");
		SCFM(playerid, COLOR_PHONE_MESSAGE, "[ PHONE ] **Nem·te dostatok peÚazÌ na zaplatenie hovoru!**");
	    
	}
	
	if(ph_IsTalking[toid] != true && ph_IsWaiting[toid] != true && ph_IsDialing[toid] != true)
	{
	    return 1;
	}

	ex_GivePlayerMoney(toid, -phoneboEnum[ phonebotmp_id[toid]-1 ][phonebo_Price]);
	
	SetTimerEx("phoneb_timer_Message_NoCredit", 60000, false, "i", toid);

	return 1;
}

forward phoneb_timer_Dial_Failed(playerid); public phoneb_timer_Dial_Failed(playerid)
{

	phonebotmp_id[playerid] = 0;
	ph_IsDialing[playerid] = false;
	SendClientMessage(playerid, COLOR_PHONE_MESSAGE, "[ PHONE ] éensk˝ hlas hovorÌ: VolanÈ ËÌslo nie je dostupnÈ!");

	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
	RemovePlayerAttachedObject(playerid, 8);
	
	TogglePlayerControllable(playerid, 1);
	return 1;
}

forward phoneb_timer_Dial_Emergency(fromid); public phoneb_timer_Dial_Emergency(fromid)
{

	if(phonebotmp_id[fromid] < 1)
	    return 1;

	ph_IsTalking[fromid] = true;
	ph_IsDialing[fromid] = false;
	ph_IsWaiting[fromid] = true;

	ph_Emergency[fromid] = 0;

	ph_CallWith[fromid] = EMERGENCY_NUMBER;

	SCFM(fromid, COLOR_PHONE_MESSAGE, "[ PHONE ] Oper·tor: Dobr˝ deÚ, ak˙ sluûbu vyûadujete?");
	
	EnterInfo(fromid, "~w~Hovor mozes zrusit prikazom /h!");

	return 1;
}

forward phoneb_timer_Dial_Swoop(fromid); public phoneb_timer_Dial_Swoop(fromid)
{

	if(phonebotmp_id[fromid] < 1)
	    return 1;

	ph_IsTalking[fromid] = true;
	ph_IsDialing[fromid] = false;
	ph_IsWaiting[fromid] = true;

	ph_Emergency[fromid] = 0;

	ph_CallWith[fromid] = EMERGENCY_TAXI;

	SCFM(fromid, COLOR_PHONE_MESSAGE, "[ PHONE ] Oper·tor: Kr·sny deÚ prajem! Kde sa prosÌm V·s nach·dzate?");

    EnterInfo(fromid, "~w~Hovor mozes zrusit prikazom /h!");

	return 1;
}

forward phoneb_timer_Dial_RCN(fromid); public phoneb_timer_Dial_RCN(fromid)
{

	if(phonebotmp_id[fromid] < 1)
	    return 1;

	ph_IsTalking[fromid] = true;
	ph_IsDialing[fromid] = false;
	ph_IsWaiting[fromid] = true;

	ph_Emergency[fromid] = 0;

	ph_CallWith[fromid] = EMERGENCY_RCN;

	SCFM(fromid, COLOR_PHONE_MESSAGE, "[ PHONE ] Oper·torka: Dobr˝ deÚ! »o by ste n·m radi odk·zali?");
	
	EnterInfo(fromid, "~w~Hovor mozes zrusit prikazom /h!");

	return 1;
}

forward phoneb_timer_Dial_HAWKINS(fromid); public phoneb_timer_Dial_HAWKINS(fromid)
{

	if(phonebotmp_id[fromid] < 1)
	    return 1;
	    
	ph_IsTalking[fromid] = true;
	ph_IsDialing[fromid] = false;
	ph_IsWaiting[fromid] = true;

	ph_Emergency[fromid] = 0;

	ph_CallWith[fromid] = EMERGENCY_HAWKINS;

	SCFM(fromid, COLOR_PHONE_MESSAGE, "[ PHONE ] Oper·tor: No, Ëo je? »o potrebujeö?");
	
	EnterInfo(fromid, "~w~Hovor mozes zrusit prikazom /h!");

	return 1;
}

forward phoneb_timer_Dial_Success(fromid, toid); public phoneb_timer_Dial_Success(fromid, toid)
{

	if(phonebotmp_id[fromid] < 1)
	    return 1;

	if(phone_isPhoneTurnedOff(toid) || ph_CanAccept[toid] == true || ph_IsTalking[toid] == true || ph_IsDialing[toid] == true)
		return SetTimerEx("phoneb_timer_Dial_Failed", 1, false, "i", fromid);

	ph_IsTalking[fromid] = false;
	ph_IsTalking[toid] = false;

	ph_IsDialing[fromid] = false;

	ph_IsWaiting[fromid] = true;
	ph_IsCaller[fromid] = true;
	ph_CanAccept[toid] = true;

	ph_CallWith[fromid] = toid;
	ph_CallWith[toid] = fromid;

	SCFM(toid, COLOR_PHONE_MESSAGE, "[ PHONE ] Prich·dzaj˙ci hovor od %s, pouûi /(p)ick pre zodvihnutie alebo /(h)angup pre zloûenie.", phoneboEnum[ phonebotmp_id[fromid]-1 ][phonebo_Code]);

	new
		Float:X,
		Float:Y,
		Float:Z;

	GetPlayerPos(toid, X, Y, Z);

	if(phone_SleepMode[toid] != 1)
	{
		foreach ( new all : Player )
		{
			if(!IsPlayerNearPlayer(all, toid, 20.0))
				continue;

			PlayerPlaySound(all, 20600, X, Y, Z);
		}
	}

	new str[256];

	if(phone_IsOut[toid] == false)
    {
	    LoadPhone(toid);

	    phone_SelectedTile[toid] 	= 0;
	    phone_Screen[toid]          = 0;
	    phone_IsOut[toid]           = true;

	    EnterInfo(toid, "~w~Telefon mozes zatvorit prikazom ~b~/phone~w~ alebo kliknutim na tlacidlo ~b~BACK~w~!~n~Kurzor otvoris prikazom ~b~/pc~w~!");

	    phone_refreshTextdraw(toid);

	    for(new x; x < 5; x++)
  			PlayerTextDrawHide(toid, PTD_phone_MENU[toid][x]);

		for(new x; x < 2; x++)
  			PlayerTextDrawHide(toid, PTD_phone_MESSAGES[toid][x]);

		for(new x; x < 4; x++)
  			PlayerTextDrawHide(toid, PTD_phone_OPTIONS[toid][x]);

	    format(str,256, "Incoming call from~n~%s", replaceChars(phone_getPlayerContact(toid, phone_getPlayerNumber(fromid))));
		PlayerTextDrawSetString(toid, PTD_phone_EXTRA[toid][1], str);

		PlayerTextDrawShow(toid, PTD_phone_EXTRA[toid][0]);
		PlayerTextDrawShow(toid, PTD_phone_EXTRA[toid][1]);
	}
	else
	{

	    for(new x; x < 5; x++)
  			PlayerTextDrawHide(toid, PTD_phone_MENU[toid][x]);

		for(new x; x < 2; x++)
  			PlayerTextDrawHide(toid, PTD_phone_MESSAGES[toid][x]);

		for(new x; x < 4; x++)
  			PlayerTextDrawHide(toid, PTD_phone_OPTIONS[toid][x]);

	    format(str,256, "Incoming call from~n~%s", replaceChars(phone_getPlayerContact(toid, phone_getPlayerNumber(fromid))));
		PlayerTextDrawSetString(toid, PTD_phone_EXTRA[toid][1], str);

		PlayerTextDrawShow(toid, PTD_phone_EXTRA[toid][0]);
		PlayerTextDrawShow(toid, PTD_phone_EXTRA[toid][1]);
	}

	//SetTimerEx("hidephoneextra", 3000, false, "i", toid);

	return 1;
}

forward PhoneBooth_OnPlayerDial(playerid);
public PhoneBooth_OnPlayerDial(playerid)
{

	if(isnull(phoneboinput[playerid]))
	{
	
	}
	
	TogglePlayerControllable(playerid, 0);
	
	SendPlayerAction(playerid, "ùuk· Ëislo do kl·vesnice na b˙dke a vyt·Ëa ho ...");
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
	
	ph_IsDialing[playerid] = true;
	
	PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);
	
	if(strlen(phoneboinput[playerid]) > 32)
	    return SetTimerEx("phoneb_timer_Dial_Failed", 4000 + random(6000), false, "i", playerid);

	if(strval(phoneboinput[playerid]) == 911)
	{
	    tcisloex[playerid] = 911;
	    return SetTimerEx("phoneb_timer_Dial_Emergency", 4000 + random(6000), false, "i", playerid);
	}
	else if(strval(phoneboinput[playerid]) == 222444666)
	{
        tcisloex[playerid] = 222444666;
	    return SetTimerEx("phoneb_timer_Dial_Swoop", 4000 + random(6000), false, "i", playerid);
	}
	else if(strval(phoneboinput[playerid]) == 8778)
	{
        tcisloex[playerid] = 8778;
	    return SetTimerEx("phoneb_timer_Dial_RCN", 4000 + random(6000), false, "i", playerid);
	}
	else if(strval(phoneboinput[playerid]) == 333)
	{
        tcisloex[playerid] = 333;
	    return SetTimerEx("phoneb_timer_Dial_HAWKINS", 4000 + random(6000), false, "i", playerid);
	}

	new player = phone_getPlayerFromNumber(strval( phoneboinput[playerid] ));

	if(player == INVALID_PHONE_PLAYER || player == playerid)
		return SetTimerEx("phoneb_timer_Dial_Failed", 4000 + random(6000), false, "i", playerid);
	else if(phonebotmp_id[playerid] == 1 || ph_IsTalking[player] == true || ph_IsDialing[player] == true || ph_IsWaiting[player] == true)
		return SetTimerEx("phoneb_timer_Dial_Failed", 4000 + random(6000), false, "i", playerid);

	// CALLING PLAYER 'player' FROM 'playerid' SUCCESSFULLY

	SetTimerEx("phoneb_timer_Dial_Success", 1000 + random(3000), false, "ii", playerid, player);

	return 1;

}

forward PhoneBooths_OnPlaceObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
public PhoneBooths_OnPlaceObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{

	if(IsEditingPB[playerid] == true)
	{
	
	    if(response == 0)
	    {
	        IsEditingPB[playerid] = false;
	        DestroyDynamicObject(objectid);

            SendError(playerid, "Tvorba telefonnej budky zruöen·!");
	    }
	    else if(response == 1)
		{

		    IsEditingPB[playerid] = false;

		    new i=-1;

		    for(new o; o < MAX_PHONE_BOOTHS; o++)
		    {
		        if(phoneboEnum[o][phonebo_posX] != 0.0)
		            continue;

				i = o;
				break;
		    }

		    if(i == -1)
		    {
		        IsEditingPB[playerid] = false;
		        DestroyDynamicObject(objectid);

	            return SendError(playerid, "Tvorba telefonnej budky zruöen·!");
		    }

		    DestroyDynamicObject(objectid);
		    
		    new tstring[98];

            phoneboEnum[i][phonebo_posX] = x;
            phoneboEnum[i][phonebo_posY] = y;
            phoneboEnum[i][phonebo_posZ] = z;
            phoneboEnum[i][phonebo_posRX] = rx;
            phoneboEnum[i][phonebo_posRY] = ry;
            phoneboEnum[i][phonebo_posRZ] = rz;
            phoneboEnum[i][phonebo_posVW] = GetPlayerVirtualWorld(playerid);
            phoneboEnum[i][phonebo_posINT] = GetPlayerInterior(playerid);
            
            
            phoneboEnum[i][phonebo_Price] = phonebotmp_price[playerid];
        	format(phoneboEnum[i][phonebo_Code], 24, phonebotmp_name[playerid]);
            
            format(tstring, sizeof tstring, "%s\n/zavolat\n%.2f$/min˙ta",phoneboEnum[i][phonebo_Code], phoneboEnum[i][phonebo_Price]);

			phoneboEnum[i][phonebo_Object] = CreateDynamicObject(1216, x, y, z, rx, ry, rz, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 100.0, 70.0, -1, 1);
	        phoneboEnum[i][phonebo_AreaID] = CreateDynamicSphere(x, y, z, 3.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1);
	        phoneboEnum[i][phonebo_Label] = CreateDynamic3DTextLabel(tstring, 0xffffffff, x, y, z, 6.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 16.0, -1, 0);

            SendSuccess(playerid, "Telefonna budka ˙speöne vytvoren·!");

            SetDynamicObjectPos(objectid, x, y, z);
			SetDynamicObjectRot(objectid, rx, ry, rz);

            new
				Q_query[256];

			mysql_format(MYSQL, Q_query, 256, "INSERT INTO gm_phonebooths (X, Y, Z, RX, RY, RZ, VW, Interior, Name, Code) VALUES ('%f', '%f', '%f', '%f', '%f', '%f', '%d', '%d', '%d', '%e')",
				x, y, z, rx, ry, rz, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), phoneboEnum[i][phonebo_Price], phoneboEnum[i][phonebo_Code]);

			mysql_query(MYSQL, Q_query, false);
		}
	
	}

	return 1;
}

GetPlayerDynamicPB(playerid) {

	for(new i; i < MAX_ATM; i++) {
	    if(phoneboEnum[i][phonebo_posX] == 0 && phoneboEnum[i][phonebo_posY] == 0 && phoneboEnum[i][phonebo_posZ] == 0)
			continue;

	    if(!IsPlayerInDynamicArea(playerid, phoneboEnum[i][phonebo_AreaID]))
			continue;

	    return i;
	}
	return -1;
	
}

LoadPhoneBooths()
{
    new mql_query[43];

	mysql_format(MYSQL, mql_query, sizeof(mql_query), "SELECT * FROM gm_phonebooths");

	mysql_tquery(MYSQL, mql_query, "OnPhoneBoothLoad");
	return 1;
}

function OnPhoneBoothLoad() {

	new
	    Float:X, Float:Y, Float:Z,
	    Float:RX, Float:RY, Float:RZ,
	    VW, Interior,
		Float:Price,

		tstring[64];

	for(new i; i < cache_num_rows(); i++) {

     	cache_get_value_name_float(i, "X", X);
     	cache_get_value_name_float(i, "Y", Y);
     	cache_get_value_name_float(i, "Z", Z);
     	cache_get_value_name_float(i, "RX", RX);
     	cache_get_value_name_float(i, "RY", RY);
     	cache_get_value_name_float(i, "RZ", RZ);
        cache_get_value_name_int(i, "VW", VW);
        cache_get_value_name_int(i, "Interior", Interior);
        cache_get_value_name_float(i, "Price", Price);
        cache_get_value_name(i, "Code", phoneboEnum[i][phonebo_Code]);

        phoneboEnum[i][phonebo_posX] = X;
        phoneboEnum[i][phonebo_posY] = Y;
        phoneboEnum[i][phonebo_posZ] = Z;
        phoneboEnum[i][phonebo_posRX] = RX;
        phoneboEnum[i][phonebo_posRY] = RY;
        phoneboEnum[i][phonebo_posRZ] = RZ;
        phoneboEnum[i][phonebo_posVW] = VW;
        phoneboEnum[i][phonebo_posINT] = Interior;
        phoneboEnum[i][phonebo_Price] = Price;
        
        format(tstring, sizeof tstring, "%s\n/zavolat\n%.2f$/min˙ta",phoneboEnum[i][phonebo_Code], Price);

        phoneboEnum[i][phonebo_Object] = CreateDynamicObject(1216, X, Y, Z, RX, RY, RZ, VW, Interior, -1, 100.0, 70.0, -1, 1);
        phoneboEnum[i][phonebo_AreaID] = CreateDynamicSphere(X, Y, Z, 3.0, VW, Interior, -1);
        phoneboEnum[i][phonebo_Label] = CreateDynamic3DTextLabel( tstring, 0xffffffff, X, Y, Z, 6.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, VW, Interior, -1, 16.0, -1, 0);

		if(i == cache_num_rows()) break;
	}
	return 1;
}

////////////////////////////////////////////////////////////////////////////////

YCMD:vytvoritbudku(playerid, params[], help)
{

	if(GetPlayerAdminLevel(playerid) < 5)
	    return SendClientCantUseCommand(playerid);

	if(IsPlayerInAnyVehicle(playerid))
	    return SendError(playerid, "Nesmieö sedieù v aute!");

	if(IsEditingPB[playerid] == true)
	    return SendError(playerid, "Uû editujeö budku!");
	    
	new
	    Float:S_temp,
	    S_temp1[9]
	;
	
	if(sscanf(params,"fs[9]",S_temp,S_temp1))
	    return SendClientSyntax(playerid, "/vytvoritbudku [cena za minutu hovoru] [kod v tvare XXX-XXX-XXX, mozu byt cisla aj pismena]");
	    
	if(S_temp < 0)
	    return SendError(playerid, "Cena nemoze byt zaporna!");
	    
	if(strlen(S_temp1) < 3)
	    return SendError(playerid, "KÛd nemÙûe byù kratöÌ troch znakov!");

    for(new i; i < MAX_PHONE_BOOTHS; i++)
	{
 		if(phoneboEnum[i][phonebo_posX] != 0.0)
   			break;

        if(i >= MAX_PHONE_BOOTHS)
            return SendError(playerid, "Nie je voln˝ slot na budku!");

		continue;
	}

	new
	    Float:X,
	    Float:Y,
	    Float:Z,
	    Float:A;

	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, A);

	Z -= 0.9;

	GetXYInFrontOfPlayer(playerid, X, Y, 2.0);

	IsEditingPB[playerid] = true;

    new
		objectid = CreateDynamicObject(1216, X, Y, Z, 0.0, 0.0, A, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 100.0, 70.0, -1, 1);

    Streamer_UpdateEx(playerid, X, Y+0.1, Z);

	EditDynamicObject(playerid, objectid);
	
	phonebotmp_price[playerid] = S_temp;
	format(phonebotmp_name[playerid], 10, S_temp1);

	return 1;
}

YCMD:zmazatbudku(playerid, params[], help)
{

    if(GetPlayerAdminLevel(playerid) < 5)
	    return SendClientCantUseCommand(playerid);

	if(GetPlayerDynamicPB(playerid) == -1)
	    return SendError(playerid, "NestojÌö pri ûiadnej telefonnej budke!");

	new
		id = GetPlayerDynamicPB(playerid),
		query[1024];



	mysql_format(MYSQL, query, 1024, "DELETE FROM gm_phonebooths WHERE X > '%f' AND X < '%f' AND Y > '%f' AND Y < '%f' AND Z > '%f' AND Z < '%f'",
 		phoneboEnum[id][phonebo_posX]-0.2, phoneboEnum[id][phonebo_posX]+0.2,
	    phoneboEnum[id][phonebo_posY]-0.2, phoneboEnum[id][phonebo_posY]+0.2,
		phoneboEnum[id][phonebo_posZ]-0.2, phoneboEnum[id][phonebo_posZ]+0.2);

	mysql_query(MYSQL, query, false);

   	phoneboEnum[id][phonebo_posX] = 0.0;
    phoneboEnum[id][phonebo_posY] = 0.0;
    phoneboEnum[id][phonebo_posZ] = 0.0;
    phoneboEnum[id][phonebo_posRX] = 0.0;
    phoneboEnum[id][phonebo_posRY] = 0.0;
    phoneboEnum[id][phonebo_posRZ] = 0.0;
    phoneboEnum[id][phonebo_posVW] = 0;
    phoneboEnum[id][phonebo_posINT] = 0;
    DestroyDynamicArea(phoneboEnum[id][phonebo_AreaID]);
	DestroyDynamicObject(phoneboEnum[id][phonebo_Object]);
	DestroyDynamic3DTextLabel(phoneboEnum[id][phonebo_Label]);

	SendError(playerid, "Telefonna budka ˙speöna zmazan·!");

	return 1;
}
YCMD:zavolat(playerid, params[], help)
{

    if(GetPlayerDynamicPB(playerid) == -1)
	    return SendError(playerid, "NestojÌö pri ûiadnej telefonnej budke!");

	if(phone_IsOut[playerid] == true)
	    return SendError(playerid, "M·ö vybran˝ svoj mobil!");

    if(ph_IsDialing[playerid] == true)
		return SendError(playerid, "Vyt·Ëaö nejakÈ ËÌslo ...");
		
    if(ph_CanAccept[playerid] == true)
        return SendError(playerid, "Niekto ti vol·!");

	if(ph_IsTalking[playerid] == true)
	    return SendError(playerid, "Telefonujeö..");
	    
    phonebotmp_id[playerid] = GetPlayerDynamicPB(playerid)+1;
    
    if(ex_GetPlayerMoney(playerid) < phoneboEnum[ phonebotmp_id[playerid]-1 ][phonebo_Price])
    {
        SendError(playerid, "Nem·ö dosù peÚazÌ na hovor!");
        phonebotmp_id[playerid] = 0;
        return 1;
    }
    
    new
        dialogstr[ 256 ];
        
	format(dialogstr, sizeof dialogstr, "{ffffff}> Zadaj prosÌm telefÛnne ËÌslo, na ktorÈ chceö zavolaù!\n\nTelefÛnne ËÌslo b˙dky: %s\nCena za min˙tu hovoru: %.2f$\nPohotovostnÈ linky s˙ zadarmo.", phoneboEnum[ phonebotmp_id[playerid]-1 ][phonebo_Code], phoneboEnum[ phonebotmp_id[playerid]-1 ][phonebo_Price]);

	ShowPlayerDialog(playerid, did_phonebooth, DIALOG_STYLE_INPUT, "TELEF”NNA B⁄DKA -> DIAL", dialogstr, "VYTO»Iç", "ZRUäIç");

	return 1;
}
