class Breeze.Timers
	# Internal Status Variables
	playlistTimers = {}
	activityTimers = {}
	expectedEvents = {}

	# Internal Constanst
	seconds = 1000
	minutes = 60
	hours = 60
	days = 24
	weeks = 7
	months = 30
	years = 365

	# REMOVE
	runningTimers = {}

	constructor: (@attributes) ->
		registeredEventLoop = setInterval( ->
			loopingTimerTasks()
		, 5 * seconds)

	@statusReport: () ->
		reportObject = {
			playlistTimers: playlistTimers
			activityTimers: activityTimers
			expectedEvents: expectedEvents
		}
		return reportObject

	playlistTimerTasks = (playlist) ->
		if playlist
			playlistTimers[playlist].elapsedTimeSeconds++
			$('#playlist-time').html(playlistTimers[playlist].elapsedTimeSeconds)

	activityTimerTasks = (activity) ->
		if activity
			if activityTimers[activity].remainingTimeSeconds > 0
				activityTimers[activity].elapsedTimeSeconds++
				activityTimers[activity].remainingTimeSeconds--
				$('#activity-time').html('Total: ' + activityTimers[activity].totalTime + ' sec - Elapsed: ' + activityTimers[activity].elapsedTimeSeconds + ' sec - Remaining: ' + activityTimers[activity].remainingTimeSeconds + ' sec')
				Breeze.Views.placeProgressMarker(activityTimers[activity].elapsedTimeSeconds/activityTimers[activity].totalTime)
			else
				Breeze.Timers.pauseActivityTimer(activity)

	loopingTimerTasks = () ->
		nowTime = new Date().getTime()
		# TODO: Check Timer accuracy
		# TODO: activate/deactivate looper based on number of events
		for eventId, eventData of expectedEvents
			if eventData.atFireTime < nowTime
				eventData.onFireCall()
				Breeze.Timers.deRegisterEvent(eventId)

	@registerEvent: (eventObject = {}) ->
		nowTime = new Date().getTime()
		eventDefaults = {
			id: nowTime
			fireAt: ['1', 'minutes']
			fireCall: ->
				console.log('default function')
		}
		for property, value of eventDefaults
			if eventObject.hasOwnProperty(property)
				eventDefaults[property] = eventObject[property]
		expectedEvents[eventDefaults.id] = {
			atFireTime: convertToMillisecondTime(nowTime, eventDefaults.fireAt[0], eventDefaults.fireAt[1])
			onFireCall: eventDefaults.fireCall
		}
		return eventDefaults.id

	@deRegisterEvent: (eventObjectId) ->
		delete expectedEvents[eventObjectId]

	@startPlaylistTimer: (playlist) ->
		nowTime = new Date().getTime()
		if not playlistTimers.hasOwnProperty(playlist)
			playlistTimers[playlist] = {
				startTime: nowTime
				elapsedTimeSeconds: 0
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

	@startActivityTimer: (activity, rawTimeLength = ['5', 'minutes']) ->
		nowTime = new Date().getTime()
		convertedTimeLength = convertToSeconds(rawTimeLength[0], rawTimeLength[1])
		Breeze.Timers.registerEvent({
			fireAt: rawTimeLength
			fireCall: ->
				console.log(activity + ' has run out of time')
		})
		if not activityTimers.hasOwnProperty(activity)
			activityTimers[activity] = {
				startTime: nowTime
				totalTime: convertedTimeLength
				expectedStopTime: nowTime + convertToMilliseconds(convertedTimeLength)
				elapsedTimeSeconds: 0
				remainingTimeSeconds: convertedTimeLength
				timer: setInterval( ->
					activityTimerTasks(activity)
				, seconds)
			}
		else
			activityTimers[activity].timer = setInterval( ->
				activityTimerTasks(activity)
			, seconds)

	@pauseActivityTimer: (activity) ->
		clearInterval(activityTimers[activity].timer)
		return activityTimers[activity]

	@stopActivityTimer: (activity) ->
		clearInterval(activityTimers[activity].timer)
		$('#activity-time').html(0)
		delete activityTimers[activity]
		return activityTimers

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
			when 'milliseconds' then return Math.round((quantity / 1000) / 60)
			when 'seconds' then return Math.round(quantity / 60)
			else return false