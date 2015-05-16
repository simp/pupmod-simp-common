Facter.add("fips_enabled") do
  setcode do
    if Facter::Util::Resolution.exec("sysctl crypto.fips_enabled | grep 1").empty?
      false
    else
      true
    end
  end
end
