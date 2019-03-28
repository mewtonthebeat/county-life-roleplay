#define Function::              stock
#define Callback::%0(%1)        forward %0(%1); public %0(%1)

#define Database::              db_
#define Player::                pla_
#define Weapon::                wep_
#define Deer::                  dee_

////////////////////////////////////////////////////////////////////////////////

new Float:Deer::SpawnPoint[][] = {
    {1736.9283,-228.2461,77.0138,275.1660},
	{1756.2639,-213.8894,80.3944,307.7530},
	{1771.0020,-199.6895,82.1328,331.8799},
	{1771.5106,-188.1960,81.3505,359.1402},
	{1769.0966,-173.9089,79.7304,11.0470},
	{1774.1531,-159.4510,76.0347,339.0867},
	{1769.1353,-142.3570,72.5166,18.5670},
	{1763.0059,-127.1529,69.0724,18.5670},
	{1770.6713,-117.7415,67.1598,313.0797},
	{2045.6492,-279.2924,10.6432,316.2132},
	{2058.6450,-330.7812,43.6357,177.8352},
	{2157.4456,-331.1582,63.7335,291.1699},
	{2587.5798,-234.4534,35.4329,255.5945},
	{2609.6350,-246.8862,39.5814,236.0227},
	{170.2662,-755.5312,33.5532,15.7707},
	{169.3874,-752.4198,33.9930,15.7707},
	{168.6386,-749.7686,34.3677,15.7707},
	{167.6311,-746.2012,34.8719,15.7707},
	{-810.1116,-575.5702,46.9976,15.7707},
	{-810.1116,-575.5702,46.9976,15.7707},
	{-805.7978,-575.5615,46.9825,266.1030},
	{-801.8409,-575.8310,47.0615,266.1030},

	{1736.9283,-229.2461,77.0138,275.1660},
	{1756.2639,-214.8894,80.3944,307.7530},
	{1771.0020,-198.6895,82.1328,331.8799},
	{1771.5106,-187.1960,81.3505,359.1402},
	{1769.0966,-174.9089,79.7304,11.0470},
	{1774.1531,-157.4510,76.0347,339.0867},
	{1769.1353,-143.3570,72.5166,18.5670},
	{1763.0059,-128.1529,69.0724,18.5670},
	{1770.6713,-118.7415,67.1598,313.0797},
	{2045.6492,-278.2924,10.6432,316.2132},
	{2058.6450,-332.7812,43.6357,177.8352},
	{2157.4456,-333.1582,63.7335,291.1699},
	{2587.5798,-233.4534,35.4329,255.5945},
	{2609.6350,-245.8862,39.5814,236.0227},
	{170.2662,-754.5312,33.5532,15.7707},
	{169.3874,-753.4198,33.9930,15.7707},
	{168.6386,-748.7686,34.3677,15.7707},
	{167.6311,-747.2012,34.8719,15.7707},
	{-810.1116,-576.5702,46.9976,15.7707},
	{-810.1116,-577.5702,46.9976,15.7707},
	{-805.7978,-578.5615,46.9825,266.1030},
	{-801.8409,-576.8310,47.0615,266.1030},
	
	{1736.9283,-228.2461,77.0138,275.1660},
	{1756.2639,-213.8894,80.3944,307.7530},
	{1771.0020,-199.6895,82.1328,331.8799},
	{1771.5106,-188.1960,81.3505,359.1402},
	{1769.0966,-173.9089,79.7304,11.0470},
	{1774.1531,-159.4510,76.0347,339.0867},
	{1769.1353,-142.3570,72.5166,18.5670},
	{1763.0059,-127.1529,69.0724,18.5670},
	{1770.6713,-117.7415,67.1598,313.0797},
	{2045.6492,-279.2924,10.6432,316.2132},
	{2058.6450,-330.7812,43.6357,177.8352},
	{2157.4456,-331.1582,63.7335,291.1699},
	{2587.5798,-234.4534,35.4329,255.5945},
	{2609.6350,-246.8862,39.5814,236.0227},
	{170.2662,-755.5312,33.5532,15.7707},
	{169.3874,-752.4198,33.9930,15.7707},
	{168.6386,-749.7686,34.3677,15.7707},
	{167.6311,-746.2012,34.8719,15.7707},
	{-810.1116,-575.5702,46.9976,15.7707},
	{-810.1116,-575.5702,46.9976,15.7707},
	{-805.7978,-575.5615,46.9825,266.1030},
	{-801.8409,-575.8310,47.0615,266.1030},

	{1736.9283,-229.2461,77.0138,275.1660},
	{1756.2639,-214.8894,80.3944,307.7530},
	{1771.0020,-198.6895,82.1328,331.8799},
	{1771.5106,-187.1960,81.3505,359.1402},
	{1769.0966,-174.9089,79.7304,11.0470},
	{1774.1531,-157.4510,76.0347,339.0867},
	{1769.1353,-143.3570,72.5166,18.5670},
	{1763.0059,-128.1529,69.0724,18.5670},
	{1770.6713,-118.7415,67.1598,313.0797},
	{2045.6492,-278.2924,10.6432,316.2132},
	{2058.6450,-332.7812,43.6357,177.8352},
	{2157.4456,-333.1582,63.7335,291.1699},
	{2587.5798,-233.4534,35.4329,255.5945},
	{2609.6350,-245.8862,39.5814,236.0227},
	{170.2662,-754.5312,33.5532,15.7707},
	{169.3874,-753.4198,33.9930,15.7707},
	{168.6386,-748.7686,34.3677,15.7707},
	{167.6311,-747.2012,34.8719,15.7707},
	{-810.1116,-576.5702,46.9976,15.7707},
	{-810.1116,-577.5702,46.9976,15.7707},
	{-805.7978,-578.5615,46.9825,266.1030},
	{-801.8409,-576.8310,47.0615,266.1030},
	
	{1736.9283,-228.2461,77.0138,275.1660},
	{1756.2639,-213.8894,80.3944,307.7530},
	{1771.0020,-199.6895,82.1328,331.8799},
	{1771.5106,-188.1960,81.3505,359.1402},
	{1769.0966,-173.9089,79.7304,11.0470},
	{1774.1531,-159.4510,76.0347,339.0867},
	{1769.1353,-142.3570,72.5166,18.5670},
	{1763.0059,-127.1529,69.0724,18.5670},
	{1770.6713,-117.7415,67.1598,313.0797},
	{2045.6492,-279.2924,10.6432,316.2132},
	{2058.6450,-330.7812,43.6357,177.8352},
	{2157.4456,-331.1582,63.7335,291.1699},
	{2587.5798,-234.4534,35.4329,255.5945},
	{2609.6350,-246.8862,39.5814,236.0227},
	{170.2662,-755.5312,33.5532,15.7707},
	{169.3874,-752.4198,33.9930,15.7707},
	{168.6386,-749.7686,34.3677,15.7707},
	{167.6311,-746.2012,34.8719,15.7707},
	{-810.1116,-575.5702,46.9976,15.7707},
	{-810.1116,-575.5702,46.9976,15.7707},
	{-805.7978,-575.5615,46.9825,266.1030},
	{-801.8409,-575.8310,47.0615,266.1030},

	{1736.9283,-229.2461,77.0138,275.1660},
	{1756.2639,-214.8894,80.3944,307.7530},
	{1771.0020,-198.6895,82.1328,331.8799},
	{1771.5106,-187.1960,81.3505,359.1402},
	{1769.0966,-174.9089,79.7304,11.0470},
	{1774.1531,-157.4510,76.0347,339.0867},
	{1769.1353,-143.3570,72.5166,18.5670},
	{1763.0059,-128.1529,69.0724,18.5670},
	{1770.6713,-118.7415,67.1598,313.0797},
	{2045.6492,-278.2924,10.6432,316.2132},
	{2058.6450,-332.7812,43.6357,177.8352},
	{2157.4456,-333.1582,63.7335,291.1699},
	{2587.5798,-233.4534,35.4329,255.5945},
	{2609.6350,-245.8862,39.5814,236.0227},
	{170.2662,-754.5312,33.5532,15.7707},
	{169.3874,-753.4198,33.9930,15.7707},
	{168.6386,-748.7686,34.3677,15.7707},
	{167.6311,-747.2012,34.8719,15.7707},
	{-810.1116,-576.5702,46.9976,15.7707},
	{-810.1116,-577.5702,46.9976,15.7707},
	{-805.7978,-578.5615,46.9825,266.1030},
	{-801.8409,-576.8310,47.0615,266.1030}
};

