@ignore
Feature:test script create token para el recurso Auth
  Background:
    * configure headers = { x-company: 'danilo-ramirez', 'User-Agent': 'Karate Project', Content-Type: 'application/json' }
    Given url 'https://restful-booker.herokuapp.com'

Scenario: CreateToken
  Given path 'auth'
  And request 
  """
  { 
    username: 'admin', 
    password: 'password123' 
  }
  """
  When method POST
  Then status 200
  And match response == 
  """
  { 
    token: '#string' 
  }
  """
