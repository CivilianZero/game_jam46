return {
	imageSrc = "assets/sprites/character_sheet.png",
	defaultState = "right",
	states = {
		right = {
			frameCount = 2,
			offsetX = 0,
			offsetY = 0,
			frameW = 16,
			frameH = 16,
			nextState = "right",
			switchDelay = 0.4
		},
		left = {
			frameCount = 2,
			offsetX = 0,
			offsetY = 18,
			frameW = 16,
			frameH = 16,
			nextState = "left",
			switchDelay = 0.4
		},
		upLeft= {
			frameCount = 2,
			offsetX = 0,
			offsetY = 36,
			frameW = 16,
			frameH = 16,
			nextState = "upLeft",
			switchDelay = 0.4
		},
		upRight = {
			frameCount = 2,
			offsetX = 0,
			offsetY = 54,
			frameW = 16,
			frameH = 16,
			nextState = "upRight",
			switchDelay = 0.4
		},
		-- see about getting attack right and left to swing higher
		attackRight = {
			frameCount = 4,
			offsetX = 0,
			offsetY = 72,
			frameW = 18,
			frameH = 16,
			nextState = "right",
			switchDelay = 0.05
		},
		attackLeft = {
			frameCount = 4,
			offsetX = 0,
			offsetY = 90,
			frameW = 18,
			frameH = 16,
			nextState = "left",
			switchDelay = 0.05
		},
		attackDown = {
			frameCount = 3,
			offsetX = 0,
			offsetY = 108,
			frameW = 18,
			frameH = 16,
			nextState = "right",
			switchDelay = 0.05
		},
		attackUp = {
			frameCount = 3,
			offsetX = 0,
			offsetY = 126,
			frameW = 18,
			frameH = 16,
			nextState = "upRight",
			switchDelay = 0.05
		}
	}
}