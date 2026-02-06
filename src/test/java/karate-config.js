function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    env: env,
    myVarName: 'someValue',
    baseUrl: 'https://restful-booker.herokuapp.com',
    environment: ''
  }
  if (env == 'dev') {
    // customize
    config.environment = 'dev';
  } else if (env == 'qa') {
    // customize
    config.environment = 'qa';
  }
  return config;
}