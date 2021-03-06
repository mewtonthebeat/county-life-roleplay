/*
 * Artificial intelligence
 * by Dayvison Balmant
 * 
 * Responsavel pela cria�ao de AI's


## Changelog:
> - ### 0.1.0 `03/06/2017`
>     + Configura�oes do AI
>     + API FCNPC
>     + Fun�oes de setup criadas

## API:
 * **Definitions:**
 	- INVALID_AI_ID
 	- INVALID_MOVE_TYPE
 * **Callbacks:**
 	- AI_OnCreate
 	- AI_OnDestroy
 	- AI_OnSpawn
 	- AI_OnRespawn
 	- AI_OnDeath
 * **Enums:**
 	- AIPosture
 * **Tags:**
 	- 
 * **Functions:**
 	- FCNPC_IsAI
 	- FCNPC_GetAIID
 	- AI_Create
 	- AI_CreateEX
 	- AI_IsValid
 	- AI_Destroy
 	- AI_Spawn
 	- AI_IsSpawned
 	- AI_Respawn
 	- AI_GetFCNPCID
	- AI_SetPosture
	- AI_GetPosture
	- AI_SetMoveInfo
	- AI_GetMoveInfo
	- AI_SetMoveType
	- AI_GetMoveType
	- AI_SetMoveSpeed
	- AI_GetMoveSpeed
	- AI_ToggleUseMapAndreas
	- AI_IsMapAndreasUsed
	- AI_ToggleUseColAndreas
	- AI_IsColAndreasUsed
	- AI_ToggleSetAngle
	- AI_IsSetAngle
	- AI_SetRadius
	- AI_GetRadius
	- AI_SetPrecision
	- AI_GetPrecision
	- AI_SetStrength
	- AI_GetStrength
 * **Variables:**
	- 
 * **Commands:**
 	- 
 * **Macros:**
 	- 

## Internal:
 * **Callbacks:**
 	- @AI_IterClear
	- FCNPC_OnSpawn
	- FCNPC_OnRespawn
	- FCNPC_OnDeath
	- OnScriptInit
	- @AI_OnTick
	- OnPlayerEnterDynArea
	- OnPlayerLeaveDynArea
	- @ai_func_in
 * **Enums:**
 	- E_AI_DATA
 * **Tags:**
 	- 
 * **Functions:**
 	- 
 * **Variables:**
	- AI_Data
 * **Macros:**
 	- 

## Configuration:
 * MAX_AI_NAME
 * MAX_AIS
 * AI_QUIET
 * AI_DEFAULT_TYPE
 * AI_DEFAULT_MOVE_SPEED
 * AI_DEFAULT_USEMAPANDREAS
 * AI_DEFAULT_USECOLANDREAS
 * AI_DEFAULT_SETANGLE
 * AI_DEFAULT_RADIUS
 * AI_DEFAULT_PRECISION
 * AI_DEFAULT_STRENGTH
 * AI_DEFAULT_PATHID
 * AI_DEFAULT_RANGE
 * AI_DEFAULT_CHECKOBSTACLES
 * AI_DEFAULT_CHECKVISION
 * AI_DEFAULT_POSTURE
 * AI_DEFAULT_ANGLE
 * AI_DEFAULT_VIRTUAL_WORLD
 * AI_DEFAULT_INTERIOR
 * DEFAULT_AI_TICK_RATE
*/

#if defined _AI_core_inc
 	#endinput
#endif
#define _AI_core_inc

#define __linux
#include <a_samp>

/*================================================
=  ___  ____ ____ _ _  _ _ ___ _ ____ _  _ ____  =
=  |  \ |___ |___ | |\ | |  |  | |  | |\ | [__   =
=  |__/ |___ |    | | \| |  |  | |__| | \| ___]  =
=                                                =
*================================================*/

#if !defined MAX_AI_NAME
	#define MAX_AI_NAME MAX_PLAYER_NAME
#endif

#if !defined MAX_AIS
	#define MAX_AIS (32)
#endif

const AI:INVALID_AI_ID = AI:-1;
#define INVALID_MOVE_TYPE -10
#define AI_STREAMER_IDENTIFIER 3657982

#if !defined AI_QUIET
	#define AI_Error(%0) printf("[AI error]: "%0)
	#define AI_Warning(%0) printf("[AI warning]: "%0)
#else
	#define AI_Error(%0)
	#define AI_Warning(%0)
#endif

#if !defined AI_DEFAULT_MOVE_TYPE
	#define AI_DEFAULT_MOVE_TYPE           (MOVE_TYPE_AUTO)
#endif

#if !defined AI_DEFAULT_MOVE_SPEED
	#define AI_DEFAULT_MOVE_SPEED          (MOVE_SPEED_AUTO)
#endif

#if !defined AI_DEFAULT_USEMAPANDREAS
	#define AI_DEFAULT_USEMAPANDREAS  (false)
#endif

#if !defined AI_DEFAULT_USECOLANDREAS
	#define AI_DEFAULT_USECOLANDREAS  (true)
#endif

#if !defined AI_DEFAULT_SETANGLE
	#define AI_DEFAULT_SETANGLE       (true)
#endif

#if !defined AI_DEFAULT_RADIUS
	#define AI_DEFAULT_RADIUS         (0.0)
#endif

#if !defined AI_DEFAULT_PRECISION
	#define AI_DEFAULT_PRECISION      (85.0)
