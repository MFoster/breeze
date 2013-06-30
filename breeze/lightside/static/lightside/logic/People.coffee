class Breeze.People
	# Establish internal variables
	_init = false
	personObject = {
		personsName: ''
		personsPlaylists: []
		personsStats: {
			chuncksCompletedMonth: 0
			chuncksCompletedDay: 0
			activitiesTopCategory: ''
		}
		personsActionLog: []
	}

	constructor: (@attributes) ->
		if !_init
			_init = true
			getPersonData()
			return Breeze.People.statusReport()
		else
			Breeze.DebugCenter.message('People class was already initialized.', 'caution')

	@statusReport: () ->
		reportData = {
			_init: _init
			personObject: personObject
		}
		return reportData

	getPersonData = () ->
		testData = {
			personsName: 'The Creator'
			personsPlaylists: ['main']
			personsStats: {
				chuncksCompletedMonth: 53
				chuncksCompletedDay: 0
				activitiesTopCategory: 'create'
			}
			personsRecentActionLog: [{
				type: 'general'
				subType: 'info'
				message: 'First log message'
				dateTime: 'TimeStamp'
			}]
		}
		personObject = testData
		Breeze.Activities.selectPlaylist(personObject.personsPlaylists[0])
		Breeze.Views.showPersonalInfo(personObject)

	@addOneToPersonsChunckStats: () ->
		personObject.personsStats.chuncksCompletedDay++
		personObject.personsStats.chuncksCompletedMonth++
		Breeze.Views.showPersonalInfo(personObject)