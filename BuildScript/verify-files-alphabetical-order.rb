#!/usr/bin/env ruby
SCHEMES = [
  'OutlookAgenda',
  'OutlookAgendaTests',
  'OutlookAgendaUITests'
].freeze

dir = File.expand_path(File.dirname(__FILE__))
require File.join(dir, 'pbxplorer')

def error_header(folder, file_names)
  $stdout.puts '^^----------------------------------------------------------------------------'
  $stdout.puts 'ERROR - There are files or groups out of alphabetical order in the project.'
  $stdout.puts ''
  $stdout.puts "Located in the folder [#{folder}] :" if folder
  $stdout.puts ''
  padding = padding_of(file_names)
  $stdout.puts format("%-#{padding}s %-#{padding}s", 'You have:', 'Should be:').to_s
  padding
end

def padding_of(file_names)
  file_names.max_by(&:length).length + 5
end

def error_message(file_names, folder)
  padding = error_header(folder, file_names)
  file_names = file_names.map(&:downcase)
  index = 0
  file_names.each do |file|
    output_selection(index, file, padding, file_names.sort_by(&String.natural_order))
    index += 1
  end
  $stdout.puts ''
  raise 'There are files or groups out of alphabetical order in the project'
end

def output_selection(index, file, padding, sorted)
  here_it_is = file != sorted[index] ? '* ' : '  '
  $stdout.puts "#{format("#{here_it_is}%-#{padding}s %-#{padding}s", file, sorted[index])}\n"
end

def String.natural_order(nocase = false)
  proc do |str|
    i = true
    str = str.upcase if nocase
    str.gsub(/\s+/, '').split(/(\d+)/).map { |x| (i = !i) ? x.to_i : x }
  end
end

def alphasorted(array)
  a = array.map(&:downcase)
  a == a.sort_by(&String.natural_order)
end

def path_for_group(folder_origin, group_value)
  folder_origin ? "#{folder_origin} / #{group_value['name'] || group_value['path']}" : (group_value['name'] || group_value['path']).to_s
end

def references_for_group_file(group_value)
  group_value.file_refs.collect { |child| File.basename(child['name'] || child['path']) }
end

def names_of_subgroups(group_value)
  group_value.subgroups.collect { |child| child['name'] || child['path'] }.compact
end

def test_sorted(groups_arr, folder_origin)
  groups_arr.each do |group_value|
    group_path = path_for_group(folder_origin, group_value)

    group_files_refs = references_for_group_file(group_value).compact
    error_message(group_files_refs, group_path) unless alphasorted(group_files_refs)

    # rubocop:disable Style/Next, Style/NumericPredicate
    if group_value.subgroups.count > 0
      # rubocop:enable Style/Next, Style/NumericPredicate
      subgroups_names = names_of_subgroups(group_value)
      error_message(subgroups_names, group_path) unless alphasorted(subgroups_names)

      # test each subgroup
      test_sorted(group_value.subgroups, group_path)
    end
  end
end

def process_project_file_for(project_file, scheme)
  directory = project_file.objects_of_class(PBXGroup, 'name' => scheme.to_s).first || project_file.objects_of_class(PBXGroup, 'path' => scheme.to_s).first
  test_sorted([directory], nil) if directory
end

#
# Main
#
exit 0 if ENV.fetch('BUILD_TYPE') { 'NO' } == 'UITEST'
project_file = XCProjectFile.new File.join(dir, '../', 'OutlookAgenda.xcodeproj/project.pbxproj')
SCHEMES.each { |scheme| process_project_file_for(project_file, scheme) }
