Puppet::Type.newtype(:sensu_handler_config) do
  @doc = ""

  def initialize(*args)
    super

    self[:notify] = [
      "Service[sensu-server]",
    ].select { |ref| catalog.resource(ref) }
  end

  ensurable do
    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    defaultto :present
  end

  newparam(:name) do
    desc "The name of the handler"
  end

  newproperty(:type) do
    desc ""
  end

  newproperty(:command) do
    desc ""
  end

  autorequire(:package) do
    ['sensu']
  end
end
