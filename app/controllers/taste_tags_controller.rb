class TasteTagsController < ApplicationController
  def autocomplete
    query = params[:q].to_s.strip

    results =
      if query.present?
        TasteTag.where("name ILIKE ?", "%#{query}%")
           .limit(5)
           .pluck(:name)
      else
        []
      end
    render json: results
  end
end
