require 'active_support/inflector'

module JsonApiParser
  module Rails
    module_function

    def to_active_record_hash(hash, options = {})
      # TODO(lucas): add options back to parse()
      resource_to_active_record_hash(JsonApiParser.parse(hash).data,
                                     options)
    end

    def resource_to_active_record_hash(resource, options = {})
      hash = {}
      hash.merge!(id: resource.id) if resource.id
      hash.merge!(attributes_for_active_record_hash(resource, options))
      hash.merge!(relationships_for_active_record_hash(resource, options))

      hash
    end

    def attributes_for_active_record_hash(resource, options = {})
      filter_keys(resource.attributes_keys,
                  options[:allowed_attributes],
                  options[:forbidden_attributes])
        .map { |key| { key.to_sym => resource.attributes.send(key) } }
        .reduce({}, :merge)
    end

    def relationships_for_active_record_hash(resource, options = {})
      filter_keys(resource.relationships_keys,
                  options[:allowed_relationships],
                  options[:forbidden_relationships])
        .map { |key| [key, resource.relationships.send(key)] }
        .map { |key, rel| relationship_to_active_record_hash(key, rel) }
        .reduce({}, :merge)
    end

    def relationship_to_active_record_hash(rel_name, rel)
      if rel.collection?
        { "#{rel_name.singularize}_ids".to_sym => rel.data.map(&:id) }
      else
        { "#{rel_name}_id".to_sym => rel.data.id }
      end
    end

    def filter_keys(keys, allowed, forbidden)
      keys.select do |key|
        (allowed.nil? || allowed.include?(key)) &&
          forbidden.nil? || !forbidden.include?(key)
      end
    end
  end
end
