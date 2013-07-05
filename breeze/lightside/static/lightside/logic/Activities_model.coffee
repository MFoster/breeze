class Breeze.Activities.Model
	# Establish internal variables
	_init = false
	# Temporary Activities Data, will need to be replaced with real data.
	activityList = [
		{
			id: 'an_id_001'
			text: 'Task Item One'
			type: 'create'
			duration: 'large'
			description: ''
			log: []
			remainingTime: ''
			createdDateTime: ''
			availableDateTime: ''
			dueDateTime: ''
			completedDateTime: ''
			scheduled: false
		},
		{
			id: 'an_id_002'
			text: 'Task Item Two'
			type: 'create'
			duration: '1'
			description: ''
			log: []
			remainingTime: ''
			createdDateTime: ''
			availableDateTime: ''
			dueDateTime: ''
			completedDateTime: ''
			scheduled: true
		},
		{
			id: 'an_id_003'
			text: 'Task Item Three'
			type: 'create'
			duration: 'small'
			description: ''
			log: []
			remainingTime: ''
			createdDateTime: ''
			availableDateTime: ''
			dueDateTime: ''
			completedDateTime: ''
			scheduled: false
		},
		{
			id: 'an_id_004'
			text: 'Task Item Four'
			type: 'create'
			duration: '90'
			description: ''
			log: []
			remainingTime: ''
			createdDateTime: ''
			availableDateTime: ''
			dueDateTime: ''
			completedDateTime: ''
			scheduled: false
		},
		{
			id: 'an_id_005'
			text: 'Task Item Five'
			type: 'create'
			duration: 'large'
			description: ''
			log: []
			remainingTime: ''
			createdDateTime: ''
			availableDateTime: ''
			dueDateTime: ''
			completedDateTime: ''
			scheduled: false
		},
		{
			id: 'an_id_006'
			text: 'Task Item Six'
			type: 'create'
			duration: 'medium'
			description: ''
			log: []
			remainingTime: ''
			createdDateTime: ''
			availableDateTime: ''
			dueDateTime: ''
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
			activityList: activityList
		}
		return reportData

	@getActivities: (selectedPlaylist) ->
		# Add Getting JSON stuff here.
		Breeze.Views.showActivitiesList(activityList)

	@getNextActivity: () ->
		return activityList[0]

	@getActivityById: (activityId) ->
		for activity in activityList
			if activity.id is activityId
				return activity
		return false

	@archiveActivityById: (activityId) ->
		for activity in activityList
			if activity.id is activityId
				activityList.splice(_i, 1)
				return true
		return false

	@addActivity = (sentData) ->
		defaultData = {
			id: 'an_temp_id_001'
			text: 'Text Missing'
			type: 'create'
			duration: 'medium'
			description: 'No description'
			log: []
			remainingTime: ''
			createdDateTime: ''
			availableDateTime: ''
			dueDateTime: ''
			completedDateTime: ''
			scheduled: false
		}
		saveData = {}
		for property, value of defaultData
			if sentData.hasOwnProperty('property')
				saveData[property] = sentData[property]
			else
				saveData[property] = value
		activityList.push(saveData)
		Breeze.Views.addToActivitiesList(activityList)

	@updateActivity = (activityIndex, sentData) ->
		return false