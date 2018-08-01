// void, Obj This

Building this;
Unit unit;
point ptDest, pt;
int lRadius, i, pop_group;
int  xfix, yfix;
str strMaleVillager, strFemaleVillager;

lRadius = GetConst("VillageTrainPeasantRadius");
pop_group = GetConst("PopGroup");
this = This.AsBuilding();
.Progress();

/// Gaul -> "GVillager" and "GWVillager", etc
if (.race == ImperialRome){
	strMaleVillager = "H";
}
else{
	strMaleVillager = .raceStrPref;
}
strFemaleVillager = strMaleVillager + "W" + "Villager";
strMaleVillager = strMaleVillager + "Villager";

xfix = 1;
yfix = 1;

for (i = 0; i < pop_group; i += 1)
{
	ptDest.Set(1,1);
	ptDest.SetLen(rand(lRadius - .settlement.GetCentralBuilding().radius) + .settlement.GetCentralBuilding().radius );
	ptDest.Rot(rand(360));
	ptDest = ptDest + .settlement.GetCentralBuilding().pos;

	pt = .GetExitPoint(ptDest, false);

// 'no peasant over peasant' code
	if( i == 0 )
		pt.Set( pt.x + 10, pt.y + 10 );
	else if( i == 1 )
		pt.Set( pt.x - 10, pt.y - 10 );
	else if( i == 2 )
		pt.Set( pt.x - 10, pt.y + 10 );
	else if( i == 3 )
		pt.Set( pt.x + 10, pt.y - 10 );
	else
		pt.Set( pt.x + 10, pt.y );

	
	if (rand(2) == 1)
		unit = Place(strMaleVillager, pt, .player).AsUnit();
	else
		unit = Place(strFemaleVillager, pt, .player).AsUnit();

	if (.settlement.supplied.IsValid())
	{
		if (!.settlement.supplied.IsTTent())
		if(!unit.IsEnemy(.settlement.supplied.GetCentralBuilding()))
		{
			unit.SetCommand("enter", .settlement.supplied.GetCentralBuilding());
			Sleep( 250 );
			continue;
		}
	}
	unit.SetCommand("move", ptDest);
	Sleep( 150 );
}