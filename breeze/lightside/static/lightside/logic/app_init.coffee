class window.Breeze
	# Internal Breeze Variables
	_init = false
	debugCenter_init = {}
	people_init = {}
	activities_init = {}
	timers_init = {}
	views_init = {}
	interactions_init = {}

	constructor: (@attributes) ->
		if (typeof jQuery != 'undefined')
			$('html').removeClass('no-js')
			$(document).ready( ->
				debugCenter_init = Breeze.DebugCenter()
				Breeze.DebugCenter.setMessageLevel(3)
				people_init = Breeze.People()
				activities_init = Breeze.Activities()
				timers_init = Breeze.Timers()
				views_init = Breeze.Views()
				interactions_init = Breeze.Interactions()
				_init = true
				Breeze.DebugCenter.message('Breeze is ready!')
			)
		else
			return false

	@statusReport: () ->
		statusObject = {
			_init: _init
			debugCenter_init: debugCenter_init
			people_init: people_init
			activities_init: activities_init
			timers_init: timers_init
			views_init: views_init
			interactions_init: interactions_init
		}

Breeze()