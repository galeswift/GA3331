/**
 *
 * Copyright 1998-2012 Epic Games, Inc. All Rights Reserved.
 */
class ActionMapInfo extends UTMapInfo;

struct EnemyWaveinfo
{
	// Will spawn this many enemies each wave.
	var() int requiredEnemiesToKill;
	
	// We will randomly pick amongst these spawn locations
	var() array<PlayerStart> spawnLocations;
};

var() array<EnemyWaveInfo> WaveInfo;

defaultproperties
{
}
