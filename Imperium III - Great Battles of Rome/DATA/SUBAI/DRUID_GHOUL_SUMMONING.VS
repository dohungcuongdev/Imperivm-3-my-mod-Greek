// void, Obj This

Druid this;
Unit u;

this = This.AsDruid();
if (!.IsValid()) return;

.PlayAnim(19, .pos);
u=Place("GGhost", .posRH, .player);
u.SetStamina(10);
u.SetLevel(.level);
if(this.HasItem("Herb amulet of luck")) {
	u.AddItem("Herb amulet of luck");
}
SwapSelectedObj(this, u);
.SetSummoningDeath(true);
.Damage(.health);
