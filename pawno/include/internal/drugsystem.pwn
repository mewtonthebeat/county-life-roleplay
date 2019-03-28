/* DEFINES, ETC */
#if !defined MAX_DRUGS
	#define MAX_DRUGS       		10
#endif

#if !defined MAX_DRUG_NAME_LENGTH
	#define MAX_DRUG_NAME_LENGTH    25
#endif
#if !defined MAX_DRUG_UNDERNAME_LENGTH
	#define MAX_DRUG_UNDERNAME_LENGTH    12
#endif

// DRUG TYPES-------------------------------------------------------------------

#define DRUG_TYPE_MARIJUANA         1
#define DRUG_TYPE_LEAN              2
#define DRUG_TYPE_LSD               3

/* VARIABLES */

enum drug_drugEnum() {
	drug_Type,
	drug_Quality,
	drug_UnderName[MAX_DRUG_UNDERNAME_LENGTH],
	drug_Name[MAX_DRUG_NAME_LENGTH]
}

new drug_drugArray[MAX_DRUGS][drug_drugEnum];

//------------------------------------------------------------------------------

enum drug_playerEnum() {
	pdrug_Quantity
}

new drug_playerArray[MAX_PLAYERS][MAX_DRUGS][drug_playerEnum];
new Iterator:Drugs<MAX_DRUGS>;

/* FUNCTIONS */

// * native drug_addDrug(drugId, drugType, drugName[], quality);
drug_addDrug(drugid, drugtype, drugname[], quality = 0, undername[] = "uses")
{
	if(drugid >= MAX_DRUGS)
	    return (false);
	    
    drug_drugArray[drugid][drug_Type]   	= drugtype;
    drug_drugArray[drugid][drug_Quality]   	= quality;
	format(drug_drugArray[drugid][drug_Name], MAX_DRUG_NAME_LENGTH, drugname);
	format(drug_drugArray[drugid][drug_UnderName], MAX_DRUG_UNDERNAME_LENGTH, undername);
	
	Iter_Add(Drugs, drugid);

	return (true);
}

// * native drug_getName(drugid);
#define drug_getName(%1)                	drug_drugArray[%1][drug_Name]

// * native drug_getUnderName(drugid);
#define drug_getUnderName(%1)             	drug_drugArray[%1][drug_UnderName]

// * native drug_givePlayerDrug(playerid, drugId, quantity);
#define drug_givePlayerDrug(%1,%2,%3)     	drug_playerArray[%1][%2][pdrug_Quantity] += %3

// * native drug_setPlayerDrug(playerid, drugId, quantity);
#define drug_setPlayerDrug(%1,%2,%3)     	drug_playerArray[%1][%2][pdrug_Quantity] = %3

// * native drug_getPlayerDrug(playerid, drugId);
#define drug_getPlayerDrug(%1,%2)     		drug_playerArray[%1][%2][pdrug_Quantity]
