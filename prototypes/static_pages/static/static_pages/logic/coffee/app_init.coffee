window.Breeze = {}

class Breeze.Initializer
	constructor: (@attributes) ->
		console.log('Breeze Starting...')
		if (typeof jQuery != 'undefined')
			$('html').removeClass('no-js')
			$(document).ready( ->
				console.log('Breeze is ready!')
			)
		return true

Breeze.Initializer()