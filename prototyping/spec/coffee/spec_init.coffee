describe 'Initialize App', ->
	it 'App Start shoud be defined', ->
		expect(App.Start).toBeDefined()
	it 'App Start constructor shoul return true', ->
		expect(App.Start()).toBeTruthy()