//void, int player
int i;
ObjList units;

while(true){
	Sleep(20000);
	units=Substract(ClassPlayerObjs("Unit",player),ClassPlayerObjs("Sentry",player)).GetObjList();
	for(i=0;i<units.count;i=i+1){
		Unit u;
		
		u=units[i];
		if(u.IsValid()){
			if(u.food>0 && u.feeds==true){
				if(u.food<u.maxfood){
					u.SetFood(u.food+1);
				}
				if(u.food>u.maxfood){
					u.SetFood(u.maxfood);
				}
			}
		}
	}
}