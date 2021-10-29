project('com.github.casasfernando.wingpanel-indicator-sysmon', 'vala', 'c')

gnome = import('gnome')
i18n = import('i18n')

add_project_arguments(['--vapidir', join_paths(meson.current_source_dir(), 'vapi')], language: 'vala')
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language:'c')

# common dirs
prefix = get_option('prefix')
datadir = join_paths(prefix, get_option('datadir'))
libdir = join_paths(prefix, get_option('libdir'))
icondir = join_paths(datadir, 'icons', 'hicolor')

# deps
wingpanel = dependency('wingpanel-2.0')

icons_gresource = gnome.compile_resources(
    'gresource_icons',
    'data/icons/icons.indicator.gresource.xml',
    source_dir: 'data/icons',
    c_name: 'as'
)

config_data = configuration_data()
config_data.set_quoted('GETTEXT_PACKAGE', meson.project_name())

configure_file(output: 'config.h', configuration: config_data)
config_h_dir = include_directories('.')

c_args = [
  '-include', 'config.h',
  '-w',
]

executable(
    meson.project_name(),
    icons_gresource,
    'src/Application.vala',
    'src/MainWindow.vala',
    'src/Widgets/Toggles.vala',
    c_args: c_args,
    dependencies: [
        dependency('gee-0.8'),
        dependency('glib-2.0'),
        dependency('granite'),
        dependency('gtk+-3.0'),
        wingpanel,
        meson.get_compiler('c').find_library('m', required : false),
        meson.get_compiler('vala').find_library('posix')
    ],
    vala_args: [
        '--vapidir=' + meson.source_root() + '/vapi/',
    ],
    install: true
)

shared_module(
    'wingpanel-indicator-sysmon',
    'src/Indicator.vala',
    'src/Widgets/DiskWidget.vala',
    'src/Widgets/DisplayWidget.vala',
    'src/Widgets/IndicatorWidget.vala',
    'src/Widgets/NetworkWidget.vala',
    'src/Widgets/PopoverWidget.vala',
    'src/Widgets/PopoverWidgetRow.vala',
    'src/Services/Cpu.vala',
    'src/Services/CpuTemperature.vala',
    'src/Services/Disk.vala',
    'src/Services/Memory.vala',
    'src/Services/Network.vala',
    'src/Services/System.vala',
    'src/Services/Utils.vala',
    icons_gresource,
    c_args: c_args,
    dependencies: [
        dependency('gdk-x11-3.0'),
        dependency('gee-0.8'),
        dependency('glib-2.0'),
        dependency('granite'),
        dependency('gtk+-3.0'),
        dependency('libgtop-2.0'),
        wingpanel,
    ],
    install: true,
    install_dir : wingpanel.get_pkgconfig_variable('indicatorsdir', define_variable: ['libdir', libdir]),
)

subdir('data')
subdir('po')
meson.add_install_script('meson/post_install.py')
