// void, Obj This, point pt

Druid this;
Unit tgt;
int  time, retries, try;
ObjList olEnemy;

this = This.AsDruid;

time = GetConst("RetryWait");
retries = GetConst("RetryCount");

if (.IsEnemyInSquadSight){
	olEnemy = Intersect(ObjsInSight(this, "Military"), EnemyObjs(.player, "Military")).GetObjList();
	olEnemy.ClearDead();
	tgt = olEnemy[rand(olEnemy.count)].AsUnit;
}
if (!tgt.IsAlive)
	while (!.Goto(pt, 0, 2000, true, -1))
	{
		olEnemy = Intersect(ObjsInSight(this, "Military"), EnemyObjs(.player, "Military")).GetObjList();
		olEnemy.ClearDead();
		tgt = olEnemy[rand(olEnemy.count)].AsUnit;
		if (tgt.IsAlive) break;
		if (.TimeWithoutWalking() > 2500) break;
	}

if (!tgt.IsAlive)
{
	olEnemy = Intersect(ObjsInSight(this, "Military"), EnemyObjs(.player, "Military")).GetObjList();
	olEnemy.ClearDead();
	tgt = olEnemy[rand(olEnemy.count)].AsUnit;
	while (try < retries && !tgt.IsAlive)
	{
		Sleep(time);
		olEnemy = Intersect(ObjsInSight(this, "Military"), EnemyObjs(.player, "Military")).GetObjList();
		olEnemy.ClearDead();
		tgt = olEnemy[rand(olEnemy.count)].AsUnit;
		try += 1;
	}
}
if (tgt.IsAlive)
{
	.AddCommand(true, "advance", pt);
	.AddCommand(true, "curse", tgt);
}
