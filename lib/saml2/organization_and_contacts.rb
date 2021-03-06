require 'saml2/contact'
require 'saml2/organization'

module SAML2
  module OrganizationAndContacts
    attr_writer :organization, :contacts

    def initialize
      @organization = nil
      @contacts = []
    end

    def from_xml(node)
      remove_instance_variable(:@organization)
      @contacts = nil
      super
    end

    def organization
      unless instance_variable_defined?(:@organization)
        @organization = Organization.from_xml(xml.at_xpath('md:Organization', Namespaces::ALL))
      end
      @organization
    end

    def contacts
      @contacts ||= load_object_array(xml, 'md:ContactPerson', Contact)
    end

    protected

    def build(builder)
      organization.build(builder) if organization
      contacts.each do |contact|
        contact.build(builder)
      end
    end
  end
end
