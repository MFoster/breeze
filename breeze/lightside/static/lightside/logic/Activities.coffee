class Breeze.Activities
	# Activities Status Variables
	_init = false
	availableActivities = ['test']
	currentPlaylist = ''
	currentActivity = ''
	nextActivity = ''
	chunckTimeSmall = 5
	chunckTimeMedium = 25
	chunckTimeLarge = 50

	constructor: (@attributes) ->
		if !_init
			_init = true
			return Breeze.Activities.statusReport()
		else
			Breeze.DebugCenter.message('Activities class was already initialized.', 'caution')

	@statusReport: () ->
		reportData = {
			_init: _init
			availableActivities: availableActivities
			currentPlaylist: currentPlaylist
			currentActivity: currentActivity
			nextActivity: nextActivity
			chunckTimeSmall: chunckTimeSmall
			chunckTimeMedium: chunckTimeMedium
			chunckTimeLarge: chunckTimeSmall
		}
		return reportData

	@selectPlaylist: (selectedPlaylist) ->
		currentPlaylist = selectedPlaylist
		Breeze.DebugCenter.message('Playlist Selected: ' + selectedPlaylist)
		return currentPlaylist

	@updateActivitiesList: () ->
		Breeze.ActivitiesModel.getActivities(currentPlaylist)

	@startPlaylist: () ->
		Breeze.Timers.startPlaylistTimer(currentPlaylist)
		Breeze.Views.showPauseControlls()
		if currentActivity is ''
			Breeze.Activities.serveNextActivity()
		else
			Breeze.Activities.startActivity(currentActivity)

	@pausePlaylist: () ->
		Breeze.Timers.pausePlaylistTimer(currentPlaylist)
		Breeze.Timers.pauseActivityTimer('test')
		Breeze.Views.showPlayControlls()

	@stopPlaylist: () ->
		Breeze.Timers.stopPlaylistTimer(currentPlaylist)
		Breeze.Timers.stopActivityTimer('test')

	@serveNextActivity: () ->
		Breeze.Views.showPrompt('Want to start test activity?', [
			['Accept', "Breeze.Activities.startActivity('test');"]
			['Snooze', "Breeze.Activities.snoozeActivity('test');"]
		])

	@startActivity: (activityIndex) ->
		if currentActivity is activityIndex
			Breeze.Timers.startActivityTimer(activityIndex)
		else
			currentActivity = activityIndex
			Breeze.Timers.startActivityTimer(activityIndex, [5, 'minutes'])
			Breeze.Views.hidePrompt()

	@snoozeActivity: (activityIndex) ->
		Breeze.Views.showPrompt('How Long Would you like to snooze for?', [
			['1 Hour', "Breeze.Activities.setSnoozeOnActivity('" + activityIndex + "', [1, 'hour']);"]
			['1 Day', "Breeze.Activities.setSnoozeOnActivity('" + activityIndex + "', [1, 'day']);"]
			['1 Week', "Breeze.Activities.setSnoozeOnActivity('" + activityIndex + "', [1, 'week']);"]
		])

	@setSnoozeOnActivity: (activityIndex, amountOfSnooze) ->
		Breeze.DebugCenter.message('Snoozed for ' + amountOfSnooze[0] + ' ' + amountOfSnooze[1])
		Breeze.Views.hidePrompt()

	@completeActivity: (activityIndex) ->
		return true

	@rewindActivity: (activityIndex, amountOfRewind) ->
		return true

	@addTimeToActivity: (activityIndex, amountOfAdd) ->
		return true

	@logToActivity: (activityIndex, logType, logMessage) ->
		return true