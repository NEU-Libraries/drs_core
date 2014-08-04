module DrsCore::SolrDocumentBehavior
  include DrsCore::Concerns::Traversals

  #-----------------------
  # Mods Datastream Stuff 
  #-----------------------

  def title
    unique_read "title_ssi"
  end

  def description
    unique_read "abstract_tesim"
  end

  def non_sort
    unique_read "title_info_non_sort_tesim"
  end

  def authorized_keywords 
    Array(self["subject_sim"]) 
  end

  def keywords 
    Array(self["subject_topic_tesim"]) 
  end

  def creators
    Array(self["creator_tesim"])
  end

  #-----------------------------
  # Properties Datastream Stuff
  #-----------------------------

  def depositor
    unique_read "depositor_tesim" 
  end

  def in_progress?
    unique_read("in_progress_tesim") == "yes" 
  end

  def canonical? 
    unique_read("canonical_tesim") == "yes" 
  end

  def thumbnail_list 
    Array(self["thumbnail_list_tesim"]) 
  end

  def parent_id 
    unique_read "parent_id_tesim" 
  end

  #-------------------
  # Permissions Stuff
  #-------------------

  def read_groups
    Array(self[Ability.read_group_field])
  end

  def read_people
    Array(self[Ability.read_people_field])
  end

  def edit_groups
    Array(self[Ability.edit_groups_field])
  end

  def edit_people
    Array(self[Ability.edit_people_field])
  end

  def is_public?
    read_groups.include? 'public'
  end

  def is_registered?
    read_groups.include? 'registered' 
  end

  def is_private?
    !is_public? && !is_registered?
  end

  #---------
  # Helpers
  #---------

  def unique_read(field_name, default = '')
    val = Array(self[field_name]).first 
    val.present? val ; default
  end
end