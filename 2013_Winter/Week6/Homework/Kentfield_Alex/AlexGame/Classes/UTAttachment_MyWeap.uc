class UTAttachment_MyWeap extends UTWeaponAttachment;


simulated function ThirdPersonFireEffects(vector HitLocation)
{
	Super.ThirdPersonFireEffects(HitLocation);
	Mesh.PlayAnim('WeaponFire');
	UTPawn(Instigator).FullBodyAnimSlot.PlayCustomAnimByDuration('hoverboardjumprtwarmup', 0.6, 0.2, 0.2, FALSE, TRUE );
}

defaultproperties
{
Begin Object Name=SkeletalMeshComponent0
SkeletalMesh=SkeletalMesh'GDC_Materials.Meshes.SK_ExportSword2'
End Object
WeaponClass=class'UTWeap_MyWeap'
MuzzleFlashSocket=MuzzleFlashSocket
}