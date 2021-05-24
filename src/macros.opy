# -------------------------------- Macro Definitions --------------------------------
#!define config(Var, Name, Type, Def) Var = createWorkshopSetting(Type, "Bounty Hunter", Name, Def)

#!define isTarget(Player) Player in mTargets

#!define makeIcon(Vis, Type, Pos, Col) createIcon(Vis, Pos, Type, IconReeval.VISIBILITY_POSITION_AND_COLOR, Col, true)

#!define makeEffect(Vis, Type, Pos) createEffect(Vis, Type, Color.TEAM_1, Pos, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

#!define makeText(Vis, Text, Pos, Col, Off) hudSubtext(Vis, Text, Pos, Off, Col, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

# Filters
#!define iconFilter [x for x in getAllPlayers() if entityExists(mTargets[evalOnce(iTargetsIndex)]) and not x in mTargets]

#!define defaultFilter [x for x in getAllPlayers() if entityExists(mTargets[evalOnce(iTargetsIndex)])]

#!define currentTarget mTargets[evalOnce(iTargetsIndex)]