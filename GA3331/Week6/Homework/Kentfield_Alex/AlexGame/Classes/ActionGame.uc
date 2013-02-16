class ActionGame extends UTDeathmatch
config(ActionGame);

var bool bFirstEnemySpawned;
var int EnemiesLeft;
var int CurrentWave;
var soundcue soundSample;
var soundcue pancakeSample;
var soundcue fiveKillSample;
var soundcue oneKillSample;
var soundcue musicSample;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	ActivateSpawners();
	PlaySound( musicSample );
}

function AddInitialBots()
{

}

function ScoreKill(Controller Killer, Controller Other)
{
	local ActionPlayerController PC;
	super.ScoreKill(Killer, Other);

	// Cast to the custom MyPlayerController class
	PC = ActionPlayerController(Killer);

	// Give XP through our custom function to our PlayerController, change 100 to whatever amount you want
	PC.GiveXP(100);

	EnemiesLeft--;
	
	if (EnemiesLeft == 5)
	{
		PlaySound( fiveKillSample );
	}

	if (EnemiesLeft == 1)
	{
		PlaySound( oneKillSample );
	}

	if( EnemiesLeft <= 0)
	{
		CleanupAllBots();
		CurrentWave++;
		ActivateSpawners();
		PlaySound( soundSample );
	}

	if( CurrentWave >= 3 )
	{
		CleanupAllBots();
		PlaySound( pancakeSample );
	}
	
	Super.ScoreKill(Killer, Other );

}

function CleanupAllBots()
{
	local UTPawn pawn;
	foreach DynamicActors(class'UTPawn', pawn)
		{
			if( PlayerController(pawn.Controller) == none )
			{
				// This is a bot
				pawn.Destroy();				
			}
		}
}

function ActivateSpawners()
{
	local int spawnIndex;
	local int i;
	local ActionMapInfo MapInfo;

		
	bFirstEnemySpawned = true;
	MapInfo = ActionMapInfo(WorldInfo.GetMapInfo());
	
	for( i=0 ; i< MapInfo.WaveInfo[CurrentWave].requiredEnemiesToKill ; i++ )
	{		
		AddCustomBot();		
	}
	
	EnemiesLeft = MapInfo.WaveInfo[CurrentWave].requiredEnemiesToKill;
}




/** FindPlayerStart()
* Return the 'best' player start for this player to start from.  PlayerStarts are rated by RatePlayerStart().
* @param Player is the controller for whom we are choosing a playerstart
* @param InTeam specifies the Player's team (if the player hasn't joined a team yet)
* @param IncomingName specifies the tag of a teleporter to use as the Playerstart
* @returns NavigationPoint chosen as player start (usually a PlayerStart)
 */

function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string incomingName)
{
	local ActionMapInfo MapInfo;	
	local int spawnIndex;
		
	MapInfo = ActionMapInfo(WorldInfo.GetMapInfo());
	spawnIndex = Rand(MapInfo.WaveInfo[CurrentWave].spawnLocations.Length);		
	return MapInfo.WaveInfo[CurrentWave].spawnLocations[spawnIndex];
}

function AddCustomBot()
{
	local UTBot NewBot;
	local UTTeamInfo BotTeam;
	local CharacterInfo BotInfo;

	BotTeam = GetBotTeam();
	BotInfo = BotTeam.GetBotInfo("Enemy Bot");
	
	NewBot = Spawn(BotClass);

	if ( NewBot != None )
	{
		InitializeBot(NewBot, BotTeam, BotInfo);

		if (BaseMutator != None)
		{
			BaseMutator.NotifyLogin(NewBot);
		}
	}
}

function UTBot AddBot(optional string BotName, optional bool bUseTeamIndex, optional int TeamIndex)
{
}


defaultproperties
{
	DefaultInventory(0)=class'AlexGame.UTWeap_MyWeap'
	bAutoNumBots=true
	EnemiesLeft=20
	bScoreDeaths=false
	DefaultPawnClass = class'AlexGame.ActionPawn'
	PlayerControllerClass = class'AlexGame.ActionPlayerController'
    	HUDType=class'AlexGame.MyHUD'
	bUseClassicHud = true
	CurrentWave = 0
	//ServerSkillLevel = 2
	//NumberOfWaves = 5
	GoalScore = true
	bPlayersVsBots = true
	soundSample = SoundCue'A_Gameplay.CTF.Cue.A_Gameplay_CTF_ScoreIncrease01Cue'
	pancakeSample = SoundCue'A_Pickups_Powerups.PowerUps.A_Powerup_Berzerk_EndCue'
	fiveKillSample = SoundCue'CastleAudio.UI.UI_InvalidTouchToMove_Cue'
	oneKillSample = SoundCue'A_Pickups.Generic.Cue.A_Pickups_Generic_ItemRespawn_Cue'
	musicSample = SoundCue'A_Music_RomNecris01.MusicSegments.A_Music_RomNecris01_Victory01Cue'
	bWarmupRound = true			
	WarmupTime = 5
	DefaultMaxLives = 50
} 