#endif

#if !defined AI_DEFAULT_STRENGTH
	#define AI_DEFAULT_STRENGTH       (5.0)
#endif

#if !defined AI_DEFAULT_PATHID
	#define AI_DEFAULT_PATHID         (0)
#endif

#if !defined AI_DEFAULT_RANGE
	#define AI_DEFAULT_RANGE          (30.0)
#endif

#if !defined AI_DEFAULT_CHECKOBSTACLES
	#define AI_DEFAULT_CHECKOBSTACLES (true)
#endif

#if !defined AI_DEFAULT_CHECKVISION
	#define AI_DEFAULT_CHECKVISION    (true)
#endif

#if !defined AI_DEFAULT_POSTURE
	#define AI_DEFAULT_POSTURE        (POSTURE_PASSIVE)
#endif

#if !defined AI_DEFAULT_ANGLE
	#define AI_DEFAULT_ANGLE        (0.0)
#endif

#if !defined AI_DEFAULT_VIRTUAL_WORLD
	#define AI_DEFAULT_VIRTUAL_WORLD        (0)
#endif

#if !defined AI_DEFAULT_INTERIOR
	#define AI_DEFAULT_INTERIOR        (0)
#endif

#if !defined DEFAULT_AI_TICK_RATE
	#define DEFAULT_AI_TICK_RATE        (1000)
#endif


/*================================================
=             ____ ____ ___ _  _ ___             =
=             [__  |___  |  |  | |__]            =
=             ___] |___  |  |__| |               =
=                                                =
*================================================*/
/// Postura adotada pelo AI
enum AIPosture {
	POSTURE_INVALID = -1,/// Postura inv�lida
	POSTURE_NONE,        /// Nenhum, nao faz nada, mesmo que receba dano
	POSTURE_AGGRESSIVE,  /// Agressivo, ataca qualquer um pr�ximo, continua perseguindo o objetivo a qualquer dist�ncia
	POSTURE_PASSIVE,     /// Passivo, apenas reaje caso sofra amea�a, pode perseguir objetivo por uma curta dist�ncia
	POSTURE_DEFENSIVE    /// Defensivo, ataca quem invade sua zona, por�m guarda sua posi�ao
};

/// Estrutura de dados dos AI's
static enum E_AI_DATA {
	AI_FCNPCID,                  /// ID recebido pelo FCNPC
	string:AI_Name[MAX_AI_NAME], /// Nome

	// Movimento
	AI_MoveType,                 /// Movimento executado pelo AI (MOVE_TYPE_AUTO, MOVE_TYPE_WALK, MOVE_TYPE_RUN, MOVE_TYPE_SPRINT, MOVE_TYPE_DRIVE)
	Float:AI_MoveSpeed,          /// Velocidade de movimento do AI (MOVE_SPEED_AUTO, MOVE_SPEED_WALK, MOVE_SPEED_RUN, MOVE_SPEED_SPRINT)
	bool:AI_UseMapAndreas,       /// Se ir� usar a corre�ao do eixo Z com MapAndreas oferecido pelo plugin FCNPC ao movimentar
	bool:AI_UseColAndreas,       /// Se ir� usar a corre�ao do eixo Z com ColAndreas feito em pawn
	bool:AI_SetAngle,            /// Se o FCNPC ir� corrigir o angulo do AI, quando ele se movimentar
	Float:AI_Radius,             /// Quando for instruido o AI a se movimentar, caso a nova posi�ao esteja neste raio a a�ao ser� ignorada

	// Combate
	Float:AI_Precision,          /// Taxa de acertos dos tiros(0, a 100%)
	Float:AI_Strength,           /// For�a do NPC, ataques fisicos(Valor do dano)

	// Caminho/Detec�ao
	AI_Pathid,                   /// Caminho para o NPC percorrer criado com FCNPC_CreateMovePath
	Float:AI_Range,              /// Area de detec�ao de um objetivo pelo NPC(Streamer_Area)
	bool:AI_CheckObstacles,      /// Se para detec�ao de um objetivo, ir� usar ColAndreas para checar se existe obst�culos no seu caminho, impossibilitando o AI de alcan�ar o objetivo
	bool:AI_CheckVision,         /// Se para detec�ao de um objetivo, ir� checar se o objetivo � visto pelo AI (IsElementOnFakeScreen)
	//AI_Solutions[AISolution],    /// Solu�oes autom�ticas para problemas encontrados durante a persegui�ao de um objetivo
	
	AIPosture:AI_Posture,        /// Postura adotada pelo AI [AIPosture](#AIPosture)
	
	// Status
	Float:AI_Health,             /// Vida padrao do AI ao se spawnar
	Float:AI_Armour,             /// Colete padrao do AI ao se spawnar


	STREAMER_TAG_AREA AI_DynArea
	// Objetivos
};


static
	AI_Data[AI:MAX_AIS][E_AI_DATA], /// Dados dos AI's
	AI:FCNPC_AIID[MAX_PLAYERS] = {INVALID_AI_ID,INVALID_AI_ID,...}            /// ID 
;

new
	Iterator:AIs<MAX_AIS>,                     /// AI's criados
	Iterator:PlayerAIs<MAX_PLAYERS, MAX_AIS>,  /// AI's seguindo o player
	Iterator:AIsPlayers<MAX_AIS, MAX_PLAYERS>  /// Players na �rea de detec�ao do AI
;

