module YamlSettings
  module Utils

    def merge_hashes(hash, other_hash)
      hash.merge(other_hash) do |key, oldval, newval|
        oldval.is_a?(Hash) && newval.is_a?(Hash) ? self.merge_hashes(oldval, newval) : newval
      end
    end
    module_function :merge_hashes

  end
end
