class LmaImporter
  DUMP_FILE = File.expand_path('lma.xml', File.dirname(__FILE__))

  def initialize(lma_user, admin_user)
    @lma_user = lma_user
    @admin_user = admin_user
  end

  def run
    items.first(3).each do |item|
      memory = Memory.new(
        type: 'Photo',
        title: title_for(item),
        year: year_for(item),
        description: description_for(item),
        attribution: attribution_for(item)
      )
      memory.categories << Category.find_by_name('Daily Life')
      memory.user = @lma_user
      memory.remote_source_url = source_url_for(item)

      if memory.save
        memory.approve!(@admin_user)
        puts "#{id_for(item)} (success)"
      else
        puts "#{id_for(item)} (failed) #{memory.errors.full_messages}"
      end
    end
  end

  private

  def title_for(item)
    content_for 'title', item
  end

  def description_for(item)
    full_description_for(item).gsub(/Donated by.*/, '')
  end

  def attribution_for(item)
    donated_by_for(item) || author_for(item)
  end

  def year_for(item)
    matches = title_for(item).match(/(\d*)$/)
    return 2015 unless matches && matches[1].to_i.between?(1000,2015)
    matches[1]
  end

  def source_url_for(item)
    lma_id = id_for(item)
    "http://livingmemory.org.uk/main.php?g2_view=core.DownloadItem&g2_itemId=#{lma_id}"
  end

  def id_for(item)
    matches = url_for(item).match(/g2_itemId=(\d*)$/)
    fail "No id for item: #{title_for(item)}" unless matches
    matches[1]
  end

  def url_for(item)
    content_for 'link', item
  end

  def full_description_for(item)
    content_for 'description', item
  end

  def donated_by_for(item)
    matches = full_description_for(item).match(/Donated by:?\s*(.*)/)
    return nil unless matches
    matches[1]
  end

  def author_for(item)
    content_for 'author', item
  end

  def doc
    @doc ||= File.open(DUMP_FILE) { |f| Nokogiri::XML(f) }
  end

  def items
    doc.xpath("//item")
  end

  def content_for(attr_name, item)
    s1 = item.xpath(attr_name).first.try(:content)
    s2 = ActionView::Base.full_sanitizer.sanitize(s1)
    s3 = s2.gsub(/\n\s*/, ' ').strip
    CGI::unescapeHTML s3
  end
end


desc "Imports data from Living Memory Association"
task :lma_import => :environment do |t, args|
  lma_user = User.find_by(screen_name: 'Living Memory Association')
  admin_user = User.where(is_admin: true).first

  puts "Running importer ..."
  LmaImporter.new(lma_user, admin_user).run
  puts "Done"
end