static AI_TickRate = DEFAULT_AI_TICK_RATE;

/**
 * Chamada quando um AI acaba de ser criado
 *
 * @param      id    ID do AI
 *
 * @date       23:13 02/06/2017
 * @author     Dayvison
 *
 * @return     --
 */
forward AI_OnCreate(AI:id);

/**
 * Chamada quando um AI acaba de ser destruido
 *
 * @param      id    ID do AI
 *
 * @date       23:14 02/06/2017
 * @author     Dayvison
 *
 * @return     --
 */
forward AI_OnDestroy(AI:id);

/**
 * Chamada quando um AI acaba de se spawna
 *
 * @param      id    ID do AI
 *
 * @date       23:14 02/06/2017
 * @author     Dayvison
 *
 * @return     --
 */
forward AI_OnSpawn(AI:id);

/**
 * Chamada quando um AI acaba de se respawna
 *
 * @param      id    ID do AI
 *
 * @date       23:15 02/06/2017
 * @author     Dayvison
 *
 * @return     --
 */
forward AI_OnRespawn(AI:id);

/**
 * Chamada quando um AI acaba de morrer
 *
 * @param      id        ID do AI
 * @param      killerid  ID do assassino
 * @param      weaponid  ID da arma/rasao do assassinato
 *
 * @date       23:15 02/06/2017
 * @author     Dayvison
 *
 * @return     --
 */
forward AI_OnDeath(AI:id, killerid, weaponid);


// Evitar avisos de for�ar tag
forward AI:FCNPC_GetAIID(npcid);
forward AI:AI_Create(string:name[MAX_AI_NAME]);
forward AI:AI_CreateEX(
	string:name[MAX_AI_NAME],
	movetype              = AI_DEFAULT_MOVE_TYPE,
	Float:movespeed       = AI_DEFAULT_MOVE_SPEED,
	bool:useMapAndreas    = AI_DEFAULT_USEMAPANDREAS,
	bool:useColAndreas    = AI_DEFAULT_USECOLANDREAS,
	bool:setAngle         = AI_DEFAULT_SETANGLE,
	Float:radius          = AI_DEFAULT_RADIUS,
	Float:precision       = AI_DEFAULT_PRECISION,
	Float:strength        = AI_DEFAULT_STRENGTH,
	pathid                = AI_DEFAULT_PATHID,
	Float:range           = AI_DEFAULT_RANGE,
	bool:checkObstacles   = AI_DEFAULT_CHECKOBSTACLES,
	bool:checkVision      = AI_DEFAULT_CHECKVISION,
	//solutions[AISolution] = AI_DEFAULT_SOLUTIONS,
	AIPosture:posture     = AI_DEFAULT_POSTURE
);
forward AIPosture:AI_GetPosture(AI:id);
forward Float:AI_GetMoveSpeed(AI:id);
forward bool:AI_IsMapAndreasUsed(AI:id);
forward bool:AI_IsColAndreasUsed(AI:id);
forward bool:AI_IsSetAngle(AI:id);
forward Float:AI_GetRadius(AI:id);
forward Float:AI_GetPrecision(AI:id);
forward Float:AI_GetStrength(AI:id);

/*================================================
=    ____ _  _ _  _ ____ ___ _ ____ _  _ ____    =
=    |___ |  | |\ | |     |  | |  | |\ | [__     =
=    |    |__| | \| |___  |  | |__| | \| ___]    =
=                                                =
*================================================*/

/**
 * Determina se um FCNPC foi criado pelo API de AI
 *
 * @param      npcid  ID do npc
 *
 * @date       22:38 02/06/2017
 * @author     Dayvison
 *
 * @return     - `1` Foi criado pelo AI
 *             - `0` Nao foi criado pelo AI ou caso ocorra algum erro:
 *                 + ID inv�lido
 */
stock FCNPC_IsAI(npcid)
{
	// ID inv�lido
	if(!(0 <= npcid < MAX_PLAYERS))
		return 0;

	// FCNPC nao existe
	if(FCNPC_IsValid(npcid))
		return 0;

	return (FCNPC_AIID[npcid] != INVALID_AI_ID);
}

/**
 * Obt�m o ID do AI de pelo ID do NPC
 *
 * @param      npcid  ID do npc
 *
 * @date       22:41 02/06/2017
 * @author     Dayvison
 *
 * @return     - `ID do AI` Sucesso
 *             - `INVALID_AI_ID` caso ocorra algum erro:
 *                 + ID inv�lido
 *                 + FCNPC nao � valido
 *                 + Nao foi criado pelo AI
 */
stock AI:FCNPC_GetAIID(npcid)
{
	// ID inv�lido
	if(!(0 <= npcid < MAX_PLAYERS))
		return INVALID_AI_ID;

	// FCNPC nao existe
	if(FCNPC_IsValid(npcid))
		return INVALID_AI_ID;

	return FCNPC_AIID[npcid];
}

/**
 * Cria um AI
 *
 * @param      name  Nome do AI
 *
 * @date       18:03 01/06/2017
 * @author     Dayvison
 *
 * @return     - `ID do AI criado` Sucesso
 *             - `INVALID_AI_ID` caso ocorra algum erro:
 *                 + M�ximo de AI's alcan�ado
 *                 + FCNP_Create falhou
 */
stock AI:AI_Create(string:name[MAX_AI_NAME])
{
	return AI_CreateEX(name);
}

