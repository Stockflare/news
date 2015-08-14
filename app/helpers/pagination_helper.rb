module PaginationHelper
  FORMAT = '%d-%m-%Y'

  def day
    date.strftime(FORMAT)
  end

  def previous_day
    (date - 60*60*24).strftime(FORMAT)
  end

  def next_day
    (date + 60*60*24).strftime(FORMAT)
  end

  def is_tomorrow?
    Time.parse(next_day) > Time.now.beginning_of_day
  end

  private

  def date
    @date
  end
end
