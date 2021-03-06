globalvar cfgScoreOnKill
globalvar cfgScoreOnKillTarget
globalvar cfgGiveUltimateOnKillTarget
globalvar cfgResetCooldownsOnKillTarget
globalvar currentTarget
globalvar currentTargetHudText
globalvar currentTargetHudIcon
globalvar currentTargetEffect

rule "BountyHunter::ProcessOptions":
    cfgScoreOnKill = createWorkshopSetting(int[1:1000], "Bounty Hunter", "Score per kill", 100, 0)
    cfgScoreOnKillTarget = createWorkshopSetting(int[1:1000], "Bounty Hunter", "Score per kill target", 300, 0)
    cfgGiveUltimateOnKillTarget = createWorkshopSetting(bool, "Bounty Hunter", "Give ultimate charge when kill target.", true, 0)
	cfgResetCooldownsOnKillTarget = createWorkshopSetting(bool, "Bounty Hunter", "Reset abilities cooldown when kill target.", false, 0)

rule "BountyHunter::SetupGameModeOverrides":
    @Condition isGameInProgress()
    disableScoring()
	
rule "BountyHunter::SetupDummyForTesting":
	@Disabled
	@Event eachPlayer
	@Condition hostPlayer == eventPlayer
	@Condition hostPlayer.isHoldingButton(Button.INTERACT)
	createDummy(hostPlayer.getCurrentHero(), Team.ALL, 11, hostPlayer.getPosition(), hostPlayer.getFacingDirection())
	wait(0.25)
	getPlayersInSlot(11, Team.ALL).startForcingButton(Button.PRIMARY_FIRE)
	
rule "BountyHunter::OnPlayerLeft":
	@Event playerLeft
	@Condition eventPlayer == currentTarget
	bigMessage(getAllPlayers(), "Finding new target!")
	currentTarget = null

rule "BountyHunter::SetupGameModeUserInterface":
    @Condition isGameInProgress()
    destroyHudText(currentTargetHudText)
    destroyIcon(currentTargetHudIcon)
    wait(0.25)
    
	#// Create offscren icon to indicate where target was in.
    createIcon([player for player in getAllPlayers() if entityExists(currentTarget) and player != currentTarget],
		updateEveryTick(currentTarget.getPosition()) + vect(0, 2.5, 0), Icon.SKULL, IconReeval.VISIBILITY_AND_POSITION, Color.RED, true)
		
    currentTargetHudIcon = getLastCreatedEntity()
    wait(0.25)
	
	#// Create hud text to indicate who is current target.
    hudHeader([player for player in getAllPlayers() if entityExists(currentTarget)],
		"{0}: {1} {2}".format(l"Current Target", heroIcon(currentTarget.getCurrentHero()), currentTarget),
			HudPosition.TOP, 1, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)
		
    currentTargetHudText = getLastCreatedText()
	wait(0.25)
	
	createEffect([player for player in getAllPlayers() if entityExists(currentTarget)], Effect.SPARKLES, Color.YELLOW,
		updateEveryTick(currentTarget.getPosition()), 10, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
	
	currentTargetEffect = getLastCreatedEntity()
	
	
rule "BountyHunter::ProcessHunterScore":
	@Event playerDied
	@Condition not entityExists(currentTarget) or attacker != currentTarget
	@Condition attacker != victim
	@Condition entityExists(attacker)
	@Condition isGameInProgress()
	
	if not entityExists(currentTarget) or currentTarget == victim:
		currentTarget = attacker
		
		if cfgGiveUltimateOnKillTarget:
			attacker.setUltCharge(100)
		
		if cfgResetCooldownsOnKillTarget:
			attacker.setAbilityCooldown(Button.ABILITY_1, 0)
			attacker.setAbilityCooldown(Button.ABILITY_2, 0)
		
		attacker.setStatusEffect(null, Status.BURNING, 9999)
		attacker.setScore(attacker.getScore() + cfgResetCooldownsOnKillTarget)
		attacker.startForcingOutlineFor([x for x in getAllPlayers() if x != attacker], true, Color.AQUA, OutlineVisibility.ALWAYS)
		attacker.setHealth(attacker.getMaxHealth() * 100)
		
		#// Workaround to prevent incrementing double of score. Since hunted event is dispatched at same time.
		attacker.setScore(attacker.getScore() + (cfgScoreOnKillTarget - cfgScoreOnKill))
		currentTarget = attacker
	else:
		if attacker != victim or (attacker != null and entityExists(attacker)):
			attacker.setScore(attacker.getScore() + cfgScoreOnKill)

rule "BountyHunter::ProcessHuntedKill":
	@Event playerDied
	@Condition attacker == currentTarget
	@Condition entityExists(victim) or victim != null
	@Condition isGameInProgress()
	attacker.setScore(attacker.getScore() + cfgScoreOnKill)
		
rule "BountyHunter::ProcessHuntedSelfKill":
	@Event playerDied
	@Condition victim == currentTarget
	@Condition attacker == null or attacker == victim
	@Condition isGameInProgress()
	currentTarget.clearStatusEffect(Status.BURNING)
	currentTarget.stopForcingOutlineFor(getAllPlayers())
	attacker.setScore(attacker.getScore() - cfgScoreOnKill)
	currentTarget = null
	
rule "BountyHunter::ResetStatus":
	@Event eachPlayer
	@Condition eventPlayer != currentTarget
	@Condition isGameInProgress()
	wait(0.25)
	eventPlayer.clearStatusEffect(Status.BURNING)
	eventPlayer.stopForcingOutlineFor(getAllPlayers())