/**
 * Cria um AI com todas op�oes de personaliza�ao
 *
 * @param      name                 Nome
 * @param      movetype             Movimento executado pelo AI (MOVE_TYPE_AUTO, MOVE_TYPE_WALK, MOVE_TYPE_RUN, MOVE_TYPE_SPRINT, MOVE_TYPE_DRIVE)
 * @param      movespeed            Velocidade de movimento do AI (MOVE_SPEED_AUTO, MOVE_SPEED_WALK, MOVE_SPEED_RUN, MOVE_SPEED_SPRINT)
 * @param      useMapAndreas        Se ir� usar a corre�ao do eixo Z com MapAndreas oferecido pelo plugin FCNPC ao movimentar
 * @param      useColAndreas        Se ir� usar a corre�ao do eixo Z com ColAndreas feito em pawn
 * @param      setAngle             Se o FCNPC ir� corrigir o angulo do AI, quando ele se movimentar
 * @param      radius               Quando for instruido o AI a se movimentar, caso a nova posi�ao esteja neste raio a a�ao ser� ignorada
 * @param      precision            Taxa de acertos dos tiros(0, a 100%)
 * @param      strength             For�a do NPC, ataques fisicos(Valor do dano)
 * @param      pathid               Caminho para o NPC percorrer criado com FCNPC_CreateMovePath
 * @param      range                Area de detec�ao de um objetivo pelo NPC(Streamer_Area)
 * @param      checkObstacles       Se para detec�ao de um objetivo, ir� usar ColAndreas para checar se existe obst�culos no seu caminho, impossibilitando o AI de alcan�ar o objetivo
 * @param      checkVision          Se para detec�ao de um objetivo, ir� checar se o objetivo � visto pelo AI (IsElementOnFakeScreen)
 * @param      solutionsAISolution  Solu�oes autom�ticas para problemas encontrados durante a persegui�ao de um objetivo
 * @param      posture              Postura adotada pelo AI [AIPosture](#AIPosture)
 *
 * @date       18:08 01/06/2017
 * @author     Dayvison
 *
 * @return     - `ID do AI criado` Sucesso
 *             - `INVALID_AI_ID` caso ocorra algum erro:
 *                 + M�ximo de AI's alcan�ado
 *                 + FCNP_Create falhou
 */
stock AI:AI_CreateEX(
	string:name[MAX_AI_NAME],
	movetype              = AI_DEFAULT_MOVE_TYPE,
	Float:movespeed       = AI_DEFAULT_MOVE_SPEED,
	bool:useMapAndreas    = AI_DEFAULT_USEMAPANDREAS,
	bool:useColAndreas    = AI_DEFAULT_USECOLANDREAS,
	bool:setAngle         = AI_DEFAULT_SETANGLE,
	Float:radius          = AI_DEFAULT_RADIUS,
	Float:precision       = AI_DEFAULT_PRECISION,
	Float:strength        = AI_DEFAULT_STRENGTH,
	pathid                = AI_DEFAULT_PATHID,
	Float:range           = AI_DEFAULT_RANGE,
	bool:checkObstacles   = AI_DEFAULT_CHECKOBSTACLES,
	bool:checkVision      = AI_DEFAULT_CHECKVISION,
	//solutions[AISolution] = AI_DEFAULT_SOLUTIONS,
	AIPosture:posture     = AI_DEFAULT_POSTURE
)
{
	new AI:id = AI:Iter_Free(AIs);

	if(_:id == cellmin)
	{
		AI_Error("Increase MAX_AIS.");
		return INVALID_AI_ID;
	}

	new ID = FCNPC_Create(name);
	if(ID == INVALID_PLAYER_ID)
	{
		AI_Error("Failed to create NPC name %s.", name);
		return INVALID_AI_ID;
	}

	Iter_Add(AIs, _:id);
	AI_Data[id][AI_FCNPCID]        = ID;
	AI_Data[id][AI_Name]           = name;
	AI_Data[id][AI_MoveType]       = movetype;
	AI_Data[id][AI_MoveSpeed]      = movespeed;
	AI_Data[id][AI_UseMapAndreas]  = useMapAndreas;
	AI_Data[id][AI_UseColAndreas]  = useColAndreas;
	AI_Data[id][AI_SetAngle]       = setAngle;
	AI_Data[id][AI_Radius]         = radius;
	AI_Data[id][AI_Precision]      = precision;
	AI_Data[id][AI_Strength]       = strength;
	AI_Data[id][AI_Pathid]         = pathid;
	AI_Data[id][AI_Range]          = range;
	AI_Data[id][AI_CheckObstacles] = checkObstacles;
	AI_Data[id][AI_CheckVision]    = checkVision;
	//AI_Data[id][AI_Solutions]      = solutions;
	AI_Data[id][AI_Posture]        = posture;

	new STREAMER_TAG_AREA area = CreateDynamicCircle(0.0, 0.0, range);
	AttachDynamicAreaToPlayer(area, ID);

	new arr[2];
	arr[0] = AI_STREAMER_IDENTIFIER;
	arr[1] = _:id;

	Streamer_SetArrayData(STREAMER_TYPE_AREA, area, E_STREAMER_EXTRA_ID, arr);

	AI_Data[id][AI_DynArea] = area;

	CallLocalFunction("AI_OnCreate", "d", _:id);
	
	return id;
}

