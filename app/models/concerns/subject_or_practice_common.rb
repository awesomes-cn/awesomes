module SubjectOrPracticeCommon
  extend ActiveSupport::Concern

  included do

    validates :name, presence: true
    validates :code, presence: true, uniqueness: true

    before_create :before_create_callback

    def before_create_callback
      downcase_code
    end

    def downcase_code
      self.code = self.code.downcase
    end

  end

end