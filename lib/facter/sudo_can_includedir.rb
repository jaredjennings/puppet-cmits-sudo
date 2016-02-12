Facter.add('sudo_can_includedir') do
  setcode do
    cmd = "sudo -V"
    v_output = begin
                 Facter::Core::Execution.execute(cmd)
               rescue NameError
                 # older facter versions
                 Facter::Util::Resolution.exec(cmd)
               end
    answer = nil
    v_output.each_line do |line|
      if line =~ /^Sudo version (.*)$/i
        version_string = $1
        if version_string =~ /^[0-9.p]*/
          numbers = version_string.split(/[.p]/).map {|x| x.to_i}
          # sudo version 1.7.2 is the first that can #includedir.
          # compare the version numbers.
          too_old = false
          numbers.zip([1,7,2]).each do |a,b|
            if a > b
              too_old = false
              break
            end
            if a < b
              too_old = true
              break
            end
           end
          answer = (not too_old)
        end
      end
    end
    # if answer is still nil now, we failed to find or parse the
    # version number
    answer
  end
end
