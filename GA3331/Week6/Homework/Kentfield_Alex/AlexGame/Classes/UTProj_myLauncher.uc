/**
 * Copyright 1998-2012 Epic Games, Inc. All Rights Reserved.
 */
class UTProj_myLauncher extends UTProj_Rocket;


defaultproperties
{
	ProjFlightTemplate=ParticleSystem'WP_LinkGun.Effects.P_FX_LinkGun_3P_Beam_MF_Blue'
	ProjExplosionTemplate=ParticleSystem'CTF_Flag_IronGuard.Effects.P_CTF_Flag_IronGuard_Idle_Blue'
	ExplosionDecal=MaterialInstanceTimeVarying'WP_RocketLauncher.Decals.MITV_WP_RocketLauncher_Impact_Decal01'
	DecalWidth=128.0
	DecalHeight=128.0
	speed=2500.0
	MaxSpeed=2500.0
	Damage=20.0
	DamageRadius=110.0
	MomentumTransfer=20000
	MyDamageType=class'UTDmgType_Rocket'
	LifeSpan=7.0
	AmbientSound=SoundCue'A_Pickups_Powerups.PowerUps.A_Powerup_Berzerk_PowerLoopCue'
	ExplosionSound=SoundCue'A_Pickups_Powerups.PowerUps.A_Powerup_Berzerk_EndCue'
	RotationRate=(Roll=50000)
	bCollideWorld=true
	CheckRadius=42.0
	bCheckProjectileLight=true
	ProjectileLightClass=class'UTGame.UTRocketLight'
	ExplosionLightClass=class'UTGame.UTRocketExplosionLight'

	bWaitForEffects=true
	bAttachExplosionToVehicles=false
}
