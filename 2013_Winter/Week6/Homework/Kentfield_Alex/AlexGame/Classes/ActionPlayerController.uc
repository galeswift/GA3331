class ActionPlayerController extends UTPlayerController;
 
const MAX_LEVEL = 50;
const XP_INCREMENT = 500; // Amount of XP that is added to the amount of XP required for a level, after each level progression
 
var int XP; // Total amount of gathered XP
var int Level; // Current level
var int XPGatheredForNextLevel; // Amount of XP gathered for the next level
var int XPRequiredForNextLevel; // Amount of XP required for the next level

exec function CastHeal()
{
  ActionPawn(Pawn).CastHeal();
}

exec function StartSprint()
{
  ActionPawn(Pawn).StartSprint();
}
//Update player rotation when walking
state PlayerWalking
{
ignores SeePlayer, HearNoise, Bump;


   function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
   {
	  local Vector tempAccel;
		local Rotator CameraRotationYawOnly;
		

      if( Pawn == None )
      {
         return;
      }

      if (Role == ROLE_Authority)
      {
         // Update ViewPitch for remote clients
         Pawn.SetRemoteViewPitch( Rotation.Pitch );
      }

      tempAccel.Y =  PlayerInput.aStrafe * DeltaTime * 100 * PlayerInput.MoveForwardSpeed;
      tempAccel.X = PlayerInput.aForward * DeltaTime * 100 * PlayerInput.MoveForwardSpeed;
      tempAccel.Z = 0; //no vertical movement for now, may be needed by ladders later
      
	 //get the controller yaw to transform our movement-accelerations by
	CameraRotationYawOnly.Yaw = Rotation.Yaw; 
	tempAccel = tempAccel>>CameraRotationYawOnly; //transform the input by the camera World orientation so that it's in World frame
	Pawn.Acceleration = tempAccel;
   
	Pawn.FaceRotation(Rotation,DeltaTime); //notify pawn of rotation

    CheckJumpOrDuck();
   }
}

//Controller rotates with turning input
function UpdateRotation( float DeltaTime )
{
local Rotator   DeltaRot, newRotation, ViewRotation;

   ViewRotation = Rotation;
   if (Pawn!=none)
   {
      Pawn.SetDesiredRotation(ViewRotation);
   }

   // Calculate Delta to be applied on ViewRotation
   DeltaRot.Yaw   = PlayerInput.aTurn;
   DeltaRot.Pitch   = PlayerInput.aLookUp;

   ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );
   SetRotation(ViewRotation);

   NewRotation = ViewRotation;
   NewRotation.Roll = Rotation.Roll;

   if ( Pawn != None )
      Pawn.FaceRotation(NewRotation, deltatime); //notify pawn of rotation
}   


simulated function PostBeginPlay()
{
super.PostBeginPlay();
 
// Calculate XP-related properties at the start of the game
CalculateLevelProgress();
}

public function GiveXP(int amount)
{
XP += amount;
 
CalculateLevelProgress();
 
while (XPGatheredForNextLevel >= XPRequiredForNextLevel && Level < MAX_LEVEL)
{
Level++;
 
// Recalculate level progress after leveling up
CalculateLevelProgress();
}
}

private function CalculateLevelProgress()
{
local int xpToCurrentLevel; // Total amount of XP gathered with current and previous levels
 
xpToCurrentLevel = 0.5*Level*(Level-1)*XP_INCREMENT;
XPGatheredForNextLevel = XP - xpToCurrentLevel;
XPRequiredForNextLevel = Level * XP_INCREMENT;
}

DefaultProperties
{
Level = 1;
XP = 0;
}