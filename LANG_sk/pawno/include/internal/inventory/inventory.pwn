#include <a_samp>

//////////////////////////////

#define     Inventory:: inv_

//////////////////////////////

#define     MAX_INVENTORY_ITEMS     100

enum inventoryEnum()
{
	invEnum_ItemId,
	invEnum_ItemType,
	invEnum_ItemQuantity
}

#include <internal\inventory\items.pwn>

//////////////////////////////

new Inventory::playerItems[MAX_PLAYERS][MAX_INVENTORY_ITEMS][inventoryEnum()];

//////////////////////////////



