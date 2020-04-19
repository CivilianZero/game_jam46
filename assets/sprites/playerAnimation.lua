return {
	imageSrc = "assets/sprites/character_sheet.png",
	defaultState = "faceRight",
	states = {
		faceRight = {
			frameCount = 1,
			offsetX = 0,
			offsetY = 0,
			frameH = 16,
			frameW = 16,
			nextState = "faceRight",
			switchDelay = 0.1
		},
		faceLeft = {
			frameCount = 1,
			offsetX = 0,
			offsetY = 16,
			frameW = 16,
			frameH = 16,
			nextState = "faceLeft",
			switchDelay = 0.1
		},
		faceUpRight = {
			frameCount = 2,
			offsetX = 0,
			offsetY = 48,
			frameW = 16,
			frameH = 16,
			nextState = "faceUpRight",
			switchDelay = 0.1
		},
		faceUpLeft = {
			frameCount = 1,
			offsetX = 0,
			offsetY = 32,
			frameW = 16,
			frameH = 16,
			nextState = "faceUpLeft",
			switchDelay = 0.6
		},
		right = {
			frameCount = 2,
			offsetX = 0,
			offsetY = 0,
			frameW = 16,
			frameH = 16,
			nextState = "faceRight",
			switchDelay = 0.6
		},
		left = {
			frameCount = 2,
			offsetX = 0,
			offsetY = 16,
			frameW = 16,
			frameH = 16,
			nextState = "faceLeft",
			switchDelay = 0.6
		},
		upLeft= {
			frameCount = 2,
			offsetX = 0,
			offsetY = 32,
			frameW = 16,
			frameH = 16,
			nextState = "faceUpLeft",
			switchDelay = 0.6
		},
		upRight = {
			frameCount = 2,
			offsetX = 0,
			offsetY = 48,
			frameW = 16,
			frameH = 16,
			nextState = "faceUpRight",
			switchDelay = 0.1
		},
		attackRight = {
			frameCount = 4,
			offsetX = 0,
			offsetY = 64,
			frameW = 16,
			frameH = 16,
			nextState = "faceRight",
			switchDelay = 0.1
		},
		attackLeft = {
			frameCount = 4,
			offsetX = 0,
			offsetY = 80,
			frameW = 16,
			frameH = 16,
			nextState = "faceLeft",
			switchDelay = 0.1
		},
		attackUp = {
			frameCount = 3,
			offsetX = 0,
			offsetY = 96,
			frameW = 16,
			frameH = 16,
			nextState = "faceUpRight",
			switchDelay = 0.1
		},
		attackDown = {
			frameCount = 3,
			offsetX = 0,
			offsetY = 112,
			frameW = 16,
			frameH = 16,
			nextState = "faceLeft",
			switchDelay = 0.1
		},
	}
}