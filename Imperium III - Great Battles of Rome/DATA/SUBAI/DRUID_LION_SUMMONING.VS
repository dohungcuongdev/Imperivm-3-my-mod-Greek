// void, Obj This

Druid this;
Unit u;
this = This.AsDruid();
if (!.IsValid()) return;

.PlayAnim(19, .pos);
u=Place("LionSummoned", .posRH, .player);
u.SetStamina(10);
u.SetLevel(.level);
if ((!.IsHeirOf("TEnchantress")) || (EnvReadString(.player, "Control") != "researched")){
SwapSelectedObj(this, u);
.SetSummoningDeath(true);
.Damage(.health);
}
if ((.IsHeirOf("TEnchantress")) && (EnvReadString(.player, "Control") == "researched")){
.Damage(.maxhealth - 10);
}