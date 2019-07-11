// void, Obj This

Druid this;
Unit u;
this = This.AsDruid();
if (!.IsValid()) return;

.PlayAnim(19, .pos);
u=Place("WolfSummoned", .posRH, .player);
u.SetStamina(10);
if(this.HasItem("Herb amulet of luck")) {
	u.AddItem("Herb amulet of luck");
}
u.SetLevel(.level);
SwapSelectedObj(this, u);
.SetSummoningDeath(true);
.Damage(.health);