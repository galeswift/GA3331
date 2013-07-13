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

DefaultProperties
{

	ProjFlightTemplate=None
	ProjExplosionTemplate=None
	ExplosionDecal=None

	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=TRUE
	End Object
	LightEnvironment=MyLightEnvironment
	Components.Add(MyLightEnvironment)

	Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
	    BlockRigidBody=false
		LightEnvironment=MyLightEnvironment
		bUsePrecomputedShadows=FALSE
		Rotation=(Pitch=16000)
	End Object
	CollisionComponent=StaticMeshComponent0
	StaticMeshComponent=StaticMeshComponent0
	Components.Add(StaticMeshComponent0)
	
	Begin Object Class=AnimNodeSequence Name=AnimNodeSeq0
	End Object

	RotationRate=(Roll=0, Pitch=-320000000)
	
	
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
