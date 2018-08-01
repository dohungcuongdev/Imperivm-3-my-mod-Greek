//void, Obj This

Building this;
int i,pNumber,pRace,sentriesLevel,timer;
str sRace,s0Act,s1Act,s2Act,s3Act,s4Act,s5Act,s6Act,s7Act,s8Act,s9Act,s10Act,s11Act;
ObjList postSentries,e0,e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11;
IntArray posX,posY;
Unit s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11;

this = This.AsBuilding();
pNumber=.player;
if(.settlement.IsIndependent()){
	sRace="G";
}
else{
	pRace=GetPlayerRace(pNumber);
	if(pRace==ImperialRome){
		sRace="H";
	}
	else{
		sRace=GetRaceStrPref(pRace);
	}
}
posX[0]=-247;posX[1]=-281;posX[2]=-247;posX[3]=19;
posX[4]=-32;posX[5]=65;posX[6]=0;posX[7]=-50;
posX[8]=45;posX[9]=260;posX[10]=260;posX[11]=300;
posY[0]=-80;posY[1]=-40;posY[2]=-10;posY[3]=-295;
posY[4]=-276;posY[5]=-276;posY[6]=215;posY[7]=185;
posY[8]=185;posY[9]=-20;posY[10]=-90;posY[11]=-70;

