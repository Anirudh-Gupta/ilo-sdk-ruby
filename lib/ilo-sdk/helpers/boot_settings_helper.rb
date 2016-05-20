module ILO_SDK
  # Contains helper methods for Boot Settings actions
  module Boot_Settings_Helper
    # Get the boot base config
    # @raise [RuntimeError] if the request failed
    # @return [Fixnum] bios_baseconfig
    def get_boot_baseconfig
      response = rest_get('/redfish/v1/Systems/1/bios/Boot/Settings/')
      response_handler(response)['BaseConfig']
    end

    # Revert the boot
    # @raise [RuntimeError] if the request failed
    # @return true
    def revert_boot
      new_action = { 'BaseConfig' => 'default' }
      response = rest_patch('/redfish/v1/systems/1/bios/Boot/Settings/', body: new_action)
      response_handler(response)
      true
    end

    # Get the boot order
    # @raise [RuntimeError] if the request failed
    # @return [Fixnum] current_boot_order
    def get_boot_order
      response = rest_get('/redfish/v1/systems/1/bios/Boot/Settings/')
      response_handler(response)['PersistentBootConfigOrder']
    end

    # Set the boot order
    # @param [Fixnum] boot_order
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_boot_order(boot_order)
      new_action = { 'PersistentBootConfigOrder' => boot_order }
      response = rest_patch('/redfish/v1/systems/1/bios/Boot/Settings/', body: new_action)
      response_handler(response)
      true
    end

    # Get the temporary boot order
    # @raise [RuntimeError] if the request failed
    # @return [Fixnum] temporary_boot_order
    def get_temporary_boot_order
      response = rest_get('/redfish/v1/Systems/1/')
      response_handler(response)['Boot']['BootSourceOverrideTarget']
    end

    # Set the temporary boot order
    # @param [Fixnum] boot_target
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_temporary_boot_order(boot_target)
      response = rest_get('/redfish/v1/Systems/1/')
      boottargets = response_handler(response)['Boot']['BootSourceOverrideSupported']
      unless boottargets.include? boot_target
        raise "BootSourceOverrideTarget value - #{boot_target} is not supported. Valid values are: #{boottargets}"
      end
      new_action = { 'Boot' => { 'BootSourceOverrideTarget' => boot_target } }
      response = rest_patch('/redfish/v1/Systems/1/', body: new_action)
      response_handler(response)
      true
    end
  end
end
