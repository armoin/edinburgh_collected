namespace :categories do
  task :convert => :environment do |t, args|
    {
      "Leisure" => "Sport & Leisure",
      "Sport"   => "Sport & Leisure"
    }.each do |old, new|
      old_category = Category.find_by(name: old)
      new_category = Category.find_by(name: new)

      puts ""
      puts "Before: #{old} has #{old_category.memories.count} memories."
      puts "Before: #{new} has #{new_category.memories.count} memories."

      old_category.memories.each do |memory|
        memory.categories << new_category unless memory.categories.include?(new_category)
        memory.categories.delete(old_category)
        memory.description = memory.title if memory.description.blank?
        memory.save!
      end

      puts "After: #{old} has #{old_category.memories.count} memories."
      puts "After: #{new} has #{new_category.memories.count} memories."
    end
    puts ""
  end

  task :show_tech => :environment do |t, args|
    p tech_mems: Category.find_by(name: 'Technology').memories.map(&:id)
  end

  task :remove_old => :environment do |t, args|
    conversions.keys.each {|old_name| Category.where(name: old_name).destroy_all }
  end
end
