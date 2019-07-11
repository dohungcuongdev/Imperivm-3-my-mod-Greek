// void, Obj This

Druid this;
Unit u;
this = This.AsDruid();
if (!.IsValid()) return;

.PlayAnim(19, .pos);
u=Place("EagleSummoned", .posRH, .player);
u.SetStamina(10);
if(this.HasItem("Herb amulet of luck")) {
	u.AddItem("Herb amulet of luck");
}
SwapSelectedObj(this, u);
.SetSummoningDeath(true);
.Damage(.health);