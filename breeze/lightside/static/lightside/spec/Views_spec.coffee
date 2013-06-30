describe 'Views Controller', ->

	statusReport = {}

	beforeEach( ->
		statusReport = Breeze.Views.statusReport()
	)

	it 'should respond to getting a status report', ->
		expect(statusReport).toBeDefined()
	it 'should have the correct status information available', ->
		expect(statusReport.pauseControllsVisible).toBeDefined()

	describe 'Playlist change controllers', ->
		it 'should respond to showing the pause controlls', ->
			expect(Breeze.Views.showPauseControlls()).toBeDefined()
			expect(statusReport.pauseControllsVisible).toBe(true)
		it 'should respond to showing the play controlls', ->
			expect(Breeze.Views.showPlayControlls()).toBeDefined()
			expect(statusReport.pauseControllsVisible).toBe(true)
		it 'should respond to toggeling the play controlls', ->
			expect(Breeze.Views.togglePlayPauseControlls()).toBeDefined()
			expect(statusReport.pauseControllsVisible).toBe(false)