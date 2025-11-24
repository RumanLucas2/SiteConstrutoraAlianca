<?php
/*
Plugin Name: Contact Form
Description: An easy way to create a contact form for your Wordpress site.
Version: 1.2
Author: Jeff Bulllins
Author URI: http://www.thinklandingpages.com
*/

class ThinkContactForm{

    private $plugin_path;
    private $plugin_url;
    private $l10n;
    private $thinkContactForm;

    function __construct() 
    {	
        $this->plugin_path = plugin_dir_path( __FILE__ );
        $this->plugin_url = plugin_dir_url( __FILE__ );
        $this->l10n = 'wp-settings-framework';
        add_action( 'admin_menu', array(&$this, 'admin_menu'), 99 );
        
        // Include and create a new WordPressSettingsFramework
        require_once( $this->plugin_path .'wp-settings-framework.php' );
        $settings_file = $this->plugin_path .'settings/settings-general.php';
        
        $this->thinkContactForm = new WordPressSettingsFramework( $settings_file, '_think_contact', $this->get_think_contactsettings() );
        // Add an optional settings validation filter (recommended)
        //add_filter( $this->thinkContactForm->get_option_group() .'_settings_validate', array(&$this, 'validate_settings') );
        
        add_action( 'init', array(&$this, 'think_contact_register_shortcodes'));
        //for tinymce button add_action('init', array(&$this, 'add_think_contact_icon'));
        add_action( 'wp_enqueue_scripts', array(&$this,'think_contact_stylesheet' ));
       
    }
    
    function admin_menu()
    {
        $page_hook = add_menu_page( __( 'Contact Form', $this->l10n ), __( 'Contact Form', $this->l10n ), 'update_core', 'Contact Form', array(&$this, 'settings_page') );
        add_submenu_page( 'Contact Form', __( 'Settings', $this->l10n ), __( 'Settings', $this->l10n ), 'update_core', 'Contact Form', array(&$this, 'settings_page') );
    }
    
    function settings_page()
	{
	    // Your settings page
	    
	    ?>
		<div class="wrap">
			<div id="icon-options-general" class="icon32"></div>
			<h2>Contact Form</h2>
			<?php
			$this->thinkContactForm->settings(); 
			?>
			<a href="http://www.thinklandingpages.com/landingpage/wordpress-contact-form-plugin/">Upgrade to the Pro Version - add captcha for Free</a><br >
			<p>What's in the Pro Version
			<ul>
				<li>Unlimited custom fields</li>
				<li>Professional templates</li>
				<li>Submit to an email address, Aweber, Mailchimp, where ever you want</li>
				<li>Custom backgrounds</li>
				<li>Professional skins</li>
				<li>Custom color schemes</li>
				<li>Place anywhere on your site</li>
				<li>Captcha</li>
				<li>And much more...</li>
			</ul>
			
			<h3>Contact forms available in this version</h3>
			<p>Create this contact form by placing the shortcode tag <code>[think_contact/]</code> on your page or post</p>	
			<?php $this->think_contact_stylesheet(); ?>			
			
			<?php 
			//$this->think_contact_shortcode();
			echo do_shortcode('[think_contact/]');
			// Output your settings form
			//$this->thinkContactForm->settings(); 
			?>
			<a href="http://www.thinklandingpages.com/landingpage/wordpress-contact-form-plugin/">Upgrade to the Pro Version - add captcha for Free</a><br >
			
		</div>
		<?php
		
		// Get settings
		//$settings = thinkContactForm_get_settings( $this->plugin_path .'settings/settings-general.php' );
		//echo '<pre>'.print_r($settings,true).'</pre>';
		
		// Get individual setting
		//$setting = thinkContactForm_get_setting( thinkContactForm_get_option_group( $this->plugin_path .'settings/settings-general.php' ), 'general', 'text' );
		//var_dump($setting);
	}
	
	function validate_settings( $input )
	{
	    // Do your settings validation here
	    // Same as $sanitize_callback from http://codex.wordpress.org/Function_Reference/register_setting
    	return $input;
	}
	
	
        
        function get_think_contactsettings(){
        	$wpsf_settings[] = array(
		    'section_id' => 'general',
		    'section_title' => 'Contact Form Settings',
		    //'section_description' => 'Some intro description about this section.',
		    'section_order' => 5,
		    'fields' => array(
		      		 array(
			            'id' => 'to_email',
			            'title' => 'To Email',
			            'desc' => 'Set the email address you want your forms submitted to.',
			            'type' => 'text',
			            'std' => '',
			        ),        
		        )
		        
        
    );
    return $wpsf_settings;
        }
        
        function think_contact_shortcode( $atts ) {
		extract( shortcode_atts( array(
			'color' => 'gray',
			'text' => 'Submit',
			'url' => '',
			'font_size' => '',
		), $atts ) );
		$my_option_string = $this->thinkContactForm->get_option_group().'_settings';
			$my_options = get_option($my_option_string);
			
			$the_option = $this->thinkContactForm->get_option_group() .'_general_to_email';
		
		ob_start();
		//echo '<a href="'.$url.'">';
		//echo '<span class="'.$color.'_think_contact" style="font-size:'.$font_size.'">'.$text.'</span></a>';
		echo '<div style="border:1px solid black;width:300px">';
		echo '<form id="cf-email" action="'. plugin_dir_url(__FILE__).'emailSubmit.php" method="post"><br />';
		echo 'Name:<br /><input type="text" name="name" size="30"><br />';
		echo 'Email:<br /><input type="text" name="email" size="30"><br />';
		//echo 'Phone:<br /><input type="text" name="phone" size="30"><br />';
		echo 'Subject:<br /><input type="text" name="subject" size="30"><br />';
		echo 'Message:<br /><textarea name="message" rows="10" cols="20"></textarea><br />';
		echo '<input type="hidden" name="to_email" value="'.$my_options[$the_option].'">';
		$nonce= wp_create_nonce('my-nonce');
		wp_nonce_field('my-nonce');
		apply_filters('cf_add_to_form_filter', null);
		echo '<input type="submit" value="Submit"><br />';
		echo '</form><br />';
		echo '</div>';
		
		return ob_get_clean();
	}
	function think_contact_register_shortcodes(){
		add_shortcode( 'think_contact', array(&$this, 'think_contact_shortcode') );
		
	}
	
	function think_contact_stylesheet() {
        	wp_register_style( 'think-button-style', plugin_dir_url(__FILE__).'css/button.css' );
        	wp_enqueue_style( 'think-button-style' );
    	}
/* for think button tinymce icon button   	
    	function add_think_contact_icon() {
	   if ( ! current_user_can('edit_posts') && ! current_user_can('edit_pages') )
	     return;
	   if ( get_user_option('rich_editing') == 'true') {
	     add_filter('mce_external_plugins', array(&$this,'add_think_contact_icon_tinymce_plugin'));
	     add_filter('mce_buttons',  array(&$this,'register_think_contact_icon'));
	   }
	}
	
	function register_think_contact_icon($buttons) {
	   array_push($buttons, "|", "thinkbutton");
	   return $buttons;
	}
	
	function add_think_contact_icon_tinymce_plugin($plugin_array) {
	   $plugin_array['thinkbutton'] = plugin_dir_url(__FILE__).'/js/think_contact_icon.js';
	   return $plugin_array;
	}

*/

	

}
new ThinkContactForm();

?>