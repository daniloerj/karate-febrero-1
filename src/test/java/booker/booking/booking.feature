Feature: script para automatizar pruebas del recurso Booking

  Background:
    * configure headers = { x-environment: #(environment), 'User-Agent': 'Karate Project', Accept: 'application/json' }
    Given url baseUrl
    * print environment

  @regression @smoke @get-booking-ids
Scenario: GetBookingIds
Given path 'booking'
When method GET
Then status 200
* print 'Response Time:', responseTime
And assert responseTime < 5000
And match response == '#[]'
And match each response == read('classpath:booker/booking/schemas/booking-id-item.json')

@regression @smoke
Scenario: GetBookingIds by filter firstname
Given path 'booking'
And param firstname = 'John'
And param lastname = 'Smith'
And param checkin = '2000-01-01'
And param checkout = '2026-01-01'
When method GET
Then status 200
* print 'Response Time:', responseTime
And assert responseTime < 5000
And match response == '#[]'
And match each response == read('classpath:booker/booking/schemas/booking-id-item.json')

@regression
Scenario: GetBooking by id
Given path 'booking'
When method GET
Then status 200

* def bookingId = response[0].bookingid

Given path 'booking', bookingId
When method GET
Then status 200
Then status 200
And match response == read('classpath:booker/booking/schemas/booking-schema.json')

@regression @smoke
Scenario: CreateBooking
* def requestPayload = read('classpath:booker/booking/requests/create-booking.json')

Given path 'booking'
And header Content-Type = 'application/json'
And header X-author = requestPayload.firstname + ' ' + requestPayload.lastname
And request requestPayload
When method POST
Then status 200
Then status 200
And match response == read('classpath:booker/booking/schemas/create-booking-response.json')

Given path 'booking', response.bookingid
When method get
Then status 200

@regression
Scenario: UpdateBooking
Given path 'booking'
When method GET
Then status 200

* def bookingId = response[0].bookingid
* def token = call read('classpath:booker/auth/auth.feature')
* print 'Token:', token

Given path 'booking', bookingId
And header Content-Type = 'application/json'
And header Cookie = 'token=' + token.response.token
And request read('classpath:booker/booking/requests/update-booking.json')
When method put
Then status 200
Then status 200
And match response == read('classpath:booker/booking/schemas/update-booking-response.json')

Given path 'booking', bookingId
When method get
Then status 200

@regression
Scenario: DeleteBooking
Given path 'booking'
And header Content-Type = 'application/json'
And request read('classpath:booker/booking/requests/create-booking.json')
When method POST
Then status 200

* def bookingId = response.bookingid
* def token = call read('classpath:booker/auth/auth.feature')

Given path 'booking', bookingId
And header Content-Type = 'application/json'
And header Cookie = 'token=' + token.response.token
When method DELETE
Then status 201
And match response == '#string'

Given path 'booking', bookingId
When method get
Then status 404

@regression
Scenario: Partial update booking (PATCH)
  Given path 'booking'
  When method GET
  Then status 200

  * def bookingId = response[0].bookingid
  * def token = call read('classpath:booker/auth/auth.feature')

  Given path 'booking', bookingId
  And header Content-Type = 'application/json'
  And header Cookie = 'token=' + token.response.token
  And request read('classpath:booker/booking/requests/partial-update-booking.json')
  When method patch
  Then status 200
  And match response.firstname == 'Raul-Partial'
  And match response.additionalneeds == 'Late Checkout'

  Given path 'booking', bookingId
  When method GET
  Then status 200
  And match response.firstname == 'Raul-Partial'
  And match response.additionalneeds == 'Late Checkout'