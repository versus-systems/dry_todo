class Pager
  attr_reader :collection, :page_size

  def initialize collection, page, page_size
    @page = (page || 1).to_i
    @collection = collection
    @page_size = (page_size || 25).to_i
    @page_size = 25 if @page_size < 1
  end

  def results
    collection.limit(page_size).offset(offset)
  end

  def total_count
    @total_count ||= collection.count
  end

  def total_page_count
    @total_page_count ||= [(total_count.to_f / page_size).ceil, 1].max
  end

  def page
    [total_page_count, @page].min
  end

  def offset
    [(page - 1) * page_size, 0].max
  end
end
