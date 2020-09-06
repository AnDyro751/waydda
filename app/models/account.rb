class Account
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  field :account_id, type: String, default: ""
  field :completed, type: Boolean, default: false
  # Stripe key
  # TODO: Enviar a secret
  Stripe.api_key = 'sk_test_51H9CZeBOcPJ0nbHctTzfQZhFXBnn8j05e0xqJ5RSVz5Bum72LsvmQKIecJnsoHISEg0jUWtKjERYGeCAEWiIAujP00Fae9MiKm'


  def self.get_price(free_days:, price:)
    if Rails.env === "development"
      if price == 229
        if free_days === 30
          return "price_1HNmjCBOcPJ0nbHcDOPnmdPR"
        elsif free_days === 14
          return "price_1HNmioBOcPJ0nbHcNEhtQXao"
        elsif free_days === 7
          return "price_1HNmiLBOcPJ0nbHce9Dg9vYj"
        else
          return nil
        end
      elsif price == 129
        if free_days == 30
          return "price_1HNmhxBOcPJ0nbHcObBcFqIu"
        elsif free_days == 14
          return "price_1HNmhhBOcPJ0nbHciN5H6YaT"
        elsif free_days == 7
          return "price_1HNmhNBOcPJ0nbHc3bf1aAeX"
        else
          return nil
        end
      elsif price == 69
        if free_days == 30
          return "price_1HNmgIBOcPJ0nbHcaweGnfsr"
        elsif free_days == 14
          return "price_1HNmgIBOcPJ0nbHcrsn0bmBC"
        elsif free_days == 7
          return "price_1HNmgIBOcPJ0nbHcAt2FBrs9"
        end
      else
        return nil
      end

    else

    end
  end

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

  def self.update_account_hook(account_updated)
    current_account = Account.find_by(account_id: account_updated["id"])
    unless current_account.nil?
      if account_updated["details_submitted"]
        unless current_account.completed
          puts "----------ACTUALIZANDO A COMPLETED"
          current_account.update(completed: true)
        end
      else
        if current_account.completed
          puts "----------ACTUALIZANDO A NOOOO COMPLETED"
          current_account.update(completed: false)
        end
      end
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

  def self.update_account(customer_id, data = {})
    begin
      current_account = Stripe::Customer.update(
          customer_id, data,
      )
      return {success: true, account: current_account}
    rescue => e
      puts "ERROR AL ACTuALIAR #{e}"
      return {success: false, account: nil}
    end
  end

  def self.create_source(customer_id, token)
    begin
      source = Stripe::Customer.create_source(
          customer_id,
          {source: token},
      )
      return source
    rescue => e
      puts "----------#{e}---CREATE SOURCE"
      return nil
    end
  end

end
