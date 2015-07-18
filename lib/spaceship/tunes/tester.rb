module Spaceship
  module Tunes
    class Tester < TunesBase

      # @return (String) The identifier of this tester, provided by iTunes Connect
      # @example 
      #   "60f858b4-60a8-428a-963a-f943a3d68d17"
      attr_accessor :tester_id

      # @return (String) The email of this tester
      # @example 
      #   "tester@spaceship.com"
      attr_accessor :email
      
      # @return (String) The first name of this tester
      # @example 
      #   "Cary"
      attr_accessor :first_name

      # @return (String) The last name of this tester
      # @example 
      #   "Bennett"
      attr_accessor :last_name

      # @return (Bool) The tester is testing
      # @example 
      #   true
      attr_accessor :testing

      # @return (String) The latest version installed of this tester (Only for apps methods)
      # @example 
      #   "0.2.9 (37)"
      attr_accessor :latest_build

      attr_mapping(
        'testerId' => :tester_id,
        'emailAddress.value' => :email,
        'firstName.value' => :first_name,
        'lastName.value' => :last_name,
        'testing.value' => :testing,
        'latestBuild' => :latest_build
      )

      class << self

        # @return (Hash) All urls for the ITC used for web requests
        def url
          raise "You must select a tester type. Use a subclass."
        end

        # Create a new object based on a hash.
        # This is used to create a new object based on the server response.
        def factory(attrs)
          self.new(attrs)
        end

        # @return (Array) Returns all beta testers available for this account
        def all
          client.testers(self).map { |tester| self.factory(tester) }
        end

        # @return (Spaceship::Tunes::Tester) Returns the tester matching the parameter
        #   as either the Tester id or email
        # @param identifier (String) (required): Value used to filter the tester
        def find(identifier)
          all.find do |tester|
            (tester.tester_id == identifier.to_s or tester.email == identifier)
          end
        end

        # Create new tester in iTunes Connect
        # @param email (String) (required): The email of the new tester
        # @param first_name (String) (optional): The first name of the new tester
        # @param last_name (String) (optional): The last name of the new tester
        # @example 
        #   Spaceship::Tunes::Tester.external.create!(email: "tester@mathiascarignani.com", first_name: "Cary", last_name:"Bennett")
        # @return (Tester): The newly created tester
        def create!(email: nil, first_name: nil, last_name: nil) 
          data = client.create_tester!(tester: self,
                                        email: email,
                                   first_name: first_name,
                                    last_name: last_name)
          self.factory(data)
        end

        #####################################################
        # @!group App
        #####################################################

        # @return (Array) Returns all beta testers available for this account filtered by app
        # @param app_id (String) (required): The app id to filter the testers
        def all_by_app(app_id) 
          client.testers_by_app(self, app_id).map { |tester| self.factory(tester) }
        end

        # @return (Spaceship::Tunes::Tester) Returns the tester matching the parameter
        #   as either the Tester id or email
        # @param app_id (String) (required): The app id to filter the testers
        # @param identifier (String) (required): Value used to filter the tester
        def find_by_app(app_id, identifier)
          all_by_app(app_id).find do |tester|
            (tester.tester_id == identifier.to_s or tester.email == identifier)
          end
        end

        # Add all testers to the app received
        # @param app_id (String) (required): The app id to filter the testers
        def add_all_to_app!(app_id)
          # TODO: Change to not make one request for each tester
          all.each do |tester|
            tester.add_to_app!(app_id)
          end
        end
      end

      #####################################################
      # @!group Subclasses
      #####################################################
      class External < Tester 
        def self.url(app_id = nil)
          {
            index: "ra/users/pre/ext",
            index_by_app: "ra/user/externalTesters/#{app_id}/",
            create: "ra/users/pre/create",
            delete: "ra/users/pre/ext/delete",
            update_by_app: "ra/user/externalTesters/#{app_id}/"
          }
        end
      end

      class Internal < Tester 
        def self.url(app_id = nil)
          {
            index: "ra/users/pre/int",
            index_by_app: "ra/user/internalTesters/#{app_id}/",
            create: nil,
            delete: nil,
            update_by_app: "ra/user/internalTesters/#{app_id}/"
          }
        end
      end

      # Delete current tester
      def delete! 
        client.delete_tester!(self)
      end

      #####################################################
      # @!group App
      #####################################################

      # Add current tester to list of the app testers
      # @param app_id (String) (required): The id of the application to which want to modify the list
      def add_to_app!(app_id)
        client.add_tester_to_app!(self, app_id)
      end

      # Remove current tester from list of the app testers
      # @param app_id (String) (required): The id of the application to which want to modify the list
      def remove_from_app!(app_id)
        client.remove_tester_from_app!(self, app_id)
      end
    end
  end
end