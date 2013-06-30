class Breeze.Views
	# View Status Variables
	pauseControllsVisible = false
	addEditForm = "form not loaded"

	constructor: (@attributes) ->
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
			pauseControllsVisible: pauseControllsVisible
			addEditForm: addEditForm
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