/**
 * Determina se um AI � valido
 *
 * @param      AI    ID do AI
 *
 * @date       18:38 01/06/2017
 * @author     Dayvison
 *
 * @return     - `1` V�lido
 *             - `0` Inv�lido:
 */
stock AI_IsValid(AI:id)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return 0;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return 0;

	return 1;
}

/**
 * Destr�i um AI
 *
 * @param      id    ID do AI
 *
 * @date       18:12 01/06/2017
 * @author     Dayvison
 *
 * @return     - `1` Sucesso
 *             - `0` caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 */
stock AI_Destroy(AI:id)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return 0;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return 0;

	static const AI_DATA_CLEAN[E_AI_DATA];

	AI_Data[id] = AI_DATA_CLEAN;

	CallLocalFunction("AI_OnDestroy", "d", _:id);

	SetTimerEx("@AI_IterClear", 0, false, "d", _:id);

	// TODO: Destruir areas

	return 1;
}

/**
 * Remove o AI de qualquer iterator em que ele esteja
 */
@AI_IterClear(id);@AI_IterClear(id)
{
	Iter_Remove(AIs, id);
	Iter_Clear(AIsPlayers<id>);
	
	foreach(new playerid: Player)
	{
		if(Iter_Contains(PlayerAIs<playerid>, id))
			Iter_Remove(PlayerAIs<playerid>, id);
	}
}

/**
 * Spawna um AI
 *
 * @param      AI            ID do AI
 * @param      skinid        ID da skin para spawnar
 * @param      x             Posi�ao X
 * @param      y             Posi�ao Y
 * @param      z             Posi�ao Z
 * @param      angle         �ngulo
 * @param      interior      ID do interior
 * @param      virtualworld  ID do virtual world
 *
 * @date       19:04 01/06/2017
 * @author     Dayvison
 *
 * @return     - `1` Sucesso
 *             - `0` caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 *                 + Skin inv�lida
 *                 + FCNPC_Spawn erro(O npc j� est� spawnado)
 */
stock AI_Spawn(AI:id, skinid, Float:x, Float:y, Float:z, Float:angle = AI_DEFAULT_ANGLE, interior = AI_DEFAULT_INTERIOR, virtualworld = AI_DEFAULT_VIRTUAL_WORLD)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return 0;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return 0;

	// Skin inv�lida
	if(!(0 <= skinid <= 311))
		return 0;

	new npcid = AI_Data[id][AI_FCNPCID];

	if(!FCNPC_Spawn(npcid, skinid, x, y, z))
		return 0;

	FCNPC_SetAngle(npcid, angle);
	FCNPC_SetVirtualWorld(npcid, virtualworld);
	FCNPC_SetInterior(npcid, interior);

	return 1;
}

/**
 * Determina se um AI est� spawnado
 *
 * @param      id    ID do AI
 *
 * @date       19:40 01/06/2017
 * @author     Dayvison
 *
 * @return     - `1` Esta spawnado
 *             - `0` Nao esta spawnado ou aso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 */
stock AI_IsSpawned(AI:id)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return 0;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return 0;

	return FCNPC_IsSpawned(AI_Data[id][AI_FCNPCID]);
}

/**
 * Respawna um AI
 *
 * @param      id    ID do AI
 *
 * @date       22:48 02/06/2017
 * @author     Dayvison
 *
 * @return     - `1` Sucesso
 *             - `0` caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 *                 + FCNPC_Respawn erro(O npc j� est� spawnado)
 */
stock AI_Respawn(AI:id)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return 0;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return 0;

	return FCNPC_Respawn(AI_Data[id][AI_FCNPCID]);
}

/**
 * Obt�m o ID do FCNPC do AI
 *
 * @param      AI    ID do AI
 *
 * @date       22:51 02/06/2017
 * @author     Dayvison
 *
 * @return     - `ID no FCNPC` Sucesso
 *             - `INVALID_PLAYER_ID` caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 */
stock AI_GetFCNPCID(AI:id)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return INVALID_PLAYER_ID;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return INVALID_PLAYER_ID;

	return AI_Data[id][AI_FCNPCID];
}

/**
 * Define a postura adotada pelo AI
 *
 * @param      id       ID do AI
 * @param      posture  A postura a definir
 *
 * @date       23:54 02/06/2017
 * @author     Dayvison
 *
 * @return     - `1` Sucesso
 *             - `0` caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 *                 + A postura � inv�lida
 */
stock AI_SetPosture(AI:id, AIPosture:posture)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return 0;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return 0;

	// Postura inv�lida
	if(!(POSTURE_INVALID < posture < AIPosture))
		return 0;

	AI_Data[id][AI_Posture] = posture;

	return 1;
}

/**
 * Obt�m a postura adotada pelo AI
 *
 * @param      id     ID do AI
 *
 * @date       23:54 02/06/2017
 * @author     Dayvison
 *
 * @return     - `Postura adotada pelo AI` Sucesso
 *             - `POSTURE_INVALID` caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 */
stock AIPosture:AI_GetPosture(AI:id)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return POSTURE_INVALID;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return POSTURE_INVALID;

	return AI_Data[id][AI_Posture];
}

