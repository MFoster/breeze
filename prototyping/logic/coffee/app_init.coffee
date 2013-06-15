window.App = {}

class App.Start
	constructor: (@attributes) ->
		if (typeof jQuery != 'undefined')
			$('html').removeClass('no-js')
			$(document).ready( ->
				console.log('Document is ready!')
			)
		return true