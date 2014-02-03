# monkey patch functionally similar to the one provided by ActiveSupport
class Hash
  # recursively symolizes keys in a Hash that are strings
  # does not modify the original hash; returns a new hash
  def symbolize_keys
    self.to_a.reduce({}) do |acc, (key, val)|
      val = symbolize_keys(val) if val.is_a?(Hash)
      key = key.to_sym if key.is_a?(String)
      acc[key] = val
      acc
    end
  end
end
