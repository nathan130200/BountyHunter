# Variables
playervar role
globalvar config
globalvar ready
globalvar bountyCount

#!define isBounty(p) p.role == EPR_Bounty
#!define isPlayer(p) p.role == EPR_None

#!define declareConfig(index, name, type, defaultValue) \
    config[index] = createWorkshopSetting(type, "Bounty Hunter", name, defaultValue, 0)

# Player Role Macros
#!define EPR_None 0
#!define EPR_Bounty 1
#!define getRemainingBounty [p for p in getAllHeroes() if p.role == EPR_Bounty]
#!define haveBounty() len(getRemainingBounty()) != 0

playervar effects
playervar effects_iter

#!define setupEffects(p) \
    p.effects = [] \
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.RED, updateEveryTick(p), 1.25, EffectReeval.VISIBILITY_POSITION_AND_RADIUS) \
    p.effects.append([0, getLastCreatedEntity()]) \
    createIcon([x for x in getAllPlayers() if x != p], p.getPosition() + Vector.UP, Icon.SKULL, IconReeval.VISIBILITY_AND_POSITION, Color.RED, true)\
    p.effects.append([1, getLastCreatedEntity()])

#!define destroyEffects(p) \
for p.effects_iter in range(0, len(p.effects), 2):\
    if isEffect(p):\
        destroyEffect(currentEffect(p))\
    elif isIcon(p):\
        destroyIcon(currentEffect(p))\
    wait()

#!define isEffect(p) p.effects[p.effects_iter] == 0
#!define isIcon(p) p.effects[p.effects_iter] == 1
#!define currentEffect(p) p.effects[p.effects_iter + 1]

#!define incrementScore(p, val) \
    p.addToScore(val)
