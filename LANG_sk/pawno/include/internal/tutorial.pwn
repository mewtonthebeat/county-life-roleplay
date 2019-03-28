////////////////////////////////////////////////////////////////////////////////

#define     Tutorial::    tut_
#define     MAX_TUTORIAL_ENTRIES        15

#define     MAX_TUTORIAL_NAME_LEN       64
#define     MAX_TUTORIAL_DESC_LEN       512

////////////////////////////////////////////////////////////////////////////////

enum tutorialenum()
{
	Float:tutorial_pos_sX, Float:tutorial_pos_sY, Float:tutorial_pos_sZ,
	Float:tutorial_look_sX, Float:tutorial_look_sY, Float:tutorial_look_sZ,
	
	Float:tutorial_pos_tX, Float:tutorial_pos_tY, Float:tutorial_pos_tZ,
	Float:tutorial_look_tX, Float:tutorial_look_tY, Float:tutorial_look_tZ,
	
	tutorial_CameraTime,
	tutorial_Color,
	
	tutorial_Name[MAX_TUTORIAL_NAME_LEN],
	tutorial_Desc[MAX_TUTORIAL_DESC_LEN]
}

new Tutorial::enum[MAX_TUTORIAL_ENTRIES][tutorialenum];
new Tutorial::biggestid=0;
new Tutorial::lastentry = -1;
new Iterator:Tutorial<MAX_TUTORIAL_ENTRIES>;
new PlayerText:TUTORIAL_PTD[MAX_PLAYERS][6];

////////////////////////////////////////////////////////////////////////////////

Tutorial::AddEntry(name[])
{
	Tutorial::lastentry = -1;
	Tutorial::lastentry = Iter_Alloc(Tutorial);
	
	
	
	if(Tutorial::lastentry < 0)
	    return 0;
	    
	if(Tutorial::biggestid < Tutorial::lastentry)
	    Tutorial::biggestid = Tutorial::lastentry;

	format(Tutorial::enum[Tutorial::lastentry][tutorial_Name], MAX_TUTORIAL_NAME_LEN, name);
	Tutorial::enum[Tutorial::lastentry][tutorial_Color] = -2147483393;
	
	return 1;
}

Tutorial::SetDescription(desc[])
{
	if(Tutorial::lastentry < 0)
	    return 0;

    format(Tutorial::enum[Tutorial::lastentry][tutorial_Desc], MAX_TUTORIAL_DESC_LEN, desc);
	return 1;
}

Tutorial::SetColor(color)
{
	if(Tutorial::lastentry < 0)
	    return 0;

    Tutorial::enum[Tutorial::lastentry][tutorial_Color] = color;
	return 1;
}

Tutorial::SetCameraPos(Float:startX, Float:startY, Float:startZ, Float:targetX, Float:targetY, Float:targetZ)
{

    if(Tutorial::lastentry < 0)
	    return 0;

	Tutorial::enum[Tutorial::lastentry][tutorial_pos_sX]    = startX;
	Tutorial::enum[Tutorial::lastentry][tutorial_pos_sY]    = startY;
	Tutorial::enum[Tutorial::lastentry][tutorial_pos_sZ]    = startZ;

	Tutorial::enum[Tutorial::lastentry][tutorial_pos_tX]    = targetX;
	Tutorial::enum[Tutorial::lastentry][tutorial_pos_tY]    = targetY;
	Tutorial::enum[Tutorial::lastentry][tutorial_pos_tZ]    = targetZ;

	return 1;
}

Tutorial::SetCameraLook(Float:startX, Float:startY, Float:startZ, Float:targetX, Float:targetY, Float:targetZ)
{

    if(Tutorial::lastentry < 0)
	    return 0;

	Tutorial::enum[Tutorial::lastentry][tutorial_look_sX]    = startX;
	Tutorial::enum[Tutorial::lastentry][tutorial_look_sY]    = startY;
	Tutorial::enum[Tutorial::lastentry][tutorial_look_sZ]    = startZ;

	Tutorial::enum[Tutorial::lastentry][tutorial_look_tX]    = targetX;
	Tutorial::enum[Tutorial::lastentry][tutorial_look_tY]    = targetY;
	Tutorial::enum[Tutorial::lastentry][tutorial_look_tZ]    = targetZ;

	return 1;
}

Tutorial::SetCameraTime(time)
{

    if(Tutorial::lastentry < 0)
	    return 0;

	Tutorial::enum[Tutorial::lastentry][tutorial_CameraTime]    = time;

	return 1;
}

////////////////////////////////////////////////////////////////////////////////

new bool:Tutorial::ison[MAX_PLAYERS];
new bool:Tutorial::spawning[MAX_PLAYERS];
new Tutorial::index[MAX_PLAYERS];

