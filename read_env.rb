def read_env(name, converter: nil, secret: false)
  value = ENV[name]
  abort "Environment variable #{name} is illegal or empty" unless value.present?

  if converter.nil?
    value
  else
    begin
      value.send(converter)
    rescue
      abort 'Environment variable is illegal'
    end
  end

  puts "#{name}: #{secret ? '*****' : value}"

  value
end
