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
		    
			
	});
	
$(document).ready(function(){ 
	$('input.ui-date-picker').datepicker({ dateFormat: 'd M yy' }); 
	$('input.ui-datetime-picker').datetimepicker({ dateFormat: 'd M yy', ampm: true }); 
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