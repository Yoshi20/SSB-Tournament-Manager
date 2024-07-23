module Currency

  def self.hash # Currency::hash['chf'.to_sym] > 'CHF'
    {
      chf: 'CHF',
      eur: '€',
      gbp: '£', # 1% additional fee by payout for Swiss bank accounts
      # isk: 'kr', # not supported by Stripe for Swiss bank accounts
    }
  end

end
