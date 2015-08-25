module PaginationHelper
  FORMAT = '%d-%m-%Y'

  def with_date(date)
    @date = date
  end

  def day
    @date.strftime(FORMAT)
  end

  def previous_day
    (@date - 60*60*24).strftime(FORMAT)
  end

  def next_day
    (@date + 60*60*24).strftime(FORMAT)
  end

  def is_tomorrow?
    Time.parse(next_day) > Time.now.beginning_of_day
  end

  def day_display
    @date = Time.parse(@date) if @date.is_a? String
    @date.strftime("#{@date.day.ordinalize} %B %Y")
  end
end
