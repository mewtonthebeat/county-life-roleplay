/*
	FUNCTIONS
	
	* stock ms_preloadStore(playerid)
	* stock ms_addItem(playerid, type, data, name[], price, model, quantity = 1)
*/

/*
	OPTIONS,
	DO NOT CHANGE
*/

#define MS_MAX_COLUMNS_FIRST	2
#define MS_MAX_COLUMNS			4
#define MS_MAX_ROWS				3

#define MS_MAX_ITEMS			10
#define	MS_MAX_ITEM_NAME		48

/*

	COLORS
	
*/

#define	MS_COLOR_SYSTEM_ERROR		(0xf63f3fFF)
#define	MS_COLOR_SYSTEM_SUCCESS		(0x6fdb6bFF)

/*
	OFFSETS
*/

#define MS_MAIN_OFFSET_X 	(65.124)
#define MS_MAIN_OFFSET_Y 	(65.124)

#define MS_CASH_OFFSET_X	(57.796)
#define MS_CASH_OFFSET_Y	(48.999)

#define MS_NAME_OFFSET_X	(1.574)
#define MS_NAME_OFFSET_Y	(0.0)

/*
	ITEM TYPES
*/

enum {
	ITEM_TYPE_WEAPON,
	ITEM_TYPE_INVENTORY,
	ITEM_TYPE_ARMOUR,
	ITEM_TYPE_ALCOHOL,
	ITEM_TYPE_WEAPON_F,
}

enum ms_menustore_item {
	ms_p_model,
	ms_p_type,
	ms_p_name[MS_MAX_ITEM_NAME],
	ms_p_price,
	ms_p_quantity,
	ms_p_data,
	
	ms_p_cart_data, //how much has he in the cart
	
	Float:ms_p_rx,
	Float:ms_p_ry,
	Float:ms_p_rz,
	Float:ms_p_zoom,
}

//*****************************

new ms_items[MAX_PLAYERS][MS_MAX_ITEMS][ms_menustore_item];
new ms_playerStoreId[MAX_PLAYERS];
new PlayerText:MS_TEXTDRAW[MAX_PLAYERS][38];

stock ms_addItem(playerid, type, data, name[], price, model, quantity = 1, Float:rx = 0.0, Float:ry = 0.0, Float:rz = 0.0, Float:zoom = 1.0)
{
	
	new
		slotId = -1
	;
	
	for( new x; x < MS_MAX_ITEMS; x ++ )
	{
		
		if(ms_items[playerid][x][ms_p_model] != 0)
			continue;
			
		slotId = x;
		
		break;
		
	}
	
	if(slotId == -1 || model == 0)
	{
	
		new
			errorString[ 128 ]
		;
		
		format(errorString, sizeof errorString, "[error]: {FFFFFF}Item %s (data: %d, model: %d), couldnt be added, contact an admin ASAP!", name, data, model);
	
		SendClientMessage(playerid, MS_COLOR_SYSTEM_ERROR, errorString);
		
		return 0; // no free slot
	}
		
	ms_items[playerid][slotId][ms_p_model] 	= model;
	ms_items[playerid][slotId][ms_p_type]	= type;
	ms_items[playerid][slotId][ms_p_price]	= price;
	ms_items[playerid][slotId][ms_p_data]	= data;
	ms_items[playerid][slotId][ms_p_quantity]	= quantity;
	
	ms_items[playerid][slotId][ms_p_rx]		= rx;
	ms_items[playerid][slotId][ms_p_ry]		= ry;
	ms_items[playerid][slotId][ms_p_rz]		= rz;
	ms_items[playerid][slotId][ms_p_zoom]		= zoom;
	
	format(ms_items[playerid][slotId][ms_p_name], MS_MAX_ITEM_NAME, name);
	
	return 1;
	
}

