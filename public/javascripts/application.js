// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){
		$('#menu li').hover(
			function() { $('ul', this).slideDown('fast'); },
			function() { $('ul', this).slideUp('fast'); });
			$('a[rel*=facebox]').facebox();
	});
	
$(document).ready(function(){ $('input.ui-date-picker').datepicker(); });

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