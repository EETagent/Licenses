project('com.github.eetagent.Licenses', ['c', 'vala'], 
          version: '0.1.0',
    meson_version: '>= 0.50.0',
  default_options: [ 'warning_level=2',
                   ],
)

app_id = meson.project_name() 
app_install_prefix = get_option('prefix')
app_binary = app_id

i18n = import('i18n')
gnome = import('gnome')


subdir('data')
subdir('src')
subdir('po')

meson.add_install_script('build-aux/meson/postinstall.py')