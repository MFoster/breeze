class Breeze.People
	# Establish internal variables
	_init = false
	personObject = {
		personsName: ''
		personsPlaylists: [
			{ id: '', name: '' }
		]
		personsStats: {
			chuncksCompletedMonth: 0
			chuncksCompletedDay: 0
			activitiesTopCategory: ''
		}
		personsPreferences: {
			chunckTimeSmall: 0
			chunckTimeMedium: 0
			chunckTimeLarge: 0
			defaultPlaylist: ''
			theme: ''
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
			personsPlaylists: [
				{ id: 'an_id_001', name: 'primary' }
				{ id: 'an_id_002', name: 'secondary' }
			]
			personsStats: {
				chuncksCompletedMonth: 53
				chuncksCompletedDay: 0
				activitiesTopCategory: 'create'
			}
			personsPreferences: {
				chunckTimeSmall: 5
				chunckTimeMedium: 25
				chunckTimeLarge: 50
				defaultPlaylist: 'an_id_001'
				theme: 'darkside'
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

	@getPersonsPlaylists: () ->
		return personObject.personsPlaylists

	@getPersonsPlaylistsById: (playlistId) ->
		for playlist in personObject.personsPlaylists
			if playlist.id is playlistId
				return playlist
		return false

	@getPersonsDefaultPlaylist: () ->
		return personObject.personsPreferences.defaultPlaylist

	@getPersonsPreferences: () ->
		return personObject.personsPreferences