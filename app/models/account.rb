class Account
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  field :account_id, type: String, default: ""
  field :completed, type: Boolean, default: false
  # Stripe key
  # TODO: Enviar a secret
  Stripe.api_key = 'sk_test_nLhx5k3K0NFLM06YC7nZAQVW003TPd9B70'

  def self.create_stripe_account(place, user)
    begin
      if user.account.nil?
        account = Stripe::Account.create({
                                             country: 'MX',
                                             type: 'express',
                                             email: user.email,
                                             requested_capabilities: %w[card_payments transfers],
                                         })

        user.account = user.create_account(account_id: account.id)
        account_id = account.id
        puts "---------CREANDO"
      else
        puts "---------RENOVANDO"
        account_id = user.account.account_id
      end
      account_link = Account.create_link(account_id)
      return account_link
    rescue => e
      puts "-----------#{e}------1"
      return nil
    end
  end

  def self.create_link(account_id)
    begin
      link = Stripe::AccountLink.create({
                                            account: account_id,
                                            refresh_url: 'http://localhost:3000/dashboard/payments/connect',
                                            return_url: 'http://localhost:3000/dashboard/payments/connect',
                                            type: 'account_onboarding',
                                        })
      return link
    rescue => e
      puts "-----------#{e}-----2"
      return nil
    end
  end

  def self.create_login_account(account_id)
    begin
      Stripe::Account.create_login_link(account_id)
    rescue
      return nil
    end
  end

end
