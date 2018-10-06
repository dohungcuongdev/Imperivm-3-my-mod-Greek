// void, Obj This

Druid this;
Unit u;
this = This.AsDruid();
if (!.IsValid()) return;

.PlayAnim(19, .pos);
u=Place("LionFSummoned", .posRH, .player);
u.SetStamina(10);
u.SetLevel(.level);

.Damage(.maxhealth - 10);