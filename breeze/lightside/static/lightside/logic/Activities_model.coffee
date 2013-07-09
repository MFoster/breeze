class Breeze.Activities.Model
	# Establish internal variables
	_init = false
	displayListData = []
	archivedListData = []
	sortedListData = []

	constructor: (@attributes) ->
		if !_init
			if Modernizr.localstorage
				localStorage['MarshallWorks.Breeze.Activities'] = '{}'
			else
				Breeze.DebugCenter.message('Local storage not available.')
			_init = true
			return Breeze.Activities.Model.statusReport()
		else
			Breeze.DebugCenter.message('Activities Model class was already initialized.', 'caution')

	@statusReport: () ->
		reportData = {
			_init: _init
			displayListData: displayListData
			archivedListData: archivedListData
			sortedListData: sortedListData
		}
		return reportData

	@getActivityDefaults: () ->
		setCurrentDateTime = '2013-07-03T12:12:10.000Z'
		setDueDateTime = '2013-07-10T12:12:10.000Z'
		setDefaultDuration = Breeze.People.getPersonsPreferences().chunckTimeMedium
		defaultData = {
			activity_duration: setDefaultDuration
			activity_type: 'create'
			activity_available_datetime: setCurrentDateTime
			activity_due_datetime: setDueDateTime
			activity_scheduled: false
		}

	@validateActivityData: (formData) ->
		validationObject = {
			text: 'required'
			type: ['appointment','communicate','create','decide','improve','maintain','obtain','organize','plan','research','resolve','social']
			originalDuration: 'number'
			currentDuration: 'number'
			remainingDuration: 'number'
			availableDateTime: 'datetime'
			dueDateTime: 'datetime'
			scheduled: 'boolean'
		}
		validatedData = {
			text: formData.activity_text
			type: formData.activity_type
			originalDuration: formData.activity_duration
			currentDuration: formData.activity_duration
			remainingDuration: formData.activity_duration
			availableDateTime: formData.activity_available_datetime
			dueDateTime: formData.activity_due_datetime
			scheduled: formData.activity_scheduled
		}
		return validatedData

	@getActivities: (selectedPlaylist) ->
		displayListData = []
		rawListData = getAllActivitiesFromDB(selectedPlaylist)
		if rawListData
			for activity in rawListData
				displayListData.push(processActivityData(activity))
			sortedListData = processActivityPriority(displayListData)
			Breeze.Views.showActivitiesList(sortedListData)
			return true
		else
			Breeze.DebugCenter.message('No activities returned when getting activities for playlist ' + selectedPlaylist + '.')
			return false

	@getNextActivity: (activityIndex = 0) ->
		return displayListData[activityIndex]

	@getActivityById: (activityId) ->
		for activity in displayListData
			if activity.id is activityId
				return activity
		return false

	@moveActivityToTop: (activityId) ->
		activityIndex = sortedListData.indexOf(activityId)
		if activityIndex > -1
			sortedListData.splice(activityIndex, 1)
			sortedListData.unshift(activityId)
			Breeze.Views.updateActivitiesList(sortedListData)
			return true
		else
			return false

	@addActivity: (playlist = '', sentData = {}) ->
		setActivityId = createRandomActivityId()
		setCurrentDateTime = '2013-07-03T12:12:10.000Z'
		setDueDateTime = '2013-07-06T00:10:00.000Z'
		setDefaultDuration = Breeze.People.getPersonsPreferences().chunckTimeMedium
		defaultData = {
			id: setActivityId
			text: 'Activity Text Missing'
			type: 'create'
			originalDuration: setDefaultDuration
			currentDuration: setDefaultDuration
			currentComplete: 0
			remainingDuration: setDefaultDuration
			description: ''
			log: []
			createdDateTime: setCurrentDateTime
			availableDateTime: setCurrentDateTime
			dueDateTime: setDueDateTime
			completedDateTime: ''
			scheduled: false
		}
		saveData = {}
		for property, value of defaultData
			if sentData.hasOwnProperty(property)
				saveData[property] = sentData[property]
			else
				saveData[property] = value
		displayListData.push(saveData)
		savedInDB = createActivityInDB(playlist, saveData)
		if savedInDB
			Breeze.Views.addToActivitiesList(displayListData)
			return saveData
		else
			return false

	@updateActivity: (activityId, sentData) ->
		return false

	@addTimeToDurationsById: (activityId, addMillisecondTime) ->
		for activity in displayListData
			if activity.id is activityId
				activity.currentDuration += addMillisecondTime
				activity.remainingDuration += addMillisecondTime

	@updateActivityDurationsById: (activityId, completedTime, remainingTime) ->
		for activity in displayListData
			if activity.id is activityId
				activity.currentComplete = completedTime
				activity.remainingDuration = remainingTime
				return true
		return false

	@updateActivityAvailableTimeById: (activityId, availableTime) ->
		for activity in displayListData
			if activity.id is activityId
				activity.availableDateTime = availableTime
				return true
		return false

	@archiveActivityById: (activityId, archiveTime) ->
		for activity in displayListData
			if activity.id is activityId
				activity.completedDateTime = archiveTime
				archivedListData.push(displayListData.splice(_i, 1))
				activityIndex = sortedListData.indexOf(activityId)
				if activityIndex > -1
					sortedListData.splice(activityIndex, 1)
					return true
		return false

	@updateActivityPriority: () ->
		processActivityPriority()
		Breeze.Views.updateActivitiesList(sortedListData)

	@resetLocalStorageForDemo: () ->
		if confirm('Are you sure you want completely RESET the local storage?')
			localStorage['MarshallWorks.Breeze.Activities'] = '{}'
			demoData = $.ajax({
				url: '/static/lightside/logic/demo_data_activities.json'
				dataType: 'json'
			}).done((data) ->
				for playlist, activities of data
					for activity in activities
						Breeze.Activities.Model.addActivity(playlist, activity)
			)
			return true

	#Database Functions
	getLocalStorageActivities = () ->
		return JSON.parse(localStorage['MarshallWorks.Breeze.Activities'])

	setLocalStorageActivities = (saveObject) ->
		localStorage['MarshallWorks.Breeze.Activities'] = JSON.stringify(saveObject)
		return true

	getAllActivitiesFromDB = (playlistId = '') ->
		if Modernizr.localstorage
			if playlistId != ''
				localActivityData = getLocalStorageActivities()
				if localActivityData.hasOwnProperty(playlistId)
					return localActivityData[playlistId]
				else
					Breeze.DebugCenter.message('Playlist with ID ' + playlistId + ' not found when getting activities.', 'error')
					return false
			else
				Breeze.DebugCenter.message('No playlist specified when getting Activities.', 'error')
				return false
		else
			Breeze.DebugCenter.message('Browser does not support Local Storage.', 'error')
			return false

	getActivityFromDB = (activityId = '') ->
		if Modernizr.localstorage
			if activityId != ''
				localActivityData = getLocalStorageActivities()
				for playlist, activities of localActivityData
					for activity in activities
						if activity.id is activityId
							return activity
				Breeze.DebugCenter.message('Could not find activity with id ' + activityId + '.', 'error')
				return false
			else
				Breeze.DebugCenter.message('No activity specified when getting Activity.', 'error')
				return false
		else
			Breeze.DebugCenter.message('Browser does not support Local Storage.', 'error')
			return false

	createActivityInDB = (playlistId = '', activityData = {}) ->
		if Modernizr.localstorage
			if playlistId != '' and !$.isEmptyObject(activityData)
				localActivityData = getLocalStorageActivities()
				if !localActivityData.hasOwnProperty(playlistId)
					localActivityData[playlistId] = []
				localActivityData[playlistId].push(activityData)
				setLocalStorageActivities(localActivityData)
				return true
			else
				Breeze.DebugCenter.message('No playlist or activity data given when saving Activity.', 'error')
				return false
		else
			Breeze.DebugCenter.message('Browser does not support Local Storage.', 'error')
			return false

	updateActivityInDB = (activityData = {}) ->
		if Modernizr.localstorage
			if !$.isEmptyObject(activityData)
				localActivityData = getLocalStorageActivities()
				for playlist, activities of localActivityData
					for activity in activities
						if activity.id is activityData.id
							activity = activityData
							setLocalStorageActivities(localActivityData)
							return true
				Breeze.DebugCenter.message('Could not find activity with id ' + activityData.id + ' to update.', 'error')
				return false
			else
				Breeze.DebugCenter.message('No data passed when updating Activity.', 'error')
				return false
		else
			Breeze.DebugCenter.message('Browser does not support Local Storage.', 'error')
			return false

	removeActivityFromDB = (activityId = '') ->
		if Modernizr.localstorage
			if activityId != ''
				localActivityData = getLocalStorageActivities()
				for playlist, activities of allActivities
					for activity in activities
						if activity.id is activityId
							localActivityData[playlist].splice(_i, 1)
							setLocalStorageActivities(localActivityData)
							return true
				Breeze.DebugCenter.message('Could not find activity with id ' + activityId + ' when deleting.', 'error')
				return false
			else
				Breeze.DebugCenter.message('No activity specified when deleting Activity.', 'error')
				return false
		else
			Breeze.DebugCenter.message('Browser does not support Local Storage.', 'error')
			return false

	removeAllActivitiesFromDB = (playlistId = '') ->
		if Modernizr.localstorage
			if playlistId != ''
				localActivityData = getLocalStorageActivities()
				if localActivityData.hasOwnProperty(playlist)
					localActivityData[playlist] = []
					setLocalStorageActivities(localActivityData)
					return true
				else
					Breeze.DebugCenter.message('Could not find playlist with id ' + playlistId + ' when deleting playlist activities.', 'error')
					return false
			else
				Breeze.DebugCenter.message('No playlist id passed when deleting activities from playlist.')
				return false
		else
			Breeze.DebugCenter.message('Browser does not support Local Storage.', 'error')
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

	createRandomActivityId = () ->
		returnString = 'BA-'
		possibleCharacters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
		for num in [1..8]
			returnString += possibleCharacters.charAt(Math.floor(Math.random() * possibleCharacters.length))
		return returnString