/**
 * Define todas op�oes do movimento do AI
 *
 * @param      id              ID do AI
 * @param      &movetype       O movimento executado pelo AI
 * @param      &movespeed      A velocidade de movimento do AI
 * @param      &useMapAndreas  O se o uso do MapAndreas para corre�ao do eixo Z esta ativo
 * @param      &useColAndreas  O se o uso do ColAndreas para corre�ao do eixo Z esta ativo
 * @param      &setAngle       O se a corre�ao autom�tica do �ngulo est� ativo 
 * @param      &radius         O raio de movimento ignorado do AI
 *
 * @date       23:54 02/06/2017
 * @author     Dayvison
 *
 * @return     - `1` Sucesso
 *             - `0` caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 *                 + Alguma das op�oes sao inv�lidas
 */
stock AI_SetMoveInfo(AI:id, movetype = MOVE_TYPE_AUTO, Float:movespeed = MOVE_SPEED_AUTO, bool:useMapAndreas = false, bool:useColAndreas = false, bool:setAngle = true, Float:radius = 0.0)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return 0;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return 0;

	// Movimento inv�lido
	if(!(MOVE_TYPE_AUTO <= movetype <= MOVE_TYPE_DRIVE))
		return 0;

	// Velocidade inv�lida
	if(movespeed <= 0.0 && movespeed != MOVE_TYPE_AUTO)
		return 0;

	// Raio inv�lido
	if(radius <= 0.0)
		return 0;

	AI_Data[id][AI_MoveType] = movetype;
	AI_Data[id][AI_MoveSpeed] = movespeed;
	AI_Data[id][AI_UseMapAndreas] = useMapAndreas;
	AI_Data[id][AI_UseColAndreas] = useColAndreas;
	AI_Data[id][AI_SetAngle] = setAngle;
	AI_Data[id][AI_Radius] = radius;

	return 1;
}

/**
 * Obt�m todas op�oes do movimento do AI por referencia
 *
 * @param      id              ID do AI
 * @param      &movetype       Variavel para obter o movimento executado pelo AI
 * @param      &movespeed      Variavel para obter a velocidade de movimento do AI
 * @param      &useMapAndreas  Variavel para obter o se o uso do MapAndreas para corre�ao do eixo Z esta ativo
 * @param      &useColAndreas  Variavel para obter o se o uso do ColAndreas para corre�ao do eixo Z esta ativo
 * @param      &setAngle       Variavel para obter o se a corre�ao autom�tica do �ngulo est� ativo 
 * @param      &radius         Variavel para obter o raio de movimento ignorado do AI
 *
 * @date       23:54 02/06/2017
 * @author     Dayvison
 *
 * @return     - `1` Sucesso
 *             - `0` caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 */
stock AI_GetMoveInfo(AI:id, &movetype, &Float:movespeed, &bool:useMapAndreas, &bool:useColAndreas, &bool:setAngle, &Float:radius)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return 0;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return 0;

	movetype = AI_Data[id][AI_MoveType];
	movespeed = AI_Data[id][AI_MoveSpeed];
	useMapAndreas = AI_Data[id][AI_UseMapAndreas];
	useColAndreas = AI_Data[id][AI_UseColAndreas];
	setAngle = AI_Data[id][AI_SetAngle];
	radius = AI_Data[id][AI_Radius];

	return 1;
}

/**
 * Define o movimento executado pelo AI
 *
 * @param      id     ID do AI
 * @param      type   O tipo do movimento
 *
 * @date       23:54 02/06/2017
 * @author     Dayvison
 *
 * @return     - `1` Sucesso
 *             - `0` caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 *                 + O tipo de movimento � inv�lido
 */
stock AI_SetMoveType(AI:id, type)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return 0;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return 0;

	// Movimento inv�lido
	if(!(MOVE_TYPE_AUTO <= type <= MOVE_TYPE_DRIVE))
		return 0;

	AI_Data[id][AI_MoveType] = type;

	return 1;
}

/**
 * Obt�m o movimento executado pelo AI
 *
 * @param      id     ID do AI
 *
 * @date       23:54 02/06/2017
 * @author     Dayvison
 *
 * @return     - `Movimento executado pelo AI` Sucesso
 *             - `INVALID_MOVE_TYPE` caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 */
stock AI_GetMoveType(AI:id)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return INVALID_MOVE_TYPE;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return INVALID_MOVE_TYPE;

	return AI_Data[id][AI_MoveType];
}

/**
 * Define a velocidade de movimento do AI
 *
 * @param      id     ID do AI
 * @param      speed  A velocidade a definir
 *
 * @date       23:54 02/06/2017
 * @author     Dayvison
 *
 * @return     - `1` Sucesso
 *             - `0` caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 *                 + A velocidade � inv�lida(Negativo && != MOVE_TYPE_AUTO)
 */
stock AI_SetMoveSpeed(AI:id, Float:speed)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return 0;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return 0;

	// Velocidade inv�lida
	if(speed <= 0.0 && speed != MOVE_TYPE_AUTO)
		return 0;

	AI_Data[id][AI_MoveSpeed] = speed;

	return 1;
}

/**
 * Obt�m a velocidade de movimento do AI
 *
 * @param      id     ID do AI
 *
 * @date       23:54 02/06/2017
 * @author     Dayvison
 *
 * @return     - `Velocidade de movimento do AI` Sucesso
 *             - `-10.0` caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 */
stock Float:AI_GetMoveSpeed(AI:id)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return -10.0;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return -10.0;

	return AI_Data[id][AI_MoveSpeed];
}

