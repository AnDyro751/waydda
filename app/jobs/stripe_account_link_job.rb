class StripeAccountLinkJob < ApplicationJob
  queue_as :default

  def perform(user)
    account_created = Account.create_stripe_account()
    unless account_created.nil?
      user.account = account_created
    end
  end
end
