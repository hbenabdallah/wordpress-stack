<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'totipot' );

/** MySQL database username */
define( 'DB_USER', 'root' );

/** MySQL database password */
define( 'DB_PASSWORD', 'root' );

/** MySQL hostname */
define( 'DB_HOST', 'mysql' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         'qv;(JL=F^ A]BH8]&(alWd%vcZkwsa&$GM=K7:Yb=P=+VzF^9xk?r<6x<&`:t};L' );
define( 'SECURE_AUTH_KEY',  '2Cp~!B>CfT~VncGg T^bAXSy*j|mwb+0qoW~cC$n~L0PMd):)l*{dMyaf6p&H)$R' );
define( 'LOGGED_IN_KEY',    ':OvjG yxF?!HnWK(KtzDD1Lt56/j5@haE2V8M@b,)7{]Z}D>WW.fszt+0$H<p<S|' );
define( 'NONCE_KEY',        '-m7JX{nPbT7n4]T&j=n]+3}@)ZbyAsug%sN)Z6^%.+Mb~,HpLE1*F{%uhSA?T`w+' );
define( 'AUTH_SALT',        '*xKMK{[4dg_eBAUdYk}A[g)X/Spk5$.dc^0Z^N7KVL+D<Dj~~~C;(6BTXdo;WDgl' );
define( 'SECURE_AUTH_SALT', 'AaUhJQO6$RS:ApvV&22?a~>=>?`et5+0/Ll2R-Zewr7;q6y)+art28AJn*X9dc:~' );
define( 'LOGGED_IN_SALT',   '[:.V0x=-Hb^xm`m*^0^tOWs[1dmBc)c:#Ym.j8Gy6L(B:87A}Gw x;aD#gmD#~@p' );
define( 'NONCE_SALT',       '.qEhb7;x,c;I{Y;in:]*BiaIs/j&?e$bXzG}m$zbPJy)Vdp_-Z+aa!g8M?~ooe `' );

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
