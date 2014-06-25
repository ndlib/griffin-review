class UpdateSakaiCache < ActiveRecord::Migration
  def change

    remove_column :sakai_context_cache, :user_id
    remove_column :sakai_context_cache, :external_id

    SakaiContextCache.delete_all
    SakaiContextCache.create(context_id: '3748467f-d1e5-4085-a34e-8481e9047c78', course_id: '12345678_54321_LR')
    SakaiContextCache.create(context_id: '233d6645-17df-478e-b4f8-e44ec27e9a0d', course_id: '12345678_54321_LR')
    SakaiContextCache.create(context_id: 'd2bc0367-fa8d-4414-a53f-a6c9a1172ab9', course_id: '12345678_54321_LR')
  end
end
