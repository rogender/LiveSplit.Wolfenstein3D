// Autosplitter for Wolfenstein 3D (for now working only on ECWolf 1.1.3)
//
// SET YOUR "COMPARE AGAINST" TO (GAME TIME) BY RIGHT CLICKING ON YOUR SPLITS OR YOU WON'T SEE LOADS GETTING PAUSED !!
//
// HOW TO USE: https://github.com/rogender/LiveSplit.Wolfenstein3D/blob/main/README.md
// PLEASE REPORT THE PROBLEMS TO EITHER THE ISSUES SECTION IN THE GITHUB REPOSITORY ABOVE
//
// !! NOTE !! WORKING ONLY ON LATEST VERSION OF SOURCE PORTS

state("ecwolf", "ECWolf")
{
    byte Level:          "safemon.dll", 0x00157FB0, 0x40, 0x20, 0xBB4;
    uint playerHealth:   "ecwolf.exe", 0x277534;
    int levelTime:       "ecwolf.exe", 0x289F38;
}

startup
{
    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{
		var mbox = MessageBox.Show(
			"Wolfenstein 3D uses in-game time.\nWould you like to switch to it?",
			"LiveSplit | Wolfenstein 3D",
			MessageBoxButtons.YesNo);

		if (mbox == DialogResult.Yes) timer.CurrentTimingMethod = TimingMethod.GameTime;
	}
}

init
{
    var mms = modules.First().ModuleMemorySize;
    print("[Wolfenstein 3D ASL] ModuleSize - 0x" + mms.ToString("X"));
    switch(mms)
    {
        case 0x2AE000: version = "ECWolf"; break;

        default:       version = "UNDETECTED"; MessageBox.Show(timer.Form, "Wolfenstein 3D autosplitter startup failure. \nI could not recognize what the version of the game you are running", "Wolfenstein 3D autosplitter startup failure", MessageBoxButtons.OK, MessageBoxIcon.Error); break;
    }
}

start
{
    return current.Level == 1 && current.levelTime != old.levelTime && current.playerHealth != 0;
}

split
{
    return current.Level > old.Level;
}

reset
{
    return (current.Level < old.Level) || (current.playerHealth == 0);
}

isLoading
{
    return current.levelTime == old.levelTime;
}

update
{
    if(version.Contains("UNDETECTED"))
        return false;
}

shutdown
{
    timer.OnStart -= vars.TimerStart;
}

exit
{
    timer.OnStart -= vars.TimerStart;
}
