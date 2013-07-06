class Breeze.Activities
	# Activities Status Variables
	_init = false
	currentPlaylist = {}
	currentActivity = {}
	nextActivity = {}
	activitiesServed = 0

	constructor: (@attributes) ->
		if !_init
			personsDefaultPlaylist = Breeze.People.getPersonsDefaultPlaylist()
			Breeze.Activities.setSelectedPlaylist(personsDefaultPlaylist)
			_init = true
			return Breeze.Activities.statusReport()
		else
			Breeze.DebugCenter.message('Activities class was already initialized.', 'caution')

	@statusReport: () ->
		reportData = {
			_init: _init
			currentPlaylist: currentPlaylist
			currentActivity: currentActivity
			nextActivity: nextActivity
			activitiesServed: activitiesServed
		}
		return reportData

	@selectPlaylist: () ->
		Breeze.Interactions.displayPersonPrompt('selectPlaylist')
		return true

	@setSelectedPlaylist: (selectedPlaylistId) ->
		currentPlaylist = Breeze.People.getPersonsPlaylistsById(selectedPlaylistId)
		Breeze.DebugCenter.message('Playlist Selected: ' + currentPlaylist.name)
		Breeze.Activities.updateActivitiesList()
		Breeze.Views.hidePromptBox()
		return currentPlaylist

	@updateActivitiesList: () ->
		Breeze.Activities.Model.getActivities(currentPlaylist.id)
		Breeze.DebugCenter.message('Getting Activities for Playlist: ' + currentPlaylist.name)

	@startPlaylist: () ->
		if $.isEmptyObject(currentPlaylist)
			Breeze.Activities.selectPlaylist()
		else
			Breeze.Timers.startPlaylistTimer(currentPlaylist.id)
			Breeze.Views.showPauseControlls()
			if $.isEmptyObject(currentActivity)
				Breeze.Activities.serveNextActivity()
			else
				Breeze.Activities.startActivity(currentActivity.id)
		Breeze.DebugCenter.message('Started Playlist: ' + currentPlaylist.name)

	@pausePlaylist: () ->
		Breeze.Timers.pausePlaylistTimer(currentPlaylist.id)
		Breeze.Timers.pauseActivityTimer(currentActivity.id)
		Breeze.Views.showPlayControlls()
		Breeze.DebugCenter.message('Paused Playlist: ' + currentPlaylist.name)

	@stopPlaylist: () ->
		Breeze.Timers.stopPlaylistTimer(currentPlaylist.id)
		Breeze.Timers.stopActivityTimer(currentActivity.id)
		Breeze.DebugCenter.message('Stopped Playlist: ' + currentPlaylist.name)

	@serveNextActivity: () ->
		activitiesServed++
		if $.isEmptyObject(currentActivity)
			currentActivity = Breeze.Activities.Model.getNextActivity(0)
			nextActivity = Breeze.Activities.Model.getNextActivity(1)
			Breeze.DebugCenter.message('Got Next Activities from Model')
		Breeze.Interactions.displayPersonPrompt('startActivity', currentActivity)

	@startActivity: (activityId) ->
		if activityId is ''
			if $.isEmptyObject(currentActivity)
				currentActivity = Breeze.Activities.Model.getNextActivity(0)
				nextActivity = Breeze.Activities.Model.getNextActivity(1)
				Breeze.Timers.startActivityTimer(currentActivity.id, currentActivity.remainingDuration)
		else
			currentActivity = Breeze.Activities.Model.getActivityById(activityId)
			Breeze.Timers.startActivityTimer(currentActivity.id, currentActivity.remainingDuration)
			Breeze.Views.hidePromptBox()
		Breeze.Views.makeActivityActive(currentActivity.id)
		Breeze.DebugCenter.message('Started Activity: ' + currentActivity.text)

	@manualStartActivity: (activityId) ->
		if activityId != ''
			Breeze.Views.showPauseControlls()
			Breeze.Timers.pausePlaylistTimer(currentPlaylist.id)
			Breeze.Timers.stopActivityTimer(currentActivity.id)
			currentActivity = Breeze.Activities.Model.getActivityById(activityId)
			nextActivity = Breeze.Activities.Model.getNextActivity(1)
			Breeze.Activities.Model.moveActivityToTop(currentActivity.id)
			Breeze.Timers.startActivityTimer(currentActivity.id, currentActivity.remainingDuration)
			Breeze.Timers.startPlaylistTimer(currentPlaylist.id)
			Breeze.Views.makeActivityActive(currentActivity.id)
			Breeze.DebugCenter.message('Manually started: ' + currentActivity.text + '.')
		else
			return false

	@snoozeActivity: (activityId) ->
		activity = currentActivity
		if activityId != ''
			activity = Breeze.Activities.Model.getActivityById(activityId)
		Breeze.Interactions.displayPersonPrompt('snoozeTime', activity)

	@setSnoozeOnActivity: (activityId, quantity, type) ->
		newAvailableTime = Breeze.Timers.addTimeToMillisecondTime(Breeze.Timers.getTime(), quantity, type)
		Breeze.Activities.Model.updateActivityAvailableTimeById(activityId, newAvailableTime)
		Breeze.Activities.Model.updateActivitySort()
		Breeze.Activities.serveNextActivity()
		Breeze.DebugCenter.message('Updated activity ' + activityId + ' available date to ' + newAvailableTime.toString())

	@activityTimeExpired: (activityId) ->
		activity = currentActivity
		if activityId != ''
			activity = Breeze.Activities.Model.getActivityById(activityId)
		Breeze.Interactions.displayPersonPrompt('completeActivity', activity)
		Breeze.DebugCenter.message('Time expired on: ' + activity.text)

	@completeActivity: () ->
		Breeze.Timers.pauseActivityTimer(currentActivity.id)
		Breeze.Interactions.displayPersonPrompt('completeActivity', currentActivity)

	@setCompleteOnActivity: (activityId) ->
		currentTime = Breeze.Timers.getTime()
		Breeze.Timers.stopActivityTimer(activityId)
		Breeze.Activities.Model.archiveActivityById(activityId, currentTime)
		Breeze.Views.removeActivity(activityId)
		Breeze.People.addOneToPersonsChunckStats()
		currentActivity = nextActivity
		Breeze.Activities.serveNextActivity()
		Breeze.DebugCenter.message('Completed Activity: ' + activityId)

	@rewindPlaylist: () ->
		Breeze.Timers.pausePlaylistTimer(currentPlaylist.id)
		Breeze.Timers.pauseActivityTimer(currentActivity.id)
		Breeze.Interactions.displayPersonPrompt('rewindTime')

	@setPlaylistRewind: (timeQuantity, timeType) ->
		Breeze.Timers.rewindPlaylistTimer(currentPlaylist.id, timeQuantity, timeType)
		Breeze.Timers.rewindActivityTimer(currentActivity.id, timeQuantity, timeType)
		Breeze.Activities.startPlaylist()
		Breeze.DebugCenter.message('Reset current playlist and activity by ' + timeQuantity + ' ' + timeType)

	@addTimeToActivity: (activityId) ->
		activity = currentActivity
		if activityId != '' then activity = Breeze.Activities.Model.getActivityById(activityId)
		Breeze.Interactions.displayPersonPrompt('addTime', activity)

	@setAddTimeToActivity: (activityId = '', timeQuantity, timeType) ->
		if activityId is '' then activityId = currentActivity.id
		millisecondChange = Breeze.Timers.convertTimeToMilliseconds(timeQuantity, timeType)
		Breeze.Timers.addTimeToActivityTimer(activityId, millisecondChange)
		Breeze.Activities.Model.addTimeToDurationsById(activityId, millisecondChange)
		Breeze.Views.hidePromptBox()
		Breeze.Timers.startActivityTimer(activityId)
		Breeze.DebugCenter.message('Added ' + timeQuantity + ' ' + timeType + ' to ' + activityId)

	@logToActivity: (activityId, logType, logMessage) ->
		return true