stock ms_showStore(playerid, name[], storeid)
{

	ms_playerStoreId[playerid] = storeid;
	
	ms_loadStore(playerid, name);
	
	PlayerTextDrawSetString(playerid, MS_TEXTDRAW[playerid][7], "Cart: ~g~$0");
	
	new
		row = 0,
		column = 0,
		
		bool:doloop = true,
		done = 0
	;
	
	while(doloop == true)
	{
	
		if(done >= MS_MAX_ITEMS)
		{
			doloop = false;
			break;
		}
	
		if(ms_items[playerid][done][ms_p_model] == 0)
		{
			done ++;
			continue;
		}
		
		ms_items[playerid][done][ms_p_cart_data] = 0;
		
		new
			pricestr[ 12 ]
		;
		
		format(pricestr, sizeof pricestr, "$%d", ms_items[playerid][done][ms_p_price]);
		
		MS_TEXTDRAW[playerid][8 + (done * 3)] = CreatePlayerTextDraw(playerid, 188.631057 + (MS_MAIN_OFFSET_X * column), 117.083358 + (MS_MAIN_OFFSET_Y * row), "");
		PlayerTextDrawLetterSize(playerid, MS_TEXTDRAW[playerid][8 + (done * 3)], 0.000000, 0.000000);
		PlayerTextDrawTextSize(playerid, MS_TEXTDRAW[playerid][8 + (done * 3)], 60.000000, 60.000000);
		PlayerTextDrawAlignment(playerid, MS_TEXTDRAW[playerid][8 + (done * 3)], 1);
		PlayerTextDrawColor(playerid, MS_TEXTDRAW[playerid][8 + (done * 3)], -1);
		PlayerTextDrawSetShadow(playerid, MS_TEXTDRAW[playerid][8 + (done * 3)], 0);
		PlayerTextDrawSetOutline(playerid, MS_TEXTDRAW[playerid][8 + (done * 3)], 0);
		PlayerTextDrawBackgroundColor(playerid, MS_TEXTDRAW[playerid][8 + (done * 3)], -421075201);
		PlayerTextDrawFont(playerid, MS_TEXTDRAW[playerid][8 + (done * 3)], 5);
		PlayerTextDrawSetProportional(playerid, MS_TEXTDRAW[playerid][8 + (done * 3)], 0);
		PlayerTextDrawSetShadow(playerid, MS_TEXTDRAW[playerid][8 + (done * 3)], 0);
		PlayerTextDrawSetPreviewModel(playerid, MS_TEXTDRAW[playerid][8 + (done * 3)], ms_items[playerid][done][ms_p_model]);
		PlayerTextDrawSetPreviewRot(playerid, MS_TEXTDRAW[playerid][8 + (done * 3)], ms_items[playerid][done][ms_p_rx], ms_items[playerid][done][ms_p_ry], ms_items[playerid][done][ms_p_rz], ms_items[playerid][done][ms_p_zoom]);
		PlayerTextDrawSetSelectable(playerid, MS_TEXTDRAW[playerid][8 + (done * 3)], true);
		
		MS_TEXTDRAW[playerid][8 + (done * 3) + 1] = CreatePlayerTextDraw(playerid, 190.925 + (MS_MAIN_OFFSET_X * column) + (MS_NAME_OFFSET_X * column), 117.083389 + (MS_MAIN_OFFSET_Y * row) + (MS_NAME_OFFSET_Y * row), ms_items[playerid][done][ms_p_name]);
		PlayerTextDrawLetterSize(playerid, MS_TEXTDRAW[playerid][8 + (done * 3) + 1], 0.216339, 0.987496);
		PlayerTextDrawTextSize(playerid, MS_TEXTDRAW[playerid][8 + (done * 3) + 1], 244.000000, 0.000000);
		PlayerTextDrawAlignment(playerid, MS_TEXTDRAW[playerid][8 + (done * 3) + 1], 1);
		PlayerTextDrawColor(playerid, MS_TEXTDRAW[playerid][8 + (done * 3) + 1], -1);
		PlayerTextDrawUseBox(playerid, MS_TEXTDRAW[playerid][8 + (done * 3) + 1], 1);
		PlayerTextDrawBoxColor(playerid, MS_TEXTDRAW[playerid][8 + (done * 3) + 1], 0);
		PlayerTextDrawSetShadow(playerid, MS_TEXTDRAW[playerid][8 + (done * 3) + 1], 0);
		PlayerTextDrawSetOutline(playerid, MS_TEXTDRAW[playerid][8 + (done * 3) + 1], 1);
		PlayerTextDrawBackgroundColor(playerid, MS_TEXTDRAW[playerid][8 + (done * 3) + 1], 255);
		PlayerTextDrawFont(playerid, MS_TEXTDRAW[playerid][8 + (done * 3) + 1], 1);
		PlayerTextDrawSetProportional(playerid, MS_TEXTDRAW[playerid][8 + (done * 3) + 1], 1);
		PlayerTextDrawSetShadow(playerid, MS_TEXTDRAW[playerid][8 + (done * 3) + 1], 0);
		
		MS_TEXTDRAW[playerid][8 + (done * 3) + 2] = CreatePlayerTextDraw(playerid, 246.895965 + (MS_MAIN_OFFSET_X * column), 166.666687 + (MS_MAIN_OFFSET_Y * row), pricestr);
		PlayerTextDrawLetterSize(playerid, MS_TEXTDRAW[playerid][8 + (done * 3) + 2], 0.215866, 0.899999);
		PlayerTextDrawAlignment(playerid, MS_TEXTDRAW[playerid][8 + (done * 3) + 2], 3);
		PlayerTextDrawColor(playerid, MS_TEXTDRAW[playerid][8 + (done * 3) + 2], 8388863);
		PlayerTextDrawSetShadow(playerid, MS_TEXTDRAW[playerid][8 + (done * 3) + 2], 0);
		PlayerTextDrawSetOutline(playerid, MS_TEXTDRAW[playerid][8 + (done * 3) + 2], 0);
		PlayerTextDrawBackgroundColor(playerid, MS_TEXTDRAW[playerid][8 + (done * 3) + 2], 255);
		PlayerTextDrawFont(playerid, MS_TEXTDRAW[playerid][8 + (done * 3) + 2], 1);
		PlayerTextDrawSetProportional(playerid, MS_TEXTDRAW[playerid][8 + (done * 3) + 2], 1);
		PlayerTextDrawSetShadow(playerid, MS_TEXTDRAW[playerid][8 + (done * 3) + 2], 0);
		
		column ++;
		if(row == 0 && column > 1)
			row ++, column = 0;
		else if(column > 3)
			row ++, column = 0;
		
		
		PlayerTextDrawShow(playerid, MS_TEXTDRAW[playerid][8 + (done * 3)]);
		PlayerTextDrawShow(playerid, MS_TEXTDRAW[playerid][8 + (done * 3) + 1]);
		PlayerTextDrawShow(playerid, MS_TEXTDRAW[playerid][8 + (done * 3) + 2]);
		
		done ++;
	}
	
	SelectTextDraw(playerid, 0xdfdfdfff);
	
	return 1;

}

