licenses_sources = [
  'Main.vala',
  'Licenses.vala',
  'Widgets/Window.vala',
  'Widgets/TextView.vala',
  'Granite/ModeSwitch.vala',
  app_licenses_txt_resources,

]

licenses_deps = [
  dependency('gio-2.0', version: '>= 2.50'),
  dependency('gtk4', version: '>= 4.00'),
]

executable(app_binary, licenses_sources,
  vala_args: '--target-glib=2.50',  dependencies: licenses_deps,
  install: true,
)
