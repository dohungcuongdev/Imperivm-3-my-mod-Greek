// void, Obj This, point pt

Hero this;
Obj u;
point dpt;
bool bSquadTarget;
int i;

this = This.AsHero ();
//.pr("hero::advance : move setup");
.FormSetupAndMoveTo (pt, 0, 0, true);
// Wait for army to exit
while(!.IsArmyOutside())
	.FormKeepMoving(500);
while(.HasPath())
{
	//.pr("Hero::Advance:Looking for enemys");
	if (.IsEnemyInSquadSight()) {
		bSquadTarget = false;
		u = .BestTargetInSquadSight();
		if (u.IsAlive()) if (u.attack > 0)
			bSquadTarget = true;
		for (i = 0; !bSquadTarget && i < .army.count; i += 1) {
			u = .army[i].AsUnit.BestTargetInSquadSight();
			if (u.IsAlive()) if (u.attack > 0)
				bSquadTarget = true;
		}		
		if (bSquadTarget) {
			.AddCommand(true, "disease_advance", pt);
			.AddCommand(true, "disease_engage");
			return;
		}
	}
	//.pr("hero::advance: No Enemy");
	//.pr("hero::advance:moving");
	.FormKeepMoving (1500);
}	

dpt = .GetFinalPartyOrientation() - Point(1024, 1024);
if (dpt.x != 0 || dpt.y != 0)
	.Face(.pos + dpt);
