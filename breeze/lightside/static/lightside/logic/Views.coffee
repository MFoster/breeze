class Breeze.Views
	# View Status Variables
	_init = false
	pauseControllsVisible = false
	addEditForm = "form not loaded"
	debugVisible = false
	bindingsActive = false

	constructor: (@attributes) ->
		if !_init
			$('#activity-list-debug-info').hide()
			$('#activity-prompt').hide()
			bindingsActive = activateBindings()
			Breeze.Views.showPlayControlls()
			_init = true
			return Breeze.Views.statusReport()
		else
			Breeze.DebugCenter.message('Views class was already initialized.', 'caution')

	activateBindings = () ->
		$(document).on('click', '#activity-list-debug-toggle', -> Breeze.Views.toggleDebugView())
		$(document).on('click', '#activity-control-rewind', -> Breeze.Activities.rewindActivity())
		$(document).on('click', '#activity-control-pause', -> Breeze.Activities.pausePlaylist())
		$(document).on('click', '#activity-control-complete', -> Breeze.Activities.completeActivity())
		$(document).on('click', '#activity-control-playlists', -> Breeze.Activities.selectPlaylist())
		$(document).on('click', '#activity-control-play', -> Breeze.Activities.startPlaylist())
		$(document).on('click', '#activity-control-stop', -> Breeze.Activities.stopPlaylist())
		$(document).on('click', '#activity-add-edit-open', -> Breeze.Views.showAddEditForm())
		Breeze.Views.showPlayControlls()
		return true

	@statusReport: () ->
		reportData = {
			_init: _init
			pauseControllsVisible: pauseControllsVisible
			addEditForm: addEditForm
			debugVisible: debugVisible
			bindingsActive: bindingsActive
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
			currentActivityData = Breeze.Activities.Model.getActivityById(activityStatus.currentActivityId)
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
		$.get "task_form_proto", (data) ->
			addEditForm = data
			$('#add-edit-form-container').html(addEditForm).show()
			addEditFormVisible = true

	@showPrompt: (message = 'Message Missing', controls = [['No Control', "Breeze.DebugCenter.message('Missing Function', 'caution')"]]) ->
		$('#activity-prompt-message').html(message)
		$('#activity-prompt-controlls').html( ->
			returnHtml = ''
			for control in controls
				returnHtml += '<button class="button-base" onclick="' + control[1] + '">' + control[0] + '</button>'
			return returnHtml
		)
		$('#activity-prompt').show()

	@hidePrompt: () ->
		$('#activity-prompt').hide()

	@placeProgressMarker: (percentage) ->
		# Angle negative for clockwise rotation
		angle = 2 * Math.PI * (-percentage)
		# Minus from center for 12 o'clock starting position
		xPos = 153 - 151 * Math.cos(angle)
		yPos = 155 - 151 * Math.sin(angle)
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
			listItem += '</li>'
			$('ul#activity-list').append($(listItem))

	@addToActivitiesList: (sortedList) ->
		Breeze.Views.showActivitiesList(sortedList)

	@removeActivity: (activityId) ->
		$('ul#activity-list > #' + activityId).remove()