/**
 * Alterna o uso do MapAndreas para corre�ao do eixo Z
 *
 * @param      id      ID do AI
 * @param      toggle  Antern�ncia
 *
 * @date       23:54 02/06/2017
 * @author     Dayvison
 *
 * @return     - `1` Sucesso
 *             - `0` caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 */
stock AI_ToggleUseMapAndreas(AI:id, bool:toggle)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return 0;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return 0;

	AI_Data[id][AI_UseMapAndreas] = toggle;
	return 1;
}

/**
 * Determina se o uso do MapAndreas para corre�ao do eixo Z esta ativo
 *
 * @param      id     ID do AI
 *
 * @date       23:54 02/06/2017
 * @author     Dayvison
 *
 * @return     - `true` A corre�ao do eixo Z com MapAndreas est� ativa
 *             - `false` A corre�ao do eixo Z com MapAndreas nao est� ativa ou caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 */
stock bool:AI_IsMapAndreasUsed(AI:id)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return false;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return false;

	return AI_Data[id][AI_UseMapAndreas];
}

/**
 * Alterna o uso do ColAndreas para corre�ao do eixo Z
 *
 * @param      id      ID do AI
 * @param      toggle  Antern�ncia
 *
 * @date       23:54 02/06/2017
 * @author     Dayvison
 *
 * @return     - `1` Sucesso
 *             - `0` caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 */
stock AI_ToggleUseColAndreas(AI:id, bool:toggle)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return 0;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return 0;

	AI_Data[id][AI_UseColAndreas] = toggle;
	return 1;
}

/**
 * Determina se o uso do ColAndreas para corre�ao do eixo Z esta ativo
 *
 * @param      id     ID do AI
 *
 * @date       23:54 02/06/2017
 * @author     Dayvison
 *
 * @return     - `true` A corre�ao do eixo Z com ColAndreas est� ativa
 *             - `false` A corre�ao do eixo Z com ColAndreas nao est� ativa ou caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 */
stock bool:AI_IsColAndreasUsed(AI:id)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return false;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return false;

	return AI_Data[id][AI_UseColAndreas];
}

/**
 * Alterna a corre�ao autom�tica do �ngulo
 *
 * @param      id      ID do AI
 * @param      toggle  Antern�ncia
 *
 * @date       23:54 02/06/2017
 * @author     Dayvison
 *
 * @return     - `1` Sucesso
 *             - `0` caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 */
stock AI_ToggleSetAngle(AI:id, bool:toggle)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return 0;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return 0;

	AI_Data[id][AI_SetAngle] = toggle;
	return 1;
}

/**
 * Determina se a corre�ao autom�tica do �ngulo est� ativo 
 *
 * @param      id     ID do AI
 *
 * @date       23:54 02/06/2017
 * @author     Dayvison
 *
 * @return     - `true` A corre�ao autom�tica do �ngulo est� ativa
 *             - `false` A corre�ao autom�tica do �ngulo nao est� ativa ou caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 */
stock bool:AI_IsSetAngle(AI:id)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return false;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return false;

	return AI_Data[id][AI_SetAngle];
}

/**
 * Define o raio de movimento ignorado do AI
 *
 * @param      id      ID do AI
 * @param      radius  O raio a definir
 *
 * @date       23:54 02/06/2017
 * @author     Dayvison
 *
 * @return     - `1` Sucesso
 *             - `0` caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 *                 + O raio � inv�lido(Negativo)
 */
stock AI_SetRadius(AI:id, Float:radius)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return 0;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return 0;

	// Raio inv�lido
	if(radius <= 0.0)
		return 0;

	AI_Data[id][AI_Radius] = radius;

	return 1;
}

/**
 * Obt�m o raio de movimento ignorado do AI
 *
 * @param      id     ID do AI
 *
 * @date       23:54 02/06/2017
 * @author     Dayvison
 *
 * @return     - `O raio de movimento ignorado do AI` Sucesso
 *             - `-10.0` caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 */
stock Float:AI_GetRadius(AI:id)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return -10.0;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return -10.0;

	return AI_Data[id][AI_Radius];
}

/**
 * Define a precisao do AI
 *
 * @param      id         ID do AI
 * @param      precision  A precisao a definir
 *
 * @date       23:54 02/06/2017
 * @author     Dayvison
 *
 * @return     - `1` Sucesso
 *             - `0` caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 *                 + A precisao � inv�lida(< 0.0 || > 100.0)
 */
stock AI_SetPrecision(AI:id, Float:precision)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return 0;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return 0;

	// Precisao inv�lida
	if(!(0.0 <= precision <= 100.0))
		return 0;

	AI_Data[id][AI_Precision] = precision;

	return 1;
}

/**
 * Obt�m a precisao do AI
 *
 * @param      id     ID do AI
 *
 * @date       23:54 02/06/2017
 * @author     Dayvison
 *
 * @return     
 * @return     - `Precisao` Sucesso
 *             - `-10.0` caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 */
stock Float:AI_GetPrecision(AI:id)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return -10.0;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return -10.0;

	return AI_Data[id][AI_Precision];
}

/**
 * Define a for�a do AI
 *
 * @param      id        ID do AI
 * @param      strength  A for�a a definir
 *
 * @date       23:54 02/06/2017
 * @author     Dayvison
 *
 * @return     - `1` Sucesso
 *             - `0` caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 *                 + A for�a � inv�lida(Negativa)
 */
