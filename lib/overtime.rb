class Overtime

  def initialize(day_type)
    @day_type = day_type
  end

  def work(labor)
    @labor = labor
    labor.work!
  end

  def getoff(labor)
    labor.getoff!
  end

  def payment
    worked_for_hours = ((@labor.worked_for_seconds) / 3600.0).round
    case @day_type
    when "平常日"
      case worked_for_hours
      when 0..2
        (@labor.salary_per_hour * worked_for_hours * 1.34).round
      when 3..4
        (@labor.salary_per_hour * 2 * 1.34).round + (@labor.salary_per_hour * (worked_for_hours - 2) * 1.67).round
      end      
    when "休息日"
      case worked_for_hours
      when 0..2
        (@labor.salary_per_hour * worked_for_hours * 1.34).round
      when 3..8
        (@labor.salary_per_hour * 2 * 1.34).round + (@labor.salary_per_hour * (worked_for_hours - 2) * 1.67).round
      when 9..12
        (@labor.salary_per_hour * 2 * 1.34).round + (@labor.salary_per_hour * 6 * 1.67).round + (@labor.salary_per_hour * (worked_for_hours - 8) * 2.67).round
      end
    when "休假日"
      case worked_for_hours
      when 0..8
        @labor.salary_per_hour * 8
      when 9..10
        (@labor.salary_per_hour * 8) + (@labor.salary_per_hour * (worked_for_hours - 8) * 2.34).round
      when 11..12
        (@labor.salary_per_hour * 8) + (@labor.salary_per_hour * 2 * 2.34).round + (@labor.salary_per_hour * (worked_for_hours - 10) * 2.67).round
      end
    when "假日時因天災、事變或突發事件"
      case worked_for_hours
      when 0..8
        @labor.salary_per_hour * worked_for_hours * 2
      when 9..10
        (@labor.salary_per_hour * 8 * 2) + (@labor.salary_per_hour * (worked_for_hours - 8) * 2.34).round
      when 11..12
        (@labor.salary_per_hour * 8 * 2) + (@labor.salary_per_hour * 2 * 2.34).round + (@labor.salary_per_hour * (worked_for_hours - 10) * 2.67).round
      end
    end
  end

end