//void, Obj This

Unit this;
int i;

this = This.AsUnit;

Sleep(rand(1073) + 571);

if (!.IsValid) while(true) Sleep(50000);

while(.IsAlive) {
	Sleep(1011);
	if (.TimeWithoutAttack >= 20000 && .HasSpecial(26))
		.SetVisible(false);
}

//prevent behavior script from terminating (this will lockup the game)
while(true) Sleep(50000);
