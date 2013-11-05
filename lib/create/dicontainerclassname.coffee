###*
  @param {string} diContainerFactoryName
  @return {string}
###
module.exports = (diContainerFactoryName) ->

  names = diContainerFactoryName.split '.'
  lastName = names.pop()
  lastName = lastName.charAt(0).toUpperCase() + lastName.slice 1
  names.push lastName
  names.join '.'