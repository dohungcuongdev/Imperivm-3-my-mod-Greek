// void, Obj This
Building this;

this = This.AsBuilding();

if(EnvReadInt(.settlement,"IsStoring")==true){
	if(.IsValid() && .settlement.GetCentralBuilding().IsValid()){
		if(EnvReadInt(.settlement,"FoodStorage")<100000000){
			if(.settlement.food>0){
				if(.settlement.food<5){
					EnvWriteInt(.settlement,"FoodStorage",EnvReadInt(.settlement,"FoodStorage")+.settlement.food);
					.settlement.SetFood(0);
				}
				if(.settlement.food>=5){
					EnvWriteInt(.settlement,"FoodStorage",EnvReadInt(.settlement,"FoodStorage")+5);
					.settlement.SetFood(.settlement.food-5);
				}
			}
		}
	}
}
Sleep(2000);