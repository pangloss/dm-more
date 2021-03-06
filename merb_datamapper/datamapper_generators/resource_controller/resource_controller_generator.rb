class ResourceControllerGenerator < Merb::GeneratorBase

  attr_reader :controller_class_name,
              :controller_file_name,
              :controller_base_path,
              :controller_modules,
              :model_class_name,
              :full_controller_const,
              :singular_model,
              :plural_model,
              :properties

  def initialize(args, runtime_args = {})
    @base = File.dirname(__FILE__)

    super

    name = args.shift
    nfp  = name.snake_case.gsub("::", "/").split("/")

    @model_class_name = nfp.pop.singularize.to_const_string
    @model_class_name = runtime_args[:model_class_name] if runtime_args[:model_class_name]
    @singular_model   = @model_class_name.snake_case
    @plural_model     = @singular_model.pluralize

    nfp << @plural_model

    @controller_file_name = nfp.join("/")

    # Need to setup the directories
    unless @controller_file_name == File.basename(@controller_file_name)
      @controller_base_path = controller_file_name.split("/")[0..-2].join("/")
    end

    @controller_modules    = @controller_file_name.to_const_string.split("::")[0..-2]
    @controller_class_name = @controller_file_name.to_const_string.split("::").last

    @full_controller_const = ((@controller_modules.dup || []) << @controller_class_name).join("::")

    # Gets the properties of the model
    # FIXME: the model file needs to be required
    @properties = if Object.const_defined?(@model_class_name)
      model_class = Object.const_get(@model_class_name)
      model_class.properties if model_class.respond_to?(:properties)
    else
      []
    end
  end

  def manifest
    record do |m|
      @m = m

      # Create the controller directory
      m.directory File.join("app/controllers", controller_base_path) if controller_base_path

      # Create the helpers directory
      m.directory File.join("app/helpers", controller_base_path) if controller_base_path

      @assigns =  {
                    :controller_modules         => controller_modules,
                    :controller_class_name      => controller_class_name,
                    :controller_file_name       => controller_file_name,
                    :controller_base_path       => controller_base_path,
                    :full_controller_const      => full_controller_const,
                    :model_class_name           => model_class_name,
                    :singular_model             => singular_model,
                    :plural_model               => plural_model,
                    :properties                 => properties
                  }
      copy_dirs
      copy_files

      m.dependency "merb_resource_controller_test", [@controller_class_name], @assigns
    end
  end

  # methods used by the templates

  def field_from_type(type)
    case type.name.to_sym
    when :String
      "text_control"
    when :TrueClass
      "checkbox_control"
    when :"DataMapper::Types::Text"
      "text_area_control"
    else
      "text_control"
    end
  end

  #returns the params needed for getting the object.
  # uses params[:id] as a default if no keys has been set in the model.
  def params_for_get
    params = properties.select{|p| p.key?}.map{|p| "params[:#{p.field}]"}.join(', ')
    @params_for_get ||= (params == "" ? "params[:id]" : params)
  end


  protected
  def banner
    <<-EOS.split("\n").map{|x| x.strip}.join("\n")
      Creates a basic Merb resource controller.

      USAGE: #{spec.name} my_resource
    EOS
  end
end
