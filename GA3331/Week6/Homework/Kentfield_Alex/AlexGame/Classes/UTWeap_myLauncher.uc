/**
 * Copyright 1998-2012 Epic Games, Inc. All Rights Reserved.
 */
class UTWeap_myLauncher extends UTWeap_RocketLauncher_Content;

defaultproperties
{
	WeaponColor=(R=255,G=0,B=0,A=255)
	FireInterval(0)=+0.2
	FireInterval(1)=+0.15
	PlayerViewOffset=(X=0.0,Y=0.0,Z=0.0)

	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'KismetGame_Assets.Anims.SK_JazzGun'
		PhysicsAsset=None
		AnimTreeTemplate=AnimTree'WP_RocketLauncher.Anims.AT_WP_RocketLauncher_1P_Base'
		AnimSets(0)=AnimSet'WP_RocketLauncher.Anims.K_WP_RocketLauncher_1P_Base'
		Translation=(X=0,Y=0,Z=0)
		Rotation=(Yaw=0)
		scale=1.0
		FOV=60.0
		bUpdateSkelWhenNotRendered=true
	End Object
	SkeletonFirstPersonMesh = FirstPersonMesh;
	AttachmentClass=class'UTAttachment_myLauncher'

	// Pickup staticmesh
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'KismetGame_Assets.Anims.SK_JazzGun'
	End Object

	WeaponLoadedSnd=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Load_Cue'

	WeaponFireSnd[0]=SoundCue'A_Gameplay.CTF.Cue.A_Gameplay_CTF_EnemyFlagGrab01Cue'
	WeaponFireSnd[1]=SoundCue'A_Gameplay.CTF.Cue.A_Gameplay_CTF_EnemyFlagGrab01Cue'

	WeaponEquipSnd=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Raise_Cue'
	AltFireModeChangeSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_AltModeChange_Cue'
	RocketLoadedSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_RocketLoaded_Cue'
	GrenadeFireSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_GrenadeFire_Cue'

	AltFireSndQue(0)=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_AltFireQueue1_Cue'
	AltFireSndQue(1)=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_AltFireQueue2_Cue'
	AltFireSndQue(2)=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_AltFireQueue3_Cue'

	LockAcquiredSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_SeekLock_Cue'
	LockLostSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_SeekLost_Cue'

	WeaponProjectiles(0)=class'UTProj_myLauncher'
	WeaponProjectiles(1)=class'UTProj_myLauncher'
	LoadedRocketClass=class'UTProj_LoadedRocket'

	GrenadeClass=class'UTProj_Grenade'

	FireOffset=(X=20,Y=12,Z=-5)


	bInstantHit=false
	bSplashJump=true
	bRecommendSplashDamage=true
	bSniping=false
	ShouldFireOnRelease(0)=0
	ShouldFireOnRelease(1)=1
	InventoryGroup=8
	GroupWeight=0.5

	PickupSound=SoundCue'A_Pickups.Weapons.Cue.A_Pickup_Weapons_Rocket_Cue'

	AmmoCount=200
	LockerAmmoCount=500
	MaxAmmoCount=500


	AltFireQueueTimes(0)=0.20
	AltFireQueueTimes(1)=0.36
	AltFireQueueTimes(2)=0.36
	AltFireLaunchTimes(0)= 0.21
	AltFireLaunchTimes(1)= 0.21
	AltFireLaunchTimes(2)= 0.21
	AltFireEndTimes(0)=0.24
	AltFireEndTimes(1)=0.24
	AltFireEndTimes(2)=0.24

	MaxLoadCount=3
	SpreadDist=1000
	FiringStatesArray(1)=WeaponLoadAmmo
	WeaponFireTypes(0)=EWFT_Projectile
	WeaponFireTypes(1)=EWFT_Projectile
	WaitToFirePct=0.85
	GracePeriod=0.96

	MuzzleFlashSocket=MuzzleFlashSocketA
	MuzzleFlashSocketList(0)=MuzzleFlashSocketA
	MuzzleFlashSocketList(1)=MuzzleFlashSocketC
	MuzzleFlashSocketList(2)=MuzzleFlashSocketB

	MuzzleFlashPSCTemplate=ParticleSystem'KismetGame_Assets.Projectile.P_BlasterMuzzle_02'
	MuzzleFlashDuration=0.33
	MuzzleFlashLightClass=class'UTGame.UTRocketMuzzleFlashLight'


	LockerRotation=(pitch=0,yaw=0,roll=-16384)
	IconCoordinates=(U=131,V=379,UL=129,VL=50)
	CrossHairCoordinates=(U=128,V=64,UL=64,VL=64)
	WeaponPutDownSnd=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Lower_Cue'

	LoadedIconCoords[0]=(U=0,V=384,UL=63,VL=63)
	LoadedIconCoords[1]=(U=63,V=384,UL=63,VL=63)
	LoadedIconCoords[2]=(U=126,V=384,UL=63,VL=63)

	LoadUpAnimList[0]=WeaponAltFireQueue1
	LoadUpAnimList[1]=WeaponAltFireQueue2
	LoadUpAnimList[2]=WeaponAltFireQueue3

	WeaponAltFireLaunch[0]=WeaponAltFireLaunch1
	WeaponAltFireLaunch[1]=WeaponAltFireLaunch2
	WeaponAltFireLaunch[2]=WeaponAltFireLaunch3

	WeaponAltFireLaunchEnd[0]=WeaponAltFireLaunch1End
	WeaponAltFireLaunchEnd[1]=WeaponAltFireLaunch2End
	WeaponAltFireLaunchEnd[2]=WeaponAltFireLaunch3End

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=90,RightAmplitude=50,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.200)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
}

