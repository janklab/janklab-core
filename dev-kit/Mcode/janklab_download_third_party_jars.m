function janklab_download_third_party_jars
% Download third-party JARs, like the JDBC drivers
%
% This downloads standard third-party Java libraries which aren't redistributed
% with Janklab itself for licensing reasons.

this_file = mfilename('fullpath');
repo_dir = fileparts(fileparts(this_file));
jar_ext_dir = [repo_dir '/dist/lib/java-ext'];


definitions = {
    };

end