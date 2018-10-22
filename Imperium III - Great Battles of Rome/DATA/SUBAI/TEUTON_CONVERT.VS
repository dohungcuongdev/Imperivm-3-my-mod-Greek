// void, Obj This

Unit this;
str tt;
this = This.AsUnit();

Sleep(1000);

if(.IsValid){
	if(.IsAlive){
		if (.IsHeirOf("SBVikingLord")) 
			tt = "SBBronzeSpearman";
		if (.IsHeirOf("SBBronzeSpearman")) 
			tt = "SBShieldBearer";
		else if (.IsHeirOf("SBShieldBearer")) 
			tt = "SCLibyanFootman";
		else if (.IsHeirOf("SCLibyanFootman")) 
			tt = "SCNoble";
		else if (.IsHeirOf("SCNoble")) 
			tt = "SEGuardian";
		else if (.IsHeirOf("SEGuardian")) 
			tt = "SEHorusWarrior";
		else if (.IsHeirOf("SEHorusWarrior")) 
			tt = "SIEliteGuard";
		else if (.IsHeirOf("SIEliteGuard")) 
			tt = "SIDefender";
		else if (.IsHeirOf("SIDefender")) 
			tt = "STSwordsman";
		else if (.IsHeirOf("STSwordsman")) 
			tt = "STMaceman";
		else if (.IsHeirOf("STMaceman")) 
			tt = "SGAxeman";
		else if (.IsHeirOf("SGAxeman")) 
			tt = "SGSpearman";
		else if (.IsHeirOf("SGSpearman"))
			tt = "SRTribune";
		else if (.IsHeirOf("SRTribune")) 
			tt = "SRPrinciple";
		else if (.IsHeirOf("SRPrinciple"))
			tt = "Rlider2";
		else if (.IsHeirOf("Rlider2")) 
			tt = "Rlider3";
		else if (.IsHeirOf("Rlider3")) 
			tt = "SBVikingLord";
		//while(!.Stop(1000));
		.Mutate(tt);
	}
}