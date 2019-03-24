#include <a_samp>
#include <YSI\y_iterate>

//////////////////////////////

#define     Voucher::                   vou_

//////////////////////////////

Voucher::ShowPlayer(playerid, forplayerid = playerid)
{

	new
	    tquery[ 144 ]
	;
	
	mysql_format(MySQL, tquery, sizeof tquery, "SELECT * FROM voucher_player WHERE name = '%e' OR name = '%e' ORDER BY redeemed", ReturnName(playerid), ReturnMaster(playerid));
	mysql_tquery(MySQL, tquery, "VoucherOnShowProccess", "dd", playerid, forplayerid);

	return 1;
}

//////////////////////////////

function VoucherOnShowProccess(playerid, forplayerid)
{
	new
		tquery[64];
	;
	
	mysql_format(MySQL, tquery, sizeof tquery, "SELECT * FROM voucher_main ORDER BY active");
	new Cache:cache = mysql_query(MySQL, tquery);
	
	for(new x, y = cache_num_rows(); x < y; x++)
	{
	
	}
	
	return 1;
}

//////////////////////////////

/*YCMD:myvouchers(playerid, params[], help)
{
	if(!Voucher::ShowPlayer(playerid))
	    return SendError(playerid, "Nemáš žiadne vouchre!");
	
	return 1;
}*/

//////////////////////////////
