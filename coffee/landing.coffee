navHeight = -> $('nav').height()

updateView = ->
	# make float menu
	$('.under-nav').css 'height', navHeight()
	$('nav').css position: 'fixed'

$window = $(window)
$window.on 'scroll resize', updateView
# $window.trigger 'scroll'
$(document).ready updateView

# link scrolling
$(document).on 'click', 'nav a', ->
	# console.log '???'
	$('html, body').animate scrollTop: $($.attr(this, 'href') ).offset().top - navHeight(), 500
	# $('nav a.active').removeClass 'active'
	# $(@).addClass 'active'
	false

$ ->
	monthNames = [
		"Январь"
		"Февраль"
		"Март"
		"Апрель"
		"Май"
		"Июнь"
		"Июль"
		"Август"
		"Сентябрь"
		"Октябрь"
		"Ноябрь"
		"Декабрь"
	]

	# месяца в склонении
	monthNames2 = []
	for name in monthNames
		monthNames2.push switch name
			when "Март", "Август" then name + 'а'
			else name.substring(0, name.length - 1) + 'я'

	outDate = (date) ->
		dateVar = new Date(date)
		msInDay = 1000 * 3600 * 24
		dateStr = "#{dateVar.getDate()} #{monthNames2[dateVar.getMonth()]}"
		dateStr = "Завтра" if dateVar.getTime() - new Date().getTime() < msInDay
		dateStr = "Сегодня" if dateVar.getTime() - new Date().getTime() < 0
		$('#order-content .date-title').text dateStr

	$('#datepicker').datepicker(
		monthNames: monthNames
		dayNamesMin: [
			"Вс"
			"Пн"
			"Вт"
			"Ср"
			"Чт"
			"Пт"
			"Сб"
		]
		firstDay: 1
		minDate: new Date()
		onSelect: (date) ->
			outDate date
	)
	outDate $('#datepicker').datepicker("getDate")

	$('#guests-count').buttonset()

	outSliderTime = (value) ->
		clock = switch value
			when 21 then "час"
			when 22, 23 then "часа"
			else "часов"
		$('#order-content .time-display').text("Буду в #{value} #{clock}")

	$('#time-slider').slider(
		value: 12
		min: 10
		max: 23
		step: 1
		slide: (event, ui) ->
			outSliderTime ui.value
	)
	outSliderTime $('#time-slider').slider('value')

	$('#programs li').each (index) ->
		move(@).x(100)
		.duration(0)
		.then()
			.x(-100)
			.ease('out')
			.delay("0.#{2 * index}")
			.duration('0.3s')
		.pop().end()

	$sections = $('section')

	activateSection = (index) ->
		id = $sections.eq(index).attr('id')
		$activeLink = $("nav a[href='##{id}']")
		$activeLink.addClass 'active'
		zoom = 0.9
		move($activeLink.get(0)).scale(zoom).end()

	deactivateSection = (index) ->
		id = $sections.eq(index).attr('id')
		$activeLink = $("nav a[href='##{id}']")
		$activeLink.removeClass 'active'
		move($activeLink.get(0)).scale(1).end()

	curIndex = 0
	activateSection(curIndex)

	$sections.each (index) ->
		waypoint = new Waypoint(
			element: @
			handler: (direction) ->
				deactivateSection curIndex
				curIndex = if direction == 'down' then index else index - 1
				activateSection curIndex
			offset: '30%'
		)

	# animate elements with class 'popup'
	popupShift = 100
	$('.popup').each ->
		move(@).y(popupShift).duration(0).end()
		el = @
		waypoint = new Waypoint(
			element: el
			handler: (direction) ->
				if direction == 'down'
					move(el).y(0).duration("0.#{600 + Math.random() * 400}").end()
				else
					move(el).y(popupShift).duration(0).end()
			offset: ->
				Waypoint.viewportHeight()
		)