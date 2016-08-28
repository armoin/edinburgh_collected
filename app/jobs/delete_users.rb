class DeleteUsers
  KEEP_FOR = 1.day

  def self.run
    users_to_delete = User.where("moderation_state = 'deleted' AND last_moderated_at < ?", KEEP_FOR.ago)
    users_to_delete.destroy_all
  end
end
