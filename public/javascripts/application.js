// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){
		$('#menu li').hover(
			function() { $('ul', this).slideDown('fast'); },
			function() { $('ul', this).slideUp('fast'); });
			$('a[rel*=facebox]').facebox();
			
			$("#tabs").tabs({
				cache:true,
				   load: function (e, ui) {
				     $(ui.panel).find(".tab-loading").remove();
					 $(ui.panel).css({float: 'none', textAlign: 'left'});
				   },
				   select: function (e, ui) {
				     var $panel = $(ui.panel);

				     if ($panel.is(":empty")) {
				         $panel.append("<div class='tab-loading'><img src='/images/spinner.gif' /><br />Loading...</div>");
						 $panel.css({float: 'none', textAlign: 'center'});
						// $panel.css({float: 'none', display: 'inline'});
						// $panel.css({float: 'none'});
				     }
				    }
			});
			
			$(".new-task-button").click(function () {
			$(".new-task-form").toggle("slow");
			});
			$(".new-task-form").bind('ajax:success', function(evt, data, status, xhr){
			    var $this = $(this);
			    $this.find('input:text,textarea').val('');
					
			  });
			$(".close-dashboard-tasks").click(function(){
				$("#dashboard-tasks").slideUp("slow");
				$(this).fadeOut("fast");
				$(".open-dashboard-tasks").fadeIn();
			});
			$(".open-dashboard-tasks").click(function(){
				$("#dashboard-tasks").slideDown("slow");
				$(this).fadeOut("fast");
				$(".close-dashboard-tasks").fadeIn();
			});
			
			$('.delete-task').bind('ajax:success', function() {  
			    $(this).closest('tr').fadeOut();
			  	
			});
			
			
			
			$('.toggle-comment-form').click(function () {
				$(this).parents('tr').next('tr').toggle('slow');
				return false;
			});
			
			
			
			$('.pagination a').live('click',function (){  
				            $.getScript(this.href);  
				            return false;  
				    });
			
		   // $('#today').hide();
		   // $('#yesterday').hide();
		   // $("#thechoices").change(function(){	
		   // 	$("#reports").children().slideUp();
		   // 	$("#" + this.value).fadeIn();
		   // });
		   // 
           //
		   // $("#thechoices").change();
		   // $('#today').show();
			
			$("#clear-frf").click(function(){
				$('#item_search select').val(0);
				$('#item_search :input:not(:submit)').val('');
				$('#item_search input:checkbox').removeAttr('checked');		
			});
			
			$('#clear-tf').click(function(){
				$('#task_search select').val(0);
				$('#task_search :input:not(:submit)').val('');
				$('#task_search input:checkbox').removeAttr('checked');
			});
		    
			$('input.ui-date-picker').datepicker({ dateFormat: 'M d yy' }); 
			$('input.ui-datetime-picker, .task-datetime').datetimepicker({ dateFormat: 'M d yy', ampm: true });
			$('.created-at-datetime, .updated-at-datetime').datetimepicker({dateFormat: 'M dd, yy ', ampm: true});
			
			
			
	});
	

// Below is for live search
//
//  $(function() {
//    $("#customer_search input").keyup(function() {
//      clearTimeout($.data(this, "timer"));
//  	    var ms = 200; //milliseconds
//  	    var val = this.value;
//  	    var wait = setTimeout(function() {
//  	      lookup(val);
//  	    }, ms);
//  	    $.data(this, "timer", wait);
//    });
//  });
//  
//  function lookup(searchinput) {
//  	$.get($("#customer_search").attr("action"), $("#customer_search").serialize(), null, "script");
//      return false;
//  
//  } // lookup