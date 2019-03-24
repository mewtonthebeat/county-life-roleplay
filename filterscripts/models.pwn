#define FILTERSCRIPT

#include <a_samp>

public OnFilterScriptInit()
{

	MODELS_LoadCustomSkins();
	MODELS_LoadCustomObjects();
	return 1;
}

new customSkins[][][] = {

	{0, 	20001, 	"customskin"}
	
};

new customObjects[][][] = {

	{2000, 	-1000, 	"custom", 			"custom"}
    
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
