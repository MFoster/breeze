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
		nowSecondsStart = Math.round(new Date().getTime() / 1000)
		runningTimers[timerID] = {
			startTime: nowSecondsStart
			currentTime: remainingTime
			timer: setInterval( ->
				runningTimers[timerID].currentTime++
			, 1000)
		}

	@startDownTimer: (timerID, remainingTime) ->
		nowSecondsStart = Math.round(new Date().getTime() / 1000)
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
		nowSecondsStop = Math.round(new Date().getTime() / 1000)
		timeElapsedTimer = runningTimers[timerID].totalTime - runningTimers[timerID].currentTime
		timeElapsedReal = runningTimers[timerID].expectedStopTime - nowSecondsStop
		timeDifference = timeElapsedReal - timeElapsedTimer
		console.log('Time drift: ' + timeDifference + ' on ' + timerID + ' in ' + timeElapsedTimer + 'seconds.')