#!include "macros.opy"
#!include "variables.opy"
#!extension buffStatusEffects
#!extension debuffStatusEffects

rule "configure global":
    @Event global
    config(iNumTargets, "Number of targets", int[1:3], 1)
    config(iScoreKill, "Score per kill", int[1: 100], 100)
    config(iScoreKillTarget, "Score per kill target", int[1:300], 300)
    config(bGiveUltimate, "Give ultimate ability when kill target", bool, false)
    config(bResetCooldown, "Reset ability cooldown when kill target", bool, false)
    config(fGiveUltimateValue, "Give ultimate ability percent", float[1:100], 5)

rule "gamemode overrides":
    @Event global
    @Condition isGameInProgress()
    disableMusic()
    disableAnnouncer()
    disableScoring()

rule "initialize gamemode":
    @Event global
    @Condition isGameInProgress()
    # Reset old effects, texts, dummies and icons
    destroyAllDummies()
    destroyAllEffects()
    destroyAllHudTexts()
    destroyAllIcons()
    wait()
    
    # Setup icons texts and effects
    for iTargetsIndex in range(0, iNumTargets, 1):
        makeIcon(iconFilter, Icon.DIZZY, currentTarget.getPosition() + vect(0, 0, 2), Color.RED)
        makeText(defaultFilter, "{0} {1}".format(heroIcon(currentTarget.getCurrentHero()), currentTarget), HudPosition.TOP, Color.RED, evalOnce(1 + iTargetsIndex))
        wait()


rule "player left":
    @Event playerLeft
    @Condition isTarget(eventPlayer)
    mTargets.remove(eventPlayer)
    wait()
    
    if len(mTargets) == 0:
        if len(getAllPlayers()) > 0:
            mTargets.append(random.choice(random.shuffle(getAllPlayers())))
        else:
            declareDraw()

    
