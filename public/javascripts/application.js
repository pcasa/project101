// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){
		$('#menu li').hover(
			function() { $('ul', this).slideDown('fast'); },
			function() { $('ul', this).slideUp('fast'); });
	});