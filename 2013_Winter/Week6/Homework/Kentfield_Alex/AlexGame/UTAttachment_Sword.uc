/**
 * Copyright 1998-2010 Epic Games, Inc. All Rights Reserved.
 */
class UTAttachment_Sword extends UTWeaponAttachment;

var ParticleSystem BeamTemplate;
var class<UDKExplosionLight> ImpactLightClass;

var int CurrentPath;

simulated function SpawnBeam(vector Start, vector End, bool bFirstPerson)
{
	local ParticleSystemComponent E;
	local actor HitActor;
	local vector HitNormal, HitLocation;

	if ( End == Vect(0,0,0) )
	{
		if ( !bFirstPerson || (Instigator.Controller == None) )
		{
	    	return;
		}
		// guess using current viewrotation;
		End = Start + vector(Instigator.Controller.Rotation) * class'UTWeap_Sword'.default.WeaponRange;
		HitActor = Instigator.Trace(HitLocation, HitNormal, End, Start, TRUE, vect(0,0,0),, TRACEFLAG_Bullet);
		if ( HitActor != None )
		{
			End = HitLocation;
		}
	}

	E = WorldInfo.MyEmitterPool.SpawnEmitter(BeamTemplate, Start);
	E.SetVectorParameter('ShockBeamEnd', End);
	if (bFirstPerson && !class'Engine'.static.IsSplitScreen())
	{
		E.SetDepthPriorityGroup(SDPG_Foreground);
	}
	else
	{
		E.SetDepthPriorityGroup(SDPG_World);
	}
}

simulated function FirstPersonFireEffects(Weapon PawnWeapon, vector HitLocation)
{
	local vector EffectLocation;

	Super.FirstPersonFireEffects(PawnWeapon, HitLocation);

	if (Instigator.FiringMode == 0 || Instigator.FiringMode == 3)
	{
		EffectLocation = UTWeapon(PawnWeapon).GetEffectLocation();
		SpawnBeam(EffectLocation, HitLocation, true);

		if (!WorldInfo.bDropDetail && Instigator.Controller != None)
		{
			UDKEmitterPool(WorldInfo.MyEmitterPool).SpawnExplosionLight(ImpactLightClass, HitLocation);
		}
	}
}

simulated function ThirdPersonFireEffects(vector HitLocation)
{
	Super.ThirdPersonFireEffects(HitLocation);
	Mesh.PlayAnim('WeaponFire');
	UTPawn(Instigator).FullBodyAnimSlot.PlayCustomAnimByDuration('hoverboardjumprtwarmup', 0.6, 0.2, 0.2, FALSE, TRUE );
}

simulated function bool AllowImpactEffects(Actor HitActor, vector HitLocation, vector HitNormal)
{
	return (HitActor != None && UTProj_ShockBall(HitActor) == None && Super.AllowImpactEffects(HitActor, HitLocation, HitNormal));
}

simulated function SetMuzzleFlashParams(ParticleSystemComponent PSC)
{
	local float PathValues[3];
	local int NewPath;
	Super.SetMuzzleFlashparams(PSC);
	if (Instigator.FiringMode == 0)
	{
		NewPath = Rand(3);
		if (NewPath == CurrentPath)
		{
			NewPath++;
		}
		CurrentPath = NewPath % 3;

		PathValues[CurrentPath % 3] = 1.0;
		PSC.SetFloatParameter('Path1',PathValues[0]);
		PSC.SetFloatParameter('Path2',PathValues[1]);
		PSC.SetFloatParameter('Path3',PathValues[2]);
//			CurrentPath++;
	}
	else if (Instigator.FiringMode == 3)
	{
		PSC.SetFloatParameter('Path1',1.0);
		PSC.SetFloatParameter('Path2',1.0);
		PSC.SetFloatParameter('Path3',1.0);
	}
	else
	{
		PSC.SetFloatParameter('Path1',0.0);
		PSC.SetFloatParameter('Path2',0.0);
		PSC.SetFloatParameter('Path3',0.0);
	}

}


defaultproperties
{	

	// Weapon SkeletalMesh
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object

	

	// Weapon SkeletalMesh
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'WP_Sword.Mesh.SK_WP_Sword_1P'
		AnimSets(0)=AnimSet'WP_Sword.Anim.K_WP_Sword'
		Animations=MeshSequenceA
		Scale = 3.0
		Translation=(x=0,Y=0,Z=-11)
	End Object

	FireAnim = AnimSet'WP_Sword.Anim.K_WP_Sword.WeaponFire'

	DefaultImpactEffect=(ParticleTemplate=ParticleSystem'WP_SteamAssaultRifle.Particles.P_WP_SteamAssaultRifle_Impact', Sound=SoundCue'WP_Sword.Sounds.SwordSwingSoundCue')
	//ImpactEffects(0)=(MaterialType=Water, ParticleTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Beam_Impact_HIT', Sound=SoundCue'A_Character_BodyImpacts.BodyImpacts.A_Character_RobotImpact_GibMedium_Cue')
	BulletWhip=SoundCue'WP_Sword.Sounds.SwordSwingSoundCue'

	MuzzleFlashSocket=None
	MuzzleFlashPSCTemplate=None
	MuzzleFlashAltPSCTemplate=None
	MuzzleFlashColor= (R=255,G=120,B=255,A=0)
	MuzzleFlashDuration=0.0;
	//MuzzleFlashLightClass=class'UTGame.UTShockMuzzleFlashLight'
	BeamTemplate=None
	WeaponClass=class'UTWeap_Sword'
	ImpactLightClass=class'UTShockImpactLight'
	WeapAnimType=EWAT_DualPistols
}
