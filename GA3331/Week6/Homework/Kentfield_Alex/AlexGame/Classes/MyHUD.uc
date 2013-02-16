class MyHUD extends UTHUD;

var const Texture2D HudFrame;
var const Texture2D healGreenBar;

function DrawBar(String Title, float Value, float MaxValue,int X, int Y, int R, int G, int B)
{

    local int PosY;
    local int BarSizeY;
	

    PosY = Y; // Where we should draw the next rectangle

	X = 503 + ((MaxValue - Value) * 1.9); // size of active rectangle (change 300 to however big you want your bar to be)
  
	if( MaxValue > 0 )
	{
		BarSizeY = 195 * FMin(Value / MaxValue, 1); // size of active rectangle (change 300 to however big you want your bar to be)
	}
  
//Displays active rectangle
Canvas.SetPos(PosY,X);
Canvas.SetDrawColor(R, G, B, 75);
Canvas.DrawRect(225, BarSizeY);
} 

function DrawGameHud()
{
    local ActionPlayerController PC;
    PC = ActionPlayerController(PlayerOwner);
    
	if( PlayerOwner == none || PlayerOwner.Pawn == none )
	{
		return;
	}

if ( !PlayerOwner.IsDead() && !UTPlayerOwner.IsInState('Spectating'))
{    


//...draw our health-bar 
DrawBar(" ",PlayerOwner.Pawn.Health, PlayerOwner.Pawn.HealthMax,500,30,255,0,10); 

Canvas.Reset(false);
Canvas.SetPos(0,0);
Canvas.DrawTile(HudFrame, HudFrame.SizeX*0.67, HudFrame.SizeY*0.67, 20, -1078, HudFrame.SizeX, HudFrame.SizeY,, true);


//...and our level-bar
//DrawBar("Level:"@PC.Level, PC.Level, PC.MAX_LEVEL ,20,40,200,200,200); 
DrawBar(" ",UTWeapon(PawnOwner.Weapon).AmmoCount, UTWeapon(PawnOwner.Weapon).MaxAmmoCount ,500,750,80,80,200);




if ( PC.Level != PC.MAX_LEVEL ) //If our player hasn't reached the highest level...
{
DrawBar(" ",PC.XPGatheredForNextLevel, PC.XPRequiredForNextLevel, 20, 60, 80, 255, 80); //...draw our XP-bar
}

}

//if (class'ActionPawn'.default.bHealing) 
if (ActionPawn(PlayerOwner.Pawn).bHealing)
{
	Canvas.Reset(false);
	Canvas.SetPos(0,0);
	Canvas.DrawTile(healGreenBar, healGreenBar.SizeX*0.7, healGreenBar.SizeY*0.7, 20, -1035, healGreenBar.SizeX, healGreenBar.SizeY,, true);
}

Canvas.Reset(false);
Canvas.Drawcolor = WhiteColor;
Canvas.Font = class'Engine'.Static.GetLargeFont();

    if(PlayerOwner.Pawn != none && UTWeap_MyWeap(PlayerOwner.Pawn.Weapon) != none)
    {
        Canvas.SetPos(Canvas.ClipX * 0.1, Canvas.ClipY * 0.9);
        Canvas.DrawText("Weapon Level:" @ UTWeap_MyWeap(PlayerOwner.Pawn.Weapon).CurrentWeaponLevel);
		Canvas.SetPos(Canvas.ClipX * 0.1, Canvas.ClipY * 0.7);
		Canvas.DrawText("EnemiesLeft:" @ ActionGame(WorldInfo.Game).EnemiesLeft);
    }

	if(ActionGame(WorldInfo.Game) != none && !ActionGame(WorldInfo.Game).bFirstEnemySpawned && ActionGame(WorldInfo.Game).IsTimerActive('ActivateSpawners'))
	{
	   Canvas.SetPos(Canvas.ClipX * 0.1, Canvas.ClipY * 0.85);
	   Canvas.DrawText("Time Left to First Spawn:" @
	   ActionGame(WorldInfo.Game).GetRemainingTimeForTimer('ActivateSpawners'));
	}

	if((ActionGame(WorldInfo.Game).CurrentWave >= 3))
	{
		Canvas.SetPos(Canvas.ClipX * 0.45, Canvas.ClipY * 0.5);
		Canvas.DrawText("You Win!!");
	}

}

defaultproperties
{
	HudFrame = Texture2D'MyPackage.dualGlobe'
	healGreenBar = Texture2D'MyPackage.healGreen'
} 