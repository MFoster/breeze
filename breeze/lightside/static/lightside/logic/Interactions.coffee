class Breeze.Interactions
	# Interactions internal variables
	_init = false
	bindingsActive = false

	constructor: (@attributes) ->
		if !_init
			bindingsActive = activateBindings()
			if bindingsActive
				_init = true
				return Breeze.Interactions.statusReport()
			else
				Breeze.DebugCenter.message('Interaction bindings failed.', 'error')
				return false
		else
			Breeze.DebugCenter.message('Interactions class was already initialized.', 'caution')
			return false

	@statusReport: () ->
		reportData = {
			_init: _init
			bindingsActive: bindingsActive
		}
		return reportData

	activateBindings = () ->
		$(document).on('click', '#activity-list-debug-toggle', -> Breeze.Views.toggleDebugView())
		$(document).on('click', '#activity-control-rewind', -> Breeze.Activities.rewindActivity())
		$(document).on('click', '#activity-control-pause', -> Breeze.Activities.pausePlaylist())
		$(document).on('click', '#activity-control-complete', -> Breeze.Activities.completeActivity())
		$(document).on('click', '#activity-control-playlists', -> Breeze.Activities.selectPlaylist())
		$(document).on('click', '#activity-control-play', -> Breeze.Activities.startPlaylist())
		$(document).on('click', '#activity-control-stop', -> Breeze.Activities.stopPlaylist())
		$(document).on('click', '#activity-add-edit-open', -> Breeze.Views.showAddEditForm())
		$(document).on('click', '#activity-add-edit-close', -> Breeze.Views.hideAddEditForm())
		return true

	@displayPersonPrompt: (type, activity = {}) ->
		promptProccessed = false
		switch type
			when 'selectPlaylist' then promptProccessed = promptSelectPlaylist()
			when 'startActivity' then promptProccessed = promptStartActivity(activity)
			when 'stopPlaylist' then promptProccessed = promptStopPlaylist()
			when 'addTime' then promptProccessed = promptAddTime(activity)
			when 'snoozeTime' then promptProccessed = promptSnoozeTime(activity)
			when 'rewindTime' then promptProccessed = promptRewindTime(activity)
			when 'completeActivity' then promptProccessed = promptCompleteActivity(activity)
			else return false
		return promptProccessed

	promptSelectPlaylist = () ->
		promptControls = []
		personsPlaylists = Breeze.People.getPersonsPlaylists()
		for playlist in personsPlaylists
			playlistControl = {
				label: playlist
				action: "Breeze.Activities.selectPlaylist('" + playlist + "');"
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

	promptRewindTime = (activity) ->
		promptObject =
			prompt: 'How long doy you need to rewind for'
			message: ''
			controls: [
				{ label: '5 Minutes', action: "Breeze.Activities.setRewind('" + activity.id + "', 5, 'minutes');" }
				{ label: '15 Minutes', action: "Breeze.Activities.setRewind('" + activity.id + "', 15, 'minutes');" }
				{ label: '1 Hour', action: "Breeze.Activities.setRewind('" + activity.id + "', 1, 'hours');" }
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
				{ label: 'Rewind Time', action: "Breeze.Activities.rewindActivity('" + activity.id + "');" }
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