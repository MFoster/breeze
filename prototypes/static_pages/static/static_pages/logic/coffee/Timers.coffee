class Breeze.Timers

	runningTimers = {}

	constructor: (@attributes) ->
		return true

	@statusReport: () ->
		reportObject = {
			runningTimers: runningTimers
		}

	@startTimer: (timerID, remainingTime) ->
		nowSecondsStart = Math.round(new Date().getTime() / 1000)
		runningTimers[timerID] = {
			startTime: nowSecondsStart
			startCountdownTime: remainingTime
			currentCountdownTime: remainingTime
			timer: setInterval( ->
				if runningTimers[timerID].currentCountdownTime > 0
					runningTimers[timerID].currentCountdownTime--
				else
					Breeze.Timers.stopTimer(timerID)
				$('#' + timerID + '-time').html(runningTimers[timerID].currentCountdownTime)
			, 1000)
		}

	@stopTimer: (timerID) ->
		clearInterval(runningTimers[timerID].timer)
		nowSecondsStop = Math.round(new Date().getTime() / 1000)
		timeElapsed = runningTimers[timerID].startCountdownTime - runningTimers[timerID].currentCountdownTime
		timeDifference = (nowSecondsStop - runningTimers[timerID].startTime) - timeElapsed
		console.log('Time drift: ' + timeDifference + ' on ' + timerID + ' in ' + timeElapsed + 'seconds.')