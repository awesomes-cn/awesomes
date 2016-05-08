module DBUtils
  class SubjectOrPractice
    class << self
      def sources
        datas = YAML.load(File.open("#{Rails.root}/lib/data/subjects_or_practices.yml")).symbolize_keys
        datas.try :[], :categories
      end

      def fetch_subjects
        sources.select { |subject| subject['typcd']=='A' }
      end

      def fetch_practices
        sources.select { |practice| practice['typcd']=='B' }
      end
    end
  end
end

namespace :db do
  namespace :subject do
    desc 'create or update subject'
    task :create_or_update, [:clear] => [:environment] do |_, args|
      puts 'build subject data --> '
      Captain::Subject.delete_all if args[:clear].present?

      subjects = DBUtils::SubjectOrPractice.fetch_subjects
      container_size = subjects.size

      subjects.each_with_index do |obj, index|
        obj.symbolize_keys!
        obj[:code] = obj[:code].downcase
        access_attr = obj.slice(:name, :code, :desc, :icon)

        puts "[#{index}/#{container_size}] #{obj[:name]} !"
        Captain::Subject.find_or_create_by access_attr do |db_subject_object|
          db_subject_object.update_attributes access_attr
        end
      end
    end
  end
  namespace :practice do
    desc 'create or update practice'
    task :create_or_update, [:clear] => [:environment] do |_, args|
      puts 'build practice data --> '
      Captain::Practice.delete_all if args[:clear].present?

      practices = DBUtils::SubjectOrPractice.fetch_practices

      subject_code_id_maps = Captain::Subject.all.each_with_object({}) do |subject, container|
        container[subject.code] = subject.id
      end
      practice_count = practices.size
      practices.each_with_index do |practice, index|
        index+=1
        practice.symbolize_keys!
        subject_code = practice[:parent].downcase
        subject_db_id = subject_code_id_maps.try :[], subject_code

        if subject_db_id.present?
          practice_attr = practice.slice(:name, :code, :desc, :icon)
          practice_attr.merge! subject_id: subject_db_id

          puts "[#{index}/#{practice_count}] #{practice_attr[:name]} !"
          Captain::Practice.find_or_create_by practice_attr do |db_practice|
            db_practice.update_attributes practice_attr
          end
        end
      end
    end
  end

  desc 'init subject and practice data'
  task :init_subject_and_practice, [:clear] => %w(subject:create_or_update practice:create_or_update) do
    puts '--> done!'
  end
end