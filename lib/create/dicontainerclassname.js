/**
  @param {string} diContainerFactoryName
  @return {string}
*/

module.exports = function(diContainerFactoryName) {
  var lastName, names;
  names = diContainerFactoryName.split('.');
  lastName = names.pop();
  lastName = lastName.charAt(0).toUpperCase() + lastName.slice(1);
  names.push(lastName);
  return names.join('.');
};
