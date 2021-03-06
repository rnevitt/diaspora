#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class Profile
  include MongoMapper::EmbeddedDocument
  require File.join(Rails.root, 'lib/diaspora/webhooks')
  include Diaspora::Webhooks
  include ROXML

  xml_reader :first_name
  xml_reader :last_name
  xml_reader :image_url
  xml_reader :birthday
  xml_reader :gender
  xml_reader :bio
  xml_accessor :diaspora_handle

  key :first_name, String
  key :last_name,  String
  key :image_url,  String
  key :birthday,   Date
  key :gender,     String
  key :bio,        String
  key :diaspora_handle, String

  after_validation :strip_names
  validates_length_of :first_name, :maximum => 32
  validates_length_of :last_name, :maximum => 32

  before_save :strip_names

  def person
    self._parent_document
  end

  def diaspora_handle
    #get the parent diaspora handle, unless we want to access a profile without a person
    (self._parent_document) ? self.person.diaspora_handle : self[:diaspora_handle]
  end

  protected

  def strip_names
    self.first_name.strip! if self.first_name
    self.last_name.strip! if self.last_name
  end
end