Tutorial::TurnOn(playerid)
{

	Tutorial::ison[playerid] 	= true;
	Tutorial::spawning[playerid]= false;
	isSpectating[playerid]      = true;
	Tutorial::index[playerid] 	= 0;
	
	SelectTextDraw(playerid, -858993409);
	
	Tutorial::CreateTextdraws(playerid);
	Tutorial::Update(playerid, 0);

	return 1;
}

Tutorial::TurnOff(playerid)
{

    Tutorial::ison[playerid] 	= false;
	Tutorial::spawning[playerid]= true;
	Tutorial::index[playerid] 	= 0;
	
	Tutorial::DestroyTextdraws(playerid);
	CancelSelectTextDraw(playerid);
	
	TogglePlayerSpectating(playerid, false);

	return 1;
}

Tutorial::Update(playerid, indexmultiplier)
{

	if(Tutorial::ison[playerid] == false)
	    return 0;
	    
	if(Tutorial::index[playerid] + indexmultiplier < 0)
	    return 0;
	    
    if(Tutorial::index[playerid] + indexmultiplier > Tutorial::biggestid)
	    return -1;
	    
	Tutorial::index[playerid] += indexmultiplier;
	
	PlayerTextDrawColor(playerid, TUTORIAL_PTD[playerid][1], Tutorial::enum[Tutorial::index[playerid]][tutorial_Color]);
	PlayerTextDrawSetString(playerid, TUTORIAL_PTD[playerid][1], Tutorial::enum[Tutorial::index[playerid]][tutorial_Name]);
	PlayerTextDrawSetString(playerid, TUTORIAL_PTD[playerid][2], Tutorial::enum[Tutorial::index[playerid]][tutorial_Desc]);
	
	PlayerTextDrawShow(playerid, TUTORIAL_PTD[playerid][0]);
	PlayerTextDrawShow(playerid, TUTORIAL_PTD[playerid][1]);
	PlayerTextDrawShow(playerid, TUTORIAL_PTD[playerid][2]);
	PlayerTextDrawShow(playerid, TUTORIAL_PTD[playerid][3]);
	PlayerTextDrawShow(playerid, TUTORIAL_PTD[playerid][4]);
	PlayerTextDrawShow(playerid, TUTORIAL_PTD[playerid][5]);
	
	InterpolatePlayerCamera(
	    playerid,
	    Tutorial::enum[Tutorial::index[playerid]][tutorial_pos_sX], Tutorial::enum[Tutorial::index[playerid]][tutorial_pos_sY], Tutorial::enum[Tutorial::index[playerid]][tutorial_pos_sZ],
	    Tutorial::enum[Tutorial::index[playerid]][tutorial_look_sX], Tutorial::enum[Tutorial::index[playerid]][tutorial_look_sY], Tutorial::enum[Tutorial::index[playerid]][tutorial_look_sZ],
	    
	    Tutorial::enum[Tutorial::index[playerid]][tutorial_pos_tX], Tutorial::enum[Tutorial::index[playerid]][tutorial_pos_tY], Tutorial::enum[Tutorial::index[playerid]][tutorial_pos_tZ],
	    Tutorial::enum[Tutorial::index[playerid]][tutorial_look_tX], Tutorial::enum[Tutorial::index[playerid]][tutorial_look_tY], Tutorial::enum[Tutorial::index[playerid]][tutorial_look_tZ],
	    
	    Tutorial::enum[Tutorial::index[playerid]][tutorial_CameraTime]
	);
	
	return 1;
}

Tutorial::DestroyTextdraws(playerid)
{
	PlayerTextDrawDestroy(playerid, TUTORIAL_PTD[playerid][0]);
	PlayerTextDrawDestroy(playerid, TUTORIAL_PTD[playerid][1]);
	PlayerTextDrawDestroy(playerid, TUTORIAL_PTD[playerid][2]);
	PlayerTextDrawDestroy(playerid, TUTORIAL_PTD[playerid][3]);
	PlayerTextDrawDestroy(playerid, TUTORIAL_PTD[playerid][4]);
	PlayerTextDrawDestroy(playerid, TUTORIAL_PTD[playerid][5]);
	return 1;
}

