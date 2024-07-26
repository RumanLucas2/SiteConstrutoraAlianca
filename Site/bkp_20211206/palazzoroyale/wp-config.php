<?php
/**
 * The base configurations of the WordPress.
 *
 * This file has the following configurations: MySQL settings, Table Prefix,
 * Secret Keys, and ABSPATH. You can find more information by visiting
 * {@link https://codex.wordpress.org/Editing_wp-config.php Editing wp-config.php}
 * Codex page. You can get the MySQL settings from your web host.
 *
 * This file is used by the wp-config.php creation script during the
 * installation. You don't have to use the web site, you can just copy this file
 * to "wp-config.php" and fill in the values.
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'crumanjr_wp1');

/** MySQL database username */
define('DB_USER', 'crumanjr_wp1');

/** MySQL database password */
define('DB_PASSWORD', 'J^McEujzd303@&9');

/** MySQL hostname */
define('DB_HOST', 'localhost');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'Fykrtzhal2iGzEraeXzq85vbJRqzzg1kyia6AU7lseDj6LUaY7m1QtmlyB4bLdOj');
define('SECURE_AUTH_KEY',  'zaEiQvGJNevAQ2w8IMt7NKELutE8m0uQiRDxtjNXFlmsoyeCYMLaYj3Jgtq3g579');
define('LOGGED_IN_KEY',    'DAowix9L0LpWVAjv3wdABhogVcwv99nJYHuwdiqINApt4zXM49kWfcH9LOsTtCRu');
define('NONCE_KEY',        'cm3yvHrdlrPPhkJH56LK3bBOXF8N2j1hJ1OMnIVMbe9J5zFF1PmecO98tIT9lPKc');
define('AUTH_SALT',        'fuwQCyAz4mQjen12ILWi2kCNIgfYYaB7M3IqCtuyZCQHdkMGzDBwn5pRQOOkH1Tf');
define('SECURE_AUTH_SALT', 'kdqjkeFt4hRrF8aPocl7VQKEvB01CiZ9oggicXcl1Pe9QqKbCVOdlFOA6cWjbRbL');
define('LOGGED_IN_SALT',   '6XT75xyv0pdUiiROVKsWZuIxLnwAJ5L3uMuf7taE75XEG9ym4xIki0uVnP8W6FuJ');
define('NONCE_SALT',       'xvnOw1jR1u3fjopY1w3eSgTYGOmUjUgeaI55U5OMiAiIJkRaL6F6ukhFKmenv8HQ');

/**
 * Other customizations.
 */
define('FS_METHOD','direct');define('FS_CHMOD_DIR',0755);define('FS_CHMOD_FILE',0644);
define('WP_TEMP_DIR',dirname(__FILE__).'/wp-content/uploads');

/**
 * Turn off automatic updates since these are managed upstream.
 */
define('AUTOMATIC_UPDATER_DISABLED', true);


/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each a unique
 * prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
