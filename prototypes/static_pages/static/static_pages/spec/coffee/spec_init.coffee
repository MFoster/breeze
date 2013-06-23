describe 'Initialize the Breeze App', ->
	it 'Breeze Start should be defined', ->
		expect(Breeze.Initializer).toBeDefined()
	it 'Breeze Start constructor should return true', ->
		expect(Breeze.Initializer()).toBeTruthy()