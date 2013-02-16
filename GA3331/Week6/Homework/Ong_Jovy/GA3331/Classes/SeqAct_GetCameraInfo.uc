class SeqAct_GetCameraInfo extends SequenceAction;

/** The location of the actor */
var() editconst Vector Location;
/** A normalized vector in the direction of the actor's rotation */
var() editconst	Vector RotationVector;
/** A vector that holds floating point versions of the FRotator rotation */
var() editconst	Vector CameraFacing;

/**
 * Called when this event is activated.
 */
event Activated()
{
	local PlayerController	P;
	local vector CameraLoc;
	local rotator CameraRot;

	ForEach GetWorldInfo().LocalPlayerControllers(class'PlayerController', P)
	{
		P.GetPlayerViewPoint(CameraLoc, CameraRot);
	}

	Location = CameraLoc;
	RotationVector = vector(CameraRot);
	
	CameraFacing = Location + RotationVector * 128;

	PopulateLinkedVariableValues();
	Super.Activated();
}

defaultproperties
{
	ObjName="Get Location and Rotation"
	ObjCategory="Camera"
	VariableLinks(0)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Location",bWriteable=true,PropertyName=Location)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Rotation Vector",bWriteable=true,PropertyName=RotationVector)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Camera Facing",bWriteable=true,PropertyName=CameraFacing)
}