//*****************************

forward MS_OPCNCT(playerid, PlayerText:playertextid);

forward OnPlayerMenuStoreBuy(playerid, item, quantity, type, count, price, object);
forward OnPlayerMenuStoreAdd(playerid, item, quantity, type);

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{

	if(ms_playerStoreId[playerid] != 0)
	{
		if(playertextid == MS_TEXTDRAW[playerid][2])
		{
			return CancelSelectTextDraw(playerid);
		}
		
		if(playertextid == MS_TEXTDRAW[playerid][5])
		{
			for(new i; i < MS_MAX_ITEMS; i++) 
			{
				ms_items[playerid][i][ms_p_cart_data] = 0;
			}
			
			SendClientMessage(playerid, MS_COLOR_SYSTEM_ERROR, "[obchod]: {FFFFFF}Cart trashed!");
			
			return PlayerTextDrawSetString(playerid, MS_TEXTDRAW[playerid][7], "Cart: ~g~$0");
		}
		
		if(playertextid == MS_TEXTDRAW[playerid][6])
		{
		
			if(ms_getPlayerPrice(playerid) == 0)
				return SendClientMessage(playerid, MS_COLOR_SYSTEM_ERROR, "[obchod]: {FFFFFF}Cart is empty!");
			
			if(GetPlayerMoney(playerid) < ms_getPlayerPrice(playerid))
				return SendClientMessage(playerid, MS_COLOR_SYSTEM_ERROR, "[obchod]: {FFFFFF}You have not enough money!");
				
			new ret = 1;
				
			for( new x; x < MS_MAX_ITEMS; x++)
			{
				if(ms_items[playerid][x][ms_p_model] == 0)
					continue;
					
				if(ms_items[playerid][x][ms_p_cart_data] == 0)
					continue;
					
				if(ret == 0)
					break;
					
				ret = CallRemoteFunction("OnPlayerMenuStoreBuy", "ddddddd",
					playerid, ms_items[playerid][x][ms_p_data], ms_items[playerid][x][ms_p_quantity], ms_items[playerid][x][ms_p_type], ms_items[playerid][x][ms_p_cart_data], ms_items[playerid][x][ms_p_cart_data]*ms_items[playerid][x][ms_p_price], ms_items[playerid][x][ms_p_model]
				);
			}
			
			if(ret == 0)
				return 1;
			
			CancelSelectTextDraw(playerid);
			
			SendClientMessage(playerid, MS_COLOR_SYSTEM_SUCCESS, "[obchod]: {FFFFFF}Order has been completed!");
			
			return 1;
		}
		
		new item = -1, ret = 1;
		
		for(new x; x < MS_MAX_ITEMS; x++)
		{
			if(playertextid != MS_TEXTDRAW[playerid][8 + (x * 3)])
				continue;
				
			item = x;
			break;
		}
		
		if(item == -1)
			return 1;
		
		ret = CallRemoteFunction("OnPlayerMenuStoreAdd", "dddd",
			playerid, ms_items[playerid][item][ms_p_data], ms_items[playerid][item][ms_p_quantity], ms_items[playerid][item][ms_p_type]
		);
		
		if(ret == 0)
			return 1;
		
		ms_items[playerid][item][ms_p_cart_data] ++;
		
		new
			okString[ 128 ],
			price =  ms_getPlayerPrice(playerid)
		;
		
		format(okString, sizeof okString, "[obchod]: {FFFFFF}You added %s ($%d) to your cart! New price of your cart is $%d.", ms_items[playerid][item][ms_p_name], ms_items[playerid][item][ms_p_price], price);
	
		SendClientMessage(playerid, MS_COLOR_SYSTEM_SUCCESS, okString);
		
		format(okString, sizeof okString, "Cart: ~g~$%d",  price);
		
		return PlayerTextDrawSetString(playerid, MS_TEXTDRAW[playerid][7], okString);
	}
    return CallLocalFunction("MS_OPCPTD", "ii", playerid, _:playertextid);
}
#if defined _ALS_OnPlayerClickPlayerTD
	#undef OnPlayerClickPlayerTextDraw