Tutorial::CreateTextdraws(playerid)
{

    TUTORIAL_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 195.143157, 393.333221, "box");
	PlayerTextDrawLetterSize(playerid, TUTORIAL_PTD[playerid][0], 0.000000, 14.723814);
	PlayerTextDrawTextSize(playerid, TUTORIAL_PTD[playerid][0], 454.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, TUTORIAL_PTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, TUTORIAL_PTD[playerid][0], -1);
	PlayerTextDrawUseBox(playerid, TUTORIAL_PTD[playerid][0], 1);
	PlayerTextDrawBoxColor(playerid, TUTORIAL_PTD[playerid][0], 150);
	PlayerTextDrawSetShadow(playerid, TUTORIAL_PTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, TUTORIAL_PTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, TUTORIAL_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, TUTORIAL_PTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, TUTORIAL_PTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, TUTORIAL_PTD[playerid][0], 0);

	TUTORIAL_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 204.666641, 395.893218, "_");
	PlayerTextDrawLetterSize(playerid, TUTORIAL_PTD[playerid][1], 0.380190, 1.536000);
	PlayerTextDrawAlignment(playerid, TUTORIAL_PTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, TUTORIAL_PTD[playerid][1], -2147483393);
	PlayerTextDrawSetShadow(playerid, TUTORIAL_PTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, TUTORIAL_PTD[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, TUTORIAL_PTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, TUTORIAL_PTD[playerid][1], 3);
	PlayerTextDrawSetProportional(playerid, TUTORIAL_PTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, TUTORIAL_PTD[playerid][1], 0);

	TUTORIAL_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 325.047668, 411.253204, "_");
	PlayerTextDrawLetterSize(playerid, TUTORIAL_PTD[playerid][2], 0.195047, 0.853333);
	PlayerTextDrawTextSize(playerid, TUTORIAL_PTD[playerid][2], 0.000000, 245.000000);
	PlayerTextDrawAlignment(playerid, TUTORIAL_PTD[playerid][2], 2);
	PlayerTextDrawColor(playerid, TUTORIAL_PTD[playerid][2], -1);
	PlayerTextDrawUseBox(playerid, TUTORIAL_PTD[playerid][2], 1);
	PlayerTextDrawBoxColor(playerid, TUTORIAL_PTD[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, TUTORIAL_PTD[playerid][2], 1);
	PlayerTextDrawSetOutline(playerid, TUTORIAL_PTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, TUTORIAL_PTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, TUTORIAL_PTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, TUTORIAL_PTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, TUTORIAL_PTD[playerid][2], 1);

	TUTORIAL_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 409.380981, 398.439971, "ld_beat:left");
	PlayerTextDrawLetterSize(playerid, TUTORIAL_PTD[playerid][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TUTORIAL_PTD[playerid][3], 12.000000, 12.000000);
	PlayerTextDrawAlignment(playerid, TUTORIAL_PTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, TUTORIAL_PTD[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, TUTORIAL_PTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, TUTORIAL_PTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, TUTORIAL_PTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, TUTORIAL_PTD[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, TUTORIAL_PTD[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, TUTORIAL_PTD[playerid][3], 0);
	PlayerTextDrawSetSelectable(playerid, TUTORIAL_PTD[playerid][3], true);

	TUTORIAL_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 423.095214, 398.439971, "ld_beat:right");
	PlayerTextDrawLetterSize(playerid, TUTORIAL_PTD[playerid][4], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TUTORIAL_PTD[playerid][4], 12.000000, 12.000000);
	PlayerTextDrawAlignment(playerid, TUTORIAL_PTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, TUTORIAL_PTD[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, TUTORIAL_PTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, TUTORIAL_PTD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, TUTORIAL_PTD[playerid][4], 255);
	PlayerTextDrawFont(playerid, TUTORIAL_PTD[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, TUTORIAL_PTD[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, TUTORIAL_PTD[playerid][4], 0);
	PlayerTextDrawSetSelectable(playerid, TUTORIAL_PTD[playerid][4], true);

	TUTORIAL_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 438.571472, 395.039855, "_");
	PlayerTextDrawUseBox(playerid, TUTORIAL_PTD[playerid][5], 1);
	PlayerTextDrawBoxColor(playerid, TUTORIAL_PTD[playerid][5], 0x00000000);
	PlayerTextDrawLetterSize(playerid, TUTORIAL_PTD[playerid][5], 0.436571, 1.642666);
	PlayerTextDrawTextSize(playerid, TUTORIAL_PTD[playerid][5], 13.000000, 13.000000);
	PlayerTextDrawAlignment(playerid, TUTORIAL_PTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, TUTORIAL_PTD[playerid][5], -1523963137);
	PlayerTextDrawSetShadow(playerid, TUTORIAL_PTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, TUTORIAL_PTD[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, TUTORIAL_PTD[playerid][5], 255);
	PlayerTextDrawFont(playerid, TUTORIAL_PTD[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, TUTORIAL_PTD[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, TUTORIAL_PTD[playerid][5], 0);
	PlayerTextDrawSetSelectable(playerid, TUTORIAL_PTD[playerid][5], true);

	return 1;
}
