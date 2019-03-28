#include <a_samp>

//////////////////////////////

#define     BusDriver::       		busd_

#define     BUSDRIVER_MAX_LINKY     10
#define     BUSDRIVER_MAX_ZASTAVKY  30 //(na jednu linku)

//////////////////////////////

enum busdriver_linky()
{

}

//////////////////////////////

new bool:BusDriver::DoingJob[MAX_PLAYERS];
new BusDriver::VehicleId[MAX_PLAYERS];

//////////////////////////////
