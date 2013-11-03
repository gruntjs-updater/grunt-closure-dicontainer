###*
  @param {string} factoryNamespace
  @return {string}
###
module.exports = (factoryNamespace) ->

  names = factoryNamespace.split '.'
  lastName = names.pop()
  lastName = lastName.charAt(0).toUpperCase() + lastName.slice 1
  names.push lastName
  names.join '.'