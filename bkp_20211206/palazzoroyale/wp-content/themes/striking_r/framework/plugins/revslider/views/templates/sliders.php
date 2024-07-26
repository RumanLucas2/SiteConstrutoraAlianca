<?php
	global $revSliderAsTheme;
	
	$exampleID = '"slider1"';
    $dir = plugin_dir_path(__FILE__).'../../';
	if(!empty($arrSliders))
		$exampleID = '"'.$arrSliders[0]->getAlias().'"';
		
	$outputTemplates = false;
	$latest_version = get_option('revslider-latest-version', GlobalsRevSlider::SLIDER_REVISION);
   if(version_compare($latest_version, GlobalsRevSlider::SLIDER_REVISION, '>')){
    //neue version existiert
   }else{
    //up to date
   }

	
?>
	
	<div class='wrap'>
		<div class="clear_both"></div> 
		<div class="title_line" style="margin-bottom:10px">
			<div id="icon-options-general" class="icon32"></div>					
			<a href="<?php echo GlobalsRevSlider::LINK_HELP_SLIDERS?>" class="button-secondary float_right mtop_10 mleft_10" target="_blank"><?php _e("Help",REVSLIDER_TEXTDOMAIN)?></a>			
			
			<a id="button_general_settings" class="button-secondary float_right mtop_10"><?php _e("Global Settings",REVSLIDER_TEXTDOMAIN)?></a>			
		</div>
		
		<div class="clear_both"></div> 
		
		<div class="title_line nobgnopd">
			<div class="view_title">
				<?php _e("Revolution Sliders",REVSLIDER_TEXTDOMAIN)?>
			</div>						
		</div>

		<?php
		$no_sliders = false;
		if(empty($arrSliders)){
			_e("No Sliders Found",REVSLIDER_TEXTDOMAIN);
			$no_sliders = true;
			?>
			<br><?php
		}
		
		require self::getPathTemplate("sliders_list");
		
		?>
	
		
		<!-- 
		THE SLIDER TEMPLATES
		-->
		<div style="width:100%;height:17px"></div>
		<div class="title_line nobgnopd"><div class="view_title"><?php _e("Revolution Slider Templates",REVSLIDER_TEXTDOMAIN)?></div></div>
		<?php
		$no_sliders = false;
		if(empty($arrSlidersTemplates)){
			_e("No Template Sliders Found",REVSLIDER_TEXTDOMAIN);
			$no_sliders = true;
			?><br><?php
		}
		
		$outputTemplates = true;
		require self::getPathTemplate("sliders_list");	 		
		?>		
	</div>
	
	<!-- Import slider dialog -->
	<div id="dialog_import_slider" title="<?php _e("Import Slider",REVSLIDER_TEXTDOMAIN)?>" class="dialog_import_slider" style="display:none">
		<form action="<?php echo UniteBaseClassRev::$url_ajax?>" enctype="multipart/form-data" method="post">
		    <br>
		    <input type="hidden" name="action" value="revslider_ajax_action">
		    <input type="hidden" name="client_action" value="import_slider_slidersview">
		    <input type="hidden" name="nonce" value="<?php echo wp_create_nonce("revslider_actions"); ?>">
		    <?php _e("Choose the import file",REVSLIDER_TEXTDOMAIN)?>:   
		    <br>
			<input type="file" size="60" name="import_file" class="input_import_slider">
			<br><br>
			<span style="font-weight: 700;"><?php _e("Note: custom styles will be updated if they exist!",REVSLIDER_TEXTDOMAIN)?></span><br><br>
			<table>
				<tr>
					<td><?php _e("Custom Animations:",REVSLIDER_TEXTDOMAIN)?></td>
					<td><input type="radio" name="update_animations" value="true" checked="checked"> <?php _e("overwrite",REVSLIDER_TEXTDOMAIN)?></td>
					<td><input type="radio" name="update_animations" value="false"> <?php _e("append",REVSLIDER_TEXTDOMAIN)?></td>
				</tr>
				<tr>
					<td><?php _e("Static Styles:",REVSLIDER_TEXTDOMAIN)?></td>
					<td><input type="radio" name="update_static_captions" value="true" checked="checked"> <?php _e("overwrite",REVSLIDER_TEXTDOMAIN)?></td>
					<td><input type="radio" name="update_static_captions" value="false"> <?php _e("append",REVSLIDER_TEXTDOMAIN)?></td>
				</tr>
			</table>
			<br><br>
			<input type="submit" class='button-primary' value="<?php _e("Import Slider",REVSLIDER_TEXTDOMAIN)?>">
		</form>		
		
	</div>
	
	<script type="text/javascript">
		jQuery(document).ready(function(){
			RevSliderAdmin.initSlidersListView();
			RevSliderAdmin.initNewsletterRoutine();
			
			jQuery('#benefitsbutton').hover(function() {
				jQuery('#benefitscontent').slideDown(200);
			}, function() {
				jQuery('#benefitscontent').slideUp(200);				
			});
			
			jQuery('#why-subscribe').hover(function() {
				jQuery('#why-subscribe-wrapper').slideDown(200);
			}, function() {
				jQuery('#why-subscribe-wrapper').slideUp(200);				
			});
			
			jQuery('#tp-validation-box').click(function() {
				jQuery(this).css({cursor:"default"});
				if (jQuery('#rs-validation-wrapper').css('display')=="none") {
					jQuery('#tp-before-validation').hide();
					jQuery('#rs-validation-wrapper').slideDown(200);
				}
			});
		});
	</script>
	