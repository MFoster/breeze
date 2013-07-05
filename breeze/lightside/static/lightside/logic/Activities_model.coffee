class Breeze.Activities.Model
	# Establish internal variables
	_init = false
	displayListData = []
	sortedListData = []
	# Temporary Activities Data, will need to be replaced with real data.
	activityList = [
		{
			id: 'an_id_001'
			text: 'Task Item One'
			type: 'create'
			originalDuration: 50
			currentDuration: 50
			currentComplete: 0
			remainingDuration: 50
			description: ''
			log: []
			createdDateTime: '2013-07-03T12:12:00.000Z'
			availableDateTime: '2013-07-03T12:12:10.000Z'
			dueDateTime: '2013-07-06T00:10:00.000Z'
			completedDateTime: ''
			scheduled: false
		},
		{
			id: 'an_id_002'
			text: 'Task Item Two'
			type: 'create'
			originalDuration: 1
			currentDuration: 1
			currentComplete: 0
			remainingDuration: 1
			description: ''
			log: []
			createdDateTime: '2013-07-03T12:12:00.000Z'
			availableDateTime: '2013-07-03T12:12:10.000Z'
			dueDateTime: '2013-07-13T00:10:00.000Z'
			completedDateTime: ''
			scheduled: true
		},
		{
			id: 'an_id_003'
			text: 'Task Item Three'
			type: 'create'
			originalDuration: 5
			currentDuration: 5
			currentComplete: 0
			remainingDuration: 5
			description: ''
			log: []
			createdDateTime: '2013-07-03T12:12:00.000Z'
			availableDateTime: '2013-07-03T12:12:10.000Z'
			dueDateTime: '2013-07-06T00:10:00.000Z'
			completedDateTime: ''
			scheduled: false
		},
		{
			id: 'an_id_004'
			text: 'Task Item Four'
			type: 'create'
			originalDuration: 90
			currentDuration: 90
			currentComplete: 0
			remainingDuration: 90
			description: ''
			log: []
			createdDateTime: '2013-07-03T12:12:00.000Z'
			availableDateTime: '2013-07-03T12:12:10.000Z'
			dueDateTime: '2013-06-06T00:10:00.000Z'
			completedDateTime: ''
			scheduled: false
		},
		{
			id: 'an_id_005'
			text: 'Task Item Five'
			type: 'create'
			originalDuration: 50
			currentDuration: 50
			currentComplete: 0
			remainingDuration: 50
			description: ''
			log: []
			createdDateTime: '2013-07-03T12:12:00.000Z'
			availableDateTime: '2013-07-03T12:12:10.000Z'
			dueDateTime: '2013-07-06T00:10:00.000Z'
			completedDateTime: ''
			scheduled: false
		},
		{
			id: 'an_id_006'
			text: 'Task Item Six'
			type: 'create'
			originalDuration: 25
			currentDuration: 25
			currentComplete: 0
			remainingDuration: 25
			description: ''
			log: []
			createdDateTime: '2013-07-03T12:12:00.000Z'
			availableDateTime: '2013-07-03T12:12:10.000Z'
			dueDateTime: '2013-07-06T00:10:00.000Z'
			completedDateTime: ''
			scheduled: false
		},
	]

	constructor: (@attributes) ->
		if !_init
			_init = true
			return Breeze.Activities.Model.statusReport()
		else
			Breeze.DebugCenter.message('Activities Model class was already initialized.', 'caution')

	@statusReport: () ->
		reportData = {
			_init: _init
			displayListData: displayListData
			sortedListData: sortedListData
		}
		return reportData

	@getActivities: (selectedPlaylist) ->
		# Add Getting JSON stuff here.
		displayListData = []
		for activity in activityList
			displayListData.push(processActivityData(activity))
		sortedListData = processActivityPriority(displayListData)
		Breeze.Views.showActivitiesList(sortedListData)

	@getNextActivity: () ->
		return displayListData[0]

	@getActivityById: (activityId) ->
		for activity in displayListData
			if activity.id is activityId
				return activity
		return false

	@archiveActivityById: (activityId) ->
		for activity in displayListData
			if activity.id is activityId
				displayListData.splice(_i, 1)
				return true
		return false

	@addActivity: (sentData) ->
		defaultData = {
			id: 'an_temp_id_001'
			text: 'Text Missing'
			type: 'create'
			originalDuration: 25
			currentDuration: 25
			currentComplete: 0
			remainingDuration: 25
			description: ''
			log: []
			createdDateTime: '2013-07-03T12:12:00.000Z'
			availableDateTime: '2013-07-03T12:12:10.000Z'
			dueDateTime: '2013-07-06T00:10:00.000Z'
			completedDateTime: ''
			scheduled: false
		}
		saveData = {}
		for property, value of defaultData
			if sentData.hasOwnProperty('property')
				saveData[property] = sentData[property]
			else
				saveData[property] = value
		displayListData.push(saveData)
		Breeze.Views.addToActivitiesList(displayListData)

	@updateActivity: (activityIndex, sentData) ->
		return false

	processActivityData = (data) ->
		originalDuration = Breeze.Timers.convertMinutesToMilliseconds(data.originalDuration)
		currentDuration = Breeze.Timers.convertMinutesToMilliseconds(data.currentDuration)
		currentComplete = Breeze.Timers.convertMinutesToMilliseconds(data.currentComplete)
		remainingDuration = Breeze.Timers.convertMinutesToMilliseconds(data.remainingDuration)
		personPreferences = Breeze.People.statusReport().personObject.personsPreferences
		durationType = 'small'
		if data.currentDuration > personPreferences.chunckTimeSmall then durationType = 'medium'
		if data.currentDuration > personPreferences.chunckTimeMedium then durationType = 'large'
		if data.currentDuration > personPreferences.chunckTimeLarge then durationType = 'custom'
		createdDateTime = Breeze.Timers.convertStringToDate(data.createdDateTime)
		availableDateTime = Breeze.Timers.convertStringToDate(data.availableDateTime)
		dueDateTime = Breeze.Timers.convertStringToDate(data.dueDateTime)
		completedDateTime = Breeze.Timers.convertStringToDate(data.completedDateTime)
		returnObject = {
			id: data.id
			text: data.text
			type: data.type
			originalDuration: originalDuration
			currentDuration: currentDuration
			currentComplete: currentComplete
			remainingDuration: remainingDuration
			durationType: durationType
			description: data.description
			log: data.log
			createdDateTime: createdDateTime
			availableDateTime: availableDateTime
			dueDateTime: dueDateTime
			completedDateTime: completedDateTime
			scheduled: data.scheduled
		}

	processActivityPriority = (data) ->
		priorityList = []
		dateSort = (a, b) ->
			a.dueDateTime - b.dueDateTime
		data = data.sort(dateSort)
		for activity in data
			priorityList.push(activity.id)
		return priorityList