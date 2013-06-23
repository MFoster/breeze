class Breeze.ActivitiesModel
	# Establish internal variables
	# Temporary Activities Data, will need to be replaced with real data.
	activityList = [
		{
			id: 'an_id_001'
			text: 'Task Item One'
			type: 'create'
			duration: 'large'
			description: ''
			log: []
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
			duration: 'medium'
			description: ''
			log: []
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
			duration: 'custom'
			description: ''
			log: []
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
			duration: 'small'
			description: ''
			log: []
			createdDateTime: ''
			availableDateTime: ''
			dueDateTime: ''
			completedDateTime: ''
			scheduled: false
		},
	]

	# Set the Angular scope to access inside of Class
	angularScope = $('#primary-container').scope()

	constructor: (@attributes) ->
		return true

	@statusReport: () ->
		reportData = {
			activityList: activityList
		}
		return reportData


	@controller: ($scope) ->
		$scope.activities = activityList
		$scope.addActivity = (sentData) ->
			activityData = sentData
			$scope.activities.push(activityData)
		$scope.updateActivity = (activityIndex, sentData) ->
			for property, value of $scope.activities[activityIndex]
				if sentData.hasOwnProperty(property)
					$scope.activities[activityIndex][property] = sentData[property]

	# Functions that can be accessed outside of the Angular Scope, and retain the ability to keep the DOM up-to-date.
	@getActivities = (selectedPlaylist) ->
		angularScope.$apply( ->
			angularScope.activities = activityList
		)

	@addActivity = (sentData) ->
		angularScope.$apply( ->
			angularScope.addActivity(sentData)
		)

	@updateActivity = (activityIndex, sentData) ->
		angularScope.$apply( ->
			angularScope.updateActivity(activityIndex, sentData)
		)