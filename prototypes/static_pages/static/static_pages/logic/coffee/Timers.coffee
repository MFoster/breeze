class Breeze.Timers

	runningTimers = {}

	constructor: (@attributes) ->
		return true

	@statusReport: () ->
		reportObject = {
			runningTimers: runningTimers
		}

	@statusReport: () ->
		reportObject = {
			runningTimers: runningTimers
		}

	@startUpTimer: (timerID) ->
		nowSecondsStart = convertToSeconds(new Date().getTime(), 'milliseconds')
		runningTimers[timerID] = {
			startTime: nowSecondsStart
			currentTime: remainingTime
			timer: setInterval( ->
				runningTimers[timerID].currentTime++
			, 1000)
		}

	@startDownTimer: (timerID, remainingTime) ->
		nowSecondsStart = convertToSeconds(new Date().getTime(), 'milliseconds')
		runningTimers[timerID] = {
			startTime: nowSecondsStart
			expectedStopTime: nowSecondsStart + remainingTime
			totalTime: remainingTime
			currentTime: remainingTime
			timer: setInterval( ->
				if runningTimers[timerID].currentTime > 0
					runningTimers[timerID].currentTime--
				else
					Breeze.Timers.stopDownTimer(timerID)
				$('#' + timerID + '-time').html(runningTimers[timerID].currentTime)
			, 1000)
		}

	@stopDownTimer: (timerID) ->
		clearInterval(runningTimers[timerID].timer)
		nowSecondsStop = convertToSeconds(new Date().getTime(), 'milliseconds')
		timeElapsedTimer = runningTimers[timerID].totalTime - runningTimers[timerID].currentTime
		timeElapsedReal = runningTimers[timerID].expectedStopTime - nowSecondsStop
		timeRemaining = timeElapsedReal - timeElapsedTimer
		console.log('Remaining Time: ' + timeRemaining + ' on ' + timerID + ' after ' + timeElapsedTimer + 'seconds.')

	convertToSeconds = (quantity, type) ->
		switch type
			when 'milliseconds' then return Math.round(quantity / 1000)
			when 'minutes' then return quantity * 60
			else return false

	convertToMinutes = (quantity, type) ->
		switch type
			when 'milliseconds' then return Math.round((quantity / 1000) / 60)
			when 'seconds' then return Math.round(quantity / 60)
			else return false