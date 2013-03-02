class SeqAct_ScorePointForTeam extends SequenceAction;

var int TeamThatScored;

event Activated()
{
	local int i;
	Super.Activated();

	PublishLinkedVariableValues();

	for( i=0 ; i<Targets.Length; i++ )
	{
		if( Controller(Targets[i]) != none )
		{
			if( UTCTFGame(GetWorldInfo().Game) != none )
			{
				UTCTFGame(GetWorldInfo().Game).ScoreFlag(Controller(Targets[i]), none);
				
				TeamThatScored = Controller(Targets[i]).PlayerReplicationInfo.Team.TeamIndex;
			}	
		}
	}
	
	PopulateLinkedVariableValues();		
}

defaultproperties
{	
	ObjName="Score Point"
	ObjCategory="Objective"

	VariableLinks(1) = (ExpectedType=class'SeqVar_Int',LinkDesc="Team That Scored",bWriteable=true,PropertyName=TeamThatScored)
	
	bCallHandler=false
}