#define 	MAX_DEERS           400
#define     BLOCKED_DUE_STEEP   -1

enum {
	DEER_SPECIAL_ACTION_NONE,
	DEER_SPECIAL_ACTION_WALK,
	DEER_SPECIAL_ACTION_RUN,
	DEER_SPECIAL_ACTION_SPRINT,
	DEER_SPECIAL_ACTION_LOOK_AROUND,
	DEER_SPECIAL_ACTION_SHOT,
}

enum deerEnum()
{
	deerenum_ObjectId,
	deerenum_ModelId,
	deerenum_SpecialAction,
	deerenum_Count,
	deerenum_Area,
	deerenum_CarArea,
	Float:deerenum_Health
}

new Iterator:Deer<MAX_DEERS>;
new carDeer[MAX_PLAYERS];
new DeerData[MAX_DEERS][deerEnum];

SpawnDeers()
{
    
	repeat DeerMovement();
	
	for(new x; x < sizeof(Deer::SpawnPoint); x++)
	{
        Deer::Spawn(19315, Deer::SpawnPoint[x][0], Deer::SpawnPoint[x][1], Deer::SpawnPoint[x][2]);
	}

	return 1;
}

Function::  Deer::Spawn(model, Float:x, Float:y, Float:z, Float:health = 100.0)
{

	new w = Iter_Alloc(Deer);

	DeerData[w][deerenum_ObjectId] = CreateDynamicObject(model, x, y, z, 0.0, 0.0, float(random(360)));
 	DeerData[w][deerenum_ModelId] = model;
  	DeerData[w][deerenum_Health] = health;
  	DeerData[w][deerenum_Area] =  CreateDynamicSphere(x, y, z, 7.5);
  	
  	AttachDynamicAreaToObject(DeerData[w][deerenum_Area], DeerData[w][deerenum_ObjectId]);
  	
  	Deer::SetSpecialAction(w, DEER_SPECIAL_ACTION_WALK);

	return 1;
}

