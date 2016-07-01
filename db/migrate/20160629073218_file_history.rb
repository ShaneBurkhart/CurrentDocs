class FileHistory < ActiveRecord::Migration
  def up
  	create_table(:plan_records) do |t|
  		t.string :plan_name
  		t.string :filename
  		t.integer  :plan_id, :null => false
  		t.integer  :job_id
	    t.datetime :created_at,                             :null => false
	    t.datetime :updated_at,                             :null => false
	    t.integer  :plan_num
	    t.string   :plan_record_file_name
	    t.string   :plan_record_content_type
	    t.integer  :plan_record_file_size
	    t.datetime :plan_updated_at
	    t.string   :tab,               :default => "Plans"
	    t.string   :csi
  	end
  end

  def down
  	drop_table :plan_records
  end
end
