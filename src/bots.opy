#!define bot getLastCreatedEntity()

playervar _dest
#!define dest eventPlayer._dest
    
rule "BountyHunter::DummyBot::.Ctor":
    @Condition isGameInProgress()
    @Condition isDevelopmentEnv
    @Condition not ready
    
    wait(1)
    
    for Z in range(4, 11):
        createDummy(random.choice([Hero.ZENYATTA, Hero.BASTION, Hero.ORISA]), Team.ALL,
            evalOnce(Z), nearestWalkablePosition(vect(1000, 1000, 1000)), vect(0,0,0))

#!define COND entityExists(dest) and not isInLoS(eventPlayer, dest, BarrierLos.PASS_THROUGH_BARRIERS)

rule "BountyHunter::DummyBot::Tick":
    @Event eachPlayer
    @Condition isGameInProgress()
    @Condition isDevelopmentEnv
    @Condition ready
    @Condition eventPlayer.isDummy()
    @Condition eventPlayer.isAlive()

    dest = random.choice(random.shuffle([p for p in getAllPlayers() if not p.isDummy()]))

    if distance(eventPlayer, dest) <= 5 or isInLoS(eventPlayer.getEyePosition(), dest, BarrierLos.PASS_THROUGH_BARRIERS):
        eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    else:
        eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)

    eventPlayer.startThrottleInDirection(directionTowards(eventPlayer, nearestWalkablePosition(dest)), 1,
        Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.DIRECTION_AND_MAGNITUDE)

    eventPlayer.startFacing(directionTowards(eventPlayer, dest), 75, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)

    wait(5)
    goto RULE_START
