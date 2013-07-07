class Breeze.Views
	# View Status Variables
	_init = false
	pauseControllsVisible = true
	promptBoxVisible = true
	addEditFormVisible = true
	addEditForm = "form not loaded"
	debugVisible = true

	constructor: (@attributes) ->
		if !_init
			Breeze.Views.hideDebugView()
			Breeze.Views.hidePromptBox()
			Breeze.Views.showPlayControlls()
			Breeze.Views.hideAddEditForm()
			_init = true
			return Breeze.Views.statusReport()
		else
			Breeze.DebugCenter.message('Views class was already initialized.', 'caution')
			return false

	@statusReport: () ->
		reportData = {
			_init: _init
			pauseControllsVisible: pauseControllsVisible
			promptBoxVisible: promptBoxVisible
			addEditForm: addEditForm
			debugVisible: debugVisible
		}
		return reportData

	@updateDebugView: () ->
		if debugVisible
			currentTime = new Date().getTime()
			timersStatus = Breeze.Timers.statusReport()
			activityStatus = Breeze.Activities.statusReport()
			peopleStatus = Breeze.People.statusReport().personObject.personsPreferences
			$('#debug-current-time').html(Breeze.Timers.convertMillisecondToString(currentTime))
			$('#debug-activities-presented').html(activityStatus.activitiesServed)
			$('#debug-large-chunck').html(peopleStatus.chunckTimeLarge)
			$('#debug-medium-chunck').html(peopleStatus.chunckTimeMedium)
			$('#debug-small-chunck').html(peopleStatus.chunckTimeSmall)
			debugEventsList = $('#debug-events-list')
			debugEventsList.empty().prepend('<li><span class="debug-stat-name">Event Id</span><span class="debug-stat-description">Expected In</span></li>')
			for expectedEvent, time of timersStatus.expectedEvents
				debugEventsList.append('<li><span class="debug-stat-name">' + expectedEvent + '</span><span class="debug-stat-output">' + (time.atFireTime - currentTime) + '</span></li>')
			debugPlaylistTimerList = $('#debug-playlist-timer-list')
			debugPlaylistTimerList.empty().prepend('<li><span class="debug-stat-name">Playlist Id</span><span class="debug-stat-description">Elapsed Time</span></li>')
			for playlistTimer, values of timersStatus.playlistTimers
				debugPlaylistTimerList.append('<li><span class="debug-stat-name">' + playlistTimer + '</span><span class="debug-stat-output">' + values.elapsedTime + '</span></li>')
			debugActivityTimers = $('#activity-list-debug-activity-timers')
			debugActivityTimers.empty().prepend('<h6>Activity Timers</h6>')
			timerList = $('<ul id="' + activityTimer + '" class="debug-stats-list"></ul>')
			for activityTimer, values of timersStatus.activityTimers
				timerList.prepend('<li><span class="debug-stat-name">Timer For</span><span class="debug-stat-description">' + activityTimer + '</span></li>')
				for property, value of values
					timerList.append('<li><span class="debug-stat-name">' + property + '</span><span class="debug-stat-output">' + value + '</span></li>')
			debugActivityTimers.append(timerList)
			debugActivity = $('#activity-list-debug-activity')
			debugActivity.empty().prepend('<h6>Current Activity</h6>')
			currentActivityData = Breeze.Activities.Model.getActivityById(activityStatus.currentActivity.id)
			activityList = $('<ul id="' + activityStatus.currentActivityId + '" class="debug-stats-list"></ul>')
			for property, value of currentActivityData
				activityList.append('<li><span class="debug-stat-name">' + property + '</span><span class="debug-stat-output">' + value + '</span></li>')
			debugActivity.append(activityList)

	@showPauseControlls: () ->
		if !pauseControllsVisible
			$('#activity-control-left').html('<span id="activity-control-rewind">Rewind</span>')
			$('#activity-control-center').html('<span id="activity-control-pause">Pause</span>')
			$('#activity-control-right').html('<span id="activity-control-complete">Complete</span>')
			pauseControllsVisible = true

	@showPlayControlls: () ->
		if pauseControllsVisible
			$('#activity-control-left').html('<span id="activity-control-playlists">Playlists</span>')
			$('#activity-control-center').html('<span id="activity-control-play">Play</span>')
			$('#activity-control-right').html('<span id="activity-control-stop">Stop</span>')
			pauseControllsVisible = false

	@togglePlayPauseControlls: () ->
		if pauseControllsVisible
			Breeze.Views.showPlayControlls()
		else
			Breeze.Views.showPauseControlls()

	@showDebugView: () ->
		if !debugVisible
			$('#activity-list-debug-info').show()
			debugVisible = true

	@hideDebugView: () ->
		if debugVisible
			$('#activity-list-debug-info').hide()
			debugVisible = false

	@toggleDebugView: () ->
		if debugVisible
			Breeze.Views.hideDebugView()
		else
			Breeze.Views.showDebugView()

	@showAddEditForm: () ->
		if !addEditFormVisible
			$('#activity-add-edit').show()
			addEditFormVisible = true

	@hideAddEditForm: () ->
		if addEditFormVisible
			$('#activity-add-edit').hide()
			addEditFormVisible = false

	@toggleAddEditForm: () ->
		if addEditFormVisible
			Breeze.Views.hideAddEditForm()
		else
			Breeze.Views.showAddEditForm()

	@showPromptBox: () ->
		if !promptBoxVisible
			$('#activity-prompt').show()
			promptBoxVisible = true

	@hidePromptBox: () ->
		if promptBoxVisible
			$('#activity-prompt').hide()
			promptBoxVisible = false

	@togglePromptBox: () ->
		if promptBoxVisible
			Breeze.Views.hidePromptBox()
		else
			Breeze.Views.showPromptBox()

	@buildPromptBox: (prompt, message, controls) ->
		$('#activity-prompt-header').html(prompt)
		$('#activity-prompt-message').html(message)
		$('#activity-prompt-controlls').html( ->
			returnHtml = ''
			for control in controls
				returnHtml += '<button class="button-base" onclick="' + control.action + '">' + control.label + '</button>'
			return returnHtml
		)
		Breeze.Views.showPromptBox()

	@placeProgressMarker: (percentage) ->
		# Angle negative for clockwise rotation
		angle = 2 * Math.PI * (-percentage)
		# Positive from center for 6 o'clock starting position
		xPos = 18 + 6 * Math.cos(angle)
		yPos = 18 + 6 * Math.sin(angle)
		$('#activity-progress-marker').animate({
			top: xPos
			left: yPos
		}, 1000, 'linear')

	@showPersonalInfo: (personObject) ->
		$('#person-name').html(personObject.personsName)
		$('#activity-completed-month').html(personObject.personsStats.chuncksCompletedMonth + ' Mo')
		$('#activity-completed-today').html('Day ' + personObject.personsStats.chuncksCompletedDay)

	@makeActivityActive: (activityId) ->
		$('ul#activity-list > #' + activityId).addClass('active-item')

	@showActivitiesList: (sortedList) ->
		$('ul#activity-list').empty()
		for activityId in sortedList
			activity = Breeze.Activities.Model.getActivityById(activityId)
			activityDuration = activity.duration
			listItem = '<li id="' + activity.id + '" class="activity-list-item" data-activity_index="' + _i + '">'
			listItem += '<div class="activity-duration-' + activity.durationType + '">&nbsp;</div>'
			listItem += '<span class="activity-title">' + activity.text + '</span>'
			listItem += '<div class="activity-reorder">&Ecirc;</div>'
			listItem += '<button id="' + activity.id + '" class="activity-edit">Edit</button>'
			listItem += '<button id="' + activity.id + '" class="activity-start">Play</button>'
			listItem += '</li>'
			$('ul#activity-list').append($(listItem))
		Breeze.Views.hideActivityButtons()

	@addToActivitiesList: (sortedList) ->
		Breeze.Views.showActivitiesList(sortedList)

	@updateActivitiesList: (sortedList) ->
		Breeze.Views.showActivitiesList(sortedList)

	@removeActivity: (activityId) ->
		$('ul#activity-list > #' + activityId).remove()

	@showActivityButton: (activityId) ->
		$('#' + activityId + '.activity-start').show()
		$('#' + activityId + '.activity-edit').show()

	@hideActivityButtons: () ->
		$('.activity-start').hide()
		$('.activity-edit').hide()
