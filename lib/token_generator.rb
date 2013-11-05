module TokenGenerator
  def generate_token(name, secure_random_method = :hex)
    define_method "generate_#{name}" do
      send(name) || loop do
        random = SecureRandom.send(secure_random_method)
        break send("#{name}=", random) unless self.class.where(name => random).exists?
      end
    end
    before_validation "generate_#{name}"
  end
end
