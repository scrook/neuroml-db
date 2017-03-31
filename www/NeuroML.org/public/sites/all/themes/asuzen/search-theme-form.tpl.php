<!-- Template for ASU scoped search module. -->
<? include('httpProtocol.php'); ?>
<div>
	<label class="hidden" for="asu_search">SEARCH</label>
  <input type="text" name="search_theme_form_keys" size="32" value="<?php print variable_get('text_for_box', 'Search'); ?>" id="gc_search" class="asu_search_box" onfocus="if (this.defaultValue && this.value == this.defaultValue) { this.value = ''; }" />
	  <fieldset class="search_range">
		<legend>Search Range:</legend>
	  <label for="site"> <input type="radio" checked="checked" value="selected" id="gc" name="search-param" class="searchparam" /> <?php print variable_get('default_search_label','This site'); ?></label></li>
    <label for="directory"><input type="radio" id="asu" class="searchparam" name="search-param" /> ASU</label></li>
		</fieldset>
	<input type="image" name="op" src="<?=$httpProtocol?>://www.asu.edu/asuthemes/2.0/images/asu_magglass_goldbg.gif" value="Search" alt="Search" title="search" class="asu_search_button" />
		<input type="hidden" name="form_id" id="edit-search-theme-form" value="search_theme_form" />
		<input type="hidden" name="form_token" id="a-unique-id" value="<?php print drupal_get_token('search_theme_form'); ?>" />
		<input name="sort" value="date:D:L:d1" type="hidden" />
		<input name="output" value="xml_no_dtd" type="hidden" />
		<input name="ie" value="UTF-8" type="hidden" />
		<input name="oe" value="UTF-8" type="hidden" />
		<input name="client" value="asu_frontend" type="hidden" />
		<input name="proxystylesheet" value="asu_frontend" type="hidden" />
		<input name="site" value="default_collection" type="hidden" />
		<input name="searchsource" value="http://www.asu.edu/search/" type="hidden" />
</div>

<script>
// Scoped Search functions
var themeroot = "<?php print base_path() . path_to_theme(); ?>";

$(document).ready(function() {
	
	$(".searchparam").click(function(){ 
		var id = this.id; 
		replaceForm(id); 
	});

	function replaceForm(formData){
		var x = $('#asu_search_module');
		var y = '';

		if(formData=="gc") {
			y+= '<form action="/search/node" method="post" id="search-theme-form">';
			y+= '<div>';
			y+= '<div>';
			y+= '<label class="hidden" for="asu_search"><strong>SEARCH</strong></label>';
			y+= '<input type="text" name="search_theme_form_keys" size="32" value="<?php print variable_get('text_for_box', 'Search'); ?>" id="gc_search" class="asu_search_box" onfocus="if (this.defaultValue && this.value == this.defaultValue) { this.value = \'\'; }" />';
			y+= '	<fieldset class="search_range">';
			y+= '	<legend>Search Range:</legend>';
			y+= '	<label for="site"><input type="radio" checked="checked" value="selected" id="gc" name="search-param" class="searchparam" /> <?php print variable_get('default_search_label', 'This site'); ?></label>';
			y+= '	<label for="directory"><input type="radio" id="asu" name="search-param" class="searchparam" /> ASU</label>';
			y+= '	</fieldset>';
			y+= '<input type="image" name="op" src="<?=$httpProtocol?>://www.asu.edu/asuthemes/2.0/images/asu_magglass_goldbg.gif" value="Search" alt="Search" title="search" class="asu_search_button" />';
			y+= '	<input type="hidden" name="form_id" id="edit-search-theme-form" value="search_theme_form" />';
			y+= '	<input type="hidden" name="form_token" id="a-unique-id" value="<?php print drupal_get_token('search_theme_form'); ?>" />';
			y+= '</div>';
			y+= '</div></form>';
		} else { // ASU Search
			y+= '<form action="http://search.asu.edu/search" method="get" name="gs">';
			y+= '<div>';
			y+= '<div>';
			y+= '<label for="asu_search" class="hidden"><strong>SEARCH</strong></label>';
			y+= '<input type="text" name="q" size="32" value="Search" id="asu_search" class="asu_search_box" onfocus="if (this.defaultValue && this.value == this.defaultValue) { this.value = \'\'; }" />';
			y+= '	<fieldset class="search_range">';
			y+= '	<legend>Search Range:</legend>';
			y+= '	<label for="site"><input type="radio" value="selected" id="gc" name="search-param" class="searchparam" /> <?php print variable_get('default_search_label', 'This site'); ?></label>';
			y+= '	<label for="directory"><input type="radio" checked="checked" id="asu" name="search-param" class="searchparam" /> ASU</label>';
			y+= '	</fieldset>';	
			y+= '<input type="image" name="op" src="<?=$httpProtocol?>://www.asu.edu/asuthemes/2.0/images/asu_magglass_goldbg.gif" value="Search" alt="Search" title="search" class="asu_search_button" />';
			y+= '	<input name="sort" value="date:D:L:d1" type="hidden" />';
			y+= '	<input name="output" value="xml_no_dtd" type="hidden" />';
			y+= '	<input name="ie" value="UTF-8" type="hidden" />';
			y+= '	<input name="oe" value="UTF-8" type="hidden" />';
			y+= '	<input name="client" value="asu_frontend" type="hidden" />';
			y+= '	<input name="proxystylesheet" value="asu_frontend" type="hidden" />';
			y+= '	<input name="site" value="default_collection" type="hidden" />';
			y+= '	<input name="searchsource" value="http://www.asu.edu/search/" type="hidden" />';
			y+= '</div>';
			y+= '</div></form>';
		}
		x.html(y);
		$(".searchparam").click(function(){ 
			var id = this.id; 
			replaceForm(id); 
		});
	}
});

</script>

