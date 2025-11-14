class ChangePrefectureIdNullableInBreweries < ActiveRecord::Migration[7.2]
  def change
    change_column_null :breweries, :prefecture_id, true
  end
end
