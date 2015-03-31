class ScrapbookQueryBuilder
  def initialize(scrapbook_ids)
    @scrapbook_ids = scrapbook_ids
  end

  def all_query
    raise 'Must be implemented'
  end

  def approved_query
    all_query.where(Memory.approved_sql)
  end

  def approved_or_owned_by_query(user_id)
    all_query.where(Memory.approved_sql.or owned_by_user(user_id))
  end

  private

  def base_query(projection)
    scrapbook_memories_table
      .project(projection)
      .join(memories_table)
        .on(scrapbook_memories_table[:memory_id].eq(memories_table[:id]))
      .join(users_table)
        .on(memories_table[:user_id].eq(users_table[:id]))
      .where(scrapbook_memories_table[:scrapbook_id].in(@scrapbook_ids))
      .order(scrapbook_memories_table[:ordering])
  end

  def owned_by_user(user_id)
    users_table[:id].eq user_id
  end

  def memories_table
    Memory.arel_table
  end

  def scrapbook_memories_table
    ScrapbookMemory.arel_table
  end

  def users_table
    User.arel_table
  end
end
