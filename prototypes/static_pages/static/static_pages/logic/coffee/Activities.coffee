class Breeze.Activities
	# Establish internal variables
	# USER Data, will need to be moved to User logic
	userName = 'Some Nameor'
	userAvailablePlaylists = ['default']
	userChuncksCompletedMonth = 32
	userChuncksCompletedDay = 0
	userActionLog = []

	# Activities Status Variables
	activitiesInitialized = false
	availableActivities = []
	currentPlaylist = ''
	currentActivity = ''
	nextActivity = ''
	currentPlaylistTimerRunning = false
	currentActivityTimerRunning = false
	chunckTimeSmall = 5
	chunckTimeMedium = 25
	chunckTimeLarge = 50

	constructor: (@attributes) ->
		activitiesInitialized = true
		availableActivities = []
		return true

	@statusReport: () ->
		reportData = {
			activitiesInitialized: activitiesInitialized
			availableActivities: availableActivities
			currentPlaylist: currentPlaylist
			currentActivity: currentActivity
			nextActivity: nextActivity
			currentPlaylistTimerRunning: currentPlaylistTimerRunning
			currentActivityTimerRunning: currentActivityTimerRunning
			chunckTimeSmall: chunckTimeSmall
			chunckTimeMedium: chunckTimeMedium
			chunckTimeLarge: chunckTimeSmall
		}
		return reportData

	@selectPlaylist: (selectedPlaylist) ->
		currentPlaylist = userAvailablePlaylists[0]
		return currentPlaylist

	@updateActivitiesList: () ->
		Breeze.ActivitiesModel.getActivities(currentPlaylist)

	@startPlaylist: () ->
		Breeze.Timers.startUpTimer(currentPlaylist)
		currentPlaylistTimerRunning = true
		return true

	@pausePlaylist: () ->
		return true

	@stopPlaylist: () ->
		return true

	@serveNextActivity: () ->
		return true

	@startActivity: (activityIndex) ->
		return true

	@snoozeActivity: (activityIndex, amountOfSnooze) ->
		return true

	@completeActivity: (activityIndex) ->
		return true

	@rewindActivity: (activityIndex, amountOfRewind) ->
		return true

	@addTimeToActivity: (activityIndex, amountOfAdd) ->
		return true

	@logToActivity: (activityIndex, logType, logMessage) ->
		return true