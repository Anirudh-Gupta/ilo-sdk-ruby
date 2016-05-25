module ILO_SDK
  # Contains helper methods for Account Service actions
  module Account_Service_Helper
    # Get the HREF for a user with a specific username
    # @param [String, Symbol] uri
    # @param [String, Symbol] username
    # @raise [RuntimeError] if the request failed
    # @return [String] userhref
    def userhref(uri, username)
      response = rest_get(uri)
      items = response_handler(response)['Items']
      items.each do |it|
        return it['links']['self']['href'] if it['UserName'] == username
      end
    end

    # Get the users
    # @raise [RuntimeError] if the request failed
    # @return [String[]] users
    def get_users
      response = rest_get('/redfish/v1/AccountService/Accounts/')
      response_handler(response)['Items'].collect { |user| user['UserName'] }
    end

    # Create a user
    # @param [String, Symbol] username
    # @param [String, Symbol] password
    # @raise [RuntimeError] if the request failed
    # @return true
    def create_user(username, password)
      new_action = { 'UserName' => username, 'Password' => password, 'Oem' => { 'Hp' => { 'LoginName' => username } } }
      response = rest_post('/redfish/v1/AccountService/Accounts/', body: new_action)
      response_handler(response)
      true
    end

    # Change the password for a user
    # @param [String, Symbol] username
    # @param [String, Symbol] password
    # @raise [RuntimeError] if the request failed
    # @return true
    def change_password(username, password)
      new_action = { 'Password' => password }
      userhref = userhref('/redfish/v1/AccountService/Accounts/', username)
      response = rest_patch(userhref, body: new_action)
      response_handler(response)
      true
    end

    # Delete a specific user
    # @param [String, Symbol] username
    # @raise [RuntimeError] if the request failed
    # @return true
    def delete_user(username)
      userhref = userhref('/redfish/v1/AccountService/Accounts/', username)
      response = rest_delete(userhref)
      response_handler(response)
      true
    end
  end
end
