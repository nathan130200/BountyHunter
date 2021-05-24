#!include "main.opy"

rule "dummy bot: setup testing only":
	@Event eachPlayer
	@Condition hostPlayer == eventPlayer
	@Condition hostPlayer.isHoldingButton(Button.INTERACT)
	createDummy(hostPlayer.getCurrentHero(), Team.ALL, 11, hostPlayer.getPosition(), hostPlayer.getFacingDirection())
	wait(0.25)
	getPlayersInSlot(11, Team.ALL).startForcingButton(Button.PRIMARY_FIRE)