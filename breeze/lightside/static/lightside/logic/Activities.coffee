class Breeze.Activities
	# Activities Status Variables
	_init = false
	currentPlaylist = ''
	currentActivityId = ''
	nextActivity = ''
	activitiesServed = 0

	constructor: (@attributes) ->
		if !_init
			_init = true
			return Breeze.Activities.statusReport()
		else
			Breeze.DebugCenter.message('Activities class was already initialized.', 'caution')

	@statusReport: () ->
		reportData = {
			_init: _init
			currentPlaylist: currentPlaylist
			currentActivityId: currentActivityId
			nextActivity: nextActivity
			activitiesServed: activitiesServed
		}
		return reportData

	@selectPlaylist: (selectedPlaylist) ->
		currentPlaylist = selectedPlaylist
		Breeze.Activities.Model.getActivities(currentPlaylist)
		Breeze.DebugCenter.message('Playlist Selected: ' + selectedPlaylist)
		return currentPlaylist

	@updateActivitiesList: () ->
		Breeze.ActivitiesModel.getActivities(currentPlaylist)

	@startPlaylist: () ->
		Breeze.Timers.startPlaylistTimer(currentPlaylist)
		Breeze.Views.showPauseControlls()
		if currentActivityId is ''
			Breeze.Activities.serveNextActivity()
		else
			Breeze.Activities.startActivity(currentActivityId)

	@pausePlaylist: () ->
		Breeze.Timers.pausePlaylistTimer(currentPlaylist)
		Breeze.Timers.pauseActivityTimer(currentActivityId)
		Breeze.Views.showPlayControlls()

	@stopPlaylist: () ->
		Breeze.Timers.stopPlaylistTimer(currentPlaylist)
		Breeze.Timers.stopActivityTimer(currentActivityId)

	@serveNextActivity: () ->
		activitiesServed++
		nextActivity = Breeze.Activities.Model.getNextActivity()
		Breeze.Views.showPrompt('Want to start: ' + nextActivity.text + '?', [
			['Accept', "Breeze.Activities.startActivity('" + nextActivity.id + "');"]
			['Snooze', "Breeze.Activities.snoozeActivity('" + nextActivity.id + "');"]
		])

	@startActivity: (activityId) ->
		Breeze.Views.makeActivityActive(activityId)
		if currentActivityId is activityId
			Breeze.Timers.startActivityTimer(activityId)
		else
			activityDuration = nextActivity.remainingDuration
			currentActivityId = activityId
			Breeze.Timers.startActivityTimer(activityId, activityDuration)
			Breeze.Views.hidePrompt()

	@snoozeActivity: (activityId) ->
		Breeze.Views.showPrompt('How Long Would you like to snooze for?', [
			['1 Hour', "Breeze.Activities.setSnoozeOnActivity('" + activityId + "', [1, 'hour']);"]
			['1 Day', "Breeze.Activities.setSnoozeOnActivity('" + activityId + "', [1, 'day']);"]
			['1 Week', "Breeze.Activities.setSnoozeOnActivity('" + activityId + "', [1, 'week']);"]
		])

	@setSnoozeOnActivity: (activityId, amountOfSnooze) ->
		Breeze.DebugCenter.message('Snoozed for ' + amountOfSnooze[0] + ' ' + amountOfSnooze[1])
		Breeze.Views.hidePrompt()

	@completeActivity: () ->
		if currentActivityId != ''
			Breeze.Timers.stopActivityTimer(currentActivityId)
			Breeze.Activities.Model.archiveActivityById(currentActivityId)
			Breeze.Views.removeActivity(currentActivityId)
			Breeze.People.addOneToPersonsChunckStats()
			currentActivityId = ''
			Breeze.Activities.serveNextActivity()

	@rewindActivity: (activityId, amountOfRewind) ->
		return true

	@addTimeToActivity: (activityId, amountOfAdd) ->
		return true

	@logToActivity: (activityId, logType, logMessage) ->
		return true