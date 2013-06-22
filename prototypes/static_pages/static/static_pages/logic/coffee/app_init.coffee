window.App = {}

class App.Start
	constructor: (@attributes) ->
		console.log('App Starting...')
		if (typeof jQuery != 'undefined')
			$('html').removeClass('no-js')
			$(document).ready( ->
				console.log('Document is ready!')
			)
		return true

App.Start()