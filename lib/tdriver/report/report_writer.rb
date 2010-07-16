############################################################################
##
## Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
## All rights reserved.
## Contact: Nokia Corporation (testabilitydriver@nokia.com)
##
## This file is part of TDriver.
##
## If you have questions regarding the use of this file, please contact
## Nokia at testabilitydriver@nokia.com .
##
## This library is free software; you can redistribute it and/or
## modify it under the terms of the GNU Lesser General Public
## License version 2.1 as published by the Free Software Foundation
## and appearing in the file LICENSE.LGPL included in the packaging
## of this file.
##
############################################################################


require File.expand_path( File.join( File.dirname( __FILE__ ), 'report_grouping' ) )
require File.expand_path( File.join( File.dirname( __FILE__ ), 'report_execution_statistics' ) )
module TDriverReportWriter
  def write_style_sheet(page)
    css='body
{
	background-color:#74C2E1;
  font-family: sans-serif;
	font-size: small;
}
.navigation_section
{
	background-color:#0191C8;
	width:800px;
	height:40px;
    margin-left : auto;
    margin-right: auto;
  font-family: sans-serif;
	font-size: medium;
}
.summary
{
	background-color:White;
	width:800px;
	height:100%;
	margin-left : auto;
    margin-right: auto;

}
.summary_total_run
{
	background-color:White;
	width:800px;
	height:100%;
	margin-left : auto;
    margin-right: auto;

}
.summary_passed
{
	background-color:White;
	width:800px;
	height:100%;
	margin-left : auto;
    margin-right: auto;

}
.statistics
{
	background-color:White;
	width:800px;
	height:100%;
	margin-left : auto;
    margin-right: auto;

}
.summary_failed
{
	background-color:White;
	width:800px;
	height:100%;
	margin-left : auto;
    margin-right: auto;

}
.summary_not_run
{
	background-color:White;
	width:800px;
	height:100%;
	margin-left : auto;
    margin-right: auto;

}
.test_passed
{
	background-color:White;
	width:800px;
	height:100%;
	margin-left : auto;
    margin-right: auto;

}
.test_failed
{
	background-color:White;
	width:800px;
	height:100%;
	margin-left : auto;
    margin-right: auto;

}
.test_not_run
{
	background-color:White;
	width:800px;
	height:100%;
	margin-left : auto;
    margin-right: auto;

}
.environment
{
	background-color:White;
	width:800px;
	height:100%;
	margin-left : auto;
    margin-right: auto;

}
.page_title
{
	background-color:#0191C8;
	width:800px;
	min-height:100%;
	margin-left : auto;
    margin-right: auto;
    color : white;
}
.table
{
	width: 100%;
}
a:link { color:Black;}
a:visited { color:Black;}
a:hover { color:White; background-color:#005B9A;}

#navigation
{
	list-style-type:none;
	padding:10px 10px 20px 10px;
	margin-left : auto;
    margin-right: auto;
}

#navigation li {
	float:left;
	margin:0 2px;
}
#navigation li a {
	display:block;
	padding:2px 10px;
	background-color:#E0E0E0;
	color:#2E3C1F;
	text-decoration:none;
}
#navigation li a.current {
	background-color:#74C2E1;
	color:#FFFFFF;
}
#navigation li a:hover {
	background-color:#3C72B0;
	color:#FFFFFF;
}
#failed_case
{
	background-color:Red;
}
#passed_case
{
	background-color:Lime;
}
#not_run_case
{
	background-color:#E0E0E0;
}
img
{
	width:50%;
	height:50%;
}
    .togList
{

}

.togList dt
{

}

.togList dt span
{

}

.togList dd
{
width: 90%;
padding-bottom: 15px;
}

FORM { DISPLAY:inline; }

html.isJS .togList dd
{
display: none;
}
    input.btn {
	  color:#050;
	  font: bold 84% \'trebuchet ms\',helvetica,sans-serif;
	  border: 1px solid;
	  border-color: #696 #363 #363 #696;
	}
  input.btn:hover{
    background-color:#dff4ff;
    border:1px solid #c2e1ef;
    color:#336699;
    }

