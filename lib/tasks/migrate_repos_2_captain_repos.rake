namespace :db do
  namespace :repos do

    desc 'migrate old repos to captain repos'
    task :migrate do
      puts 'migrate old repos to captain repos --> '
      subject_id_code_maps = Captain::Subject.all.each_with_object({}) do |subject, container|
        container[subject.id] = subject.code
      end
      practice_code_ip_maps = Captain::Practice.all.each_with_object({}) do |practice, container|
        subject_code = subject_id_code_maps[practice.subject_id]
        next if subject_code.blank?
        code_key = "#{practice.code}_#{subject_code}"
        container[code_key] = practice.id
      end

      unless practice_code_ip_maps.empty?
        old_repos_count = Repo.count
        Repo.all.each_with_index do |repo, index|
          puts "[#{index+1}/#{old_repos_count}] #{repo.name}"
          attributes= repo.attributes.symbolize_keys
          slice_attrs = attributes.slice(:name, :html_url, :description, :typcd, :rootyp)
          code_key = "#{slice_attrs[:typcd].downcase}_#{slice_attrs[:rootyp].downcase}"
          practice_id = practice_code_ip_maps[code_key]

          next if practice_id.blank?

          assign_repo_attrs = {name: slice_attrs[:name], status: Captain::Repo::Status::WAIT_TO_APPROVE, url: slice_attrs[:html_url], practice_id: practice_id}
          Captain::Repo.find_or_create_by assign_repo_attrs do |captain_repo|
            captain_repo.update_attributes assign_repo_attrs
          end

        end
      end
    end

  end
end