class Breeze.Activities
	# Establish internal variables
	chuncksCompletedMonth = 32
	chuncksCompletedDay = 0
	activityList = [
		{
			id: 'an_id_001'
			text: 'Task Item One'
			duration: 'large'
		},
		{
			id: 'an_id_002'
			text: 'Task Item Two'
			duration: 'custom'
		},
		{
			id: 'an_id_003'
			text: 'Task Item Three'
			duration: 'medium'
		},
		{
			id: 'an_id_004'
			text: 'Task Item Four'
			duration: 'small'
		},
		{
			id: 'an_id_005'
			text: 'Task Item Five'
			duration: 'small'
		},
		{
			id: 'an_id_006'
			text: 'Task Item Six'
			duration: 'large'
		}
	]

	constructor: (@attributes) ->
		return true

	@controller: ($scope) ->
		$scope.chuncksCompletedMonth = chuncksCompletedMonth
		$scope.chuncksCompletedDay = chuncksCompletedDay
		$scope.activities = activityList
		$scope.completeActivity = ->
			$scope.chuncksCompletedMonth++
			$scope.chuncksCompletedDay++