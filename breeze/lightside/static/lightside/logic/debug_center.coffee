class Breeze.DebugCenter
	#Internal Variables
	_init = false
	messageLogTypes = ['error', 'caution', 'info']
	messageLogLevel = 0 # No messages, higher corresponds to messageTypes index
	messageLogTimeStamp = false
	messageLogLength = 100
	messageLogHistory = []

	constructor: (@attributes) ->
		if !_init
			# Check if console is available, add log for older IE browsers
			if(!window.console) then window.console = {log: -> }
			_init = true
			return Breeze.DebugCenter.statusReport()
		else
			Breeze.DebugCenter.message('DebugCenter class was already initialized.', 'caution')

	@statusReport: () ->
		reportData = {
			_init: _init
			messageLogTypes: messageLogTypes
			messageLogLevel: messageLogLevel
			messageLogTimeStamp: messageLogTimeStamp
			messageLogLength: messageLogLength
			messageLogHistory: messageLogHistory
		}
		return reportData

	@message: (message = 'NO MESSAGE TEXT SENT!', type = 'info') ->
		messagePrefix = 'informational: '
		messageTimeStamp = ''
		messageColor = 'green'
		switch type
			when 'caution' then messagePrefix = 'Caution: ' and messageColor = 'orange'
			when 'error' then messagePrefix = 'ERROR: ' and messageColor = 'red'
		messageToLog = messagePrefix + message
		nowTime = new Date().getTime()
		timeStamp = new Date(nowTime)
		messageTimeStamp = ' -- ' + timeStamp.toString()
		messageWithTimeStamp = messageToLog + messageTimeStamp
		recordMessageToHistory(messageWithTimeStamp)
		if messageLogTimeStamp
			messageToLog = messageWithTimeStamp
		for messageLogType in messageLogTypes
			if messageLogType is type
				if _i < messageLogLevel
					console.log('%c' + messageToLog, 'background: white; color: ' + messageColor + ';')

	@setMessageLevel: (level) ->
		messageLogLevel = level

	recordMessageToHistory = (message) ->
		if messageLogHistory.length > messageLogLength
			messageLogHistory.shift()
		messageLogHistory.push(message)