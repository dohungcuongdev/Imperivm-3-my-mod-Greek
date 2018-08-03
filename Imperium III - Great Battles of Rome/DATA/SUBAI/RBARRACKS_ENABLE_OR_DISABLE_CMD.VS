// void, Obj This

Building this;

this = This.AsBuilding();

if( (EnvReadString(.settlement, "ChooseRepublicanRome") == "researched") || (EnvReadString(.settlement, "ChooseImperialRome") == "researched") )
{
	.CmdEnable("Barrack Level 1");
	Sleep(50);
	.CmdEnable("Barrack Level 2");
	Sleep(50);
	.CmdEnable("Barrack Level 3");
	Sleep(50);
	.CmdEnable("trainRHastatus");
	Sleep(50);
	.CmdEnable("trainRArcher");
	Sleep(50);
	.CmdEnable("trainRPrinciple");
	Sleep(50);
	.CmdEnable("trainRScout");
	Sleep(50);
		
	if(EnvReadString(.settlement, "ChooseRepublicanRome") == "researched")
	{
		.CmdEnable("trainRGladiator");
		Sleep(50);
		.CmdEnable("trainRTribune");
		Sleep(50);
		.CmdEnable("Equip Chariot");
		Sleep(50);
		.CmdDisable("trainIRVelit");
		Sleep(50);
		.CmdDisable("trainIRPraetorian");
		Sleep(50);
	}	//End if.
	else
	{
		.CmdDisable("trainRGladiator");
		Sleep(50);
		.CmdDisable("trainRTribune");
		Sleep(50);
		.CmdDisable("Equip Chariot");
		Sleep(50);
		.CmdEnable("trainIRVelit");
		Sleep(50);
		.CmdEnable("trainIRPraetorian");
		Sleep(50);
	}	//End else.
}	//End if.
else
{
	.CmdDisable("Barrack Level 1");
	Sleep(50);
	.CmdDisable("Barrack Level 2");
	Sleep(50);
	.CmdDisable("Barrack Level 3");
	Sleep(50);
	.CmdDisable("trainRHastatus");
	Sleep(50);
	.CmdDisable("trainRArcher");
	Sleep(50);
	.CmdDisable("trainRPrinciple");
	Sleep(50);
	.CmdDisable("trainRScout");
	Sleep(50);
	.CmdDisable("trainRGladiator");
	Sleep(50);
	.CmdDisable("trainRTribune");
	Sleep(50);
	.CmdDisable("Equip Chariot");
	Sleep(50);
	.CmdDisable("trainIRVelit");
	Sleep(50);
	.CmdDisable("trainIRPraetorian");
	Sleep(50);
}	//End else.

Sleep(1000);

// Edit by Riccardo "Highlander" Tedesco (Alias Ricky1996, Ricky96Highlander)