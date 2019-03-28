#define FILTERSCRIPT

#include <a_samp>

public OnFilterScriptInit()
{

	MODELS_LoadCustomSkins();
	MODELS_LoadCustomObjects();
	return 1;
}

new customSkins[][][] = {
	/*

	    SHERIFF DEPARTMENT

	*/

	{280,   20007,  "sheriff_skins/lapd1/lapd1"},
	{281,   20008,  "sheriff_skins/sfpd1/sfpd1"},
	{281,   20009,  "sheriff_skins/dsherna/dsherna"},
	{281,   20010,  "sheriff_skins/cb/csherna/cshern"},
	{281,   20011,  "sheriff_skins/cb/dsherna/dsherna"},
	{282,   20012,  "sheriff_skins/cb/lvpd1/lvpd1"},
	{266,   20084,  "sheriff_skins/cb/pulaski/pulaski"},
	{250,   20085,  "sheriff_skins/cb/swmycr/swmycr"},
	{126,   20086,  "sheriff_skins/cb/vmaff3/vmaff3"},
	{285,   20087,  "sheriff_skins/cb/seb"},
	{311,   20088,  "sheriff_skins/cb/WFYCLLV"},
	{286,   20089,  "sheriff_skins/cb/fbi"},
	{283,   20090,  "sheriff_skins/cb/lapdm1"},
	{111,   20091,  "sheriff_skins/cb/army"},
	{280,   20092,  "sheriff_skins/acad"},
	{70,    20096,  "sheriff_skins/wmosci"},

	/*

	    FIRE DEPARTMENT

	*/

	//bez bundy
	{274, 	20022,	"m_laemt1_274"},
	{275,   20023,  "m_lvemt1_275"},
	{276,   20024,  "m_sfemt1_276"},

	//s bundou
	{93,    20029,  "skinsupdate102/Fhasicoveral/wfyst"},
	{277,   20028,  "m_lafd1_277"},
	{278,   20026,  "m_lvfd1_278"},
	{279,   20027,  "m_sffd1_279"}

};

new customObjects[][][] = {

	/*

		CLOTHING

	*/

	{19294, -1000, "textdraws", 			"textdraws"},
	{19966, -1034,  "SAMPRoadSign19",           "SAMPRoadSigns"},
	{2998,  -1052,  "sizzurpdafev2",	"sizzurpdafev2"},   //pohár leanu
	{19294, -2000,   "textdraws",    				"textdraws"},
	{19294, -2001, "elm_bullet", "MatLights"},
	{19294, -2002, "elm_copbike", "MatLights"},
	{19294, -2003, "elm_fbirancher", "MatLights"},
	{19294, -2004, "elm_firela", "MatLights"},
	{19294, -2005, "elm_cheetah", "MatLights"},
	{19294, -2006, "elm_lspd", "MatLights"},
	{19294, -2007, "elm_ranger", "MatLights"},
	{19294, -2008, "elm_sultan", "MatLights"},
	{19294, -2009, "elm_firetruck", "MatLights"},
	{19294, -2010, "elm_ambulance", "MatLights"},
	{19294, -2011, "elm_trafbarL", "MatLights"},
	{19294, -2012, "elm_trafbarM", "MatLights"},
	{19294, -2013, "elm_trafbarR", "MatLights"},
	{19294, -2014, "majacik", "MatLights"},
	{19294, -2015, "elm_trafbarM_rang", "MatLights"},
	{19294, -2016, "elm_spotlight", "MatLights"},
	{19294, -2017, "elm_trafbar_huntley", "MatLights"},
    {19379, -3000, "SFBELM", "SFBELM"}

};

/* MODELS */

MODELS_LoadCustomSkins()
{

	for(new i; i < sizeof(customSkins); i++)
	{

	    new
	        skin_dff[64],
	        skin_txd[64]
		;

		format(skin_dff, sizeof(skin_dff), "%s.dff", customSkins[i][2]);
		format(skin_txd, sizeof(skin_txd), "%s.txd", customSkins[i][2]);

    	AddCharModel(customSkins[i][0][0], customSkins[i][1][0], skin_dff, skin_txd);
	}

	return 1;

}

MODELS_LoadCustomObjects()
{

	for(new i; i < sizeof(customObjects); i++)
	{

	    new
	        skin_dff[64],
	        skin_txd[64]
		;

		format(skin_dff, sizeof(skin_dff), "%s.dff", customObjects[i][2]);
		format(skin_txd, sizeof(skin_txd), "%s.txd", customObjects[i][3]);

    	AddSimpleModel(-1, customObjects[i][0][0], customObjects[i][1][0], skin_dff, skin_txd);
	}

	return 1;

}
