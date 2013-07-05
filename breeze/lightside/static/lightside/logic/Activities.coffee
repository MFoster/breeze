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
		Breeze.Interactions.displayPersonPrompt('startActivity', nextActivity)

	@startActivity: (activityId) ->
		Breeze.Views.makeActivityActive(activityId)
		if currentActivityId is activityId
			Breeze.Timers.startActivityTimer(activityId)
		else
			activityDuration = nextActivity.remainingDuration
			currentActivityId = activityId
			Breeze.Timers.startActivityTimer(activityId, activityDuration)
			Breeze.Views.hidePromptBox()

	@snoozeActivity: (activityId) ->
		activity = Breeze.Activities.Model.getActivityById(activityId)
		Breeze.Interactions.displayPersonPrompt('snoozeTime', activity)

	@setSnoozeOnActivity: (activityId, amountOfSnooze) ->
		newAvailableTime = Breeze.Timers.addTimeToMillisecondTime(Breeze.Timers.getTime(), amountOfSnooze[0], amountOfSnooze[1])
		Breeze.Activities.Model.updateActivityAvailableTimeById(activityId, newAvailableTime)
		Breeze.Views.hidePromptBox()
		Breeze.DebugCenter.message('Updated activity ' + activityId + ' available date to ' + newAvailableTime.toString())

	@activityTimeExpired: (activityId) ->
		activity = Breeze.Activities.Model.getActivityById(activityId)
		Breeze.Interactions.displayPersonPrompt('completeActivity', activity)

	@completeActivity: () ->
		if currentActivityId != ''
			activity = Breeze.Activities.Model.getActivityById(currentActivityId)
			Breeze.Interactions.displayPersonPrompt('completeActivity', activity)

	@setCompleteOnActivity: (activityId) ->
		Breeze.Timers.stopActivityTimer(activityId)
		Breeze.Activities.Model.archiveActivityById(activityId)
		Breeze.Views.removeActivity(activityId)
		Breeze.People.addOneToPersonsChunckStats()
		Breeze.Activities.serveNextActivity()

	@rewindActivity: (activityId, amountOfRewind) ->
		return true

	@addTimeToActivity: (activityId, amountOfAdd) ->
		return true

	@logToActivity: (activityId, logType, logMessage) ->
		return true