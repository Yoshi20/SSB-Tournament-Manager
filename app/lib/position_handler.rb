module PositionHandler

  def swap_position_with(record)
    return false unless self.respond_to?(:position)
    ok = true
    pos1 = self.position
    pos2 = record.position
    begin
      ActiveRecord::Base.transaction do
        self.update!(position: pos2)
        record.update!(position: pos1)
      end
    rescue # must be outside of Base.transaction to make sure everything is rolled back
      ok = false
    end
    return ok
  end

  def move_position_up(records)
    return false unless self.respond_to?(:position)
    return true unless records.any?
    next_record = nil
    next_pos = self.position + 1
    last_record_pos = records.order(:position, :created_at).last.position
    while next_record.nil? && next_pos <= last_record_pos
      next_record = records&.find_by(position: next_pos)
      next_pos = next_pos + 1
    end
    return next_record.present? ? self.swap_position_with(next_record) : true
  end

  def move_position_down(records)
    return false unless self.respond_to?(:position)
    return true if self.position == 0
    next_record = nil
    next_pos = self.position - 1
    while next_record.nil? && next_pos >= 0
      next_record = records&.find_by(position: next_pos)
      next_pos = next_pos - 1
    end
    return next_record.present? ? self.swap_position_with(next_record) : true
  end

end
