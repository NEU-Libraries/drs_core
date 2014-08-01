module DrsCore::Services
  class QueryService 

    attr_accessor :pid, :class_name

    def initialize(pid, class_name)
      self.pid = pid
      self.class_name = class_name 
    end

    # Assuming a well formed graph of Projects/Collections/CoreRecords
    # Returns the immediate descendents of this pid and class name
    def get_children(opts = {})
      query_with_models(:all, opts)
    end

    def get_descendents(opts = {}) 
      recursive_query_with_models(:all, opts) 
    end

    def get_child_records(opts = {})
      query_with_models(:records, opts)
    end

    def get_descendent_records(opts = {})
      opts = initialize_opts opts 
      qr = recursive_query_with_models(:all, :return_as => :query_result)

      models = model_array(:records)

      qr.keep_if { |r| models.include? r["active_fedora_model_ssi"] }

      parse_return_statement(opts[:return_as], qr)
    end

    def get_child_collections(opts = {}) 
      query_with_models(:collections, opts) 
    end

    def get_descendent_collections(opts = {})
      recursive_query_with_models(:collections, opts) 
    end

    protected 

    def query_with_models(model_types, opts = {})
      models = model_array(model_types)
      if models.any?
        opts = initialize_opts opts

        models = models.map{ |x| "\"#{x}\"" }.join(" OR ")
        models = "active_fedora_model_ssi:(#{models})"

        full_pid         = "\"info:fedora/#{pid}\""
        member_of        = "is_member_of_ssim:#{full_pid}"
        affiliation_with = "has_affiliation_ssim:#{full_pid}"

        query   = "#{models} AND (#{member_of} OR #{affiliation_with})"
        results = ActiveFedora::SolrService.query(query, rows: 999) 

        parse_return_statement(opts[:return_as], results)
      else
        return []
      end
    end

    private

    def recursive_query_with_models(model_types, opts) 
      opts = initialize_opts opts 

      results = query_with_models(model_types, :return_as => :query_result)

      results.each do |r|
        id    = r["id"]
        model = r["active_fedora_model_ssi"]
        qs    = QueryService.new(id, model)
        more_kids = qs.query_with_models(model_types, :return_as => :query_result)
        results.push(*more_kids)
      end

      parse_return_statement(opts[:return_as], results) 
    end

    def initialize_opts(opts)
      opts = opts.with_indifferent_access
      opts[:return_as] ||= :query_result
      return opts
    end

    def parse_return_statement(opt, results)
      if opt == :query_result
        return results 
      elsif opt == :models 
        results.map! do |result| 
          ActiveFedora::Base.find(result["id"], cast: true) 
        end
      elsif opt == :solr_document
        raise "Not implemented yet srry" 
      else
        raise "Invalid option passed" 
      end
    end

    def model_array(type)
      const = class_name.constantize 

      records = []
      folders = []

      check = Proc.new do |x, y| 
        const.constants.include?(x) && y.include?(type)
      end

      if check.call(:CORE_RECORD_CLASSES, [:records, :all])
        records = const::CORE_RECORD_CLASSES 
      end

      if check.call(:FOLDER_CLASSES, [:collections, :all])
        folders = const::FOLDER_CLASSES 
      end

      return records + folders
    end
  end
end