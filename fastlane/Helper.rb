def absolute_path(path)
  path = File.join(Dir.pwd, path) unless path.start_with?("/")
  return File.absolute_path(path)
end

def get_required_option(options, opt, lane_name, validate = [])
  if options[opt].nil? || options[opt].empty?
    UI.user_error!("No '#{opt}' option specified to '#{lane_name}' lane, pass using '#{opt}:value'")
  end
  value = options[opt]
  if !validate.empty? && !validate.include?(value)
    value = value.to_s.tr(":", "").to_sym
    if !validate.include?(value)
      UI.user_error!("Invalid option '#{value}' - must be one of: #{validate}")
    end
  end
  return value
end
