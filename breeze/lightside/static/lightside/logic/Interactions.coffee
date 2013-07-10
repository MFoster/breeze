class Breeze.Interactions
	# Interactions internal variables
	_init = false
	bindingsActive = false
	useStandardChunck = true
	currentCustomChunck = 0
	currentAvailableDateTime = new Date().getTime()
	currentDueDateTime = new Date().getTime()
	defaultDueDateTimeWeeks = 2

	constructor: (@attributes) ->
		if !_init
			Breeze.Interactions.initActivityForm()
			bindingsActive = activateBindings()
			keyBindingsActive = activateKeyBindings()
			if bindingsActive and keyBindingsActive
				_init = true
				return Breeze.Interactions.statusReport()
			else
				Breeze.DebugCenter.message('Interaction bindings failed.', 'error')
				return false
		else
			Breeze.DebugCenter.message('Interactions class was already initialized.', 'caution')
			return false

	@statusReport: () ->
		_init: _init
		bindingsActive: bindingsActive
		useStandardChunck: useStandardChunck
		currentCustomChunck: currentCustomChunck
		currentAvailableDateTime: currentAvailableDateTime
		currentDueDateTime: currentDueDateTime
		defaultDueDateTimeWeeks: defaultDueDateTimeWeeks

	activateBindings = () ->
		$(document).on('click', '#activity-list-debug-toggle', -> Breeze.Views.toggleDebugView())
		$(document).on('click', '#activity-control-rewind', -> Breeze.Activities.rewindPlaylist())
		$(document).on('click', '#activity-control-pause', -> Breeze.Activities.pausePlaylist())
		$(document).on('click', '#activity-control-complete', -> Breeze.Activities.completeActivity())
		$(document).on('click', '#activity-control-playlists', -> Breeze.Activities.selectPlaylist())
		$(document).on('click', '#activity-control-play', -> Breeze.Activities.startPlaylist())
		$(document).on('click', '#activity-control-stop', -> Breeze.Activities.stopPlaylist())
		$(document).on('click', '#activity-add-edit-control', -> Breeze.Views.toggleAddEditForm())
		$(document).on('click', '.activity-list-item', -> Breeze.Views.showActivityButton($(this).attr('id')))
		$(document).on('click', 'button.activity-start', -> Breeze.Activities.manualStartActivity($(this).attr('id')))
		$(document).on('click', 'button#activity-submit-accept', (event) ->
			event.preventDefault()
			Breeze.Interactions.processActivityFormSubmit()
		)
		$(document).on('click', 'button#activity-submit-decline', (event) ->
			event.preventDefault()
			Breeze.Views.resetAddEditForm()
			Breeze.Views.hideAddEditForm()
		)
		return true

	activateKeyBindings = () ->
		$('body').keypress((event) ->
			code = event.keyCode || event.which
			console.log(code)
			if code is 13 and event.shiftKey
				Breeze.Views.cycleVisible()
		)

	@processActivityFormSubmit: () ->
		formValues = {}
		$('#activity-form :input').each( ->
			formValues[$(this).attr('name')] = $(this).val()
		)
		validatedData = Breeze.Activities.Model.validateActivityData(formValues)
		if validatedData.hasOwnProperty('error')
			# Display Validation Errors
		else
			currentPlaylist = Breeze.Activities.statusReport().currentPlaylist.id
			saveData = Breeze.Activities.Model.addActivity(currentPlaylist, validatedData)
			if saveData
				Breeze.Views.resetAddEditForm()
				Breeze.Views.hideAddEditForm()
			else
				Breeze.DebugCenter.message('Form save failed.', 'error')

	@displayPersonPrompt: (type, activity = {}) ->
		promptProccessed = false
		switch type
			when 'selectPlaylist' then promptProccessed = promptSelectPlaylist()
			when 'startActivity' then promptProccessed = promptStartActivity(activity)
			when 'stopPlaylist' then promptProccessed = promptStopPlaylist()
			when 'addTime' then promptProccessed = promptAddTime(activity)
			when 'snoozeTime' then promptProccessed = promptSnoozeTime(activity)
			when 'rewindTime' then promptProccessed = promptRewindTime()
			when 'completeActivity' then promptProccessed = promptCompleteActivity(activity)
			else return false
		return promptProccessed

	@initActivityForm: () ->
		personsPreferences = Breeze.People.getPersonsPreferences()
		chunckTimeLarge = personsPreferences.chunckTimeLarge
		chunckTimeMedium = personsPreferences.chunckTimeMedium
		chunckTimeSmall = personsPreferences.chunckTimeSmall
		currentFormDateTime = Breeze.Timers.getTime()
		$('#activity-duration-large').data('duration', chunckTimeLarge).html(chunckTimeLarge + 'min')
		$('#activity-duration-medium').data('duration', chunckTimeMedium).html(chunckTimeMedium + 'min')
		$('#activity-duration-small').data('duration', chunckTimeSmall).html(chunckTimeSmall + 'min')
		$('#activity-duration-display').html(chunckTimeMedium + 'min')
		$('#activity-duration-reset').hide()
		$('#activity-duration').hide()
		Breeze.Views.hideAllDateTimeControls()
		$('#activity-available-datetime').hide()
		$('#activity-due-datetime').hide()
		$(document).on('click', '.duration-select', (event) ->
			event.preventDefault()
			amount = $(this).data('duration')
			Breeze.Interactions.adjustFormDuration(amount)
		)
		$(document).on('click', '#activity-duration-custom', (event) ->
			event.preventDefault()
			$('#activity-duration-custom').hide()
			$('#activity-duration-reset').show()
			useStandardChunck = false
		)
		$(document).on('click', '#activity-duration-reset', (event) ->
			event.preventDefault()
			$('#activity-duration-reset').hide()
			$('#activity-duration-custom').show()
			useStandardChunck = true
			Breeze.Interactions.adjustFormDuration(chunckTimeMedium)
		)
		$(document).on('click', '#activity-available-date-selected', -> Breeze.Views.toggleAvailableDateControls())
		$(document).on('click', '#activity-available-time-selected', -> Breeze.Views.toggleAvailableTimeControls())
		$(document).on('click', '#activity-due-date-selected', -> Breeze.Views.toggleDueDateControls())
		$(document).on('click', '#activity-due-time-selected', -> Breeze.Views.toggleDueTimeControls())
		$(document).on('click', '.date-time-column-plus, .date-time-column-minus', (event) ->
			event.preventDefault()
			targetField = $(this).data('targetfield')
			amount = $(this).data('amount')
			type = $(this).data('type')
			Breeze.Interactions.adjustFormDateTime(targetField, amount, type)
		)
		Breeze.Views.hideAddEditForm()
		Breeze.Views.resetAddEditForm()
		Breeze.Interactions.adjustFormDateTime('available')

	@adjustFormDuration: (amount) ->
		if useStandardChunck
			currentCustomChunck = amount
			Breeze.Views.updateFormDuration(amount)
		else
			currentCustomChunck += amount
			Breeze.Views.updateFormDuration(currentCustomChunck)

	@adjustFormDateTime: (targetField, amount = 0, type = 'none') ->
		currentFormDateTime = currentAvailableDateTime
		if targetField is 'due' then currentFormDateTime = currentDueDateTime
		seconds = 1000
		minutes = 60
		hours = 60
		days = 24
		weeks = 7
		switch type
			when 'none' then currentFormDateTime = currentFormDateTime
			when 'second' then currentFormDateTime += amount * seconds
			when 'minute' then currentFormDateTime += amount * minutes * seconds
			when 'hour' then currentFormDateTime += amount * hours * minutes * seconds
			when 'day' then currentFormDateTime += amount * days * hours * minutes * seconds
			when 'week' then currentFormDateTime += amount * weeks * days * hours * minutes * seconds
		if targetField is 'available'
			currentAvailableDateTime = currentFormDateTime
			currentDueDateTime = currentFormDateTime
			Breeze.Interactions.adjustFormDateTime('due', 2, 'week')
		if targetField is 'due' then currentDueDateTime = currentFormDateTime
		adjustedDate = new Date(currentFormDateTime)
		formYear = adjustedDate.getFullYear()
		formMonth = adjustedDate.getMonth() + 1
		displayMonth = switch adjustedDate.getMonth()
			when 0 then 'Jan'
			when 1 then 'Feb'
			when 2 then 'Mar'
			when 3 then 'Apr'
			when 4 then 'May'
			when 5 then 'Jun'
			when 6 then 'Jul'
			when 7 then 'Aug'
			when 8 then 'Sep'
			when 9 then 'Oct'
			when 10 then 'Nov'
			else 'Dec'
		formMonth = ('0' + formMonth).slice(-2)
		formDay = adjustedDate.getDate()
		displayDay = formDay
		formDay = ('0' + formDay).slice(-2)
		displayWeekday = switch adjustedDate.getDay()
			when 0 then 'Sunday'
			when 1 then 'Monday'
			when 2 then 'Tuesday'
			when 3 then 'Wednesday'
			when 4 then 'Thursday'
			when 5 then 'Friday'
			else 'Saturday'
		formHours = adjustedDate.getHours()
		formMinutes = adjustedDate.getMinutes()
		formMinutes = formMinutes + (15 - formMinutes%15)
		if formMinutes is 60
			formMinutes = 0
			formHours = if formHours is 23 then 0 else formHours += 1
		formMinutes = ('0' + formMinutes).slice(-2)
		formAmPm = 'AM'
		if formHours >= 12
			formAmPm = 'PM'
			formHours %= 12
		if formHours is 0 then formHours = 12
		displayHours = formHours
		displayAmPm = formAmPm.toLowerCase()
		formHours = ('0' + formHours).slice(-2)
		formDate = formYear + '-' + formMonth + '-' + formDay
		formTime = formHours + ':' + formMinutes + ' ' + formAmPm
		displayDate = displayWeekday + ' ' + displayMonth + ' ' + displayDay + ', ' + formYear
		displayTime = displayHours + ':' + formMinutes + displayAmPm
		Breeze.Views.updateFormDateTime(targetField, formDate, formTime, displayDate, displayTime)
		return displayDate + ' ' + displayTime

	promptSelectPlaylist = () ->
		promptControls = []
		personsPlaylists = Breeze.People.getPersonsPlaylists()
		for playlist in personsPlaylists
			playlistControl = {
				label: playlist.name
				action: "Breeze.Activities.setSelectedPlaylist('" + playlist.id + "');"
			}
			promptControls.push(playlistControl)
		promptObject =
			prompt: 'Select Desired Playlist'
			message: ''
			controls: promptControls
		promptProccessed = createPrompt(promptObject)
		if promptProccessed then Breeze.DebugCenter.message('Display Select Playlist Prompt.')
		return promptProccessed

	promptStartActivity = (activity) ->
		promptObject =
			prompt: 'Would you like to Start'
			message: activity.text
			controls: [
				{ label: 'Accept', action: "Breeze.Activities.startActivity('" + activity.id + "');" }
				{ label: 'Snooze', action: "Breeze.Activities.snoozeActivity('" + activity.id + "');" }
			]
		promptProccessed = createPrompt(promptObject)
		if promptProccessed then Breeze.DebugCenter.message('Display Start Activity Prompt.')
		return promptProccessed

	promptStopPlaylist = (activity) ->
		promptObject =
			prompt: 'Finished for now?'
			message: ''
			controls: [
				{ label: 'Yes', action: "Action"}
				{ label: 'Not yet', action: "Action"}
			]
		promptProccessed = createPrompt(promptObject)
		if promptProccessed then Breeze.DebugCenter.message('Display Stop Playlist Prompt.')
		return promptProccessed

	promptAddTime = (activity) ->
		personsPreferences = Breeze.People.getPersonsPreferences()
		smallChunck = personsPreferences.chunckTimeSmall
		mediumChunck = personsPreferences.chunckTimeMedium
		largeChunck = personsPreferences.chunckTimeLarge
		promptObject =
			prompt: 'How much time would you like to add to'
			message: activity.text
			controls: [
				{
					label: smallChunck + ' Minutes'
					action: "Breeze.Activities.setAddTimeToActivity('" + activity.id + "', " + smallChunck + ", 'minutes');"
				}
				{
					label: mediumChunck + ' Minutes'
					action: "Breeze.Activities.setAddTimeToActivity('" + activity.id + "', " + mediumChunck + ", 'minutes');"
				}
				{
					label: largeChunck + ' Minutes'
					action: "Breeze.Activities.setAddTimeToActivity('" + activity.id + "', " + largeChunck + ", 'minutes');"
				}
			]
		promptProccessed = createPrompt(promptObject)
		if promptProccessed then Breeze.DebugCenter.message('Display Add Time Prompt.')
		return promptProccessed

	promptSnoozeTime = (activity) ->
		promptObject =
			prompt: 'How long would you like to snooze'
			message: activity.text
			controls: [
				{ label: '1 Hour', action: "Breeze.Activities.setSnoozeOnActivity('" + activity.id + "', 1, 'hours');" }
				{ label: '1 Day', action: "Breeze.Activities.setSnoozeOnActivity('" + activity.id + "', 1, 'days');" }
				{ label: '1 Week', action: "Breeze.Activities.setSnoozeOnActivity('" + activity.id + "', 1, 'weeks');" }
			]
		promptProccessed = createPrompt(promptObject)
		if promptProccessed then Breeze.DebugCenter.message('Display Snooze Time Prompt.')
		return promptProccessed

	promptRewindTime = () ->
		promptObject =
			prompt: 'How long doy you need to rewind for'
			message: ''
			controls: [
				{ label: '5 Minutes', action: "Breeze.Activities.setPlaylistRewind(5, 'minutes');" }
				{ label: '15 Minutes', action: "Breeze.Activities.setPlaylistRewind(15, 'minutes');" }
				{ label: '1 Hour', action: "Breeze.Activities.setPlaylistRewind(1, 'hours');" }
			]
		promptProccessed = createPrompt(promptObject)
		if promptProccessed then Breeze.DebugCenter.message('Display Rewind Time Prompt.')
		return promptProccessed

	promptCompleteActivity = (activity) ->
		promptObject =
			prompt: 'Done with'
			message: activity.text
			controls: [
				{ label: 'Yes', action: "Breeze.Activities.setCompleteOnActivity('" + activity.id + "');" }
				{ label: 'Add Time', action: "Breeze.Activities.addTimeToActivity('" + activity.id + "');" }
				{ label: 'Rewind Time', action: "Breeze.Activities.rewindPlaylist('" + activity.id + "');" }
			]
		promptProccessed = createPrompt(promptObject)
		if promptProccessed then Breeze.DebugCenter.message('Display Complete Activity Prompt.')
		return promptProccessed

	createPrompt = (promptObject) ->
		objectHasPrompt = promptObject.hasOwnProperty('prompt')
		objectHasMessage = promptObject.hasOwnProperty('message')
		objectHasControls = if promptObject.hasOwnProperty('controls') and promptObject.controls.length > 0 then true else false
		if objectHasPrompt and objectHasMessage and objectHasControls
			Breeze.Views.buildPromptBox(promptObject.prompt, promptObject.message, promptObject.controls)
		else
			Breeze.DebugCenter.message('Missing property or controls when creating prompt.', 'error')
			return false