#else
	#define _ALS_OnPlayerClickPlayerTD
#endif
#define OnPlayerClickPlayerTextDraw MS_OPCPTD

forward MS_OPCPTD(playerid, PlayerText:playertextid);

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{

	if(playerid != -1)
	{
		if(ms_playerStoreId[playerid] != 0)
		{
			if(clickedid == Text:INVALID_TEXT_DRAW)
			{
				ms_closeStore(playerid);
			}
		}
	}
    return CallLocalFunction("MS_OPCTD", "ii", playerid, _:clickedid);
}
#if defined _ALS_OnPlayerClickTextdraw
	#undef OnPlayerClickTextDraw
#else
	#define _ALS_OnPlayerClickTextdraw
	#undef OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw MS_OPCTD

forward MS_OPCTD(playerid, Text:clickedid);

//*****************************

stock ms_getPlayerPrice(playerid)
{

	new
		price = 0;
		
	for(new x; x < MS_MAX_ITEMS; x++)
	{
		if(ms_items[playerid][x][ms_p_model] == 0)
			continue;
			
		price += (ms_items[playerid][x][ms_p_price] * ms_items[playerid][x][ms_p_cart_data]);
	}
		
	return price;

}

stock ms_closeStore(playerid)
{

	if(playerid == -1)
		return 1;

	if(ms_playerStoreId[playerid] == 0)
		return 0;

	for(new i; i < 8; i++)
	{
		if(i == 8 || i == -1)
			continue;
			
		PlayerTextDrawDestroy(playerid, MS_TEXTDRAW[playerid][i]);
	}
	
	for(new i; i < MS_MAX_ITEMS; i ++)
	{
		if(ms_items[playerid][i][ms_p_model] == 0)
			continue;
			
		PlayerTextDrawDestroy(playerid, MS_TEXTDRAW[playerid][8 + (i * 3)]);
		PlayerTextDrawDestroy(playerid, MS_TEXTDRAW[playerid][8 + (i * 3) + 1]);
		PlayerTextDrawDestroy(playerid, MS_TEXTDRAW[playerid][8 + (i * 3) + 2]);
		
		ms_items[playerid][i][ms_p_model] = 0;
	}
	
	for(new i; i < 38; i++)
	{
		if(i == -1 || i == 38)
			continue;
			
		MS_TEXTDRAW[playerid][i] = PlayerText:-1024;
	}
	
	ms_playerStoreId[playerid] = 0;
	
	return 1;
}

