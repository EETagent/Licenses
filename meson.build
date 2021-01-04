project('com.github.eetagent.Licenses', ['c', 'vala'], 
          version: '0.9.0',
    meson_version: '>= 0.50.0',
  default_options: [ 'warning_level=2',
                   ],
)

app_id = meson.project_name() 
app_install_prefix = get_option('prefix')
app_binary = app_id

i18n = import('i18n')
gnome = import('gnome')

vala_lint = find_program('io.elementary.vala-lint', required : false)
if vala_lint.found()
    test (
        'Vala lint',
        vala_lint,
        args: ['-d', join_paths(meson.source_root(), 'src')]
    )
endif

subdir('data')
subdir('src')
subdir('po')

meson.add_install_script('build-aux/meson/postinstall.py')