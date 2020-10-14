class CreateMovie
  attr_reader :vote_count,
              :id,
              :genres,
              :title,
              :vote_average,
              :overview,
              :release_date,
              :runtime
  def initialize(attributes)
    @vote_count = attributes[:vote_count]
    @id = attributes[:id]
    @genres = attributes[:genres].map { |numb| numb[:name] } if !attributes[:genres].nil?
    @title = attributes[:title]
    @vote_average = attributes[:vote_average]
    @overview = attributes[:overview]
    @release_date = attributes[:release_date]
    @runtime = attributes[:runtime]
  end
end
