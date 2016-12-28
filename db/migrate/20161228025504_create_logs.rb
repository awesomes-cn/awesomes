class CreateLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :logs do |t|
      t.string :typcd  #日志类型  Task  任务
      t.string :key    #日志小类类型  RepoTrend 趋势
      t.string :title  #日志标题
      t.string :state  #状态   on 进行中  success 成功  error 失败

      t.datetime :begtime #开始时间
      t.datetime :endtime #结束时间
      t.integer :timespend #耗时


      t.timestamps
    end
  end
end
