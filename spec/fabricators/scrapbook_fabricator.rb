Fabricator(:scrapbook, aliases: :pending_scrapbook) do
  id               { sequence(:id, 1) }
  user             { Fabricate(:approved_user) }
  title            { FFaker::Product.product_name }
  description      { FFaker::Lorem.words(rand(50)).join(' ') }
  updated_at       { rand(10).to_i.days.ago }
  moderation_state ModerationStateMachine::DEFAULT_STATE
end

Fabricator(:approved_scrapbook, from: :scrapbook) do
  after_create {|scrapbook, transients| scrapbook.approve!(scrapbook.user) }
end
