// void, Obj This

Unit u;
Druid this;
this = This.AsDruid;

if(EnvReadString(.player, "Zombify") != "researched")
	return;

//SacrificeMage is set in stonehenge_wait_for_finish_sacrifice.vs
u = EnvReadObj(.player, "SacrificeMage");
if (u.AsUnit.IsValid) if (u == this)
	return;

if (!.InHolder() && !.IsSummoningDeath()) {
	u=Place("GGhost", .pos, .player);
	if(u.IsValid){
		u.SetStamina(5);
		u.SetLevel(.level);
		u.SetCommand("spawn");
		SwapSelectedObj(this, u);	
	}
}