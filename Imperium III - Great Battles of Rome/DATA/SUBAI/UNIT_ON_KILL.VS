//void, Obj this, Obj Victim

if (!.IsValid())
	return;

// Kills statistic
if (.AsUnit.IsValid)
if (!.AsUnit.IsDead())
	{
	.AsUnit.IncKills(1);
	}

// Egypt
.AsUnit.RemoveItemsOfType("Damage charm");
.AsUnit.RemoveItemsOfType("Armor charm");
.AsUnit.RemoveItemsOfType("Health charm");
.AsUnit.RemoveItemsOfType("Knowledge charm");

if (EnvReadString(.player, "Path of the dead I") == "researched")
  {
	if (.AsUnit().inherentlevel < 4 )
	  .AsUnit().SetLevel(4);
  }

if (EnvReadString(.player, "Path of the dead II") == "researched")
  {
	if (.AsUnit().inherentlevel < 8 )
	  .AsUnit().SetLevel(8);
  }

if (EnvReadString(.player, "Path of the dead III") == "researched")
  {
	if (.AsUnit().inherentlevel < 12 )
	  .AsUnit().SetLevel(12);
  }

//
if (EnvReadString(.player, "Spoils of war") == "researched") {
	.AddItem("Spoils of War");
}

// rArena items
if (EnvReadString(.player, "Veteran Offence") == "researched") {
	if (!.HasItem("Veteran Offence"))
	  .AddItem("Veteran Offence");
}

if (EnvReadString(.player, "Veteran Defence") == "researched") {
	if (!.HasItem("Veteran Defence"))
  		.AddItem("Veteran Defence");
}

if (EnvReadString(.player, "Veteran Health") == "researched") {
	if (!.HasItem("Veteran Health"))
      	.AddItem("Veteran Health");
}

// Britain
if (.AsUnit().inherentlevel >= 12)
{
	if (EnvReadString(.player, "Noble Offence") == "researched") {
		if (!.HasItem("Noble Offence"))
			.AddItem("Noble Offence");
	}

	if (EnvReadString(.player, "Noble Defence") == "researched") {
		if (!.HasItem("Noble Defence"))
  		.AddItem("Noble Defence");
	}
}

// Greece
if (.AsUnit().inherentlevel >= 10 && .AsUnit().free_item_slots>0){
	if (EnvReadString(.player, "Charm of Athena") == "researched") {
		if (!.HasItem("Charm of Athena"))
			.AddItem("Charm of Athena");
	}

	if (EnvReadString(.player, "Charm of Aegle") == "researched") {
		if (!.HasItem("Charm of Aegle"))
  		.AddItem("Charm of Aegle");
	}
}

if (EnvReadString(.player, "Gambler's Day") == "researched")
	if (Victim.AsUnit)
	if (!Victim.IsSentry)
		if (.AsUnit().inherentlevel < Victim.AsUnit().inherentlevel)
		{
			int chance;
			chance = EnvReadInt(.player, "GamblersDayChance");
			if (rand(100) < chance)
			{
				.AsUnit.SetLevel(Victim.AsUnit.inherentlevel);
			}
		}

if (EnvReadString(.player, "Statue of Zeus") == "researched")
	if (Victim.AsUnit)
	if (!Victim.IsSentry)
		if (.AsUnit().health>=1 && .AsUnit().health<=.AsUnit().maxhealth/10){
			int chance;
			chance = 50;
			if (rand(100) < chance){
				CreateFeedback("Heal", .AsUnit());
				.AsUnit.SetHealth(.AsUnit.maxhealth);
			}
		}
		
if (EnvReadString(.player, "Tales of Hero I") == "researched") {
	if (.AsHero().IsValid && !.HasItem("Belt of snakes"))
  		.AddItem("Belt of snakes");
}

if (EnvReadString(.player, "Tales of Hero II") == "researched") {
	if (.AsHero().IsValid && !.HasItem("King's Belt"))
      	.AddItem("King's Belt");
}

if (EnvReadString(.player, "Strength of Anubis") == "researched") {
	if (.AsHero().IsValid && .AsHero().inherentlevel >= 30 && !.HasItem("Anubis Helmet"))
  		.AddItem("Anubis Helmet");
}

if (EnvReadString(.player, "Strength of Horus") == "researched") {
	if (.AsHero().IsValid && .AsHero().inherentlevel >= 30 && !.HasItem("Horus Sword"))
      	.AddItem("Horus Sword");
}