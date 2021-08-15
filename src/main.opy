#!include "shared.opy"
#!include "config.opy"

rule "BountyHunter::.Ctor":
    @Event global
    disableScoring()

rule "BountyHunter::SkipAssembleHeroes":
    @Event global
    @Condition isAssemblingHeroes()
    setMatchTime(10)

rule "BountyHunter::PreGame":
    @Event global
    @Condition isGameInProgress()
    @Condition not ready
    bountyCount = getNumberOfPlayers(Team.ALL)

    if bountyCount <= initialBountyCount:
        bountyCount = round(bountyCount / initialBountyCount)
    
    if bountyCount == 0:
        bountyCount = 1
    
    if bountyCount == 1 and getNumberOfPlayers(Team.ALL) == 1:
        printLog("Cannot setup gamemode. (reason='Not enough players')")
        ready = false
        wait(1)
        goto RULE_START

    ready = true

# rule "BountyHunter::Init":
#     @Event global
#     @Condition isGameInProgress()
#     @Condition ready

rule "BountyHunter::ProcessScore(Mode=ESM_None,Type=EPR_None)":
    @Event playerDealtFinalBlow
    @Condition isGameInProgress()
    @Condition isPlayer(attacker)
    @Condition ready
    
    # Validate if victim is bounty or not, then increment score.
    if isBounty(victim):
        incrementScore(attacker, scorePerKillTarget)
        destroyEffects(victim)
    else:
        incrementScore(attacker, scorePerKill)
    
    # Players become bounty now.
    attacker.role = EPR_Bounty
    
    # Setup effects
    setupEffects(attacker)

rule "BountyHunter::ProcessScore(Mode=ESM_ASSISTENCE,Type=EPR_ALL)":
    @Event playerEarnedElimination
    @Condition isGameInProgress()
    @Condition ready
    if victim != null and victim != attacker:
        attacker.addToScore(scorePerAssistence)

rule "BountyHunter::ProcessScore(Mode=ESM_None,Type=EPR_Bounty)":
    @Event playerDealtFinalBlow
    @Condition isGameInProgress()
    @Condition isBounty(attacker)
    @Condition ready

    attacker.addToScore(scorePerKill)
    
    if isBounty(victim):
        victim.role = EPR_None
        destroyEffects(victim)
        
rule "BountyHunter::ProcessDeath(Mode=EDM_None,Type=EPR_All)":
    @Event playerDied
    @Condition isGameInProgress()
    @Condition ready
    
    if isBounty(victim):
        victim.role = EPR_None
        destroyEffects(victim)

rule "BountyHunter::ProcessDeath(Mode=EDM_Self,Type=EPR_ALL)":
    @Event playerDied
    @Condition isGameInProgress()
    @Condition ready
    
    if not entityExists(attacker) or attacker == victim:
        victim.addToScore(-penaltyForSelfKill)
    else: 
        if attacker == null or eventWasEnvironment:
            victim.addToScore(-penaltyForSelfKill)

