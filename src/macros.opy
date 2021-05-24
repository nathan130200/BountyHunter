# Create new configuration
#!define config(Var, Name, Type, Def) Var = createWorkshopSetting(Type, "Bounty Hunter", Name, Def)

# Determins if current player is bounty target.
#!define isTarget(Player) Player in mTargets

# Quick function to create icon
#!define makeIcon(Vis, Type, Pos, Col) createIcon(Vis, Pos, Type, IconReeval.VISIBILITY_POSITION_AND_COLOR, Col, true)

# Quick function to create effect
#!define makeEffect(Vis, Type, Pos) createEffect(Vis, Type, Color.TEAM_1, Pos, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

# Quick function to create text
#!define makeText(Vis, Text, Pos, Col, Off) hudSubtext(Vis, Text, Pos, Off, Col, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

# Bounty icon filter
#!define iconFilter [x for x in getAllPlayers() if entityExists(mTargets[evalOnce(iTargetsIndex)]) and not x in mTargets]

# Generic filter for effects
#!define defaultFilter [x for x in getAllPlayers() if entityExists(mTargets[evalOnce(iTargetsIndex)])]

# Determins current bounty target
#!define currentTarget mTargets[evalOnce(iTargetsIndex)]