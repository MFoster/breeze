class Breeze.Timers
	# Internal Status Variables
	_init = false
	playlistTimers = {}
	activityTimers = {}
	expectedEvents = {}
	eventLoopInterval = 5

	# Internal Constants
	seconds = 1000
	minutes = 60
	hours = 60
	days = 24
	weeks = 7
	months = 30
	years = 365

	constructor: (@attributes) ->
		if !_init
			registeredEventLoop = setInterval( ->
				loopingTimerTasks()
			, eventLoopInterval * seconds)
			_init = true
			return Breeze.Timers.statusReport()
		else
			Breeze.DebugCenter.message('Timers class was already initialized.', 'caution')

	@statusReport: () ->
		reportData = {
			_init: _init
			playlistTimers: playlistTimers
			activityTimers: activityTimers
			expectedEvents: expectedEvents
			eventLoopInterval: eventLoopInterval
			CONSTANTS: {
				seconds: seconds
				minutes: minutes
				hours: hours
				days: days
				weeks: weeks
				months: months
				years: years
			}
		}
		return reportData

	playlistTimerTasks = (playlist) ->
		if playlist
			playlistTimers[playlist].elapsedTime += seconds

	activityTimerTasks = (activity) ->
		if activity
			activityTimers[activity].elapsedTime += seconds
			activityTimers[activity].remainingTime -= seconds
			Breeze.Views.placeProgressMarker(activityTimers[activity].elapsedTime/activityTimers[activity].totalTime)
			$('#activity-minutes-remaining').html(convertToMinutes(activityTimers[activity].remainingTime, 'milliseconds') + 'min')

	activityTimerExpiredTasks = (activity) ->
		Breeze.Timers.pauseActivityTimer(activity)
		Breeze.Views.showPrompt('Time is up on: ' + activity + '.', [
			['Complete', "Breeze.Activities.completeActivity('" + activity + "');"]
			['Rewind', "Breeze.Activities.rewindActivity('" + activity + "');"]
			['Add Time', "Breeze.Activities.addTimeToActivity('" + activity + "');"]
		])

	loopingTimerTasks = () ->
		nowTime = getCurrentTime()
		Breeze.Views.updateDebugView()
		# TODO: Check Timer accuracy
		# TODO: activate/deactivate looper based on number of events
		for eventId, eventData of expectedEvents
			if eventData.atFireTime < nowTime
				eventData.onFireCall()
				Breeze.Timers.deRegisterEvent(eventId)

	getCurrentTime = () ->
		return new Date().getTime()

	@registerEvent: (eventObject = {}) ->
		nowTime = getCurrentTime()
		eventDefaults = {
			id: nowTime
			fireAt: ['1', 'minutes']
			fireCall: ->
				Breeze.DebugCenter.message('Event Fire with NO Message', 'caution')
		}
		for property, value of eventDefaults
			if eventObject.hasOwnProperty(property)
				eventDefaults[property] = eventObject[property]
		expectedEvents[eventDefaults.id] = {
			atFireTime: convertToMillisecondTime(nowTime, eventDefaults.fireAt, 'milliseconds')
			onFireCall: eventDefaults.fireCall
		}
		return eventDefaults.id

	@deRegisterEvent: (eventObjectId) ->
		delete expectedEvents[eventObjectId]

	@startPlaylistTimer: (playlist) ->
		nowTime = getCurrentTime()
		if not playlistTimers.hasOwnProperty(playlist)
			playlistTimers[playlist] = {
				startTime: nowTime
				elapsedTime: 0
				timer: setInterval( ->
					playlistTimerTasks(playlist)
				, seconds)
			}
		else
			playlistTimers[playlist].timer = setInterval( ->
				playlistTimerTasks(playlist)
			, seconds)
		return playlistTimers[playlist]

	@pausePlaylistTimer: (playlist) ->
		clearInterval(playlistTimers[playlist].timer)
		return playlistTimers[playlist]

	@stopPlaylistTimer: (playlist) ->
		clearInterval(playlistTimers[playlist].timer)
		$('#playlist-time').html(0)
		delete playlistTimers[playlist]
		return playlistTimers

	@startActivityTimer: (activity, duration) ->
		nowTime = getCurrentTime()
		if not activityTimers.hasOwnProperty(activity)
			registerEvent = Breeze.Timers.registerEvent({
				fireAt: duration
				fireCall: -> activityTimerExpiredTasks(activity)
			})
			activityTimers[activity] = {
				startTime: nowTime
				totalTime: duration
				registeredEvent: registerEvent
				expectedStopTime: nowTime + duration
				elapsedTime: 0
				remainingTime: duration
				timer: setInterval( ->
					activityTimerTasks(activity)
				, seconds)
			}
		else
			remainingTime = activityTimers[activity].remainingTime
			registerEvent = Breeze.Timers.registerEvent({
				fireAt: remainingTime
				fireCall: -> activityTimerExpiredTasks(activity)
			})
			activityTimers[activity].registeredEvent = registerEvent
			activityTimers[activity].expectedStopTime = nowTime + remainingTime
			activityTimers[activity].timer = setInterval( ->
				activityTimerTasks(activity)
			, seconds)

	@pauseActivityTimer: (activity) ->
		delete expectedEvents[activityTimers[activity].registeredEvent]
		clearInterval(activityTimers[activity].timer)
		return activityTimers[activity]

	@stopActivityTimer: (activity) ->
		delete expectedEvents[activityTimers[activity].registeredEvent]
		clearInterval(activityTimers[activity].timer)
		$('#activity-time').html(0)
		delete activityTimers[activity]
		return activityTimers

	@convertStringToDate: (string) ->
		return new Date(string)

	@convertMinutesToMilliseconds: (quantity) ->
		return convertToMilliseconds(quantity, 'minutes')

	@convertMillisecondToString: (milliseconds) ->
		return new Date(milliseconds)

	@convertMillisecondToUTC: (milliseconds) ->
		return new Date(milliseconds).toISOString();

	@addTimeToMillisecondTime: (start, quantity, type) ->
		return convertToMillisecondTime(start, quantity, type)

	@addTimeToStringTime: (string, quantity, type) ->
		startTime = Breeze.Timers.convertStringToDate(string)
		newTime = convertToMillisecondTime(startTime, quantity, type)
		return convertMillisecondToString(newTime)

	convertToMillisecondTime = (start, quantity, type) ->
		switch type
			when 'milliseconds' then return start + quantity
			when 'seconds' then return start + (quantity * seconds)
			when 'minutes' then return start + (quantity * seconds * minutes)
			when 'hours' then return start + (quantity * seconds * minutes * hours)
			when 'days' then return start + (quantity * seconds * minutes * hours * days)
			when 'weeks' then return start + (quantity * seconds * minutes * hours * days * weeks)
			when 'months' then return start + (quantity * seconds * minutes * hours * days * months)
			when 'years' then return start + (quantity * seconds * minutes * hours * days * years)
			else return false

	convertToMilliseconds = (quantity, type) ->
		switch type
			when 'milliseconds' then return quantity
			when 'seconds' then return quantity * seconds
			when 'minutes' then return quantity * seconds * minutes
			when 'hours' then return quantity * seconds * minutes * hours
			else return false

	convertToSeconds = (quantity, type) ->
		switch type
			when 'milliseconds' then return Math.round(quantity / seconds)
			when 'seconds' then return quantity
			when 'minutes' then return quantity * minutes
			when 'hours' then return quantity * minutes * hours
			else return false

	convertToMinutes = (quantity, type) ->
		switch type
			when 'milliseconds' then return Math.round((quantity / seconds) / minutes)
			when 'seconds' then return Math.round(quantity / minutes)
			when 'minutes' then return quantity
			when 'hours' then return quantity * hours
			else return false