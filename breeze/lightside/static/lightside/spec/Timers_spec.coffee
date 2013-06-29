describe 'Timers Controller', ->

	statusReport = {}
	testEventId = null

	beforeEach( ->
		statusReport = Breeze.Timers.statusReport()
	)

	it 'should respond to getting a status report', ->
		expect(statusReport).toBeDefined()
	it 'should have the correct status information available', ->
		expect(statusReport.playlistTimers).toBeDefined()
		expect(statusReport.activityTimers).toBeDefined()
		expect(statusReport.expectedEvents).toBeDefined()

	describe 'event methods', ->
		it 'should respond to registering an event', ->
			expect(Breeze.Timers.registerEvent()).toBeDefined()
		it 'should add event when registering', ->
			testEventId = Breeze.Timers.registerEvent({})
			expect(statusReport.expectedEvents[testEventId]).toBeDefined()
		it 'should have the correct properties', ->
			expect(statusReport.expectedEvents[testEventId].atFireTime).toBeDefined()
			expect(statusReport.expectedEvents[testEventId].onFireCall).toBeDefined()
		it 'should respond to removeing an event', ->
			expect(Breeze.Timers.deRegisterEvent()).toBeDefined()
		it 'should remove event when de-registering', ->
			Breeze.Timers.deRegisterEvent(testEventId)
			expect(statusReport.expectedEvents[testEventId]).not.toBeDefined()

	describe 'playlist timer methods', ->
		it 'should respond to starting the playlist', ->
			expect(Breeze.Timers.startPlaylistTimer()).toBeDefined()
		it 'should respond to pausing the playlist', ->
			expect(Breeze.Timers.pausePlaylistTimer()).toBeDefined()
		it 'should respond to stopping the playlist', ->
			expect(Breeze.Timers.stopPlaylistTimer()).toBeDefined()

	describe 'activity timer methods', ->
		it 'should respond to starting an activity', ->
			expect(Breeze.Timers.startActivityTimer()).toBeDefined()
		it 'should respond to pausing an activity', ->
			expect(Breeze.Timers.pauseActivityTimer()).toBeDefined()
		it 'should respond to stopping an activity', ->
			expect(Breeze.Timers.stopActivityTimer()).toBeDefined()