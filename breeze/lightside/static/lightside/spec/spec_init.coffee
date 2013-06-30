describe 'Initialize the Breeze App', ->

	statusReport = {}

	beforeEach( ->
		statusReport = Breeze.Initializer.statusReport()
	)

	it 'should be defined', ->
		expect(Breeze.Initializer).toBeDefined()
	it 'constructor should have a true init', ->
		expect(statusReport._init).toBeTruthy()

	describe ': All components need to be initalized successfully', ->

		it 'including Debuger', ->
			expect(statusReport.debugCenter_init._init).toBeTruthy()
		it 'inculding People', ->
			expect(statusReport.people_init._init).toBeTruthy()
		it 'including Activities', ->
			expect(statusReport.activities_init._init).toBeTruthy()
		it 'including Views', ->
			expect(statusReport.views_init._init).toBeTruthy()
		it 'including Timers', ->
			expect(statusReport.timers_init._init).toBeTruthy()