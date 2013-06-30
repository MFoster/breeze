describe 'People Controller', ->

	statusReport = {}

	beforeEach( ->
		statusReport = Breeze.People.statusReport()
	)

	it 'should respond to getting a status report', ->
		expect(statusReport).toBeDefined()
	it 'should have the correct status information available', ->
		expect(statusReport._init).toBeDefined()
		expect(statusReport.personObject).toBeDefined()