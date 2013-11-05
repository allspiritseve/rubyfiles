module Authentication
  module Model
    def self.included(base)
      base.has_secure_password
      base.before_validation :generate_activation_token, unless: :activated?
    end

    def activated?
      activated_at.present?
    end

    def activate
      self.activated_at ||= Time.now
    end

    def activate!
      activate and save!
    end

    def deactivate
      self.activated_at = nil
    end

    def deactivate!
      deactivate and save!
    end

    def generate_activation_token
      self.activation_token ||= loop do
        random = SecureRandom.hex
        break random unless self.class.where(:activation_token => random).exists?
      end
    end
  end
end
