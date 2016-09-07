module.exports = (sequelize, DataTypes) ->
  sequelize.define 'user', {
    userid: type: DataTypes.STRING, unique: true
    firstname:type: DataTypes.STRING
    lastname: type: DataTypes.STRING
    age: type: DataTypes.INTEGER, validate: min: 0, max: 100
  },
  classMethods:
    associate: (models) ->
      this.hasMany models.address
