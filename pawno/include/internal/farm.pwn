/*
	* Farm::CreateProperty( string Name, string Owner = "", int BuyPrice, float X, float Y, float Z, float pMinX, float pMinY, float pMaxX, float pMaxY )
	    - vytvori property farmy na urcitej lokacii, s urcitym menom a pripadne majitelom nacitanym z databazi
	    
	* Farm::DestroyProperty( int farmId )
	    - zmaze property farmy na zaklade id farmy
	    
	* Farm::RetrieveLabelString( int farmId )
	    - returnuje label prislusny k danej property na zaklade jej dat
	    
	* Farm::ReturnStandingProperty( int playerid )
		- returnuje id farmy pri ktorej aktualne hrac stoji
*/

////////////////////////////////////////////////////////////////////////////////

#if !defined INVALID_MAP_ICON_MODEL
	#define INVALID_MAP_ICON_MODEL  		-255
#endif

#define         Farm::          			farm_

#define         MAX_FARM_PROPERTIES     	5
#define         MAX_FARM_NAME_LEN       	64
#define         MAX_FARM_LABEL_LEN          128
#define         FARM_MAP_ICON_MODEL     	31      // green house map icon
#define         FARM_LABEL_COLOR            0x7FB758FF

#define         FARM_AREA_SIZE              4.0
#define         FARM_PICKUP_STREAM_DIST 	75.0
#define         FARM_MAPICON_STREAM_DIST    300.0
#define         FARM_LABEL_STREAM_DIST      12.5

#define         INVALID_FARM_ID         	-1

////////////////////////////////////////////////////////////////////////////////

enum Farm::primaryData()
{
	farm_Name[ MAX_FARM_NAME_LEN ],
	farm_Owner[ MAX_PLAYER_NAME + 1 ],

	farm_BuyPrice,

	Float:farm_X, Float:farm_Y, Float:farm_Z,
	
	Float:farm_Property_MinX, Float:farm_Property_MinY,
	Float:farm_Property_MaxX, Float:farm_Property_MaxY,

    farm_AreaId,
	farm_PickupId,
	farm_MapIconId,
	Text3D:farm_LabelId
}

////////////////////////////////////////////////////////////////////////////////

new Iterator:Farm< MAX_FARM_PROPERTIES >;
new Farm::data[MAX_FARM_PROPERTIES][ Farm::primaryData ];

////////////////////////////////////////////////////////////////////////////////

Farm::CreateProperty(Name[], Owner[], BuyPrice, Float:X, Float:Y, Float:Z, Float:pMinX = 0.0, Float:pMinY = 0.0, Float:pMaxX = 0.0, Float:pMaxY = 0.0)
{

	new
	    farmId = INVALID_FARM_ID
	;
	
	farmId = Iter_Alloc(Farm);
	
	if(farmId == INVALID_FARM_ID)
	{
	    printf(
			"[ERROR]: Could not create farm named '%s', all slots are occupied!",
			farm_Name
		);
		
	    return (0);
	}
	
	////////////////////////////////////////////////////////////////////////////
	
	format(Farm::data[ farmId ][ farm_Name ], MAX_FARM_NAME_LEN, Name);
	format(Farm::data[ farmId ][ farm_Owner], MAX_PLAYER_NAME + 1, Owner);
	
	Farm::data[ farmId ][ farm_BuyPrice ]   = BuyPrice;
	
	Farm::data[ farmId ][ farm_X ]      	= X;
	Farm::data[ farmId ][ farm_Y ]      	= Y;
	Farm::data[ farmId ][ farm_Z ]      	= Z;
	
	Farm::data[ farmId ][ farm_Property_MinX]   = pMinX;
	Farm::data[ farmId ][ farm_Property_MinY]   = pMinY;
	
	Farm::data[ farmId ][ farm_Property_MaxX]   = pMaxX;
	Farm::data[ farmId ][ farm_Property_MaxY]   = pMaxY;
	
	////////////////////////////////////////////////////////////////////////////

	Farm::data[ farmId ][ farm_AreaId ]     = CreateDynamicSphere(X, Y, Z, FARM_AREA_SIZE, 0, 0, -1);
	Farm::data[ farmId ][ farm_PickupId ]   = CreateDynamicPickup(FARM_PICKUP_MODEL, 1, X, Y, Z, 0, 0, -1, FARM_PICKUP_STREAM_DIST, -1, 1);
	
	if(FARM_MAP_ICON_MODEL != INVALID_MAP_ICON_MODEL)
		Farm::data[ farmId ][ farm_MapIconId ]  = CreateDynamicMapIcon(X, Y, Z, FARM_MAP_ICON_MODEL, 0xFFFFFFFF, 0, 0, -1, FARM_MAPICON_STREAM_DIST, MAPICON_LOCAL, -1, 1);
		
	Farm::data[ farmId ][ farm_LabelId]     = CreateDynamic3DTextLabel(Farm::RetrieveLabelString(farmId), FARM_LABEL_COLOR, X, Y, Z + 0.5, FARM_LABEL_STREAM_DIST, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0, -1, FARM_LABEL_STREAM_DIST, -1, 1);
	
	return (1);
}

Farm::DestroyProperty(farmId)
{

	Farm::data[ farmId ][ farm_Name ][0]	= EOS;
	Farm::data[ farmId ][ farm_Owner ][0]	= EOS;

	Farm::data[ farmId ][ farm_X ]      	= 0.0;
	Farm::data[ farmId ][ farm_Y ]      	= 0.0;
	Farm::data[ farmId ][ farm_Z ]      	= 0.0;

	////////////////////////////////////////////////////////////////////////////

	DestroyDynamicArea(Farm::data[ farmId ][ farm_AreaId ]);
	DestroyDynamicPickup(Farm::data[ farmId ][ farm_PickupId ]);
	
	if(FARM_MAP_ICON_MODEL != INVALID_MAP_ICON_MODEL)
	    DestroyDynamicMapIcon(Farm::data[ farmId ][ farm_MapIconId ]);

	DestroyDynamic3DTextLabel(Farm::data[ farmId ][ farm_LabelId ]);
	
	////////////////////////////////////////////////////////////////////////////

	Iter_Remove(farmId, Farm);

	return (1);
}

Farm::RetrieveLabelString(farmId)
{

	new
	    tmpvar[ MAX_FARM_LABEL_LEN ]
	;
	
	if(strlen( Farm::data[ farmId ][ farm_Owner ] ) > 0)
	{
		format(
			tmpvar, sizeof tmpvar,
			"[ FARM ]\n{EAEAEA}%s",

			Farm::data[ farmId ][ farm_Name ]
		);
	}
	else if(Farm::data[ farmId ][ farm_BuyPrice ] > 0)
	{
	    format(
			tmpvar, sizeof tmpvar,
			"[ FARM ]\n{EAEAEA}%s\n({679646}$%d{EAEAEA})\n\nFOR SALE!\n/buyfarm",

			Farm::data[ farmId ][ farm_Name ],
			Farm::data[ farmId ][ farm_BuyPrice]
		);
	}
	else
	{
	    format(
			tmpvar, sizeof tmpvar,
			"[ FARM ]\n{EAEAEA}%s",

			Farm::data[ farmId ][ farm_Name ]
		);
	}

	return tmpvar;
}

Farm::ReturnStandingProperty(playerid)
{
	new
	    farmId = INVALID_FARM_ID
	;
	
	foreach( new x : Farm )
	{
	    if(!IsPlayerInDynamicArea(playerid, Farm::data[ x ][ farm_AreaId ], 0)) continue;
	    farmId = x;
	    break;
	}
	
	return farmId;
}
