require 'active_support/inflector'

module JSON
  module API
    class Resource
      def to_active_record_hash(options = {})
        hash = {}
        hash.merge!(id: id) if id
        hash.merge!(attributes_for_active_record_hash(options))
        hash.merge!(relationships_for_active_record_hash(options))

        hash
      end

      private

      def attributes_for_active_record_hash(options = {})
        filter_keys(attributes_keys,
                    options[:allowed_attributes],
                    options[:forbidden_attributes])
          .map { |key| { key.to_sym => attributes.send(key) } }
          .reduce({}, :merge)
      end

      def relationships_for_active_record_hash(options = {})
        filter_keys(relationships_keys,
                    options[:allowed_relationships],
                    options[:forbidden_relationships])
          .map { |key| relationship_for_active_record_hash(key) }
          .reduce({}, :merge)
      end

      def relationship_for_active_record_hash(rel_name)
        rel = relationships.send(rel_name)
        if rel.collection?
          { "#{rel_name.singularize}_ids".to_sym => rel.data.map(&:id) }
        elsif rel.data.nil?
          { "#{rel_name}_id".to_sym => nil }
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
end

