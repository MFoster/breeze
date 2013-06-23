describe 'Activities Controller', ->

	statusReport = {}

	beforeEach( ->
		statusReport = Breeze.Activities.statusReport()
	)

	it 'should respond to getting a status report', ->
		expect(statusReport).toBeDefined()
	it 'should have the correct status information available', ->
		expect(statusReport.activitiesInitialized).toBeDefined()
		expect(statusReport.availableActivities).toBeDefined()
		expect(statusReport.currentPlaylist).toBeDefined()
		expect(statusReport.currentActivity).toBeDefined()
		expect(statusReport.nextActivity).toBeDefined()
		expect(statusReport.currentPlaylistTimerRunning).toBeDefined()
		expect(statusReport.currentActivityTimerRunning).toBeDefined()
		expect(statusReport.chunckTimeSmall).toBeDefined()
		expect(statusReport.chunckTimeMedium).toBeDefined()
		expect(statusReport.chunckTimeLarge).toBeDefined()

	describe 'Select desired playlist and get activities', ->
		it 'should respond to selecting a playlist', ->
			expect(Breeze.Activities.selectPlaylist()).toBeDefined()
		it 'should have a playlist defined', ->
			expect(statusReport.currentPlaylist).not.toBe('')
		xit 'should return activities for selected playlist', ->
			expect(Breeze.Activities.updateActivitiesList()).toBeDefined()

	describe 'Playlist controlls', ->
		describe 'start', ->
			it 'should respond to starting a playlist', ->
				expect(Breeze.Activities.startPlaylist()).toBeDefined()
			it 'should start playlist timer', ->
				expect(statusReport.currentPlaylistTimerRunning).toBe(true)
		it 'should serve up the next activity', ->
			expect(Breeze.Activities.serveNextActivity()).toBeDefined()
		it 'should start served up activity', ->
			expect(Breeze.Activities.startActivity()).toBeDefined()
		it 'should be able to snooze served up activity', ->
			expect(Breeze.Activities.snoozeActivity()).toBeDefined()
		it 'should pause current playlist and activity', ->
			expect(Breeze.Activities.pausePlaylist()).toBeDefined()
		it 'should stop current playlist', ->
			expect(Breeze.Activities.stopPlaylist()).toBeDefined()

	describe 'Complete activity', ->
		it 'should complete activity when time runs out', ->
			expect(Breeze.Activities.completeActivity()).toBeDefined()
		it 'should complete activity when instant complete is clicked', ->
			expect(Breeze.Activities.completeActivity()).toBeDefined()
		it 'should allow rewind on activity', ->
			expect(Breeze.Activities.rewindActivity()).toBeDefined()
		it 'should allow add time on activity', ->
			expect(Breeze.Activities.addTimeToActivity()).toBeDefined()

	describe 'Log events on activities', ->
		it 'should respond to logging events', ->
			expect(Breeze.Activities.logToActivity()).toBeDefined()