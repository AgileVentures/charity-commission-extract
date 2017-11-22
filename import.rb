#!/usr/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'optparse'
require 'find'

options = {}
option_parser = OptionParser.new do |opts|
  opts.on('-i INPUTFOLDER') do |input_folder|
    options[:input_folder] = input_folder
  end

  opts.on('-o OUTPUTFOLDER') do |output_folder|
    options[:output_folder] = output_folder
  end
end

option_parser.parse!

# puts options.inspect

def prepare_file(file)
  input_file = file.read
  input_file.delete!("\n")
  input_file.delete!("\r")
  input_file.squeeze!(' ')
  input_file.delete!('"')
  input_file.delete!('\\')
  input_file.encode!('UTF-8', invalid: :replace, undef: :replace, replace: '')
  input_file.gsub!('&#x0D;', '. ')
  input_file.gsub!('@**@', '","')
  input_file.gsub!('*@@*', "\n\"")
  input_file = '"' + input_file
  input_file.chomp!('"')
  input_file.gsub!(",\"\n", ",\"\"\n")
  input_file.gsub!(/(\w)$/, '\1"')
  input_file.gsub!('-.-', '"')
  input_file
end

def add_header_row(prepared_file, file_name)
  header_rows = {
      extract_acct_submit:  '"regno","submit_date","arno","fyend"',
      extract_aoo_ref:      '"aootype","aookey","aooname","aoosort","welsh","master"',
      extract_ar_submit:    '"regno""arno""submit_date"',
      extract_charity:      '"regno","subno","name","orgtype","gd","aob","aob_defined","nhs","ha_no","corr","add1","add2","add3","add4","add5","postcode","phone","fax"',
      extract_charity_aoo:  '"regno""aootype""aookey""welsh""master"',
      extract_class:        '"regno","class"',
      extract_class_ref:    '"classno","classtext"',
      extract_financial:    '"regno""fystart""fyend""income""expend"',
      extract_main_charity: '"regno","coyno","trustees","fyend","welsh","incomedate","income","grouptype","email","web"',
      extract_name:         '"regno","subno","nameno","name"',
      extract_objects:      '"regno","subno","seqno","object"',
      extract_partb:        '"regno","artype","fystart","fyend","inc_leg","inc_end","inc_vol","inc_fr","inc_char","inc_invest","inc_other","inc_total","invest_gain","asset_gain","pension_gain","exp_vol","exp_trade","exp_invest","exp_grant","exp_charble","exp_gov","exp_other","exp_total","exp_support","exp_dep","reserves","asset_open","asset_close","fixed_assets","open_assets","invest_assets","cash_assets","current_assets","credit_1","credit_long","pension_assets","total_assets","funds_end","funds_restrict","funds_unrestrict","funds_total","employees","volunteers","cons_acc","charity_acc"',
      extract_registration: '"regno","subno","regdate","remdate","remcode"',
      extract_remove_ref:   '"code","text"',
      extract_trustee:      '"regno","trustee"'
  }
  return prepared_file = header_rows[file_name.to_sym] + "\n" + prepared_file
end

# TODO: Need to add error checking to test if file name has a matching header row
def process_file(file, options)
  # check input file exists
  if File.file? file
    file_name = File.basename file
    open_file = File.open file, 'rb'
    prepared_file = prepare_file(open_file)
    prepared_file = add_header_row(prepared_file, file_name.split('.')[0])
    output_file = "#{file_name.split('.')[0]}.csv"
    output_file = options[:output_folder] + '/' + output_file
    output_file.gsub!('//', '/')
    File.open(output_file, 'w') { |f| f.write(prepared_file) }
    puts "Converted:  --> #{output_file}"
  else
    puts "ERROR: There was a problem reading '#{file}'."
    exit 1
  end
end



################
# Main Process #
################

# get list of *.bcl files
options[:input_folder] = './' unless options[:input_folder]
options[:output_folder] = './' unless options[:output_folder]
bcp_files = []
Find.find(options[:input_folder]) do |path|
  bcp_files << path if path =~ /.*\.bcp$/
end

if bcp_files.empty?
  puts 'Warning: No bcp files to process in directory provided.'
  exit 0
else
  bcp_files.each do |file|
    puts "Processing: #{file}"
    process_file file, options
  end
end
