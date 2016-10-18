#!/bin/bash
cd $WORKDIR

echo ''  
echo '#################################'
echo '#                               #'
echo '#      Start Writing Config     #'
echo '#                               #'
echo '#################################'
echo ''  

if [ ! -f sites/default/settings.php ]; then
  echo "using default settings as template"
  cp sites/default/default.settings.php sites/default/settings.php
fi

if [ -f sites/default/only_automatic_config ]; then
  echo "reverting interim config"
  cp sites/default/default.settings.php sites/default/settings.php
  rm sites/default/only_automatic_config
fi

if [ -f sites/default/local_config_available ]; then
  echo "switch config back"
  mv sites/default/settings.php.original sites/default/settings.php
  rm sites/default/local_config_available
fi

echo '#################################' >> sites/default/settings.php 
echo '#                               #' >> sites/default/settings.php 
echo '#   Automatic Config Section    #' >> sites/default/settings.php 
echo '#                               #' >> sites/default/settings.php 
echo '#################################' >> sites/default/settings.php 
echo ''  >> sites/default/settings.php 
echo "\$conf['environment_indicator_text'] = '$DRUPAL_ENVIRONMENT_ID';" >> sites/default/settings.php 
echo "\$conf['image_allow_insecure_derivatives'] = TRUE;" >> sites/default/settings.php 

echo '# Security '  >> sites/default/settings.php 
echo "\$conf['allow_authorize_operations'] = FALSE;" >> sites/default/settings.php 
echo "\$update_free_access = FALSE;" >> sites/default/settings.php 

echo '# Let the Server do the work'          >> sites/default/settings.php 
echo "\$conf['css_gzip_compression'] = FALSE;" >> sites/default/settings.php 
echo "\$conf['js_gzip_compression'] = FALSE;"  >> sites/default/settings.php 

# Database Config 
{ \
    echo ""; \
    echo "# Automatic Database configuration;"; \
    echo "\$databases = array ("; \
    echo "'default' =>"; \
    echo "array ("; \
    echo "        'default' =>"; \
    echo "        array ("; \
    echo "            'database' => '$MYSQL_DATABASE',"; \
    echo "            'username' => '$MYSQL_USER',"; \
    echo "            'password' => '$MYSQL_PASSWORD',"; \
    echo "            'host' => '$MYSQL_LINK',"; \
    echo "            'port' => '$MYSQL_PORT',"; \
    echo "            'driver' => 'mysql',"; \
    echo "            'prefix' => '',"; \
    echo "        ),"; \
    echo "    ),"; \
    echo ");"; \
} >> /var/www/html/sites/default/settings.php

if [ "$DRUPAL_MEMCACHE_SERVER" != 0 ]; then
# Memcache Config
    { \
        echo ''; \
        echo '# Automatic Memcache configuration'; \
        echo '$conf["cache_backends"][] = "sites/all/modules/memcache/memcache.inc";'; \
        echo '#$conf["lock_inc"] = "sites/all/modules/memcache/memcache-lock.inc";'; \
        echo '#$conf["memcache_stampede_protection"] = TRUE;'; \
        echo '$conf["cache_default_class"] = "MemCacheDrupal";'; \
        echo '$conf["cache_class_cache_form"] = "DrupalDatabaseCache";'; \
        echo '$conf["memcache_servers"] = array("'$DRUPAL_MEMCACHE_SERVER:11211'" => "default");'; \
    } >> /var/www/html/sites/default/settings.php
fi

if [ "$DRUPAL_VARNISH_SERVER" != 0 ]; then
    echo ''  >> sites/default/settings.php 
    echo "# Proxy Config"  >> sites/default/settings.php 
    echo "\$conf['reverse_proxy'] = TRUE;" >> sites/default/settings.php 
    echo "#\$conf['reverse_proxy_addresses'] = array('$DRUPAL_VARNISH_SERVER');" >> sites/default/settings.php 
    echo "\$conf['reverse_proxy_header'] = 'HTTP_X_CLUSTER_CLIENT_IP';" >> sites/default/settings.php 
fi