Function:: Deer::OnEnterArea(playerid, areaid)
{
    foreach( new w : Deer )
	{
	    if(Deer::GetSpecialAction(x) == DEER_SPECIAL_ACTION_SHOT)
			continue;
	
	    if(areaid == DeerData[w][deerenum_Area])
	    {
	        Deer::SetSpecialAction(w, DEER_SPECIAL_ACTION_SPRINT);
	    }
	    
	    if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleSeat(playerid) == 0&&carDeer[playerid]==-1)
    	{
	        carDeer[playerid]==w;
	    }
	}
	return 0;
}

timer DeerChangeSpecialAction[60000](deerid, action)
{
    Deer::SetSpecialAction(deerid, action);
    return 1;
}

Function:: Deer::MoveRandomly(deerid, forceangle = 0, count = 0)
{

	switch(random(3000))
	{
	    case 3:
	        Deer::SetSpecialAction(deerid, DEER_SPECIAL_ACTION_WALK);
	        
        case 4:
	        Deer::SetSpecialAction(deerid, DEER_SPECIAL_ACTION_RUN);
	        
        case 5:
		{
	        Deer::SetSpecialAction(deerid, DEER_SPECIAL_ACTION_LOOK_AROUND);
	        
	        defer DeerChangeSpecialAction[5000](deerid, DEER_SPECIAL_ACTION_WALK);
		}
	}


	if(Deer::GetSpecialAction(deerid) == DEER_SPECIAL_ACTION_NONE)
	    return 0;
	    
	if(Deer::GetSpecialAction(deerid) == DEER_SPECIAL_ACTION_LOOK_AROUND)
	{
	    new
		    Float:angle = 0,
		    Float:pos[3]
		;

		new angleInt = (random(40000) - 20000);
		angle = (float(angleInt) / 1000.0);

		GetDynamicObjectRot(DeerData[deerid][deerenum_ObjectId], pos[0], pos[1], pos[2]);

		pos[2] += (angle - 90.0);

		SetDynamicObjectRot(DeerData[deerid][deerenum_ObjectId], pos[0], pos[1], pos[2] + 90.0);
		
		return 1;
	}
	
	////////////////////////////////////////////////////////////////////////////

	if(count == 3)
	    return 0;
	    
	if(DeerData[deerid][deerenum_Count] >= 100)
	{
	    OnDeerShot(deerid, -1, -1);
	    return 0;
	}

	new
	    Float:angle = 0,
	    Float:pos[10],
		Float:opos[2]
	;
	
	count ++;

	if(random(30) == 2 || forceangle == 1)
	{
		new angleInt = (random(40000) - 20000);
		
		if(forceangle == 1)
		    angleInt = (random(180000) - 90000);
		
		angle = (float(angleInt) / 1000.0);
	}
	
	GetDynamicObjectPos(DeerData[deerid][deerenum_ObjectId], pos[0], pos[1], pos[2]);
	GetDynamicObjectRot(DeerData[deerid][deerenum_ObjectId], pos[5], pos[4], pos[3]);
	
	opos[0] = pos[0];
	opos[1] = pos[1];
	
	pos[3] += (angle - 90.0);
	
	SetDynamicObjectRot(DeerData[deerid][deerenum_ObjectId], pos[5], pos[4], pos[3] + 90.0);
	
	pos[0] += (0.7 * floatsin(-pos[3], degrees));
	pos[1] += (0.7 * floatcos(-pos[3], degrees));
	
	////////////////////////////////////////////////////////////////////////////
	
	//object check
	
	new verdict = CA_RayCastLine(opos[0], opos[1], pos[2], pos[0], pos[1], pos[2] + 0.6, pos[7], pos[8], pos[9]);
	
	if(verdict != 0)
	{
	
	    DeerData[deerid][deerenum_Count] ++ ;
	
	    OnDeerBlocked(deerid, verdict);
	    Deer::MoveRandomly(deerid, 1, count);
	
	    return 0;
	}
	
	////////////////////////////////////////////////////////////////////////////
	
	//water check
	
	verdict = CA_RayCastLine(opos[0], opos[1], pos[2], pos[0], pos[1], pos[2] - 1.5, pos[7], pos[8], pos[9]);

	if(verdict == WATER_OBJECT)
	{
	
	    DeerData[deerid][deerenum_Count] ++ ;

	    OnDeerBlocked(deerid, verdict);
	    Deer::MoveRandomly(deerid, 1, count);

	    return 0;
	}
	
	////////////////////////////////////////////////////////////////////////////
	    
    CA_FindZ_For2DCoord(pos[0], pos[1], pos[6]);

	if(pos[6] > pos[2] + 1.1 || pos[6] < pos[2] - 1.6)
	{

        DeerData[deerid][deerenum_Count] ++ ;
        OnDeerBlocked(deerid, BLOCKED_DUE_STEEP);
	    Deer::MoveRandomly(deerid, 1, count);
	
	    return 0;
	}
	    
	StopDynamicObject(DeerData[deerid][deerenum_ObjectId]);
	
	DeerData[deerid][deerenum_Count] = 0;
	    
	switch(Deer::GetSpecialAction(deerid))
	{
	    case DEER_SPECIAL_ACTION_WALK:
	        MoveDynamicObject(DeerData[deerid][deerenum_ObjectId], pos[0], pos[1], pos[6] + 0.4, 2, pos[5], pos[4], pos[3] + 90.0);
	        
        case DEER_SPECIAL_ACTION_RUN:
	        MoveDynamicObject(DeerData[deerid][deerenum_ObjectId], pos[0], pos[1], pos[6] + 0.4, 3.5, pos[5], pos[4], pos[3] + 90.0);
	        
		case DEER_SPECIAL_ACTION_SPRINT:
	        MoveDynamicObject(DeerData[deerid][deerenum_ObjectId], pos[0], pos[1], pos[6] + 0.4, 5, pos[5], pos[4], pos[3] + 90.0);
	}


	return 1;
	
}

