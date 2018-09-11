//void

Hero h;
Query alliesHeroesQuery;
ObjList alliesHeroesOL;
int alliesHeroesCounter;
int heroesCounter;

alliesHeroesQuery = ClassPlayerObjs("Hero", AIGetPlayer);

while(true) 
{
	alliesHeroesOL = alliesHeroesQuery.GetObjList();

	for(heroesCounter = 0; heroesCounter < alliesHeroesOL.count(); heroesCounter += 1)
	{
		h = alliesHeroesOL[heroesCounter].AsHero();
		
		if(h.IsValid() == true && h.EnemiesInSight() == false)
		{
			for(alliesHeroesCounter = 0; alliesHeroesCounter < alliesHeroesOL.count(); alliesHeroesCounter += 1)
			{
				Hero allyHero;
				allyHero = alliesHeroesOL[alliesHeroesCounter].AsHero();
				
				if(allyHero.IsValid() == true && allyHero != h && allyHero.EnemiesInSight() == false)
				{
					if(allyHero.DistTo(h) <= (h.sight() * 5 / 6) && allyHero.free_item_slots() >= 1)
					{
						int heroItemsCounter1, //Contatore per gli oggetti dell'eroe.
						   heroItemsCounter2; //Contatore per gli oggetti dell'eroe successivi al valore di heroItemsCounter1.
							 Item heroItem; //Un oggetto dell'eroe.

						for(heroItemsCounter1 = 1; heroItemsCounter1 <= (h.items_count() - 1) && allyHero.free_item_slots() >= 1; heroItemsCounter1 += 1)
						{
							heroItem = h.GetItem(heroItemsCounter1);

							//pr("heroItemsCounter1 = " + heroItemsCounter1 + " name = " + heroItem.name());

							for(heroItemsCounter2 = heroItemsCounter1 + 1; heroItemsCounter2 <= h.items_count(); heroItemsCounter2 += 1)
							{
								if(heroItem.name() == h.GetItem(heroItemsCounter2).name() && allyHero.HasItem(heroItem.name()) == false)
								{
									//I due eroi si vanno incontro. Aspetta che si siano raggiunti.
									while(h.DistTo(allyHero) >= 15 && h.IsValid() == true && allyHero.IsValid() == true)
									{
										h.SetCommand("move", allyHero.pos());
										allyHero.SetCommand("move", h.pos());
										Sleep(100);
									}  //Fine del while.

									h.GiveItem(heroItem, allyHero);
									Sleep(200);
									break;
								}  //Fine if.
							}  //Fine del for.
						}  //Fine del for.
					}  //Fine if.
				}  //Fine if.
			}	//Fine del for.
		}	//Fine if.
	}  //Fine if.
}  //Fine while.


/* Totally edited by "Imperivm World Team", in particular by Riccardo "Highlander" Tedesco (Ricky96Highlander). */
/* Visit http://imperivm-world.forumcommunity.net/ */
