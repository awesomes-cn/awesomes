module DBUtils
  class GithubRepo
    class << self
      def build_repo_doc(attributes, github_repo)
        puts '--> build repo_doc'
        assign_repo_doc_attr = {readme_en: attributes[:about], readme_zh: attributes[:about_zh], repo_id: github_repo.try(:id)}
        Captain::GithubRepoDoc.create assign_repo_doc_attr
      end

      def build_github_repo(attributes)
        puts '--> build github_repo'
        github_repos_attr = attributes.slice(:name, :full_name, :alia, :description, :homepage,
                                             :stargazers_count, :forks_count, :subscribers_count)
        github_repos_attr.merge!({favicon: attributes[:cover],

                                  repo_pushed_at: attributes[:pushed_at],
                                  repo_created_at: attributes[:github_created_at]})
        Captain::GithubRepo.find_or_create_by(name: github_repos_attr[:name], full_name: github_repos_attr[:full_name]) do |github_repo|
          github_repo.update_attributes github_repos_attr
        end
      end

      def build_repo(slice_attrs, practice_id)
        puts '--> build repo'
        assign_repo_attrs = {name: slice_attrs[:name], status: Captain::Repo::Status::WAIT_TO_APPROVE,
                             url: slice_attrs[:html_url], practice_id: practice_id}
        Captain::Repo.find_or_create_by assign_repo_attrs
      end
    end
  end
end

namespace :db do
  namespace :repos do
    desc 'migrate old repos to captain repos'
    task :migrate, [:clear] => [:environment] do |_, args|
      start_time = Time.current
      puts "[#{start_time}] migrate old repos to captain repos --> "
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
        if args[:clear].present?
          Captain::Repo.delete_all
          Captain::GithubRepo.delete_all
          Captain::GithubRepoDoc.delete_all
          Captain::GithubRepoOwner.delete_all
        end

        old_repos_count = Repo.count
        Repo.all.each_with_index do |repo, index|
          puts "[#{index+1}/#{old_repos_count}] #{repo.name}"

          attributes= repo.attributes.symbolize_keys
          slice_attrs = attributes.slice(:name, :html_url, :description, :typcd, :rootyp)

          code_key = "#{slice_attrs[:typcd].downcase}_#{slice_attrs[:rootyp].downcase}"
          practice_id = practice_code_ip_maps[code_key]

          next if practice_id.blank?

          #build repos base data
          DBUtils::GithubRepo.build_repo slice_attrs, practice_id

          #build github repos data
          github_repo = DBUtils::GithubRepo.build_github_repo attributes

          #build github repo doc data
          DBUtils::GithubRepo.build_repo_doc attributes, github_repo

        end
      end
      end_time = Time.current
      puts "[#{end_time}] Total cast: (#{((end_time - start_time) / 60).round 2}) minutes"
    end

  end
end