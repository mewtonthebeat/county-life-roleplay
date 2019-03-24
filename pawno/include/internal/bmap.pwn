#include <a_samp>

//////////////////////////////

#define     BMap::          bmap_

//////////////////////////////

new bmap_currentMap[ MAX_PLAYERS ];
new bmap_tempMap[ MAX_PLAYERS ];

//////////////////////////////

stock BMap::SwitchTo(playerid, mapid)
{
	bmap_currentMap			[playerid] = mapid;
	return (1);
}

stock BMap::GetMap(playerid)
	return bmap_currentMap[playerid];

//////////////////////////////