while(.IsValid()){
	postSentries.ClearDead();
	if(!.IsBroken()){
		if(EnvReadInt(this,"sentriesLevel")<23){
			if(timer<90000/1500){
				timer=timer+1;
			}
			else{
				timer=0;
				EnvWriteInt(this,"sentriesLevel",EnvReadInt(this,"sentriesLevel")+1);
			}
		}
		if(!s0.IsValid()){
			s0Act="";
			s0=Place(sRace+"GuardPostSentry",.pos()+Point(posX[0],posY[0]),pNumber);
			postSentries.Add(s0);
		}
		if(!s1.IsValid()){
			s1Act="";
			s1=Place(sRace+"GuardPostSentry",.pos()+Point(posX[1],posY[1]),pNumber);
			postSentries.Add(s1);
		}
		if(!s2.IsValid()){
			s2Act="";
			s2=Place(sRace+"GuardPostSentry",.pos()+Point(posX[2],posY[2]),pNumber);
			postSentries.Add(s2);
		}
		if(!s3.IsValid()){
			s3Act="";
			s3=Place(sRace+"GuardPostSentry",.pos()+Point(posX[3],posY[3]),pNumber);
			postSentries.Add(s3);
		}
		if(!s4.IsValid()){
			s4Act="";
			s4=Place(sRace+"GuardPostSentry",.pos()+Point(posX[4],posY[4]),pNumber);
			postSentries.Add(s4);
		}
		if(!s5.IsValid()){
			s5Act="";
			s5=Place(sRace+"GuardPostSentry",.pos()+Point(posX[5],posY[5]),pNumber);
			postSentries.Add(s5);
		}
		if(!s6.IsValid()){
			s6Act="";
			s6=Place(sRace+"GuardPostSentry",.pos()+Point(posX[6],posY[6]),pNumber);
			postSentries.Add(s6);
		}
		if(!s7.IsValid()){
			s7Act="";
			s7=Place(sRace+"GuardPostSentry",.pos()+Point(posX[7],posY[7]),pNumber);
			postSentries.Add(s7);
		}
		if(!s8.IsValid()){
			s8Act="";
			s8=Place(sRace+"GuardPostSentry",.pos()+Point(posX[8],posY[8]),pNumber);
			postSentries.Add(s8);
		}
		if(!s9.IsValid()){
			s9Act="";
			s9=Place(sRace+"GuardPostSentry",.pos()+Point(posX[9],posY[9]),pNumber);
			postSentries.Add(s9);
		}
		if(!s10.IsValid()){
			s10Act="";
			s10=Place(sRace+"GuardPostSentry",.pos()+Point(posX[10],posY[10]),pNumber);
			postSentries.Add(s10);
		}
		if(!s11.IsValid()){
			s11Act="";
			s11=Place(sRace+"GuardPostSentry",.pos()+Point(posX[11],posY[11]),pNumber);
			postSentries.Add(s11);
		}
	}
	//Handles sentinels action
	/*----SENTINEL 0----*/
	e0=Intersect(ObjsInCircle(s0.pos,s0.range-15,"Military"),EnemyObjs(.player,"Military")).GetObjList();
	if(e0){
		if(s0.IsValid()){
			s0.SetCommand("attack",s0.pos());
			s0Act=="Return";
		}
		else{
			s0Act="";
		}
	}
	else{
		if(s0Act==""){
			if(s0.IsValid()){s0.SetCommand("move",.pos()+Point(posX[0]+90,posY[0]-90));}
			s0Act="Facing1";
		}
		if(s0.IsValid() && s0Act=="Facing2" && s0.pos==.pos()+Point(posX[0],posY[0])){
			s0.Face(s0.pos+Point(-90,-90));
			s0Act="";
		}
		if(s0.IsValid() && s0Act=="Return"){
			if(s0.IsValid()){s0.SetCommand("move",.pos()+Point(posX[0],posY[0]));}
			s0Act="Facing2";
		}
		if(s0.IsValid() && s0Act=="Facing1" && s0.pos==.pos()+Point(posX[0]+90,posY[0]-90)){
			if(s0.IsValid()){s0.Face(s0.pos+Point(-90,-90));}
			s0Act="Return";
		}
	}
	/*----SENTINEL 1----*/
	e1=Intersect(ObjsInCircle(s1.pos,s1.range-15,"Military"),EnemyObjs(.player,"Military")).GetObjList();
	if(e1){
		if(s1.IsValid()){
			s1.SetCommand("attack",s1.pos());
		}
	}
	else{
		if(s1.IsValid()){
			if(s1Act=="Facing3"){
				if(s1.IsValid()){s1.Face(s1.pos+Point(-90,-45));}
				s1Act="";
			}
			if(s1Act=="Facing2"){
				if(s1.IsValid()){s1.Face(s1.pos+Point(-90,0));}
				s1Act="Facing3";
			}
			if(s1Act=="Facing1"){
				if(s1.IsValid()){
					s1.Face(s1.pos+Point(-90,45));
				}
				s1Act="Facing2";
			}
			if(s1Act==""){
				s1Act="Facing1";
			}
		}
	}
	/*----SENTINEL 2----*/
	e2=Intersect(ObjsInCircle(s2.pos,s2.range-15,"Military"),EnemyObjs(.player,"Military")).GetObjList();
	if(e2){
		if(s2.IsValid()){
			s2.SetCommand("attack",s2.pos());
			s2Act=="Return";
		}
	}
	else{
		if(s2Act==""){
			if(s2.IsValid()){s2.SetCommand("move",.pos()+Point(posX[2]+60,posY[2]+60));}
			s2Act="Facing1";
		}
		if(s2.IsValid() && s2Act=="Facing2" && s2.pos==.pos()+Point(posX[2],posY[2])){
			s2.Face(s2.pos+Point(-90,90));
			s2Act="";
		}
		if(s2.IsValid() && s2Act=="Return"){
			if(s2.IsValid()){s2.SetCommand("move",.pos()+Point(posX[2],posY[2]));}
			s2Act="Facing2";
		}
		if(s2.IsValid() && s2Act=="Facing1" && s2.pos==.pos()+Point(posX[2]+60,posY[2]+60)){
			if(s2.IsValid()){s2.Face(s2.pos+Point(-90,90));}
			s2Act="Return";
		}
	}
	/*----SENTINEL 3----*/
	e3=Intersect(ObjsInCircle(s3.pos,s3.range-15,"Military"),EnemyObjs(.player,"Military")).GetObjList();
	if(e3){
		if(s3.IsValid()){
			s3.SetCommand("attack",s3.pos());
		}
	}
	else{
		if(s3.IsValid() && s3Act=="Facing3"){
			s3.Face(s3.pos+Point(45,-90));
			s3Act="";
		}
		if(s3.IsValid() && s3Act=="Facing2"){
			s3.Face(s3.pos+Point(0,-90));
			s3Act="Facing3";
		}
		if(s3.IsValid() && s3Act=="Facing1"){
			s3.Face(s3.pos+Point(-45,-90));
			s3Act="Facing2";
		}
		if(s3.IsValid() && s3Act==""){
			s3Act="Facing1";
		}
	}
	/*----SENTINEL 4----*/
	e4=Intersect(ObjsInCircle(s4.pos,s4.range-15,"Military"),EnemyObjs(.player,"Military")).GetObjList();
	if(e4){
		if(s4.IsValid()){
			s4.SetCommand("attack",s4.pos());
			s4Act=="Return";
		}
	}
	else{
		if(s4.IsValid() && s4Act==""){
			s4.SetCommand("move",.pos()+Point(posX[4]-10,posY[4]+10));
			s4Act="Facing1";
		}
		if(s4.IsValid() && s4Act=="Facing2" && s4.pos==.pos()+Point(posX[4],posY[4])){
			s4.Face(s4.pos+Point(-90,-90));
			s4Act="";
		}
		if(s4.IsValid() && s4Act=="Return"){
			s4.SetCommand("move",.pos()+Point(posX[4],posY[4]));
			s4Act="Facing2";
		}
		if(s4.IsValid() && s4Act=="Facing1" && s4.pos==.pos()+Point(posX[4]-10,posY[4]+10)){
			s4.Face(s4.pos+Point(-90,-90));
			s4Act="Return";
		}
	}
	/*----SENTINEL 5----*/
	e5=Intersect(ObjsInCircle(s5.pos,s5.range-15,"Military"),EnemyObjs(.player,"Military")).GetObjList();
	if(e5){
		if(s5.IsValid()){
			s5.SetCommand("attack",s5.pos());
			s5Act=="Return";
		}
	}
	else{
		if(s5.IsValid() && s5Act==""){
			s5.SetCommand("move",.pos()+Point(posX[5]+75,posY[5]+75));
			s5Act="Facing1";
		}
		if(s5.IsValid() && s5Act=="Facing2" && s5.pos==.pos()+Point(posX[5],posY[5])){
			s5.Face(s5.pos+Point(90,-90));
			s5Act="";
		}
		if(s5.IsValid() && s5Act=="Return"){
			s5.SetCommand("move",.pos()+Point(posX[5],posY[5]));
			s5Act="Facing2";
		}
		if(s5.IsValid() && s5Act=="Facing1" && s5.pos==.pos()+Point(posX[5]+75,posY[5]+75)){
			s5.Face(s5.pos+Point(90,-90));
			s5Act="Return";
		}
	}
	/*----SENTINEL 6----*/
	e6=Intersect(ObjsInCircle(s6.pos,s6.range-15,"Military"),EnemyObjs(.player,"Military")).GetObjList();
	if(e6){
		if(s6.IsValid()){
			s6.SetCommand("attack",s6.pos());
		}
	}
	else{
		if(s6.IsValid() && s6Act=="Facing3"){
			s6.Face(s6.pos+Point(45,90));
			s6Act="";
		}
		if(s6.IsValid() && s6Act=="Facing2"){
			s6.Face(s6.pos+Point(0,90));
			s6Act="Facing3";
		}
		if(s6.IsValid() && s6Act=="Facing1"){
			s6.Face(s6.pos+Point(-45,90));
			s6Act="Facing2";
		}
		if(s6.IsValid() && s6Act==""){
			s6Act="Facing1";
		}
	}
	/*----SENTINEL 7----*/
	e7=Intersect(ObjsInCircle(s7.pos,s7.range-15,"Military"),EnemyObjs(.player,"Military")).GetObjList();
	if(e7){
		if(s7.IsValid()){
			s7.SetCommand("attack",s7.pos());
			s7Act=="Return";
		}
	}
	else{
		if(s7.IsValid() && s7Act==""){
			s7.SetCommand("move",.pos()+Point(posX[7]-25,posY[7]-25));
			s7Act="Facing1";
		}
		if(s7.IsValid() && s7Act=="Facing2" && s7.pos==.pos()+Point(posX[7],posY[7])){
			s7.Face(s7.pos+Point(-90,90));
			s7Act="";
		}
		if(s7.IsValid() && s7Act=="Return"){
			s7.SetCommand("move",.pos()+Point(posX[7],posY[7]));
			s7Act="Facing2";
		}
		if(s7.IsValid() && s7Act=="Facing1" && s7.pos==.pos()+Point(posX[7]-25,posY[7]-25)){
			s7.Face(s7.pos+Point(-90,90));
			s7Act="Return";
		}
	}
	/*----SENTINEL 8----*/
	e8=Intersect(ObjsInCircle(s8.pos,s8.range-15,"Military"),EnemyObjs(.player,"Military")).GetObjList();
	if(e8){
		if(s8.IsValid()){
			s8.SetCommand("attack",s8.pos());
			s8Act=="Return";
		}
	}
	else{
		if(s8.IsValid() && s8Act==""){
			s8.SetCommand("move",.pos()+Point(posX[8]+105,posY[8]-105));
			s8Act="Facing1";
		}
		if(s8.IsValid() && s8Act=="Facing2" && s8.pos==.pos()+Point(posX[8],posY[8])){
			s8.Face(s8.pos+Point(90,90));
			s8Act="";
		}
		if(s8.IsValid() && s8Act=="Return"){
			s8.SetCommand("move",.pos()+Point(posX[8],posY[8]));
			s8Act="Facing2";
		}
		if(s8.IsValid() && s8Act=="Facing1" && s8.pos==.pos()+Point(posX[8]+105,posY[8]-105)){
			s8.Face(s8.pos+Point(90,90));
			s8Act="Return";
		}
	}
	/*----SENTINEL 9----*/
	e9=Intersect(ObjsInCircle(s9.pos,s9.range-15,"Military"),EnemyObjs(.player,"Military")).GetObjList();
	if(e9){
		if(s9.IsValid()){
			s9.SetCommand("attack",s9.pos());
			s9Act=="Return";
		}
	}
	else{
		if(s9.IsValid() && s9Act==""){
			s9.SetCommand("move",.pos()+Point(posX[9]-10,posY[9]+10));
			s9Act="Facing1";
		}
		if(s9.IsValid() && s9Act=="Facing2" && s9.pos==.pos()+Point(posX[9],posY[9])){
			s9.Face(s9.pos+Point(90,90));
			s9Act="";
		}
		if(s9.IsValid() && s9Act=="Return"){
			s9.SetCommand("move",.pos()+Point(posX[9],posY[9]));
			s9Act="Facing2";
		}
		if(s9.IsValid() && s9Act=="Facing1" && s9.pos==.pos()+Point(posX[9]-10,posY[9]+10)){
			s9.Face(s9.pos+Point(90,90));
			s9Act="Return";
		}
	}
	/*----SENTINEL 10----*/
	e10=Intersect(ObjsInCircle(s10.pos,s10.range-15,"Military"),EnemyObjs(.player,"Military")).GetObjList();
	if(e10){
		if(s10.IsValid()){
			s10.SetCommand("attack",s10.pos());
			s10Act=="Return";
		}
	}
	else{
		if(s10.IsValid() && s10Act==""){
			s10.SetCommand("move",.pos()+Point(posX[10]-40,posY[10]-40));
			s10Act="Facing1";
		}
		if(s10.IsValid() && s10Act=="Facing2" && s10.pos==.pos()+Point(posX[10],posY[10])){
			s10.Face(s10.pos+Point(90,-90));
			s10Act="";
		}
		if(s10.IsValid() && s10Act=="Return"){
			s10.SetCommand("move",.pos()+Point(posX[10],posY[10]));
			s10Act="Facing2";
		}
		if(s10.IsValid() && s10Act=="Facing1" && s10.pos==.pos()+Point(posX[10]-40,posY[10]-40)){
			s10.Face(s10.pos+Point(90,-90));
			s10Act="Return";
		}
	}
	/*----SENTINEL 11----*/
	e11=Intersect(ObjsInCircle(s11.pos,s11.range-15,"Military"),EnemyObjs(.player,"Military")).GetObjList();
	if(e11){
		if(s11.IsValid()){
			s11.SetCommand("attack",s11.pos());
		}
	}
	else{
		if(s11.IsValid() && s11Act=="Facing3"){
			s11.Face(s11.pos+Point(45,90));
			s11Act="";
		}
		if(s11.IsValid() && s11Act=="Facing2"){
			s11.Face(s11.pos+Point(90,0));
			s11Act="Facing3";
		}
		if(s11.IsValid() && s11Act=="Facing1"){
			s11.Face(s11.pos+Point(45,-90));
			s11Act="Facing2";
		}
		if(s11.IsValid() && s11Act==""){
			s11Act="Facing1";
		}
	}
	//Destroy all sentinels if building is broken or isn't of the same player
	if(.IsBroken()){
		postSentries.ClearDead();
		for(i=0;i<postSentries.count;i=i+1){
			postSentries[i].Damage(postSentries[i].AsUnit().maxhealth);
			Sleep(10);
		}
		s0Act="";s1Act="";s2Act="";s3Act="";s4Act="";s5Act="";
		s6Act="";s7Act="";s8Act="";s9Act="";s10Act="";s11Act="";
	}
	if(.player()!=pNumber){
		postSentries.ClearDead();
		for(i=0;i<postSentries.count;i=i+1){
			postSentries[i].Damage(postSentries[i].AsUnit().maxhealth);
			Sleep(10);
		}
		s0Act="";s1Act="";s2Act="";s3Act="";s4Act="";s5Act="";
		s6Act="";s7Act="";s8Act="";s9Act="";s10Act="";s11Act="";
		break;
	}
	if(!.IsBroken() && .player()==pNumber){
		postSentries.ClearDead();
		for(i=0;i<postSentries.count;i=i+1){
			postSentries[i].AsUnit().SetLevel(EnvReadInt(this,"sentriesLevel")+1);
			Sleep(10);
		}
	}
	Sleep(1500);
}