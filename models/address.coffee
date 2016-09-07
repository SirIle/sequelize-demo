module.exports = (sequelize, DataTypes) ->
  sequelize.define 'address',
    streetaddress: type: DataTypes.STRING
    zipcode: type: DataTypes.STRING
