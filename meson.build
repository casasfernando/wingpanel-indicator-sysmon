# Project name, programming language and version
project (
    'com.github.casasfernando.wingpanel-indicator-sysmon',
    'c', 'vala',
    version: '0.6.5'
)

# GNOME module
gnome = import ('gnome')

# Translation module
i18n = import ('i18n')

# Project arguments
add_project_arguments (
    '-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name ()),
    language: 'c'
)

add_project_arguments (
    ['--vapidir', join_paths (meson.current_source_dir (), 'vapi')],
    language: 'vala'
)

# Listing dependencies
wingpanel = dependency ('wingpanel-2.0')

common_dependencies = [
    dependency ('granite'),
    dependency ('gtk+-3.0'),
    dependency ('gee-0.8'),
    dependency ('glib-2.0'),
    wingpanel
]

executable_dependencies = [
    common_dependencies,
    meson.get_compiler ('c').find_library ('m', required : false),
    meson.get_compiler ('vala').find_library ('posix')
]

indicator_dependencies = [
    common_dependencies,
    dependency ('gdk-x11-3.0'),
    dependency ('libgtop-2.0')
]

# Compiling resources
asresources = gnome.compile_resources (
    'as-resources',
    join_paths ('data', meson.project_name ()) + '.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

# Config
config_data = configuration_data ()
config_data.set_quoted ('GETTEXT_PACKAGE', meson.project_name ())

configure_file (output: 'config.h', configuration: config_data)

c_args = [
  '-include', 'config.h',
  '-w',
]

subdir ('src')

# Define executable
executable (
    meson.project_name (),
    executable_sources,
    asresources,
    c_args: c_args,
    dependencies: executable_dependencies,
    install: true
)

# Define indicator
shared_module (
    'wingpanel-indicator-sysmon',
    indicator_sources,
    asresources,
    c_args: c_args,
    dependencies: indicator_dependencies,
    install: true,
    install_dir : wingpanel.get_pkgconfig_variable('indicatorsdir', define_variable: ['libdir', join_paths (get_option ('prefix'), get_option ('libdir'))]),
)


subdir ('data')
subdir ('po')

meson.add_install_script ('meson/post_install.py')
