//void

Settlement setGIn, setGDest;

Sleep(rand(1000) + 300);

while (1)
{

int AIPlayer;
int i, nMilUnits;
int time, min;
int nMagePerc;
bool bLog;

AIPlayer = AIGetPlayer;
nMilUnits = MilUnits(AIPlayer);
bLog = AIVar(AIPlayer, AIV_LogFlee) != 0 && UEnabled(AIVar(AIPlayer, AIV_LogPlayer), AIPlayer);
nMagePerc = AIVar(AIPlayer, AIV_DruidAttach);

time = GetTime / 60000;
if (time < 10) min = 15;
else if (time < 20) min = 20;
else if (time < 30) min = 31;
else min = 41;

if (4 * min < nMilUnits)
	min = nMilUnits / 4;
if (min > 41)
	min = 41;

for (i = 1; i < NumSquads(AIPlayer); i += 1)
[
	Squad sq;
	int nSqState, nSqStateTime;
	Unit sqLeader;
	
	sq = GetSquad(AIPlayer, i);
	nSqState = sq.State;
	nSqStateTime = sq.StateTime;
	sqLeader = sq.Leader;

	if (sq.Eval == 0)
		continue;
	if (!sqLeader.IsValid)
		{ if (bLog) pr("Inconsistent squad?!?"); continue; }
	if (sq.TestFlags(SF_NOAI))
		continue;
	if (sqLeader.GetFlags(UNITFLAG_NOAI))
		continue;

	if (IsWaterLsa(sq.GAIKAIn.LSA))
	{
		if (sq.InHolder || sqLeader.AsShip.IsValid)
			continue; // ships and units in ships are not "monitored"
		// todo: squad in water GAIKA, move it out (be careful not to take boarding units away)
	}

	setGIn = sq.GAIKAIn.settlement;
	setGDest = sq.AIDest.settlement;

	// approach to capture a settlement when we move around it
	if (nSqState == SS_Approach || nSqState == SS_IDLE) //if (sqLeader.command == "idle") if (sq.GAIKAIn == sq.AIDest)
	if (setGIn.IsValid)
	if (setGIn.IsIndependent)
	if ((setGIn.IsOutpost && !setGIn.IsIndependentGuarded) || setGIn.IsVillage || setGIn.IsShipyard)
	{
		point pt, ptBld;
		int nDist, nSight;
		sqLeader.SetVisible(true); sqLeader.SetLastAttackTime();
		ptBld = setGIn.GetCentralBuilding.pos;
		nDist = sqLeader.DistTo(ptBld);
		nSight = 2 * setGIn.GetCentralBuilding.sight / 3;
		if (nDist > nSight)
		{
			pt = ptBld + (sqLeader.pos - ptBld) * nSight / nDist;
			sq.Units.SetCommand("advance", pt);
			if (sq.AIDest > 0)
				sq.Units.AddCommand(false, "advance", sq.AIDest.Center);
			//pr("Player " + AIPlayer + " go to capture GAIKA " + sq.GAIKAIn.ID);
			continue;
		}
	}

	// gather staing army together
	if (nSqState == SS_Approach || nSqState == SS_IDLE)
	if (sqLeader.command == "idle")
	if (sq.GAIKAIn != sq.AIDest)
	if (setGDest.IsValid)
	if (setGDest.IsEnemy(AIPlayer))
	if (setGIn.IsOutpost || setGIn.IsVillage || setGIn.IsShipyard)
	if (setGDest.GetCentralBuilding.DistTo(sq.pos) < 2000)
	{
		int own, ally, enemy, enemy_hidden;
		sq.AIDest.Eval(AI_ALL, AIPlayer, own, ally, enemy, enemy_hidden);
		if (own + ally + sq.Eval > 2 * enemy)	{
			sq.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "advance", setGDest.GetCentralBuilding.pos);
			continue;
		}
	}

	/* the AI should send it at home! otherwise it cicles!!!
	/// staing army is better to stay at home
	if (nSqState == SS_Approach || nSqState == SS_IDLE)
	if (sqLeader.command == "idle")
	if (sq.GAIKAIn == sq.AIDest || sq.AIDest == 0)
	if (setGDest.IsValid)
	if (setGDest.IsAlly(AIPlayer))
	{
		int own, ally, enemy, enemy_hidden, nMinNeed;
		sq.GAIKAIn.Eval(AI_ALL, AIPlayer, own, ally, enemy, enemy_hidden);
		nMinNeed = sq.GAIKAIn.MinNeed(AIPlayer, own, ally, enemy);
		if (nMinNeed == 0) {
			Settlement s;
			s = NearestStronghold(sq.pos, sq.Player);
			sq.SetCmd(SS_Enter, 0, SF_ADVCHOOSER, "enter", s.GetCentralBuilding);
		}
	}
	*/

	if (nSqState != SS_IDLE)
	if (nSqState != SS_ApproachWait)
	if (nSqState != SS_Siege)
	if (nSqState != SS_Catapult)
	if (!sqLeader.InHolder)
	if (sqLeader.command == "idle")
	{ // patch fix :)
		sq.DelOrder;
		sq.SetState(SS_IDLE);
	}

	if (nSqState == SS_KillAll)
	if (sqLeader.command == "ai_killall" || sqLeader.command == "idle" || sqLeader.command == "stand_position")
	{
		if (setGDest.IsValid) if (!sqLeader.IsVisible) {
			sqLeader.SetVisible(true); sqLeader.SetLastAttackTime();
		}
		if (nSqStateTime > 60000)
			if (setGDest.IsValid)
			{
				if (setGDest.GetCentralBuilding.DistTo(sq.pos) > 500)
					sq.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "advance", setGDest.GetCentralBuilding.pos);
				else
					if (setGIn.IsAlly(AIPlayer))
						sq.SetCmd(SS_Enter, 0, SF_ADVCHOOSER, "enter", setGIn.GetCentralBuilding);
			}
			else
				sq.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
	}

	if (nSqState == SS_Catapult)
	if (!sqLeader.InHolder)
	if (sqLeader.command != "build_catapult")
		sq.SetState(SS_IDLE);

	if (nSqState == SS_IDLE)
	if (sqLeader.command == "idle")
	if (!sq.InHolder)
	if (sq.GAIKAIn == sq.AIDest)
	if (sq.GAIKAIn.StratRunning(AIPlayer) == GS_EnterSettlement)
	if (!sq.TestFlags(SF_PEACEFUL))
	if (!sq.TestFlags(SF_NOAI))
	{
		sq.SetCmd(SS_Enter, 0, SF_ADVCHOOSER, "enter", setGIn.GetCentralBuilding);
	}

	if (nSqState == SS_IDLE || nSqState == SS_Enter)
	if (sqLeader.command == "idle")
	{
		if (sq.AIDest > 0 && sq.GAIKAIn != sq.AIDest)
		{ // oops, I did it again :)
			sq.SendTo(sq.AIDest,1);
			Sleep(100);
			continue;
		}
		else // Send units from Teuton tents and other small armies at home
		{
			if (sq.Units.count <= 10)
			if (sq.Eval < 5000)
			if (sq.GAIKAIn.StratRunning(AIPlayer) == GS_NONE || sq.GAIKAIn.StratRunning(AIPlayer) == GS_EnterSettlement)
			if (!sq.TestFlags(SF_PEACEFUL) || sqLeader.AsDruid.IsValid)
			{
				if (sqLeader.GetHolderSett.IsTeutonTent)
				{
					if (rand(15) == 0)
					if (sqLeader.GetHolderSett.UnitsCount >= 8)
					{
						Settlement s;
						s = NearestStronghold(sq.pos, sq.Player);
						if (s.IsValid)
						{
							SquadList SL;
							sq.GAIKAIn.GetSquads(SL, AI_STAYING, AIPlayer); SL.Lock;
							for (0; !SL.EOL; SL.Next)
								if (SL.Cur.Leader.GetHolderSett.IsTeutonTent)	{
									sq.SetCmd(SS_Flee, 0, SF_ADVCHOOSER, "enter", s.GetCentralBuilding);
								}
							SL.Unlock;
							Sleep(100);
							continue;
						}
					}
				}
				else
					if ((!sq.InHolder && GetTime > 900000)
					  || (!sqLeader.GetHolderSett.IsStronghold && !sqLeader.AsHero.IsValid && !sqLeader.HasFreedom))
					{
						Settlement s;
						s = NearestStronghold(sq.pos, sq.Player);
						if (s.IsValid)
						{
							sq.SetCmd(SS_Flee, 0, SF_ADVCHOOSER, "enter", s.GetCentralBuilding);
							Sleep(100);
							continue;
						}
					}
			}
		}
	}

	// retreat idle units from tower range
	if (nSqState == SS_IDLE || nSqState == SS_Wait)
	if (sqLeader.command == "idle" || sqLeader.command == "stand_position") 
	if (sq.LastFightTime > GetTime-3000)
	if (sq.GetLastAttacker.IsValid)
	if (sq.GetLastAttacker.AsBuilding.IsValid || sq.GetLastAttacker.IsSentry)
	{
		point pt;
		pt = sq.pos - sq.GetLastAttacker.pos;
		pt.SetLen(100);
		sq.SetCmd(SS_IDLE, 0, SF_ADVCHOOSER, "move", sq.pos + pt);
	}

	// use ruins
	if (rand(5) == 3)
	if (AIVar(AIPlayer, AIV_UseRuins) != 0)
	if (sq.InHolder)
	if (sqLeader.AsHero)
	if (setGIn.IsStronghold)
	{
		Obj ruins;
		if (nSqState == SS_Ruins)
			sq.SetState(SS_IDLE);
		ruins = FindRuins(sq.pos, 6500, sqLeader.level);
		if (ruins.IsValid)
		{
			sqLeader.AsHero.DetachArmy;
			sq.SetCmd(SS_Ruins, 0, SF_ADVCHOOSER, "enter", ruins);
			sqLeader.AddCommand(false, "enter", setGIn.GetCentralBuilding);
			Sleep(100);
			continue;
		}
	}
	
	// use items
	if (AIVar(AIPlayer, AIV_UseItems) != 0)
	{
		if (sqLeader.AsHero.IsValid)
		{
			if (sqLeader.item_count > 0)
			{
				if (sqLeader.HasItem("Poison Mushroom") == true)
				{
					if(sq.health > sq.maxhealth * 90 / 100)
					{
						// L'eroe usa funghi velenosi se ALMENO una delle seguenti condizioni si verifica:
						// 1) Possiede ALMENO un oggetto tra "Erba curativa" e "Zanna di elefante"
						// 2) Non ci sono unità nemiche nel suo raggio visivo.
						if(sqLeader.HasItem("Healing herbs") == true || sqLeader.HasItem("Elephant Tusk") == true || sqLeader.EnemiesInSight() == false)
						{
							sqLeader.UseItem("Poison Mushroom");
						}	//Fine if.
					}	//Fine if.
				}	//Fine if.

				if (sqLeader.HasItem("Healing herbs"))
				if (sqLeader.health < sqLeader.maxhealth / 2)
					sqLeader.UseItem("Healing herbs");

				if (sqLeader.HasItem("Healing water"))
				if ((sq.health < sq.maxhealth / 2) || (sq.health <= sq.maxhealth - 1000))
					sqLeader.UseItem("Healing water");

				if (sqLeader.HasItem("Ash of druid heart"))
				if ((sqLeader.health < sqLeader.maxhealth / 2) || (sq.health < sq.maxhealth / 2))
					sqLeader.UseItem("Ash of druid heart");

				if (sqLeader.HasItem("Rye spikes"))
				if (sq.food < sq.Size * 3 / 2)
					sqLeader.UseItem("Rye spikes");

				if (rand(3) == 1) // Don't use too often
				if (sqLeader.HasItem("Horn of victory") || sqLeader.HasItem("Finger of death"))
				{
					int own, ally, enemy, enemy_hidden, nMinNeed;
					sq.GAIKAIn.Eval(AI_ALL, AIPlayer, own, ally, enemy, enemy_hidden);
					nMinNeed = sq.GAIKAIn.MinNeed(AIPlayer, own, ally, enemy);
					if (own + ally < nMinNeed*5/4) // we are losing here
					{
						if (sqLeader.HasItem("Horn of victory"))
							sqLeader.UseItem("Horn of victory");
						if (sqLeader.HasItem("Finger of death"))
							sqLeader.UseItem("Finger of death");
					}
				}
			}
		}	//Fine if.
	}	//Fine if.
	
	if (AIVar(AIPlayer, AIV_FeedWithWagons) != 0)
	if (nSqState != SS_Flee)
	if (sq.Eval >= 3000)
	{ // check feeding
		int dist, food, needed;
		dist = sq.pos.Dist(sq.AIDest.Center) + 200; // add 200 to help feeding already hungry squads :)
		food = sq.food + sq.FoodComing;
		needed = sq.Size * dist / 700;
		if (AIVar(AIPlayer, AIV_SynchApproach))
			needed = needed*4/3;
		if (food + 100 < needed) // don't ask for less than 100 food
		if (sq.SendFoodWagon(needed - food, 3000))
		if (AIVar(AIPlayer, AIV_LogFeed) != 0)
			UserNotification("location message", "Sent food wagon", sq.pos, AIPlayer);
	}

	// Stop for healing
	if (sqLeader.AsHero)
	if (!sq.InHolder)
	if (nSqState == SS_Flee)
	if (!sqLeader.BestTargetInSquadSight.IsValid)
	if (sq.food > 100)
	{
		int nHealers, nThreshold = 7;
		nHealers = sq.Count("GDruid");
		if (nHealers < nThreshold)
			nHealers += sq.Count("RPriest");
		if (nHealers >= nThreshold)	{
			sq.SetCmd(SS_IDLE, 0, SF_ADVCHOOSER, "move", sqLeader.pos);
		}
	}

	// Flee logic
	if (nSqState != SS_Flee)
	if (nSqState != SS_Ruins)
	{ // --------- hero squad
		// Init druid attaching for the hero
		if (sqLeader.AsHero)
		/*
		if (sq.Size == 1)
			if (rand(100) < AIVar(AIPlayer, AIV_DruidAttach))
				sq.SetState(nSqState, SF_WANTDRUIDS, 0);
			else
				sq.SetState(nSqState, 0, SF_WANTDRUIDS);
		*/
		/*if (sq.DestGAIKA != sq.SrcGAIKA) */
		{ // check flee
			bool bHeroHurt = false;
			bool bDetachArmy = false;
			int nFlee = 0; // 1 - smallarmy | 2 - herosick | 4 - armysick | 8 - losing
  
			//if (sq.Size < min - 10) nFlee += 1; // army too small in number
			if (sqLeader.AsHero)
			if (sqLeader.health < sqLeader.maxhealth / 2)
			if (sqLeader.BestTargetInSquadSight.IsAlive)
			{	// hero badly hurt in battle
				bHeroHurt = true;
				nFlee += 2; 
				if (sqLeader.health < sqLeader.maxhealth / 3)
					bDetachArmy = true;
			}
			if (AIVar(AIPlayer, AIV_Coward) != 0)
			{
				bool bFleeCheck = false;
				if (sq.health < sq.maxhealth / 2)
					nFlee += 4; // army sick
				if (sq.AIDest == sq.GAIKAIn)
					bFleeCheck = true;
				if (!bFleeCheck)
				if (setGIn.IsTeutonTent)
				if (setGIn.IsEnemy(AIPlayer))
				if (sqLeader.command == "engage")
					bFleeCheck = true;
				if (bFleeCheck)
				{
					int own, ally, enemy, enemy_hidden, nMinNeed;
					sq.GAIKAIn.Eval(AI_ALL, AIPlayer, own, ally, enemy, enemy_hidden);
					nMinNeed = sq.GAIKAIn.MinNeed(AIPlayer, own, ally, enemy);
					if (own + ally < nMinNeed / 2) // we are losing here
						nFlee += 8;
				}
			}

			if (!bHeroHurt)
			if (nFlee != 0)
			if (nFlee != 8)
			{ // willing to flee, en-route, more than just losing
				int own, ally, enemy, enemy_hidden, nMinNeed;
				sq.AIDest.Eval(AI_COMING + AI_STAYING, AIPlayer, own, ally, enemy, enemy_hidden);
				nMinNeed = sq.GAIKAIn.MinNeed(AIPlayer, own, ally, enemy);
				if (own + ally >= nMinNeed)
				if (own + ally - sq.Eval < nMinNeed)
				if (own + ally - sq.Eval > 0)
				if (sq.Size > 6)
					nFlee = 0; // don't flee if others can't do it without you ;)
			}

			if (nFlee != 0)
			{
				int own, ally, enemy, enemy_hidden;
				sq.GAIKAIn.Eval(AI_STAYING, AIPlayer, own, ally, enemy, enemy_hidden);
				enemy += sq.GAIKAIn.Eval(AI_LEAVING, AIPlayer, AI_ENEMY);
				if (enemy == 0)
				if (setGIn.IsEnemy(AIPlayer))
				if (setGIn.CanBeCaptured)
					nFlee = 0;

				if (enemy != 0)
				if (nFlee == 1) // if enemies around, don't flee only because army is small
					nFlee = 0;

				if (nFlee != 0)
				{
					GAIKA gFlee; gFlee = NearestHospital(sq);
					if (gFlee == 0)	{
						int nHomeGaikaID;
						nHomeGaikaID = EnvReadInt(AIPlayer, "HomeGaika");
						if (nHomeGaikaID > 0)
							gFlee = GetGAIKA(nHomeGaikaID);
					}

					if (nFlee == 1)
					if (gFlee.LSA != sq.GAIKAIn.LSA)
					{ // don't go for reequip only if offshore
						Sleep(100);
						continue;
					}

					if (nFlee == 8)
					if (sq.AIDest != sq.GAIKAIn)
					{ // ambushed but otherwise OK, decide where to flee
						int distGoal, distHospital;
						// try to go around
						if (sq.DestGAIKA == sq.AIDest)
						if (sqLeader.command == "move"
						 || sqLeader.command == "sneak"
						 || sqLeader.command == "advance"
						 || sqLeader.command == "enter")
						{
							SetMAIKA(sq.SrcGAIKA, sq.AIDest, sq.GAIKAIn);
							if (AIVar(AIPlayer, AIV_GoAround) != 0)
							if (sq.CalcGoAround)
							{ // worked :)
								//UserNotification("location message", "Hero go around", sq.pos, AIPlayer);
								//SetSpeed(0);
								Sleep(100);
								continue;
							}  
						}
						distGoal = sq.pos.Dist(sq.AIDest.Center);
						distHospital = sq.pos.Dist(gFlee.Center);
						if (distGoal >= 1500)
						if (distGoal < distHospital)
							gFlee = sq.AIDest;
					}

					if (gFlee == 0)
						nFlee = 0;
					else
						if (gFlee == sq.GAIKAIn)
							if (enemy != 0)
								nFlee = 0;
							else
								if (nSqState == SS_Enter)
									nFlee = 0;

					if (nFlee != 0)
					{
						if (bLog) {
							str dbg = "";
							if (UEnabled(nFlee, 0)) dbg = dbg + " (reequip)";
							if (UEnabled(nFlee, 1)) dbg = dbg + " (herosick)";
							if (UEnabled(nFlee, 2)) dbg = dbg + " (armysick)";
							if (UEnabled(nFlee, 3)) dbg = dbg + " (losing)";
							UserNotification("location message", "Squad fled" + dbg, sq.pos, AIPlayer);
							pr(dbg);
						}
						SetMAIKA(sq.SrcGAIKA, sq.AIDest, sq.GAIKAIn);
						sq.SetState(SS_Flee);
						if (bDetachArmy)
							sqLeader.AsHero.DetachArmy;
						if (AIVar(AIPlayer, AIV_Coward) != 0)
							sq.SendTo(gFlee, 1000);
						else
							sq.SendTo(gFlee, 1);
						Sleep(100);
						continue;
					}
				}
			}
		}

		// take items from nearby item holders
		if (sqLeader.AsHero)
		if (AIVar(AIPlayer, AIV_TakeItems) != 0)
		if (sq.TakeNearbyItems(sqLeader.sight))
		{
			// UserNotification("location message", "Found item", sq.pos, AIPlayer);
			Sleep(100);
			continue;
		}
	}

	if (nSqState == SS_Flee)
	{
		if (sq.InHolder)
			sq.SetState(SS_IDLE);
		else
		{
			bool bStop = true;
			if (sqLeader.AsHero.IsValid)
			if (sqLeader.health < sqLeader.maxhealth / 3)
				sqLeader.AsHero.DetachArmy;
			if (sq.pos.Dist(sq.AIDest.Center) > 1500)
			if (sqLeader.BestTargetInSquadSight.IsValid)
				bStop = false;
			if (bStop) 
				if (sq.GAIKAIn == sq.AIDest)
				{
					if (!setGIn.IsAlly(AIPlayer))
						sq.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
					else
						if (setGIn.IsFull)
							sq.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
						else
							sq.SetCmd(SS_Enter, 0, SF_ADVCHOOSER, "enter", setGIn.GetCentralBuilding);
					Sleep(100);
					continue;
				}
				else
					if (AIVar(AIPlayer, AIV_Coward) != 0)
					if (sq.Size >= min - 10)
					if (sqLeader.health >= sqLeader.maxhealth / 2)
					if (sq.health >= sq.maxhealth / 2)
					{
						/*sq.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);//*/ sq.SetState(SS_Approach);
						Sleep(100);
						continue;
						if (bLog) { 
						 UserNotification("location message", "Squad flee stopped", sq.pos, AIPlayer);
						 //if (CurPlayer == AIPlayer) if (!setGDest.IsStronghold) SetSpeed(0);
						}
					}
		}
	}

	// attach free units
	if (!sq.TestFlags(SF_PEACEFUL) || sqLeader.AsDruid.IsValid)
	if (!sqLeader.AsShip.IsValid)
	if (!sqLeader.HasFreedom)
	if (nSqState != SS_Catapult)
	if (nSqState != SS_Train)
	if (nSqState != SS_Flee)
	if (!sqLeader.IsHeirOf("IEnchantress") || IsResearched(AIPlayer, "Cover of Mercy")) // enchantress are useless in combat without combat magic
	{
		Unit BestHero;
		int BestEval = 0;

		{	SquadList SL; // this scope is to ensure SquadList destruction
			for (sq.GAIKAIn.GetSquads(SL, AI_STAYING + AI_LEAVING, AIPlayer, AI_OWN); !SL.EOL; SL.Next)
			{
				int eval;
				if (SL.Cur.TestFlags(SF_NOAI)) continue;
				if (SL.Cur.Leader.GetFlags(UNITFLAG_NOAI)) continue;
				eval = sq.EvalAttach(SL.Cur.Leader, min);
				if (eval == 0) continue;

				if (SL.Cur.State == SS_Ruins || SL.Cur.State == SS_Flee)
					continue;
				if (sqLeader.AsDruid.IsValid)
				{
					int nWant; nWant = SL.Cur.Units.count * nMagePerc / 100 - SL.Cur.Count("BaseMage");
					if (nWant > 0)
						eval = eval * nWant;
					else
						continue;
				}
				if (SL.Cur.Size != 1)
				if (SL.Cur.Count("Horse") == SL.Cur.Size - 1)
				if (sq.Count("Horse") != sq.Size)
					{ /*pr("Refusing to attach non-horse units");*/ continue; }

				if (eval > BestEval) 
					{ BestHero = SL.Cur.Leader; BestEval = eval; }
			}
		}
		if (BestEval > 0)
			if (!sqLeader.AsHero.IsValid)
			{
				bool bAttached = true;
				if (!BestHero.InHolder || sq.InHolder)
				{
					if (!sq.InHolder && nSqState == SS_Attach)
						bAttached = false;
					sq.SetCmd(SS_Attach, 0, SF_ADVCHOOSER, "attach", BestHero);
				} else
					if (setGIn.IsValid)
						sq.SetCmd(SS_Attach, 0, SF_ADVCHOOSER, "enter", setGIn.GetCentralBuilding);
				if (bAttached) {
					Sleep(100); 
					continue;
				}
			}
			else
				if (BestHero != sqLeader.AsHero)
				if (sq.Size > 1)
				if (sq.Size < 51)
				if (BestHero.InHolder)
				if (sqLeader.SameHolderAs(BestHero))
				{	// check if worth transfering army
					int e1, e2;
					e1 = (101 - min) * (1 + sqLeader.level / 5); // cur hero eval after detach
					e2 = BestHero.GetSquad.Size + sq.Size - 1; // best hero squad size after attach
					if (e2 < min)
						e2 = 100 - (min - e2);
					else
						e2 = e2 - min + 1;
					e2 = e2 * (1 + BestHero.level / 50); // best hero eval after attach
					if (e1 < e2)
					{ // still worh it
						sqLeader.AsHero.DetachArmy;
						Sleep(100);
						continue;
					}
				}
	}
	if (nSqState == SS_Attach)
	if (sqLeader.command == "idle")
	{
		sq.DelOrder;
		sq.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
		Sleep(100);
		continue;
	}

	// peaceful go around
	if (sq.TestFlags(SF_PEACEFUL))
	if (sq.AIDest != sq.GAIKAIn)
	if (sq.AIDest != sq.SrcGAIKA)
	if (sq.DestGAIKA == sq.AIDest)
	if (sqLeader.command == "move" || sqLeader.command == "enter"|| sqLeader.command == "unload")
	{ 
		int own, ally, enemy, enemy_hidden;
		sq.GAIKAIn.Eval(AI_STAYING, AIPlayer, own, ally, enemy, enemy_hidden);
		if (enemy > 1000)
		if (own + ally < 500)
		{ // peaceful go around
			SetMAIKA(sq.SrcGAIKA, sq.AIDest, sq.GAIKAIn);
			if (AIVar(AIPlayer, AIV_GoAround) != 0)
			if (sq.CalcGoAround)
			{
				//UserNotification("location message", "Peaceful go around", sq.pos, AIPlayer);
				//SetSpeed(0);
				Sleep(100);
				continue;
			}
		}
	}
	if (sq.TestFlags(SF_PEACEFUL))
	if (sqLeader.command == "idle")
	if (!sq.InHolder)
	{
		Settlement s; s = NearestStronghold(sqLeader.pos, AIPlayer);
		if (s.IsValid)
			sq.SetCmd(SS_Enter, 0, SF_ADVCHOOSER, "enter", s.GetCentralBuilding);
	}
	
	if (sqLeader.AsHero)
	if (setGIn.IsStronghold)
	{
		int nMages, nWant, nBalance;
		nMages = sq.Count("BaseMage");
		nWant = sq.Units.count * nMagePerc / 100;
		nBalance = nMages - nWant;
		if (nBalance > 0)
		{
			ObjList olDetach;
			Hero hero; hero = sqLeader.AsHero;
			
			for (i = 0; i < sq.Units.count; i += 1)
			{
				Unit u; u = sq.Units[i].AsUnit;
				if (!u.IsValid) continue;
				if (!u.IsHeirOf("BaseMage")) continue;
				olDetach.Add(u);
				nBalance -= 1;
				if (nBalance <= 0)
					break;
			}
			for (i = 0; i < olDetach.count; i += 1)
				olDetach[i].AsUnit.DetachFrom(hero);
		}
	}

	// Nothing for this squad
	Sleep(50);
]

Sleep(AIVar(AIPlayer, AIV_Sleep_SquadMonitor));
}
