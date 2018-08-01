// void, Obj This

Druid this;
Unit u;
ObjList ol;
int HealthDistrubute, Give, i;

this = This.AsDruid;

if (.InHolder())
	return;

if (.race == Germany || .race == Britain)
if (EnvReadString(.player, "Mass Heal") == "researched")
{
	ol = ObjsInCircle(.pos, .sight, "Unit").GetObjList();
	HealthDistrubute = 1000;
	for(i = 0; i < ol.count; i += 1) {
		u = ol[i].AsUnit();
		if (!u.IsValid()) continue;
		if (.IsEnemy(u)) continue;
		
		if (u.health < u.maxhealth) {
			CreateFeedback("Heal", u);
			Give = u.maxhealth - u.health;
			if (Give > HealthDistrubute) Give = HealthDistrubute;
			HealthDistrubute -= Give;
			u.Heal(Give);
			if (HealthDistrubute == 0) break;
		}
	}
}

if (.race == Gaul || .race == ImperialRome)
if (EnvReadString(.player, "Restoration") == "researched")
{
	int nRestored = 0;
	ol = ObjsInCircle(.pos, .sight, "Unit").GetObjList();

	for (i = 0; i < ol.count; i += 1)
	{
		u = ol[i].AsUnit();
		if (!u.IsValid()) continue;
		if (.IsEnemy(u)) continue;
		if (u.stamina >= u.maxstamina) continue;
		u.SetStamina(u.maxstamina);
		CreateFeedback("StaminaBoost", u);
		nRestored += 1;
		if (nRestored >= 5)
			break;
	}
}