.behaviour_table_title
{
	background-color:#CCCCCC;
}
.user_data_table_title
{
	background-color:#CCCCCC;
}
    '
    File.open(page, 'w') {|f| f.write(css) }
    css=nil
  end
  def format_duration(seconds)
    m, s = seconds.divmod(60)
    "#{m}m#{'%.3f' % s}s"
  end
  def behaviour_log_summary(log,log_format='string')
    begin
      log_table = Array.new
      pass=0
      fail=0
      #behaviour=0
      warning=0
      debug=0
      info=0
      error=0
      fatal=0
      log_table << '<table width=60% border="1">'
      log_table << '<tr class="behaviour_table_title"><td><b>BEHAVIOUR</b></td><td><b>Total</b></td></tr>'
      log.each do |log_row|
        if log_row[0].include? 'PASS'
          pass+=1
        end
        if log_row[0].include? 'FAIL'
          fail+=1
        end
        #if log_row.include? 'BEHAVIOUR'
        # behaviour+=1
        #end
        if log_row[0].include? 'WARNING'
          warning+=1
        end
        if log_row[0].include? 'DEBUG'
          debug+=1
        end
        if log_row[0].include? 'INFO'
          info+=1
        end
        if log_row[0].include? 'ERROR'
          error+=1
        end
        if log_row[0].include? 'FATAL'
          fatal+=1
        end
      end
      log_table << '<tr><td>PASS:</td><td>'+pass.to_s+'</td></tr>'
      log_table << '<tr><td>FAIL:</td><td>'+fail.to_s+'</td></tr>'
      #log_table << '<tr><td>BEHAVIOUR:</td><td>'+behaviour.to_s+'</td></tr>'
      log_table << '<tr><td>WARNING:</td><td>'+warning.to_s+'</td></tr>'
      log_table << '<tr><td>DEBUG:</td><td>'+debug.to_s+'</td></tr>'
      log_table << '<tr><td>INFO:</td><td>'+info.to_s+'</td></tr>'
      log_table << '<tr><td>ERROR:</td><td>'+error.to_s+'</td></tr>'
      log_table << '<tr><td>FATAL:</td><td>'+fatal.to_s+'</td></tr>'
      log_table << '</table>'
      if log_format=='string'
        log_table.join
      else
        log_table
      end
    rescue
      '-'
    end
  end
  def format_behaviour_log(log,log_format='string')
    begin
      log_table = Array.new
      log_table << '<table border="1">'
      log_table << '<tr class="behaviour_table_title"><td><b>TDriver</b></td><td><b>Log</b></td><td><b>Status</b></td></tr>'
      log.each do |log_row|
        status='-'
        type='-'
        log_entry='-'
        if log_row[0].include? 'PASS'
          status='<b style="color: #00FF00">PASS</b>'
        end
        if log_row[0].include? 'FAIL'
          status='<b style="color: #FF0000">FAIL</b>'
        end
        if log_row[0].include? 'BEHAVIOUR'
          type='<b>BEHAVIOUR</b>'
        end
        if log_row[0].include? 'WARNING'
          type='<b style="color: #FF00FF">WARNING<b>'
        end
        if log_row[0].include? 'DEBUG'
          type='DEBUG'
        end
        if log_row[0].include? 'INFO'
          type='<b style="color: #00FF00">INFO</b>'
        end
        if log_row[0].include? 'ERROR'
          type='<b style="color: #FF0000">ERROR</b>'
        end
        if log_row[0].include? 'FATAL'
          type='<b style="color: #FF0000">FATAL</b>'
        end

        formatted_log=log_row[0].gsub('PASS;','')
        formatted_log=formatted_log.gsub('FAIL;','')
        formatted_log=formatted_log.gsub('BEHAVIOUR TDriver:','')
        formatted_log=formatted_log.gsub('WARNING;','')
        formatted_log=formatted_log.gsub('DEBUG TDriver:','')
        formatted_log=formatted_log.gsub('INFO TDriver:','')
        formatted_log=formatted_log.gsub('ERROR TDriver:','')
        formatted_log=formatted_log.gsub('FATAL TDriver:','')
        log_entry=formatted_log
        formatted_log=nil
        if log_row[1] != nil
          log_table << '<tr><td>'+type+'</td><td><a href="'+log_row[1].to_s+'/index.html">'+log_entry+'</a></td><td>'+status+'</td></tr>'
        else
          log_table << '<tr><td>'+type+'</td><td>'+log_entry+'</td><td>'+status+'</td></tr>'
        end

      end
      log_table << '</table>'
      if log_format=='string'
        log_table.join
      else
        log_table
      end
    rescue
      '-'
    end
  end
  def format_execution_log(log)
    begin
      formatted_log=Array.new
      log.each do |line|
        if line.include?('test_unit.rb')
          formatted_log << line.gsub('PASSED','<b style="color: #00FF00">PASSED</b>').gsub('FAILED','<b style="color: #FF0000">FAILED</b>').gsub('SKIPPED','<b>SKIPPED</b>')
        else
          formatted_log << "<b style=\"color: #2554C7\">#{line}</b>".gsub('PASSED','<b style="color: #00FF00">PASSED</b>').gsub('FAILED','<b style="color: #FF0000">FAILED</b>').gsub('SKIPPED','<b>SKIPPED</b>')
        end
      end
      formatted_log.to_s
    rescue
      '-'
    end
  end
  def write_page_start(page, title)
    case title
    when "TDriver test results"
      stylesheet='<link rel="stylesheet" title="TDriverReportStyle" href="tdriver_report_style.css"/>'
    when "TDriver test environment"
      stylesheet='<link rel="stylesheet" title="TDriverReportStyle" href="../tdriver_report_style.css"/>'
    when "Total run"
      stylesheet='<link rel="stylesheet" title="TDriverReportStyle" href="../tdriver_report_style.css"/>'
    when "Statistics"
      stylesheet='<link rel="stylesheet" title="TDriverReportStyle" href="../tdriver_report_style.css"/>'
    when "Passed"
      stylesheet='<link rel="stylesheet" title="TDriverReportStyle" href="../tdriver_report_style.css"/>'
    when "Failed"
      stylesheet='<link rel="stylesheet" title="TDriverReportStyle" href="../tdriver_report_style.css"/>'
    when "Not run"
      stylesheet='<link rel="stylesheet" title="TDriverReportStyle" href="../tdriver_report_style.css"/>'
    when "TDriver log"
      stylesheet='<link rel="stylesheet" title="TDriverReportStyle" href="../tdriver_report_style.css"/>'
    else
      stylesheet='<link rel="stylesheet" title="TDriverReportStyle" href="../../tdriver_report_style.css"/>'
    end
    html_start='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' <<
      '<html xmlns="http://www.w3.org/1999/xhtml">'<<
      '<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta http-eqiv="cache-control" content="no-cache">'<<
      stylesheet<<
      get_java_script()<<
      '<title>'+title+'</title>'<<
      '</head><body>'
    File.open(page, 'w') do |f2|
      f2.puts html_start
    end
    html_start=nil
    stylesheet=nil
    write_navigation_menu(page,title)
    page=nil
    title=nil
  end
  def write_test_case_body(page,test_case_name,start_time,end_time,run_time,status,index,folder,capture_screen_error,failed_dump_error,reboots=0)
    status_style='test_passed' if status=='passed' || @pass_statuses.include?(status)
    status_style='test_failed' if status=='failed' || @fail_statuses.include?(status)
    status_style='test_not_run' if status=='not run' || @not_run_statuses.include?(status)
    begin
      used_memory_difference=@tc_memory_amount_start.to_i-@tc_memory_amount_end.to_i
    rescue
      used_memory_difference='-'
    end
    formatted_test_case_name=test_case_name.gsub('_',' ')
    if formatted_test_case_name==nil
      formatted_test_case_name=test_case_name
    end
    html_body='<div class="page_title"><center><h1>',formatted_test_case_name,'</h1></center></div>'<<
      '<div class="'<<
      status_style<<
      '"><table align="center" style="width:100%;">'<<
      '<tr>'<<
      '<td style="font-weight: 700">'<<
      'Case</td>'<<
      '<td>'<<
      index.to_s,'</td>'<<
      '</tr>'<<
      '<tr>'<<
      '<td style="font-weight: 700">'<<
      'Status</td>'<<
      '<td>'<<
      status,'</td>'<<
      '</tr>'<<
      '<tr>'<<
      '<td style="font-weight: 700">'<<
      'Started</td>'<<
      '<td>'<<
      start_time.strftime("%d.%m.%Y %H:%M:%S"),'</td>'<<
      '</tr>'<<
      '<tr>'<<
      '<td style="font-weight: 700">'<<
      'Ended</td>'<<
      '<td>'<<
      end_time.strftime("%d.%m.%Y %H:%M:%S"),'</td>'<<
      '</tr>'<<
      '<tr>'<<
      '<td style="font-weight: 700">'<<
      'Runtime</td>'<<
      '<td>'<<
      format_duration(run_time)+'</td>'<<
      '</tr>'<<
      '<tr><td><b>Total memory</b></td><td>'<<
      @tc_memory_amount_total.to_s<<
      '</td></tr>'<<
      '<tr><td><b>Used memory at beginning</b></td><td>'<<
      @tc_memory_amount_start.to_s<<
      '</td></tr>'<<
      '<tr><td><b>Used memory at end</b></td><td>'<<
      @tc_memory_amount_end.to_s<<
      '</td></tr>'<<
      '<tr><td><b>Used memory difference</b></td><td>'<<
      used_memory_difference.to_s<<
      '</td></tr>' <<
      '<tr><td><b>Device reboots</b></td><td>'<<
      reboots.to_s<<
      '</td></tr>' <<
      '<tr>' <<
      '<td style="font-weight: 700">'<<
      'Details</td>'<<
      '<td style="font-size: small; font-weight: bold">'<<
      format_execution_log(@test_case_execution_log)<<
      '</td></tr>'
    if File::directory?(folder.to_s+'/state_xml')==true
      d=Dir.entries(folder.to_s+'/state_xml')
      d.each do |x|
        if (x !='.' && x != '..')
          if (x.include? '.png') && (capture_screen_error==nil)
            html_body=html_body<<
              '<tr>'<<
              '<td style="font-weight: 700">'<<
              'Screen capture</td>'<<
              '<td>'<<
              '<a href="state_xml/'<<
              x<<
              '"><img alt="" src="state_xml/'<<
              x<<
              '" /></a></td>'<<
              '</tr>'
          elsif capture_screen_error!=nil
            html_body=html_body<<
              '<tr>'<<
              '<td style="font-weight: 700">'<<
              'Screen capture</td>'<<
              '<td style="font-weight: 700">'<<
              capture_screen_error.to_s,'</td>'<<
              '</tr>'
          end
          if (x.include? '.xml') && (failed_dump_error==nil)
            html_body=html_body<<
              '<tr>'<<
              '<td style="font-weight: 700">'<<
              'State</td>'<<
              '<td>'<<
              '<a href="state_xml/'<<
              x<<
              '">Sut XML State</a></td>'<<
              '</tr>'
          elsif failed_dump_error!=nil
            html_body=html_body<<
              '<tr>'<<
              '<td style="font-weight: 700">'<<
              'State</td>'<<
              '<td style="font-weight: 700">'<<
              failed_dump_error.to_s,'</td>'<<
              '</tr>'
          end
        end
      end
    end
    if File::directory?(folder.to_s+'/crash_files')==true
      d=Dir.entries(folder.to_s+'/crash_files')
      d.each do |x|
        if (x !='.' && x != '..')
          html_body=html_body<<
            '<tr>'<<
            '<td style="font-weight: 700">'<<
            '&nbsp;</td>'<<
            '<td>'<<
            '<a href="crash_files/'<<
            x<<
            '">'+x+'</a></td>'<<
            '</tr>'
        end
      end
    end
    if File::directory?(folder.to_s+'/trace_files')==true
      d=Dir.entries(folder.to_s+'/trace_files')
      d.each do |x|
        if (x !='.' && x != '..')
          html_body=html_body<<
            '<tr>'<<
            '<td style="font-weight: 700">'<<
            'Trace files</td>'<<
            '<td>'<<
            '<a href="trace_files/'<<
            x<<
            '">Captured trace files</a></td>'<<
            '</tr>'
        end
      end
    end
    if File::directory?(folder.to_s+'/video')==true
      d=Dir.entries(folder.to_s+'/video')
      html_body=html_body<<
        '<tr>'<<
        '<td style="font-weight: 700">'<<
        'Video files</td>'<<
        '</tr>'
      d.each do |x|
        if (x !='.' && x != '..')
          html_body=html_body<<
            '<tr>'<<
            '<td style="font-weight: 700">'<<
            '&nbsp;</td>'<<
            '<td>'<<
            '<a href="video/'<<
            x<<
            '">'+x+'</a></td>'<<
            '</tr>'
        end
      end
    end
    if File::directory?(folder.to_s+'/files')==true
      d=Dir.entries(folder.to_s+'/files')
      html_body=html_body<<
        '<tr>'<<
        '<td style="font-weight: 700">'<<
        'Monitored files</td>'<<
        '</tr>'
      d.each do |x|
        if (x !='.' && x != '..')
          html_body=html_body<<
            '<tr>'<<
            '<td style="font-weight: 700">'<<
            '&nbsp;</td>'<<
            '<td>'<<
            '<a href="files/'<<
            x<<
            '">'+x+'</a></td>'<<
            '</tr>'
        end
      end
    end
    html_body=html_body<<
      '<tr><td style="font-weight: 700">'<<
      '&nbsp;</td>'
    html_body=html_body<<
      '</tr>'<<
      '</table>'
    if @test_case_behaviour_log.length > 0
      html_body=html_body<<
        '<dl class="togList">'<<
        '<dt onclick="tog(this)" style="background-color: #CCCCCC;"><b style="font-size: large"><span><input id="Button1" type="button" value="Open" class="btn" /></span> Behaviours</b></dt>'<<
        '<dd style="font-size: small">'<<
        format_behaviour_log(@test_case_behaviour_log)<<
        '</dd>'<<
        '</dl>'
    end
    if @test_case_user_data!=nil && !@test_case_user_data.empty?
      html_body=html_body<<
        '<dl class="togList">'<<
        '<dt onclick="tog(this)" style="background-color: #CCCCCC;"><b style="font-size: large"><span><input id="Button1" type="button" value="Open" class="btn" /></span> User Data</b></dt>'<<
        '<dd style="font-size: small">'<<
        format_user_log_table( @test_case_user_data,@test_case_user_data_columns)<<
        '</dd>'<<
        '</dl>'
    end
    html_body=html_body<<
      '</div>'
    File.open(page, 'a') do |f2|
      f2.puts html_body
    end
    html_body=nil
    @test_case_execution_log=nil
    @test_case_behaviour_log=nil
    @test_case_user_data=nil
    @test_case_user_data_columns=nil
  end
  def tog_list_begin(name)
    html_body='<dl class="togList">'<<
      '<dt onclick="tog(this)"><b><span>+</span>'<<
      name<<
      '</b></dt>'<<
      '<dd>'
    html_body
  end
  def tog_list_end()
    html_body='</dd>'<<
      '</dl>'
    html_body
  end
  def write_test_case_summary_body(page,status,tc_arr,chronological_page=nil)
    html_body=Array.new
    case status
    when 'passed'
      title='<div class="page_title"><center><h1>Passed</h1></center></div>'<<
        '<div class="summary_passed">' <<
        '<form action="save_total_run_results" >'
      tdriver_group=ReportingGroups.new(@reporting_groups,tc_arr)
      tdriver_group.parse_groups()
      html_result=tdriver_group.generate_report(@pass_statuses.first)
      html_body << title
      html_body << html_result
      html_body << "<input type=\"submit\" name=\"save_changes\" value=\"Save changes\" />" if @report_editable=='true'
      html_body << "</form>"
      html_body << '<form action="save_results_to" ><input type="submit" name="save_results_to" value="Download report" /></form>' if @report_editable=='true'
      tdriver_group=nil
      html_result=nil
    when 'failed'
      title='<div class="page_title"><center><h1>Failed</h1></center></div>'<<
        '<div class="summary_failed">' <<
        '<form action="save_total_run_results" >'
      tdriver_group=ReportingGroups.new(@reporting_groups,tc_arr)
      tdriver_group.parse_groups()
      html_result=tdriver_group.generate_report(@fail_statuses.first)
      html_body << title
      html_body << html_result
      html_body << "<input type=\"submit\" name=\"save_changes\" value=\"Save changes\" />" if @report_editable=='true'
      html_body << "</form>"
      html_body << '<form action="save_results_to" ><input type="submit" name="save_results_to" value="Download report" /></form>' if @report_editable=='true'
      tdriver_group=nil
      html_result=nil
    when 'not run'
      title='<div class="page_title"><center><h1>Not run</h1></center></div>'<<
        '<div class="summary_not_run">' <<
        '<form action="save_total_run_results" >'
      tdriver_group=ReportingGroups.new(@reporting_groups,tc_arr)
      tdriver_group.parse_groups()
      html_result=tdriver_group.generate_report(@not_run_statuses.first)
      html_body << title
      html_body << html_result
      html_body << "<input type=\"submit\" name=\"save_changes\" value=\"Save changes\" />" if @report_editable=='true'
      html_body << "</form>"
      html_body << '<form action="save_results_to" ><input type="submit" name="save_results_to" value="Download report" /></form>' if @report_editable=='true'
      tdriver_group=nil
      html_result=nil
    when 'statistics'
      title='<div class="page_title"><center><h1>Statistics</h1></center></div>'<<
        '<div class="statistics">'
      tdriver_group=ReportingStatistics.new(tc_arr)
      html_result=tdriver_group.generate_statistics_table()
      html_body << title
      html_body << html_result
      tdriver_group=nil
      html_result=nil
    else
      chronological_html_body=Array.new
      title='<div class="page_title"><center><h1>Total run</h1></center></div>'
      view_selection='<div class="summary_view_select"><center><input type="button" value="Grouped view" ONCLICK="location.assign(\'total_run_index.html\');"/>'<<
        '<input type="button" value="Chronological view" ONCLICK="location.assign(\'chronological_total_run_index.html\');"/></center></div>'<<
        '<div class="summary_total_run">' <<
        '<form action="save_total_run_results" >'
      title << view_selection
      tdriver_group=ReportingGroups.new(@reporting_groups,tc_arr)
      tdriver_group.parse_groups()
      html_result=tdriver_group.generate_report('all')
      html_body << title
      html_body << html_result
      html_body << "<input type=\"submit\" name=\"save_changes\" value=\"Save changes\" />" if @report_editable=='true'
      html_body << "</form>"
      html_body << '<form action="save_results_to" ><input type="submit" name="save_results_to" value="Download report" /></form>' if @report_editable=='true'
      html_body << '<form action="export_results_to_excel" ><input type="submit" name="export_results_to_excel" value="Export to Excel" /></form>' if @report_editable=='true'

      tdriver_group=nil
      html_result=nil
      tdriver_group=ReportingGroups.new(@reporting_groups,tc_arr,false)
      tdriver_group.parse_groups()
      chronological_html_result=tdriver_group.generate_report('all')
      chronological_html_body << title
      chronological_html_body << chronological_html_result
      chronological_html_body << "<input type=\"submit\" name=\"save_changes\" value=\"Save changes\" />" if @report_editable=='true'
      chronological_html_body << "</form>"
      chronological_html_body << '<form action="save_results_to" ><input type="submit" name="save_results_to" value="Download report" /></form>' if @report_editable=='true'
      chronological_html_body << '<form action="export_results_to_excel" ><input type="submit" name="export_results_to_excel" value="Export to Excel" /></form>' if @report_editable=='true'
      chronological_html_body << "</div>"

      File.open(chronological_page, 'a') do |f2|
        f2.puts chronological_html_body
      end
      tdriver_group=nil
      chronological_html_result=nil
      chronological_html_body=nil
    end
    html_body << '</div>'
    File.open(page, 'a') do |f2|
      f2.puts html_body
    end
    html_body=nil
    GC.start
  end

  def write_summary_body(page,start_time,end_time,run_time,total_run,total_passed,total_failed,total_not_run,total_crash_files,total_device_resets)
    fail_rate=0
    pass_rate=0
    if total_run.to_i > 0
      fail_rate=(total_failed.to_f/total_run.to_f)*100
      pass_rate=(total_passed.to_f/total_run.to_f)*100
    end

    html_body='<div class="page_title"><center><h1>TDriver test results</h1></center></div>'<<
      '<div class="summary"><table align="center" style="width:80%;" border="0">'<<
      '<tr>'<<
      '<td><b>Started</b></td>'<<
      '<td>'+start_time.strftime("%d.%m.%Y %H:%M:%S")+'</td>'<<
      '</tr>'<<
      '<tr>'<<
      '<td><b>Ended</b></td>'
    begin
      html_body+='<td>'+end_time.strftime("%d.%m.%Y %H:%M:%S")+'</td>'
    rescue
      html_body+='<td>'+end_time.to_s+'</td>'
    end
    html_body+='</tr>'<<
      '<tr>'<<
      '<td><b>Runtime</b></td>'<<
      '<td>'+format_duration(run_time)+'</td>'<<
      '</tr>'<<
      '<tr>'<<
      '<td><a href="cases/total_run_index.html"><b>Total run</b></a></td>'<<
      '<td>'+total_run.to_s+'</td>'<<
      '</tr>'<<
      '<tr>'<<
      '<td><a href="cases/passed_index.html"><b>Passed</b></a></td>'<<
      '<td>'+total_passed.to_s+'</td>'<<
      '</tr>'<<
      '<tr>'<<
      '<td><a href="cases/failed_index.html"><b>Failed</b></a></td>'<<
      '<td>'+total_failed.to_s+'</td>'<<
      '</tr>'<<
      '<tr>'<<
      '<td><a href="cases/not_run_index.html"><b>Not run</b></a></td>'<<
      '<td>'+total_not_run.to_s+'</td>'<<
      '</tr>'<<
      '<tr>'<<
      '<td><b>Total crash files captured</b></td>'<<
      '<td>'+total_crash_files.to_s+'</td>'<<
      '</tr>'<<
      '<tr>'<<
      '<td><b>Total device resets</b></td>'<<
      '<td>'+total_device_resets.to_s+'</td>'<<
      '</tr>'<<
      '<tr>'<<
      '<td><b>Pass %</b></td>'<<
      '<td>'+pass_rate.to_f.to_s+'%</td>'<<
      '</tr>'<<
      '<tr>'<<
      '<td><b>Fail %</b></td>'<<
      '<td>'+fail_rate.to_f.to_s+'%</td>'<<
      '</tr>'<<
      '</table></div>'
    File.open(page, 'a') do |f2|
      f2.puts html_body
    end
    html_body=nil
  end
  def create_behaviour_links()
    folder=@report_folder+'/environment/behaviours'
    links=' '
    if File::directory?(folder.to_s)==true
      d=Dir.entries(folder.to_s)
      d.each do |x|
        if (x !='.' && x != '..')
          if x.include? '.xml'
            links << '<a href="behaviours/'+x+'">'+x+'</a> <br />'
          end
        end
      end
    end
    links
  end

  def create_templates_links()
    folder=@report_folder+'/environment/templates'
    links=' '
    if File::directory?(folder.to_s)==true
      d=Dir.entries(folder.to_s)
      d.each do |x|
        if (x !='.' && x != '..')
          if x.include? '.xml'
            links << '<a href="templates/'+x+'">'+x+'</a> <br />'
          end
        end
      end
    end
    links
  end

  def write_environment_body(page,os,sw,variant,product,language,loc)
    begin
      used_memory_difference=@memory_amount_start.to_i-@memory_amount_end.to_i
    rescue
      used_memory_difference='-'
    end

    tdriver_version=ENV['TDRIVER_VERSION']
    tdriver_version='TDRIVER_VERSION environment variable not found' if tdriver_version==nil
    html_body='<div class="page_title"><center><h1>TDriver test environment</h1></center></div>'<<
      '<div class="environment"><table align="center" style="width:80%;" border="0">'<<
      '<tr><td><b>OS</b></td><td>'<<
      os<<
      '</td></tr>'<<
      '<tr><td><b>TDriver version</b></td><td>'<<
      tdriver_version<<
      '</td></tr>'<<
      '<tr><td><b>SW Version</b></td><td>'<<
      sw<<
      '</td></tr>'<<
      '<tr><td><b>Variant</b></td><td>'<<
      variant<<
      '</td></tr>'<<
      '<tr><td><b>Product</b></td><td>'<<
      product<<
      '</td></tr>'<<
      '<tr><td><b>Language</b></td><td>'<<
      language<<
      '</td></tr>'<<
      '<tr><td><b>Localization</b></td><td>'<<
      loc<<
      '</td></tr>'<<
      '<tr><td><b>Total memory</b></td><td>'<<
      @memory_amount_total.to_s<<
      '</td></tr>'<<
      '<tr><td><b>Used memory at beginning</b></td><td>'<<
      @memory_amount_start.to_s<<
      '</td></tr>'<<
      '<tr><td><b>Used memory at end</b></td><td>'<<
      @memory_amount_end.to_s<<
      '</td></tr>'<<
      '<tr><td><b>Used memory difference</b></td><td>'<<
      used_memory_difference.to_s<<
      '</td></tr>'<<
      "<tr><td><b>Behaviours</b></td><td>#{create_behaviour_links()}</td></tr>"<<
      '<tr><td><b>Parameters</b></td><td><a href="tdriver_parameters.xml">tdriver_parameters.xml</a></td></tr>'<<
      "<tr><td><b>Templates</b></td><td>#{create_templates_links()}</td></tr>"<<
      '</table></div>'
    create_behaviour_links()
    File.open(page, 'a') do |f2|
      f2.puts html_body
    end
    html_body=nil
  end
  def write_tdriver_log_body(page,log)
    if log.length > 0
      log_summary=behaviour_log_summary(log,'array')
      formatted_log=format_behaviour_log(log,'array')
      File.open(page, 'a') do |f|
        f.write('<div class="page_title"><center><h1>TDriver Log</h1></center></div>')
        f.write('<div class="environment">')
        f.write('<center><H2>Summary</H2>')
        log_summary.each do |entry|
          f.write(entry)
        end
        f.write('</center><br /><br /></div><br />')
        f.write('<div class="environment">')
        formatted_log.each do |entry|
          f.write(entry)
        end
        f.write('</div>')
      end
    else
      File.open(page, 'a') do |f|
        f.write('<div class="page_title"><center><h1>TDriver Log</h1></center></div>')
        f.write('<div class="environment">')
        f.write('<center><H2>Log is empty</H2>')
        f.write('</center><br /><br /></div><br />')
      end
    end
  end
  def write_navigation_menu(page,title)
    case title
    when "TDriver test results"
      tdriver_test_results_link='index.html" class="current"'
      tdriver_test_environment_link='environment/index.html"'
      tdriver_log_link='cases/tdriver_log_index.html"'
      total_run_link='cases/total_run_index.html"'
      statistics_link='cases/statistics_index.html"'
      passed_link='cases/passed_index.html"'
      failed_link='cases/failed_index.html"'
      not_run_link='cases/not_run_index.html"'
    when "TDriver test environment"
      tdriver_test_results_link='../index.html"'
      tdriver_test_environment_link='index.html" class="current"'
      tdriver_log_link='../cases/tdriver_log_index.html"'
      total_run_link='../cases/total_run_index.html"'
      statistics_link='../cases/statistics_index.html"'
      passed_link='../cases/passed_index.html"'
      failed_link='../cases/failed_index.html"'
      not_run_link='../cases/not_run_index.html"'
    when "Total run"
      tdriver_test_results_link='../index.html"'
      tdriver_test_environment_link='../environment/index.html"'
      tdriver_log_link='tdriver_log_index.html"'
      total_run_link='total_run_index.html" class="current"'
      statistics_link='statistics_index.html"'
      passed_link='passed_index.html"'
      failed_link='failed_index.html"'
      not_run_link='not_run_index.html"'
    when "Statistics"
      tdriver_test_results_link='../index.html"'
      tdriver_test_environment_link='../environment/index.html"'
      tdriver_log_link='tdriver_log_index.html"'
      total_run_link='total_run_index.html"'
      statistics_link='statistics_index.html" class="current"'
      passed_link='passed_index.html"'
      failed_link='failed_index.html"'
      not_run_link='not_run_index.html"'
    when "Passed"
      tdriver_test_results_link='../index.html"'
      tdriver_test_environment_link='../environment/index.html"'
      tdriver_log_link='tdriver_log_index.html"'
      total_run_link='total_run_index.html"'
      statistics_link='statistics_index.html"'
      passed_link='passed_index.html" class="current"'
      failed_link='failed_index.html"'
      not_run_link='not_run_index.html"'
    when "Failed"
      tdriver_test_results_link='../index.html"'
      tdriver_test_environment_link='../environment/index.html"'
      tdriver_log_link='tdriver_log_index.html"'
      total_run_link='total_run_index.html"'
      statistics_link='statistics_index.html"'
      passed_link='passed_index.html"'
      failed_link='failed_index.html" class="current"'
      not_run_link='not_run_index.html"'
    when "Not run"
      tdriver_test_results_link='../index.html"'
      tdriver_test_environment_link='../environment/index.html"'
      tdriver_log_link='tdriver_log_index.html"'
      total_run_link='total_run_index.html"'
      statistics_link='statistics_index.html"'
      passed_link='passed_index.html"'
      failed_link='failed_index.html"'
      not_run_link='not_run_index.html" class="current"'
    when "TDriver log"
      tdriver_test_results_link='../index.html"'
      tdriver_test_environment_link='../environment/index.html"'
      tdriver_log_link='tdriver_log_index.html" class="current"'
      total_run_link='total_run_index.html"'
      statistics_link='statistics_index.html"'
      passed_link='passed_index.html"'
      failed_link='failed_index.html"'
      not_run_link='not_run_index.html"'
    else
      tdriver_test_results_link='../../index.html"'
      tdriver_test_environment_link='../../environment/index.html"'
      tdriver_log_link='../tdriver_log_index.html"'
      total_run_link='../total_run_index.html"'
      statistics_link='../statistics_index.html"'
      passed_link='../passed_index.html"'
      failed_link='../failed_index.html"'
      not_run_link='../not_run_index.html"'
    end
    html_body='<div class="navigation_section">'<<
      '<ul id="navigation">'<<
      '<li><a href="'<<
      tdriver_test_results_link<<
      '>TDriver test results</a></li>'<<
      '<li><a href="'<<
      tdriver_test_environment_link<<
      '>TDriver test environment</a></li>'<<
      '<li><a href="'<<
      statistics_link<<
      '>Statistics</a></li>'<<
      '<li><a href="'<<
      total_run_link<<
      '>Total run</a></li>'<<
      '<li><a href="'<<
      passed_link<<
      '>Passed</a></li>'<<
      '<li><a href="'<<
      failed_link<<
      '>Failed</a></li>'<<
      '<li><a href="'<<
      not_run_link<<
      '>Not run</a></li>'<<
      '</ul>'<<
      '</div>'
    File.open(page, 'a') do |f2|
      f2.puts html_body
    end
    html_body=nil
  end
  def write_page_end(page)
    html_end='</body></html>'
    File.open(page, 'a') do |f2|
      f2.puts html_end
    end
    html_end=nil
  end
  def get_java_script()
    java_script='<script type="text/javascript">'<<
      '/* Only set closed if JS-enabled */'<<
      "document.getElementsByTagName('html')[0].className = 'isJS';"<<
      'function tog(dt)'<<
      '{'<<
      'var display, dd=dt;'<<
      '/* get dd */'<<
      "do{ dd = dd.nextSibling } while(dd.tagName!='DD');"<<
      'toOpen =!dd.style.display;'<<
      "dd.style.display = toOpen? 'block':'';"<<
      "dt.getElementsByTagName('span')[0].innerHTML"<<
      "= toOpen? '<input id=\"Button1\" type=\"button\" value=\"Close\" class=\"btn\" style=\"background-color: #FFFFFF\" />':'<input id=\"Button1\" type=\"button\" value=\"Open\" class=\"btn\" />' ;"<<
      '}'<<
      '</script>'
    java_script
  end
  def format_user_log_table(user_data_rows,user_data_columns)
    begin
      formatted_user_data=Array.new
      formatted_user_data << '<div><table align="center" style="width:100%;" border="1">'
      header='<tr class="user_data_table_title">'
      user_data_columns.sort.each do |column|
        header=header+'<td><b>'+column.to_s+'</b></td>'
      end
      formatted_user_data << header +'</tr>'

      #first need to add empty values for those columns that donot exist

      user_data_rows.each do |row_hash|
        keys_need_adding = user_data_columns - row_hash.keys
        keys_need_adding.each do |new_key|
          row_hash[new_key] = " - "
        end
      end

      #create the table rows
      user_data_rows.each do |row_hash|
        row = '<tr>'
        row_hash.sort{|a,b| a[0]<=>b[0]} .each do |value|
          row=row+'<td>'+value[1].to_s+'</td>'
        end
        formatted_user_data << row+'</tr>'
      end
      formatted_user_data << '</table></div>'
      formatted_user_data.to_s
    rescue Exception => e
      '-'
    end
  end

end #end TDriverReportWriter

