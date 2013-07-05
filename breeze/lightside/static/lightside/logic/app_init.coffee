window.Breeze = {}

class Breeze.Initializer

	_init = false
	initWith = {}
	debugCenter_init = {}
	people_init = {}
	activities_init = {}
	views_init = {}
	timers_init = {}

	constructor: (@attributes) ->
		if (typeof jQuery != 'undefined')
			$('html').removeClass('no-js')
			$(document).ready( ->
				debugCenter_init = Breeze.DebugCenter()
				Breeze.DebugCenter.setMessageLevel(3)
				people_init = Breeze.People()
				activities_init = Breeze.Activities()
				views_init = Breeze.Views()
				timers_init = Breeze.Timers()
				Breeze.DebugCenter.message('Breeze is ready!')
				_init = true
				initWith = Breeze.Initializer.statusReport()
			)
		else
			return false

	@statusReport: () ->
		statusObject = {
			_init: _init
			initWith: initWith
			debugCenter_init: debugCenter_init
			people_init: people_init
			activities_init: activities_init
			views_init: views_init
			timers_init: timers_init
		}

Breeze.Initializer()