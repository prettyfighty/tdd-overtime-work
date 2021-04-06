class Labor

  def initialize(salary)
    @salary = salary
    @salary_per_hour = (@salary / 30 / 8.0).round
  end

  def work!
    @work_at = Time.now
    @getoff_at = nil
  end

  def getoff!
    @getoff_at = Time.now
  end

  def off?
    @getoff_at != nil
  end

  def worked_for_seconds
    if off?
      (@getoff_at - @work_at).to_i
    else
      (Time.now - @work_at).to_i
    end
  end

  def salary_per_hour
    (@salary / 30 / 8.0).round
  end

end