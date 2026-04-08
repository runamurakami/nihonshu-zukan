class ChangeActiveStorageRecordIdToUuid < ActiveRecord::Migration[7.2]
  def change
    add_column :active_storage_attachments, :record_id_tmp, :uuid

    remove_column :active_storage_attachments, :record_id

    rename_column :active_storage_attachments, :record_id_tmp, :record_id
  end
end
