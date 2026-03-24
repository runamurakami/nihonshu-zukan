class BreweriesController < ApplicationController
  def autocomplete
    query = params[:q].to_s.strip

    results =
      if query.present?
        Brewery.where("name ILIKE ?", "%#{query}%")
               .limit(5)
               .pluck(:name)
      else
        []
      end
    render json: results
  end
end