if [ "$DRUPAL_VARNISH_SERVER" != 0 ]; then
    echo ''  
    echo '#################################'
    echo '#                               #'
    echo '# Configure Drupal for Varnish  #'
    echo '#                               #'
    echo '#################################'
    echo ''  

    # Varnish Drush Config
    drush vset varnish_control_terminal "$DRUPAL_VARNISH_SERVER:6082"
    drush vset varnish_control_key "$DRUPAL_VARNISH_KEY"
    drush vset varnish_version "3"
    drush vset varnish_bantype "0"
    drush vset varnish_cache_clear "2"

    php -r "print json_encode(array('1','2','3','4','5'));" | drush vset --format=json expire_comment_actions -
    drush vset expire_comment_comment_page 1
    drush vset expire_comment_custom 0
    drush vset expire_comment_custom_pages ''
    drush vset expire_comment_front_page 0
    drush vset expire_comment_node_page 1
    drush vset expire_comment_node_term_pages 0
    drush vset expire_debug '0'
    php -r "print json_encode(array('1','2'));" | drush vset --format=json expire_file_actions - 
    drush vset expire_file_custom 0
    drush vset expire_file_custom_pages ''
    drush vset expire_file_file 1
    drush vset expire_file_front_page 1
    drush vset expire_include_base_url 0
    php -r "print json_encode(array(0,0,0));" | drush vset --format=json expire_menu_link_actions - 
    php -r "print json_encode(array('main-menu'=>'0','management'=>'0','navigation'=>'0','user-menu'=>'0'));" | drush vset --format=json expire_menu_link_override_menus - 
    php -r "print json_encode(array('1','2','3'));" | drush vset --format=json expire_node_actions - 
    drush vset expire_node_custom 0
    drush vset expire_node_custom_pages ''
    drush vset expire_node_front_page 1
    drush vset expire_node_node_page 1
    drush vset expire_node_term_pages 1
    drush vset expire_status '2'
    php -r "print json_encode(array('1','2',0,0));" | drush vset --format=json expire_user_actions - 
    drush vset expire_user_custom 0
    drush vset expire_user_custom_pages ''
    drush vset expire_user_front_page 0
    drush vset expire_user_term_pages 0
    drush vset expire_user_user_page 1
    drush vset page_cache_maximum_age '86400'
    drush vset page_compression 0
    drush vset "cache" 1
    drush vset block_cache 0
    drush vset cache_lifetime 300
    drush vset cache_class_cache_ctools_css 'CToolsCssCache'
    drush vset preprocess_css 1
    drush vset css_gzip_compression false
    drush vset preprocess_js 1
    drush vset js_gzip_compression false
fi

#Configure SOLR
if [ "$DRUPAL_CONFIGURE_SOLR" != 0 ]; then
    drush sql-query "REPLACE search_api_server VALUES (1,'SOLR Server (Automatic Configured)','server','Automatic SOLR configuration','search_api_solr_service','a:16:{s:9:\"clean_ids\";b:1;s:9:\"site_hash\";b:1;s:6:\"scheme\";s:4:\"http\";s:4:\"host\";s:11:\"$SOLR_LINK\";s:4:\"port\";s:4:\"8983\";s:4:\"path\";s:13:\"/solr/drupal7\";s:9:\"http_user\";s:0:\"\";s:9:\"http_pass\";s:0:\"\";s:7:\"excerpt\";i:0;s:13:\"retrieve_data\";i:0;s:14:\"highlight_data\";i:0;s:17:\"skip_schema_check\";i:0;s:12:\"solr_version\";s:0:\"\";s:11:\"http_method\";s:4:\"AUTO\";s:9:\"log_query\";i:0;s:12:\"log_response\";i:0;}',1,1,NULL);"
    drush sql-query "REPLACE search_api_index VALUES (1,'Default node index','default_node_index','An automatically created search index for indexing node data. Might be configured to specific needs.','server','node','a:6:{s:10:\"datasource\";a:1:{s:7:\"bundles\";a:0:{}}s:14:\"index_directly\";i:1;s:10:\"cron_limit\";s:2:\"50\";s:20:\"data_alter_callbacks\";a:1:{s:28:\"search_api_alter_node_access\";a:3:{s:6:\"status\";i:1;s:6:\"weight\";s:1:\"0\";s:8:\"settings\";a:0:{}}}s:10:\"processors\";a:3:{s:22:\"search_api_case_ignore\";a:3:{s:6:\"status\";i:1;s:6:\"weight\";s:1:\"0\";s:8:\"settings\";a:1:{s:7:\"strings\";i:0;}}s:22:\"search_api_html_filter\";a:3:{s:6:\"status\";i:1;s:6:\"weight\";s:2:\"10\";s:8:\"settings\";a:3:{s:5:\"title\";i:0;s:3:\"alt\";i:1;s:4:\"tags\";s:54:\"h1 = 5\nh2 = 3\nh3 = 2\nstrong = 2\nb = 2\nem = 1.5\nu = 1.5\";}}s:20:\"search_api_tokenizer\";a:3:{s:6:\"status\";i:1;s:6:\"weight\";s:2:\"20\";s:8:\"settings\";a:2:{s:6:\"spaces\";s:13:\"[^\\p{L}\\p{N}]\";s:9:\"ignorable\";s:3:\"[-]\";}}}s:6:\"fields\";a:10:{s:6:\"author\";a:2:{s:4:\"type\";s:7:\"integer\";s:11:\"entity_type\";s:4:\"user\";}s:10:\"body:value\";a:1:{s:4:\"type\";s:4:\"text\";}s:7:\"changed\";a:1:{s:4:\"type\";s:4:\"date\";}s:13:\"comment_count\";a:1:{s:4:\"type\";s:7:\"integer\";}s:7:\"created\";a:1:{s:4:\"type\";s:4:\"date\";}s:7:\"promote\";a:1:{s:4:\"type\";s:7:\"boolean\";}s:19:\"search_api_language\";a:1:{s:4:\"type\";s:6:\"string\";}s:6:\"sticky\";a:1:{s:4:\"type\";s:7:\"boolean\";}s:5:\"title\";a:2:{s:4:\"type\";s:4:\"text\";s:5:\"boost\";s:3:\"5.0\";}s:4:\"type\";a:1:{s:4:\"type\";s:6:\"string\";}}}',1,0,1,NULL);"
fi

drush vset composer_manager_vendor_dir /var/www/html/sites/all/libraries/vendor/
drush vset composer_manager_file_dir /var/www/html/sites/all/libraries/
