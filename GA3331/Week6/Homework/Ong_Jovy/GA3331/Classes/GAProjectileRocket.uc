class GAProjectileRocket extends UTProj_Rocket;

var() const editconst StaticMeshComponent	StaticMeshComponent;
var()	SkeletalMeshComponent			SkeletalMeshComponent;
var() const editconst DynamicLightEnvironmentComponent LightEnvironment;

function OnSetMesh(SeqAct_SetMesh Action)
{
	local bool bForce;
	if( Action.MeshType == MeshType_StaticMesh )
	{
		bForce = Action.bIsAllowedToMove == StaticMeshComponent.bForceStaticDecals || Action.bAllowDecalsToReattach;

		if( (Action.NewStaticMesh != None) &&
			(Action.NewStaticMesh != StaticMeshComponent.StaticMesh || bForce) )
		{
			// Enable the light environment if it is not already
			LightEnvironment.bCastShadows = false;
			LightEnvironment.SetEnabled(TRUE);
			// Don't allow decals to reattach since we are changing the static mesh
			StaticMeshComponent.bAllowDecalAutomaticReAttach = Action.bAllowDecalsToReattach;
			StaticMeshComponent.SetStaticMesh( Action.NewStaticMesh, Action.bAllowDecalsToReattach );
			StaticMeshComponent.bAllowDecalAutomaticReAttach = true;
			StaticMeshComponent.SetActorCollision(false, false, false );
		}
	}
	else if (Action.MeshType == MeshType_SkeletalMesh)
	{
		if (Action.NewSkeletalMesh != None && Action.NewSkeletalMesh != SkeletalMeshComponent.SkeletalMesh)
		{
			SkeletalMeshComponent.SetSkeletalMesh(Action.NewSkeletalMesh);
		}
	}
}

function OnSetMaterial(SeqAct_SetMaterial Action)
{
	SkeletalMeshComponent.SetMaterial( Action.MaterialIndex, Action.NewMaterial );	
	StaticMeshComponent.SetMaterial( Action.MaterialIndex, Action.NewMaterial );
	
}

/**
 *	Handler for the SeqAct_SetVelocity action. Allows level designer to impart a velocity on the actor.
 */
simulated function OnSetVelocity( SeqAct_SetVelocity Action )
{
	Super.OnSetVelocity(Action);
	Init(Velocity);
	
	speed=Action.VelocityMag;	
	MaxSpeed=Action.VelocityMag;
}

/**
 *	Handler for the SeqAct_SetAcceleration action. Allows level designer to impart a Acceleration on the actor.
 */
simulated function OnSetAcceleration( SeqAct_SetAcceleration Action )
{
	local Vector A;
	local float	 Mag;

	Mag = Action.AccelerationMag;
	if( Mag <= 0.f )
	{
		Mag = VSize( Action.AccelerationDir);
	}
	A = Normal(Action.AccelerationDir) * Mag;
	if( Action.bAccelerationRelativeToActorRotation )
	{
		A = A >> Rotation;
	}
	Acceleration = A;
	
	Init(Acceleration);
}

DefaultProperties
{
	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=TRUE
	End Object
	LightEnvironment=MyLightEnvironment
	Components.Add(MyLightEnvironment)

	Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
	    BlockRigidBody=false
		LightEnvironment=MyLightEnvironment
		bUsePrecomputedShadows=FALSE
	End Object
	CollisionComponent=StaticMeshComponent0
	StaticMeshComponent=StaticMeshComponent0
	Components.Add(StaticMeshComponent0)
	
	Begin Object Class=AnimNodeSequence Name=AnimNodeSeq0
	End Object

	RotationRate=(Roll=0)
	speed=1350.0
	MaxSpeed=1350.0
	
	Begin Object Class=SkeletalMeshComponent Name=SkeletalMeshComponent0
		Animations=AnimNodeSeq0
		bUpdateSkelWhenNotRendered=FALSE
		CollideActors=TRUE //@warning: leave at TRUE until backwards compatibility code is removed (bCollideActors_OldValue, etc)
		BlockActors=FALSE
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=FALSE
		BlockRigidBody=FALSE
		LightEnvironment=MyLightEnvironment
		RBChannel=RBCC_GameplayPhysics
		RBCollideWithChannels=(Default=TRUE,BlockingVolume=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE)
	End Object
	SkeletalMeshComponent=SkeletalMeshComponent0
	Components.Add(SkeletalMeshComponent0)

}
