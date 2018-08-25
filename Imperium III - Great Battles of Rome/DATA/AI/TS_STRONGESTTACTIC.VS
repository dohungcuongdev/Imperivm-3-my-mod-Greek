// void, Settlement set
if (EnvReadInt(set, "StrongestTactic") == 1) 
	return;

if (EnvReadInt(set,"StopTacticScript") == 1)
	return;

EnvWriteInt(set, "StrongestTactic",1);
