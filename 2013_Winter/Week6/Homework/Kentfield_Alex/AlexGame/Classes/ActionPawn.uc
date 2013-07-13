class ActionPawn extends UTPawn
config(ActionGame);

var float RegenAmount;
var float CamOffsetDistance; //distance to offset the camera from the player in unreal units
var float CamMinDistance, CamMaxDistance;
var float CamZoomTick; //how far to zoom in/out per command
var float CamHeight; //how high cam is relative to pawn pelvis
var float Stamina;
var float Mana;
var float SprintTimer;
var float SprintRecoverTimer;
var float HealRecoverTimer;
var float Empty;
var bool bSprinting;
var public bool bHealing;
var bool bInvulnerable;
var float InvulnerableTime;
var ParticleSystemComponent healEffect;
var ParticleSystemComponent healEffect2;
var Name HealSocket;
var Name HealSocket2;
var SoundCue healSound;


simulated function bool ShouldGib(class<UTDamageType> UTDamageType)
{
	return true;
}

// begin healing
function CastHeal()
{
	if (bHealing != false)
	{
	bHealing = false;
	HealDamage(RegenAmount, Controller, class'DamageType');
	Mesh.AttachComponentToSocket(healEffect, healSocket);
	Mesh.AttachComponentToSocket(healEffect2, healSocket2);
	PlaySound( healSound );
	UTPawn(Instigator).FullBodyAnimSlot.PlayCustomAnimByDuration('hoverboardjumpfall', 0.6, 0.2, 0.2, FALSE, TRUE );
	setTimer(5.0, false, 'EmptyHeal');
	// Turn off healing timer
	setTimer(2.0, false, 'SturnOffHealingEffect');
	}	
}

// turn off healing effects
function SturnOffHealingEffect()
{
	Mesh.DetachComponent(healEffect);
	Mesh.DetachComponent(healEffect2);	
}

// heal cooldown bool
simulated function ReplenishMana()
{
bHealing = true;
}


simulated function EmptyHeal()
{
bHealing = false;
setTimer(0.25, false, 'ReplenishMana');
}

function EndInvulnerable()
{
    bInvulnerable = false;
}

//stop aim node from aiming up or down
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	super.PostInitAnimTree(SkelComp);
	AimNode.bForceAimDir = true; //forces centercenter
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	`Log("Custom Pawn up"); //debug
	//DrawDebugSphere( Location, 100, 25, 255, 100, 100, true) ;
}

//override to make player mesh visible by default
simulated event BecomeViewTarget( PlayerController PC )
{
   local UTPlayerController UTPC;

   Super.BecomeViewTarget(PC);

   if (LocalPlayer(PC.Player) != None)
   {
      UTPC = UTPlayerController(PC);
      if (UTPC != None)
  {
         //set player controller to behind view and make mesh visible
         UTPC.SetBehindView(true);
         SetMeshVisibility(UTPC.bBehindView); 
         UTPC.bNoCrosshair = true;
      }
   }
}

//only update pawn rotation while moving
simulated function FaceRotation(rotator NewRotation, float DeltaTime)
{
	// Do not update Pawn's rotation if no accel
	if (Normal(Acceleration)!=vect(0,0,0))
	{
		if ( Physics == PHYS_Ladder )
		{
			NewRotation = OnLadder.Walldir;
		}
		else if ( (Physics == PHYS_Walking) || (Physics == PHYS_Falling) )
		{
			NewRotation = rotator((Location + Normal(Acceleration))-Location);
			NewRotation.Pitch = 0;
		}
		
		SetRotation(NewRotation);
	}
	
}

//orbit cam, follows player controller rotation
simulated function bool CalcCamera( float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV )
{
	local vector HitLoc,HitNorm, End, Start, vecCamHeight;

	vecCamHeight = vect(0,0,0);
	vecCamHeight.Z = CamHeight;
	Start = Location;
	End = (Location+vecCamHeight)-(Vector(Controller.Rotation) * CamOffsetDistance);  //cam follow behind player controller
	out_CamLoc = End;

	//trace to check if cam running into wall/floor
	if(Trace(HitLoc,HitNorm,End,Start,false,vect(12,12,12))!=none)
	{
		out_CamLoc = HitLoc + vecCamHeight;
	}
	
	//camera will look slightly above player
   out_CamRot=rotator((Location + vecCamHeight) - out_CamLoc);
   return true;
}

// sprint cooldown
simulated function ReplenishStamina()
{
Stamina = 10.0;
bSprinting = false;
}

// while sprinting
simulated function EmptySprint()
{
Stamina = Empty;
Groundspeed = 440;
bSprinting = true;
setTimer(SprintRecoverTimer, false, 'ReplenishStamina');
}

// begin sprinting
exec function StartSprint()
{
ConsoleCommand("Sprint");
Groundspeed = 800;
bSprinting = true;
 
// If we have enough speed, run
if(Groundspeed >= 590)
{   
StopFiring();    
setTimer(SprintTimer, false, 'EmptySprint');
}
}

// set run speed back to normal after sprinting
exec function StopSprinting()
{
GroundSpeed = 440;
}

exec function CamZoomIn()
{
	`Log("Zoom in");
	if(CamOffsetDistance > CamMinDistance)
		CamOffsetDistance-=CamZoomTick;
}

exec function CamZoomOut()
{
	`Log("Zoom out");
	if(CamOffsetDistance < CamMaxDistance)
		CamOffsetDistance+=CamZoomTick;
}

defaultproperties
{
Begin Object Class=ParticleSystemComponent Name=healEffectComponent
	Template = ParticleSystem'KismetGame_Assets.Projectile.P_Spit_01'
End object
Begin Object Class=ParticleSystemComponent Name=healEffectComponent2
	Template = ParticleSystem'KismetGame_Assets.Projectile.P_Spit_01'
End object
	healSound = SoundCue'CastleAudio.UI.UI_TouchToMove_Cue'
	bHealing = true
	healEffect = healEffectComponent
	healEffect2 = healEffectComponent2
	HealSocket = WeaponPoint
	HealSocket2 = DualWeaponPoint
	RegenAmount=25.0
	MeleeRange=+100.0
	InvulnerableTime=0.3
	SprintTimer = 5.0
	SprintRecoverTimer = 10.0
	HealRecoverTimer = 10.0
	Stamina = 10.0
	Mana = 10.0
	Empty = 1
	CamHeight = 40.0
	CamMinDistance = 40.0
	CamMaxDistance = 350.0
   	CamOffsetDistance=250.0
	CamZoomTick=20.0
	MaxMultiJump=100
	MultiJumpRemaining=100
	MultiJumpBoost=+200.0
	MaxJumpHeight=600.0
	MaxDoubleJumpHeight=600.0
	DoubleJumpThreshold=4000.0	
}