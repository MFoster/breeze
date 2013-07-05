class Breeze.Views
	# View Status Variables
	_init = false
	pauseControllsVisible = false
	addEditForm = "form not loaded"
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
		$(document).on('click', '#activity-list-debug-toggle', -> $('#activity-list-debug-info').toggle())
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
			bindingsActive: bindingsActive
		}
		return reportData

	@showPauseControlls: () ->
		$('#activity-control-left').html('<span id="activity-control-rewind">Rewind</span>')
		$('#activity-control-center').html('<span id="activity-control-pause">Pause</span>')
		$('#activity-control-right').html('<span id="activity-control-complete">Complete</span>')
		pauseControllsVisible = true

	@showPlayControlls: () ->
		$('#activity-control-left').html('<span id="activity-control-playlists">Playlists</span>')
		$('#activity-control-center').html('<span id="activity-control-play">Play</span>')
		$('#activity-control-right').html('<span id="activity-control-stop">Stop</span>')
		pauseControllsVisible = false

	@togglePlayPauseControlls: () ->
		if pauseControllsVisible
			Breeze.Views.showPlayControlls()
		else
			Breeze.Views.showPauseControlls()
		pauseControllsVisible != pauseControllsVisible

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

	@showActivitiesList: (activityList) ->
		$('ul#activity-list').empty()
		for activity in activityList
			activityDuration = activity.duration
			if activityDuration not in ['large', 'medium', 'small']
				activityDuration = 'custom'
			listItem = '<li id="' + activity.id + '" class="activity-list-item" data-activity_index="' + _i + '">'
			listItem += '<div class="activity-duration-' + activityDuration + '">&nbsp;</div>'
			listItem += '<span class="activity-title">' + activity.text + '</span>'
			listItem += '<div class="activity-reorder">&Ecirc;</div>'
			listItem += '</li>'
			$('ul#activity-list').append($(listItem))

	@addToActivitiesList: (activityList) ->
		Breeze.Views.showActivitiesList(activityList)

	@removeActivity: (activityId) ->
		$('ul#activity-list > #' + activityId).remove()
