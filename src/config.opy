#!mainFile "main.opy"

#!define ID_INITIAL_BOUNTY_COUNT 0
#!define ID_SCORE_PER_KILL 1
#!define ID_SCORE_PER_KILL_TARGET 2
#!define ID_SCORE_PER_ASSISTENCE 3
#!define ID_RESET_ABILITY_COOLDOWN 4
#!define ID_DEVELOPMENT_MODE 5
#!define ID_PENAULTY_FOR_SELF_KILL 6

#!define initialBountyCount config[ID_INITIAL_BOUNTY_COUNT]
#!define scorePerKill config[ID_SCORE_PER_KILL]
#!define scorePerKillTarget config[ID_SCORE_PER_KILL_TARGET]
#!define scorePerAssistence config[ID_SCORE_PER_ASSISTENCE]
#!define resetAbilityCooldownWhenKillTarget config[ID_RESET_ABILITY_COOLDOWN]
#!define isDevelopmentEnv config[ID_DEVELOPMENT_MODE]
#!define penaltyForSelfKill config[ID_PENAULTY_FOR_SELF_KILL]

rule "BountyHunter::Configure":
    @Event global
    declareConfig(ID_INITIAL_BOUNTY_COUNT, "Bounty Targets", int[1:5], 1)
    declareConfig(ID_SCORE_PER_KILL, "Score per Kill", int[1:500], 100)
    declareConfig(ID_SCORE_PER_KILL_TARGET, "Score per Kill Target", int[1:500], 300)
    declareConfig(ID_SCORE_PER_ASSISTENCE, "Score per Assistence", int[5:100], 25)
    /*declareConfig(ID_RESET_ABILITY_COOLDOWN, "Reset Ability Cooldown When Kill Target", bool, true)*/
    /* BOTS ONLY!!! declareConfig(ID_DEVELOPMENT_MODE, "Development Mode", bool, false) */
    declareConfig(ID_PENAULTY_FOR_SELF_KILL, "Penalty for self kill", int[50:500], 150)
