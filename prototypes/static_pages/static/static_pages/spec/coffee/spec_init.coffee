describe 'Initialize App', ->
	it 'App Start should be defined', ->
		expect(App.Start).toBeDefined()
	it 'App Start constructor should return true', ->
		expect(App.Start()).toBeTruthy()