/*

	[PROJECT NAME]; Trucking Job
	[PROJECT VERSION]; 1.0
	[DEVELOPER]; bigweb
	
	[DEFINES];
		* INVALID_CARGO_QUANTITY
		
	[ENUMS];
		* CARGO_TYPE_NONE
		* CARGO_TYPE_GROCERIES
		* CARGO_TYPE_FUEL
		* CARGO_TYPE_CLOTHES
		* CARGO_TYPE_ELECTRONICS
		* CARGO_TYPE_CAR_PARTS
		* CARGO_TYPE_WEAPONS
		
	[FUNCTIONS];
		native trucking_retCargoTypeName( const cargoType );
		native Float:trucking_retCargoMaxStorage_W( const cargoType );
		native Float:trucking_retCargoMaxStorage_B( const cargoType );
		native Float:trucking_retWhouseStorageQuan( const warehouseId, const cargoType );
		
*/

/*

	DEFINES

*/

#define INVALID_CARGO_QUANTITY		(-1024.0)

/*

	ENUMS AND ARRAYS
	
*/

enum {
	CARGO_TYPE_NONE,
	CARGO_TYPE_MISC,
	CARGO_TYPE_FUEL,
	CARGO_TYPE_CLOTHES,
	CARGO_TYPE_ELECTRONICS,
	CARGO_TYPE_CAR_PARTS,
	CARGO_TYPE_WEAPONS,
}
	
new A_cargoTypes[][] = {
	"_",
	"Miscallaenous",
	"Clothing",
	"Electronics",
	"Vehicle-parts",
	"Weapons"
};

new A_cargoStorage[700][7];

new A_cargoPrice[] = {
	0,
	100,
	100,
	100,
	100,
	100
};

new A_cargoStocked[] = {
	0,
	100,
	90,
	70,
	50,
	60
};

/*

	FUNCTIONS
	
*/

stock trucking_retCargoTypeName( cargoType )
{
	
	return A_cargoTypes[cargoType];
	
}

stock Float:trucking_retCargoMaxStorage_W( const cargoType )
{

	return float(A_maxCargoOnStorage[ _:cargoType ][1]);

}

stock Float:trucking_retCargoMaxStorage_B( const cargoType )
{

	return float(A_maxCargoOnStorage_Biz[ _:cargoType ][1]);

}

stock Float:trucking_retCargoMaxStorage_T( const cargoType )
{

	return float(A_maxCargoOnStorage_Truck[ _:cargoType ][1]);

}

stock Float:trucking_retWhouseStorageQuan( const warehouseId, const cargoType )
{
	
	return Float:A_cargoStorage[ warehouseId ][ cargoType ];
	
}

stock Float:trucking_retCargoPrice( const cargoType )
{

	return A_cargoPrice[ _:cargoType ];

}