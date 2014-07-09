module CanCan
  # For use with Inherited Resources
  class InheritedResource < ControllerResource # :nodoc:
    def load_resource_instance
      Rails.logger.debug "CC: loading resource instance"
      Rails.logger.debug "CC: new actions: #{new_actions}"
      Rails.logger.debug "CC: params action: #{@params[:action]}"
      Rails.logger.debug "CC: id_param: #{id_param}"
      Rails.logger.debug "CC: controller association_chain: #{@controller.send(:association_chain)}"

      if parent?
        Rails.logger.debug "CC: parent has been found"
        @controller.send :association_chain
        @controller.instance_variable_get("@#{instance_name}")
      elsif new_actions.include? @params[:action].to_sym
        Rails.logger.debug "CC: appears to be a new action (#{@params[:action]})"
        resource = @controller.send :build_resource
        assign_attributes(resource)
      else
        @controller.send :resource
      end
    end

    def resource_base
      Rails.logger.debug "CC: in resource base... controller end_of_association_chain: #{@controller.send(:end_of_association_chain)}"
      @controller.send :end_of_association_chain
    end
  end
end
