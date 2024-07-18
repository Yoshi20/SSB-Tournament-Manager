module Currency

  def self.hash # Currency::hash['chf'.to_sym] > 'CHF'
    {
      chf: 'CHF',
      eur: '€',
      gbp: '£',
      isk: 'kr',
    }
  end

end
