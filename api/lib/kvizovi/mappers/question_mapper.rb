require "kvizovi/mappers/base_mapper"

module Kvizovi
  module Mappers
    class QuestionMapper < BaseMapper
      attributes :id, :type, :title, :content, :image, :hint, :position
    end
  end
end
