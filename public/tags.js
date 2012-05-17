
/*
 * Dynamic Tag Form - for jQuery 1.3+
 * http://codecanyon.net/user/RikdeVos?ref=RikdeVos
 *
 * Copyright 2012, Rik de Vos
 * You need to buy a license if you want use this script.
 * http://codecanyon.net/item/dynamic-tag-form/482498?ref=RikdeVos
 *
 * Version: 1.1 (Feb 13 2012)
 */

(function($){ 
	$.fn.extend({ 
		tag: function() { 
			
			//Set the default options
			var defaults = {
				width: 400,
				height: 90,
				inputName: 'tags',
				key: ['enter', 'space', 'comma'],
				clickRemove: true
			};
			
			//Get the options
			var attr = arguments[0] || {};
			
			//Set the defaults if the options are undefined
			if(typeof(attr.width) === "undefined") { attr.width = defaults.width; }
			if(typeof(attr.height) === "undefined") { attr.height = defaults.height; }
			if(typeof(attr.inputName) === "undefined") { attr.inputName = defaults.inputName; }
			if(typeof(attr.key) === "undefined") { attr.key = defaults.key; }
			if(typeof(attr.clickRemove) === "undefined") { attr.clickRemove = defaults.clickRemove; }
			
			
			//Loop through each
			this.each(function(){
				
				//Cache the element
				var $this = $(this);
				
				//Add the tag class
				$this
					.addClass('tag_form')
					.addClass('tag_form_tags');
				
				if(attr.clickRemove) {
					$this.addClass('tag_form_click_remove');
				}

				if($.inArray('comma', attr.key) < 0) {
					$this.addClass('tag_form_prevent_comma_removal');
				}
				
				//Set the width and height
				$this.css({
					width: attr.width,
					height: attr.height
				});
				
				//Add textbox
				$('<input type="text" value="" name="add_tag" placeholder="Add tag" class="new_tag_input" onkeydown="if(event.keyCode == 13) { return false; }" />')
				
					//Add focus class when focused upon
					.focus(function(){ $this.addClass('focus') })
					
					//Remove focus class when blurred
					.blur(function(){ $this.removeClass('focus') })
					
					//When a key is pressed
					.keydown(function(e){
						
						//Get the keycode, input element and value
						var key = e.which,
							box = $(this),
							val = box.val();
						
						//Backspace
						if(key == 8) {
							
							//If the textbox is empty, remove the last tag
							if(val.length == 0) {
								$this.removeTag();
							}
							
						}
						
					})
					
					//When a key goes up
					.keyup(function(e){
						
						//Get the keycode, input element and value
						var key = e.which,
							box = $(this),
							val = box.val(),
							add = false;
						
						//Check for comma
						if(key === 188 && $.inArray('comma', attr.key) >= 0) {
							add = true;
						}

						//Check for enter
						if(key === 13 && $.inArray('enter', attr.key) >= 0) {
							add = true;
						}

						//Check for space
						if(key === 32 && $.inArray('space', attr.key) >= 0) {
							add = true;
						}
						
						//Comma or Enter
						if(add) {
							
							//Add tag
							$this.addTag(val);
							
							//Clear the textbox
							box.val('');
							
						}
						
					})
					
					//Append textbox to the tags div
					.appendTo($this);
				
				
				//Focus on the textbox when clicked upon
				$this.click(function(){
					$this.children('.new_tag_input').focus();
				});
				
				//Add textbox containing all the tags and give it an empty serialized array as value
				$('<input type="hidden" value="a:0:{}" class="tags_array" name="'+attr.inputName+'" />').appendTo($this);
				
			});
			
			//Return for linking
			return this;
		},
		
		addTag: function(value) {
			
			var $this = $(this);

			//If allowed to remove commas
			if($this.hasClass('tag_form_prevent_comma_removal') === null || $this.hasClass('tag_form_prevent_comma_removal') === false) {

				//Remove all the commas
				value = value.replace(/,/g, '');

			}
			
			//Just return when the value is empty
			if(value.length === 0 || value === ',' || value === ' ') {
				return;
			}
			
			//Remove spaces at start and ending
			value = value.replace(/^\s+|\s+$/g,"");
			
			//Create new tag
			var $tag = $('<div class="tag">'+value+'</div>');

			if($this.hasClass('tag_form_click_remove')) {

				//When tag clicked
				$tag.click(function(){

					//Remove tag
					//$(this).remove();

					$(this).animate({
						opacity: 0
					}, 200, function() {
						$(this).animate({
							width: 0,
							'padding-left': 0,
							'padding-right': 0,
							'min-width': 0
						}, 200, function() {
							$(this).remove();
							$this.updateTagsArray();
						});
					});

				});

			}

			//Insert the tag
			$tag.insertBefore($this.children('.new_tag_input'));
			
			//Update the serialized array
			$this.updateTagsArray();
			
			//Return for linking
			return $this;
		},
		
		removeTag: function() {
			
			var $this = $(this);
			
			//Remove the last tag
			$this.children('.tag:last').remove();

			//Update array
			$this.updateTagsArray();
			
			//Return for linking
			return $this;
			
		},
		
		updateTagsArray: function() {
			
			var $this = $(this);
			
			//Create empty array
			var tags = [];
			
			//Loop through each tag
			$this.children('.tag').each(function(){
				
				//Add the value of the tag to the array
				tags.push($(this).html());
				
			});
			
			//Update the value of the input with the serialized array
			$this.children('.tags_array').val((serialize_javascript_array(tags)));
			
			//Return for linking
			return $(this);
			
		}
		
	});
	
	function serialize_javascript_array (a) {
		return JSON.stringify(a);
		
		// Original code not helpful as we're using Ruby on Rails rather than PHP
		
//		var a_php = "",
//			total = 0;
//		
//		for (var key in a) {
//			++ total;
//			a_php = a_php + "s:" + String(key).length + ":\"" + String(key) + "\";s:" + String(a[key]).length + ":\"" + String(a[key]) + "\";";
//		}
//		a_php = "a:" + total + ":{" + a_php + "}";
//		return a_php;
	}
	
})(jQuery);
