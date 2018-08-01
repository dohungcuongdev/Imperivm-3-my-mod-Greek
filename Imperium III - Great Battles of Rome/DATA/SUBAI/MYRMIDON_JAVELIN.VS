// void, Obj me

Unit this;
int timer;

this = me.AsUnit();

if (.IsValid) // leave parry mode at new command
 .SetParryMode(false);

.Idle(1);
.SetState(3);
Sleep(978);
.Mutate("HMyrmidon_Javelin");