require_relative('../db/sql_runner')
require('pry')

class Animal

  attr_accessor :name, :type, :admission_date, :owner_id, :adoptable
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @type = options['type']
    @admission_date = options['admission_date']
    @adoptable = options['adoptable'] ? options['adoptable'] : false
    @owner_id = options['owner_id'].to_i if options['owner_id']
  end

  def save()
    sql = "INSERT INTO animals
    (
      name,
      type,
      admission_date,
      adoptable,
      owner_id
    )
    VALUES
    (
      $1, $2, $3, $4, $5
    )
    RETURNING id"
    values = [@name, @type, @admission_date, @adoptable, @owner_id]
    result = SqlRunner.run(sql, values)
    @id = result.first['id']
  end

  def owner()
    owner = Owner.find(@owner_id)
    return owner
  end

  def update()
    sql = "UPDATE animals
    SET name = $1
    WHERE id = $2"
    values = [@name, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM animals
    WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM animals"
    animal_data = SqlRunner.run(sql)
    animals = map_items(animal_data)
    return animals
  end

  def self.delete_all()
    sql = "DELETE FROM animals"
    SqlRunner.run(sql)
  end

  def self.find(id)
    sql = "SELECT * FROM animals
    WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values)
    animal = self.new(result.first)
    return animal
  end


  def self.map_items(animal_data)
    return animal_data.map { |animal| Animal.new(animal) }
  end

  def self.find_owned_by(owner_id)
    sql = "SELECT * FROM animals WHERE owner_id = $1"
    values = [owner_id]
    results = SqlRunner.run(sql, values)
    return map_items(results)
  end

  def self.find_adoptable()
    # write sql that gets all the animals where the adoptable column is true (test the sql in postico)
    # run the sql runner passing in sql
    # map the results, creating animal objects (use map_items) method
    sql = "SELECT * FROM animals WHERE adoptable = 'true'"
    result = SqlRunner.run(sql)
    return map_items(result)
  end

  def self.find_adopted()
    sql = "SELECT * FROM animals WHERE owner_id IS NOT NULL"
    results = SqlRunner.run(sql)
    return map_items(results)
  end

  def self.find_training()
    sql = "SELECT * FROM animals WHERE owner_id IS NULL AND adoptable = 'false'"
    results = SqlRunner.run(sql)
    return map_items(results)
  end





end
