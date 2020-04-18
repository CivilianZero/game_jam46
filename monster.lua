Monster = {}

Monster.body = love.physics.newBody(World, 300, 300, "dynamic")
Monster.shape = love.physics.newRectangleShape(16, 16)
Monster.fixture = love.physics.newFixture(Monster.body, Monster.shape)
-- Monster.sprite = Sprites.monster