Function:: Deer::SetSpecialAction(deerid, special_action = DEER_SPECIAL_ACTION_NONE)
{

	DeerData[deerid][deerenum_SpecialAction] = special_action;
	
	return 1;
}

Function:: Deer::GetSpecialAction(deerid)
	return DeerData[deerid][deerenum_SpecialAction];

Callback::OnDeerBlocked(deerid, objectid)
{

	return 1;
}

Callback::OnDeerShot(deerid, playerid, weaponid)
{

	Deer::SetSpecialAction(deerid, DEER_SPECIAL_ACTION_SHOT);
	
	StopDynamicObject(DeerData[deerid][deerenum_ObjectId]);
	
	new
	    Float:pos[3],
	    Float:rot[3]
	;
	
	GetDynamicObjectRot(DeerData[deerid][deerenum_ObjectId], rot[0], rot[1], rot[2]);
	
	if(random(2) == 1)
		SetDynamicObjectRot(DeerData[deerid][deerenum_ObjectId], 90.0, rot[1], rot[2]);
	else
	    SetDynamicObjectRot(DeerData[deerid][deerenum_ObjectId], -90.0, rot[1], rot[2]);
	
	GetDynamicObjectPos(DeerData[deerid][deerenum_ObjectId], pos[0], pos[1], pos[2]);
	SetDynamicObjectPos(DeerData[deerid][deerenum_ObjectId], pos[0], pos[1], pos[2] - 0.27);
	
	if(weaponid != 1500)
	{
		new tmpobjid;

		for(new x, y = 1+random(4); x < y; x++)
		{
		    tmpobjid = CreateDynamicObject(19836, pos[0] + (float(random(2000) - 1000) / 1000), pos[1] + (float(random(2000) - 1000) / 1500), pos[2] - 0.31, 0.0, 0.0, 0.0, -1, -1, -1, 70.0, 65.0);
		    defer DeerRemoveBlood(tmpobjid);
		}
	}
	
	return 1;
}

timer DeerRemoveBlood[30000](bloodid)
{
	DestroyDynamicObject(bloodid);
	return 1;
}

timer DeerMovement[200]()
{

	foreach( new x : Deer )
	{
			
        if(Deer::GetSpecialAction(x) == DEER_SPECIAL_ACTION_SHOT)
			continue;
			
		Deer::MoveRandomly(x);
	
	}
	
	return 1;
}

public OnPlayerShootDynamicObject(playerid, weaponid, objectid, Float:x, Float:y, Float:z)
{

	foreach( new w : Deer )
	{
		if(Deer::GetSpecialAction(w) == DEER_SPECIAL_ACTION_SHOT)
		    continue;
		    
		if(objectid != DeerData[w][deerenum_ObjectId])
		    continue;
			
		OnDeerShot(w, playerid, weaponid);
		
		return 1;
	}

	return 1;
}
