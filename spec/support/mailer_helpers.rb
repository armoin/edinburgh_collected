EMAIL_PARTS = %w(plain html)

def get_body_for(mail, content_type)
  mail.body.parts.find {|p| p.content_type.match /#{content_type}/}.body.raw_source
end