stock AI_SetStrength(AI:id, Float:strength)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return 0;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return 0;

	// For�a inv�lida
	if(strength <= 0.0)
		return 0;

	AI_Data[id][AI_Strength] = strength;

	return 1;
}

/**
 * Obt�m a for�a do AI
 *
 * @param      id     ID do AI
 *
 * @date       23:54 02/06/2017
 * @author     Dayvison
 *
 * @return     - `For�a do AI` Sucesso
 *             - `-10.0` caso ocorra algum erro:
 *                 + O id � inv�lido
 *                 + O id nao existe
 */
stock Float:AI_GetStrength(AI:id)
{
	// O id � inv�lido
	if(!(0 <= _:id < MAX_AIS))
		return -10.0;

	// O id nao existe
	if(!Iter_Contains(AIs, _:id))
		return -10.0;

	return AI_Data[id][AI_Strength];
}

/*================================================
=  ____ ____ _    _    ___  ____ ____ _  _ ____  =
=  |    |__| |    |    |__] |__| |    |_/  [__   =
=  |___ |  | |___ |___ |__] |  | |___ | \_ ___]  =
=                                                =
*================================================*/

hook FCNPC_OnSpawn(npcid)
{
	if(FCNPC_IsAI(npcid))
		CallLocalFunction("AI_OnSpawn", "d", _:FCNPC_GetAIID(npcid));
}

hook FCNPC_OnRespawn(npcid)
{
	if(FCNPC_IsAI(npcid))
		CallLocalFunction("AI_OnRespawn", "d", _:FCNPC_GetAIID(npcid));
}

hook FCNPC_OnDeath(npcid, killerid, weaponid)
{
	if(FCNPC_IsAI(npcid))
		CallLocalFunction("AI_OnDeath", "ddd", _:FCNPC_GetAIID(npcid), killerid, weaponid);
}

hook OnScriptInit()
{
	SetTimer("@AI_OnTick", AI_TickRate, true);
}

@AI_OnTick();@AI_OnTick()
{
	foreach(new ai: AIs)
	{
		foreach(new playerid: AIsPlayers<ai>)
		{
			// TODO: algoritimo de detec�ao
		}
	}
}

hook OnPlayerEnterDynArea(playerid, STREAMER_TAG_AREA areaid)
{
	// Quando se anexa uma area a um player � chamada para ele como se ele tivesse entrado na area

	new attachedid = Streamer_GetIntData(STREAMER_TYPE_AREA, areaid, E_STREAMER_ATTACHED_PLAYER);
	if(playerid == attachedid)
		return;

	new arr[2];

	Streamer_GetArrayData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID, arr);

	if(arr[0] != AI_STREAMER_IDENTIFIER)
		return;

	new AI:id = AI:arr[1];

	// TODO: criar objetivos

Iterator:PlayerAIs<MAX_PLAYERS, MAX_AIS>  /// AI's seguindo o player
Iterator:<MAX_AIS, MAX_PLAYERS> /// Players na �rea de detec�ao do AI

	Iter_Add(AIsPlayers<_:id>, playerid);
}
hook OnPlayerLeaveDynArea(playerid, STREAMER_TAG_AREA areaid)
{
	new arr[2];

	Streamer_GetArrayData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID, arr);

	if(arr[0] != AI_STREAMER_IDENTIFIER)
		return;

	new AI:id = AI:arr[1];

	// TODO: remover objetivos
}

@ai_func_in();@ai_func_in()
{
	FCNPC_IsAI(0);
	FCNPC_GetAIID(0);
	AI_Create("");
	AI_CreateEX("");
	AI_IsValid(INVALID_AI_ID);
	AI_Destroy(INVALID_AI_ID);
	AI_Spawn(INVALID_AI_ID, 0, 0.0, 0.0, 0.0);
	AI_IsSpawned(INVALID_AI_ID);
	AI_Respawn(INVALID_AI_ID);
	AI_GetFCNPCID(INVALID_AI_ID);
	AI_SetPosture(INVALID_AI_ID, POSTURE_INVALID);
	AI_GetPosture(INVALID_AI_ID);
	AI_SetMoveInfo(INVALID_AI_ID, 0, 0.0, false, false, false, 0.0);
	new var, Float:fvar, bool:bvar;
	AI_GetMoveInfo(INVALID_AI_ID, var, fvar, bvar, bvar, bvar, fvar);
	AI_SetMoveType(INVALID_AI_ID, 0);
	AI_GetMoveType(INVALID_AI_ID);
	AI_SetMoveSpeed(INVALID_AI_ID, 0.0);
	AI_GetMoveSpeed(INVALID_AI_ID);
	AI_ToggleUseMapAndreas(INVALID_AI_ID, false);
	AI_IsMapAndreasUsed(INVALID_AI_ID);
	AI_ToggleUseColAndreas(INVALID_AI_ID, false);
	AI_IsColAndreasUsed(INVALID_AI_ID);
	AI_ToggleSetAngle(INVALID_AI_ID, false);
	AI_IsSetAngle(INVALID_AI_ID);
	AI_SetRadius(INVALID_AI_ID, 0.0);
	AI_GetRadius(INVALID_AI_ID);
	AI_SetPrecision(INVALID_AI_ID, 0.0);
	AI_GetPrecision(INVALID_AI_ID);
	AI_SetStrength(INVALID_AI_ID, 0.0);
	AI_GetStrength(INVALID_AI_ID);
}
}