stock ms_loadStore(playerid, name[])
{

	MS_TEXTDRAW[playerid][0] = CreatePlayerTextDraw(playerid, 317.174255, 103.666702, "cerne_bg");
	PlayerTextDrawLetterSize(playerid, MS_TEXTDRAW[playerid][0], 0.000000, 23.587112);
	PlayerTextDrawTextSize(playerid, MS_TEXTDRAW[playerid][0], 0.000000, 265.000000);
	PlayerTextDrawAlignment(playerid, MS_TEXTDRAW[playerid][0], 2);
	PlayerTextDrawColor(playerid, MS_TEXTDRAW[playerid][0], -1);
	PlayerTextDrawUseBox(playerid, MS_TEXTDRAW[playerid][0], 1);
	PlayerTextDrawBoxColor(playerid, MS_TEXTDRAW[playerid][0], 200);
	PlayerTextDrawSetShadow(playerid, MS_TEXTDRAW[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, MS_TEXTDRAW[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, MS_TEXTDRAW[playerid][0], 255);
	PlayerTextDrawFont(playerid, MS_TEXTDRAW[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, MS_TEXTDRAW[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, MS_TEXTDRAW[playerid][0], 0);

	MS_TEXTDRAW[playerid][1] = CreatePlayerTextDraw(playerid, 185.051223, 96.666648, name);
	PlayerTextDrawLetterSize(playerid, MS_TEXTDRAW[playerid][1], 0.498389, 1.716667);
	PlayerTextDrawAlignment(playerid, MS_TEXTDRAW[playerid][1], 1);
	PlayerTextDrawColor(playerid, MS_TEXTDRAW[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, MS_TEXTDRAW[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, MS_TEXTDRAW[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, MS_TEXTDRAW[playerid][1], 255);
	PlayerTextDrawFont(playerid, MS_TEXTDRAW[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, MS_TEXTDRAW[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, MS_TEXTDRAW[playerid][1], 0);

	MS_TEXTDRAW[playerid][2] = CreatePlayerTextDraw(playerid, 449.828674, 97.416702, "X");
	PlayerTextDrawLetterSize(playerid, MS_TEXTDRAW[playerid][2], 0.294582, 1.127500);
	PlayerTextDrawTextSize(playerid, MS_TEXTDRAW[playerid][2], 10.294582, 20.127500);
	PlayerTextDrawAlignment(playerid, MS_TEXTDRAW[playerid][2], 2);
	PlayerTextDrawColor(playerid, MS_TEXTDRAW[playerid][2], 0xdd2f2fff);
	PlayerTextDrawSetShadow(playerid, MS_TEXTDRAW[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, MS_TEXTDRAW[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, MS_TEXTDRAW[playerid][2], 255);
	PlayerTextDrawFont(playerid, MS_TEXTDRAW[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, MS_TEXTDRAW[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, MS_TEXTDRAW[playerid][2], 0);
	PlayerTextDrawSetSelectable(playerid, MS_TEXTDRAW[playerid][2], true);

	MS_TEXTDRAW[playerid][3] = CreatePlayerTextDraw(playerid, 323.265045, 117.083335, "Welcome!");
	PlayerTextDrawLetterSize(playerid, MS_TEXTDRAW[playerid][3], 0.325252, 1.314165);
	PlayerTextDrawAlignment(playerid, MS_TEXTDRAW[playerid][3], 1);
	PlayerTextDrawColor(playerid, MS_TEXTDRAW[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, MS_TEXTDRAW[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, MS_TEXTDRAW[playerid][3], 1);
	PlayerTextDrawBackgroundColor(playerid, MS_TEXTDRAW[playerid][3], 255);
	PlayerTextDrawFont(playerid, MS_TEXTDRAW[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, MS_TEXTDRAW[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, MS_TEXTDRAW[playerid][3], 0);

	MS_TEXTDRAW[playerid][4] = CreatePlayerTextDraw(playerid, 326.544738, 128.749984, "Click something available to add it to your cart.~n~~n~Press ESC to leave.");
	PlayerTextDrawLetterSize(playerid, MS_TEXTDRAW[playerid][4],0.183540, 0.853331);
	PlayerTextDrawTextSize(playerid, MS_TEXTDRAW[playerid][4], 441.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, MS_TEXTDRAW[playerid][4], 1);
	PlayerTextDrawColor(playerid, MS_TEXTDRAW[playerid][4], -1);
	PlayerTextDrawUseBox(playerid, MS_TEXTDRAW[playerid][4], 1);
	PlayerTextDrawBoxColor(playerid, MS_TEXTDRAW[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, MS_TEXTDRAW[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, MS_TEXTDRAW[playerid][4], 1);
	PlayerTextDrawBackgroundColor(playerid, MS_TEXTDRAW[playerid][4], 255);
	PlayerTextDrawFont(playerid, MS_TEXTDRAW[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, MS_TEXTDRAW[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, MS_TEXTDRAW[playerid][4], 0);

	MS_TEXTDRAW[playerid][5] = CreatePlayerTextDraw(playerid, 429.150970, 163.750000, "EMPTY~n~CART");
	PlayerTextDrawLetterSize(playerid, MS_TEXTDRAW[playerid][5], 0.161990, 0.748332);
	PlayerTextDrawTextSize(playerid, MS_TEXTDRAW[playerid][5], 19.000000, 37.000000);
	PlayerTextDrawAlignment(playerid, MS_TEXTDRAW[playerid][5], 2);
	PlayerTextDrawColor(playerid, MS_TEXTDRAW[playerid][5], MS_COLOR_SYSTEM_ERROR);
	PlayerTextDrawSetShadow(playerid, MS_TEXTDRAW[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, MS_TEXTDRAW[playerid][5], 1);
	//PlayerTextDrawUseBox(playerid, MS_TEXTDRAW[playerid][5], 1);
	PlayerTextDrawBoxColor(playerid, MS_TEXTDRAW[playerid][5], 0x00000000);
	PlayerTextDrawBackgroundColor(playerid, MS_TEXTDRAW[playerid][5], 255);
	PlayerTextDrawFont(playerid, MS_TEXTDRAW[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, MS_TEXTDRAW[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, MS_TEXTDRAW[playerid][5], 0);
	PlayerTextDrawSetSelectable(playerid, MS_TEXTDRAW[playerid][5], true);

	MS_TEXTDRAW[playerid][6] = CreatePlayerTextDraw(playerid, 398.858154, 163.750000, "BUY~n~ITEMS");
	PlayerTextDrawLetterSize(playerid, MS_TEXTDRAW[playerid][6],0.161990, 0.748332);
	PlayerTextDrawTextSize(playerid, MS_TEXTDRAW[playerid][6], 19.000000, 22.000000);
	PlayerTextDrawAlignment(playerid, MS_TEXTDRAW[playerid][6], 2);
	PlayerTextDrawColor(playerid, MS_TEXTDRAW[playerid][6], 0x8388863ff);
	PlayerTextDrawSetShadow(playerid, MS_TEXTDRAW[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, MS_TEXTDRAW[playerid][6], 1);
	//PlayerTextDrawUseBox(playerid, MS_TEXTDRAW[playerid][6], 1);
	PlayerTextDrawBoxColor(playerid, MS_TEXTDRAW[playerid][6], 0x00000000);
	PlayerTextDrawBackgroundColor(playerid, MS_TEXTDRAW[playerid][6], 255);
	PlayerTextDrawFont(playerid, MS_TEXTDRAW[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, MS_TEXTDRAW[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, MS_TEXTDRAW[playerid][6], 0);
	PlayerTextDrawSetSelectable(playerid, MS_TEXTDRAW[playerid][6], true);

	MS_TEXTDRAW[playerid][7] = CreatePlayerTextDraw(playerid, 326.076202, 170.750000, "Cart: ~g~1490$");
	PlayerTextDrawLetterSize(playerid, MS_TEXTDRAW[playerid][7], 0.161990, 0.748332);
	PlayerTextDrawAlignment(playerid, MS_TEXTDRAW[playerid][7], 1);
	PlayerTextDrawColor(playerid, MS_TEXTDRAW[playerid][7], -1);
	PlayerTextDrawSetShadow(playerid, MS_TEXTDRAW[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, MS_TEXTDRAW[playerid][7], 1);
	PlayerTextDrawBackgroundColor(playerid, MS_TEXTDRAW[playerid][7], 255);
	PlayerTextDrawFont(playerid, MS_TEXTDRAW[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, MS_TEXTDRAW[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, MS_TEXTDRAW[playerid][7], 0);
	PlayerTextDrawSetSelectable(playerid, MS_TEXTDRAW[playerid][7], true);
	
	for(new i; i < 8; i++)
	{
		if(i == 8)
			continue;
			
		PlayerTextDrawShow(playerid, MS_TEXTDRAW[playerid][i]);
	}
	
	return 1;
}