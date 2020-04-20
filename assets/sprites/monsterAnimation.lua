return {
	imageSrc = "assets/sprites/bloodbeast_sheet.png",
	defaultState = "idle",
	states = {
		idle = {
			frameCount = 16,
			offsetX = 0,
			offsetY = 0,
			frameW = 16,
			frameH = 16,
			nextState = "idle",
			switchDelay = 0.1
		},
		dead = {
			frameCount = 4,
			offestX = 0,
			offsetY = 18,
			frameW = 16,
			frameH = 16,
			nextState = "idle",
			switchDelay = 0.09
		}
	}
}