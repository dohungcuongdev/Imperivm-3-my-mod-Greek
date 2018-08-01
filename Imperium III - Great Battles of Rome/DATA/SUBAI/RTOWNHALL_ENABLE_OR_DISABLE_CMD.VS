// void, Obj This

Building this;
Unit rFlag, iFlag;

this = This.AsBuilding();

if( (EnvReadString(.settlement, "ChooseRepublicanRome") == "researched") || (EnvReadString(.settlement, "ChooseImperialRome") == "researched") )
{
	.CmdDisable("ChooseRepublicanRome");
	Sleep(50);
	.CmdDisable("ChooseImperialRome");
	Sleep(50);
	.CmdEnable("createfoodmule1");
	Sleep(50);
	.CmdEnable("creategoldmule1");
	Sleep(50);
	.CmdEnable("createfoodmule2");
	Sleep(50);
	.CmdEnable("creategoldmule2");
	Sleep(50);
	.CmdEnable("autotrain_start_gr");
	Sleep(50);
	.CmdEnable("townhall_military_training");
	Sleep(50);
	.CmdEnable("autotrain_stop_gr");
	Sleep(50);

	if( (EnvReadString(.settlement, "ChooseRepublicanRome") == "researched") ){
		rFlag=.settlement.ObjectsAround("RepublicanRomeFlag")[0];
		iFlag=.settlement.ObjectsAround("ImperialRomeFlag")[0];
		if( !rFlag.IsValid() )
		{
			rFlag = Place("RepublicanRomeFlag", .pos + Point(167, -225), .player);
		}
		if( iFlag.IsValid() )
		{
			iFlag.Erase();
		}
	}
	else{
		if( (EnvReadString(.settlement, "ChooseImperialRome") == "researched") ){
			rFlag=.settlement.ObjectsAround("RepublicanRomeFlag")[0];
			iFlag=.settlement.ObjectsAround("ImperialRomeFlag")[0];
			if( !iFlag.IsValid() )
			{
				iFlag = Place("ImperialRomeFlag", .pos + Point(167, -225), .player);
			}
			if( rFlag.IsValid() )
			{
				rFlag.Erase();
			}
		}
	}//End if.
}
else{
	.CmdEnable("ChooseRepublicanRome");
	Sleep(50);
	.CmdEnable("ChooseImperialRome");
	Sleep(50);
	.CmdDisable("createfoodmule1");
	Sleep(50);
	.CmdDisable("creategoldmule1");
	Sleep(50);
	.CmdDisable("createfoodmule2");
	Sleep(50);
	.CmdDisable("creategoldmule2");
	Sleep(50);
	.CmdDisable("autotrain_start_gr");
	Sleep(50);
	.CmdDisable("townhall_military_training");
	Sleep(50);
	.CmdDisable("autotrain_stop_gr");
	Sleep(50);
}

Sleep(1000);

// Edit by Riccardo "Highlander" Tedesco (Alias Ricky1996, Ricky96Highlander)