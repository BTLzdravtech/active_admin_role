module ActiveAdmin
  class ManagedResource < ActiveRecord::Base
    self.table_name = "active_admin_managed_resources"

    has_many :permissions, dependent: :destroy
    validates :class_name, presence: true
    validates :action, presence: true

    def const
      @const ||= class_name.try(:safe_constantize)
    end

    def active?
      !const.nil?
    end

    def for_active_admin_page?
      class_name == "ActiveAdmin::Page"
    end

    class << self
      def reload
        ActiveAdmin::PermissionReloader.reload
      end

      def ransackable_attributes(auth_object = nil)
        column_names
      end

      def ransackable_associations(auth_object = nil)
        reflect_on_all_associations.map { |a| a.name.to_s }
      end
    end
  end
end
