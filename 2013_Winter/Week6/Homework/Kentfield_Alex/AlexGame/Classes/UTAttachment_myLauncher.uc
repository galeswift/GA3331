/**
* Copyright 1998-2012 Epic Games, Inc. All Rights Reserved.
*/
class UTAttachment_myLauncher extends UTAttachment_RocketLauncher;

simulated function AttachTo(UTPawn OwnerPawn)
{
	Super.AttachTo(OwnerPawn);
}

defaultproperties
{
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'KismetGame_Assets.Anims.SK_JazzGun'		
		MaxDrawDistance=5000
		AnimSets(0)=AnimSet'WP_RocketLauncher.Anims.K_WP_RocketLauncher_3P'
		Translation=(Y=1,Z=1)
		Rotation=(Roll=-599)
		Scale=3.1
		End Object

		MuzzleFlashLightClass=class'UTGame.UTRocketMuzzleFlashLight'
		WeaponClass=class'UTWeap_myLauncher'

		WeapAnimType=EWAT_Stinger
}
