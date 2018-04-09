class Dumpdata

  def dump
    d = Day.first
    exceptions = 'id, created_at, updated_at, user_id, day_id'.split(', ')
    d.foods.each do |f|
      s = ''
      thingies = []
      f.attributes.each_pair do |name, value|
        if not exceptions.include?(name)
          thingies.append("\'#{name}\' => \'#{value}\'")
        end
      end
      s = thingies.join(', ')
      puts "day.foods.create(#{s})"
    end
  end
end
